#!/usr/bin/env bash
# Shared companions: scripts/ci/read-cargo-workspace-version.sh scripts/ci/check-release-source.sh scripts/ci/check-release-delivery.sh scripts/ci/check-release-changelog.sh scripts/ci/cargo-release-preflight.sh scripts/ci/cargo-release-metadata.sh scripts/dev/release-editor.sh ci/tool-versions.env ci/release-delivery.txt ci/release-tools.env
set -euo pipefail

# Consumer adapter. Dependencies: Cargo, jq, yq, Git, tar, awk, Perl and Unix utilities.
operation="${1:-}"
[[ $# -eq 1 ]] || exit 2
# Standard entrypoints select cache preparation only after runner recovery/source
# admission. Consume the internal selection before any helper or Cargo child.
release_cache_prepare="${IC_METRICS_RELEASE_CACHE_PREPARE:-0}"
unset IC_METRICS_RELEASE_CACHE_PREPARE
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
"$BASH" "$root/scripts/ci/check-release-delivery.sh" \
    "$root/ci/release-delivery.txt" "${RELEASE_DELIVERY-direct}"
reader="$root/scripts/ci/read-cargo-workspace-version.sh"
release_paths=(Cargo.toml Cargo.lock CHANGELOG.md)
source_arguments=()
for path in "${release_paths[@]}"; do source_arguments+=(--allow "$path"); done
case "$operation" in
    files) printf '%s\0' "${release_paths[@]}" ;;
    version) bash "$reader" Cargo.toml ;;
    preflight)
        if ! bash "$root/scripts/ci/check-release-source.sh" "${source_arguments[@]}"; then
            echo 'release preflight refused; this attempt has not started validation or version preparation' >&2
            exit 1
        fi
        current_version="$(bash "$reader" Cargo.toml)"
        [[ "$current_version" == "${RELEASE_PREVIOUS:?}" ]] || exit 1
        for path in "${release_paths[@]}"; do
            [[ -f "$path" && ! -L "$path" ]] || exit 1
        done
        # Refuse conflicting pending notes before a gate or preparation intent.
        bash "$root/scripts/ci/check-release-changelog.sh" \
            "${RELEASE_VERSION:?}" "$RELEASE_PREVIOUS" "${RELEASE_DATE:?}" CHANGELOG.md
        tool_versions="${RUST_TOOL_VERSIONS:-$root/ci/tool-versions.env}"
        bash "$root/scripts/ci/cargo-release-preflight.sh" "$root" "$release_cache_prepare" \
            --pin "$tool_versions" --pin "$root/ci/release-tools.env" \
            --check rust-tools-check --check release-editor-check \
            --prepare install-rust-tools --prepare rust-tools-check \
            --prepare install-release-editor --prepare release-editor-check
        ;;
    prepare)
        # Selection is read-only here; only explicit setup/preflight installs tools.
        CARGO_RELEASE_METADATA_EDITOR="$(bash "$root/scripts/dev/release-editor.sh" check)"
        export CARGO_RELEASE_METADATA_EDITOR
        # shellcheck source=ci/release-tools.env
        source "$root/ci/release-tools.env"
        export CARGO_RELEASE_METADATA_MAX_BYTES="$IC_METRICS_RELEASE_METADATA_MAX_BYTES"
        bash "$root/scripts/ci/cargo-release-metadata.sh" prepare ic-metrics
        ;;
    check|commit-check)
        if [[ "$operation" == commit-check ]]; then
            [[ -z "${RELEASE_COMMIT:-}" ]] || exit 1
        fi
        bash "$root/scripts/ci/cargo-release-metadata.sh" check ic-metrics --manifest-order-grouped
        bash "$root/scripts/ci/check-release-source.sh" "${source_arguments[@]}"
        if [[ "$operation" == commit-check ]]; then
            git diff --quiet -- "${release_paths[@]}"
        fi
        ;;
    *) echo 'usage: metadata.sh files|version|preflight|prepare|check|commit-check' >&2; exit 2 ;;
esac
