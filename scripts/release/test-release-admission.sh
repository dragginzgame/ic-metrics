#!/usr/bin/env bash
# Shared companions: scripts/release/admission/support.sh scripts/release/admission/cache.sh scripts/release/admission/source.sh scripts/release/admission/validation.sh
set -euo pipefail
export RELEASE_DELIVERY=direct

# Real index and actual Make/logger boundaries; only isolated fixture Git objects.
# Selected-release checks retain the actual product commit; no product Git writes.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
# Intentional logger failures and summaries belong to this fixture's inputs.
unset VALIDATION_LOG_DIR VALIDATION_FAILURE_LOG_DIR GITHUB_STEP_SUMMARY
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-release-admission.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        [[ ! -f "$fixture/result.log" ]] || cat "$fixture/result.log" >&2
    fi
    fixture_finish "$status" "$fixture" "failed admission fixture retained"
}
trap cleanup EXIT
# shellcheck source=scripts/release/admission/support.sh
source "$root/scripts/release/admission/support.sh"
# shellcheck source=scripts/release/admission/cache.sh
source "$root/scripts/release/admission/cache.sh"
# shellcheck source=scripts/release/admission/source.sh
source "$root/scripts/release/admission/source.sh"
# shellcheck source=scripts/release/admission/validation.sh
source "$root/scripts/release/admission/validation.sh"

check_cache_and_tools
check_source_admission
check_validation_adapter
echo 'release admission, cache preparation, selected-commit metadata and Make/logger retention passed (real Git/locked offline metadata; other Cargo effects and gates substituted)'
fixture_complete=true
