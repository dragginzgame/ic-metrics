# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and
endpoints. See [the extraction contract](../extraction.md).

## Released source

The latest verified published release is 0.2.7, tag `v0.2.7`, at
`09c6786c3b68759ea0ead4d1b987b5a9b472bdbb`. The non-yanked registry archive
matches its checksum, embedded Git identity and maintained package files.
[The release record](../evidence/release-027.md) binds publication and the complete
passing Linux, macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV matrix.
Cargo package/workspace and lock versions remain 0.2.7.

Histograms are available from 0.2.4; checked means are available from 0.2.6.
`checked_mean(samples, total)` and `MeasurementSummary::mean()` return `None`
for empty `(0, 0)`, `Some(0)` for measured zero and floor division for valid
nonempty aggregates. Inconsistent empty pairs and either counter at `u64::MAX`
return typed errors, including an exactly reached cap. Recording, storage and
ownership contracts are unchanged. The
[application guide](../../crates/ic-metrics/src/application.md) is packaged and
compiled; [arithmetic evidence](../evidence/arithmetic-026.md) retains its
original source, host/Wasm, MSRV and documentation scope.

The [histogram experiment](../evidence/histogram-cost-026.md) measures an isolated
Canic recording source-copy on Linux PocketIC 16.0.0, with 138 validated calls.
At 1,000 repeated-key records, two histogram bounds add 42,000–75,000
instructions, 42,035–75,035 observed whole-update cycles and 208 raw Wasm bytes
over count/total; slots use 72 versus 16 bytes. This does not qualify a full
consumer, other bound counts/cardinalities, timer admission, mainnet or macOS.

## Pending 0.2.8

This compatible tooling/documentation batch adopts reviewed committed Shared
Tooling 0.1.18 at `a3430b34b32a60f3b245a2b4f7e2f5321556fe56`, through its
canonical helper from a clean detached checkout. All 67 declared files are
recorded in `.shared-tooling.snapshot`; sibling dirty source is excluded.
The [adoption record](../evidence/adoption-028.md) binds focused checks and
propagation. No arithmetic API, Cargo package version or locked dependency changes.

The shared logger rejects Make options and assignments before validation effects.
LOC reporting excludes physical target paths behind aliases; fixtures isolate
enclosing Cargo configuration and qualify adopted working-tree bytes independently
of the upstream exporter. Explicit `make install-rust-tools` prepares pinned
Cargo tools in `.tools/rust/bin`, with offline `make rust-tools-check`; both attach
to the aggregate setup/check commands. Native CI uses those same helpers and
retains failed Rust installation output. Ordinary validation never installs tools.

[Upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37604299590)
passes all three native hosts and lint/security at the adopted revision. This
consumer's new committed native CI remains separate from local Linux/Bash 3.2
checks and the released 0.2.7 matrix. The scope is recorded in
[#21](https://github.com/dragginzgame/ic-metrics/issues/21) and
[#22](https://github.com/dragginzgame/ic-metrics/issues/22).

## Downstream boundaries

The 2026-10-07 read-only inspection found the following concrete callers. Source
identities bind this observation; newer dirty work and remote publication require
independent inspection. All selected locks below refer to the registry package.

| Caller | Inspected local HEAD | Metrics lock and scope |
| --- | --- | --- |
| IcyDB | `15e083e479129bb8a62aede0e768a2b5c40be23b` | Committed 0.2.7; inclusive spans and CLI `checked_mean` projection. |
| Canic | `fb191848a728d00a0451fe604e31182ab0573376` | Committed 0.2.7; exclusive endpoint accounting and invocation-owned async checkpoints. |
| IC Timers | `7e98cbc969b1e6d6098786a7f36ac3ba66d8165a` | Committed 0.2.7; scheduler/work summaries and consumer-owned sample admission. |
| IC Backup | `7660b56c196d2af3d084524bc74bb9dd4982d1ad` | Committed 0.2.7; nanosecond summaries and four-bound prepared-byte histogram. |
| IC Blob Storage | `aadfe16216ddfc20f8dd68de048b0846c54dcfb3` | Committed 0.2.7; restoration test probe uses `record_sample`, not production library instrumentation. |
| Toko Miner | `9071b4cc9c1cf0d6d905f73592154b5108ab2147` | HEAD lock 0.2.2; working-tree lock 0.2.7. Production action-count cohorts use `record_sample`. |

IcyDB's CLI projects empty, inconsistent or saturated aggregates as `unavailable`,
while preserving numeric zero and floor rounding; its own output compatibility
belongs to [IcyDB #313](https://github.com/dragginzgame/icydb/issues/313).
Canic's async attribution stays with
[Canic #99](https://github.com/dragginzgame/canic/issues/99).
Histogram workload, bounds and storage decisions belong to
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) records its
summary-only decision without a demonstrated distribution workload. Toko's
cohorts count actions, not instruction-value ranges; a future distribution must
retain that separate contract. Blob probe and Toko application qualification
belong to [Blob #19](https://github.com/dragginzgame/ic-blob-storage/issues/19) and
[Toko #6](https://github.com/dragginzgame/toko-miner/issues/6).

Consumer adoption and complete owning runtime/native qualification remain
separate from root publication and local lock updates, tracked in
[#4](https://github.com/dragginzgame/ic-metrics/issues/4) and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).
No sibling files were mutated by this batch. Historical source-bound evidence
stays under `docs/evidence/`; [the host record](../hosts.md) distinguishes focused
Linux execution from owning native macOS CI. No full local CI/test gate,
commit, push, tag, package version change or release command ran.
