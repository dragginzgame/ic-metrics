#!/usr/bin/env bash
# Shared companions: scripts/dev/install-rust-tools.sh ci/release-tools.env
set -euo pipefail
[[ $# == 1 ]] || { echo 'usage: release-editor.sh install|check' >&2; exit 2; }
arguments=()
case "$1" in
    install) ;;
    check) arguments+=(--check) ;;
    *) echo 'usage: release-editor.sh install|check' >&2; exit 2 ;;
esac
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=ci/release-tools.env
source "$root/ci/release-tools.env"
exec "$BASH" "$root/scripts/dev/install-rust-tools.sh" --consumer "$root" \
    --package ic-build --version "$IC_METRICS_RELEASE_EDITOR_VERSION" \
    --bin ic-build-release-metadata --profile debug --features cli ${arguments[@]+"${arguments[@]}"}
