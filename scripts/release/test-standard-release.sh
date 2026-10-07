#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/standard-release-entry.XXXXXX")"
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        if [[ -f "$fixture/output" ]]; then cat "$fixture/output" >&2 || :; fi
        for log in "$fixture"/release-commands.*/*.log; do
            if [[ -f "$log" ]]; then cat "$log" >&2 || :; fi
        done
        echo "failed standard release fixture retained: $fixture" >&2
    else
        rm -rf "$fixture"
    fi
    exit "$status"
}
trap cleanup EXIT
mkdir -p "$fixture/bin" "$fixture/make"
cp "$root/make/tools.mk" "$fixture/make/"
real_bash="$(command -v bash)"
export EVENTS="$fixture/events"
cd "$fixture"
real_make="$(command -v make)"
TMPDIR="$fixture" "$real_bash" "$root/scripts/ci/check-release-commands.sh" "$root" \
    make/tools.mk \
    > "$fixture/output" 2>&1

# Publication remains a separate single-package Cargo operation, never a release.
printf '#!%s\n' "$real_bash" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
set -euo pipefail
printf '%s\n' "$@" >> "$EVENTS"
[[ "${FAIL_PUBLISH:-0}" == 0 ]]
CARGO
chmod +x "$fixture/bin/cargo"
for target in publish publish-check; do
    for fail in 0 1; do
        : > "$EVENTS"
        status=0
        PATH="$fixture/bin:$PATH" FAIL_PUBLISH="$fail" "$real_make" --no-print-directory \
            -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
        if [[ "$fail" == 0 ]]; then [[ "$status" == 0 ]]; else [[ "$status" != 0 ]]; fi
        printf '%s\n' publish -p ic-metrics --locked --registry crates-io > "$fixture/expected"
        if [[ "$target" == publish-check ]]; then printf '%s\n' --dry-run >> "$fixture/expected"; fi
        cmp "$fixture/expected" "$EVENTS"
    done
done
echo 'release and publication Make adapters passed (command stubs; no Git or registry effects)'
