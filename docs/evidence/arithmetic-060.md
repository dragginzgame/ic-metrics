# Pending 0.6.0 arithmetic hard cut

This local batch is authorized against released Metrics 0.5.6
`392d1e2cbffb434dea591df8cb3165e8c625ab01`. The single pending changelog is
0.6.0 because histogram projection and tracked saturation semantics break the
public contract. Package/workspace versions remain 0.5.6; no release is executed.
[#57](https://github.com/dragginzgame/ic-metrics/issues/57) owns delivery and
source-bound native acceptance separately from the local implementation.

## Current source contract

`MeasurementAggregate` retains count, total, maximum and sticky independent
actual-overflow flags. Exact caps remain usable; overflow clips values without
pretending lost observations are exact. `merge` adds batches without ordering or
deduplication. Empty and measured zero remain distinct. `MeasurementSummary`
retains the latest ordered observation separately and projects its aggregate;
ordered summaries cannot merge. Storage remains fixed, dependency-free and
`no_std`; there is no wider total, registry, reader or attribution mode.

Histograms retain one aggregate, disjoint counts and independent overflow flags.
The public projection becomes `aggregate()` without a latest observation. Merges
require identical bounds and reject mismatches before any mutation. Checked
cumulative counts admit an exact cap and reject actual required-count/sum overflow.
Quantile ranges require exact sample and distribution counts, including when the
value total has overflowed. No exact percentile is invented.

`interval_since` returns exact count/total differences and a floor-rounded mean.
Both snapshots must be admitted by the owner as one append-only window with common
identity, units and attribution. Overflow, decreasing counters and a changed total
without added observations return typed failures. Numeric success cannot detect
reset followed by larger values. Maximum/latest/quantiles are not subtractable.
Raw external-field `record_sample` and `checked_mean` retain the conservative cap
contract because those fields carry no overflow provenance. Tracked flags establish
accumulation exactness only, never the exactness of an already clipped sample.

## Read-only consumer review

The reviewed source hashes and immutable HEADs are in
`target/evidence/hard-cut-060/caller-inputs.json`. Selected dirty files are identified
separately; no sibling resolver, build, formatting or file mutation is performed.

| Consumer / HEAD | Review and adoption consequence |
| --- | --- |
| IcyDB `091a4f09b2cbf54c0e2a20e3cdbd66e7623f6f89` | Committed instruction/schema/entity count/total fields and CLI raw means retain their existing helpers and DTOs. Inclusive spans, maximum/reset and journal-debt separation remain owned by IcyDB. |
| Canic `25b73cd403b20b4e148c6e340f8c760a26d97f6e` | Committed `perf.rs` retains raw helpers, exclusive accounting and invocation-owned checkpoints. Root manifest has unrelated dirty selection; it is not committed qualification. |
| IC Timers `3174935874796c3ffae30b0dfcf9c0c8f4557322` | Committed scheduler/work summaries retain latest and their public re-exports. Coordinate dependency identity and actual-overflow projections under [#43](https://github.com/dragginzgame/ic-timers/issues/43); roles, epochs, trap admission and reset remain local. |
| IC Backup `943ade5afac218d2eeae280111a75f26612ab80f` | Committed four-bound prepared-byte histogram currently projects a public summary. Change that projection/re-export and explicitly dispose of latest under [#38](https://github.com/dragginzgame/ic-backup/issues/38). Reviewed integration test has dirty work; it is not proof of committed/native acceptance. Duration/byte sample clamping also needs owning admission so it cannot masquerade as exact input. |
| IC Blob Storage `037f91c8ab9ba70675ea76a90a1c7591b2bc554d` | Committed restoration test probe retains raw count/instruction fields and separate byte counts. Its bounded reporting/reset and call-context attribution remain local. |
| Toko Miner `cb9031b13ad7f685e51237828ed0fc915fe97910` | Committed game-shard action cohorts retain raw attempt/instruction helpers and domain/outcome admission. Root manifest has unrelated dirty selection; category bins are not value-distribution buckets. |

Backup and Timers explicitly expose shared types, so applications must coordinate
one published 0.6 dependency identity when adopting. Volatile accumulator layout
changes supply no serialized replacement or consumer data reset. The library has
no codecs or persistent format. No aliases, dual readers or migration mechanism
are introduced. Consumer reports and any retained-data disposition remain with
those owners. Earlier completed extraction acceptance stays separate from this
new hard cut; the original Canic obligation in #10 is not supplied by root work.

## Storage and compiled artifact observations

A source-bound standalone `no_std` probe is compiled for `wasm32-unknown-unknown`
with Rust 1.99.0, edition 2024, `opt-level=z`, `panic=abort`, and stripped symbols.
The baseline exports released 0.5.6 arithmetic from the exact Git source; the
current probe uses this working source. Both export the same layout constants and
three-observation summary mean. Results, commands, input hashes, LLVM IR and raw
Wasms are retained under `target/evidence/hard-cut-060/layout/`.

| Wasm-target storage | Released 0.5.6 bytes | Pending 0.6.0 bytes |
| --- | ---: | ---: |
| Ordered summary | 32 | 40 |
| Histogram with no finite bounds | 40 | 48 |
| Two-bound histogram | 72 | 80 |
| Four-bound histogram | 104 | 112 |

Actual-overflow provenance costs eight bytes in each inspected instance. The
isolated stripped probe is 592 baseline raw Wasm bytes and 576 current bytes;
its mean contract changes at exact caps, so this is not an application saving or
same-contract optimization claim. Unstripped observations remain separate. No
IC instructions/cycles or native timings are measured, and frozen histogram cost
records do not quantify this recorder's runtime overhead. Consumers must qualify
their own cardinality, recording and report/merge workload on the IC.

## Local validation

Native and Wasm warnings-as-errors Clippy and the focused arithmetic package
checks pass. The tests exercise exact caps versus actual overflow, sticky propagation,
empty/zero, additive partition merging, ordering separation, atomic mismatch
rejection, interval continuity errors, distribution exactness and constant evaluation.
Final-source delivery qualification is recorded below.
Frozen historical source/performance bundles remain unchanged; they do not qualify
new recording overhead. Native substitutes establish no IC instruction/cycle cost.

The first full gate stopped at the existing formatting fixture: its committed
export overlaid current `lib.rs` but omitted the newly introduced aggregate
module. Its failed logs and exported source remain under the first `delivery.log`
and the reported `fixture-retention.snri3X` owner. The Metrics-owned wrapper now
passes the complete NUL-delimited current arithmetic source tree to the unchanged
canonical checker; producer failure remains visible before selection. Hook
preservation/install checks pass on modern Bash/Make and genuine Bash 3.2.57/Make
3.81 on Linux. Selected ShellCheck and the complete existing failure-retention
fixture pass. This shell-profile evidence is not hosted macOS acceptance.

## Complete final-source delivery qualification

The completed batch passes `ci` (250 seconds), `msrv` (Rust 1.85, including Wasm)
and `wasm-inspect-msrv` (Rust 1.88). All 101 final frozen code/graph/pin/workflow
inputs remain unchanged after the complete gates. `delivery-current.log`,
`delivery-inputs.json` and `delivery-preservation.txt` retain this qualification
under `target/evidence/hard-cut-060/`; the first failed gate/catalog stays separate.
The suite includes warnings-as-errors native/Wasm Clippy, actual arithmetic tests,
compiled usage examples and inspector checks, repository/tooling/recovery fixtures,
snapshot/pin admission and documentation checks. Package versions remain 0.5.6;
no new dependency or release is selected. Local Linux qualification does not supply
unreleased-source macOS receipts, IC recording costs or owning consumer adoption.
