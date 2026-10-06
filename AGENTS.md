# IC Metrics Agent Rules

Read [DRAGGINZGAME.md](DRAGGINZGAME.md) first. The reviewed Shared Tooling revision
`a7efade1a68e43f148252a1a73908a46c4cbe9e9` and file digests are recorded in
[.shared-tooling.snapshot](.shared-tooling.snapshot). This is the local overlay;
there are no baseline exceptions. Read [the current handoff](docs/status/current.md)
and [the extraction contract](docs/extraction.md) before implementation.

## Ownership

- Own small, allocation-free measurement arithmetic and, when its contract is
  demonstrated, an IC instruction-counter boundary. Keep the core `no_std`.
- Consumer code owns measurement attribution, registries, labels, replication
  policy, reset/restart identity, persistence, lifecycle hooks, and endpoints.
  Do not add dependencies on IcyDB, Canic, `ic-timers`, or `ic-backup`.
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
- When shared contracts change, review the IcyDB, Canic, `ic-timers` and
  `ic-backup` callers under [the downstream contract checks](docs/extraction.md#downstream-contract-checks).
  Each consumer owns its qualification; review does not authorize sibling edits.
- Do not patch snapshot-owned files. Refresh through the upstream distribution
  helper from a clean checkout of a reviewed revision, then verify the snapshot.
- Maintain one numbered, undated pending changelog under the shared rules;
  derive its version from the latest finalized release and the complete batch's
  compatibility impact. This does not authorize package version changes or a
  release. Track follow-up work exclusively in GitHub issues, not local task lists.

## Dependency qualification

- The optional Wasm `ic0 = "=1.2.0"` constraint preserves the explicitly qualified
  safe System API binding described in [the extraction contract](docs/extraction.md#ic-reader-contract-audit).
  Its exact value is recorded in `ci/dependency-pinning-exceptions.json`; changing
  that boundary requires reader/callback qualification, not only lock resolution.
  Development registry dependencies use compatible requirements and locked builds.
- `make check-pins` requires prepared Git, jq and Mike Farah yq; consumer-selected
  tool versions/digests are in `ci/tool-versions.env`. CI provisions the parser
  explicitly. The checker and release gates do not install tools or unlock graphs.
