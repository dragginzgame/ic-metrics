#!/usr/bin/env bash
set -euo pipefail
# One Metrics-owned selection for native hashing and workflow fixture copies.
# NUL-delimited paths include pending source, excluding generated/private evidence.
[[ $# == 0 ]] || { echo 'usage: native-source-files.sh' >&2; exit 2; }
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
git -C "$root" ls-files --cached --others --exclude-standard -z -- \
    README.md Cargo.toml Cargo.lock Makefile rust-toolchain.toml .shared-tooling.snapshot \
    make crates ci scripts .githooks .github \
    ':(glob,exclude)**/target/**' ':(glob,exclude)**/.tools/**' \
    ':(glob,exclude)**/.private-evidence/**'
