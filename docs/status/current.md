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

The local batch starts at `e972af583cb9e6e669bbe0b46f6ab398cc08a7d9`
and preserves the incoming Memory 0.49.2 lock update with selected Storage 0.5.8.
Their 49 and five library source files, included READMEs, normal dependencies,
features and Rust floors match the preceding patches. Both product APIs and
Metrics V1 bytes remain unchanged; production arithmetic is dependency-free.

All 22 stable units and three doctests, strict native/Wasm stable Clippy,
native all-target/Wasm library Rust 1.91 checks and production dependency
admission with exclusion fixtures pass locally. Logs remain under
`/tmp/metrics-01410-*.log`. No full CI/MSRV gate, native macOS run or new IC
measurement is claimed. Source equality does not assert identical artifacts.

Shared Tooling's reviewed source and payload digests belong to
[the snapshot](../../.shared-tooling.snapshot). The 0.25.5 adoption clarifies
failure-evidence collection; executable helpers and pins are unchanged.
The pending workflow fix preserves independent native recovery packaging after
collector failure and retains the first error. Its regression and combined-failure
cases belong to [#95 — Native recovery after diagnostic collection failure](https://github.com/dragginzgame/ic-metrics/issues/95).
Compiler and library selections stay local; the host guide owns setup and policy.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) and
[Memory patch qualification](../evidence/memory-0491.md) retain their own graphs.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [0.14.9 handoff](https://github.com/dragginzgame/ic-metrics/blob/e972af583cb9e6e669bbe0b46f6ab398cc08a7d9/docs/status/current.md)
retains completed arithmetic, tooling and validation preparation. Its linked
historical handoffs preserve earlier identities and evidence paths. Historical
observations are not current issue/PR status. Follow the
[archive distribution record](../evidence/archive-distribution-072.md) for public payloads.

## Owning follow-up links

Read the owning issues for their current disposition; this handoff is not a
second issue-status ledger:

- [Published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82).
- [Durable scalar consumer acceptance](https://github.com/dragginzgame/ic-metrics/issues/83).
- [Storage discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12).
- [Evidence archive distribution review](https://github.com/dragginzgame/ic-metrics/issues/72).
