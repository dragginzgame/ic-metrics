# Published 0.3.1 verification

Released source `2383dc0d684800b1610e3eb727449b0a87d562bb` matches public main,
annotated tag `v0.3.1` (object `c6b24782e5d7441ba4beadd12bd7c2807553e148`) and
workspace/package versions. The official registry reports a non-yanked package
with no dependencies/features and Rust 1.85.0. Its archive verifies SHA-256
`acce3009a305edc4db9244828e268db7cb89bba21daa28d1ffee4dbba087ed4a`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match the release commit. The packaged lock contains
only Metrics 0.3.1; arithmetic source is unchanged from published 0.3.0.

[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37922233973)
passes Linux native and both package floors. Intel and Apple Silicon remain
queued. This review checks job outcomes; it does not download this release's
native artifacts or complete
[#42](https://github.com/dragginzgame/ic-metrics/issues/42)'s source-bound native
acceptance. Prior releases' receipts retain their original identities.

Publication inputs, archive comparisons and CI observations remain under
`target/evidence/release-031/`. The new pending 0.3.2 Host lock selection and
Shared Tooling snapshot remain separate from this released source. No release
rerun or publication occurs during verification.

## Linux native receipt supplement

The later receipt review downloads artifact `11612642334` from the same run,
attempt 1. GitHub's ZIP digest verifies as
`d2d4b094e8ea8ee0a961c25f01666ceb4239208630aff7de7ea892b24384930c`;
the inner archive verifies as
`c5cfb7f72077b03bc6e4a11d4defcc088b86fc9a046b1ed94dfa933c657eeb06`.
All 14 top-level payload hashes and 65 selected-source hashes match, with exact
release commit/run/attempt/push/Linux/x86_64 identity, nine successful setup/native
outcomes and the release's IC pin catalog. Every completed job step succeeds.
The native log confirms IC installer fixtures and release admission/cache,
restoration/recovery and failure-retention fixtures pass. Declared Git/Cargo/Make
substitutions retain their scope; these are not live interrupted release effects.
The inspector uses released Host 0.9.1, separately from pending 0.3.2's 0.9.2.

Verified payloads, API inputs and comparison results remain under
`target/evidence/release-031/linux-download/`. Both macOS jobs are still queued
at this review, so #42 remains open. No local full gate or workflow rerun is used
to replace the missing native receipts.
