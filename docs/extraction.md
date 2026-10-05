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

All dependencies are explicitly declared local paths with an exact 0.1.0 requirement.
The crate is unpublished and publishing consumers requires a released dependency.
IC counter readers remain local: their backend execution needs its own demonstrated
contract and real IC evidence before it moves. Other crates can consume the pure
arithmetic without acquiring product instrumentation or an IC runtime dependency.
