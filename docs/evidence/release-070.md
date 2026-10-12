# Published 0.7.0 verification

Local HEAD, public main and the peeled annotated `v0.7.0` tag agree on
`384046884365e3d73696e0813a43640d3b1f2cb4`. Both official registry rows are
non-yanked and their downloaded archives verify against the declared SHA-256:

| Package | Archive SHA-256 | Rust floor | Direct dependencies |
| --- | --- | --- | --- |
| ic-metrics 0.7.0 | `d526f945450ce67a517b36673d215809ce6e089e7809c4192db23600fe75d4ca` | 1.85.0 | None |
| ic-metrics-stable 0.7.0 | `ffc3ed0f5e26063867e4b0dd89f1d3732b600981c30d01a89f7e9dbb322a9c85` | 1.88.0 | ic-memory ^0.35.12, ic-metrics ^0.7 |

Each archive embeds that exact Git commit and the owning package directory.
Every packaged Rust source matches the released checkout. The arithmetic package
retains no dependencies; the stable adapter remains a separate opt-in package.
The wide-total arithmetic and restoration APIs are delivered, satisfying
[#63](https://github.com/dragginzgame/ic-metrics/issues/63)'s delivery/publication
condition. The frozen [arithmetic comparison](arithmetic-070.md) and
[native stable-store qualification](stable-070.md) retain their original sources
and evidence scopes rather than being relabelled as new release measurements.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38215901637)
initially passes the compiler-floor job with all three native jobs still running.
A later API observation confirms all four jobs and the complete run pass at the
same source. Native artifact receipts have not yet been independently downloaded
and verified in this record. Actual
IC upgrade/message execution and storage instruction/cycle/Wasm costs remain in
[#64](https://github.com/dragginzgame/ic-metrics/issues/64); package publication
and native storage tests do not satisfy them. Consumer-wide-total adoption stays
with the six issues linked from the arithmetic review.

Official sparse rows, archives, extracted sources and API observations are retained
under `target/evidence/release-070`. This review performs no release, publication,
dependency update, version change or sibling mutation.
