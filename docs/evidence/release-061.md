# Published 0.6.1 verification

Public main, local HEAD, the peeled annotated tag `v0.6.1`, package/workspace
versions and the archive's embedded Git identity agree on
`39b357eb4e53051b5ad9afcfcd0a8c147c68a524`. The official non-yanked registry row
declares Rust 1.85.0, no dependencies and no features. Downloaded archive SHA-256
verifies as `756fd394c6bc660673660f9b0ac49aaad90725db3f8c9fce7492dd4727a5a917`.
The complete arithmetic source tree, original manifest, README and license match
the released checkout. Arithmetic is unchanged from 0.6.0.

The release delivers [Shared Tooling 0.3.12 adoption](adoption-061.md); the actual
private graph remains Host 0.13.0. Earlier local qualification keeps its original
0.6.0 package metadata and is separate from released-source hosted acceptance.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38124526984)
passes Linux and the job checking both Rust floors. Downloaded Linux artifact
`11696508986` verifies ZIP SHA-256
`cf4e97264a257cc3093b367dc5820937455355ccbe669a1f22e0f4883a0629bb`
and inner archive SHA-256
`d03ca6b0839a60b2a4f6ba024aa7f247f74871c674a1e10afe7eb0db8c6f8901`.
All 72 source hashes and the exact released workflow catalog, all 14 payload
hashes, source/run/attempt/host/IC pins and seven successful outcomes verify.
Actual aggregate/collector, release metadata/admission, failure retention,
formatting and inspector CLI checks execute. Two nonempty formatting diagnostics
are retained; no jobserver warning appears. Fixture effects remain substitutes.

Both macOS jobs are queued at this observation.
[#58](https://github.com/dragginzgame/ic-metrics/issues/58) retains complete native
acceptance. 0.6.0's older run was cancelled on unfinished macOS lanes when this
release arrived; its Linux results remain historical and do not establish full
native acceptance. [#57](https://github.com/dragginzgame/ic-metrics/issues/57)
retains qualification of the current 0.6 arithmetic contract. No older cancelled
source is relabelled as qualified by this newer source.

Index/archive inputs, raw artifacts, CI observations, recovered top-level receipts
and independent verification results remain under `target/evidence/review-062/`.
The prior ignored evidence directory was absent; new hosted downloads do not
restore deleted local preparation/performance evidence. This review performs no
build, dependency resolution, installation, workflow dispatch, release or sibling
mutation. No new behavior requires a pending changelog entry.
