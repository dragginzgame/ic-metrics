# IC Host 0.8.4 dependency review

The pending compatible 0.2.16 batch is based on released Metrics
`287251eb51412852a58cabd9de5b3c28e207e705`. Before this review, the maintainer's dirty
lock already advanced `ic-host-artifacts` and `ic-host-fs` from 0.8.2 to 0.8.4,
without changing other registry selections. The review preserves that input;
workspace/package versions remain 0.2.15 and compatible root requirements remain
0.8.1. All private inspector Rust sources match the released Metrics commit.

Published Host `v0.8.4` resolves to
`97187b2a46d6f8a6964224a36a133d858ef0d223`, matching public main and both crate
archives' embedded Git identities. Cached registry archives verify the selected
lock checksums:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `26e471bd1214f30f1bdaa75bd0de152c863c16548f8682bba08ced37e9ddad02` |
| ic-host-fs | `e26d9a9c7741af21823ba5e46d19c10e15d2a511cc294eaed1e37f66f85bc02c` |

Every packaged Rust source compares byte-for-byte with the selected Host commit.
The Host 0.8.2-to-0.8.4 source diff leaves the inspector's hashing, Wasm inspection
and bounded-read implementation unchanged. New unlocked-file admission and live
child-output observation belong to consumers using lock/process policy; this
inspector needs neither. Existing-lock admission in 0.8.4 avoids staging/sync work,
but this consumer performs no such lock opening, so no cost benefit is claimed.
The public arithmetic package still has no dependency on these host crates.

The first offline focused check fails because Cargo cannot find the new selected
packages in its effective registry cache. An explicit `cargo fetch --locked
--target x86_64-unknown-linux-gnu` prepares the graph, with before/after lock
SHA-256 `b612339cbe85fb0e10a2371f36b5be50321350d7e68c078906d6ec9a537221ec`
unchanged. Then locked offline Linux validation passes:

- `make wasm-inspect-check`: all-target compilation, warning-denied Clippy and
  named argument/report tests.
- `make wasm-inspect-msrv`: actual Rust/Cargo 1.88.0 all-target host check.
- `make msrv`: actual Rust/Cargo 1.85.0 arithmetic host and Wasm checks.
- Actual private binary build and inspection of all three frozen replay Wasms;
  the complete new TSVs match their original committed reports byte-for-byte.
- Actual malformed input, byte-budget, directory and missing-argument requests
  each refuse with status 1 and empty stdout.
- Core Cargo tree contains only `ic-metrics`; metadata/admission fixtures,
  formatting, declaration pins and the 91-file snapshot check pass.

The frozen bundle verifies its original checksum and is not modified or rebuilt.
These are structural facts, not new IC instruction/cycle measurements. Evidence,
the initial failed attempt and exact selected lock hash remain under
`target/evidence/host-084-review/`. No function, method or type is removed.

[Exact upstream Host CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37818647474)
passes Linux native and Rust 1.88 at review; Intel and Apple Silicon are queued.
The preceding 0.8.3 matrix passes completely, but is not relabelled as 0.8.4.
Released Metrics 0.2.15 has completed native/MSRV receipts with Host 0.8.2.
[#37](https://github.com/dragginzgame/ic-metrics/issues/37) retains the pending
batch's exact-source native/downloaded-receipt acceptance with Host 0.8.4.
Focused checks support pushing this coherent batch for configured CI; they do
not establish the future committed matrix. No full local CI, package version
change, sibling edit, commit, push, release or publication runs in this review.
