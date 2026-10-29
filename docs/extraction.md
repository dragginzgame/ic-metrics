# Observability ownership and extraction contract

IC Observability combines the Metrics and Logging packages in one workspace.
Their library APIs, dependencies and runtime state remain independent. The root
workspace owns coordinated versions, dependency selection and validation tooling.
Existing frozen Metrics evidence retains the original repository/source identities.

| Package | Owner |
| --- | --- |
| `ic-metrics` | The arithmetic, numeric transport and optional bounded recorder contract below |
| `ic-logging` | Heap admission, retention and paging; [logging contract](logging.md) |
| `ic-metrics-stable` | IC Persistence; unchanged external stable adapter owner |

## Measurement contract

IC Metrics owns allocation-free `no_std` arithmetic and optional bounded heap
recording. Default arithmetic remains allocation-free. Consumers own platform
reads, sample admission, units, attribution, instance identities, limits, labels,
synchronization, lifecycle and endpoints. The
[application guide](../crates/ic-metrics/src/application.md) is included in the
crate documentation and supplies compiled examples.

## Capability placement

Metrics is an independently released application capability, at the same layer
as Timers, Jobs and Auth. Applications and Canic compose those capabilities;
Metrics does not depend on those consumers or own their orchestration policy.
Its arithmetic package stays portable, with standard numeric transport. IC Persistence owns
the separately published stable adapter alongside its Memory/Storage packages.

IC Tooling owns the separate Host, Build and Testkit packages. Benchmark parsing,
finite-sample reporting and tooling-specific arithmetic stay with that reporter;
Metrics' general integer APIs remain here.
Qualification tools do not enter the Metrics production graph. Existing frozen
receipts preserve the supplying packages and repository identities they measured.

## Arithmetic ownership

| Primitive | Retained state and projection |
| --- | --- |
| `CheckedMeasurementAggregate` | Exact `u128` observations, count, total and extrema; recording rejects overflow without partial updates. No persistence or attribution. |
| `MeasurementAggregate` | Mergeable sample count, wide total, maximum and actual-overflow flags; checked means and count/total intervals. |
| `MeasurementSummary` | An aggregate plus the latest ordered observation; no merge that invents ordering. |
| `MeasurementHistogram<N>` | Immutable finite bounds, disjoint counts, overflow and an aggregate; equal-bound merging and checked cumulative counts/nearest-rank ranges. |
| `MeasurementCounter` | Scalar wide total and actual-overflow flag; checked totals and numeric deltas, without observation statistics. Optional stable checkpoints retain only its scalar state. |

Summaries and histograms project count, total,
maximum, mean and scaled mean through `aggregate()`. The summary's latest
observation remains summary-owned. The arithmetic package requires Rust 1.91 on native and
Wasm. Each consumer qualifies its own integration.

`validate_histogram_bounds` admits borrowed strictly increasing bounds without
constructing temporary measurement state. Construction, restored-state admission
and the stable adapter share this ordering rule. Stored bytes still receive
independent arithmetic validation; the adapter owns its bound-count limit.

The checked wide accumulator accepts `u128` observations and rejects count/total
overflow without changing any field. Its count is `u64`; empty extrema are `None`.
It supplies exact reporting arithmetic without platform reads, persistence or
floating-point sample storage.

The tracked integer APIs use `u64` observations, sample counts and bucket counts; accumulated
quantities and means use `u128`. Zero is a valid observation. Empty aggregates
have no maximum, ordered summaries have no latest, and empty means are `None`.
A zero scalar counter is exact; consumers decide whether a counter exists.

Exactly reaching a numeric cap remains exact. Actual overflow clips the value
and sets a sticky flag. Recording a clipped input cannot recover its lost
quality. Reports preserve flags or explicit unavailable results and use checked
narrowing. Consumers may alert once on a flag transition per window; this
library never logs or supplies authoritative spending, budgets, balances or debt.

`scaled_mean(scale)` admits quality before scaling the total, preserving
fractional information that multiplying an integer mean loses. The generic
`checked_scaled_ratio` accepts already exact inputs; it does not admit units,
identity, overflow provenance or empty observations. Quantiles identify bucket
ranges, not exact observed percentiles.

