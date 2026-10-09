# IC Host 0.8.5 dependency review

The 2026-10-09 review starts from released Metrics 0.2.16
`d8276daa3ae8603a5b4e196d0bb5369de54c1216` with the maintainer's existing dirty
lock selecting `ic-host-artifacts` and `ic-host-fs` 0.8.5. Only those two registry
rows differ from the released lock. Root requirements remain compatible 0.8.1;
workspace and package versions remain 0.2.16. Other dirty documentation is preserved.

Host release `1cad3253096b6eb67be5187209e7fb606593c501` matches public main and
the cached package archives' embedded Git identity. Archive SHA-256 values match
the selected lock:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `6bae9bbf01e0666e67e983d051f0485b2eb554cb9e33b5805fa9dc9e6bd42322` |
| ic-host-fs | `dcba13af085a73c04d4e8ea2d01d947c80f3c20517370ae8ec986bd342efbd7b` |

All packaged Rust files match the committed source byte-for-byte. Both crate
trees are unchanged from Host 0.8.4. The new release adopts Shared Tooling's
equivalent-pin installer reuse fix; it adds no library capability or inspector
performance benefit. No dependency-selection command runs during this review.

Locked offline Linux validation with prepared caches passes:

- `make wasm-inspect-check`: all-target compilation, warning-denied Clippy and
  named argument/report tests.
- `make wasm-inspect-msrv`: actual Rust/Cargo 1.88.0 host checks.
- `make msrv`: actual Rust/Cargo 1.85.0 arithmetic host and Wasm checks.
- An actual private binary build and inspection of all three checksum-verified
  frozen replay Wasms. Complete reports match the original committed TSVs.
- The core Cargo tree contains only `ic-metrics`, and the lock hash is unchanged.

Local command logs, package-source comparisons and new reports remain under
`target/evidence/host-085-review/`. The frozen bundle and its instruction/cycle
evidence are neither rebuilt nor relabelled. No function, method or type is removed.

[Exact upstream Host CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37893479726)
passes Linux, both native macOS architectures and Rust 1.88. Metrics' completed
[0.2.16 release matrix](release-0216.md) still qualifies Host 0.8.4; these focused
Linux checks do not replace configured native qualification of this dirty 0.8.5
selection. No full local CI, sibling mutation, package version change, commit,
push, tag, publication or release command runs.
