# Pending IC Host 0.12.8 selection review

Explicit precise updates select published `ic-host-artifacts` and `ic-host-fs`
0.12.8 for the private inspector, then `cargo fetch --locked` prepares that graph.
Only these two versions/checksums differ from released Metrics 0.5.5; package
identities, dependency lists and all other selections are identical. The actual
released [Host 0.12.7 review](host-dependencies-0127.md) retains its own identity.

Official non-yanked index rows declare Rust 1.88.0 and match the current lock and
cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `613e1079912a047f9f036ed73a7d033ea12ff56c35e227a9541ad05fdfdac3cb` |
| ic-host-fs | `c1dcc02e397e1f5b1c18c0627867bd7d9b849a67e9205a60f6d6d155b5dbfc81` |

Embedded Git identities, every packaged Rust file and original manifests match
released Host `c810c299acd0c41001a046c8e8ad0ee6daceefc0`. Both consumed source
trees are unchanged from 0.12.7; this release adds upstream formatting/hook
qualification and metadata. Metrics activates no new Host crate, feature, writer
or platform reader. The inspector retains bounded reads, structural reports and
Rust 1.88; arithmetic remains dependency-free with Rust 1.85.

Registry responses, source/archive verification and locked-selection comparisons
are retained under `target/evidence/review-055/`. Current-source full qualification
belongs to [the completed batch](release-preparation-056.md); native hosted
acceptance remains separate. No arithmetic improvement, IC instruction/cycle
cost reduction or Wasm-size change is claimed.
