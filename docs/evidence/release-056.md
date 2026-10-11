# Published 0.5.6 verification

Annotated tag `v0.5.6`, public main, package/workspace versions and embedded
registry Git identity agree on `392d1e2cbffb434dea591df8cb3165e8c625ab01`.
The official non-yanked row declares Rust 1.85.0 with no dependencies or features.
Downloaded archive SHA-256 verifies as
`13cb67fc18e59e30f328cf86d6d5c579742bc8d37e0f62a7d62160349212e7b3`.
All seven Rust files, the application guide, original manifest, root README and
license match released source. The packaged lock contains only Metrics 0.5.6;
arithmetic remains unchanged from 0.5.5.

The release delivers [incomplete metadata cleanup refusal](release-preparation-056.md),
Shared Tooling 0.3.8 and the separately reviewed private
[Host 0.12.8 graph](host-dependencies-0128.md). Earlier preparation evidence keeps
its original package version, graph and commands.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38072716144)
passes both package-floor checks; Linux is running and both macOS jobs are queued
at the initial observation. [#56](https://github.com/dragginzgame/ic-metrics/issues/56)
retains full released-source native acceptance. Release 0.5.5's
[complete native acceptance](release-055.md#complete-native-acceptance) is separate.

Official index/archive verification, CI observations and independent results are
retained under `target/evidence/review-057/`. This review performs no release,
publication, workflow dispatch or sibling mutation. Later private graph preparation
is collected under compatible pending 0.5.7, leaving this release's ledger intact.

## Linux acceptance

The same exact-source run subsequently passes Linux and both package floors;
both macOS jobs remain queued at this observation. Downloaded Linux artifact
`11677277048` verifies GitHub ZIP SHA-256
`9e9e1462af5d2c84f4b40c657f2f7a31a8d66cfbb31fac44146a0e34c0856021`
and inner archive SHA-256
`053d84456429faa64962885c5fdee3676af1fc2ad102591e4902db926cc7b854`.
All 70 released-source and 14 payload hashes, the exact workflow catalog,
source/run/attempt/host/pins and seven successful outcomes verify. Logs establish
actual aggregate/collector, release/admission, formatting and inspector CLI
execution with two nonempty formatting diagnostics. Fixture effects remain
substitutes; #56 retains complete native acceptance. Observations, raw download,
extracted receipts and independent results remain under the review directory.
