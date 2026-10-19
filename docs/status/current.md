# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
The optional stable package owns validated V1 snapshots in one governed Storage
map. Consumers own sampling, attribution, units, identities, registries, lifecycle
and endpoints. [The extraction contract](../extraction.md),
[stable guide](../../crates/ic-metrics-stable/README.md) and
[host guide](../hosts.md) own those boundaries and local qualification commands.

## Selection and qualification

[Cargo.toml](../../Cargo.toml) owns workspace versions and dependency requirements;
[Cargo.lock](../../Cargo.lock) owns resolved dependency identities. The
[changelog](../../CHANGELOG.md) records released changes and the pending batch.
Those files do not prove registry publication, hosted CI or consumer acceptance.

The [Memory patch qualification](../evidence/memory-0491.md) records the focused
checks for Memory 0.49.1 with Storage 0.5.7 and the independent full-width ratio
oracle. The oracle is test-only; production arithmetic remains dependency-free.
Neither package changes its API, V1 bytes or Rust 1.91 floor in this batch.

Shared Tooling's reviewed source and payload digests belong to
[the snapshot](../../.shared-tooling.snapshot). Dependency-role and production
exclusion policy is documented in the host guide, with admission enforced by
`make production-dependencies-check` for both native and Wasm graphs.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) has its own older graph.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [source-bound historical handoff](https://github.com/dragginzgame/ic-metrics/blob/a9c7789910cf5040788d14b3c2206a559dba4af1/docs/status/current.md)
retains earlier release, tooling and downstream narratives, exact source identities
and local evidence paths. Those historical observations are not current issue or
PR status. Follow the [archive distribution record](../evidence/archive-distribution-072.md)
when selecting public evidence payloads.

## Owning follow-up links

Read the owning issues for their current disposition; this handoff is not a
second issue-status ledger:

- [Published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82).
- [Durable scalar consumer acceptance](https://github.com/dragginzgame/ic-metrics/issues/83).
- [Storage discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12).
- [Evidence archive distribution review](https://github.com/dragginzgame/ic-metrics/issues/72).
