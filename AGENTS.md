# IC Metrics Agent Rules

Read [DRAGGINZGAME.md](DRAGGINZGAME.md) first. The reviewed Shared Tooling revision
`e16c9c99bd800567189c8024eaf4242a5d1c9e29` and file digests are recorded in
[.shared-tooling.snapshot](.shared-tooling.snapshot). This is the local overlay;
there are no baseline exceptions. Read [the current handoff](docs/status/current.md)
and [the extraction contract](docs/extraction.md) before implementation.

## Ownership

- Own small, allocation-free measurement arithmetic and, when its contract is
  demonstrated, an IC instruction-counter boundary. Keep the core `no_std`.
- Consumer code owns measurement attribution, registries, labels, replication
  policy, reset/restart identity, persistence, lifecycle hooks, and endpoints.
  Do not add dependencies on IcyDB, Canic, or `ic-timers`.
- IcyDB's inclusive overlapping spans and Canic's exclusive endpoint accounting
  remain separate consumer contracts. Do not add an attribution-mode switch.
- Units and saturation are explicit. Zero is a valid sample; no samples is a
  different state. Saturated totals are unsuitable for exact interval arithmetic.
  Counter identity must be established before comparing snapshots.
- Native substitutes are not IC measurements. Never add timing benchmarks or
  convert instruction counts into estimated cycles. Permitted performance
  evidence is instruction counts, IC cycles, and raw Wasm bytes.

## Work and validation

- Mutate only this repository unless exact sibling targets are explicitly
  authorized. Never commit or push. Preserve unrelated dirty work.
- Do not edit existing Cargo package/workspace versions. Initial metadata is not
  a release selection; version changes and publication remain maintainer-owned.
- Use Rust edition 2024 and ordinary directory modules. Public APIs need docs;
  invalid input and recoverable failures need typed errors. No string matching
  on errors, production panics, or committed Python tooling.
- Check for active builds before source edits or compilation. Use this repo's
  `target/` and locked dependencies; do not upgrade dependencies as a side effect.
- After Rust edits, run `make fmt`, then selected package checks or named tests.
  Focused commands and host qualification are in [docs/hosts.md](docs/hosts.md).
  Full tests and `make ci` require an explicit request or configured CI.
- Fix warnings in the selected Clippy gate before later validation.
- Do not patch snapshot-owned files. Refresh through the upstream distribution
  helper from a clean checkout of a reviewed revision, then verify the snapshot.
- Keep one undated top `Draft` changelog until a release is selected. Track
  follow-up work exclusively in GitHub issues, not local task lists.
