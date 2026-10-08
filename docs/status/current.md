# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and endpoints.
See [the extraction contract](../extraction.md).

## Released source

Verified published 0.2.10 source is `90262c3b086ee39016a6f36902a610a78a139301`.
Its non-yanked registry archive has SHA-256
`8e2eaa37874c60628dd5610305baafd278bb6479724cc22d7f2b556ca1f7d4ee`,
with no dependencies or features. The checksum, embedded Git identity, maintained
Rust source, packaged guide, original manifest, README, license and lock verify.
The [release record](../evidence/release-0210.md) binds passing Linux native,
macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV gates. All three downloaded
native archives verify exact source and artifact hashes. This completes the
owning qualification in [#27](https://github.com/dragginzgame/ic-metrics/issues/27).
Earlier complete matrices retain their own scope in
[the 0.2.9 record](../evidence/release-029.md) and historical records.
Cargo workspace, package and lock versions remain 0.2.10.

Histograms are available from 0.2.4; checked means are available from 0.2.6.
`checked_mean(samples, total)` and `MeasurementSummary::mean()` return `None`
for empty `(0, 0)`, `Some(0)` for measured zero and floor division for valid
nonempty aggregates. Inconsistent empty pairs and either counter at `u64::MAX`
return typed errors, including an exactly reached cap. Recording, storage and
ownership contracts are unchanged. The
[application guide](../../crates/ic-metrics/src/application.md) is packaged and
compiled; [arithmetic evidence](../evidence/arithmetic-026.md) retains its original
source, host/Wasm, MSRV and documentation scope.

The [histogram experiment](../evidence/histogram-cost-026.md) measures an isolated
Canic recording source-copy on Linux PocketIC 16.0.0, with 138 validated calls.
At 1,000 repeated-key records, two histogram bounds add 42,000–75,000
instructions, 42,035–75,035 observed whole-update cycles and 208 raw Wasm bytes
over count/total; slots use 72 versus 16 bytes. This does not qualify a full
consumer, other bound counts/cardinalities, timer admission, mainnet or macOS.
The original ignored replay inputs are unavailable and the maintainer has no
backup. The historical report and identities remain unchanged. A separate
[durable arithmetic replay](../evidence/histogram-replay-029.md) supplies new,
checksum-bound source/lock/result/Wasm inputs; it does not reproduce the old
Canic experiment or extend its qualification.

Released 0.2.9 includes the canonical path/date repairs and source-first native
CI evidence collection. Their preparation and controlled failure checks remain
in [the adoption record](../evidence/adoption-029.md), with committed native
qualification in [the release record](../evidence/release-029.md).
The public frozen histogram bundle matches its checksum and all payload hashes;
[#26](https://github.com/dragginzgame/ic-metrics/issues/26) is complete. Its
138 measured/six admission replies, rebuilt identical Wasms and repeat replay
remain bound to the separate direct-arithmetic experiment. Missing historical
Canic inputs are not recovered or relabelled.

## Released 0.2.10 tooling

The released contribution/release-tooling batch adopts committed Shared Tooling
0.1.22 at `2687f26317952c43c685f7f799ed09288dc10a67` through the canonical
helper from a clean detached checkout. The 70-file snapshot explicitly adds
the contribution rules and PR release helper and refreshes linked guidance. Local AGENTS.md and
README now allow an explicitly requested PR to include scoped commits and a
topic-branch push. Ordinary continuation remains local work; merges, direct
integration-branch pushes and releases retain separate explicit authority.
Required protections/checks are preserved. The
[adoption review](../evidence/adoption-0210.md) binds interpretation and focused
checks. The [release-tooling review](../evidence/adoption-0210-shared022.md)
binds the subsequent runner refresh and direct-only delivery guard. Unsupported
PR delivery fails before release dispatch or metadata effects. Ordinary PR
contributions remain supported. Arithmetic, pins, package versions and locks are
unchanged by adoption. Its source-matching native matrix and downloaded receipts
now qualify the owning fixtures at 0.2.10; live interrupted GitHub release effects
remain distinct from command substitutes.

## Pending 0.2.11

This compatible batch adopts committed Shared Tooling 0.1.23
`0ba0ad00ed94848e54ecc82629b6b7873b7284c0` through the canonical helper from a
clean detached checkout. The 70-file selection stays explicit and direct-only
delivery remains supported. After final consumer hooks, the runner rechecks the
index, committed payload and exact annotated tag. Completed direct recovery
confirms local/remote tag identity and branch ancestry before reporting success;
conflicts or unavailable observations stop without repeating effects.
[The adoption record](../evidence/adoption-0211.md) binds passing focused
Linux Bash 5/3.2 fixtures and static checks. Upstream 0.1.23 has passed all native
hosts, but this uncommitted consumer source still requires its own native CI in
[#28](https://github.com/dragginzgame/ic-metrics/issues/28). Arithmetic, consumer
ownership, pins and dependency selection are unchanged; no package version or
release effect is selected by the 0.2.11 changelog heading.

## Downstream boundaries

The 2026-10-07 read-only inspection binds these local sources and selected locks.
Newer dirty work and remote publication require independent inspection; all
selected Metrics locks below refer to the registry package.

| Caller | Inspected local HEAD | Committed Metrics lock and inspected working-tree selection |
| --- | --- | --- |
| IcyDB | `8a5d094c9f9057b47d467d790b6a3871fd7c1561` | Committed/clean 0.2.8. Local preparation under active maintainer release validation at inspection; inclusive spans and CLI checked means. |
| Canic | `4bee0f8f69c80825e41d6100bde7575c5002980d` | Committed 0.2.8; dirty selection 0.2.9. Exclusive endpoint accounting and invocation-owned async checkpoints. |
| IC Timers | `72e8f5d9769d00fbe165b16cd6eb2d81cf1b0a67` | Committed 0.2.8; dirty selection 0.2.9. Scheduler/work summaries and local sample admission. |
| IC Backup | `a388d4185073853eda9113456deae2b4bdd2685b` | Committed/clean 0.2.9. Local preparation; nanosecond summaries and four-bound prepared-byte histogram. |
| IC Blob Storage | `7c41e3a90996157312aa40985a9861f4c03ca35e` | Committed 0.2.8; dirty selection 0.2.9. Restoration test probe, not production library instrumentation. |
| Toko Miner | `aeed004b03b9b5d848de3750d77a42c5160c5fdf` | Committed/clean 0.2.9. Local preparation; production action-count cohorts use `record_sample`. |

The 2026-10-08 remote recheck now finds IcyDB public 0.267.1 source
`cb8cefca1d68c20025398eae6dfab18a2eb45883`, selecting Metrics 0.2.8. Its
[CI](https://github.com/dragginzgame/icydb/actions/runs/37653174383) passes
Rust/MSRV/static but both native macOS jobs fail the retained release-lock lookup.
The owning explicit-template repair remains pending committed native acceptance
in [IcyDB #309](https://github.com/dragginzgame/icydb/issues/309). The successful
scheduled SQL evidence workflow is a separate gate, not Metrics native closure.
Canic's public source remains older `071a9c64d7ff71ba7a0a695d24a66de11b651aed`;
the newer local source still has no matching hosted run. New local Backup/Toko
sources likewise have no matching hosted run. Local commits and active release
validation are not publication or completed native qualification.

Timers' arithmetic-only adoption is already qualified at 0.14.6 on all three
native hosts and MSRV. Its later 0.14.12 main CI passes Linux/MSRV/Apple Silicon
but lacks Intel execution because GitHub could not acquire a runner; tag truth
passes separately. Backup's selected metrics integration is qualified at 0.5.2.
These completed source-bound adoptions do not automatically qualify later graphs
or reopen merely because another release has unrelated outstanding work.

Blob 0.17.1's workflow also executes the actual restoration-metrics PocketIC
case, despite its tooling-oriented name. All three native logs confirm the
named case passes. The earlier tooling-only description was incorrect;
[the consumer review](../evidence/consumer-closeout-0210.md) binds the correction
to actual commands, source and downloaded logs. Its scope remains a test probe,
not production instrumentation. No sibling source, graph or validation is changed.

IcyDB's CLI output compatibility belongs to
[IcyDB #313](https://github.com/dragginzgame/icydb/issues/313); Canic's async
attribution remains in [Canic #99](https://github.com/dragginzgame/canic/issues/99).
Histogram workload, bounds and storage decisions belong to
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) records the
summary-only decision without a demonstrated distribution workload. Toko's
cohorts count actions, not instruction-value ranges; Blob probe and Toko
application qualification belong to completed source-bound
[Blob #19](https://github.com/dragginzgame/ic-blob-storage/issues/19) and open
[Toko #6](https://github.com/dragginzgame/toko-miner/issues/6).

Remaining original extraction qualification is consolidated in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10): IcyDB's adopting-source
focused/native acceptance and Canic's adopting-source actual interleaving/native
acceptance. [#4](https://github.com/dragginzgame/ic-metrics/issues/4) closes as a
duplicate tracker; its outstanding obligations remain in #10. Timers, Backup
and Blob retain their completed adoption scopes. Toko application follow-up
is separate from the original reader-cut closure criteria. Histogram
investigators now have the published mean API and checksum-bound public replay
feedback in their existing issues; no new instrumentation is requested.
No sibling files were edited. Historical evidence stays under `docs/evidence/`;
[the host record](../hosts.md) separates focused Linux checks from native CI.
No full local CI/product-test gate, dependency upgrade, package version change,
commit, push, tag or release command ran.
