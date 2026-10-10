# IC Host 0.10.1 selection review

The pending compatible Metrics 0.3.6 batch preserves an independently incoming
lock edit selecting `ic-host-artifacts` and `ic-host-fs` 0.10.1. Only their package
versions/checksums differ from released Metrics 0.3.5. No resolver or upgrade runs;
the compatible 0.10 requirements and Metrics package/workspace versions remain
unchanged.

Both cached archives match the selected lock and official non-yanked registry
rows, declare Rust 1.88.0 and embed released Host source
`c7bdc3d4e1c658957202eebd76bff2c51e22f645`. All packaged sources and original
member manifests match that source: 20 files for artifacts and 19 for fs.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts 0.10.1 | `a99e46f828ed6944bc398069ab557d1ccedf260a1974f4028418b4f4c9b66c04` |
| ic-host-fs 0.10.1 | `a8ad852553cd23ca1a509be2af9bc4d38a39663fe6af0aa6365250046f6f0b76` |

The patch completes synchronization when a competing writer creates a formerly
missing parent directory ([Host #43](https://github.com/dragginzgame/ic-host-tooling/issues/43)).
Metrics has no durable publication caller. Artifact source and fs read modules
are unchanged from Host 0.10.0; no inspector caller or output contract changes.

Focused locked offline Linux qualification passes: warning-denied all-target
inspector Clippy, two argument tests, three report tests, expanded actual CLI
admission/budget/output-failure coverage and Rust 1.88 all-target compilation.
Manifest/lock and tool-pin hashes remain unchanged throughout. Package/source,
registry inputs and check logs are under `target/evidence/host-0101/`;
preservation inputs are under `target/evidence/adoption-036/`.

The arithmetic library remains unchanged and dependency-free. These results
do not establish native macOS acceptance or IC cost improvement. No production
Rust edit, full local CI/product suite, commit, push, version bump or release runs.
