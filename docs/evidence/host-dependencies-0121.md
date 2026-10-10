# Incoming IC Host 0.12.1 selection review

After the jobserver repair's complete gate passed on Host 0.12.0, an incoming
lockfile edit selected private `ic-host-artifacts` and `ic-host-fs` 0.12.1.
The edit is preserved. Only those two package versions/checksums change; their
dependencies and every other lock row remain identical. Package/workspace
versions stay 0.5.0. The original 196-second gate and frozen inputs retain their
0.12.0 graph identity; the later mismatch log is retained.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and downloaded registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `6969fa402c3657ef37304c71229557eb36bdf6b323157fafd37580ebb3b297ac` |
| ic-host-fs | `7b5b606bd537b0a47e0dff6f5edf8b107c9e444158d4aba64ac957700634d449` |

Embedded Git identities and every packaged Rust/original manifest file match
released Host `e5ecfa06c14d144cfeb85ea89d65906b1bf81636`, also matching public
main at inspection. Consumed artifact/fs Rust source is unchanged from 0.12.0.
No inspector wrapper, report, arithmetic, consumer identity/state or endpoint
change is needed; there is no process/runtime dependency in this private graph.

Explicit `cargo fetch --locked` prepares the incoming selection; no version
selection or lockfile rewrite is performed. Focused all-target inspector check,
warning-denied Clippy, named argument/report tests, actual CLI test and Rust 1.88
all-target compilation pass. Complete updated-graph validation passes through
the shared logger: `ci` (193 seconds), `msrv` and `wasm-inspect-msrv`. All 81
frozen code/graph/pin/workflow inputs remain unchanged through this gate. The
actual parallel inspector floor check also passes without jobserver warnings.
Inputs, registry/source verification, cache preparation and checks are under
`target/evidence/host-0121/`. Native acceptance remains separate from local
checks. No API or IC instruction/cycle/Wasm-size improvement is claimed.

No sibling edits, tool installation, package-version change, commit, push,
release, publication or workflow dispatch is performed. This separate incoming
dependency qualification is included in the compatible pending 0.5.1 batch;
the Metrics-owned jobserver repair remains [#48](https://github.com/dragginzgame/ic-metrics/issues/48).
