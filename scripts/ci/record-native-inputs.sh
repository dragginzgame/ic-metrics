#!/usr/bin/env bash
# Shared companions: scripts/ci/native-source-files.sh
set -euo pipefail
[[ $# -le 1 ]] || { echo 'usage: record-native-inputs.sh [EVIDENCE-DIRECTORY]' >&2; exit 2; }
evidence="${1:-target/evidence/native-ci}"
mkdir -p "$evidence"
{
    git rev-parse HEAD
    printf 'run=%s attempt=%s event=%s\n' "$GITHUB_RUN_ID" "$GITHUB_RUN_ATTEMPT" "$GITHUB_EVENT_NAME"
    uname -s
    uname -m
} > "$evidence/inputs.txt"
bash scripts/ci/native-source-files.sh > "$evidence/source-files.nul"
while IFS= read -r -d '' file; do
    shasum -a 256 -- "$file"
done < "$evidence/source-files.nul" > "$evidence/source-sha256.txt"
