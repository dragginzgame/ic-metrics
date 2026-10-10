#!/usr/bin/env bash
set -euo pipefail

# Consumer adapter. Dependencies: Cargo/cargo-edit/cargo-sort, jq, yq, Git, tar, awk and Unix utilities.
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
local_lock_packages() {
    # This repository permits only workspace-owned local packages. Cargo's
    # source-less lock rows identify those packages without a second name list.
    "${YQ:-yq}" -p toml -o json '.' "$1" | jq -er '
        [.package[] | select(.source == null)] as $local |
        if any($local[]; .name == "ic-metrics") and
           all($local[]; .name | test("^[A-Za-z0-9][A-Za-z0-9_-]*$")) and
           (($local | map(.name) | unique | length) == ($local | length))
        then $local[].name else error("invalid workspace lock identities") end'
}
case "$operation" in
    version) bash "$reader" Cargo.toml ;;
    preflight)
        if ! bash "$root/scripts/ci/check-release-source.sh" \
            --allow Cargo.toml --allow Cargo.lock --allow CHANGELOG.md; then
            echo 'release preflight refused; this attempt has not started validation or version preparation' >&2
            exit 1
        fi
        current_version="$(bash "$reader" Cargo.toml)"
        [[ "$current_version" == "${RELEASE_PREVIOUS:?}" ]]
        for path in Cargo.toml Cargo.lock CHANGELOG.md; do
            [[ -f "$path" && ! -L "$path" ]]
        done
        # Refuse conflicting pending notes before a gate or preparation intent.
        awk -v version="${RELEASE_VERSION:?}" -v previous="$RELEASE_PREVIOUS" -v date="${RELEASE_DATE:?}" \
            -f scripts/ci/finalize-release-changelog.awk CHANGELOG.md > /dev/null
        cargo set-version --help >/dev/null
        tool_versions="$root/ci/tool-versions.env"
        tool_versions_digest="$(bash "$root/scripts/ci/verify-file-checksum.sh" --print sha256 "$tool_versions")"
        tool_targets=(rust-tools-check)
        case "$release_cache_prepare" in
            1)
                cargo fetch --locked
                tool_targets=(install-rust-tools rust-tools-check)
                ;;
            0) cargo fetch --locked --offline ;;
            *) echo 'invalid release cache preparation selection' >&2; exit 2 ;;
        esac
        # Source fetching does not install the pinned Cargo executables. Prepare
        # only behind normal release admission; standalone preflight stays offline.
        for target in "${tool_targets[@]}"; do
            make --no-print-directory -C "$root" "$target"
            if [[ "$(bash "$root/scripts/ci/verify-file-checksum.sh" --print sha256 "$tool_versions")" != "$tool_versions_digest" ]]; then
                echo 'selected Rust tool pins changed during release preflight' >&2
                exit 1
            fi
        done
        ;;
    prepare)
        current_version="$(bash "$reader" Cargo.toml)"
        [[ "$current_version" == "${RELEASE_PREVIOUS:?}" ]]
        backup="$(mktemp -d "${TMPDIR:-/tmp}/metrics-release-backup.XXXXXX")"
        files=(Cargo.toml Cargo.lock CHANGELOG.md)
        for path in "${files[@]}"; do
            [[ -f "$path" && ! -L "$path" ]]
            cp -p "$path" "$backup/$path"
        done
        complete=false
        cleanup() {
            local status=$? path restore_failed=false
            trap - EXIT
            if [[ "$complete" != true ]]; then
                for path in "${files[@]}"; do
                    if ! cp -p "$backup/$path" "$path"; then
                        echo "metadata restore failed: $path" >&2
                        restore_failed=true
                    fi
                done
                if [[ "$restore_failed" == true ]]; then
                    echo "metadata restoration incomplete; originals retained: $backup" >&2
                    exit 1
                fi
                echo "failed metadata preparation restored; evidence retained: $backup" >&2
            else
                rm -rf "$backup"
            fi
            exit "$status"
        }
        trap cleanup EXIT
        trap 'exit 130' INT
        trap 'exit 143' TERM
        cargo set-version --workspace --offline "${RELEASE_VERSION:?}"
        # Only root metadata changes; members were sorted by the validation gate.
        cargo sort
        # Retain registry selections; advance every workspace-owned local row.
        packages=()
        local_lock_packages "$backup/Cargo.lock" > "$backup/local-packages" || exit $?
        while IFS= read -r package; do packages+=("$package"); done < "$backup/local-packages"
        perl scripts/ci/rewrite-local-lock-versions.pl "$backup/Cargo.lock" \
            "$RELEASE_PREVIOUS" "$RELEASE_VERSION" "${packages[@]}" > "$backup/candidate.lock" || exit $?
        cp "$backup/candidate.lock" Cargo.lock
        awk -v version="$RELEASE_VERSION" -v previous="$RELEASE_PREVIOUS" -v date="${RELEASE_DATE:?}" \
            -f scripts/ci/finalize-release-changelog.awk "$backup/CHANGELOG.md" > CHANGELOG.md
        cargo metadata --locked --offline --format-version 1 >/dev/null
        current_version="$(bash "$reader" Cargo.toml)"
        [[ "$current_version" == "$RELEASE_VERSION" ]]
        complete=true
        ;;
    check|commit-check)
        metadata_root=.
        if [[ -n "${RELEASE_COMMIT:-}" ]]; then
            [[ "$RELEASE_COMMIT" =~ ^([0-9a-f]{40}|[0-9a-f]{64})$ ]]
            object_type="$(git cat-file -t "$RELEASE_COMMIT")"
            [[ "$object_type" == commit ]]
            metadata_root="$(mktemp -d "${TMPDIR:-/tmp}/metrics-committed-metadata.XXXXXX")"
            cleanup_committed_metadata() {
                local status=$?
                if [[ "$status" == 0 ]]; then
                    rm -rf "$metadata_root"
                else
                    echo "failed selected-commit metadata retained: $metadata_root" >&2
                fi
                exit "$status"
            }
            trap cleanup_committed_metadata EXIT
            # Cargo's manifest validator needs the selected workspace members
            # and targets. Export their committed tree, never newer HEAD files.
            git archive --format=tar "$RELEASE_COMMIT" Cargo.toml Cargo.lock CHANGELOG.md crates |
                tar -xf - -C "$metadata_root"
        fi
        current_version="$(bash "$reader" "$metadata_root/Cargo.toml")"
        [[ "$current_version" == "${RELEASE_VERSION:?}" ]]
        awk -v heading="## [$RELEASE_VERSION] - ${RELEASE_DATE:?}" \
            '$0 == heading { count++ } END { if (count != 1) exit 1 }' "$metadata_root/CHANGELOG.md"
        local_lock_packages "$metadata_root/Cargo.lock" > /dev/null
        "${YQ:-yq}" -p toml -o json '.' "$metadata_root/Cargo.lock" |
            jq -e --arg version "$RELEASE_VERSION" \
                'all(.package[] | select(.source == null); .version == $version)' > /dev/null
        # The runner seals prepared metadata in its staged tree. Late checks
        # inspect that selected commit, without resolving a newer HEAD's graph.
        if [[ "$metadata_root" == . ]]; then
            cargo metadata --locked --offline --format-version 1 >/dev/null
        fi
        bash "$root/scripts/ci/check-release-source.sh" \
            --allow Cargo.toml --allow Cargo.lock --allow CHANGELOG.md
        if [[ "$operation" == commit-check ]]; then
            [[ -z "${RELEASE_COMMIT:-}" ]]
            git diff --quiet -- Cargo.toml Cargo.lock CHANGELOG.md
        fi
        ;;
    *) echo 'usage: metadata.sh version|preflight|prepare|check|commit-check' >&2; exit 2 ;;
esac
