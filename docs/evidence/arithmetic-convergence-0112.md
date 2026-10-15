# Arithmetic convergence review for 0.11.2

The baseline is released 0.11.1 source
`98e5c2f6788d142b6d0fe3fb111f8bb8d1936632`. This review evaluates two private
refactors: a shared nearest-rank calculation for histograms and finite samples,
and shared quotient/remainder calculation for floor and nearest scaled ratios.
Both preserve the tested public results, error contracts and constant evaluation.
Both are rejected on measured cost trade-offs; **no Rust change is retained**.

## Candidates

Attempt 1 moves rank arithmetic into a private directory module, preserving the
checked `u64` fast path and exact `u128` fallback. Invalid fractions are mapped
to the existing public errors and a zero rank denotes an admitted empty set.
The ratio helper returns the floor and remainder together, sharing its overflow
admission between the two public projections.

Attempt 2 adds an explicit empty-count branch to the rank helper and forces
inlining of the ratio helper. It does not remove the regressions. The original
arithmetic remains simpler than adding further dispatch or policy to recover
each caller's previous costs. The existing histogram fast path is retained.

## IC observations

Each bracket performs 128 black-boxed public API calls, with seven cases and
three repeats. Histogram setup and argument selection precede the instruction
bracket; Candid replies follow it. Finite-sample calls include copying and sorting
the same five observations. Sinks make all returned sample statistics observable;
the driver checks identical before/after projections. Ratios include ordinary
fractions, exact wide caps, rounded-only overflow, floor overflow and denominator
zero. Rank cases cover p50, p95, maximum-width fractions and either side of the
five-sample narrow-product boundary.

| Kernel | Attempt 1 instruction delta | Attempt 2 instruction delta |
| --- | ---: | ---: |
| Histogram quantile | 0 to +256 | +512 to +768 |
| Finite sample statistics | -24,832 to +10,368 | -23,936 to +11,264 |
| Floor ratio | +128 to +256 | +128 to +256 |
| Nearest ratio | -896 to -256 | -2,432 to 0 |

These ranges are **per 128-call bracket**, not per-call or application savings.
The sample fast path helps ordinary small products, but adds work for wide
products. Sharing quotient/remainder reduces nearest-ratio work while making
every measured floor case more expensive. There is no universal improvement.

| Whole probe | Baseline raw Wasm bytes | Attempt 1 | Attempt 2 |
| --- | ---: | ---: | ---: |
| Histogram | 292,120 | 292,100 | 292,105 |
| Finite samples | 296,026 | 296,094 | 296,105 |
| Floor ratio | 291,037 | 291,036 | 291,036 |
| Nearest ratio | 291,171 | 291,158 | 291,157 |

The CSVs separately retain actual whole-update cycle-balance decreases. Those
include setup, ingress and encoding; they are not isolated arithmetic cycle costs
and are never inferred from instructions. Native checks establish behavior only.

## Frozen replay

The [archive](arithmetic-convergence-0112.tar.gz) and
[checksum](arithmetic-convergence-0112.tar.gz.sha256) contain exact baseline and
candidate sources, locked fixture graphs, twelve raw Wasms, build logs and both
raw result sets. The one-off harness reuses the earlier checkpoint's CDK 0.20.3,
Candid 0.10.38 and Testkit 0.34.2 lock. Its historical Memory graph is not
exercised and does not replace the product's selected Memory 0.41 graph.
Rust 1.99.0 uses opt-level=z, LTO, one codegen unit, stripped symbols and abort
panics, without Wasm postprocessing. PocketIC 16.1.0's prepared executable SHA-256
is `b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

After preparing that compiler, server and locked cache, extract and run
`POCKET_IC_BIN=/path/to/pocket-ic bash replay.sh /path/to/ic-metrics/target/math-convergence /fresh/output`.
A fresh extraction independently rebuilds all twelve Wasms byte-for-byte and
repeats both sets of IC instruction counts and projections on fresh local servers.
The replay deliberately refreshes copied source timestamps before each build,
so Cargo cannot qualify a previous source selection from its cache.

This adds no maintained endpoint, benchmark framework, dependency or performance
CI gate. No performance improvement is claimed for the retained product source.
