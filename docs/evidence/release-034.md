# Published 0.3.4 verification

Released source `5a5f1dab1f7ee3e1e5624c9d889148c39abf45f2` matches public main,
annotated tag `v0.3.4` (object `00061941f86712364f569071975f031a8d4b64a3`)
and package/workspace versions. The official registry reports a non-yanked,
dependency-free package without features, declaring Rust 1.85.0. Its archive
verifies SHA-256
`e34003e0092eae233d9bb1bb47f7c22e8966eaeee6d2ebe57efe7012eb627351`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match the release. Its packaged lock contains only
Metrics 0.3.4. Arithmetic source is unchanged from 0.3.3. The private workspace
graph selects [separately qualified Host 0.9.5](host-dependencies-095.md).

[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37955395588)
passes Linux native and both package floors; both macOS jobs remain queued at
observation. Downloaded Linux artifact `11627658017` verifies its API ZIP digest
`df3b7a654f736bedae3d145511c2b7d889807d67849e4f6bb52aeb9659dfda4e`
and inner archive digest
`a4d09958b05351ce6d07918a93b8d47caa4f02a1a4651e3ddaf0c8aaacee6987`.
All 14 payload hashes and 69 selected-source hashes verify against the release,
including the Make execution include and probe. Inputs bind exact source,
run/attempt 1/push/Linux/x86_64 identity, nine successful outcomes and released
IC pins. The native log confirms actual inspector CLI admission/publication,
formatting hooks and the substituted release/admission cases.

Inputs and verified receipts are retained under `target/evidence/release-034/`.
This records publication and Linux acceptance, not complete native macOS or IC
cost qualification. No release rerun or publication runs during this verification.
