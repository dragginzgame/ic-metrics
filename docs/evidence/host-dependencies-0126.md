# IC Host 0.12.6 selection review

Incoming private `ic-host-artifacts` and `ic-host-fs` lock selections are preserved.
Explicit requested precise updates and `cargo fetch --locked` leave the already
selected graph unchanged. Only their versions/checksums differ from finalized
0.5.4's 0.12.4 graph; dependency lists and every other row are identical. The
[earlier 0.12.5 review](host-dependencies-0125.md) retains its original identity.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the lock and
cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `e959dc0497e6f86c1619f955b93bd04c4a081d4646c2ae649ae945ef960dd353` |
| ic-host-fs | `cda95ec3cfb45722c4d7e490b62c1f1f52984c3962d34d317e98ca3feac481e6` |

Embedded Git identities, all packaged Rust and original manifests match released
Host `5f356effea97fbc31dfcca5b9f1b2834f35325a9`. Both crate source trees are
unchanged from 0.12.5; this upstream release changes CI concurrency and metadata.
The inspector keeps its bounded read/structural-inspection APIs and Rust 1.88
floor. Arithmetic remains dependency-free with its separate Rust 1.85 floor.
No new Host crate, feature, writer or downstream platform reader is activated.

Official index responses and independent source/archive/lock comparisons remain
under `target/evidence/adoption-055-current/`; current complete graph qualification
passes `ci` (180 seconds), `msrv` and `wasm-inspect-msrv` with all 81 frozen inputs
unchanged, as recorded in [the handoff](../status/current.md). Hosted acceptance remains
separate. No IC instruction, cycle or Wasm-size improvement is claimed, and no
package version, sibling source, commit, release or publication is changed.