For admitted aggregates, total overflow implies sample-count overflow. Mean and
interval queries reject count overflow first; exact counts bound totals and
scaled means. The generic ratio owns zero-denominator
and result-overflow errors for independently supplied scalar inputs; the scalar
counter retains its actual-total-overflow error. Flags now use `*_overflowed`
names, and the remaining error cases are `SampleCountOverflow`, `TotalOverflow`,
`CountOverflow` and `InvalidOverflowFlag`. Histogram `overflow()` remains the
beyond-last-bound count; `overflow_count_overflowed()` reports its lost quality.
Consumer-owned DTO/wire names need not follow these Rust API names.

Merging adds deliberately attributed batches without deduplication. Before
intervals or scalar deltas, establish matching units, counter/window identity
and append-only continuity. Numeric success cannot detect a reset followed by
larger readings. Maxima, latest observations and quantiles are not subtractable.

The 0.14 hard cut removes complete floating-point sample statistics
from Metrics. Testkit's private development reporter owns its finite-sample
mean, midpoint median and observed nearest-rank quantile, including non-finite
admission and typed failures. Its worker schema, sample storage, process lifecycle
and report presentation remain Testkit-owned. Metrics retains checked and tracked integer
arithmetic; histogram quantiles remain bucket ranges.
Other callers of the removed sample API must move it to their owning reporter.
Testkit 0.54.0 source at
[`ff88087`](https://github.com/dragginzgame/ic-testkit/tree/ff88087d6757121ac92e0dec4705ecaccfd8ebed)
contains that private reporter and selects Metrics 0.14.
[PR #125](https://github.com/dragginzgame/ic-testkit/pull/125) was closed without
merging after those changes were integrated through the maintainer's release
path. Its proposed checked-cohort rewrite was not integrated: Testkit retains
one cohort count and atomic multi-counter admission. Adopting Metrics 0.14 does
not require replacing that consumer-owned builder.

## Platform and persistence boundaries

Consumers read counter 1 through their own adapters: IcyDB and Canic use
`ic_cdk::api::call_context_instruction_counter()`, while IC Timers uses
`ic0::performance_counter(1)`. Native substitutes are not IC measurements.
Inclusive overlapping IcyDB spans and exclusive Canic endpoint accounting remain
separate contracts; there is no attribution-mode switch or product dependency.

IC Persistence owns the optional
[stable adapter](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable),
including persisted records, governed collection integration, restoration and
checkpoint validation. Its canonical guide and
[migration guide](https://github.com/dragginzgame/ic-persistence/blob/main/docs/migration/ic-metrics-stable.md)
own version selection and retained-data compatibility. Hosts retain allocation,
identities, lifecycle, write cadence and reset policy. Metrics supplies validated
arithmetic state through its public API; standard transport supplies validated numeric
transport, with no stable-memory allocation or storage dependency. Historical storage receipts below retain their
original source and graph identities.

The published [IC Host Wasm inspector](https://github.com/dragginzgame/ic-tooling/tree/main/apps/ic-host-wasm-inspect)
owns bounded structural inspection and its managed installation guide. Optional
experiments retain their own qualified tool identity; Metrics maintains no CLI
adapter or pin. Common setup, CI and release preflight require no inspector. It
does not execute canisters or estimate instruction/cycle costs. PocketIC provisioning and lifecycle
belong to IC Testkit; this workspace has no maintained server caller.
No IC Host package is required to compile or use the arithmetic library.

## Downstream contract checks

| Consumer | Owning contracts to preserve | Adoption owner |
| --- | --- | --- |
| IcyDB | Inclusive overlapping spans, zero, overflow/report fields, CLI means, reset identity and journal-debt separation. | [#356](https://github.com/dragginzgame/icydb/issues/356) |
| Canic | Exclusive nesting, async call-context identity, invocation checkpoints, zero, scalar/measurement report quality and reset continuity. | [#535 — Shared scalar diagnostic counters](https://github.com/dragginzgame/canic/issues/535); [#523](https://github.com/dragginzgame/canic/issues/523); [#600 — Protected report semantics](https://github.com/dragginzgame/canic/issues/600) |
| IC Timers | Scheduler/work roles, registration/epoch identity, completion/trap admission and empty/zero/overflow projections. | [0.9 qualification](https://github.com/dragginzgame/ic-timers/issues/51); [#59 — Adopt Metrics 0.10 summary projections](https://github.com/dragginzgame/ic-timers/issues/59) |
| IC Backup | Nanosecond/byte separation, success/rejection samples, zero/repeated chunks, clamped durations, copied views, `Send + Sync` and empty create/open state. | [Earlier qualification](https://github.com/dragginzgame/ic-backup/issues/41); [#47 — Adopt Metrics 0.10 summary projections](https://github.com/dragginzgame/ic-backup/issues/47) |
| Blob restoration test probe | Restoration-operation attribution, call-context identity, zero, bounded reports and reset behavior; not production storage instrumentation. | [#65](https://github.com/dragginzgame/ic-blob-storage/issues/65) |
| Toko Miner game shard | Action-count cohort admission, separate attempt/instruction units, trap/outcome policy, bounded reports and window/reset identity. | [#48](https://github.com/dragginzgame/toko-miner/issues/48) |

Review affected producers, DTOs, codecs, generated views and callers when shared
contracts change. Consumers explicitly select registry dependencies, remove
superseded arithmetic and qualify their own runtime/native contracts. Exposed
shared types require a consistent dependency identity. Publication and a lock
update do not establish owning acceptance. GitHub issues retain current work;
remaining original Canic qualification stays with
[#447](https://github.com/dragginzgame/canic/issues/447) and
[#99](https://github.com/dragginzgame/canic/issues/99).
[Metrics #10](https://github.com/dragginzgame/ic-observability/issues/10) retains the
retired root coordination history, and [Toko #49](https://github.com/dragginzgame/toko-miner/issues/49)
owns the database quality bridge/UI. The
[six-consumer review](evidence/consumer-review-082.md) retains its observed sources.

Distribution adoption needs admitted observations, not reconstructed counts,
maxima or chronological histories. Backup's reviewed four-bound histogram owns
prepared chunk bytes. Timers' scheduler/work summaries and Toko's domain cohorts
are separate contracts. Histogram investigations remain with
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).

## Compatibility and evidence

Reports preserve the tracked accumulator's actual overflow quality.
[The changelog](../CHANGELOG.md) owns released API changes and required caller
actions. Metrics never automatically resets retained data. Consumer wire changes
and retained-data disposition stay at their owner.

[The current handoff](status/current.md) separates local preparation, package
publication and hosted qualification. [Published 0.8.2](evidence/release-082.md)
retains its exact source and initial CI observation; [released 0.8.1](evidence/release-081.md)
has complete source-bound native acceptance; historical cancelled runs keep
their original status. [The tracked cut](evidence/tracked-080.md),
[durable IC experiment](evidence/stable-cost-072.md) and
[consumer closeout](evidence/consumer-closeout-0210.md) retain their own graphs,
workloads and acceptance scope. Raw Wasm bytes, IC instructions and actual cycle
charges are separate measurements; native execution supplies none of those IC
costs. No frozen experiment proves a later consumer's performance.

The separate [frozen durability receipt](evidence/stable-current-0146.md)
uses published Platform/Wire/Testkit interfaces and the governed Memory/Storage
map. Its source, graph, compiler and workload identities bound the result;
earlier durability archives retain their original identities.
The separate [Memory 0.49 comparison](evidence/memory-0147.md) qualifies that
version-bound retained upgrade with matched raw Wasm and IC cost observations.

Older release-by-release extraction prose is preserved verbatim in
[the cleanup receipt](evidence/cleanup-082.md), rather than mixed into this current
contract. The [pre-0.2 extraction record](evidence/extraction-through-019.md)
retains the retired reader's scope. Existing evidence and changelog history stay
unchanged.

## Bounded recording extension

The maintainer selected this extension on 2026-10-28 for unconditional bounded
consumer recording with independently selected endpoint exposure. `recording`
adds no further production dependency and uses Rust `alloc`, never `std` or platform APIs.
`BoundedMeasurementTable` admits the first identities within explicit entry,
per-key byte and total-key-byte limits. Existing identities continue at capacity.
Each refused observation contributes exactly once to a same-unit omitted aggregate;
its count is observations, not distinct omitted identities. Reports borrow keys
and copy arithmetic state; no global top-cost or complete-identity claim is made.
The key-byte budget excludes map-node and allocator overhead. Bounds are product
choices; the shared crate chooses no application capacity or admission labels.

`MeasurementWindow<T>` holds consumer-defined combinations of counters, aggregates,
summaries or bounded tables. Replacing a window advances its nonwrapping sequence.
Consumers supply clock fields, empty replacement state and reset authorization.
Equal sequences from different instances never establish continuity. Restart and
persistence remain at their existing owners; this is not a durable registry.
Authoritative database debt, quotas and balances never move into this recorder.
No change to inclusive versus exclusive attribution or public DTOs is implied.
