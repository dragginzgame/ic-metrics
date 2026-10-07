# Published 0.2.5 source and qualification

Tag `v0.2.5`, local HEAD and remote main identify
`d8b3a46f24518a033cd36e40bf1f1895099b809f`. Finalized notes and Cargo
metadata select 0.2.5. The release contains the reviewed 57-file Shared Tooling
snapshot at `25e7ce83149e081e4dcc52c55c33724e44153f2a` (0.1.14), including
the Make execution guard and consumer fixture/source-receipt propagation.
The [preparation record](adoption-025.md) retains its original uncommitted scope.

## Publication

The official sparse registry index reports non-yanked 0.2.5, no dependencies
or features, and checksum
`f03846f188137170575ee48c04ece8a5d2d54096206d55bd7f56cd97afeac2fe`.
The downloaded archive matches that checksum and embeds the release Git identity
and `crates/ic-metrics` package path. All five Rust files, original member
manifest, tagged README, license and lock match the release byte-for-byte.
Normalized metadata retains edition 2024, MSRV 1.88.0 and registry publication.
Rust source is unchanged from v0.2.4; histogram availability still starts at 0.2.4.

Index, archive, extracted payload, source checksums and CI inputs remain under
`target/evidence/release-025/`. No package, lock or version edit was made by
this inspection.

## Release CI

[CI run 37589261498](https://github.com/dragginzgame/ic-metrics/actions/runs/37589261498)
binds the exact release source. The initial receipt had Linux/MSRV passing,
Intel macOS running and Apple Silicon macOS queued. The later completed receipt
now passes Linux, native Intel macOS, native Apple Silicon macOS and MSRV, so
[#14](https://github.com/dragginzgame/ic-metrics/issues/14) is completed. Both
initial and completed observations are retained separately under the release
evidence directory. Earlier 0.2.4 and upstream native passes retain their identities.
No local full CI/test gate or workflow rerun/dispatch occurred.

## Downstream inspection

Read-only committed source and exact-source workflow inspection establish:

| Consumer | Inspected committed metrics graph | Owning qualification |
| --- | --- | --- |
| IcyDB | Remote/local `049e561a843a8d3f4526460fd15876a4a238df10`, requirement 0.2, registry lock 0.2.0 | Full CI fails; separate SQL Tier C workflow passes. |
| Canic | Local `d7698e1f0541cb52ad8d762bc1549a700b412e88`, requirement 0.2, registry lock 0.2.3 | Remote main is older `071a9c64d7ff71ba7a0a695d24a66de11b651aed`; its preflight fails and later gates are skipped. |
| IC Timers | Remote/local `0c90c391dff5960a7502fc15a0718b03631f2515`, 0.14.6, requirement 0.2, registry lock 0.2.3 | Main passes Linux, native Intel/ARM macOS and MSRV; tag-truth passes separately. |
| IC Backup | Remote/local `eece44dac79da1bfb36f82ce2cd30d51edd3a9c1`, 0.5.0, requirement 0.2, registry lock 0.2.3 | Main and tag runs pass Linux and both native macOS hosts. |

Sources: [IcyDB full CI](https://github.com/dragginzgame/icydb/actions/runs/37496328220),
[IcyDB SQL Tier C](https://github.com/dragginzgame/icydb/actions/runs/37560420313),
[Canic remote CI](https://github.com/dragginzgame/canic/actions/runs/37329324275),
[Timers main](https://github.com/dragginzgame/ic-timers/actions/runs/37584151377),
[Timers tag](https://github.com/dragginzgame/ic-timers/actions/runs/37584150869),
[Backup main](https://github.com/dragginzgame/ic-backup/actions/runs/37583420007) and
[Backup tag](https://github.com/dragginzgame/ic-backup/actions/runs/37583420151).

IcyDB fails pinned-formatting-tool installation in the static lane and portable
automation qualification on both macOS hosts; the aggregate lane also fails.
Canic fails its preflight validation step. `gh run view --log-failed` returned
empty output for both runs, retained as such; step names establish the failing
boundaries, not an underlying error diagnosis. No new root cause is claimed.

Passing IC Backup 0.5.0 does not qualify its separate uncommitted 0.5.1 custody
repair or explain the older same-source macOS contention observation:
[IC Backup #13](https://github.com/dragginzgame/ic-backup/issues/13) retains that
owner's demonstrated regression and required committed native proof.
[Canic #99](https://github.com/dragginzgame/canic/issues/99) retains invocation
accounting and actual IC interleaving evidence at its original source/graph.

All four sibling working trees were dirty and preserved. No sibling file edits,
consumer builds, dependency updates or IC cost measurements ran. Histogram
investigations still need owning workloads, bounds, budgets and qualification.
Root coordination remains in [#4](https://github.com/dragginzgame/ic-metrics/issues/4)
and [#10](https://github.com/dragginzgame/ic-metrics/issues/10).

## Shared Tooling

Remote and local committed main remain reviewed 0.1.14
`25e7ce83149e081e4dcc52c55c33724e44153f2a`; no newer committed source is
available to adopt. Dirty 0.1.15 work remains separate. New
[Shared Tooling #37](https://github.com/dragginzgame/shared-tooling/issues/37)
concerns Canic's retained successful logs, timings and structured failure events;
no committed logger API implements it yet. Do not copy dirty source or expand
this arithmetic library for that consumer tooling contract.
