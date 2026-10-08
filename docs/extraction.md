# Measurement extraction contract

ic-metrics owns only allocation-free, dependency-free `no_std` arithmetic:
`record_sample` updates consumer-owned count/total fields, and
`MeasurementSummary` owns samples, total, latest and maximum, and the separate
`MeasurementHistogram` adds fixed disjoint buckets and overflow around that summary.
Histogram bounds and units are caller-selected; invalid bounds return a typed
error. Bucket counts saturate independently. These primitives never read
platform counters, allocate labels, persist data or claim endpoints.

Published 0.2.6 adds `checked_mean(samples, total)` for consumer-owned report
fields and `MeasurementSummary::mean()` using that canonical projection.
Empty `(0, 0)` is `None`; measured zero is `Some(0)`. Nonempty unsaturated
means round down. A nonzero total without samples or either counter at
`u64::MAX` returns `MeasurementMeanError`, including an exactly reached cap.
It establishes no unit, snapshot identity or input provenance and adds no storage.
The [packaged application guide](../crates/ic-metrics/src/application.md) shows
consumer-owned named aggregates and their admission/reporting obligations.

## Canonical ownership

Zero is a valid sample; empty has no latest or maximum. Count and total saturate
independently; saturated totals cannot support exact interval arithmetic. Units,
counter identity, sample admission, replication, reset/restart identity, registries,
labels, synchronization, serialization, persistence and lifecycle remain consumer-owned.
There are no global consumer IDs or stable-memory allocations in this crate.

| Known consumer | Local measurement policy | Shared arithmetic |
| --- | --- | --- |
| IcyDB | Inclusive overlapping spans; native zero substitute; maximum/report fields and CLI mean projection | `record_sample`, `checked_mean` |
| Canic | Exclusive endpoint accounting and invocation-owned async checkpoints; native zero substitute | `record_sample` |
| IC Timers | Scheduler/work roles, registration epochs and sample admission; test-only fake counter | `MeasurementSummary` |
| IC Backup | Guard-local host durations in nanoseconds and prepared chunk bytes; separate units | `MeasurementSummary`, `MeasurementHistogram<4>` for prepared bytes |
| IC Blob Storage test probe | Restoration-operation instruction samples; test-canister attribution and reset | `record_sample` |
| Toko Miner game shard | Production action-count cohorts with separate attempt/instruction totals | `record_sample` |

IcyDB's journal debt and IC Backup's persistence/spending/receipt authority are
outside resettable diagnostics. IcyDB-to-Canic application sampling belongs in
an IcyDB-owned integration adapter. This crate has no product dependencies or
attribution-mode switch. Native substitutes provide no IC measurement evidence.

## Arithmetic-only 0.2 hard cut

Release 0.2.0 removes `call_context_instructions`, feature `ic`, the ic0 runtime
dependency, reader canister fixture, host qualification harness and
`make reader-check`. It keeps one arithmetic contract without a compatibility
reader or another runtime crate. Existing sample APIs and consumer reports remain unchanged;
there is no persisted format here to migrate and no consumer reset is required.

Consumers read counter 1 through APIs they already depend on:
IcyDB and Canic use `ic_cdk::api::call_context_instruction_counter()`;
IC Timers uses its existing `ic0::performance_counter(1)` platform adapter.
All IcyDB audit/test-canister direct readers must change along with Core.
These calls share the upstream counter contract; they do not unify attribution.
Numerically increasing readings alone do not establish a shared call context.
Actual IC execution and callback identity checks belong in consumer qualification.

Release 0.2.9 is available in the registry; the
[release record](evidence/release-029.md) binds the source, archive and complete
native matrix separately from the earlier complete 0.2.8 matrix.
The six inspected callers select registry arithmetic-only 0.2 requirements.
The [current handoff](status/current.md) separates their committed and working-tree
lock identities. IC Blob Storage's direct caller is a restoration test probe,
not production library instrumentation. Toko's action-count cohorts are domain
categories, not instruction-value histogram buckets. Package publication and a
lock update do not establish complete owning runtime/native qualification.
Local commits, remote/publication state and complete owning qualification remain
separate, tracked in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).
IC Backup's integration began in release 0.3.7 at
`1a23d66dd65b1e36e986b8c7d13758cf3c92d193`; release 0.4.2 at
`654790f374f9923df9020f4812cec65e47cbe3af` selects ic-metrics 0.2 with a 0.2.2
registry lock identity. It needed no reader changes. Public summary re-exports
still require a consistent dependency identity in applications combining crates.

## Downstream contract checks

| Consumer | Contracts to preserve and check |
| --- | --- |
| IcyDB | Inclusive overlapping spans, measured zero, saturation, maximum/report fields, reset identity and journal-debt separation. |
| Canic | Exclusive nesting, async call-context identity, checkpoint ownership, measured zero, saturation and report ordering. |
| IC Timers | Scheduler/work roles, registration/epoch identity, completion/trap admission and empty/zero/saturated projections. |
| IC Backup | Nanosecond/byte separation, success/rejection samples, zero/repeated chunks, duration clamping, copied views, Send + Sync and empty create/open state. |
| IC Blob Storage test probe | Restoration-operation attribution, call-context identity, measured zero, saturation and bounded report/reset behavior. |
| Toko Miner game shard | Action-count cohort admission, separate attempt/instruction units, trap/outcome policy, bounded reporting and window/reset identity. |

Review all affected callers before arithmetic changes. Use released dependencies,
no hidden sibling discovery or product coupling. Extraction is adopted when the
consumer explicitly uses the shared primitives, removes superseded arithmetic
and passes focused checks for its own contracts. Focused local evidence and
complete owning native release/CI qualification remain separate; see
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).
The earlier publication/path tracker
[#4](https://github.com/dragginzgame/ic-metrics/issues/4) is consolidated there;
its unfinished owning qualification is retained, not declared complete.

Histogram usage is investigated at the admitted-value producer in
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
The original counter-path review found no measurement histogram to replace.
The subsequently inspected IC Backup implementation records prepared chunk
bytes in four fixed disjoint buckets and overflow; its canonical summary derives
from the same accumulator. [IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15)
is complete at its released 0.5.2 source and native matrix; later graphs remain
separate. [The consumer review](evidence/consumer-closeout-0210.md) also verifies
Blob's actual restoration-metrics probe on all three native hosts. Neither result
establishes adoption of a different application workload.
IC Timers retains summaries without a demonstrated distribution workload.
Counts, maxima and totals cannot reconstruct an observation distribution;
chronological histories and domain/category buckets retain their own contracts.
The histogram API is published in 0.2.4; consumers using it need that released
minimum in their root dependency catalog. This repository's source review and
publication do not establish consumer histogram adoption or IC cost qualification.

## Historical evidence

The [frozen pre-cut extraction record](evidence/extraction-through-019.md) retains
publication, upstream binding and consumer adoption identities. Historical reader
claims apply to pre-0.2 sources, including tagged 0.1.9; they do not describe the
current library. The [host record](hosts.md) and
[current handoff](status/current.md) retain source-bound qualification.
The [performance audit](evidence/performance-audit.md) and
[consumer lookup measurements](evidence/consumer-lookups.md) retain workload limits;
this removal claims no instruction, cycle or Wasm-size improvement.
