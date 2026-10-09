# IC Host 0.9.4 review

The pending Metrics 0.3.3 batch preserves an incoming lock edit selecting
`ic-host-artifacts` and `ic-host-fs` 0.9.4. Only their versions/checksums differ
from released Metrics 0.3.2. Compatible 0.9 requirements and package/workspace
versions remain unchanged. No dependency resolution or upgrade runs in this work.

Both cached registry archives match their locked checksums, declare Rust 1.88
and embed upstream source `4e3daebd5df07c6449279535668436024a45c02b`.
Every packaged Rust source and original member manifest matches that commit.
The upstream library source is unchanged from Host 0.9.2
`c5decaefd17809829bfa969966729d672f609c49`.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `2daf8afa9ef450450e8eb051bd1e47601e99063bf04893a5c0cd2967e104ca3c` |
| ic-host-fs | `0d51d7dc5c12d1f87ee11268000c4ffa1617bd13853d63baffd08e88c53f5f13` |

Focused locked offline Linux validation passes: warning-denied all-target
inspector Clippy, named argument/report tests, actual CLI admission/publication
and Rust 1.88 all-target compilation. Checksums bind the selected manifest/lock
before and after final Clippy. The arithmetic dependency graph remains separate.
No production Rust changes or claim of native macOS/IC runtime qualification is made.

The lock changed concurrently from 0.9.3 to 0.9.4 during these checks. The first
Clippy log used 0.9.3; subsequent test and MSRV logs explicitly compiled 0.9.4.
Final Clippy was rerun for 0.9.4. Raw logs retain their original `host093-*`
filenames and observed package versions; they are not relabeled as one unchanged
graph. Final hashes, package verification and Clippy are recorded separately
under `target/evidence/adoption-033/make-includes/host094-*`.
