# IC Host 0.8.9 dependency review

The pending Metrics 0.2.19 batch preserves the existing working-tree selection of
registry `ic-host-artifacts` and `ic-host-fs` 0.8.9. Compared with committed Metrics
0.2.18, only these two lock versions/checksums differ; no other dependency is
updated by this review. Root requirements remain compatible 0.8.1, workspace
versions remain 0.2.18, and the arithmetic graph remains dependency-free.

The cached package archives match their lock checksums and embedded upstream
release `0464db5146be910a0f078447831fa2807072c75a`. All packaged Rust sources and
original member manifests match that committed source byte-for-byte.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `2fefad1ae4756603dc3c40ae959c636ffc3a6e2ea06a6787c814eae056042813` |
| ic-host-fs | `febd1654e330ba56b5abc6e1ee5044f65a36ca79aa1648ac1b9efacf8e3f2e5d` |

Host 0.8.9 changes its release-cache adapter and fixtures. Its library sources are
unchanged from [the reviewed 0.8.8 selection](host-dependencies-088.md); no new Host
API or process dependency is needed. The inspector continues to read one bounded
buffer and hash the bytes it inspects, preserving caller-owned path custody.

Locked offline Linux checks with prepared caches pass:

- `make wasm-inspect-check`: all-target compilation, warning-denied Clippy,
  two named argument tests and three named report tests.
- `make wasm-inspect-msrv`: actual Rust/Cargo 1.88.0 all-target compilation.
- Actual private binary build and fresh inspection of the three frozen replay
  Wasms from checksum-verified `histogram-replay-029.tar.gz`. All complete reports
  match the original `wasm-inspection-0215` TSVs byte-for-byte.
- The core Cargo tree contains only Metrics 0.2.18; the initial lock hash is
  unchanged throughout qualification.

Logs, archive/source comparison inputs, source/binary hashes and new reports
remain under `target/evidence/host-089-review/`.
[Exact upstream CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37905479815)
passes Linux and Rust 1.88 MSRV; both macOS native jobs are queued at inspection.
This is local Linux and partial upstream qualification, not exact committed
Metrics native acceptance. The original Wasm bytes, replay measurements and
historical reports retain their identities. No runtime cost improvement, IC
execution, symbol removal, broad local gate or release is claimed.
