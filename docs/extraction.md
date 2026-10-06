# Measurement extraction contract

ic-metrics owns only allocation-free, dependency-free `no_std` arithmetic:
`record_sample` updates consumer-owned count/total fields, and
`MeasurementSummary` owns samples, total, latest and maximum. Neither function
reads platform counters, allocates labels, persists data or claims endpoints.

## Canonical ownership

Zero is a valid sample; empty has no latest or maximum. Count and total saturate
independently; saturated totals cannot support exact interval arithmetic. Units,
counter identity, sample admission, replication, reset/restart identity, registries,
labels, synchronization, serialization, persistence and lifecycle remain consumer-owned.
There are no global consumer IDs or stable-memory allocations in this crate.

| Known consumer | Local measurement policy | Shared arithmetic |
| --- | --- | --- |
| IcyDB | Inclusive overlapping spans; native zero substitute; maximum/report fields | `record_sample` |
| Canic | Exclusive endpoint accounting and invocation-owned async checkpoints; native zero substitute | `record_sample` |
| IC Timers | Scheduler/work roles, registration epochs and sample admission; test-only fake counter | `MeasurementSummary` |
| IC Backup | Guard-local host durations in nanoseconds and prepared chunk bytes; separate units | `MeasurementSummary` |

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

The latest published release is 0.2.0. IC Timers 0.14.0 selects it; IcyDB and
Canic's current worktrees select ic-metrics 0.2 and IC Timers 0.14. Their locks
contain one registry ic-metrics 0.2.0 identity. Complete owning qualification
remains tracked in [#10](https://github.com/dragginzgame/ic-metrics/issues/10).
IC Backup's integration began in release 0.3.7 at
`1a23d66dd65b1e36e986b8c7d13758cf3c92d193`; release 0.3.9 still selects
arithmetic-only ic-metrics 0.1.9 and needs no reader changes. Public summary
re-exports require coordinated dependency identity when that consumer moves to 0.2.

## Downstream contract checks

| Consumer | Contracts to preserve and check |
| --- | --- |
| IcyDB | Inclusive overlapping spans, measured zero, saturation, maximum/report fields, reset identity and journal-debt separation. |
| Canic | Exclusive nesting, async call-context identity, checkpoint ownership, measured zero, saturation and report ordering. |
| IC Timers | Scheduler/work roles, registration/epoch identity, completion/trap admission and empty/zero/saturated projections. |
| IC Backup | Nanosecond/byte separation, success/rejection samples, zero/repeated chunks, duration clamping, copied views, Send + Sync and empty create/open state. |

Review all affected callers before arithmetic changes. Use released dependencies,
no hidden sibling discovery or product coupling. Extraction is adopted when the
consumer explicitly uses the shared primitives, removes superseded arithmetic
and passes focused checks for its own contracts. Focused local evidence and
complete owning native release/CI qualification remain separate; see
[#4](https://github.com/dragginzgame/ic-metrics/issues/4).

## Historical evidence

The [frozen pre-cut extraction record](evidence/extraction-through-019.md) retains
publication, upstream binding and consumer adoption identities. Historical reader
claims apply to pre-0.2 sources, including tagged 0.1.9; they do not describe the
current library. The [host record](hosts.md) and
[current handoff](status/current.md) retain source-bound qualification.
The [performance audit](evidence/performance-audit.md) and
[consumer lookup measurements](evidence/consumer-lookups.md) retain workload limits;
this removal claims no instruction, cycle or Wasm-size improvement.
