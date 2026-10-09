# Published 0.3.3 verification

Released source `b3ddfdf0406b54ef9a98ce48cbf5a9afe5fe406b` matches public main,
annotated tag `v0.3.3` (object `5a9e97ba110d5a7dcf3ff7595d5b40d3fd25db19`)
and workspace/package versions. The official registry reports a non-yanked
package with no dependencies/features and Rust 1.85.0. The archive verifies
SHA-256 `a5e14c6174e3baf461085f8ef1b7213d703691464b9443ca98d960aedd2c9c69`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match the release. The packaged lock contains only
Metrics 0.3.3; arithmetic source is unchanged from 0.3.2. The private workspace
graph selects independently reviewed Host 0.9.4.

[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37951810531)
passes Linux native and both package floors. Both macOS jobs remain queued at
observation. Authenticated GitHub REST downloads exact artifact `11626765793`;
its ZIP verifies the API digest
`d513480ad08dcde11ed0d3876ae38b3bd32590f8dd6863a513fa46925ed0ae99`.
The inner archive verifies
`246b05fc778bc496c44587e2daaf7b846b2f957fdeb91b7aed8df8d95168ec86`.
All 14 payload and 68 selected-source hashes match, with exact release source,
run/attempt 1/push/Linux/x86_64 identity, nine successful outcomes and released
IC pins. The native log confirms actual inspector CLI admission/publication,
consumer formatting hooks and release/admission fixtures with their declared
effect substitutions. Both new shared Make includes are covered by source hashes.

Inputs, archive and verified receipts remain under `target/evidence/release-033/`.
Initial attempts with an unsupported `gh run view` JSON field and an incorrectly
capitalized IC host receipt expectation are retained separately; corrected reads
and owner-format verification pass. These were inspection failures, not CI failures.
This records publication and Linux acceptance, not complete native macOS
qualification or IC cost measurements. No release rerun or publication occurs
during verification.
