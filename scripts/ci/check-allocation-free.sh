#!/usr/bin/env bash
set -euo pipefail
# Validation only. Cargo uses this repository's target directory and locked graph.
[[ $# -le 1 ]] || { echo 'usage: check-allocation-free.sh [prepared-toolchain]' >&2; exit 2; }
bash scripts/ci/check-make-execution.sh
export RUSTUP_AUTO_INSTALL=0 CARGO_NET_OFFLINE=true
toolchain=()
if [[ $# == 1 ]]; then
    [[ -n "$1" && "$1" != -* && "$1" != *[[:space:]]* ]] || exit 2
    toolchain=("+$1")
fi
# --export-all and link-dead-code retain the runtime-input arithmetic entrypoint.
# No global allocator or std is supplied by the fixture. This must link, not check.
cargo ${toolchain[@]+"${toolchain[@]}"} rustc -p ic-metrics --example arithmetic-no-allocator \
    --no-default-features --locked --offline --target wasm32-unknown-unknown \
    -- -C panic=abort -C link-dead-code=yes -C link-arg=--no-entry -C link-arg=--export-all
