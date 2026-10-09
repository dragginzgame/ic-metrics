# IC Host 0.9.6 selection and 0.9.7 review

The pending compatible Metrics 0.3.5 batch preserves an independently incoming
lock edit selecting `ic-host-artifacts` and `ic-host-fs` 0.9.6. Only those package
versions/checksums differ from released Metrics 0.3.4. No resolver or upgrade runs;
the compatible 0.9 requirements and Metrics package/workspace versions are unchanged.

Both cached archives match the selected lock and official non-yanked registry rows,
declare Rust 1.88.0 and embed released Host source
`6aaa4229913bafc68a443e7e855468efcca8ee7a`. All packaged sources and original
member manifests match that source: 20 files for artifacts and 19 for fs.

| Selected package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts 0.9.6 | `38f6956f7aa73ec640b1939f1942b072a72fccc3bc24f813f702c0f580c3e748` |
| ic-host-fs 0.9.6 | `3ffb49aef729c237467636eac6bfce9073eb78f27c8938858adc1f6c04734f36` |

Focused locked offline Linux qualification passes with the selected 0.9.6 graph:
warning-denied all-target inspector Clippy, two argument tests, three report tests,
actual CLI admission/publication and Rust 1.88 all-target compilation. Before/after
hashes preserve the manifest, incoming lock selection and tool pins. Logs and package
receipts remain under `target/evidence/host-096/`.

Latest public Host 0.9.7 is source
`ca62e661918db2f4320743b9042a4993a5fff2aa`. Its cached artifacts/fs archives also
match official registry checksums, Rust 1.88.0 and packaged source identities:

| Reviewed package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts 0.9.7 | `67370ad6694be28e687d9797d0505320c94f84fd488d92aa8fbcb5c836c979a8` |
| ic-host-fs 0.9.7 | `3ea403e45ff971df9c9b1ad2ef5a567055b3264b415ec0024d203336ad46f178` |

Neither library has source changes from Host 0.9.5 through 0.9.7. Host 0.9.6
simplifies response hex decoding in `ic-host-tools`, which Metrics does not use;
0.9.7 adopts Shared Make admission fixes already in the pending Metrics batch.
No new inspector API or arithmetic dependency is justified by these changes.
The 0.9.7 archive/source review is not execution qualification or a lock selection.
[Its exact CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37958032736)
passes Linux and MSRV; both macOS jobs remain queued at observation. Metadata,
registry inputs and exact CI reads remain under `target/evidence/host-097/`.

Production Rust and report schemas remain unchanged. No native macOS acceptance,
IC instruction/cycle improvement or raw Wasm reduction is claimed.
