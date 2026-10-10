# Published 0.5.2 verification

Public main, local release tag `v0.5.2`, package/workspace versions and embedded
registry Git identity match `2400e918e5a1c89a769768621c0cfe1006067f35`.
The official non-yanked registry row has no dependencies or features and declares
Rust 1.85.0. Downloaded package SHA-256 verifies as
`54bb0abd64335436e59ebc4895a01e3553a5d5cfbf8f82228e180a58dbc658c6`.
Seven Rust files, the application guide, original manifest, root README and
license match released source. The packaged lock contains only Metrics 0.5.2.
Arithmetic source is unchanged from 0.5.0.

The release delivers the [Shared 0.3.2 and owned fixture repairs](adoption-052.md)
and separately [qualified private Host 0.12.2 selection](host-dependencies-0122.md).
Its [exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38052541381)
passes Linux and both package floors; both macOS jobs remain queued. Downloaded
Linux receipt `11670081928` verifies ZIP SHA-256
`c9bfbccc7b5734d13ec082ce79e205067b3ed3b16ed8af26cdc6fde892e30699`
and inner archive SHA-256
`44324fd01c108908bdc32166c30e4557241d8ad54d4724ddd437c5dc016c99a8`.
All 14 payload and 70 released-source hashes, exact workflow catalog,
run/attempt/host/pins and seven successful outcomes verify. Logs prove actual
aggregate, collector, release/admission, formatting and inspector CLI execution;
two nonempty formatting diagnostics are retained. Fixture effects remain
substitutes, with no IC measurement or live release claim.
Native acceptance remains incomplete. [#49](https://github.com/dragginzgame/ic-metrics/issues/49) and
[#50](https://github.com/dragginzgame/ic-metrics/issues/50) retain those obligations.
Earlier source qualification is not reused for the changed runner/fixtures.

Official registry/archive/source verification and CI/issue observations are
retained under `target/evidence/review-053/`. No release, publication or workflow
dispatch is performed. Subsequent compatible runner adoption is collected under
pending 0.5.3, leaving the finalized ledger unchanged.
