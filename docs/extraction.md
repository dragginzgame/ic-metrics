# Measurement extraction contract

IC Metrics owns small, allocation-free, dependency-free `no_std` arithmetic.
Consumers own platform reads, sample admission, units, attribution, identities,
registries, labels, synchronization, lifecycle and endpoints. The
[application guide](../crates/ic-metrics/src/application.md) is included in the
crate documentation and supplies compiled examples.

## Arithmetic ownership

| Primitive | Retained state and projection |
| --- | --- |
| `CheckedMeasurementAggregate` | Exact `u128` observations, count, total and extrema; recording rejects overflow without partial updates. No persistence or attribution. |
| `MeasurementAggregate` | Mergeable sample count, wide total, maximum and actual-overflow flags; checked means and count/total intervals. |
| `MeasurementSummary` | An aggregate plus the latest ordered observation; no merge that invents ordering. |
| `MeasurementHistogram<N>` | Immutable finite bounds, disjoint counts, overflow and an aggregate; equal-bound merging and checked cumulative counts/nearest-rank ranges. |
| `summarize_samples` | Sort a caller-owned finite floating-point slice without allocation; project mean, median and a selected observed nearest-rank value. No retained state, collection, attribution or serialization. |
| `MeasurementCounter` | Scalar wide total and actual-overflow flag; checked totals and numeric deltas, without observation statistics. Optional stable checkpoints retain only its scalar state. |

In the current 0.11 contract, summaries and histograms project count, total,
maximum, mean and scaled mean through `aggregate()`. The summary's latest
observation remains summary-owned. Consumers updating from before 0.10 replace
the removed summary forwarding methods with aggregate projections; 0.11 also
requires Rust 1.91 on native and Wasm. Each consumer qualifies its own integration.

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

Finite sample statistics are a separate approximate projection over actual
caller-supplied observations. They do not reconstruct exact counts or histogram
state from floating values. The caller supplies the quantile fraction, memory
and units; Metrics sorts that memory in place and reports a midpoint median and
an observed nearest-rank value. Invalid fraction/non-finite sample admission
precedes mutation; rounded mean overflow is explicit after sorting. Existing
integer arithmetic and stable records remain unchanged. Testkit's prepared
consumer removes its private statistics only after a supplying release is
published; its worker schema, process lifecycle and report presentation remain
Testkit-owned. Other maintained consumers require no change for this additive API.

## Platform and persistence boundaries

Consumers read counter 1 through their own adapters: IcyDB and Canic use
`ic_cdk::api::call_context_instruction_counter()`, while IC Timers uses
`ic0::performance_counter(1)`. Native substitutes are not IC measurements.
Inclusive overlapping IcyDB spans and exclusive Canic endpoint accounting remain
separate contracts; there is no attribution-mode switch or product dependency.

The optional [stable package](../crates/ic-metrics-stable/README.md) owns validated
V1 snapshots for counters, aggregates, summaries and histograms in one host-supplied
`ic-memory` B-tree map. One permanent store allocation resolves to one memory ID;
namespace/name keys distinguish rows. Hosts own bootstrap, map initialization,
update-message synchronization, write cadence, authorization and resets. Queries
cannot make stable writes durable, and adapter errors never silently reset data.
The prepared 0.12 API uses concrete load/save operations for each metric family;
histogram loads take bounds directly. Codec/kind and continuity dispatch remain
private, without a public generic trait or capability-token surface. The core has no
serialization or stable-memory dependency. Scalar checkpoints use
distinct V1 kind 4; aggregate/summary/histogram kinds 1/2/3 are never repurposed.

The published [IC Host Wasm inspector](https://github.com/dragginzgame/ic-host-tooling/tree/main/apps/ic-host-wasm-inspect)
owns bounded structural inspection and its managed installation guide. Optional
experiments retain their own qualified tool identity; Metrics maintains no CLI
adapter or pin. Common setup, CI and release preflight require no inspector. It
does not execute canisters or estimate instruction/cycle costs. PocketIC provisioning and lifecycle
belong to IC Testkit; this workspace has no maintained server caller.
No IC Host package is required to compile or use either published Metrics library.

## Downstream contract checks

| Consumer | Owning contracts to preserve | Adoption owner |
| --- | --- | --- |
| IcyDB | Inclusive overlapping spans, zero, overflow/report fields, CLI means, reset identity and journal-debt separation. | [#356](https://github.com/dragginzgame/icydb/issues/356) |
| Canic | Exclusive nesting, async call-context identity, invocation checkpoints, zero, report ordering and quality propagation. | [#523](https://github.com/dragginzgame/canic/issues/523) |
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
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) retains the
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

The published 0.8 contract requires tracked recording instead of `record_sample`
or raw-field `checked_mean`; reports must preserve actual overflow quality.
[The changelog](../CHANGELOG.md) owns released API cuts and required caller
changes. The stable V1 contract was preserved through that cut, with no Metrics
owned durable-data reset. Consumer wire changes and retained-data disposition
stay at their owner.

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

Older release-by-release extraction prose is preserved verbatim in
[the cleanup receipt](evidence/cleanup-082.md), rather than mixed into this current
contract. The [pre-0.2 extraction record](evidence/extraction-through-019.md)
retains the retired reader's scope. Existing evidence and changelog history stay
unchanged.
