# IC Metrics Agent Rules

Read [DRAGGINZGAME.md](DRAGGINZGAME.md) first. The reviewed Shared Tooling revision
`b32d3038c850a7c53470c326b0f7f11263b31669` and file digests are recorded in
[.shared-tooling.snapshot](.shared-tooling.snapshot). This is the local overlay;
there are no baseline exceptions. Read [the current handoff](docs/status/current.md)
and [the extraction contract](docs/extraction.md) before implementation.

## Ownership

- Own small, allocation-free measurement arithmetic. Keep the library
  dependency-free and `no_std`; consumers own platform counter reads.
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

- `make check-pins` requires prepared Git, jq and Mike Farah yq; consumer-selected
  tool versions/digests are in the reviewed `ci/tool-versions.env`. Explicit
  `make install-host-tools` prepares the pair under `.tools/host/bin`;
  `make host-tools-check` verifies it offline. IC executable pins live only in
  `ci/ic-tools.tsv`. The checker and release gates never install tools or unlock graphs.
- Shared structural reviews use [the common methods](audits/README.md), with
  this overlay's allocation, units, counter identity and ownership constraints.
  Source scope is `crates/ic-metrics`, owning tooling and the affected downstream
  contracts in `docs/extraction.md`; focused commands remain in `docs/hosts.md`.
  Existing performance evidence under `docs/evidence` retains its domain scope
  and original identities. Audit adoption schedules no review or broad gate.
