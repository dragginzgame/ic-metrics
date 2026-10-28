# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
IC Persistence owns the optional stable adapter and its governed-map tests.
This checkout publishes only arithmetic. Consumers own sampling, attribution,
units, identities, lifecycle and endpoints. The [extraction contract](../extraction.md)
and [host guide](../hosts.md) define local boundaries and qualification;
[Persistence's guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable)
owns durable integration and retained-data contracts.

## Selection and qualification

The latest finalized release is 0.16.3 at `27a46f1`; the current committed base
is its changelog presentation merge `78a99d9`. The adapter retirement is complete
here; Persistence published the replacement as 0.50.17. The arithmetic API and
Rust 1.91 floor are unchanged. Package and dependency identities belong to
[Cargo.toml](../../Cargo.toml) and [Cargo.lock](../../Cargo.lock), not this summary.

The pending 0.16.4 batch adopts Shared Tooling 0.27.4 at
`83f87cca71a420a61e69b6bdd018be27d4455daf` through its canonical exporter
(122 payloads). Trusted-source verification also compares every payload's bytes
and mode with that independently selected commit. The formatting runner now
reports pass timings and reuses exact successful inputs. The hook fixture selects
actual consumer roots and lets Shared derive their complete companion closure.
The catalog adds optional sccache without enabling it here. Library source/API,
package versions, dependency selections and the Rust 1.91 floor are unchanged.

The release gate remains host/Cargo/native/Wasm-only. Existing native bootstrap
precedes common tools and the selected IC Build editor; no browser or IC tool
caller is added. The release commands retain their fresh-start behavior and
`make release-resume VERSION=X.Y.Z` retains exact-attempt recovery.

The [0.16.3 handoff](https://github.com/dragginzgame/ic-metrics/blob/27a46f1076ee757680b6e6b1974947e482f3158d/docs/status/current.md)
retains the preceding adoption and dependency-free declaration qualification.
Its pending label is historical; the tag and finalized changelog own release state.

Focused checks pass: trusted-source snapshot comparison, pins, formatting,
offline tool admission, actual release/hook retention and admission fixtures,
native evidence/recovery fixtures, sourced ShellCheck, local documentation links
and diff whitespace. Initial metadata-fixture admission refused an unprepared
editor selection; retained evidence is under `target/evidence/native-ci/`.
`make install-tools` prepared current selections and the affected fixtures pass.
Release/action effects are substituted. No full release gate or new native macOS
execution is claimed.

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
