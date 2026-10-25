# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
IC Persistence owns the optional stable adapter and its governed-map tests.
This checkout publishes only arithmetic. Consumers own sampling, attribution,
units, identities, lifecycle and endpoints. The [extraction contract](../extraction.md)
and [host guide](../hosts.md) define local boundaries and qualification;
[Persistence's guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable)
owns durable integration and retained-data contracts.

## Selection and qualification

The released source base is 0.16.1 at `b6193cb`. The adapter retirement is complete
here; Persistence published the replacement as 0.50.17. The arithmetic API and
Rust 1.91 floor are unchanged. Package and dependency identities belong to
[Cargo.toml](../../Cargo.toml) and [Cargo.lock](../../Cargo.lock), not this summary.

The pending 0.16.2 batch simplifies dependency-free admission to one locked,
offline Cargo metadata observation. All normal/build declarations are forbidden,
including inactive optional and target-specific edges. This already establishes
an empty production graph, so compiler-host discovery and repeated native/Wasm
graph traversal are retired. Development dependencies remain allowed except for
the existing direct stable-substrate prohibition. Fixtures retain declaration
coverage and distinguish failed, malformed and incomplete metadata observations.

The unused graph helper is retired by canonical snapshot refresh (117 payloads) at
the same Shared Tooling revision, 0.26.10 `a8141e775983c7fe504c4dd911e978152e657fdf`.
The README now selects the current 0.16 arithmetic contract. The host guide links
Persistence's stable-adapter qualification instead of maintaining its graph rules.
Library source, API, package versions and dependency selections are unchanged.

The [0.16.1 handoff](https://github.com/dragginzgame/ic-metrics/blob/b6193cb/docs/status/current.md)
retains preceding validation identities, including the Rust-floor doctests and
native evidence fixtures. Focused checks for this batch pass: real declaration admission, refusal fixtures
with inherited `CDPATH`, Perl syntax, ShellCheck, snapshot verification, formatting,
release-command fixtures, actual offline package verification and local doc links.
Release-command effects are substituted. No new full release gate or native
macOS result is claimed.

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
