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

The released base is 0.15.4 at `b6bd4e37b6e201ac8c4c5dc99ed40ac409f0c319`.
The pending 0.15.5 patch qualifies the resolved Memory/Storage 0.50.10 graph,
which obtains the same 0.7.2 stable substrate through IC Platform 0.6.7.
Published-source comparison shows stable-substrate import/re-export changes,
with no collection implementation changes. Metrics' public APIs, V1 bytes,
package versions, dependency requirements and Rust 1.91 floor are unchanged;
hosts still own identity/provenance and no data reset is required.
The application guide also exercises exact totals above the narrow reporting
cap and requires retaining rows with unavailable narrow fields and source quality.

Focused Linux checks pass on this graph: 25 stable unit tests, three stable
doctests, 13 arithmetic doctests, stable-package native/Wasm Clippy and Rust 1.91
native all-target/Wasm library checks. Frozen V1 rows reopen, allocation leases
remain enforced, and invalid checkpoints preserve rows without writes.
Production-graph admission and its exclusion fixtures pass for native and Wasm;
the arithmetic package remains dependency-free and Host/Build/Testkit remain
excluded. Documentation links and diff checks pass. Full workspace CI, native
macOS and new IC costs were not run.

Shared Tooling 0.26.6 at `4cb9bc907154225a3f7e4c33fd8d75fbeaa125c8` and
its 117 payload digests belong to [the snapshot](../../.shared-tooling.snapshot).
Normal setup explicitly selects no IC executables; optional IC setup and checks
use the same `IC_TOOLS` list. Prior bundles and failure evidence stay retained.
Focused Linux adoption checks pass: snapshot integrity, offline tools, formatting
and hooks, production graphs/exclusion fixtures, local release and native-evidence
fixtures, upstream validation-runner/digest/reporter/fixture-copy tests, ShellCheck,
Perl syntax, documentation links and diff checks. Native evidence fixtures use
substituted action/Make effects; no hosted run or native macOS result is claimed.
Full CI and Rust-floor gates were not rerun for this tooling-only adoption.
The previously delivered 0.25.9 release guard matches
[PR #96](https://github.com/dragginzgame/ic-metrics/pull/96), now
closed as superseded. Its obsolete branch and the six other delivered or retired
contribution branches are deleted; verified private backups remain. Compiler and
library selections stay local; the host guide owns setup and policy.

The [capability contract](../extraction.md#capability-placement) places Metrics
alongside Timers, Jobs and Auth, with IC Tooling's Host/Build/Testkit packages
outside production graphs. The dependency policy rejects IC Build too,
including renamed transitive edges; development-only qualification remains allowed.

The maintainer closed [#82](https://github.com/dragginzgame/ic-metrics/issues/82)
as not planned. The existing local test write observer remains; no replacement
or adoption is claimed. Supplying work remains owned by
[Tooling #227](https://github.com/dragginzgame/ic-tooling/issues/227).

The maintainer closed [#83](https://github.com/dragginzgame/ic-metrics/issues/83)
as not planned until a real durable-consumer use case emerges. Volatile behavior
and the available opt-in persistence API are unchanged.

For [#72](https://github.com/dragginzgame/ic-metrics/issues/72), the approved
rewrite removes only the twelve recorded archive/checksum paths from published
head/tag histories. Eight branches and 44 tags changed IDs, including 0.15.2.
All 109 remote refs matched the filtered result at publication; the fresh clone
excludes all six original blobs. After retiring seven obsolete branches, the remote
retains main and all 101 release tags unchanged. Private originals, backups and mappings
remain retained. The maintainer closed the issue as not planned and elected not
to pursue the remaining GitHub-held refs/caches. The private Support draft was
not submitted; no complete erasure is claimed. Metrics has no open issues or PRs
at this tracker check.
Other clones must adopt the rewritten history without merging old ancestry.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) and
[Memory patch qualification](../evidence/memory-0491.md) retain their own graphs.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [sanitized 0.15.1 handoff](https://github.com/dragginzgame/ic-metrics/blob/29249c713bf3f842dacfb7ee1f3ad874fc2c9866/docs/status/current.md)
retains the completed capability boundary and release-guard qualification. Its linked
historical handoffs preserve earlier identities and evidence paths. Historical
observations are not current issue/PR status. Follow the
[archive distribution record](../evidence/archive-distribution-072.md) for public payloads.

## Owning follow-up links

Read the owning issues for their current disposition; this handoff is not a
second issue-status ledger:

- [Storage discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12).
