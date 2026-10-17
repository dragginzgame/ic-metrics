#!/usr/bin/env bash
set -euo pipefail
export RELEASE_DELIVERY=direct

# Exercise real consumer fixtures through controlled executable failures.
# Use caller-owned scratch, defaulting to native CI evidence, including inputs.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
mkdir -p "$root/target/evidence/native-ci"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
evidence="$(fixture_create "${TMPDIR:-$root/target/evidence/native-ci}/fixture-retention.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    fixture_completion_status "$status" "$fixture_complete" || status=$?
    if [[ "$status" != 0 ]]; then
        fixture_replay_logs "${active_log:-}"
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
git -C "$root" rev-parse HEAD > "$evidence/source-commit.txt"

for kind in standard metadata hook; do
    case "$kind" in
        standard) script=scripts/release/test-standard-release.sh; prefix=standard-release-entry; child=bash ;;
        metadata) script=scripts/release/test-metadata.sh; prefix=metrics-metadata-test; child=cargo ;;
        hook) script=scripts/dev/test-format-hook.sh; prefix=formatting-adoption; child='make' ;;
    esac
    cp "$root/$script" "$evidence/$kind-source.sh"
    scenarios=(success child)
    if [[ "$kind" == metadata ]]; then scenarios+=(assertion); fi
    if [[ "$kind" == standard ]]; then scenarios+=(publication-child publication-assertion); fi
    if [[ "$kind" == hook ]]; then scenarios=(success baseline); fi
    for scenario in "${scenarios[@]}"; do
        run="$evidence/$kind-$scenario"
        active_log="$run/result.log"
        mkdir -p "$run/tmp" "$run/bin"
        if [[ "$scenario" != success ]]; then
            executable="$child"
            if [[ "$scenario" == publication-child ]]; then executable='make'; fi
            if [[ "$scenario" == baseline ]]; then executable='make'; fi
            if [[ "$scenario" == *assertion ]]; then executable='cmp'; fi
            printf '#!%s\n' "$real_bash" > "$run/bin/$executable"
            if [[ "$executable" == cargo ]]; then
                cat >> "$run/bin/$executable" <<'CARGO'
if [[ "${1:-}" != generate-lockfile ]]; then
    exec "$FIXTURE_RETENTION_REAL_CARGO" "$@"
fi
CARGO
            fi
            if [[ "$executable" == bash ]]; then
                cat >> "$run/bin/$executable" <<'BASH'
case "${1:-}" in
    */scripts/ci/check-release-commands.sh) ;;
    *) exec "$FIXTURE_RETENTION_REAL_BASH" "$@" ;;
esac
BASH
            fi
            if [[ "$scenario" == baseline ]]; then
                cat >> "$run/bin/$executable" <<'MAKE'
for argument in "$@"; do
    if [[ "$argument" == fmt-check ]]; then
        echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
        exit 43
    fi
done
exec "$FIXTURE_RETENTION_REAL_MAKE" "$@"
MAKE
            elif [[ "$scenario" == publication-child ]]; then
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
            cat >> "$run/bin/$executable" <<'FAIL'
echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
exit 43
FAIL
            chmod +x "$run/bin/$executable"
        fi
        expected_status=43
        case "$scenario" in
            success) expected_status=0 ;;
            publication-child) expected_status=1 ;;
        esac
        PATH="$run/bin:$PATH" \
            fixture_probe_effect "$root/$script" "$run" "$prefix" "$expected_status" "$real_bash" \
                FIXTURE_RETENTION_INJECTED_FAILURE
        if [[ "$scenario" == success ]]; then
            echo "$kind fixture passed (full body; success cleanup checked)"
            continue
        fi
        retained="$fixture_effect_retained"
        if [[ "$kind" == hook ]]; then
            grep -Fxq "Formatting adoption evidence retained: $retained" "$run/result.log"
        else
            grep -Fq "fixture retained: $retained" "$run/result.log"
        fi
        case "$kind" in
            standard)
                [[ -f "$retained/output" ]] || exit 1
                if [[ "$scenario" == publication-* ]]; then
                    [[ -f "$retained/events" && -f "$retained/bin/cargo" ]] || exit 1
                    if [[ "$scenario" == publication-assertion ]]; then [[ -f "$retained/expected" ]] || exit 1; fi
                fi
                ;;
            metadata)
                [[ -f "$retained/prepared/Cargo.toml" && -f "$retained/prepared/setup.log" ]] || exit 1
                if [[ "$scenario" == assertion ]]; then
                    [[ -f "$retained/prepared/expected-packages" && -f "$retained/prepared/actual-packages" ]] || exit 1
                    [[ -f "$retained/prepared/originals/Cargo.lock" && -f "$retained/prepared/result.log" ]] || exit 1
                fi
                ;;
            hook)
                grep -Fq FIXTURE_RETENTION_INJECTED_FAILURE "$retained/baseline.log"
                ;;
        esac
    done
done
# Execute the actual admission fixture with parent-owned evidence destinations.
# Its synthetic failures must use its own logs and leave the parent untouched.
run="$evidence/admission-parent"
active_log="$run/result.log"
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
    scripts/release/test-release-admission.sh \
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
        mkdir -p "$run"
        FIXTURE_PROBE_ROOT_VARIABLE=root FIXTURE_PROBE_DIRECTORY_VARIABLE="$directory_variable" \
            fixture_probe_exit "$root/$script" "$run" "$root" "${name%.sh}" "$scenario" || exit 1
    done
done
echo "fixture success cleanup and child/assertion failure retention passed; evidence: $evidence"
fixture_complete=true
