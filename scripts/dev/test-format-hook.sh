#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH

# Exercise the arithmetic hook through the reviewed shared checker.
# Only scratch Git state changes; tools are already prepared.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/metrics-format-hook.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    [[ "$fixture_complete" == true || "$status" != 0 ]] || status=1
    if [[ "$status" != 0 ]]; then
        if [[ -f "$fixture/format-tools.log" ]]; then cat "$fixture/format-tools.log" >&2 || :; fi
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
# shellcheck source=ci/tool-versions.env
source "$root/ci/tool-versions.env"
bash "$root/scripts/ci/check-format-tools.sh" "$SHARED_TOOLING_CARGO_SORT_VERSION" > "$fixture/format-tools.log" 2>&1
# Overlay current arithmetic modules and the optional package, including new files.
# The canonical checker starts from committed HEAD; lib.rs alone can refer to
# modules absent from that export. Keep the producer's failure visible before
# passing its NUL-delimited, checkout-relative regular files to the checker.
(cd "$root"; rg --files --null -- crates/ic-metrics/src crates/ic-metrics-stable) > "$fixture/arithmetic-sources"
arithmetic_sources=()
while IFS= read -r -d '' path; do
    arithmetic_sources+=("$path")
done < "$fixture/arithmetic-sources"
# The shared checker owns disposable exports and mechanical hook cases.
# Nest its retained failures under this consumer's reported evidence directory.
TMPDIR="$fixture" bash "$root/scripts/ci/check-formatting-hooks.sh" "$root" \
    crates/ic-metrics/src/lib.rs crates/ic-metrics/Cargo.toml \
    --no-dependency-tables Cargo.toml Cargo.lock crates/ic-metrics/LICENSE \
    ci/tool-versions.env scripts/ci/check-format-tools.sh scripts/ci/run-formatting.sh \
    make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk \
    "${arithmetic_sources[@]}" \
    > "$fixture/hook.log" 2>&1
cat "$fixture/hook.log"
fixture_complete=true
