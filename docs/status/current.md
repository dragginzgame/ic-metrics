# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
IC Persistence owns the optional stable adapter and its governed-map tests.
This checkout publishes only arithmetic. Consumers own sampling, attribution,
units, identities, lifecycle and endpoints. The [extraction contract](../extraction.md)
and [host guide](../hosts.md) define local boundaries and qualification;
[Persistence's guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable)
owns durable integration and retained-data contracts.

## Selection and qualification

The released source base is 0.16.2 at `0d60020`. The adapter retirement is complete
here; Persistence published the replacement as 0.50.17. The arithmetic API and
Rust 1.91 floor are unchanged. Package and dependency identities belong to
[Cargo.toml](../../Cargo.toml) and [Cargo.lock](../../Cargo.lock), not this summary.

The pending 0.16.3 batch adopts Shared Tooling 0.26.20 at
`a7f85d45d4212d4c39225f58597580560a333550` through its canonical exporter
(120 payloads, including the linked Node/npm guide). The compact baseline delegates
detailed rules to task-specific references; the local overlay retains Metrics
ownership and validation choices.
Detailed change accounting is opt-in. No npm SDK or RPC-budget caller exists here.

Normal release commands now start fresh from clean committed metadata without
scanning or replaying historical plans. Exact attempt recovery uses
`make release-resume VERSION=X.Y.Z`. Build/validation evidence remains retained;
the shared runner supersedes only the new candidate's old plan and receipts.
Cargo-tool setup reports phase outcomes on stderr. Read-only admission reports
admitted contention as exit status 75 and supports explicit bounded waits.
Tool pins, library source/API, package versions and dependency selections are unchanged.

The [0.16.2 handoff](https://github.com/dragginzgame/ic-metrics/blob/0d60020987fe706e8182b6d4ab9c87a406876f16/docs/status/current.md)
retains dependency-free declaration admission and preceding validation details.
It calls that batch pending; the release tag and finalized changelog now identify
it as released. Persistence owns stable-adapter qualification.

Focused checks pass: snapshot integrity, pins, formatting, offline tool admission,
release/hook retention and admission fixtures, native evidence/recovery fixtures,
ShellCheck with sourced helpers, local documentation links and diff whitespace.
`make install-tools` prepared the pinned selections after initial tool admission
found a missing current selection. Release/action effects are substituted in
fixtures. No full release gate or new native macOS execution is claimed.

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
