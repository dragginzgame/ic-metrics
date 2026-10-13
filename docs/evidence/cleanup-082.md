# Current-contract cleanup for pending 0.8.2

The requested full cleanup reviews arithmetic, the optional durable adapter,
private inspector, product tests, owned release/hook/evidence tooling and current
README/integration/host/handoff documentation. It follows the adopted
[code-hygiene](../../audits/code-hygiene.md),
[flow-convergence](../../audits/flow-convergence-and-duplication.md) and
[authorized cleanup](../../audits/module-cleanup.md) methods at Shared Tooling
`7e55adecf6f0b196c050f104b37f8c69b6bf434e`, with the local allocation, numeric
quality, identity and ownership overlay. The baseline is the incoming dirty tree
on released HEAD `368f2dca9a46faa639c3074ee45fc76d89b443e7`; source bytes distinguish
this cleanup from the earlier counter, dependency and snapshot batches.

Current host/extraction guides previously repeated historical release and reader
qualification, raw-helper semantics and older queued/cancelled observations.
They now state the current contract and route history to its existing owners.
README cost guidance and the handoff likewise retain current decisions and link
source-bound evidence instead of repeating timelines. Previous guides are retained
verbatim; changelog history and all existing evidence reports/archives stay intact.

Two duplicate arithmetic test obligations are retired: a comparison of two APIs
sharing the same addition implementation, and a second recording/constant test
now covered by the existing summary projection test. Known-answer, boundary,
constant, restoration, independent oracle and storage corruption checks remain.
Histogram and summary saturation fixtures use public validated restoration rather
than inconsistent private field mutations. Stale names and a positive fixture for
unsupported newline checkout paths are corrected; spaces and relative/absolute
helper resolution remain covered. Release recovery, jobserver, hook and evidence
fixtures protect current effects and are retained.

The durable error formatter uses one exhaustive match, removing an unreachable
nested arm while preserving variants, display text and typed causes. Quantile
queries use the aggregate's admitted count quality instead of rescanning bucket
flags: recording and merging carry every bucket's count loss into the aggregate,
and restoration refuses disagreement. Prefix cumulative counts retain their
independent bucket checks because later loss does not invalidate an exact prefix.
Public signatures, ranges, typed failures, encoded bytes, allocation, endpoints
and consumer policy remain unchanged.
Product boundaries remain separately owned; shared snapshot files are unmodified.

## Quantile invariant and Wasm shape

Existing record/merge and restored-state tests protect the count-quality invariant.
Restoration additionally rejects finite/overflow bucket loss paired with an exact
aggregate count. All 19 histogram and nine state tests pass, as do denied-warning
native/Wasm Clippy. The initial cleanup slice's full CI/floors pass before this
query simplification; the final source requires its own complete gate below.

A private dependency-free four-bound probe compiles the incoming core and final
candidate with Rust 1.99.0, edition 2024, opt-level=z, fat LTO, one codegen unit,
stripped symbols and panic abort. Query state/fractions pass through `black_box`;
recording is checked separately. Bounded structural inspection verifies every
artifact hash and raw size. Recording modules are byte-identical at 764 bytes;
the query module falls from 2,675 to 2,618 bytes. These are raw standalone Wasm
module observations, not canister measurements, instruction/cycle estimates,
mainnet savings or whole-consumer footprints. No module is executed or optimized
after compilation. The frozen build script, sources, compiler, Wasms and reports
retain the exact comparison scope.

The earlier [counter](counter-082.md), [tooling](adoption-082-shared-0910.md) and
[released native receipts](release-081.md) retain their original source scope.
Dependencies/pins and package metadata remain unchanged; pending notes stay 0.8.2.
The incoming lock already selects Host 0.15.2, unlike the earlier 0.15.1 receipt;
the cleanup preserves and qualifies its actual selection with Memory 0.35.19.
No sibling file, real Git index/ref, version or release/publication is mutated.

## Delivery and retention

Final `make ci` passes in 261 seconds, including 50 arithmetic tests and eight
doctests. Arithmetic Rust 1.85 native/Wasm, stable Rust 1.88 native/Wasm and
private inspector Rust 1.88 native gates pass. Both initial and final slices
retain eight matching 140-input checkpoints with their own source copies;
neither qualification is relabelled as the other. All package metadata,
dependency/pin inputs, real index and HEAD remain exact. This is local Linux
qualification; pending macOS and owning consumer acceptance remain separate.

The [frozen receipt](cleanup-082.tar.gz) and [checksum](cleanup-082.tar.gz.sha256)
retain the before/after guides and sources, both complete gates, focused checks,
raw Wasm comparison and replay, and source verification. Earlier guide text is
under `before/docs/hosts.md`, `before/docs/extraction.md` and
`before/docs/status/current.md`. All existing evidence and finalized changelog
history retain their original bytes. Fresh extraction verifies payload/source
hashes, both checkpoint sets and byte-identical Wasm replay.

To rebuild the standalone modules from an extracted receipt, use a fresh output
directory under this repository's `target/` and the prepared Rust 1.99 toolchain:

```sh
bash wasm-shape/build.sh before/crates/ic-metrics/src source/crates/ic-metrics/src /absolute/metrics/target/evidence/cleanup-rebuild
```

Compare all four `.wasm` files with the recorded `wasm-shape/{baseline,candidate}`
artifacts. This compiles only the frozen dependency-free core/probe and performs
no canister execution, downloads or graph changes. The public error-surface
investigation remains in [#69](https://github.com/dragginzgame/ic-metrics/issues/69);
its API removal is outside the compatible cleanup.
