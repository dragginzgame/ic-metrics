#!/usr/bin/env bash
set -euo pipefail

# Consumer integration only. Shared Tooling owns generic metadata failure cases.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
export RELEASE_DELIVERY=direct
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-metadata-test.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        for log in "${worktree:-}/setup.log" "${worktree:-}/preflight.log" "${worktree:-}/result.log"; do
            if [[ -f "$log" ]]; then cat "$log" >&2 || :; fi
        done
    fi
    fixture_finish "$status" "$fixture" "failed metadata fixture retained"
}
trap cleanup EXIT
real_bash="$(command -v bash)"
mkdir -p "$fixture/bin"
printf '#!%s\n' "$real_bash" > "$fixture/bin/git"
cat >> "$fixture/bin/git" <<'GIT'
case "$*" in
    'rev-parse --show-prefix'|'status --porcelain=v1 -z --untracked-files=all') ;;
    *) echo 'unexpected fixture Git operation' >&2; exit 99 ;;
esac
GIT
chmod +x "$fixture/bin/git"
printf '#!%s\n' "$real_bash" > "$fixture/bin/make"
cat >> "$fixture/bin/make" <<'MAKE'
[[ $# == 4 && "$1" == --no-print-directory && "$2" == -C && ( "$4" == rust-tools-check || "$4" == wasm-inspector-tools-check ) ]] || exit 1
MAKE
chmod +x "$fixture/bin/make"
export PATH="$fixture/bin:$PATH" CARGO_NET_OFFLINE=true
export RELEASE_PREVIOUS=0.1.1 RELEASE_VERSION=0.1.2 RELEASE_DATE=2026-10-05
worktree="$fixture/version-input"
mkdir -p "$worktree"
cd "$worktree"
printf "[workspace.package]\nversion = '0.1.1' # inline comment\n" > Cargo.toml
cp Cargo.toml original.toml
[[ "$(bash "$root/scripts/release/metadata.sh" version)" == "$RELEASE_PREVIOUS" ]] || exit 1
cmp original.toml Cargo.toml
bootstrap="$fixture/checkout with spaces"
mkdir -p "$bootstrap/scripts/release" "$bootstrap/scripts/ci"
cp "$root/scripts/release/metadata.sh" "$bootstrap/scripts/release/"
cp "$root/scripts/ci/read-cargo-workspace-version.sh" "$bootstrap/scripts/ci/"
cp original.toml "$bootstrap/Cargo.toml"
for entry in scripts/release/metadata.sh "$bootstrap/scripts/release/metadata.sh"; do
    actual="$(cd "$bootstrap"; CDPATH="$fixture:$root" bash "$entry" version)"
    [[ "$actual" == "$RELEASE_PREVIOUS" ]] || exit 1
done
cmp original.toml "$bootstrap/Cargo.toml"
worktree="$fixture/prepared"
mkdir -p "$worktree/crates/ic-metrics/src" "$worktree/crates/ic-metrics-stable/src" "$worktree/target" "$worktree/originals" "$worktree/scripts/ci" "$worktree/attempts"
cp "$root/scripts/ci/finalize-release-changelog.awk" "$worktree/scripts/ci/"
cd "$worktree"
export CARGO_TARGET_DIR="$worktree/target" TMPDIR="$worktree/attempts"
cat > Cargo.toml <<'TOML'
[workspace]
members = ["crates/ic-metrics", "crates/ic-metrics-stable"]
resolver = "3"
[workspace.package]
version = "0.1.1"
edition = "2024"
[workspace.dependencies]
ic-metrics = { version = "0.1", path = "crates/ic-metrics" }
TOML
for package in ic-metrics ic-metrics-stable; do
    cat > "crates/$package/Cargo.toml" <<TOML
[package]
name = "$package"
version.workspace = true
edition.workspace = true
TOML
    printf '#![no_std]\n' > "crates/$package/src/lib.rs"
done
printf '\n[dependencies]\nic-metrics.workspace = true\n' >> crates/ic-metrics-stable/Cargo.toml
printf '# Changelog\n\n## [0.1.2]\n\n- Consumer note.\n\n## [0.1.1] - 2026-10-05\n\n- Previous.\n' > CHANGELOG.md
cargo generate-lockfile --offline > setup.log 2>&1
cargo sort --workspace >> setup.log 2>&1
cp Cargo.toml Cargo.lock CHANGELOG.md originals/
printf 'retained fixture artifact\n' > target/evidence
cp target/evidence originals/evidence
bash "$root/scripts/release/metadata.sh" preflight > preflight.log 2>&1
bash "$root/scripts/release/metadata.sh" prepare > result.log 2>&1
bash "$root/scripts/release/metadata.sh" check >> result.log 2>&1
cargo metadata --locked --offline --format-version 1 | jq -r \
    '.packages[] | select(.source == null) | [.name,.version] | @tsv' | LC_ALL=C sort > actual-packages
printf 'ic-metrics\t0.1.2\nic-metrics-stable\t0.1.2\n' > expected-packages
cmp expected-packages actual-packages
# Keep the real two-package consumer boundary independent of upstream toy names.
cp Cargo.lock prepared.lock
awk '/^\[\[package\]\]$/ { adapter=0 }
     $0 == "name = \"ic-metrics-stable\"" { adapter=1 }
     adapter && /^version = / { $0="version = \"0.1.1\"" } { print }' prepared.lock > Cargo.lock
cp Cargo.lock stale.lock
if bash "$root/scripts/release/metadata.sh" check > stale-check.log 2>&1; then
    echo 'stale stable adapter was admitted' >&2; exit 1
fi
cmp stale.lock Cargo.lock
cp prepared.lock Cargo.lock
bash "$root/scripts/release/metadata.sh" check >> result.log 2>&1
cmp originals/evidence target/evidence
echo 'Metrics coordinated-package metadata delegation passed (Git/Make substituted; offline Cargo metadata real)'
fixture_complete=true
