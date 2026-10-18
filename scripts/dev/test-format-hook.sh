#!/usr/bin/env bash
set -euo pipefail

# Exercise both workspace formatting surfaces through the reviewed shared checker.
# Only scratch Git state changes; tools are already prepared.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# Metrics selects real dependency declarations; Shared owns permutation and hook mechanics.
# Retain the generated input alongside the shared checker's nested failure evidence.
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-format-hook.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Metrics formatting fixture retained"' EXIT
perl "$root/scripts/ci/prepare-cargo-formatting-fixture.pl" "$root/Cargo.toml" \
    workspace.dependencies ic-metrics ic-storage > "$fixture/unsorted.toml"
TMPDIR="$fixture" bash "$root/scripts/ci/check-formatting-hooks.sh" "$root" \
    crates/ic-metrics-stable/src/lib.rs Cargo.toml \
    "$fixture/unsorted.toml" --rust-sources Cargo.lock crates/ic-metrics/LICENSE \
    ci/tool-versions.env scripts/ci/check-format-tools.sh scripts/ci/run-formatting.sh \
    make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk
fixture_complete=true
