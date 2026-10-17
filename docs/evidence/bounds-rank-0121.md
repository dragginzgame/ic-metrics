# Bounds ownership and rank trial for 0.12.1

Baseline source is finalized 0.12.0 commit
`1c56fdfdd331e1bd26cfdb14519b1296ad3e88f0`. The retained change exposes the core's
borrowed bounds validator and reuses it in stable loading, construction and
restoration. Stable size admission still precedes expected-bound ordering and row
access; stored bytes retain independent arithmetic admission. No stored layout,
memory allocation, dependency or package version changes.

## Narrower rank candidate

The [archive](bounds-rank-0121.tar.gz) and
[checksum](bounds-rank-0121.tar.gz.sha256) freeze a bounds-only baseline and a
candidate that moves the existing histogram rank helper into the private ratio
module and reuses it for finite samples. Unlike the
[earlier trial](arithmetic-convergence-0112.md), this helper adds no fraction or
empty-count admission: both public callers keep their existing checks. The
checked u64 product fast path and exact u128 fallback remain intact.

The candidate is rejected. Histogram Wasms are byte-identical at 292,095 bytes,
with identical measured IC instructions. Samples grow from 296,026 to 296,098
raw Wasm bytes (+72). Small products improve but wide-fraction costs regress;
that trade-off does not justify replacing the existing small implementations.
Histogram and sample rank code are restored to their original locations and
calculations. Sample sorting and floating-point summation order never change.

The probe uses five observations. Deltas are candidate minus baseline per
128-call instruction bracket, reproduced across three repeats:

| Fraction | Histogram instructions | Sample instructions |
| --- | ---: | ---: |
| 1/2 | 0 | -24,832 |
| 95/100 | 0 | -24,832 |
| 1/u64::MAX | 0 | -23,424 |
| u64::MAX/u64::MAX | 0 | +10,368 |
| (u64::MAX - 1)/u64::MAX | 0 | +10,368 |
| (u64::MAX / 5)/u64::MAX | 0 | -24,576 |
| (u64::MAX / 5 + 1)/u64::MAX | 0 | +10,368 |

All 84 updates retain instruction counts, actual whole-update cycle-balance
decreases and result sinks in `results/costs.csv`. Sinks consume all projected
fields and agree between variants. Cycle readings include setup and reply work
outside the brackets; they are not inferred from instructions. These five-sample
probes do not qualify downstream workloads or native execution costs.

## Ratio disposition

The current ratio source is byte-identical to the earlier trial's baseline.
That trial's shared quotient/remainder candidates increased every measured floor
case by 128 to 256 instructions per 128 calls, including the forced-inline
attempt. Its historical source, graph and results remain at their original
identity; they are not new 0.12.1 measurements. No ratio refactor is retained.

## Frozen replay

The independent fixture uses CDK 0.20.3, Candid 0.10.38 and Testkit 0.34.2, with
its existing offline lock. Unused optional stable members retain Memory 0.35.14;
they are not compiled for these probes and do not replace the product's Memory
0.45 graph. Fixture package labels are 0.0.0, not a Metrics release selection.
Rust 1.99.0 (`b940084d7`, 2026-09-28) builds with opt-level z, LTO, one codegen
unit, stripped symbols and aborting panics, without Wasm postprocessing.
PocketIC 16.1.0's prepared executable SHA-256 is
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

After preparing those inputs, extract and run
`POCKET_IC_BIN=/absolute/path/to/pocket-ic bash replay.sh /absolute/path/to/ic-metrics/target/rank-replay`.
Replay verifies `SHA256SUMS`, rebuilds all four Wasms byte-for-byte in fresh
scratch, executes both variants on new local canisters and compares every raw
CSV row. Replay evidence is retained separately from the first execution.
The archive selects only Metrics-owned/public fixture sources and artifacts;
it excludes private sibling source, search excerpts and issue bodies. No runtime
dependency, maintained measurement endpoint or performance CI gate is added.
