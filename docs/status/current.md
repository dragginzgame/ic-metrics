# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and endpoints.
See [the extraction contract](../extraction.md).

## Released source

Verified published 0.2.11 source is `69b110b8fbefdac4773eac7631796f9dcb3f41a0`.
Its non-yanked registry archive has SHA-256
`dc75470aa6335a0b1f3dbefd30229e0ac10713f21193f21af3c03987afdfa0c9`,
with no dependencies or features. The checksum, embedded Git identity, maintained
Rust source, packaged guide, original manifest, README, license and lock verify.
The [release record](../evidence/release-0211.md) binds passing Linux native,
macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV gates. All three completed
native archives verify exact source and artifact hashes.
This finishes [#28](https://github.com/dragginzgame/ic-metrics/issues/28).
Earlier complete matrices retain their own scope in
[the 0.2.10 record](../evidence/release-0210.md) and historical records.
Cargo workspace, package and lock versions remain 0.2.11.

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

## Released 0.2.11 tooling

This compatible batch adopts committed Shared Tooling 0.1.23
`0ba0ad00ed94848e54ecc82629b6b7873b7284c0` through the canonical helper from a
clean detached checkout. The 70-file selection stays explicit and direct-only
delivery remains supported. After final consumer hooks, the runner rechecks the
index, committed payload and exact annotated tag. Completed direct recovery
confirms local/remote tag identity and branch ancestry before reporting success;
conflicts or unavailable observations stop without repeating effects.
[The adoption record](../evidence/adoption-0211.md) binds passing focused
Linux Bash 5/3.2 fixtures and static checks. Upstream 0.1.23 has passed all native
hosts; the release record above binds this consumer's complete source-matching
native matrix. Arithmetic, consumer ownership and dependency selection
are unchanged by the release-tooling adoption.

## Prepared 0.2.12 tooling

The compatible pending 0.2.12 batch adopts committed Shared Tooling 0.1.25
`672ab4b8af50c75ed21a359ca5968682de83be94` through the canonical exporter
from a clean detached checkout. The verified snapshot explicitly adds the
archiver and its fixture for 72 selected files. The runner prepares a Git ref
transaction and checks its type under the update lock before refreshing a
matching tracking ref. Symbolic replacements, including unchanged resolved OIDs,
and inspection failures preserve the observation without replaying delivery.
Direct-only release selection remains unchanged. Tooling LOC now includes `bin/`
and distinguishes unborn repositories from corrupt Git state; snapshot expansion
checks declared companions before replacing files.

The native collector reuses the helper for failed tool candidates. Its outer tar
archive deliberately retains Git intent/index evidence from release fixtures;
the shared helper excludes that metadata. Source receipts include the two new
files. Focused fixtures cover literal names, modes, links, candidate Git exclusion,
outer recovery-state retention, partial writes and occupied archive refusal.
[#31](https://github.com/dragginzgame/ic-metrics/issues/31) and
[#30](https://github.com/dragginzgame/ic-metrics/issues/30) retain committed
consumer native/download acceptance. Preparation evidence is in
[the adoption record](../evidence/adoption-0212.md).

The earlier same-OID race remains bound to uncorrected `eeb72e7` and retained
under `target/evidence/shared025-review/`; successful dirty-patch previews stay
under `target/evidence/shared025-tracking-preview/`. The earlier archive-only
native pass does not qualify the corrected runner. Matching upstream
[run 37767868576](https://github.com/dragginzgame/shared-tooling/actions/runs/37767868576)
was queued at initial preparation. This local batch does not establish native
consumer qualification or live interrupted release execution. Arithmetic,
package/workspace/lock version 0.2.11 and dependency pins remain unchanged.
Focused release-tooling, native archive/setup and LOC fixtures pass under Linux
Bash 5.2 and 3.2.57. ShellCheck, actionlint, documentation, pins, snapshot and
formatting checks pass; finalized changelog history is preserved byte-for-byte.
Upstream Linux and lint now pass; its macOS jobs were still queued at inspection.

## Downstream boundaries

The 2026-10-08 read-only inspection binds these local sources and selected locks.
Newer dirty work and remote publication require independent inspection; all
selected Metrics locks below refer to the registry package.

| Caller | Inspected local HEAD | Committed Metrics lock and inspected working-tree selection |
| --- | --- | --- |
| IcyDB | `cb8cefca1d68c20025398eae6dfab18a2eb45883` | Committed 0.2.8; dirty selection 0.2.10. Inclusive spans and CLI checked means. |
| Canic | `4c51a87c6a32397196bb3f65d064641194df10a5` | Public 0.110.53 commits Metrics 0.2.9; subsequent dirty work remains separate. Exclusive endpoint accounting and invocation-owned async checkpoints. |
| IC Timers | `7d3ef40c50e49b79a8e9e10fb7cb68cee244eb7b` | Committed Metrics lock 0.2.10. Scheduler/work summaries and local sample admission. The local commit advanced during inspection; earlier reads selected 0.2.9. |
| IC Backup | `8a1152d0a510f34f8daed59f06632306f7cf134e` | Committed 0.2.9; dirty selection 0.2.10. Nanosecond summaries and four-bound prepared-byte histogram. |
| IC Blob Storage | `704b8ebf6bea85a715e465e32e34758b601852ec` | Committed/clean Metrics lock 0.2.9. Restoration test probe, not production library instrumentation. |
| Toko Miner | `aeed004b03b9b5d848de3750d77a42c5160c5fdf` | Committed/working Metrics lock 0.2.9; other lock edits remain separate. Production action-count cohorts use `record_sample`. |

The 2026-10-08 remote recheck now finds IcyDB public 0.267.1 source
`cb8cefca1d68c20025398eae6dfab18a2eb45883`, selecting Metrics 0.2.8. Its
[CI](https://github.com/dragginzgame/icydb/actions/runs/37653174383) passes
Rust/MSRV/static but both native macOS jobs fail the retained release-lock lookup.
The owning explicit-template repair remains pending committed native acceptance
in [IcyDB #309](https://github.com/dragginzgame/icydb/issues/309). The successful
scheduled SQL evidence workflow is a separate gate, not Metrics native closure.
Canic's newer source is now public as 0.110.53
`4c51a87c6a32397196bb3f65d064641194df10a5`. Its
[exact CI](https://github.com/dragginzgame/canic/actions/runs/37752054026) passes
all eight Core perf host cases and facade/report projections. Both macOS gates
stop at worker fixtures calling `rg` before pinned host-tool installation.
PocketIC refuses a stale embedded allocation peer before test startup, so the
actual held-HTTP metrics interleaving case does not execute. The ordinary lane
also rejects a finalized changelog without a pending draft. Owning corrections
remain in [Canic #450](https://github.com/dragginzgame/canic/issues/450);
passing host cases do not close the missing native/IC acceptance.
Backup 0.6.0 and Blob
0.18.0 public main match the inspected commits; their later graph's native/runtime
outcomes were not requalified in this inventory. Toko has no matching hosted
run at inspection. Timers public main was `0b12c8a6dbe5f359f5499df67313ffa5c02af446`
at the remote read, before the newer local 0.14.14 commit was observed. Local
commits and active release validation are not completed native qualification.

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
