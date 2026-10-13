#!/usr/bin/env bash
set -euo pipefail

# Smoke the consumer's offline selected-tool dispatch, not the upstream CLI suite.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
mkdir -p "$root/target/evidence/wasm-inspector"
fixture="$(mktemp -d "$root/target/evidence/wasm-inspector/run.XXXXXX")"
printf '\000asm\001\000\000\000' > "$fixture/empty.wasm"
bash "$root/scripts/dev/wasm-inspector.sh" run "$fixture/empty.wasm" 8 0 0 0 > "$fixture/report.tsv"
[[ "$(wc -l < "$fixture/report.tsv")" == 2 ]]
# All facts correspond to the exact admitted empty module, including its digest.
digest="$(bash "$root/scripts/ci/verify-file-checksum.sh" --print sha256 "$fixture/empty.wasm")"
printf '%s\t8\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\n' "$digest" > "$fixture/expected-row.tsv"
tail -n 1 "$fixture/report.tsv" > "$fixture/actual-row.tsv"
cmp "$fixture/expected-row.tsv" "$fixture/actual-row.tsv"
printf 'published Wasm inspector dispatch passed; inputs retained: %s\n' "$fixture"
