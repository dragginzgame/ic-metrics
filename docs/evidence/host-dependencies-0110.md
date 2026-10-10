# IC Host 0.11.0 selection review

The initially compatible Metrics 0.3.8 candidate preserved the incoming manifest/lock selection
of `ic-host-artifacts` and `ic-host-fs` 0.11.0. The private inspector inherits the
0.11 requirements; Metrics package/workspace versions remain 0.3.7. No resolver,
dependency upgrade or product source edit was performed by this review.
The maintainer subsequently selected complete Shared Tooling adoption for 0.4.0;
this private dependency update is carried into that draft. Its focused evidence
below retains its own original inputs and scope.

Both cached archives match their lock checksums and freshly observed official
sparse-index 0.11.0 rows, which are non-yanked and declare Rust 1.88.0:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `a455545c5f621655009e3cbdfc51b7df8980e1dc71b2b3b1e5810d54cf79150d` |
| ic-host-fs | `643fc14fef29e16027811415869b0bdb1d128c495fa4d74f0a6e74b5d86e1bf4` |

Embedded source identity is released Host
`1d768c80a5bb87e3330a6b7bacfdfc543063968f`, matching public main at inspection.
All packaged Rust sources and original member manifests match that source:
20 files for artifacts and 19 for fs. Initial crates.io metadata API requests
returned HTTP 403; the separate successful sparse-index observations provide
registry facts. The failed requests are not treated as registry success.

Relative to Host 0.10.1, artifact source and fs bounded-read modules are unchanged.
The 0.11 process limit/cleanup hard cut has no Metrics caller: this inspector does
not depend on `ic-host-process`. The fs development-only artifact feature selection
does not change Metrics' dependency graph. The 0.10.2 durable target-path repair
also has no inspector caller. No wrapper or process API migration is needed.

Focused locked Linux qualification passes: all-target inspector check and
warning-denied Clippy; both named argument tests; all three named report tests;
the actual CLI admission, structural-budget and failed-output case; and Rust 1.88
all-target compilation. The arithmetic crate remains dependency-free and unchanged.
No IC instruction, cycle or Wasm-size improvement is inferred.

Package/source, official index and check records are under
`target/evidence/host-0110/`. Incoming Cargo and tool-pin preservation hashes pass.
Local focused results do not establish native macOS or a complete release gate.
No full local suite, commit, push, version bump, release or publication occurred.
