# Measurement extraction contract

IC Metrics owns small, allocation-free, dependency-free `no_std` arithmetic.
Consumers own platform reads, sample admission, units, attribution, identities,
registries, labels, synchronization, lifecycle and endpoints. The
[application guide](../crates/ic-metrics/src/application.md) is included in the
crate documentation and supplies compiled examples.

## Arithmetic ownership

| Primitive | Retained state and projection |
| --- | --- |
| `MeasurementAggregate` | Mergeable sample count, wide total, maximum and actual-overflow flags; checked means and count/total intervals. |
| `MeasurementSummary` | An aggregate plus the latest ordered observation; no merge that invents ordering. |
| `MeasurementHistogram<N>` | Immutable finite bounds, disjoint counts, overflow and an aggregate; equal-bound merging and checked cumulative counts/nearest-rank ranges. |
| Pending 0.8.2 `MeasurementCounter` | Scalar wide total and actual-overflow flag; checked totals and numeric deltas, without observation statistics or durable encoding. |

Individual observations, sample counts and bucket counts use `u64`; accumulated
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

Merging adds deliberately attributed batches without deduplication. Before
intervals or scalar deltas, establish matching units, counter/window identity
and append-only continuity. Numeric success cannot detect a reset followed by
larger readings. Maxima, latest observations and quantiles are not subtractable.

## Platform and persistence boundaries

Consumers read counter 1 through their own adapters: IcyDB and Canic use
`ic_cdk::api::call_context_instruction_counter()`, while IC Timers uses
`ic0::performance_counter(1)`. Native substitutes are not IC measurements.
Inclusive overlapping IcyDB spans and exclusive Canic endpoint accounting remain
separate contracts; there is no attribution-mode switch or product dependency.

The optional [stable package](../crates/ic-metrics-stable/README.md) owns validated
V1 snapshots for aggregates, summaries and histograms in one host-supplied
`ic-memory` B-tree map. One permanent store allocation resolves to one memory ID;
namespace/name keys distinguish rows. Hosts own bootstrap, map initialization,
update-message synchronization, write cadence, authorization and resets. Queries
cannot make stable writes durable, and adapter errors never silently reset data.
The core has no serialization or stable-memory dependency. Scalar counters have
no stored kind; an existing kind must never be repurposed for them.

The private [Wasm inspector](../crates/ic-metrics-wasm-inspect/README.md) owns
bounded structural inspection through IC Host libraries. It is outside the
arithmetic graph and does not execute canisters or estimate instruction/cycle
costs. PocketIC provisioning and lifecycle belong to IC Testkit; this workspace
has no maintained server caller.

## Downstream contract checks

| Consumer | Owning contracts to preserve | Adoption owner |
| --- | --- | --- |
| IcyDB | Inclusive overlapping spans, zero, overflow/report fields, CLI means, reset identity and journal-debt separation. | [#354](https://github.com/dragginzgame/icydb/issues/354) |
| Canic | Exclusive nesting, async call-context identity, invocation checkpoints, zero, report ordering and quality propagation. | [#523](https://github.com/dragginzgame/canic/issues/523) |
| IC Timers | Scheduler/work roles, registration/epoch identity, completion/trap admission and empty/zero/overflow projections. | [#50](https://github.com/dragginzgame/ic-timers/issues/50) |
| IC Backup | Nanosecond/byte separation, success/rejection samples, zero/repeated chunks, clamped durations, copied views, `Send + Sync` and empty create/open state. | [#41](https://github.com/dragginzgame/ic-backup/issues/41) |
| Blob restoration test probe | Restoration-operation attribution, call-context identity, zero, bounded reports and reset behavior; not production storage instrumentation. | [#62](https://github.com/dragginzgame/ic-blob-storage/issues/62) |
| Toko Miner game shard | Action-count cohort admission, separate attempt/instruction units, trap/outcome policy, bounded reports and window/reset identity. | [#48](https://github.com/dragginzgame/toko-miner/issues/48) |

Review affected producers, DTOs, codecs, generated views and callers when shared
contracts change. Consumers explicitly select registry dependencies, remove
superseded arithmetic and qualify their own runtime/native contracts. Exposed
shared types require a consistent dependency identity. Publication and a lock
update do not establish owning acceptance. GitHub issues retain current work;
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) owns the original
remaining consumer qualification, and [Toko #49](https://github.com/dragginzgame/toko-miner/issues/49)
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
publication and hosted qualification. [Released 0.8.1](evidence/release-081.md)
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
