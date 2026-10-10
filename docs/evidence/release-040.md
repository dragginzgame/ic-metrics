# Published 0.4.0 verification

Public main, annotated tag `v0.4.0`, package/workspace versions and embedded
registry Git identity match `97ec991776bb16efbab59faeb43bc72ce9ebcefa`.
The official non-yanked registry row has no dependencies or features and declares
Rust 1.85.0. Downloaded package SHA-256 verifies as
`6bdcedba0e995c3c57f1f608d9f1664b8ec56c0d437d330c13004e78dbce434d`.
Seven Rust files, the application guide, original manifest, root README and
license match released source. The packaged lock contains only Metrics 0.4.0.
Arithmetic source is unchanged from 0.3.7.

The release delivers the [Shared 0.2.13 tooling adoption](adoption-040.md) and
separately [qualified private Host 0.11 graph](host-dependencies-0110.md).
Operational LF/CR directory names are forbidden; retained artifacts are preserved.
There is no arithmetic API, consumer state, attribution, endpoint or report change.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38042698441)
was queued in the initial observation. A subsequent inspection finds Linux and both
package-floor checks passing; both macOS jobs are initially queued. The final
recheck finds Apple Silicon running and Intel still queued.
The Linux receipt `11665539876` independently verifies ZIP SHA-256
`ac2e6d01a8f371bff70e9307e448b5eff69deff293d7c581aad72e9d16fd9da0`
and inner archive SHA-256
`29bde8a495d20911f0d73736e45538f6f831eaae467589ebfed7283a494ca5d5`.
All 15 payload and 70 released-source hashes, source-file ordering, run/attempt/
host/pin identities and nine successful outcomes verify. Downloaded logs confirm
actual CLI, formatting/hooks, reporter/collector and release/admission fixture
execution. Two nonempty formatting diagnostics are retained. Documented fixture
effects remain substituted; this establishes no IC measurement or live release.

Publication and these partial results do not establish complete native acceptance. Snapshot-root
[#45](https://github.com/dragginzgame/ic-metrics/issues/45) and admitted-tool
preparation [#46](https://github.com/dragginzgame/ic-metrics/issues/46) retain that
acceptance; do not reuse earlier releases' receipts for this changed graph.
Tag/index observations, downloaded package/Linux archives and their verification are
retained under `target/evidence/release-040/`. No release, publication, workflow
dispatch, dependency resolution or build occurs during this verification.
