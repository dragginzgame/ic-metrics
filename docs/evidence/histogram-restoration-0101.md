# Histogram restoration consolidation

This frozen 0.10.1 preparation compares task-start arithmetic at
`63a6bd7ee79cc892f9894ab307c990520842ffc7` with the working-tree histogram
admission consolidation. The [receipt](histogram-restoration-0101.tar.gz) and
[checksum](histogram-restoration-0101.tar.gz.sha256) retain both complete arithmetic
source trees, the product patch, reference driver, probe, exact compiler identity,
structural inspection reports and focused validation logs. Public API, restored
state representation, error precedence and stable V1 layouts remain unchanged.

The constructor still admits bounds first. One private numeric admission routine
then derives count/overflow agreement, highest occupied bucket placement and the
permitted total range in the same traversal. Overflow-envelope precedence remains
ahead of finite-bucket flags; range failures follow flag admission. Zero counts,
exact caps, clipped lower bounds and a final `u64::MAX` bound retain their rules.

## Behavioral and compiler checks

An independent native driver links the frozen before/after libraries separately
and compares exact typed results for 318,456 inputs, with 976 accepted states.
Widths are 0, 1, 2, 4 and 256; cases include empty/nonempty aggregates, invalid
bounds, independent flags, count caps, wide totals and impossible maxima. Small
widths enumerate count/flag combinations; width 256 uses selected patterns.
This establishes agreement over the recorded domain, not a proof over all inputs.

All 19 histogram and ten restored-state tests pass, including a new regression
for error priority and the closed maximum bound. Three affected durable histogram
tests and the malformed-record refusal case pass on the existing incoming Memory
0.39.0 graph. Strict native/Wasm Clippy passes for both packages. Actual arithmetic
Rust 1.85 and stable Rust 1.88 checks pass on native and Wasm. Other consumer
workloads, full repository validation and hosted acceptance are separate.

## Raw Wasm comparison

The freestanding `no_std` probe exports dynamic-input restoration through the
public API. Both builds use Rust 1.99.0, edition 2024, opt-level=z, fat LTO, one
codegen unit, abort panics and stripped symbols, with no postprocessing.

| Probe | Raw Wasm bytes | SHA-256 |
| --- | ---: | --- |
| Before | 1,398 | `6a5ee30f3a420304afdbe4cfe098572594a52951bab0273f0c44fe6cb35e2588` |
| After | 1,326 | `416b27aadf8d93dd8a477b3e7eb903c14fd7c7dc09df84172f8e318f505d6668` |

The published selected Host inspector validates both modules. `rebuild.sh`
reproduces byte-identical Wasms and the complete native result count. The
72-byte reduction belongs to this probe, not a complete application or an
isolated contribution to every consumer's Wasm. This is structural Wasm evidence;
no IC instructions, cycles, execution time or native-to-IC estimate is measured.
