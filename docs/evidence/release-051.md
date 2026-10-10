# Published 0.5.1 verification

Annotated tag `v0.5.1`, package/workspace versions and embedded registry Git
identity match `a2f8e6e5e3d57f2d9eaff61791230ac1efbbafb8`. The official non-yanked
registry row has no dependencies or features and declares Rust 1.85.0. Downloaded
package SHA-256 verifies as
`ee345849bf612a87c362fd1d666d6211b2954f62694e02f6af903d047348326e`.
Seven Rust files, the application guide, original manifest, root README and
license match released source. The packaged lock contains only Metrics 0.5.1.
Arithmetic source is unchanged from 0.5.0.

The release delivers the [Metrics-owned Cargo jobserver repair](adoption-051-make.md)
and separately [qualified private Host 0.12.1 selection](host-dependencies-0121.md).
Its [exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38051255689)
passes Linux and both package floors; both macOS hosts are queued at
this inspection. Downloaded Linux receipt `11669805607` verifies ZIP SHA-256
`4b22924fad52de639901c4fd72125d61b07cedff7b64ca1e08a47310d5703d84`
and inner archive SHA-256
`28b674e4c1ec1a4dae6cfb01b9dcbce60473e9adde7b93e40fe5cae72449bd7e`.
All 14 payload and 70 released-source hashes, exact workflow catalog,
run/attempt/host/pins and seven successful outcomes verify. Logs prove the actual
aggregate, collector, release/admission, formatting and inspector CLI checks ran;
two nonempty formatting diagnostics are retained. Fixture effects remain
substitutes, without a live release or IC measurement claim.
[#48](https://github.com/dragginzgame/ic-metrics/issues/48)
retains changed-source native acceptance. Release 0.5.0's remaining Intel
acceptance stays separate in [#47](https://github.com/dragginzgame/ic-metrics/issues/47).

Official index/archive verification and current CI/issue observations are retained
under `target/evidence/review-051/`. This read-only review performs no release,
publication, workflow dispatch or sibling mutation. Subsequent compatible
changes are collected under pending 0.5.2, leaving the finalized ledger intact.

## Complete native acceptance

A subsequent review finds the same exact-source
[CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/38051255689)
complete: Linux, Intel macOS, Apple Silicon and both package-floor checks pass.
All three downloaded artifacts independently verify GitHub's ZIP digest, the
inner archive receipt, all 14 payload hashes and all 70 released-source hashes.
The source catalog exactly matches the selection in this release's workflow;
source, run 38051255689, attempt 1, host and released IC pins agree. All seven
recorded outcomes are successful.

| Host | Artifact | ZIP SHA-256 |
| --- | --- | --- |
| Linux | `11669805607` | `4b22924fad52de639901c4fd72125d61b07cedff7b64ca1e08a47310d5703d84` |
| Intel macOS | `11671725380` | `bc53ace9a65ab0d621219732a0b333a687e360f566d9f49897b730b4d6d21e91` |
| Apple Silicon | `11671912024` | `2dd8238ba75ca554e6061dc7fb2eaa11593b14b8b1cf34721d7a4e4f40ae8b4c` |

Retained logs prove actual aggregate/collector, release/admission, formatting and
inspector CLI checks execute on each host; no jobserver descriptor warning is
observed. Each artifact retains two nonempty formatting diagnostics. Fixture
Cargo, metadata and publication effects remain substitutes. This completes
[#48](https://github.com/dragginzgame/ic-metrics/issues/48) at released 0.5.1,
without qualifying another source or changing 0.5.0's cancelled Intel result.
Raw downloads, extracted receipts/logs and independent verification results
remain under `target/evidence/issues-055/`. No CI dispatch, source change, graph
update, release or publication is performed by this supplemental review.
