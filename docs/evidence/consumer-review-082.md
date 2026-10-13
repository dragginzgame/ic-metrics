# Consumer review after published Metrics 0.8.1

Read-only review of the six extraction consumers separates recorded math from
reporting, reset identity and owning acceptance. Source hashes distinguish
committed and working files; incoming graphs are not relabelled as delivered.
No consumer build, full suite or sibling edit runs in this review.

| Consumer | Reviewed state | Remaining boundary |
| --- | --- | --- |
| IcyDB | Local 0.272 source records tracked entity/lifecycle/journal-fold aggregates and projects flags plus optional exact means. Current lock selects Metrics 0.8.1. | [#354](https://github.com/dragginzgame/icydb/issues/354) retains owning delivery/qualification; inclusive spans and exact journal debt stay separate. |
| Canic | Dirty perf work records tracked aggregates; the working graph still contains Metrics 0.7.3 and 0.8.0. | `PerfEntry` and both view constructors drop overflow flags; public sampling infers loss from numeric caps. [#523](https://github.com/dragginzgame/canic/issues/523#issuecomment-6129422434) owns quality propagation and the consumer contract. |
| IC Timers | Released 0.21.0 selects Metrics 0.8.0 and retains tracked scheduler/work summaries. | [#50](https://github.com/dragginzgame/ic-timers/issues/50) is closed against its owning delivered receipt. New graphs/hosted runs retain their own qualification. |
| IC Backup | Released 0.21.0 selects Metrics 0.8.0; a dirty incoming lock selects 0.8.1. Existing diagnostic summaries and prepared-byte histogram retain shared types. | [#41](https://github.com/dragginzgame/ic-backup/issues/41) remains open at the issue observation. Nanoseconds/bytes, guard lifetime and backup authority stay separate. |
| Blob test probe | Released 0.22.14 includes tracked read aggregates and independent checked byte overflow. A dirty incoming lock selects Metrics 0.8.1. | [#62](https://github.com/dragginzgame/ic-blob-storage/issues/62) retains owning qualification/closeout; these are private probe reports, not production storage metrics. |
| Toko Miner | Current direct requirement/lock selects Metrics 0.8/0.8.1, while action recording still imports the removed raw helper. | [#48](https://github.com/dragginzgame/toko-miner/issues/48#issuecomment-6129422745) owns recording/report migration. [#49](https://github.com/dragginzgame/toko-miner/issues/49) separately owns the IcyDB quality bridge and database-cost UI. |

Canic's current public sampler can miss a clipped `u128::MAX` instruction total
by comparing it to `u64::MAX`; history can then project an unchanged clipped
value as an exact zero delta. That correction belongs at the consumer projection,
not in another Metrics recording path. Toko's database UI similarly treats an
ordinary exact `u128` total equal to `u64::MAX` as unavailable and marks raw
numeric caps as lower bounds. Producer quality must survive the complete bounded
provider/wire/UI path. Neither source finding claims new runtime execution.

## Demonstrated arithmetic opportunity

[Metrics #68](https://github.com/dragginzgame/ic-metrics/issues/68) investigates
a small overflow-aware scalar counter. Timers has registration-local diagnostic
event counts; Toko has outcome/intent-byte diagnostics; Blob independently tracks
a byte total and sticky loss. A dedicated primitive could share exact-cap and
overflow arithmetic without extracting lifecycle classification, attribution,
identities, endpoints or authoritative spending/debt. Compare the simpler
`MeasurementAggregate::record(1)` alternative first and select width from real
consumer contracts. No new API, storage kind or performance improvement is
implemented or claimed by this review. Future work stays in the owning issue.

## Publication and qualification identities

Released/public Metrics 0.8.1 and peeled v0.8.1 agree on
`368f2dca9a46faa639c3074ee45fc76d89b443e7`. Both official non-yanked package
archives match registry checksums, their embedded Git source and all packaged
Rust files:

| Package | SHA-256 | Rust floor |
| --- | --- | --- |
| ic-metrics 0.8.1 | `5b2d23a378f6dd80661e0a93313ad31170842fe2558e4d8df017061877986d86` | 1.85 |
| ic-metrics-stable 0.8.1 | `b40afd217c738b9da9ee824e6bd12be5452219f9182852d40c6e7894536c9412` | 1.88 |

The older 0.8.0 run has passing Linux, Intel macOS and floors, with Apple Silicon
cancelled. The newer exact-source
[0.8.1 run](https://github.com/dragginzgame/ic-metrics/actions/runs/38284066419)
has passing floors, Linux running and both macOS jobs queued at this observation.
No complete replacement matrix exists yet; [#66](https://github.com/dragginzgame/ic-metrics/issues/66)
remains open. Original Canic qualification stays in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).
The later [0.8.1 native closeout](release-081.md) records the now-complete
replacement matrix and source-bound receipt verification, completing #66.
The frozen observation here retains its earlier scope.

Existing incoming Metrics Cargo edits select Host artifacts/FS 0.15.1, Memory
0.35.19 and Syn 3.0.9; they are preserved and not qualified by this inspection.
The consumed Host production source is unchanged from 0.15.0, and Memory 0.35.19
has no production Rust delta from 0.35.18. Neither fact replaces selected-graph
validation. Shared 0.9.7 is available; Metrics retains its reviewed 0.9.6 snapshot.
No package version, Git index/ref, release or publication effect occurs here.

The [frozen review](consumer-review-082.tar.gz) and
[checksum](consumer-review-082.tar.gz.sha256) retain 23 selected consumer files,
committed/working graph identities, issue observations and feedback, current
Metrics inputs, official archives and publication/CI observations. Fresh readback
verifies the frozen source hashes and both package checksums. The preparation
receipts for [the restoration fix](summary-restoration-081.md) and
[Shared 0.9.6](adoption-081-shared-096.md) retain their original pre-release scope.
