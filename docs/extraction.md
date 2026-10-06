# Measurement extraction contract

This records the implemented arithmetic extraction and its consumer boundaries.
Re-read consumer worktrees before editing; concurrent work is active in the consumers.

## Demonstrated overlap

| Consumer source | Existing behavior | Shared boundary |
| --- | --- | --- |
| `icydb/crates/icydb-core/src/runtime.rs` | IC performance counter 1; native zero substitute | Explicit instruction-reader boundary |
| `icydb/crates/icydb-core/src/metrics/state.rs` | Saturating sample count, total, and maximum | Small measurement arithmetic |
| `canic/crates/canic-core/src/perf.rs` | Same instruction source and saturating count/total | Same primitives with consumer-owned attribution |
| `ic-timers/crates/ic-timers/src/snapshot/metrics.rs` | Summary with samples, total, latest, maximum | Canonical summary with consumer-owned scheduler/work attribution |
| `ic-backup/crates/ic-backup/src/ops/persistence/download_journal/metrics/mod.rs` | Guard-local host duration and prepared-byte summaries | Arithmetic-only `MeasurementSummary`; no IC reader |

Paths are relative to the parent projects directory and are evidence, not
dependencies or build inputs. No sibling needs to be present for this crate to
build. These are the known downstream consumers to review when shared contracts
change. Sibling mutations require authorization for their exact targets.

## Canonical ownership

