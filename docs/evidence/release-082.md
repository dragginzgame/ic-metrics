# Published 0.8.2 verification

Local released HEAD, public main and peeled v0.8.2 agree on
`65d824d501d9f3d21bb9b01c298488dcdf3f7d23`. Both official non-yanked package
archives match their sparse-index checksums, embedded Git source and every
packaged Rust file:

| Package | SHA-256 | Packaged Rust sources |
| --- | --- | --- |
| ic-metrics 0.8.2 | `b61bee701f158d171b6347339d4ef40df7cff882e2e85ddeb7eee5ec79c3d5ba` | 13 |
| ic-metrics-stable 0.8.2 | `fb5fa9ab68e7040b31ce5c10efceee962f38a763a7d1d0f19e2a78bd1cbba9dd` | 4 |

The crates.io API returned HTTP 403 for the version reads; the official sparse
index and static archive route supplies independent publication verification.
Core remains dependency-free on Rust 1.85, with stable separately opted in on
Rust 1.88. Scalar counters are now released but have no durable encoding.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38365868955)
is queued at the first observation. This is publication verification, not a
completed native matrix. The final job-detail read records successful Linux and
Rust-floor jobs, with both macOS jobs queued. No native artifact is downloaded
in this review. [Released 0.8.1 receipts](release-081.md) retain their
original complete acceptance and do not qualify newer source/graphs.
Consumer qualification remains with its owning issues, including
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10).

Official archives/index rows and CI/source observations are retained with
[the subsequent decoder receipt](decoder-083.md). The counter, tooling and
[cleanup evidence](cleanup-082.md) preserve their earlier preparation scope;
published metadata does not relabel those receipts as released-source CI.
