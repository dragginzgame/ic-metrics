# Pending IC Host 0.12.9 selection review

Explicit precise updates select published `ic-host-artifacts` and `ic-host-fs`
0.12.9 for the private inspector; `cargo fetch --locked` prepares that graph.
Only their versions/checksums differ from released Metrics 0.5.6. Names, sources,
dependency lists and every other selected row are unchanged. Package/workspace
versions remain 0.5.6; the compatible next changelog candidate is 0.5.7.

Official non-yanked index rows declare Rust 1.88.0 and match the selected lock and
cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `a2ef59a520243a3b377e1d8cd53d0164cab3f6cb4e582be1e190c9c8d986fff6` |
| ic-host-fs | `f8b9cfa175f6261d50ce9cdd0d72fc154fb8acd2cafe5df80e21e6006e6f46d6` |

Embedded Git identities, every packaged Rust file and original manifests match
public Host `8cc85c53cdd59701a7352f566425b3faf195a37b`. Both consumed source
trees are unchanged from 0.12.8. Upstream changes concern macOS fixture path/count
assumptions, failed-fixture uploads, Shared Tooling adoption and release metadata.
Metrics already archives native fixture scratch, including failed Git state;
no duplicate upload mechanism or upstream fixture suite is added here.
Dirty sibling work is excluded.

The existing focused inspector check, warnings-as-errors Clippy, argument/report
tests and actual CLI admission/publication test pass with the selected graph.
The inspector retains bounded reads, structural reports and Rust 1.88; arithmetic
remains dependency-free with Rust 1.85. No new Host crate, feature, writer or
platform reader is activated. Official responses, source/archive/graph verification
and focused logs remain under `target/evidence/review-057/`. No IC performance
claim is made.

## Complete delivery qualification

The selected graph passes complete `ci` (181 seconds), arithmetic `msrv`
(Rust 1.85, including Wasm) and private `wasm-inspect-msrv` (Rust 1.88).
All 99 frozen code/graph/pin/workflow inputs remain unchanged after the gates.
`delivery.log`, `delivery-inputs.json` and `delivery-preservation.txt` retain
this local qualification under `target/evidence/review-057/`; it does not
replace released-source native receipts.
