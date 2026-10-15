#!/usr/bin/env bash
set -euo pipefail

# Consumer adapter. Dependencies: Cargo, jq, yq, Git, tar, awk, Perl and Unix utilities.
operation="${1:-}"
[[ $# -eq 1 ]] || exit 2
# Standard entrypoints select cache preparation only after runner recovery/source
# admission. Consume the internal selection before any helper or Cargo child.
release_cache_prepare="${IC_METRICS_RELEASE_CACHE_PREPARE:-0}"
unset IC_METRICS_RELEASE_CACHE_PREPARE
if [[ "${RELEASE_DELIVERY-direct}" != direct ]]; then
    echo 'ic-metrics supports RELEASE_DELIVERY=direct only' >&2
    exit 2
fi
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
reader="$root/scripts/ci/read-cargo-workspace-version.sh"
case "$operation" in
    version) bash "$reader" Cargo.toml ;;
    preflight)
        if ! bash "$root/scripts/ci/check-release-source.sh" \
            --allow Cargo.toml --allow Cargo.lock --allow CHANGELOG.md; then
            echo 'release preflight refused; this attempt has not started validation or version preparation' >&2
            exit 1
        fi
        current_version="$(bash "$reader" Cargo.toml)"
        [[ "$current_version" == "${RELEASE_PREVIOUS:?}" ]] || exit 1
        for path in Cargo.toml Cargo.lock CHANGELOG.md; do
            [[ -f "$path" && ! -L "$path" ]] || exit 1
        done
        # Refuse conflicting pending notes before a gate or preparation intent.
        awk -v version="${RELEASE_VERSION:?}" -v previous="$RELEASE_PREVIOUS" -v date="${RELEASE_DATE:?}" \
            -f scripts/ci/finalize-release-changelog.awk CHANGELOG.md > /dev/null
        tool_versions="${RUST_TOOL_VERSIONS:-$root/ci/tool-versions.env}"
        bash "$root/scripts/ci/cargo-release-preflight.sh" "$root" "$release_cache_prepare" \
            --pin "$tool_versions" \
            --check rust-tools-check \
            --prepare install-rust-tools --prepare rust-tools-check
        ;;
    prepare)
        bash "$root/scripts/ci/cargo-release-metadata.sh" prepare ic-metrics
        ;;
    check|commit-check)
        if [[ "$operation" == commit-check ]]; then
            [[ -z "${RELEASE_COMMIT:-}" ]] || exit 1
        fi
        bash "$root/scripts/ci/cargo-release-metadata.sh" check ic-metrics --manifest-order
        bash "$root/scripts/ci/check-release-source.sh" \
            --allow Cargo.toml --allow Cargo.lock --allow CHANGELOG.md
        if [[ "$operation" == commit-check ]]; then
            git diff --quiet -- Cargo.toml Cargo.lock CHANGELOG.md
        fi
        ;;
    *) echo 'usage: metadata.sh version|preflight|prepare|check|commit-check' >&2; exit 2 ;;
esac
