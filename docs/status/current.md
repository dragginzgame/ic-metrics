# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Pending 0.10.0

Summaries now project counts, totals, maximum and means through `aggregate()`,
matching histograms. Their five direct forwarding methods are removed, without
aliases. Ordered recording, restoration and `latest()` remain summary-owned;
underlying arithmetic, quality flags and empty/zero semantics are unchanged.
Consumers selecting the new minor must update summary projections; package
versions, the lock and release effects remain maintainer-owned and unchanged.
The complete pending batch moves from 0.9.7 to 0.10.0 because this is an API cut.

The batch also adds optional durable scalar counters to the existing one-map
store; [the stable README](../../crates/ic-metrics-stable/README.md) owns supported
kinds, identity, reset and write policy. Existing V1 layouts require no reset.
[The frozen counter qualification](../evidence/durable-counter-097.md) retains
its exact source before this API cut, including the earlier passing CI/floors
and reproducible IC upgrade/rollback/cost results. It does not qualify this later
source or an owning application's workload; its identities and archives are unchanged.

Earlier pending fixture changes keep synthetic release cases on a minimal Git
baseline and generic archive fidelity at Shared Tooling. Product-commit offline
Cargo admission, workflow ordering, payload replay and outer Git custody remain
local. [The retained handoff](../evidence/handoff-before-summary-cut-0100.md)
preserves their original qualification and all earlier release observations.

## Selected owners and qualification

Full Linux `make ci`, `make msrv` and `make stable-msrv` pass for this cut:
50 arithmetic units, 16 stable units and eight doctests per package. Both
advertised floors pass native/Wasm. Hosted macOS and owning consumer acceptance
remain independent. Documentation links, historical readback and diff checks pass.

The lock still selects Memory 0.38.0. Arithmetic retains Rust 1.85 native/Wasm;
the optional stable package retains Rust 1.88. Shared's recorded candidate is
`345865182de74a4cadfb9028b7c2055796d9552e`; the separately managed published
Host inspector remains 0.17.10. The refresh changes three metadata helpers;
executable-tool selections remain unchanged.

[Shared PR #197](https://github.com/dragginzgame/shared-tooling/pull/197) repairs
coordinated local dependency requirements. The earlier release attempt restored
manifest, lock and notes exactly after Cargo refused its stale `^0.9` requirement.
Its retained plan remains untouched. After committing this source repair, the
standard minor command can restart preparation through the runner's existing
clean-descendant recovery, retaining the old attempt and repeating validation.

[Memory PR #103](https://github.com/dragginzgame/ic-memory/pull/103) remains open;
the official registry index's latest Memory 0.38.0 has no test-support feature.
The local test observer remains until its published replacement can be selected,
as tracked in [#82 — Adopt published Memory test support](https://github.com/dragginzgame/ic-metrics/issues/82).
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned after publication. Existing callers are not opted into persistence.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary callers are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47); adopt after
publication with aggregate projections, preserving attribution, quality and resets.
The arithmetic-reader closeout remains [#10 — Complete arithmetic-only consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/10).
Current migration guidance uses aggregate projections; historical wire names,
measurement archives and already accepted consumer receipts retain their scope.
