#!/usr/bin/env bash
set -euo pipefail

# This independent fixture owns its release and logger selections.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH

# Exercise the consumer's preparation boundary without release or Git effects.
# Cargo-edit is substituted; sorting and locked offline metadata use real Cargo.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/metrics-metadata-test.XXXXXX")"
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        for log in "${worktree:-}/setup.log" "${worktree:-}/result.log"; do
            if [[ -f "$log" ]]; then cat "$log" >&2 || :; fi
        done
        echo "failed metadata fixture retained: $fixture" >&2
    else
        rm -rf "$fixture"
    fi
    exit "$status"
}
trap cleanup EXIT
FIXTURE_REAL_CARGO="$(command -v cargo)"
FIXTURE_REAL_AWK="$(command -v awk)"
export FIXTURE_REAL_CARGO FIXTURE_REAL_AWK
real_bash="$(command -v bash)"
mkdir -p "$fixture/bin"
printf '#!%s\n' "$real_bash" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
set -euo pipefail
if [[ "${1:-}" == set-version ]]; then
    [[ $# -eq 4 && "$2" == --workspace && "$3" == --offline && "$4" == "$RELEASE_VERSION" ]]
    awk -v version="$4" '/^version = / { $0="version = \"" version "\"" } { print }' Cargo.toml > Cargo.toml.fixture
    mv Cargo.toml.fixture Cargo.toml
else
    if [[ "${1:-}" == "${FIXTURE_FAIL_STEP:-}" ]]; then
        printf '%s\n' "$1" > failure-reached
        exit 9
    fi
    exec "$FIXTURE_REAL_CARGO" "$@"
fi
CARGO
chmod +x "$fixture/bin/cargo"
printf '#!%s\n' "$real_bash" > "$fixture/bin/git"
cat >> "$fixture/bin/git" <<'GIT'
set -euo pipefail
case "$*" in
    'diff --cached --name-only -z HEAD --'|'diff --name-only -z --'|'ls-files --others --exclude-standard -z') ;;
    *) echo 'unexpected fixture Git operation' >&2; exit 99 ;;
esac
GIT
chmod +x "$fixture/bin/git"
printf '#!%s\n' "$real_bash" > "$fixture/bin/awk"
cat >> "$fixture/bin/awk" <<'AWK'
set -euo pipefail
if [[ "$1" == '/^\[workspace.package\]$/'* ]]; then
    actual="$("$FIXTURE_REAL_AWK" "$@")"
    printf '%s\n' "$actual"
    if [[ "$actual" == "${FIXTURE_FAIL_VERSION:-}" ]]; then exit 43; fi
else
    exec "$FIXTURE_REAL_AWK" "$@"
fi
AWK
chmod +x "$fixture/bin/awk"
export PATH="$fixture/bin:$PATH" CARGO_NET_OFFLINE=true
export RELEASE_PREVIOUS=0.1.1 RELEASE_VERSION=0.1.2 RELEASE_DATE=2026-10-05

for scenario in prepared sort metadata lock conflicting-notes version-before version-after; do
    worktree="$fixture/$scenario"
    mkdir -p "$worktree/crates/ic-metrics/src" "$worktree/target" "$worktree/originals" "$worktree/scripts/ci" "$worktree/attempts"
    cp "$root/scripts/ci/finalize-release-changelog.awk" "$worktree/scripts/ci/"
    cp "$root/scripts/ci/rewrite-local-lock-versions.pl" "$worktree/scripts/ci/"
    cd "$worktree"
    export CARGO_TARGET_DIR="$worktree/target" FIXTURE_FAIL_STEP="" FIXTURE_FAIL_VERSION="" TMPDIR="$worktree/attempts"
    cat > Cargo.toml <<'TOML'
[workspace]
members = ["crates/ic-metrics"]
resolver = "3"

[workspace.package]
version = "0.1.1"
edition = "2024"
TOML
    cat > crates/ic-metrics/Cargo.toml <<'TOML'
[package]
name = "ic-metrics"
version.workspace = true
edition.workspace = true
TOML
    printf '#![no_std]\n' > crates/ic-metrics/src/lib.rs
    cat > CHANGELOG.md <<'NOTES'
