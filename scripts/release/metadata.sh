#!/usr/bin/env bash
set -euo pipefail

# Consumer adapter. Dependencies: Cargo/cargo-edit/cargo-sort, Git, awk and Unix utilities.
operation="${1:-}"
[[ $# -eq 1 ]] || exit 2
version() {
    awk '/^\[workspace.package\]$/ { package=1; next }
        /^\[/ { package=0 }
        package && /^version = "/ { gsub(/"/, "", $3); print $3; count++ }
        END { if (count != 1) exit 1 }' "${1:-Cargo.toml}"
}
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
    version) version ;;
    preflight)
        [[ "$(version)" == "${RELEASE_PREVIOUS:?}" ]]
        admit_files
        for path in Cargo.toml Cargo.lock CHANGELOG.md; do
            [[ -f "$path" && ! -L "$path" ]]
        done
        # Refuse conflicting pending notes before a gate or preparation intent.
        awk -v version="${RELEASE_VERSION:?}" -v date="${RELEASE_DATE:?}" \
            -f scripts/ci/finalize-release-changelog.awk CHANGELOG.md > /dev/null
        cargo set-version --help >/dev/null
        cargo sort --help >/dev/null
        cargo fetch --locked --offline
        ;;
    prepare)
        [[ "$(version)" == "${RELEASE_PREVIOUS:?}" ]]
        backup="$(mktemp -d "${TMPDIR:-/tmp}/metrics-release-backup.XXXXXX")"
        files=(Cargo.toml Cargo.lock CHANGELOG.md)
        for path in "${files[@]}"; do
            [[ -f "$path" && ! -L "$path" ]]
            cp -p "$path" "$backup/$path"
        done
        complete=false
        cleanup() {
            local status=$? path
            trap - EXIT
            if [[ "$complete" != true ]]; then
                for path in "${files[@]}"; do
                    cp -p "$backup/$path" "$path" || { echo "restore failed; originals: $backup" >&2; exit 1; }
                done
            fi
            rm -rf "$backup"
            exit "$status"
        }
        trap cleanup EXIT
        trap 'exit 130' INT
        trap 'exit 143' TERM
        cargo set-version --workspace --offline "${RELEASE_VERSION:?}"
        # Only root metadata changes; members were sorted by the validation gate.
        cargo sort
        # Retain every dependency selection; change this one local package only.
        awk -v previous="$RELEASE_PREVIOUS" -v version="$RELEASE_VERSION" '
            /^\[\[package\]\]$/ { owned=0 }
            /^name = "ic-metrics"$/ { owned=1 }
            owned && $0 == "version = \"" previous "\"" {
                $0="version = \"" version "\""; count++
            }
            { print }
            END { if (count != 1) exit 1 }
        ' "$backup/Cargo.lock" > Cargo.lock
        awk -v version="$RELEASE_VERSION" -v date="${RELEASE_DATE:?}" \
            -f scripts/ci/finalize-release-changelog.awk "$backup/CHANGELOG.md" > CHANGELOG.md
        cargo metadata --locked --offline --format-version 1 >/dev/null
        [[ "$(version)" == "$RELEASE_VERSION" ]]
        complete=true
        ;;
    check|commit-check)
        metadata_root=.
        if [[ -n "${RELEASE_COMMIT:-}" ]]; then
            [[ "$RELEASE_COMMIT" =~ ^([0-9a-f]{40}|[0-9a-f]{64})$ ]]
            [[ "$(git cat-file -t "$RELEASE_COMMIT")" == commit ]]
            metadata_root="$(mktemp -d "${TMPDIR:-/tmp}/metrics-committed-metadata.XXXXXX")"
            trap 'rm -rf "$metadata_root"' EXIT
            for path in Cargo.toml Cargo.lock CHANGELOG.md; do
                git show "$RELEASE_COMMIT:$path" > "$metadata_root/$path"
            done
        fi
        [[ "$(version "$metadata_root/Cargo.toml")" == "${RELEASE_VERSION:?}" ]]
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
