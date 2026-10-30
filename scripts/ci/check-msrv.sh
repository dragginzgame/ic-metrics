#!/usr/bin/env bash
set -euo pipefail

# Validation only: the workspace owns the default floor; callers may select an
# already prepared toolchain through MSRV. Never install tools or change the lock.
[[ $# == 0 ]] || { echo 'usage: check-msrv.sh (optional MSRV override)' >&2; exit 2; }
export RUSTUP_AUTO_INSTALL=0
minimum="${MSRV:-}"
if [[ -z "$minimum" ]]; then
    minimum="$(bash scripts/ci/read-cargo-workspace-rust-version.sh Cargo.toml)"
fi
[[ "$minimum" != -* && "$minimum" != *[[:space:]]* ]] || {
    echo 'MSRV must select one prepared Rust toolchain' >&2; exit 2;
}
rustc "+$minimum" --version
cargo "+$minimum" --version
# Include native test targets and their development dependencies at the same floor.
cargo "+$minimum" check -p ic-metrics --lib --no-default-features --locked
# The Wasm link fixture also builds the default-feature library at this floor.
bash scripts/ci/check-allocation-free.sh "$minimum"
cargo "+$minimum" check --workspace --all-targets --all-features --locked
cargo "+$minimum" check --workspace --all-features --locked --target wasm32-unknown-unknown

# Public examples are part of the compiler-floor contract too.
cargo "+$minimum" test --workspace --doc --all-features --locked
