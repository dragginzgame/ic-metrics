#!/usr/bin/env bash
set -euo pipefail

# Consumer adapter. Dependencies: Cargo/cargo-edit/cargo-sort, jq, yq, Git, awk and Unix utilities.
operation="${1:-}"
[[ $# -eq 1 ]] || exit 2
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
reader="$root/scripts/ci/read-cargo-workspace-version.sh"
admit_files() (
    local paths path admitted=true
    paths="$(mktemp "${TMPDIR:-/tmp}/metrics-release-paths.XXXXXX")"
    trap 'rm -f "$paths"' EXIT
    # Staged content can differ even when working bytes have returned to HEAD.
    git diff --cached --name-only -z HEAD -- > "$paths"
    git diff --name-only -z -- >> "$paths"
    git ls-files --others --exclude-standard -z >> "$paths"
    while IFS= read -r -d '' path; do
        case "$path" in Cargo.toml|Cargo.lock|CHANGELOG.md) ;;
            *) printf 'uncommitted non-release path: %q\n' "$path" >&2; admitted=false; break ;;
        esac
    done < "$paths"
    [[ "$admitted" == true ]]
)
case "$operation" in
    version) bash "$reader" Cargo.toml ;;
    preflight)
        current_version="$(bash "$reader" Cargo.toml)"
        [[ "$current_version" == "${RELEASE_PREVIOUS:?}" ]]
        admit_files
        for path in Cargo.toml Cargo.lock CHANGELOG.md; do
            [[ -f "$path" && ! -L "$path" ]]
        done
        # Refuse conflicting pending notes before a gate or preparation intent.
        awk -v version="${RELEASE_VERSION:?}" -v previous="$RELEASE_PREVIOUS" -v date="${RELEASE_DATE:?}" \
            -f scripts/ci/finalize-release-changelog.awk CHANGELOG.md > /dev/null
        cargo set-version --help >/dev/null
        cargo sort --help >/dev/null
        cargo fetch --locked --offline
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
        # Retain every dependency selection; change this one local package only.
        perl scripts/ci/rewrite-local-lock-versions.pl "$backup/Cargo.lock" \
            "$RELEASE_PREVIOUS" "$RELEASE_VERSION" ic-metrics > "$backup/candidate.lock" || exit $?
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
            for path in Cargo.toml Cargo.lock CHANGELOG.md; do
                git show "$RELEASE_COMMIT:$path" > "$metadata_root/$path"
            done
        fi
        current_version="$(bash "$reader" "$metadata_root/Cargo.toml")"
        [[ "$current_version" == "${RELEASE_VERSION:?}" ]]
        awk -v heading="## [$RELEASE_VERSION] - ${RELEASE_DATE:?}" \
            '$0 == heading { count++ } END { if (count != 1) exit 1 }' "$metadata_root/CHANGELOG.md"
        awk -v expected="$RELEASE_VERSION" '
            /^\[\[package\]\]$/ { owned=0 }
            /^name = "ic-metrics"$/ { owned=1 }
            owned && /^version = / {
                if ($0 != "version = \"" expected "\"") exit 1
                count++
            }
            END { if (count != 1) exit 1 }
        ' "$metadata_root/Cargo.lock"
        # The runner seals prepared metadata in its staged tree. Late checks
        # inspect that selected commit, without resolving a newer HEAD's graph.
        if [[ "$metadata_root" == . ]]; then
            cargo metadata --locked --offline --format-version 1 >/dev/null
        fi
        admit_files
        if [[ "$operation" == commit-check ]]; then
            [[ -z "${RELEASE_COMMIT:-}" ]]
            git diff --quiet -- Cargo.toml Cargo.lock CHANGELOG.md
        fi
        ;;
    *) echo 'usage: metadata.sh version|preflight|prepare|check|commit-check' >&2; exit 2 ;;
esac
