#!/usr/bin/env bash
set -euo pipefail

# Consumer adapter. Dependencies: Cargo/cargo-edit/cargo-sort, Git, awk and Unix utilities.
operation="${1:-}"
[[ $# -eq 1 ]] || exit 2
version() {
    awk '/^\[workspace.package\]$/ { package=1; next }
        /^\[/ { package=0 }
        package && /^version = "/ { gsub(/"/, "", $3); print $3; count++ }
        END { if (count != 1) exit 1 }' Cargo.toml
}
admit_files() {
    local paths path admitted=true
    paths="$(mktemp "${TMPDIR:-/tmp}/metrics-release-paths.XXXXXX")"
    git diff --name-only -z HEAD -- > "$paths"
    git ls-files --others --exclude-standard -z >> "$paths"
    while IFS= read -r -d '' path; do
        case "$path" in Cargo.toml|Cargo.lock|CHANGELOG.md) ;;
            *) printf 'uncommitted non-release path: %q\n' "$path" >&2; admitted=false; break ;;
        esac
    done < "$paths"
    rm -f "$paths"
    [[ "$admitted" == true ]]
}
case "$operation" in
    version) version ;;
    preflight)
        [[ "$(version)" == "${RELEASE_PREVIOUS:?}" ]]
        admit_files
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
    check)
        [[ "$(version)" == "${RELEASE_VERSION:?}" ]]
        awk -v heading="## [$RELEASE_VERSION] - ${RELEASE_DATE:?}" \
            '$0 == heading { count++ } END { if (count != 1) exit 1 }' CHANGELOG.md
        cargo metadata --locked --offline --format-version 1 >/dev/null
        admit_files
        ;;
    *) echo 'usage: metadata.sh version|preflight|prepare|check' >&2; exit 2 ;;
esac
