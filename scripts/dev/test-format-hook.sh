#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH

# Exercise the adopted hook and this consumer's real formatting/setup targets.
# Reuse existing objects; never create commits or touch the consumer's index.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/metrics-format-hook.XXXXXX")"
cleanup() {
    local status=$?
    if [[ "$status" != 0 && -f "$fixture/hook.log" ]]; then cat "$fixture/hook.log" >&2; fi
    rm -rf "$fixture"
    exit "$status"
}
trap cleanup EXIT
[[ "$(cargo sort --version)" == 'cargo-sort 2.1.4' ]] || {
    echo 'hook checks require prepared cargo-sort 2.1.4' >&2
    exit 1
}
source_commit="$(git -C "$root" rev-parse HEAD)"
source_objects="$(git -C "$root" rev-parse --git-path objects)"
case "$source_objects" in /*) ;; *) source_objects="$root/$source_objects" ;; esac
mkdir -p "$fixture/templates" "$fixture/repo"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TEMPLATE_DIR="$fixture/templates"
git -C "$fixture/repo" init --quiet
mkdir -p "$fixture/repo/.git/objects/info"
printf '%s\n' "$source_objects" > "$fixture/repo/.git/objects/info/alternates"
git -C "$fixture/repo" update-ref HEAD "$source_commit"
cd "$fixture/repo"
git read-tree HEAD
git checkout-index --all
mkdir -p .githooks scripts/dev
for path in Makefile Cargo.toml crates/ic-metrics/Cargo.toml crates/ic-metrics/LICENSE .githooks/pre-commit scripts/dev/install-git-hooks.sh; do
    cp "$root/$path" "$path"
    git add -- "$path"
done

# macOS temporary-directory aliases and other logical roots must work in setup.
ln -s "$fixture/repo" "$fixture/alias"
(
    cd "$fixture/alias"
    make --no-print-directory install-hooks > "$fixture/hook.log" 2>&1
)
[[ "$(git config --local --get core.hooksPath)" == .githooks ]]
make --no-print-directory install-hooks >> "$fixture/hook.log" 2>&1

lib=crates/ic-metrics/src/lib.rs
printf '\n// Scratch formatter fixture.\nfn formatter_fixture ( ) { }\n' >> "$lib"
git add -- "$lib"
printf '\nUnrelated scratch working edit.\n' >> README.md
cp README.md "$fixture/readme-before"
.githooks/pre-commit >> "$fixture/hook.log" 2>&1
cmp README.md "$fixture/readme-before"
git diff --exit-code -- "$lib"
git show ":$lib" > "$fixture/staged-lib"
cmp "$lib" "$fixture/staged-lib"
awk '$0 == "fn formatter_fixture() {}" { found=1 } END { exit !found }' "$lib"
make --no-print-directory fmt-check >> "$fixture/hook.log" 2>&1

printf '\n// Scratch unstaged change.\n' >> "$lib"
cp "$lib" "$fixture/partial-before"
git write-tree > "$fixture/index-before"
if .githooks/pre-commit >> "$fixture/hook.log" 2>&1; then
    echo 'hook accepted partial staging' >&2
    exit 1
fi
cmp "$lib" "$fixture/partial-before"
git write-tree > "$fixture/index-after"
cmp "$fixture/index-before" "$fixture/index-after"

# Failed snapshot formatting must preserve both the index and working bytes.
printf '\nfn broken ( {\n' >> "$lib"
git add -- "$lib"
cp "$lib" "$fixture/invalid-before"
git write-tree > "$fixture/index-before"
if .githooks/pre-commit >> "$fixture/hook.log" 2>&1; then
    echo 'hook accepted failed Rust formatting' >&2
    exit 1
fi
cmp "$lib" "$fixture/invalid-before"
cmp README.md "$fixture/readme-before"
git write-tree > "$fixture/index-after"
cmp "$fixture/index-before" "$fixture/index-after"
echo 'consumer hook setup, selected refresh, partial staging and formatter failure isolation passed (scratch only)'
