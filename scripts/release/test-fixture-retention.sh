#!/usr/bin/env bash
set -euo pipefail
export RELEASE_DELIVERY=direct

# Exercise real consumer fixtures through controlled executable failures.
# Keep intentional failures under the native CI artifact owner, including inputs.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
mkdir -p "$root/target/evidence/native-ci"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
evidence="$(fixture_create "$root/target/evidence/native-ci/fixture-retention.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    fixture_completion_status "$status" "$fixture_complete" || status=$?
    if [[ "$status" != 0 ]]; then
        echo "fixture retention check failed; evidence retained: $evidence" >&2
    fi
    exit "$status"
}
trap cleanup EXIT
# shellcheck source=scripts/ci/fixture-retention-probes.sh
source "$root/scripts/ci/fixture-retention-probes.sh"
real_bash="$(command -v bash)"
real_cargo="$(command -v cargo)"
export FIXTURE_RETENTION_REAL_CARGO="$real_cargo"
export FIXTURE_RETENTION_REAL_BASH="$real_bash"
FIXTURE_RETENTION_REAL_MAKE="$(command -v make)"
FIXTURE_RETENTION_REAL_CMP="$(command -v cmp)"
export FIXTURE_RETENTION_REAL_MAKE FIXTURE_RETENTION_REAL_CMP
FIXTURE_RETENTION_REAL_YQ="${YQ:-$(command -v yq)}"
export FIXTURE_RETENTION_REAL_YQ
git -C "$root" rev-parse HEAD > "$evidence/source-commit.txt"

for kind in standard metadata hook; do
    case "$kind" in
        standard) script=scripts/release/test-standard-release.sh; prefix=standard-release-entry; child=bash ;;
        metadata) script=scripts/release/test-metadata.sh; prefix=metrics-metadata-test; child=cargo ;;
        hook) script=scripts/dev/test-format-hook.sh; prefix=metrics-format-hook; child=bash ;;
    esac
    cp "$root/$script" "$evidence/$kind-source.sh"
    scenarios=(success child)
    if [[ "$kind" == metadata ]]; then scenarios+=(assertion); fi
    if [[ "$kind" == standard ]]; then scenarios+=(publication-child publication-assertion); fi
    if [[ "$kind" == hook ]]; then scenarios+=(formatter-version); fi
    if [[ "$kind" == metadata ]]; then scenarios+=(predicate-assertion); fi
    for scenario in "${scenarios[@]}"; do
        run="$evidence/$kind-$scenario"
        mkdir -p "$run/tmp" "$run/bin"
        if [[ "$scenario" != success ]]; then
            executable="$child"
            if [[ "$scenario" == publication-child ]]; then executable='make'; fi
            if [[ "$scenario" == *assertion ]]; then executable='cmp'; fi
            if [[ "$scenario" == formatter-version ]]; then executable=cargo; fi
            if [[ "$scenario" == predicate-assertion ]]; then executable=yq; fi
            printf '#!%s\n' "$real_bash" > "$run/bin/$executable"
            if [[ "$executable" == cargo ]]; then
                cat >> "$run/bin/$executable" <<'CARGO'
if [[ "${1:-}" != generate-lockfile && "${FIXTURE_RETENTION_SCENARIO:-}" != formatter-version ]]; then
    exec "$FIXTURE_RETENTION_REAL_CARGO" "$@"
fi
CARGO
            fi
            if [[ "$executable" == bash ]]; then
                cat >> "$run/bin/$executable" <<'BASH'
case "${1:-}" in
    */scripts/ci/check-release-commands.sh|*/scripts/ci/check-formatting-hooks.sh) ;;
    *) exec "$FIXTURE_RETENTION_REAL_BASH" "$@" ;;
esac
BASH
            fi
            if [[ "$scenario" == publication-child ]]; then
                cat >> "$run/bin/$executable" <<'MAKE'
publication=false
for argument in "$@"; do
    case "$argument" in publish|publish-check) publication=true ;; esac
done
if [[ "$publication" != true ]]; then exec "$FIXTURE_RETENTION_REAL_MAKE" "$@"; fi
MAKE
            elif [[ "$scenario" == publication-assertion ]]; then
                cat >> "$run/bin/$executable" <<'CMP'
case "$1" in
    */standard-release-entry.*/expected) ;;
    *) exec "$FIXTURE_RETENTION_REAL_CMP" "$@" ;;
esac
CMP
            elif [[ "$kind" == metadata && "$scenario" == assertion ]]; then
                cat >> "$run/bin/$executable" <<'CMP'
case "$1" in
    expected-packages) ;;
    *) exec "$FIXTURE_RETENTION_REAL_CMP" "$@" ;;
esac
CMP
            fi
            if [[ "$scenario" == predicate-assertion ]]; then
                # Return successful parser output contradicting the first assertion.
                cat >> "$run/bin/$executable" <<'YQ'
set -euo pipefail
"$FIXTURE_RETENTION_REAL_YQ" "$@" > "$FIXTURE_RETENTION_PROBE/original.json"
if [[ ! -e "$FIXTURE_RETENTION_PROBE/changed" ]]; then
    touch "$FIXTURE_RETENTION_PROBE/changed"
    echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
    jq '.workspace.package.version = "0.9.9"' "$FIXTURE_RETENTION_PROBE/original.json"
else
    cat "$FIXTURE_RETENTION_PROBE/original.json"
