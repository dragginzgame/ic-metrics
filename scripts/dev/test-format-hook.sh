#!/usr/bin/env bash
set -euo pipefail

# Exercise the workspace formatting surfaces through the reviewed shared checker.
# Only scratch Git state changes; tools are already prepared.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# The arithmetic-only workspace has no dependency pair to reorder. Shared owns
# generic manifest sorting; this fixture retains Rust hook and failure checks.
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-format-hook.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Metrics formatting fixture retained"' EXIT
TMPDIR="$fixture" bash "$root/scripts/ci/check-formatting-hooks.sh" "$root" \
    crates/ic-metrics/src/lib.rs Cargo.toml \
    --no-dependency-tables --rust-sources Cargo.lock crates/ic-metrics/LICENSE \
    ci/tool-versions.env scripts/ci/check-format-tools.sh scripts/ci/run-formatting.sh \
    make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk
fixture_complete=true
