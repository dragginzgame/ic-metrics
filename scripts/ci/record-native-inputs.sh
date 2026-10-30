#!/usr/bin/env bash
# Shared companions: scripts/ci/native-source-files.sh
set -euo pipefail
[[ $# == 0 ]] || { echo 'usage: record-native-inputs.sh' >&2; exit 2; }
mkdir -p target/evidence/native-ci
{
    git rev-parse HEAD
    printf 'run=%s attempt=%s event=%s\n' "$GITHUB_RUN_ID" "$GITHUB_RUN_ATTEMPT" "$GITHUB_EVENT_NAME"
    uname -s
    uname -m
} > target/evidence/native-ci/inputs.txt
bash scripts/ci/native-source-files.sh > target/evidence/native-ci/source-files.nul
while IFS= read -r -d '' file; do
    shasum -a 256 -- "$file"
done < target/evidence/native-ci/source-files.nul > target/evidence/native-ci/source-sha256.txt