The [consumer lookup record](evidence/consumer-lookups.md) measures subsequent
IcyDB/Canic allocation and reporting changes. Repeated keys benefit, while first
insertions cost more; neither result changes the shared core's ownership.
Canic's async endpoint attribution defect remains consumer-owned in
[#99](https://github.com/dragginzgame/canic/issues/99).

`record_sample` now serves IcyDB and Canic directly; `MeasurementSummary` is
the canonical summary re-exported by ic-timers and used by ic-backup's prepared
host diagnostics. Shared arithmetic remains allocation-free; sampling and
synchronization stay with each consumer.
A tiny counter reader alone does not justify a framework. Add no speculative modules, registry, trait,
feature matrix, serialization contract, or persisted state.

Document empty versus zero samples, independent saturation of count and total,
maximum/latest semantics, units, and counter regression before exposing an API.
Do not silently convert missing measurements to measured zero. Any native
substitute must advertise that it supplies no IC instruction evidence.
Keep pure arithmetic usable without allocation. A future IC backend must keep
its dependency target-specific and its execution semantics explicit.

Consumer-local invariants remain local:

- IcyDB spans are inclusive and can overlap; Canic endpoint accounting subtracts
  child spans. Moving arithmetic must preserve both contracts.
- Replicated-execution filtering, failed-attempt accounting, and async/trap
  handling are owned by their instrumentation callers.
- Heap reset windows and timer registration identities are different. This crate
  does not establish identity or promise persistence across resets/upgrades.
- Authoritative IcyDB journal debt is not a resettable metrics counter.
- Public metric labels, DTOs, bounded snapshots, Candid encoding, and visibility
  are consumer contracts. Serialization dependencies are not needed initially.

The optional IcyDB-to-Canic application sampler belongs in an IcyDB-owned
integration crate such as `icydb-canic`, depending on both products. Neither
core product nor this measurement crate should depend on that adapter.

## Extraction acceptance

Trace producers, consumers, and public/persisted shapes before any API change.
Keep consumer wire contracts unchanged unless a separate breaking scope and
minor release are explicitly selected. A shared API must have direct tests for
maintained arithmetic, empty/zero samples, and saturation; IC claims need real
IC instruction evidence rather than native elapsed time.

Extraction becomes adopted only when each authorized consumer explicitly depends
on this crate, uses its primitives, removes the replaced local implementation,
and passes focused checks for its own attribution and reset contracts.
Use released package dependencies for published consumers; any temporary local
path is explicit integration wiring, never hidden sibling discovery.

## Downstream contract checks

Review the affected caller contracts when changing shared arithmetic or the
reader, using each consumer's focused commands and source-bound evidence.

| Consumer | Contracts to preserve and check |
| --- | --- |
| IcyDB | Inclusive overlapping spans, measured zero, saturation, maximum/report fields, reset identity and journal-debt separation. |
| Canic | Exclusive synchronous nesting, async call-context identity, checkpoint ownership, measured zero, saturation and report ordering. |
| ic-timers | Scheduler/work attribution, registration/epoch identity, completion/trap sample admission and empty/zero/saturated snapshots. |
| ic-backup | Separate nanosecond/byte units and success/rejection samples, zero/repeated chunks, duration clamping, copied views, Send + Sync and empty create/open state. Diagnostics remain outside persistence, spending and receipt authority. |

ic-backup uses only the default arithmetic core. Its host durations can include
nested verification and therefore overlap; they supply no IC cost evidence.
Reader-only changes do not require IC execution in this host consumer. Shared
library validation and complete downstream release qualification are separate.

## Implemented adoption and evidence

IcyDB retains its report fields and maximum arithmetic while sharing count/total
updates. Canic removes `PerfSlot::increment` and shares the same count/total
primitive without changing exclusive nesting. ic-timers moves its summary into
this crate and directly re-exports it; role collection and registration identity
remain consumer-owned. Public report/serialized shapes are unchanged.

Six core tests cover empty/zero, latest/maximum, independent saturation and constant
evaluation. Nine IcyDB state tests, four Canic endpoint tests and three ic-timers
measurement/projection tests passed on Linux during extraction. These are native
contract tests, not IC instruction measurements or qualification of later unrelated
consumer edits. No instruction-count, cycle or Wasm-size improvement is claimed.

The maintainer published `0.1.3`, matching tag `v0.1.3` at
`a45c6fb156139efda8cfdfe7fbea1372cc11e559`. The registry index and downloaded
archive confirm its identity; packaged Rust sources match the tag. A standalone
registry-dependent `no_std` fixture passes Rust 1.88 host and Wasm checks.
During that adoption, IcyDB selected registry 0.1.3. IC Timers' root and testing
lockfiles selected registry 0.1.3, preserving every other package record. Focused
measurement, registration/reset identity and delivery checks pass on Linux.
The maintainer also published 0.1.4 at
`1a144139a2b84e7a389d721febe79aaac3775b0c`; its verified archive matches the tag
and passes the same standalone Rust 1.88 host/Wasm compilation checks. Canic's
primary checkout then selected registry 0.1.4 without a sibling path, preserving
all other lock records and package metadata. The isolated candidate first passed
locked offline Linux metadata, manifest sorting, strict Core library Clippy and
all four endpoint tests. After its primary release command stopped, source/lock
identities were rechecked and the patch was applied there. Primary metadata,
manifest sorting, strict Core Clippy and all four endpoint tests also pass.
IcyDB's clean committed adoption source `1a8511c3a` passed metrics-enabled strict
Core Clippy and all nine selected state tests in an isolated worktree with a
separate build directory. Primary source/manifest/lock inputs matched the captured
qualification revision. After its primary release command stopped, the prepared
registry notes and obsolete-comment cleanup were applied with source/free-lock
checks. Primary locked Linux metadata and manifest sorting pass; typed Cargo
metadata, lock bytes and all other changelog content are preserved.
Focused evidence remains separate from complete consumer native release/CI and
publication qualification.
The [publication issue](https://github.com/dragginzgame/ic-metrics/issues/4)
links each consumer's path removal and qualification evidence.
Published ic-metrics 0.1.5 now supplies the shared reader. All three named primary
consumer checkouts select its registry package with `ic` and delegate their Wasm
read to it. IcyDB/Canic retain native zero; IC Timers retains its existing native
production binding and test fake. No attribution, report or identity contract
changed. Owning release/CI qualification remains coordinated under
[#3](https://github.com/dragginzgame/ic-metrics/issues/3), with focused results in
[the current handoff](status/current.md).
Other crates can consume the pure
arithmetic without acquiring product instrumentation or an IC runtime dependency.

## IC reader contract audit

All three current readers select `ic0.performance_counter(1)` rather than the
per-message counter `0`. The [System API specification](https://docs.internetcomputer.org/references/ic-interface-spec/canister-interface/#performance-counter)
defines continuity within one replicated call context, including its message
executions. Non-replicated continuity is scoped to the corresponding composite
query helper and its callbacks; downstream query helpers are excluded. Neither
mode establishes continuity across unrelated calls, timer deliveries, resets or
upgrades. A numerically increasing pair is not proof of shared identity.

IcyDB and Canic return native zero substitutes. IC Timers instead keeps a test-only
fake counter; its production reader uses the IC binding. These native contracts
must remain local and must not be promoted to shared IC measurements. Consumers
currently use saturating subtraction for their span policy, so extracting a
reader alone must not silently reinterpret regressions or measured zero.

The selected `ic0 1.2.0` binding uses `std::mem::MaybeUninit` and has no `no_std`
feature. The new `ic` feature explicitly opts into its safe API, only on
`wasm32-unknown-unknown`. The default feature set does not select that dependency
on host or Wasm. The arithmetic source remains `no_std`; the optional IC backend
requires the binding's `std` support. This preserves `unsafe_code = "forbid"`
without a raw project-owned import, a vendored binding or a policy exception.
The feature owns just this runtime boundary, not attribution or a backend matrix;
an unconditional Wasm dependency would unnecessarily change arithmetic-only
consumers. [Reader extraction](https://github.com/dragginzgame/ic-metrics/issues/3)
owns publication, caller adoption and the execution evidence.

The upstream binding at
[`dfinity/cdk-rs` revision `624606f7fd1ecd6668e9608594946486aec29167`](https://github.com/dfinity/cdk-rs/blob/624606f7fd1ecd6668e9608594946486aec29167/ic0/src/lib.rs)
still uses std and declares no no_std feature. The earlier
[no_std request](https://github.com/dfinity/cdk-rs/issues/588) was closed with an
explanation about ic-cdk's Candid dependency; that does not demonstrate a no_std
contract for the lower-level ic0 binding. The explicit opt-in does not claim that
ic0 is `no_std` or require an upstream change.

The maintained Wasm fixture brackets shared reads with direct counter-1 reads,
executes bounded work, then checks continuity across an actual self-call callback
against the per-message counter 0. `make reader-check` runs only this named
PocketIC test with an explicitly installed local or caller-supplied 16.0.0 binary;
its version and platform digest
are checked before server startup. No native counter fake is used. Runtime
qualification and its artifact identities are recorded in [the host record](hosts.md).
The earlier synchronous and replicated callback evidence is retained separately.
The extended fixture also executes ordinary queries and composite-query callbacks
using a distinct downstream canister. Increasing downstream work leaves the
caller's measured callback interval unchanged; each interval establishes its own
local counter identity before comparison. The [query execution record](evidence/ic-reader-query.md)
binds these observations to the pre-release 0.1.6 fixture and unchanged published
reader source. This does not qualify complete consumer lifecycle behavior or claim
a performance gain.
The maintainer subsequently published and pushed 0.1.6. Its exact tagged hosted
qualification and independently verified registry archive are recorded in
[the release record](evidence/release-016.md); earlier observations retain their
original source and package identities.

## Additional consumer source audit

The initial read-only scan of IC Memory, IC Query, IC Blob Storage, IC Backup,
IC Testkit and IC Host Tools did not establish another matching saturating sample
summary. IC Backup subsequently added an arithmetic-only integration, described
below; that later adoption supersedes its initial audit disposition.
IC Testkit's `BenchmarkCounters` uses `u128`, checked deltas and typed overflow
errors across instruction and byte counters; substituting the current `u64`
saturating arithmetic would change that contract. Its canister performance
reader also includes memory counters. These ownership and unit differences do
not justify another shared mode or widening the current API. No additional
repository was modified and no native timing measurements were run.

## IC Backup host adoption

A subsequent read-only review found pending integration on IC Backup HEAD
`f4b1426b5afac3ad53d3c862e39f784cef7391f9` (0.3.6). Its uncommitted 0.3.7 batch
declares registry `ic-metrics 0.1.7` with default features disabled and member
workspace inheritance. The lock selects 0.1.7 with checksum
`9e8632a16ca69a8a9ab1fd4daa276f7739d9996bd970373992e6c97087a04378`, without
the IC binding. This is prepared consumer adoption, not a released integration.

`DownloadJournalGuard::ic_snapshot_metrics` returns a copied guard-local
`IcSnapshotLocalMetrics` view. Verification and upload metadata/data preparation
record separate returned success/rejection durations in nanoseconds. Successful
data preparation records chunk bytes, including zero and repeated preparation.
Each field uses `MeasurementSummary`. Create/open starts empty; journal replay
does not reconstruct observations. Synchronization, inclusive host sampling,
duration clamping and public diagnostics remain IC Backup-owned. No measurement
identity, persistence, transport, completion or spending authority moves here.

IC Backup's owning [adoption record](/home/adam/projects/ic-backup/docs/ic-metrics-adoption.json)
and [handoff](/home/adam/projects/ic-backup/docs/status/current.md)
describe its focused native qualification. At this review those records and the
integration were uncommitted.
This review inspected local source and tests, without running consumer commands,
native timing benchmarks or IC measurements. Native macOS qualification remains
consumer-owned. No IC Backup file was changed.
