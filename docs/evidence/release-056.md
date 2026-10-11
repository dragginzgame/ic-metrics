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

## Complete native acceptance

All required jobs now pass at this release's exact source: Linux, macOS 15
Intel, macOS 15 Apple Silicon and the job checking both package floors.
Fresh downloads independently verify all three ZIP and inner archive digests,
all 70 source hashes against the exact released workflow catalog, all 14 payload
hashes, source/run/attempt/host/IC pins and seven successful outcomes.

| Native receipt | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Intel | `11678715798` | `c238a8d9a0da6fa499221ad291f2285b3824cd8cc5904190d07ca7b1a6030505` | `26d257eaa1059bf697a640c43dde51db40625505099e85bb9aed36c7d0231652` |
| Apple Silicon | `11678309440` | `254893cf2a36bcbb3ee7385472a7962fca6a7c83872b5fbf659a568bac80cd3c` | `748eae2fc580f68042337224d28469294e09e58fd5ebadd3d4d99b98c8c8b6c9` |
| Linux | `11677277048` | `9e9e1462af5d2c84f4b40c657f2f7a31a8d66cfbb31fac44146a0e34c0856021` | `053d84456429faa64962885c5fdee3676af1fc2ad102591e4902db926cc7b854` |

Actual aggregate/collector, release metadata/admission, failure retention,
formatting and inspector CLI checks execute on each host. Each receipt contains
two nonempty formatting logs and no jobserver warning. This completes
[#56](https://github.com/dragginzgame/ic-metrics/issues/56) at published 0.5.6;
fixture effects remain substitutes and establish no live release execution or
IC instruction/cycle measurements.

The prior ignored evidence tree was absent at this inspection. Fresh GitHub
downloads, observations, recovered top-level receipts and independent results
are retained under `target/evidence/review-062/`; they recover this release's
hosted proof rather than reconstructing its deleted local preparation logs.
Cancelled 0.5.2, 0.5.3 and 0.6.0 runs retain their original qualification gaps;
these 0.5.6 receipts do not relabel those sources or qualify 0.6.1's new snapshot.
