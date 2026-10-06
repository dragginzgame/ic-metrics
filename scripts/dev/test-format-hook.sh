#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH

# Exercise this dependency-free consumer through the reviewed shared checker.
# Only scratch Git state changes; tools are already prepared.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/metrics-format-hook.XXXXXX")"
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        if [[ -f "$fixture/hook.log" ]]; then cat "$fixture/hook.log" >&2 || :; fi
        for log in "$fixture"/formatting-adoption.*/*.log "$fixture"/formatting-adoption.*/*/.git/*.log; do
            if [[ -f "$log" ]]; then cat "$log" >&2 || :; fi
        done
        echo "failed formatting hook fixture retained: $fixture" >&2
    else
        rm -rf "$fixture"
    fi
    exit "$status"
}
trap cleanup EXIT
sort_version="$(cargo sort --version)"
[[ "$sort_version" == 'cargo-sort 2.1.4' ]] || {
    echo 'hook checks require prepared cargo-sort 2.1.4' >&2
    exit 1
}
# The shared checker owns disposable exports and mechanical hook cases.
# Nest its retained failures under this consumer's reported evidence directory.
TMPDIR="$fixture" bash "$root/scripts/ci/check-formatting-hooks.sh" "$root" \
    crates/ic-metrics/src/lib.rs crates/ic-metrics/Cargo.toml \
    --no-dependency-tables Cargo.toml Cargo.lock crates/ic-metrics/LICENSE \
    > "$fixture/hook.log" 2>&1
cat "$fixture/hook.log"
