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

Shared Tooling's reviewed source and payload digests belong to
[the snapshot](../../.shared-tooling.snapshot). The local batch starts at
`a3b0c4a76145fddb0a36a4ce553435ae4ddb6b46`, preserving the incoming Memory 0.50.1
and Storage 0.50.1 lock selection. Both published packages bind IC Persistence
source `d61e5c014e11313313da167df3f24af2de6d96aa`. Their library source trees,
features and Rust floors match 0.50.0. Storage raises its Memory requirement to
0.50.1; no other resolved package changes. Upstream development-only tool updates
do not enter Metrics' production graph. Metrics
V1 rows and upstream stored formats remain unchanged.

Shared Tooling 0.25.9 adds confirmed Git-delivery admission before restarting a
committed preparation into another increment. The canonical snapshot carries
the same release guard reviewed in [PR #96](https://github.com/dragginzgame/ic-metrics/pull/96);
that PR's old pending heading conflicts with the released 0.15.0 base. No merge,
branch rewrite or release is performed by this local adoption. Shared 0.26
adoption waits for its [macOS selection fix](https://github.com/dragginzgame/shared-tooling/issues/294)
to be committed and qualified; no uncommitted upstream fix is imported.

Qualification covers stable native/Wasm Clippy, package tests and doctests,
native all-target/Wasm library Rust 1.91 checks, production dependency admission,
release retry/tracking and consumer adapters, snapshot integrity, tools, pins,
formatting and documentation links. Full CI/MSRV and native macOS checks remain
release gates; no new IC measurement or downstream acceptance is claimed.
Compiler and library selections stay local; the host guide owns setup and policy.

The [capability contract](../extraction.md#capability-placement) places Metrics
alongside Timers, Jobs and Auth, with IC Tooling's Host/Build/Testkit packages
outside production graphs. The dependency policy now rejects IC Build too,
including renamed transitive edges; development-only qualification remains allowed.
The inspected Tooling working tree already removes Testkit's Metrics dependency
and supplies its own benchmark-average error. That pending sibling work was
reviewed read-only and remains outside this batch's edits and qualification.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) and
[Memory patch qualification](../evidence/memory-0491.md) retain their own graphs.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [0.15.0 handoff](https://github.com/dragginzgame/ic-metrics/blob/a3b0c4a76145fddb0a36a4ce553435ae4ddb6b46/docs/status/current.md)
retains the completed dependency-identity cut and qualification. Its linked
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
