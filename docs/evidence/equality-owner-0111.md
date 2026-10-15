# Histogram equality ownership review for 0.11.1

The review starts at released 0.11.0 source
`d68886af183688e365338196a17b83f5d0ed050d`. Its histogram derives structural
equality; the stable adapter rejects changed overflow/aggregate values before
full equality for four or more bounds, preserving direct equality below four.

The proposed move replaces the derive with manual `PartialEq`, keeps the same
width threshold and compares every retained field. A matched IC experiment
compares that prototype with the released stable adapter's equality strategy.
The prototype is rejected and **no Rust change is retained**.

## Compatibility

A constant histogram is usable in a Rust constant pattern with the released
derive. The same source fails to compile against manual `PartialEq`: the type
is no longer structural. Native Rust 1.99 compilation demonstrates both outcomes
in the retained fixture. Equal numeric results alone do not preserve this public
contract, and moving the method would require an unnecessary API cut.

## Measured cost

The frozen equality-only harness from [the earlier checkpoint experiment](checkpoint-093.md)
uses current arithmetic source and its unchanged historical CDK 0.20.3,
Candid 0.10.38, Testkit 0.34.2 and PocketIC 16.1.0 lock. Its historical Memory
graph is not exercised. For sizes 0, 1, 4, 8 and 256, each case performs 64
black-box comparisons in three repeats, outside construction and reply encoding.

| Bounds / case | Released strategy instructions | Prototype instructions |
| --- | ---: | ---: |
| 0 / all cases | unchanged | unchanged |
| 1 / changed first bucket | 4,189 | 3,293 |
| 1 / changed overflow | 2,845 | 3,741 |
| 4 / unchanged | 117,725 | 121,821 |
| 4 / changed first bucket | 4,445 | 5,149 |
| 8 / unchanged | 224,219 | 228,315 |
| 256 / unchanged | 7,253,853 | 7,257,885 |
| 256 / changed first bucket | 4,445 | 5,149 |

Whole-fixture raw Wasm grows from 293,562 to 293,612 bytes, a 50-byte increase.
The prototype therefore also fails the cost-preservation condition. Native
compilation and tests are compatibility evidence, not IC cost measurements.
The CSV retains actual whole-update cycle charges, which include construction
and ingress; they are not isolated equality costs or instruction conversions.

## Retention and replay

The [archive](equality-owner-0111.tar.gz) and
[checksum](equality-owner-0111.tar.gz.sha256) retain both source selections,
the harness and lock, raw Wasms, instruction/cycle results and constant-pattern
source/diagnostics. Rust 1.99 uses opt-level=z, LTO, one codegen unit, stripped
symbols and abort panics, without Wasm postprocessing. The prepared server's
SHA-256 is `b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

After preparing that compiler, server and locked cache, extract the archive and
run `POCKET_IC_BIN=/path/to/pocket-ic bash replay.sh /path/to/ic-metrics/target/equality-comparison /fresh/output`.
The script checks both raw Wasms byte-for-byte, both constant-pattern outcomes,
and repeated IC instruction counts/equality results. Output and scratch remain
available for review. The earlier sandbox socket refusal and stale-cache attempt
remain locally retained under `/tmp/metrics-equality-cleanup.iG5uzt/`; neither
supplies the accepted measurements above. Freshly touching each selected source
prevents copied timestamps from admitting an older Cargo artifact.

A fresh archive extraction independently rebuilds both Wasms byte-for-byte,
reproduces the constant-pattern outcomes and repeats all recorded instruction
counts and equality results on a fresh local server.

No endpoint, public helper, dependency update, benchmark framework or performance
CI gate is added. The released fast path and stable V1 encoding remain unchanged.
