# Current handoff — 2026-10-29

The checkout starts at released 0.16.6 (`6152804`). Earlier audit cleanup is
committed in that release; its historical evidence remains retained. The current
compatible pending 0.16.7 implements [#99](https://github.com/dragginzgame/ic-metrics/issues/99),
opt-in transport for canonical numeric measurements. Package versions are unchanged.
No commit, release or package publication has been performed for this work.

The selected smallest ownership model is one optional `wire` feature on the
arithmetic package, avoiding a second public representation in a companion crate.
It supplies Serde Serialize/Deserialize for MeasurementAggregate and
MeasurementCounter, plus native IC Wire TypeScript metadata. Private fixed-size
Serde records define the exact layout; metadata delegates to those same records.
Deserialize calls existing from_parts admission and reports typed codec failure
for inconsistent state. Empty maxima, u128 totals and actual overflow survive.
Means remain derived checked projections, rather than duplicated report fields.

Default arithmetic and recording alone remain dependency-free and no_std.
Wire uses optional Serde on all targets; optional IC Wire with TypeScript metadata
is selected only on native targets. Wasm transport uses Serde without Wire's host
metadata dependency. The dependency checker admits this explicit optional pair,
rejects default activation, and retains other production/substrate prohibitions.
The locked graph adds only the new transport dependencies; earlier selections
including num-bigint remain unchanged.

Focused evidence is retained under `target/evidence/transport-99/`. Native
round-trip, malformed numeric admission, resource refusal and browser contract
metadata generation tests pass, including Rust 1.91 native execution. Rust 1.91
Wasm compilation with wire passes. Strict all-feature library/test Clippy passes.
Default production graph inspection is empty. Dependency fixtures, doctests and
maintained documentation checks are included in the recorded validation.
No full release gates or browser runtime execution are claimed.

The application guide documents consumer mirror migration and supported types.
Consumers own report composition, labels, units, grouping, limits, replicated
admission, endpoints, restart identity and controller reset. Bounded tables and
windows remain heap-only; no transport or durable registry is added for them.
Other measurement shapes have no wire implementation in this scoped addition.
IC Persistence retains stable formats, durable adapters and governed integration.

Native browser metadata describes shape; Rust remains authoritative for numeric
admission. Rebuild browser contracts when replacing consumer mirrors. There is
no historical codec fallback and no IcyDB source change or qualification here.
Publication and actual downstream adoption remain separate maintainer effects.
