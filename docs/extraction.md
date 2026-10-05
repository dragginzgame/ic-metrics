# Measurement extraction contract

This records the implemented arithmetic extraction and its consumer boundaries.
Re-read consumer worktrees before editing; concurrent work is active in the consumers.

## Demonstrated overlap

| Consumer source | Existing behavior | Shared boundary |
| --- | --- | --- |
| `icydb/crates/icydb-core/src/runtime.rs` | IC performance counter 1; native zero substitute | Explicit instruction-reader boundary |
| `icydb/crates/icydb-core/src/metrics/state.rs` | Saturating sample count, total, and maximum | Small measurement arithmetic |
| `canic/crates/canic-core/src/perf.rs` | Same instruction source and saturating count/total | Same primitives with consumer-owned attribution |
| `ic-timers/crates/ic-timers/src/snapshot/metrics.rs` | Summary with samples, total, latest, maximum | Existing contract to compare before designing another |

Paths are relative to the parent projects directory and are evidence, not
dependencies or build inputs. No sibling needs to be present for this crate to
build. All three named consumers are authorized integration scope.

## Canonical ownership

`record_sample` now serves IcyDB and Canic directly; `MeasurementSummary` is
the canonical summary re-exported by ic-timers. All remain allocation-free.
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

The maintainer tagged arithmetic release `0.1.1` at
`e3d4b0c3b3d19dbaa7b4e5763bea1144cb6570bc`. The three consumer dependency pins
and four applicable lockfiles now select that local `0.1.1` package. Registry
publication now has a separate maintainer command; enabling its policy and creating
a Git tag do not establish an available registry dependency.
The [publication issue](https://github.com/dragginzgame/ic-metrics/issues/4)
links each consumer's replacement of temporary paths.
IC counter readers remain local: their backend execution needs its own demonstrated
contract and real IC evidence before it moves. Other crates can consume the pure
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

The existing cached binding `ic0 1.2.0` uses `std::mem::MaybeUninit` and has no
`no_std` feature. There is no selected backend dependency in this crate. A direct
raw import would also conflict with the workspace's `unsafe_code = "forbid"`
policy. Preserve the dependency-free arithmetic boundary while resolving a safe,
target-specific backend; do not vendor the binding or weaken that policy to move
three one-line calls. [Reader extraction](https://github.com/dragginzgame/ic-metrics/issues/3)
owns this contract and its real IC qualification.

The upstream binding at
[`dfinity/cdk-rs` revision `624606f7fd1ecd6668e9608594946486aec29167`](https://github.com/dfinity/cdk-rs/blob/624606f7fd1ecd6668e9608594946486aec29167/ic0/src/lib.rs)
still uses std and declares no no_std feature. The earlier
[no_std request](https://github.com/dfinity/cdk-rs/issues/588) was closed with an
explanation about ic-cdk's Candid dependency; that does not demonstrate a no_std
contract for the lower-level ic0 binding. No upstream change or new dependency
has been selected here.
