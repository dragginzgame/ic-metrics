#!/usr/bin/env bash
set -euo pipefail

# Validation only: the workspace owns the default floor; callers may select an
# already prepared toolchain through MSRV. Never install tools or change the lock.
[[ $# == 0 ]] || { echo 'usage: check-msrv.sh (optional MSRV override)' >&2; exit 2; }
export RUSTUP_AUTO_INSTALL=0
minimum="${MSRV:-}"
if [[ -z "$minimum" ]]; then
    document="$("${YQ:-yq}" -p toml -o json '.' Cargo.toml)"
    minimum="$(printf '%s' "$document" | jq -er '
        .workspace.package."rust-version" |
        select(type == "string" and test("\\A[0-9]+\\.[0-9]+(\\.[0-9]+)?\\z"))
    ')"
fi
[[ "$minimum" != -* && "$minimum" != *[[:space:]]* ]] || {
    echo 'MSRV must select one prepared Rust toolchain' >&2; exit 2;
}
rustc "+$minimum" --version
cargo "+$minimum" --version
cargo "+$minimum" check --workspace --locked
cargo "+$minimum" check --workspace --locked --target wasm32-unknown-unknown
