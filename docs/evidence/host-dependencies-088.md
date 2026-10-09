# IC Host 0.8.8 dependency review

Released Metrics 0.2.18 `3b1f461ed9aacce6c3d04d391178fecb9ce283dd` already
selects registry `ic-host-artifacts` and `ic-host-fs` 0.8.8. This review qualifies
that existing selection without updating dependencies or the lock. Root
requirements remain compatible 0.8.1 and the arithmetic graph remains empty.

The cached archives match the selected checksums and embedded upstream release
`ccfd7724dd31c14cfbb8ae434f683babfeabf906`. All packaged Rust source files match
that committed source byte-for-byte.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `606926664bacc3d1da87749ded9f96643ab585ea02f97e503be3453a22ca55f3` |
| ic-host-fs | `8113bd0abe5a81e0770c5fe7b4cc0e21d31b710d36bbc006181555d626359cc0` |

Compared with the previously reviewed Host 0.8.5, the artifact crate is unchanged.
The filesystem crate adds Unix `hash_file_no_follow` and focused read/durable
tests; the inspector's bounded `read_file` path is unchanged. The new hash helper
does not replace the inspector's buffer: Wasm inspection needs the bytes, and the
existing report hashes that same buffer. A separate streaming hash would add a
second read and would not bind inspection to the same bytes under concurrent
modification. Symlink/path custody remains the explicit caller-owned contract.
No additional Host API adoption or process dependency is justified here.

Locked offline Linux checks with prepared caches pass:

- `make wasm-inspect-check`: all-target compilation, warning-denied Clippy,
  two named argument tests and three named report tests.
- `make wasm-inspect-msrv`: actual Rust/Cargo 1.88.0 all-target compilation.
- Actual private binary build and inspection of all three checksum-verified
  frozen replay Wasms. Complete reports match the committed original TSVs
  byte-for-byte; the original archive and measurements are unchanged.
- The core Cargo tree contains only `ic-metrics` 0.2.18; the lock hash is unchanged.

[Exact upstream Host CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37901415314)
passes Linux, Intel, Apple Silicon and MSRV. This does not replace the consumer's
[0.2.18 native qualification](release-0218.md). Source/binary identities, command
logs, archive comparisons and fresh structural reports remain under
`target/evidence/host-088-review/`. No Rust code or symbols change, no runtime
cost improvement is claimed, and no broad local gate or release runs.
