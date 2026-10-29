#!/usr/bin/env bash
# Shared companions: scripts/ci/collect-native-diagnostics.sh scripts/ci/package-native-recovery-evidence.sh ci/tool-versions.env ci/ic-tools.tsv
set -euo pipefail
[[ $# == 0 ]] || { echo 'usage: collect-native-evidence.sh (workflow outcomes in environment)' >&2; exit 2; }
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
cd "$root"
mkdir -p target/evidence/native-ci
# Project only logs belonging to an action that actually ran.
case "$TOOLS_OUTCOME" in
    success|failure|cancelled)
        if [[ -f "$RUNNER_TEMP/tools-install.log" ]]; then
            cp "$RUNNER_TEMP/tools-install.log" target/evidence/native-ci/tools-setup.log
        fi
        if [[ -f "$RUNNER_TEMP/tools-check.log" ]]; then
            cp "$RUNNER_TEMP/tools-check.log" target/evidence/native-ci/tools-check.log
        fi ;;
esac
git rev-parse HEAD > target/evidence/native-ci/source-commit.txt
printf 'native=%s\ninputs=%s\ntools=%s\nhost=%s\ntoolchain=%s\nprerequisites=%s\nhost_tools=%s\ntool_inputs=%s\napplication_sources=%s\n' \
    "$NATIVE_OUTCOME" "$INPUT_OUTCOME" "$TOOLS_OUTCOME" \
    "$HOST_OUTCOME" "$TOOLCHAIN_OUTCOME" \
    "$PREREQUISITES_OUTCOME" "$HOST_TOOLS_OUTCOME" "$TOOL_INPUT_OUTCOME" "$APPLICATION_OUTCOME" \
    > target/evidence/native-ci/outcome.txt
# Keep the sanitized diagnostic roster separate from full recovery custody.
collection_status=0
collection_outcome="$TOOLS_OUTCOME"
if [[ "$HOST_TOOLS_OUTCOME" == failure ]]; then collection_outcome=failure; fi
bash scripts/ci/collect-native-diagnostics.sh \
    "$PWD" "$PWD/target/evidence/native-ci" target/evidence/native-diagnostics.tar.gz \
    "${RUNNER_TEMP:-${TMPDIR:-/tmp}}" "$collection_outcome" \
    "$PWD/ci/tool-versions.env" "$PWD/ci/ic-tools.tsv" \
    inputs.txt source-commit.txt source-files.nul source-sha256.txt outcome.txt \
    prerequisites.log host-tools.log tools-setup.log tools-check.log tool-versions.txt application-sources.log native-ci.log || collection_status=$?
# Attempt recovery packaging even after collection fails, preserving the first error.
archive_status=0
bash scripts/ci/package-native-recovery-evidence.sh \
    target/evidence/native-ci target/evidence/native-ci.tar.gz || archive_status=$?
if [[ "$archive_status" != 0 ]]; then
    printf 'Native recovery archive failed (exit %s)\n' "$archive_status" >&2
fi
if [[ "$collection_status" != 0 ]]; then exit "$collection_status"; fi
exit "$archive_status"
