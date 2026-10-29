# Current handoff — 2026-10-29

The checkout starts at released 0.16.7 (`a404422`). The maintainer selected standard
numeric transport so consumers can embed aggregates/counters directly in reports.
The pending 0.17.0 removes the published `wire` feature rather than keeping an
obsolete compatibility switch. Consumers must remove `wire` from feature lists.
This is a pre-1.0 breaking feature-contract change; package versions and Cargo.lock
remain unchanged. Work is uncommitted; no release or publication was performed.

Serde Serialize/Deserialize for MeasurementAggregate and MeasurementCounter is
always available. Native IC Wire metadata is also standard. Private fixed-size
Serde records define the serialized layout; metadata follows those same records.
Decoding calls canonical from_parts admission. Empty/zero maxima, wide u128 totals
and actual overflow quality remain explicit; exact means are derived after decode.
There are no numeric representation, stored-byte or decoding-rule changes.

The crate remains no_std on every target; measurement operations remain allocation-free.
Serde is a required dependency on all targets. IC Wire with TypeScript metadata
is a required dependency only on native targets. Wasm numeric transport needs
Serde without the host metadata graph. The declaration checker admits this required
pair without dependency defaults, rejects optional/missing transport and unrelated
production/build dependencies, and retains the stable-substrate prohibition.

Only bounded heap recording requires a feature (`recording`). Applications retain
units, labels, report grouping, replication policy, limits, clocks, identity,
endpoints and controller reset. Table/window state remains heap-only. IC Persistence
owns stable formats, durable adapters and governed integration. Transport support
continues to cover aggregates and scalar counters; no storage framework is added.

Focused evidence is under `target/evidence/standard-transport/`: strict all-feature
library/test Clippy, default-feature transport round-trips, invalid-state and resource
refusals, browser metadata generation, Rust 1.91 default doctests and default Wasm
compilation, dependency-admission fixtures, documentation links and diff checks.
Evidence from released #99 remains in `target/evidence/transport-99/` under its
original opt-in feature identity. No browser runtime execution or IC cost delta is
claimed, and no full release gates were run for this batch.
