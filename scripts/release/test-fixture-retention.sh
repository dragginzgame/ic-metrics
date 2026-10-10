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
evidence="$(mktemp -d "$root/target/evidence/native-ci/fixture-retention.XXXXXX")"
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
    for scenario in "${scenarios[@]}"; do
        run="$evidence/$kind-$scenario"
        mkdir -p "$run/tmp" "$run/bin"
        if [[ "$scenario" != success ]]; then
            executable="$child"
            if [[ "$scenario" == *assertion ]]; then executable='cmp'; fi
            if [[ "$scenario" == formatter-version ]]; then executable=cargo; fi
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
    history-before) ;;
    *) exec "$FIXTURE_RETENTION_REAL_CMP" "$@" ;;
esac
CMP
            fi
            if [[ "$scenario" == formatter-version ]]; then
                # The expected stdout must not hide this producer's failure.
                printf '%s\n' 'printf "cargo-sort 2.1.4\n"' >> "$run/bin/$executable"
            fi
            cat >> "$run/bin/$executable" <<'FAIL'
echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
exit 43
FAIL
            chmod +x "$run/bin/$executable"
        fi
        status=0
        TMPDIR="$run/tmp" PATH="$run/bin:$PATH" FIXTURE_RETENTION_SCENARIO="$scenario" "$real_bash" "$root/$script" \
            > "$run/result.log" 2>&1 || status=$?
        printf '%s\n' "$status" > "$run/status.txt"
        if [[ "$scenario" == success ]]; then
            [[ "$status" == 0 ]]
            for remaining in "$run/tmp"/*; do [[ ! -e "$remaining" ]]; done
            continue
        fi
        [[ "$status" != 0 ]]
        if [[ "$scenario" == formatter-version ]]; then
            [[ "$status" == 1 ]] # The shared prerequisite checker rejects the failed producer.
        elif [[ "$kind" == standard && "$scenario" == *child ]]; then
            [[ "$status" == 1 ]] # The real fixture rejects the unexpected Make status.
        else
            [[ "$status" == 43 ]] # Cleanup must preserve the injected failure status.
        fi
        grep -q FIXTURE_RETENTION_INJECTED_FAILURE "$run/result.log"
        set -- "$run/tmp/$prefix".*
        [[ $# == 1 && -d "$1" ]]
        retained="$1"
        grep -Fq "fixture retained: $retained" "$run/result.log"
        case "$kind" in
            standard)
                [[ -f "$retained/output" ]]
                if [[ "$scenario" == publication-* ]]; then
                    [[ -f "$retained/events" && -f "$retained/bin/cargo" ]]
                    if [[ "$scenario" == publication-assertion ]]; then [[ -f "$retained/expected" ]]; fi
                else
                    set -- "$retained"/release-commands.*
                    [[ $# == 1 && -f "$1/Makefile" && -f "$1/events" && -f "$1/patch-0.log" ]]
                    if [[ "$scenario" == assertion ]]; then [[ -f "$1/expected" ]]; fi
                fi
                ;;
            metadata)
                [[ -f "$retained/prepared/Cargo.toml" && -f "$retained/prepared/setup.log" ]]
                if [[ "$scenario" == assertion ]]; then
                    [[ -f "$retained/prepared/history-before" && -f "$retained/prepared/history-after" ]]
                    [[ -f "$retained/prepared/originals/Cargo.lock" && -f "$retained/prepared/result.log" ]]
                fi
                ;;
            hook)
                if [[ "$scenario" == formatter-version ]]; then
                    [[ ! -e "$retained/hook.log" ]]
                    continue
                fi
                [[ -f "$retained/hook.log" ]]
                set -- "$retained"/formatting-adoption.*
                [[ $# == 1 && -f "$1/base/Cargo.toml" && -f "$1/baseline.log" ]]
                if [[ "$scenario" == assertion ]]; then
                    [[ -f "$1/sorted-manifest" && -f "$1/refresh/crates/ic-metrics/Cargo.toml" ]]
                fi
                ;;
        esac
    done
done
# Execute the actual cleanup bodies independently of installer/compilation effects.
# Bash 3.2's nounset trap status and an explicit early exit must never admit success.
for script in scripts/release/test-standard-release.sh scripts/release/test-metadata.sh \
    scripts/release/test-release-admission.sh scripts/dev/test-format-hook.sh \
    scripts/ci/test-native-evidence.sh scripts/release/test-fixture-retention.sh; do
    name="${script##*/}"
    for scenario in nounset early-zero success; do
        run="$evidence/cleanup-${name%.sh}-$scenario"
        mkdir -p "$run/tmp" "$run/target/evidence/native-ci"
        awk '
            /^(fixture|evidence)="\$\(mktemp / { copy=1 }
            copy { print }
            /^trap cleanup EXIT$/ && copy { exit }
        ' "$root/$script" > "$run/cleanup.sh"
        cat >> "$run/cleanup.sh" <<'CLEANUP'
retained="${fixture:-$evidence}"
printf '%s\n' "$retained" > "$root/selected.txt"
printf 'retained diagnostic\n' > "$retained/result.log"
case "$CLEANUP_SCENARIO" in
    nounset) printf '%s\n' "${METRICS_INTENTIONALLY_UNSET?injected nounset}" ;;
    early-zero) exit 0 ;;
    success) fixture_complete=true ;;
esac
CLEANUP
        status=0
        env -u METRICS_INTENTIONALLY_UNSET root="$run" TMPDIR="$run/tmp" CLEANUP_SCENARIO="$scenario" \
            "$real_bash" -eu "$run/cleanup.sh" > "$run/result.log" 2>&1 || status=$?
        printf '%s\n' "$status" > "$run/status.txt"
        retained="$(cat "$run/selected.txt")"
        if [[ "$scenario" != success ]]; then
            [[ "$status" != 0 && -f "$retained/result.log" ]]
            grep -F 'retained diagnostic' "$retained/result.log" > /dev/null
            if [[ "$scenario" == nounset ]]; then grep -F 'injected nounset' "$run/result.log" > /dev/null; fi
        else
            [[ "$status" == 0 ]]
            case "$script" in
                scripts/ci/test-native-evidence.sh|scripts/release/test-fixture-retention.sh) [[ -f "$retained/result.log" ]] ;;
                *) [[ ! -e "$retained" ]] ;;
            esac
        fi
    done
done
echo "fixture success cleanup and child/assertion failure retention passed; evidence: $evidence"
fixture_complete=true