fi
YQ
            elif [[ "$scenario" == formatter-version ]]; then
                # The expected stdout must not hide this producer's failure.
                printf '%s\n' 'printf "cargo-sort 2.1.4\n"' >> "$run/bin/$executable"
            fi
            if [[ "$scenario" != predicate-assertion ]]; then
                cat >> "$run/bin/$executable" <<'FAIL'
echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
exit 43
FAIL
            fi
            chmod +x "$run/bin/$executable"
        fi
        expected_status=43
        case "$scenario" in
            success) expected_status=0 ;;
            predicate-assertion|formatter-version) expected_status=1 ;;
            publication-child) expected_status=1 ;;
        esac
        fixture_yq="$FIXTURE_RETENTION_REAL_YQ"
        if [[ "$scenario" == predicate-assertion ]]; then fixture_yq="$run/bin/yq"; fi
        PATH="$run/bin:$PATH" FIXTURE_RETENTION_SCENARIO="$scenario" \
            FIXTURE_RETENTION_PROBE="$run" YQ="$fixture_yq" \
            fixture_probe_effect "$root/$script" "$run" "$prefix" "$expected_status" "$real_bash" \
                FIXTURE_RETENTION_INJECTED_FAILURE
        if [[ "$scenario" == success ]]; then continue; fi
        retained="$fixture_effect_retained"
        grep -Fq "fixture retained: $retained" "$run/result.log"
        case "$kind" in
            standard)
                [[ -f "$retained/output" ]] || exit 1
                if [[ "$scenario" == publication-* ]]; then
                    [[ -f "$retained/events" && -f "$retained/bin/cargo" ]] || exit 1
                    if [[ "$scenario" == publication-assertion ]]; then [[ -f "$retained/expected" ]] || exit 1; fi
                fi
                ;;
            metadata)
                if [[ "$scenario" == predicate-assertion ]]; then
                    [[ -f "$retained/version-input/original.toml" && ! -e "$retained/prepared" ]] || exit 1
                    cmp "$retained/version-input/original.toml" "$retained/version-input/Cargo.toml"
                    continue
                fi
                [[ -f "$retained/prepared/Cargo.toml" && -f "$retained/prepared/setup.log" ]] || exit 1
                if [[ "$scenario" == assertion ]]; then
                    [[ -f "$retained/prepared/expected-packages" && -f "$retained/prepared/actual-packages" ]] || exit 1
                    [[ -f "$retained/prepared/originals/Cargo.lock" && -f "$retained/prepared/result.log" ]] || exit 1
                fi
                ;;
            hook)
                if [[ "$scenario" == formatter-version ]]; then
                    [[ ! -e "$retained/hook.log" ]] || exit 1
                    continue
                fi
                [[ -f "$retained/hook.log" ]] || exit 1
                ;;
        esac
    done
done
# Execute the actual admission fixture with parent-owned evidence destinations.
# Its synthetic failures must use its own logs and leave the parent untouched.
run="$evidence/admission-parent"
mkdir -p "$run/logs" "$run/failures" "$run/tmp"
printf 'parent-owned evidence\n' > "$run/expected"
for destination in logs/sentinel failures/sentinel summary.md; do
    cp "$run/expected" "$run/$destination"
done
VALIDATION_LOG_DIR="$run/logs" VALIDATION_FAILURE_LOG_DIR="$run/failures" \
    GITHUB_STEP_SUMMARY="$run/summary.md" TMPDIR="$run/tmp" \
    "$real_bash" "$root/scripts/release/test-release-admission.sh" \
    > "$run/result.log" 2>&1
for destination in logs/sentinel failures/sentinel summary.md; do
    cmp "$run/expected" "$run/$destination"
done
for directory in logs failures; do
    [[ "$(ls -A "$run/$directory")" == sentinel ]] || exit 1
done
for remaining in "$run/tmp"/*; do [[ ! -e "$remaining" ]] || exit 1; done
echo 'Admission fixture preserves inherited parent logs and summary'

# Probe actual initialization/cleanup prefixes through the shared owner.
# Consumer rosters and successful diagnostic retention remain explicit here.
for script in scripts/release/test-standard-release.sh scripts/release/test-metadata.sh \
    scripts/release/test-release-admission.sh scripts/dev/test-format-hook.sh \
    scripts/ci/test-native-evidence.sh scripts/release/test-fixture-retention.sh; do
    name="${script##*/}"
    success=completed
    directory_variable=fixture
    case "$script" in
        scripts/ci/test-native-evidence.sh) success='retained-completed' ;;
        scripts/release/test-fixture-retention.sh) success='retained-completed'; directory_variable=evidence ;;
    esac
    for scenario in nounset premature "$success"; do
        run="$evidence/cleanup-${name%.sh}-$scenario"
        probe_source="$run/source"
        mkdir -p "$probe_source/scripts/ci" "$probe_source/scripts/dev" "$probe_source/.githooks" "$probe_source/crates/ic-metrics/src"
        cp "$root/scripts/ci/fixture-lifecycle.sh" "$root/scripts/ci/fixture-retention-probes.sh" \
            "$root/scripts/ci/check-make-execution.sh" "$probe_source/scripts/ci/"
        # The native fixture observes its checkout before installing its trap.
        git init --quiet "$probe_source"
        FIXTURE_PROBE_ROOT_VARIABLE=root FIXTURE_PROBE_DIRECTORY_VARIABLE="$directory_variable" \
            fixture_probe_exit "$root/$script" "$run" "$probe_source" "${name%.sh}" "$scenario" || exit 1
    done
done
echo "fixture success cleanup and child/assertion failure retention passed; evidence: $evidence"
fixture_complete=true
