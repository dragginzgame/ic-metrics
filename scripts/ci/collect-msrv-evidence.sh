#!/usr/bin/env bash
# Shared companions: scripts/ci/archive-evidence.sh scripts/ci/verify-file-checksum.sh
set -euo pipefail
[[ $# == 0 ]] || { echo 'usage: collect-msrv-evidence.sh (workflow outcomes in environment)' >&2; exit 2; }
evidence=target/evidence/msrv-ci
output=target/evidence/msrv-ci.tar.gz
mkdir -p "$evidence"
printf 'inputs=%s\nhost_tools=%s\ntoolchain=%s\napplication_sources=%s\nmsrv=%s\n' \
    "$INPUT_OUTCOME" "$HOST_TOOLS_OUTCOME" "$TOOLCHAIN_OUTCOME" "$APPLICATION_SOURCES_OUTCOME" "$MSRV_OUTCOME" > "$evidence/outcome.txt"
# This job owns the dedicated evidence root: source records, setup logs, shared
# validation logs/scratch and the artifact captured immediately after linking.
[[ ! -e "$output.sha256" && ! -L "$output.sha256" ]] || exit 2
bash scripts/ci/archive-evidence.sh "$output" "$evidence" .
(set -C; bash scripts/ci/verify-file-checksum.sh --print sha256 "$output" > "$output.sha256")
