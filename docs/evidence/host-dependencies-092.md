# IC Host 0.9.2 review

The pending Metrics 0.3.2 batch includes the pre-existing working lock selection
of `ic-host-artifacts` and `ic-host-fs` 0.9.2. Only these two versions/checksums
differ from released Metrics 0.3.1 `2383dc0d684800b1610e3eb727449b0a87d562bb`;
requirements remain compatible 0.9 and workspace/package versions remain 0.3.1.
This review preserves the selected lock rather than resolving another update.

Both registry archives are non-yanked, declare Rust 1.88 and match their lock
checksums and embedded upstream release
`c5decaefd17809829bfa969966729d672f609c49`. All packaged Rust sources and original
member manifests match that commit. Library source is unchanged from Host 0.9.1;
0.9.2 changes CI concurrency and adopts the Shared Tooling installer fixes.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `bc4f8956657ca3c95d11828bd340eb568bb06f93f964247333124598168eb469` |
| ic-host-fs | `793e8e2a20ab2765f048c6197304faa799ac8ee69795552549da174c4d368d77` |

Locked offline Linux checks pass: warning-denied inspector Clippy, two named
argument tests, three named report tests, actual Rust 1.88 all-target compilation
and an actual binary build. Fresh reports for all three checksum-verified frozen
histogram replay Wasms match the original TSVs byte-for-byte. The core Cargo tree
contains only Metrics 0.3.1. The lock, requirements and frozen archive remain
unchanged throughout checking; source/binary hashes still match during 0.3.2
preparation. Evidence remains under `target/evidence/host-092-review/`.

[Exact upstream CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37924013633)
passes Linux and Rust 1.88 at inspection; both macOS native lanes remain queued.
Local Linux compatibility and unchanged reports do not establish exact released
Metrics native acceptance or an IC runtime-cost improvement. No inspector API,
source or attribution changes are required.
