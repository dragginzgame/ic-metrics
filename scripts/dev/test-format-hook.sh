#!/usr/bin/env bash
set -euo pipefail

# Exercise the arithmetic hook through the reviewed shared checker.
# Only scratch Git state changes; tools are already prepared.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# The shared checker owns disposable exports, diagnostics and fixture custody.
exec bash "$root/scripts/ci/check-formatting-hooks.sh" "$root" \
    crates/ic-metrics/src/lib.rs crates/ic-metrics/Cargo.toml \
    --no-dependency-tables --rust-sources Cargo.toml Cargo.lock crates/ic-metrics/LICENSE \
    ci/tool-versions.env scripts/ci/check-format-tools.sh scripts/ci/run-formatting.sh \
    make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk
