# Released IC Host 0.12.7 selection review

Metrics 0.5.5's actual committed lock selects private `ic-host-artifacts` and
`ic-host-fs` 0.12.7. This is an inspection of the released selection; no dependency
update or fetch changes it. The [0.12.6 preparation review](host-dependencies-0126.md)
keeps its original source and local validation scope.

Official non-yanked index rows declare Rust 1.88.0 and match both the released
lock and cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `dd31b52c6f4664f2e40b3fa7b2d0290c9a405511264a72e4733565016908651b` |
| ic-host-fs | `340fdb9877a3e32ca77e5964865e1aa696f9574077915a9034467024e8eb1ab2` |

Embedded Git identities, every packaged Rust file and original manifests match
released Host `7c31035ccf9922f914ba6c63096f2437a30e1e03`. Both consumed source
trees are unchanged from released 0.12.6
`5f356effea97fbc31dfcca5b9f1b2834f35325a9`. Upstream changes Shared Tooling,
owned Bash assertions, CI and metadata rather than these library implementations.
Uncommitted sibling work is excluded.

The inspector retains bounded file reads, structural inspection and its separate
Rust 1.88 floor; arithmetic remains dependency-free with Rust 1.85. The
[released-source Linux receipt and package-floor checks](release-055.md) qualify
this actual graph, with native macOS acceptance separate. Registry/source/archive
verification is retained under `target/evidence/review-055/`. No new feature,
writer, platform reader or IC performance claim is introduced.
