# Incoming IC Host 0.12.2 selection review

The incoming maintainer lock selection is preserved. Only private
`ic-host-artifacts` and `ic-host-fs` versions/checksums change from 0.12.1;
their dependency lists and every other lock row remain identical. Metrics
package/workspace versions remain 0.5.1.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `a9930b168e6c0e2106af3480f2b573d181dada2886b478000b12f8c79b59fd67` |
| ic-host-fs | `28bf5810925e301299bfb83076317eb55dfb24d28f0100cd5d9455c6fef324d1` |

Embedded Git identities and every packaged Rust/original manifest file match
released Host `e1ef99e6a4c6d05f0b0d8364f8586c6cc358dadc`. Consumed artifact/fs
Rust source is unchanged from 0.12.1. No inspector wrapper, report, arithmetic,
consumer identity/state or endpoint change is required. No graph resolution or
cache download is necessary: both exact selected archives are already cached.

Focused inspector all-target checks, warning-denied Clippy, named argument/report
tests, the actual CLI test and Rust 1.88 compilation pass. The current-graph
complete gate is recorded separately in [the adoption record](adoption-052.md).
Original lock selection, official index responses, archive/source verification
and focused logs are under `target/evidence/host-0122/`. Native acceptance remains
separate; no IC instruction, cycle or Wasm-size improvement is claimed.
