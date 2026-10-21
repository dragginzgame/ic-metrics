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

Release source `ff38c84cdbb73c01c08be3424d71aa34e35f740f` (0.15.1) passes
[Linux, both macOS hosts and native/Wasm MSRV CI](https://github.com/dragginzgame/ic-metrics/actions/runs/39567196567).
The incoming Memory/Storage 0.50.5 lock update is preserved separately; the
released source's CI does not qualify that newer selection.

The pending 0.15.2 changelog covers the compatible lockfile update and the
maintainer's durable-consumer disposition; package versions remain unchanged.

Shared Tooling's reviewed source and payload digests belong to
[the snapshot](../../.shared-tooling.snapshot). The delivered 0.25.9 release
guard matches [PR #96](https://github.com/dragginzgame/ic-metrics/pull/96), now
closed as superseded without merging or deleting its branch. Compiler and
library selections stay local; the host guide owns setup and policy.

The [capability contract](../extraction.md#capability-placement) places Metrics
alongside Timers, Jobs and Auth, with IC Tooling's Host/Build/Testkit packages
outside production graphs. The dependency policy rejects IC Build too,
including renamed transitive edges; development-only qualification remains allowed.

The official `ic-testkit-native` 0.63.0 archive supplies heap allocation
measurement, but no stable-memory IO observer. The existing write observer
remains until a supplying registry release and qualified adoption.
[Tooling #227](https://github.com/dragginzgame/ic-tooling/issues/227) now records
the canonical local implementation at `14a04da0`; remote Tooling main remains
`62ab46bf` and the registry still ends at native 0.63.0 at this check. The separate
Metrics proposal at `/tmp/metrics-observer-tooling.K50gSP`, commit `535e5f5f`, is
retained unpublished; do not submit a competing PR. Its passing focused Linux
checks do not qualify the owner's differing implementation or a registry release.
Metrics has no open PRs; no observer publication or adoption is claimed.

The maintainer closed [#83](https://github.com/dragginzgame/ic-metrics/issues/83)
as not planned until a real durable-consumer use case emerges. Volatile behavior
and the available opt-in persistence API are unchanged.

For [#72](https://github.com/dragginzgame/ic-metrics/issues/72), the unpublished
history-cleanup review and verified private original bundle are retained in
`/tmp/metrics-history072.pDE2nd/REVIEW.md`. Its draft removes only the twelve
recorded original archive/checksum paths from public head/tag histories. Eight
branches and 43 tags change IDs; current main's source tree is identical.
Shared-history publication requires explicit approval and a fresh remote-ref
comparison. GitHub caches/PR refs and existing clones need separate disposition;
the dry run does not close the issue or change live refs.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) and
[Memory patch qualification](../evidence/memory-0491.md) retain their own graphs.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [0.15.1 handoff](https://github.com/dragginzgame/ic-metrics/blob/ff38c84cdbb73c01c08be3424d71aa34e35f740f/docs/status/current.md)
retains the completed capability boundary and release-guard qualification. Its linked
historical handoffs preserve earlier identities and evidence paths. Historical
observations are not current issue/PR status. Follow the
[archive distribution record](../evidence/archive-distribution-072.md) for public payloads.

## Owning follow-up links

Read the owning issues for their current disposition; this handoff is not a
second issue-status ledger:

- [Published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82).
- [Storage discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12).
- [Evidence archive distribution review](https://github.com/dragginzgame/ic-metrics/issues/72).
