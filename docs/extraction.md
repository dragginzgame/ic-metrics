# Measurement extraction contract

ic-metrics owns only allocation-free, dependency-free `no_std` arithmetic:
`record_sample` updates consumer-owned count/total fields, and
`MeasurementSummary` owns samples, total, latest and maximum, and the separate
`MeasurementHistogram` adds fixed disjoint buckets and overflow around that summary.
Histogram bounds and units are caller-selected; invalid bounds return a typed
error. Bucket counts saturate independently. These primitives never read
platform counters, allocate labels, persist data or claim endpoints.

The private host [Wasm inspector](../crates/ic-metrics-wasm-inspect/README.md)
uses IC Host libraries for bounded artifact inspection. It is a separate workspace
package, not an arithmetic dependency or platform reader. It establishes no
consumer attribution, runtime qualification or instruction/cycle measurement.

Release 0.3.0 adopts the shared five-tool IC setup contract. PocketIC selection,
provisioning, admission and lifecycle belong to IC Testkit. This workspace has
no active server caller and adds no runtime dependency. Existing six-tool bundles
require explicit `make install-ic-tools` replacement; old bundles and frozen
measurement inputs are retained. The breaking change is developer tooling, with
unchanged arithmetic APIs and no consumer data reset. Native adoption acceptance
is tracked in [#41](https://github.com/dragginzgame/ic-metrics/issues/41).

Published compatible 0.2.17 adds checked finite-bound cumulative counts and
nearest-rank quantile bucket ranges to the existing histogram, with no new
recording state or change to bucket attribution. A rational quantile identifies
a range, not an exact observed percentile. Required count saturation is rejected;
saturated value totals alone do not invalidate exact distribution counts.
It also adds `checked_scaled_ratio` for exact scaled fractional means/proportions
from admitted `u128` totals and `u64` denominators/scales. This arithmetic does not
admit identity, saturation provenance or empty samples and does not replace
`checked_mean`'s availability checks. Existing caller formats, recording and
public projections remain consumer-owned and unchanged by this addition.
Publication does not establish completed consumer adoption.

Published 0.2.6 adds `checked_mean(samples, total)` for consumer-owned report
fields and `MeasurementSummary::mean()` using that canonical projection.
Empty `(0, 0)` is `None`; measured zero is `Some(0)`. Nonempty unsaturated
means round down. A nonzero total without samples or either counter at
`u64::MAX` returns `MeasurementMeanError`, including an exactly reached cap.
It establishes no unit, snapshot identity or input provenance and adds no storage.
The [packaged application guide](../crates/ic-metrics/src/application.md) shows
consumer-owned named aggregates and their admission/reporting obligations.

## Canonical ownership

Published 0.5.0 adopts Shared Tooling's complete 12-executable setup/check contract
and retires the optional host installer flags. This changes developer commands,
not arithmetic, attribution, counter identity, persistence or consumer endpoints.
Each consumer owns its tooling adoption/native qualification under
[Shared #98](https://github.com/dragginzgame/shared-tooling/issues/98); Metrics'
coherent adoption is in [#47](https://github.com/dragginzgame/ic-metrics/issues/47)
and [its adoption evidence](evidence/adoption-050.md).
[Publication verification](evidence/release-050.md) binds the source, tag and
dependency-free archive; Linux and package-floor checks pass, with both macOS
jobs queued at that initial inspection. Subsequent
[Apple Silicon acceptance](evidence/release-050.md#apple-silicon-acceptance)
verifies that receipt; Intel remains queued. No consumer data reset or new IC
reader is required.

Published 0.5.1 repairs Metrics-owned Cargo jobserver handoff without changing
arithmetic; [its verification](evidence/release-051.md) binds the registry archive
and passing Linux receipt, with macOS acceptance remaining separate. Released
compatible 0.5.2 adopts Shared 0.3.2 setup admission, authenticated diagnostics,
common jobserver handling and completion-aware fixtures through
[the canonical adoption](evidence/adoption-052.md). Existing 12-tool ordering,
consumer policies and arithmetic dependencies remain unchanged.
Pending compatible 0.5.3 [adopts completed validation dispatch](evidence/adoption-053.md)
without changing these measurement contracts.

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

Release 0.3.6 is available in the registry; its
[verification](evidence/release-036.md) binds unchanged arithmetic, the published
archive, complete native/MSRV results and all three downloaded source-bound
receipts. It adopts Shared 0.2.9 and the separately qualified private Host 0.10.1
graph. Shared #30's Make-mode gap remains separate; no arithmetic, attribution
or consumer endpoint contract changes.

Released 0.3.7 adopts the canonical hidden-Make-mode repair, with
[focused local qualification](evidence/adoption-037-make.md) and
[complete native acceptance](evidence/release-037.md). [IcyDB's scoped closeout](evidence/consumer-closeout-037.md)
now binds registry adoption, measurement-state tests and helper/native checks to
0.269.1; Canic's held-HTTP/native obligation remains in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10). Neither tooling
qualification nor native substitutes establish IC measurement costs.

Published 0.4.0 adopts the Shared Tooling directory-path restriction and selected
executable preparation contract. This is a developer-tooling cut, with no change
to sample arithmetic, consumer attribution/identity, endpoints, persisted state
or report output. Operational LF/CR directories must be explicitly renamed;
retained measurement evidence is not renamed or deleted. The private inspector's
Host 0.11 selection retains unchanged consumed read/inspection APIs. See the
[adoption record](evidence/adoption-040.md) and
[separate Host qualification](evidence/host-dependencies-0110.md).
[Publication verification](evidence/release-040.md) binds the source, tag and
dependency-free archive; exact-source Linux and package-floor checks pass while
Intel remains queued and Apple Silicon is running at that initial inspection.
Subsequent [complete native acceptance](evidence/release-040.md#complete-native-acceptance)
verifies all three receipts and closes #45/#46; this remains separate from 0.5.0.

Earlier release 0.3.5 is available in the registry; its
[verification](evidence/release-035.md) binds unchanged arithmetic, the published
archive and passing Linux/MSRV results. Downloaded Linux receipts cover the
shared Make includes and execution companion, actual formatting hooks and
expanded inspector CLI. Subsequent
[complete native acceptance](evidence/release-035.md#complete-native-acceptance)
verifies both macOS receipts and the passing native/MSRV matrix. The pending
graph and shared Make execution-mode gap retain their separate qualification.

Earlier 0.3.3 now has [complete native/MSRV acceptance](evidence/release-033.md#complete-native-acceptance),
with all three downloaded source-bound receipts, completing the original installer
and literal-hook obligations in #42/#43. Later sources/graphs and the shared Make
execution-mode gap retain their own qualification.

Earlier release 0.3.2's
[verification](evidence/release-032.md) binds the unchanged arithmetic source,
published archive and passing Linux/MSRV results, with the actual inspector CLI
test confirmed in downloaded Linux receipts. Both macOS jobs remain queued.
Its changes cover shared guidance, the private inspector's Host lock selection
and focused CLI admission/publication coverage. Arithmetic and inspector
production source are unchanged; the test establishes no IC runtime measurement.

Earlier release 0.3.1's
[verification](evidence/release-031.md) binds the unchanged arithmetic source,
published archive and passing Linux/MSRV results. Both macOS jobs remain queued;
the installer acceptance in #42 remains separate.

Earlier release 0.3.0's
[verification](evidence/release-030.md) binds the unchanged arithmetic source,
published archive and passing Linux/MSRV results. Both macOS native jobs remain
queued in the initial observation. Later downloaded Intel/Apple Silicon receipts
complete [the supplemental acceptance](evidence/release-030.md#native-acceptance-complete),
closing #41 without relabeling earlier observations. Earlier release 0.2.20's
[verification](evidence/release-0220.md) binds the unchanged arithmetic and observed
exact-source hosted state for the pinning fix. The earlier 0.2.19
[verification](evidence/release-0219.md) retains its original Linux receipts.
The earlier 0.2.18
[verification](evidence/release-0218.md) retains its original Linux receipts.
The reporting APIs are
published from 0.2.17; their
[verification](evidence/release-0217.md) binds the published reporting APIs and
partial exact-source hosted checks. Complete native receipt review remains
separate. The earlier 0.2.16
[release record](evidence/release-0216.md) verifies its published arithmetic-only
payload and complete source-matching native/MSRV receipts. The
previous 0.2.13
[release record](evidence/release-0213.md) binds its source, archive and observed
native outcomes separately from earlier releases. Its tooling changes preserve
the arithmetic-only contract.
The six inspected callers select centralized registry arithmetic dependencies;
their exact requirements and locks retain separate source identities.
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
