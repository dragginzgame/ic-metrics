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

## Complete native acceptance

A later review finds the exact 0.4.0 run complete and passing on Linux, Intel
macOS and Apple Silicon, including both package-floor checks. All three
independently downloaded receipts verify against that released source:

| Host | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Linux x86_64 | `11665539876` | `ac2e6d01a8f371bff70e9307e448b5eff69deff293d7c581aad72e9d16fd9da0` | `29bde8a495d20911f0d73736e45538f6f831eaae467589ebfed7283a494ca5d5` |
| macOS Intel | `11668175438` | `39ccc2bb9800f34884f9fb57341cb5f04205eadf070851077529d7941c3052ae` | `3c2e22ce235529acd65bd2d8f16113b21041a4f78327fa3ba00d26d551750989` |
| macOS Apple Silicon | `11667648298` | `3df5b4d6326815647b112d852ef8de6b510b604ac9d5ac4c4a0115c060937863` | `f5e99f7dbb84bcb7f979aa1b8db7a1a979b0d57b04e7e8d52927bff5124bab4f` |

Each receipt verifies all 15 payload and 70 released-source hashes, the exact
workflow source catalog, run/attempt/host/pin identities and nine successful
outcomes. Each downloaded log proves actual snapshot verification, metadata/
admission/standard-release, native collector and inspector CLI execution; each
retains two nonempty formatting diagnostics. Tool/release effects inside the
fixtures remain substituted. Combined with the separately recorded actual
negative-path and preparation checks, this completes
[#45](https://github.com/dragginzgame/ic-metrics/issues/45) and
[#46](https://github.com/dragginzgame/ic-metrics/issues/46).

The initial queue/running observations above remain historical. This acceptance
does not qualify 0.5.0's changed snapshot/aggregate. New downloads and verification
are under `target/evidence/review-050/`; no build, rerun or release is performed.
