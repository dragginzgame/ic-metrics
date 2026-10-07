# Fixed-size histogram qualification for pending 0.2.4

This record qualifies the uncommitted arithmetic addition on base release
`89f8c6947fb3253991c65479f04bf14acb676328` (0.2.3), with the reviewed Shared
Tooling snapshot `e378671d90afa237ff63a4b0e3b9551eb2c222b6`. The compatible
addition belongs to [#15](https://github.com/dragginzgame/ic-metrics/issues/15).
Cargo package/workspace versions remain 0.2.3; this is not publication evidence.

## Contract and scope

`MeasurementHistogram<N>` contains immutable inclusive bounds, disjoint counts,
one overflow count and the existing `MeasurementSummary`. Construction rejects
the first duplicate or descending bound with `HistogramBoundsError::index()`.
No bounds means every observation goes into overflow; `u64::MAX` as the last
bound includes every remaining observation. A zero bound admits measured zero.
Construction and recording support constant evaluation, including at MSRV.

Every admitted value updates one bucket and the canonical summary once. Bucket
counts, overflow and summary counters saturate independently. No exact percentile
or cumulative exporter is provided. Bounds, units, admission, resets, identities,
labels, persistence and endpoints stay consumer-owned. Storage is fixed by `N`;
recording searches at most `N` bounds and allocates nothing. This is a separate
type: `record_sample`, `MeasurementSummary` and their source/tests are unchanged.
The graph remains dependency-free, feature-free and `no_std`.

## Source inputs

SHA-256 receipts for the final Rust and Cargo inputs are retained in
`target/evidence/histogram-024/source.sha256`. The added source identities are:

| Input | SHA-256 |
| --- | --- |
| `crates/ic-metrics/src/lib.rs` | `d8367a91724a8fc42b2dddcddd7bce68579bed2d55b82fa576d5b4f78ae07fae` |
| `crates/ic-metrics/src/histogram/mod.rs` | `0a699655fc2d5e38298bb405dbbdc8a034ed73afe86c7d1d5ca8511be1df90aa` |
| `crates/ic-metrics/src/histogram/tests.rs` | `4dd28a91687330ddb740f99720bf57e72a438f332317f96ef63597f8c8ef4429` |

The same receipt includes both unchanged summary files, root/member manifests
and Cargo.lock. `git diff --exit-code` confirms those tracked inputs remain equal
to the base release. Toolchain identity/version output and the toolchain-file
receipt are retained beside it. No active build was present before source edits
or the selected compilation. Checks use the owning `target/` and locked offline
graph; explicit `cargo fetch --locked --offline` cache preparation succeeds.

## Focused execution

On Linux x86-64, the final constant-capable source passes:

- `make fmt`, followed by `make clippy`: host all-targets and Wasm library,
  denying every selected warning.
- `cargo test -p ic-metrics --locked --offline histogram::tests`: eight tests
  covering invalid bounds, inclusive boundaries, empty/zero, empty bounds,
  maximum bounds, independent bucket/overflow saturation and constant evaluation.
- The same focused histogram tests under Rust 1.88.0.
- The existing named `count_saturation_does_not_freeze_other_observations` test
  for the reused summary's sample-count saturation contract.
- `cargo test -p ic-metrics --locked --offline --doc MeasurementHistogram`:
  the public example with typed construction and disjoint buckets.
- `make msrv`: Rust 1.88.0 host and `wasm32-unknown-unknown` checks.
- `make docs-check`: warning-denied host and Wasm documentation.
- Offline locked `cargo package --allow-dirty --list`: both new module files
  are included in the development package selection; no archive is uploaded.
- Final formatting, local document links, 56-file snapshot verification and
  dependency-pin declarations. All recorded source/toolchain receipts recheck.

Rust validation uses `CARGO_NET_OFFLINE=true` for Make callers and the pinned
toolchain. Final const-source logs have `-const` in their names; the separate
MSRV histogram log is `histogram-tests-msrv.log`. Earlier successful checks of
the non-const draft remain retained separately and do not prove constant support.
Formatting, receipts and all command output remain in
`target/evidence/histogram-024/`. No failed validation attempt occurred.

## Consumer review and limitations

Read-only review confirms IcyDB still calls `record_sample` for inclusive entity
and schema-owner observations; Canic's Core perf slots use it for exclusive
accounting. IC Backup keeps guard-local success/failure nanoseconds and prepared
bytes in separate summaries. None of these paths adopts or pays for a histogram
in this change.

IC Timers' `TimerPerformance::record_work` records the accepted completed work
envelope, not exclusive consumer code. Its role, epoch, admission and terminal
declaration-removal contracts must remain local. The concrete first-consumer
proposal and owning measurement obligations are in
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22).
Use the histogram's summary as the canonical stored aggregate if adopted for
that role; keeping a second summary would duplicate recording and storage.
The runtime finishes the sampled envelope before recording measurements, so
comparing those sample values alone cannot measure histogram recording overhead.
The owning IC fixture must include the recording work in its cost comparison.
No consumer files were changed or consumer builds/tests run. A published primitive,
chosen workload/bounds, per-timer storage assessment and actual IC measurement
comparison are prerequisites for that adoption.