# Changelog

## [0.1.2]

- Preserve the pending note.

## [0.1.1] - 2026-10-05

- Preserve historical notes.
NOTES
    if [[ "$scenario" == conflicting-notes ]]; then
        sed 's/\[0.1.2\]/[0.9.9]/' CHANGELOG.md > conflicting.md
        mv conflicting.md CHANGELOG.md
    fi
    cargo generate-lockfile --offline > setup.log 2>&1
    cargo sort --workspace >> setup.log 2>&1
    if [[ "$scenario" == lock ]]; then
        sed 's/version = "0.1.1"/version = "0.1.0"/' Cargo.lock > mismatch.lock
        mv mismatch.lock Cargo.lock
    fi
    cp Cargo.toml Cargo.lock CHANGELOG.md originals/
    cp crates/ic-metrics/Cargo.toml originals/member.toml
    printf 'retained fixture artifact\n' > target/evidence
    cp target/evidence originals/evidence
    case "$scenario" in
        sort|metadata) export FIXTURE_FAIL_STEP="$scenario" ;;
        version-before) export FIXTURE_FAIL_VERSION="$RELEASE_PREVIOUS" ;;
        version-after) export FIXTURE_FAIL_VERSION="$RELEASE_VERSION" ;;
    esac
    if [[ "$scenario" == prepared ]]; then
        bash "$root/scripts/release/metadata.sh" prepare > result.log 2>&1
        status=0
        FIXTURE_FAIL_VERSION="$RELEASE_VERSION" bash "$root/scripts/release/metadata.sh" check \
            > failed-check.log 2>&1 || status=$?
        [[ "$status" == 43 ]]
        bash "$root/scripts/release/metadata.sh" check >> result.log 2>&1
        cargo sort --workspace --check >> result.log 2>&1
        [[ "$(bash "$root/scripts/release/metadata.sh" version)" == "$RELEASE_VERSION" ]]
        awk -v heading="## [$RELEASE_VERSION] - $RELEASE_DATE" \
            '$0 == heading { found=1 } END { exit !found }' CHANGELOG.md
        awk '/^## \[0.1.1\]/ { history=1 } history' CHANGELOG.md > history-after
        awk '/^## \[0.1.1\]/ { history=1 } history' originals/CHANGELOG.md > history-before
        cmp history-before history-after
        awk '$0 == "- Preserve the pending note." { found=1 } END { exit !found }' CHANGELOG.md
    else
        if [[ "$scenario" == version-before ]]; then
            status=0
            bash "$root/scripts/release/metadata.sh" preflight > failed-preflight.log 2>&1 || status=$?
            [[ "$status" == 43 ]]
        fi
        status=0
        bash "$root/scripts/release/metadata.sh" prepare > result.log 2>&1 || status=$?
        if [[ "$status" == 0 ]]; then
            echo "metadata fixture unexpectedly accepted $scenario" >&2
            exit 1
        fi
        case "$scenario" in sort|metadata) [[ "$(cat failure-reached)" == "$scenario" ]] ;; esac
        for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "originals/$path" "$path"; done
        if [[ "$scenario" == version-* ]]; then
            [[ "$status" == 43 ]]
            if [[ "$scenario" == version-before ]]; then
                for remaining in attempts/*; do [[ ! -e "$remaining" ]]; done
            else
                set -- attempts/metrics-release-backup.*
                [[ $# == 1 && -f "$1/candidate.lock" ]]
                for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "originals/$path" "$1/$path"; done
            fi
        fi
        if [[ "$scenario" == lock ]]; then
            grep -F 'local package version mismatch: ic-metrics' result.log >/dev/null
            set -- attempts/metrics-release-backup.*
            [[ $# == 1 && -f "$1/Cargo.lock" && -f "$1/candidate.lock" && ! -s "$1/candidate.lock" ]]
            cmp originals/Cargo.lock "$1/Cargo.lock"
        fi
    fi
    cmp originals/member.toml crates/ic-metrics/Cargo.toml
    cmp originals/evidence target/evidence
done
echo 'release metadata preparation and failure restoration passed (Cargo-edit and Git substituted)'
