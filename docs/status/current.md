# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
IC Persistence owns the optional stable adapter and its governed-map tests.
This checkout publishes only arithmetic. Consumers own sampling, attribution,
units, identities, lifecycle and endpoints. The [extraction contract](../extraction.md)
and [host guide](../hosts.md) define local boundaries and qualification;
[Persistence's guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable)
owns durable integration and retained-data contracts.

## Selection and qualification

The released source base is 0.16.0 at `c0f033a`. The adapter retirement is complete
here; Persistence published the replacement as 0.50.17. The arithmetic API and
Rust 1.91 floor are unchanged. Package and dependency identities belong to
[Cargo.toml](../../Cargo.toml) and [Cargo.lock](../../Cargo.lock), not this summary.

The pending 0.16.1 batch enforces zero production dependency declarations,
including inactive optional and target-specific edges. Development dependencies
remain allowed except for the existing direct stable-substrate prohibition.
Native/Wasm graph observation remains an independent check. Fixtures distinguish
policy refusal from observation failure and no longer repeat tooling-name cases.

Native source evidence now includes the packaged root README. Local graph/source
fixtures resolve their roots independently of inherited `CDPATH`. The Rust-floor
adapter additionally runs public doctests on the selected minimum compiler.
These are contributor validation changes, not arithmetic API or runtime changes.

Focused checks pass for declaration policy, native/Wasm production graphs,
source selection with inherited `CDPATH`, all 13 Rust 1.91 doctests, formatting,
ShellCheck, snapshot integrity and documentation links. Native-evidence recovery
and release-command fixtures also pass with substituted effects; they are not
hosted CI. Full release gates and native macOS qualification remain separate. The reviewed Shared
Tooling snapshot remains 0.26.10 at `a8141e775983c7fe504c4dd911e978152e657fdf`.
No shared payload or dependency selection changes in this batch.

## Historical dispositions

The [0.16.0 handoff](https://github.com/dragginzgame/ic-metrics/blob/c0f033a/docs/status/current.md)
retains the migration's original validation and closed investigation history.
Its statements about pending migration and local stable tests are historical,
not current ownership or live issue status. The stable write observer moved
with the adapter; no local adoption work remains for that observer.

For archive issue #72, the maintainer elected not to pursue remaining
GitHub-held refs/caches. Private originals and rewrite backups remain retained;
no complete erasure is claimed. Other clones must adopt the rewritten history
without merging old ancestry. Follow the
[archive distribution record](../evidence/archive-distribution-072.md) before
selecting any public evidence payload.

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
