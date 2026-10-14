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
    [[ "$fixture_complete" == true || "$status" != 0 ]] || status=1
    if [[ "$status" != 0 ]]; then
        echo "fixture retention check failed; evidence retained: $evidence" >&2
    fi
    exit "$status"
}
trap cleanup EXIT
real_bash="$(command -v bash)"
real_cargo="$(command -v cargo)"
export FIXTURE_RETENTION_REAL_CARGO="$real_cargo"
FIXTURE_RETENTION_REAL_MAKE="$(command -v make)"
FIXTURE_RETENTION_REAL_CMP="$(command -v cmp)"
export FIXTURE_RETENTION_REAL_MAKE FIXTURE_RETENTION_REAL_CMP
FIXTURE_RETENTION_REAL_YQ="${YQ:-$(command -v yq)}"
export FIXTURE_RETENTION_REAL_YQ
git -C "$root" rev-parse HEAD > "$evidence/source-commit.txt"

for kind in standard metadata hook; do
    case "$kind" in
        standard) script=scripts/release/test-standard-release.sh; prefix=standard-release-entry; child='make' ;;
        metadata) script=scripts/release/test-metadata.sh; prefix=metrics-metadata-test; child=cargo ;;
        hook) script=scripts/dev/test-format-hook.sh; prefix=metrics-format-hook; child='make' ;;
    esac
    cp "$root/$script" "$evidence/$kind-source.sh"
    scenarios=(success child assertion)
    if [[ "$kind" == standard ]]; then scenarios+=(publication-child publication-assertion); fi
    if [[ "$kind" == hook ]]; then scenarios+=(formatter-version); fi
    if [[ "$kind" == metadata ]]; then scenarios+=(predicate-assertion); fi
    for scenario in "${scenarios[@]}"; do
        run="$evidence/$kind-$scenario"
        mkdir -p "$run/tmp" "$run/bin"
        if [[ "$scenario" != success ]]; then
            executable="$child"
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
        status=0
        fixture_yq="$FIXTURE_RETENTION_REAL_YQ"
        if [[ "$scenario" == predicate-assertion ]]; then fixture_yq="$run/bin/yq"; fi
        TMPDIR="$run/tmp" PATH="$run/bin:$PATH" FIXTURE_RETENTION_SCENARIO="$scenario" \
            FIXTURE_RETENTION_PROBE="$run" YQ="$fixture_yq" "$real_bash" "$root/$script" \
            > "$run/result.log" 2>&1 || status=$?
        printf '%s\n' "$status" > "$run/status.txt"
        if [[ "$scenario" == success ]]; then
            [[ "$status" == 0 ]] || exit 1
            for remaining in "$run/tmp"/*; do [[ ! -e "$remaining" ]] || exit 1; done
            continue
        fi
        [[ "$status" != 0 ]] || exit 1
        if [[ "$scenario" == predicate-assertion ]]; then
            [[ "$status" == 1 ]] || exit 1
        elif [[ "$scenario" == formatter-version ]]; then
            [[ "$status" == 1 ]] || exit 1 # The shared prerequisite checker rejects the failed producer.
        elif [[ "$kind" == standard && "$scenario" == *child ]]; then
            [[ "$status" == 1 ]] || exit 1 # The real fixture rejects the unexpected Make status.
        else
            [[ "$status" == 43 ]] || exit 1 # Cleanup must preserve the injected failure status.
        fi
        grep -q FIXTURE_RETENTION_INJECTED_FAILURE "$run/result.log"
        set -- "$run/tmp/$prefix".*
        [[ $# == 1 && -d "$1" ]] || exit 1
        retained="$1"
        grep -Fq "fixture retained: $retained" "$run/result.log"
        case "$kind" in
            standard)
                [[ -f "$retained/output" ]] || exit 1
                if [[ "$scenario" == publication-* ]]; then
                    [[ -f "$retained/events" && -f "$retained/bin/cargo" ]] || exit 1
                    if [[ "$scenario" == publication-assertion ]]; then [[ -f "$retained/expected" ]] || exit 1; fi
                else
                    set -- "$retained"/release-commands.*
                    [[ $# == 1 && -f "$1/Makefile" && -f "$1/events" && -f "$1/patch-0.log" ]] || exit 1
                    if [[ "$scenario" == assertion ]]; then [[ -f "$1/expected" ]] || exit 1; fi
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
                set -- "$retained"/formatting-adoption.*
                [[ $# == 1 && -f "$1/base/Cargo.toml" && -f "$1/baseline.log" ]] || exit 1
                if [[ "$scenario" == assertion ]]; then
                    [[ -f "$1/sorted-manifest" && -f "$1/refresh/crates/ic-metrics/Cargo.toml" ]] || exit 1
                fi
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
# shellcheck source=scripts/ci/fixture-retention-probes.sh
source "$root/scripts/ci/fixture-retention-probes.sh"
for script in scripts/release/test-standard-release.sh scripts/release/test-metadata.sh \
    scripts/release/test-release-admission.sh scripts/dev/test-format-hook.sh \
    scripts/ci/test-native-evidence.sh scripts/release/test-fixture-retention.sh \
    scripts/ci/check-formatting-hooks.sh; do
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
        cp "$root/scripts/ci/fixture-lifecycle.sh" "$root/scripts/ci/check-make-execution.sh" "$probe_source/scripts/ci/"
        # The native fixture observes its checkout before installing its trap.
        git init --quiet "$probe_source"
        probe_args=()
        if [[ "$script" == scripts/ci/check-formatting-hooks.sh ]]; then
            for path in Makefile README.md .githooks/pre-commit scripts/dev/install-git-hooks.sh \
                crates/ic-metrics/src/lib.rs Cargo.toml; do
                cp "$root/$path" "$probe_source/$path"
            done
            probe_args=("$probe_source" crates/ic-metrics/src/lib.rs Cargo.toml --no-dependency-tables)
        fi
        FIXTURE_PROBE_ROOT_VARIABLE=root FIXTURE_PROBE_DIRECTORY_VARIABLE="$directory_variable" \
            fixture_probe_exit "$root/$script" "$run" "$probe_source" "${name%.sh}" "$scenario" \
            ${probe_args[@]+"${probe_args[@]}"} || exit 1
    done
done
echo "fixture success cleanup and child/assertion failure retention passed; evidence: $evidence"
fixture_complete=true
