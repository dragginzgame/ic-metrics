# Measurement extraction contract

This is scope and source evidence for a candidate extraction, not an implemented
API or a second issue tracker. Re-read consumer worktrees before extracting;
the audit observed concurrent Canic changes.

## Demonstrated overlap

| Consumer source | Existing behavior | Shared candidate |
| --- | --- | --- |
| `icydb/crates/icydb-core/src/runtime.rs` | IC performance counter 1; native zero substitute | Explicit instruction-reader boundary |
| `icydb/crates/icydb-core/src/metrics/state.rs` | Saturating sample count, total, and maximum | Small measurement arithmetic |
| `canic/crates/canic-core/src/perf.rs` | Same instruction source and saturating count/total | Same primitives with consumer-owned attribution |
| `ic-timers/crates/ic-timers/src/snapshot/metrics.rs` | Summary with samples, total, latest, maximum | Existing contract to compare before designing another |

Paths are relative to the parent projects directory and are evidence, not
dependencies or build inputs. No sibling needs to be present for this crate to
build. `ic-timers` is an additional candidate, not authorized adoption scope.

## Canonical ownership

Measurement math may move here when at least IcyDB and Canic have concrete
callers. Start by comparing maintained summaries; a tiny counter reader alone
does not justify a framework. Add no speculative modules, registry, trait,
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
