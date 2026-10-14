#!/usr/bin/env bash
set -euo pipefail

# Smoke the consumer's offline selected-tool dispatch, not the upstream CLI suite.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
mkdir -p "$root/target/evidence/wasm-inspector"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "$root/target/evidence/wasm-inspector/run.XXXXXX")"
printf '\000asm\001\000\000\000' > "$fixture/empty.wasm"
bash "$root/scripts/dev/wasm-inspector.sh" run "$fixture/empty.wasm" 8 0 0 0 > "$fixture/report.tsv"
# Host owns structural report semantics. Bind consumer dispatch to this input.
digest="$(bash "$root/scripts/ci/verify-file-checksum.sh" --print sha256 "$fixture/empty.wasm")"
# shellcheck disable=SC2016 # awk fields remain literal.
awk -F '\t' -v digest="$digest" '
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            if ($i == "sha256") identity = i
            if ($i == "raw_wasm_bytes") bytes = i
        }
    }
    NR == 2 { if (!identity || !bytes || $identity != digest || $bytes != 8) exit 1 }
    END { if (NR != 2) exit 1 }
' "$fixture/report.tsv"
printf 'published Wasm inspector dispatch passed; inputs retained: %s\n' "$fixture"
