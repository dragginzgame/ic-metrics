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

The released base is 0.15.6 at `356a8c7f9defe136f20e7737e76891954c9c590f`.
The pending 0.15.7 patch adopts Shared Tooling's bounded Cargo setup waiting,
lock-withdrawal handling and source-cache initialization without a global lock.
The build-policy digest changed; explicit `make install-tools` completed and
offline checks admit the newly selected common tools and IC Build 0.64.0 editor
with its required `cli` feature. Tool pins and previous generations are retained.

Focused Linux checks pass: upstream Cargo-installer and lock-wait fixtures,
offline tool admission, formatting and hooks, production-graph/exclusion checks,
release and native-evidence fixtures, ShellCheck, snapshot integrity,
documentation links and diff checks. Fixture Git/Make effects remain substituted;
the selected metadata editor and offline Cargo are real. Producer fixtures cover
contention, owner withdrawal, timeout, interruption and immediate offline refusal.
The GitHub description still matches this repository's measurement scope.
No full CI, Rust-floor gates, native macOS or IC cost experiment ran.

The incoming Cargo.lock update is preserved byte-for-byte. Graph-policy checks
pass on that selection; this tooling adoption does not qualify its new
Memory/Storage/Platform runtime behavior. Library source, APIs, V1 bytes,
package versions and dependency requirements are unchanged by this batch. The
[0.15.6 handoff](https://github.com/dragginzgame/ic-metrics/blob/356a8c7f9defe136f20e7737e76891954c9c590f/docs/status/current.md)
retains the preceding tool and library qualification.

Shared Tooling 0.26.8 at `0b07c2a3163a5a66328e100b553baf93afd8ed07` and
its 117 payload digests belong to [the snapshot](../../.shared-tooling.snapshot).
Normal setup explicitly selects no IC executables; optional IC setup and checks
use the same `IC_TOOLS` list. Prior bundles and failure evidence stay retained.
Prior validation-runner/digest/reporter/fixture-copy evidence retains its original
source identity in the preceding handoffs; those unchanged helpers were not
requalified independently in this adoption. Native evidence fixtures use
substituted action/Make effects; no hosted run or native macOS result is claimed.
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