These are arithmetic correctness and compiler checks, not IC measurements or
native macOS execution. No histogram raw-Wasm, IC instruction or cycle result
exists yet. No full tests, full local CI, commits, tags, pushes, package version
changes or release commands ran. Native qualification of published 0.2.3 does
not qualify this uncommitted addition.

## Further consumer inspection

The maintainer requested feedback to all four consumers and a check for existing
histogram-like counter functions. Read-only inspection covered their Rust crate
sources for histogram/quantile/percentile and numeric bucket/range accumulators,
then traced the maintained measurement producers, storage and projections.
These later source identities do not relabel earlier qualification:

| Consumer | Inspected local HEAD | Committed metrics lock | Working metrics lock |
| --- | --- | --- | --- |
| IcyDB | `049e561a843a8d3f4526460fd15876a4a238df10` | 0.2.0 | 0.2.3 |
| Canic | `d7698e1f0541cb52ad8d762bc1549a700b412e88` | 0.2.3 | 0.2.3 |
| IC Timers | `0c90c391dff5960a7502fc15a0718b03631f2515` | 0.2.3 | 0.2.3 |
| IC Backup | `eece44dac79da1bfb36f82ce2cd30d51edd3a9c1` | 0.2.3 | 0.2.3 |

The reviewed measurement/history files equal their owning HEADs; all four
checkouts have unrelated dirty work. Their SHA-256 receipt is retained in
`target/evidence/histogram-024/consumer-review/source.sha256`.
No existing numeric measurement histogram was identified in the recording paths:

- IcyDB's owner/entity counters store samples or hits, instruction totals and
  maxima. SQL hash/group/distinct buckets, exact index range cardinality and
  SQL-generator coverage categories have separate correctness contracts.
- Canic's perf slots store count/total for endpoint completions and distinct
  checkpoint intervals. Operation/outcome tables count categories. Its public
  history retains chronological u128 observations in 288 sampling slots and
  qualifies adjacent same-window unsaturated deltas; it is not a distribution
  accumulator. Allocation and quota buckets remain at their existing owners.
- IC Timers keeps role-specific instruction summaries, event counters and
  memory-page observations; none is an existing distribution accumulator.
- IC Backup keeps six success/failure nanosecond summaries and a prepared-byte
  summary, with per-guard diagnostic lifetime and no retained authority.

There is no redundant histogram function to remove or mechanically upgrade.
Any adoption adds distribution behavior and storage at the raw admitted-value
producer; total/count/maximum or periodic public snapshots cannot recover that
distribution. The proposed aggregate owns its summary once, with consumer views
projecting it. No new counter reads, clocks, persistence or endpoints were added.
The unpublished API is not selected by any consumer lock.

Concrete owning feedback is in
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
The first three concern instruction samples; IC Backup's smallest proposal
uses already admitted chunk-byte samples, with host-duration distributions a
separate local use of existing observations. No sibling code, dependencies,
validation artifacts or publication state were changed by this inspection.
