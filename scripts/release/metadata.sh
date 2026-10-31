#!/usr/bin/env bash
# Shared companions: scripts/ci/cargo-release-group.sh scripts/ci/cargo-release-metadata.sh scripts/ci/check-release-source.sh scripts/ci/check-release-delivery.sh scripts/ci/check-release-changelog.sh scripts/ci/cargo-release-preflight.sh scripts/ci/release-receipts.sh scripts/dev/release-editor.sh ci/tool-versions.env ci/release-delivery.txt ci/release-tools.env
set -euo pipefail
[[ $# == 1 ]] || exit 2
operation="$1"
case "$operation" in selection|files|version|plan|packages|preflight|verify|prepare|check|commit-check) ;; *) exit 2 ;; esac
release_cache_prepare="${IC_METRICS_RELEASE_CACHE_PREPARE:-0}"
unset IC_METRICS_RELEASE_CACHE_PREPARE
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
if [[ -z "${RELEASE_GROUP:-}" ]]; then
    echo 'Select RELEASE_GROUP explicitly; see ci/cargo-release-groups.json' >&2
    exit 2
fi
export RELEASE_GROUP
if ! jq -e --arg group "$RELEASE_GROUP" '[.groups[] | select(.name == $group)] | length == 1' \
    "$root/ci/cargo-release-groups.json" > /dev/null; then
    echo 'Unknown RELEASE_GROUP; see ci/cargo-release-groups.json' >&2
    exit 2
fi
[[ "$operation" != selection ]] || exit 0
bash "$root/scripts/ci/check-release-delivery.sh" "$root/ci/release-delivery.txt" "${RELEASE_DELIVERY-direct}"
# Initial admission precedes Cargo, tooling preparation and validation effects.
if [[ "$operation" == preflight || "$operation" == verify ]]; then
    bash "$root/scripts/ci/check-release-source.sh"
fi
if [[ "$operation" == packages ]]; then unset RELEASE_COMMIT; fi
plan="$(bash "$root/scripts/ci/cargo-release-group.sh" plan "$RELEASE_GROUP")"
primary="$(printf '%s' "$plan" | jq -er .primary)"
changelog="$(printf '%s' "$plan" | jq -er .changelog)"
files=()
while IFS= read -r -d '' path; do files+=("$path"); done < <(printf '%s' "$plan" | jq -jr '.files[] | . + "\u0000"')
source_arguments=()
for path in "${files[@]}"; do source_arguments+=(--allow "$path"); done
case "$operation" in
    plan) printf '%s\n' "$plan"; exit ;;
    packages) printf '%s' "$plan" | jq -er '.members | join(" ")'; exit ;;
    files) printf '%s\0' "${files[@]}"; exit ;;
    version) printf '%s' "$plan" | jq -er .previous; exit ;;
esac
# shellcheck source=scripts/ci/release-receipts.sh
source "$root/scripts/ci/release-receipts.sh"
perl "$root/scripts/ci/validate-release-inputs.pl" version "${RELEASE_VERSION:?}" > /dev/null
state="$(git rev-parse --git-path release-state)/$RELEASE_GROUP-$RELEASE_VERSION"
metadata() {
    bash "$root/scripts/ci/cargo-release-metadata.sh" "$1" "$primary" ${2:+"$2"}
}
prepared() {
    release_receipt_check "$state/validated" release_receipt_identity
    metadata check --manifest-order-grouped
    release_receipt_check "$state/prepared" release_receipt_payload "${RELEASE_COMMIT:-}" "${files[@]}"
}
case "$operation" in
    preflight)
        [[ "$(printf '%s' "$plan" | jq -er .previous)" == "${RELEASE_PREVIOUS:?}" ]]
        bash "$root/scripts/ci/check-release-changelog.sh" "$RELEASE_VERSION" "$RELEASE_PREVIOUS" "${RELEASE_DATE:?}" "$changelog"
        bash "$root/scripts/ci/cargo-release-preflight.sh" "$PWD" "$release_cache_prepare" \
            --pin "${RUST_TOOL_VERSIONS:-$root/ci/tool-versions.env}" --pin "$root/ci/release-tools.env" \
            --check rust-tools-check --check release-editor-check \
            --prepare install-rust-tools --prepare rust-tools-check \
            --prepare install-release-editor --prepare release-editor-check
        ;;
    verify)
        mkdir -p "$state"
        release_receipt_archive "$state/previous-attempt.XXXXXX" "$state/validated" "$state/prepared"
        VALIDATION_FAILURE_LOG_DIR="$(git rev-parse --git-path release-state)/validation-failures" \
            CARGO_NET_OFFLINE=true bash "$root/scripts/ci/run-validation-targets.sh" \
            --fail-fast --input Cargo.toml --input Cargo.lock ci msrv
        bash "$root/scripts/ci/check-release-source.sh"
        release_receipt_write "$state/validated" release_receipt_identity
        ;;
    prepare)
        release_receipt_check "$state/validated" release_receipt_identity
        bash "$root/scripts/ci/check-release-source.sh"
        CARGO_RELEASE_METADATA_EDITOR="$("${RELEASE_MAKE:-make}" --no-print-directory -s release-editor-check)"
        export CARGO_RELEASE_METADATA_EDITOR
        # shellcheck source=ci/release-tools.env
        source "$root/ci/release-tools.env"
        export CARGO_RELEASE_METADATA_MAX_BYTES="$IC_METRICS_RELEASE_METADATA_MAX_BYTES"
        metadata prepare
        release_receipt_write "$state/prepared" release_receipt_payload '' "${files[@]}"
        ;;
    check|commit-check)
        if [[ "$operation" == commit-check ]]; then [[ -z "${RELEASE_COMMIT:-}" ]]; fi
        prepared
        bash "$root/scripts/ci/check-release-source.sh" "${source_arguments[@]}"
        if [[ "$operation" == commit-check ]]; then git diff --quiet -- "${files[@]}"; fi
        ;;
esac
