#!/usr/bin/env bash
set -euo pipefail

# Metrics selects the published CLI; Shared Tooling owns installation/admission.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
operation="${1:-}"
[[ $# -ge 1 ]] || exit 2
shift
selection=(--consumer "$root" --package ic-host-wasm-inspect --version 0.17.10 --bin ic-host-wasm-inspect --profile release)
case "$operation" in
    install|check)
        [[ $# == 0 ]] || exit 2
        if [[ "$operation" == check ]]; then selection+=(--check); fi
        bash "$root/scripts/dev/install-rust-tools.sh" "${selection[@]}"
        ;;
    run)
        executable="$(bash "$root/scripts/dev/install-rust-tools.sh" "${selection[@]}" --check)"
        exec "$executable" "$@"
        ;;
    *) echo 'usage: wasm-inspector.sh install|check|run [CLI arguments]' >&2; exit 2 ;;
esac
