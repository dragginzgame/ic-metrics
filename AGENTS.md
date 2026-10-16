# IC Metrics Agent Rules

Read [DRAGGINZGAME.md](DRAGGINZGAME.md) first. The reviewed Shared Tooling revision
`9b555ad46b7a74e8fbbeba234b8df60829be58ce` and file digests are recorded in
[.shared-tooling.snapshot](.shared-tooling.snapshot). This is the local overlay;
there are no baseline exceptions. Read [the current handoff](docs/status/current.md)
and [the extraction contract](docs/extraction.md) before implementation.

## Ownership

- Own small, allocation-free measurement arithmetic. Keep the library
  dependency-free and `no_std`; consumers own platform counter reads.
- The separately opted-in `ic-metrics-stable` package owns one-map snapshot
  encoding and validated restoration, using `ic-memory`'s exact collection types.
  Its native/Wasm Rust floor is 1.91. Hosts own the allocation key, bootstrap,
  collection lifecycle, identities, synchronization, write cadence and resets.
  Never add stable-memory dependencies to the arithmetic package.
- IC Host owns the published `ic-host-wasm-inspect` CLI, its installation guide
  and Rust floor. Optional evidence experiments select their own qualified tool
  identity; Metrics owns no inspector wrapper, pin or workspace dependency.
  Source-less lock packages must be workspace-owned; external path dependencies
  are not permitted. Release metadata advances both local workspace rows together.
- Consumer code owns measurement attribution, registries, labels, replication
  policy, reset/restart identity, persistence, lifecycle hooks, and endpoints.
  Do not add dependencies on IcyDB, Canic, `ic-timers`, or `ic-backup`.
- IcyDB's inclusive overlapping spans and Canic's exclusive endpoint accounting
  remain separate consumer contracts. Do not add an attribution-mode switch.
- Units and overflow are explicit. Zero is a valid sample; no samples is a
  different state. Overflowed totals are unsuitable for exact interval arithmetic.
  Counter identity must be established before comparing snapshots.
- Native substitutes are not IC measurements. Never add timing benchmarks or
  convert instruction counts into estimated cycles. Permitted performance
  evidence is instruction counts, IC cycles, and raw Wasm bytes.
- Public evidence must exclude private sibling source, search excerpts and issue
  bodies. Select payloads explicitly; read access is not export authority. Follow
  [the archive distribution record](docs/evidence/archive-distribution-072.md)
  for original retention and separately identified sanitized receipts.

## Work and validation

- Mutate only this repository unless exact sibling targets are explicitly
  authorized. Preserve unrelated dirty work. Follow the shared
  [contribution rules](rules/contributions.md): an explicit PR request includes
  its topic branch, scoped commits, branch push and PR creation/update. Ordinary
  fixes and continuation authorize local work. Merges, direct integration-branch
  pushes and shared-history rewrites require their own explicit authorization.
- Cargo package/workspace version changes and releases require explicit authority.
  Initial metadata is not a release selection; an ordinary PR does not authorize
  a version bump, tag, release or publication. An explicitly requested standard
  release includes its documented gate, commit, tag and atomic push; publication
  remains a separate effect. Preserve branch protections and required checks.
- This consumer supports `RELEASE_DELIVERY=direct` only. PR release delivery
  needs separately adopted merged-checkout adapters and qualification; ordinary
  contribution PRs retain the shared contribution rules.
- Use Rust edition 2024 and ordinary directory modules. Public APIs need docs;
  invalid input and recoverable failures need typed errors. No string matching
  on errors, production panics, or committed Python tooling.
- Check for active builds before source edits or compilation. Use this repo's
  `target/` and locked dependencies; do not upgrade dependencies as a side effect.
- After Rust edits, run `make fmt`, then selected package checks or named tests.
  Focused commands and host qualification are in [docs/hosts.md](docs/hosts.md).
  Focused checks for the changed behavior and directly affected callers suffice
  for ordinary handoff under [the validation policy](DRAGGINZGAME.md#validation-and-evidence).
  Full `make ci` and `make msrv` are release gates or explicit
  check requests. Reuse passing evidence only for unchanged inputs. Documentation-
  only work needs link, consistency and diff checks. Releases remain separately
  authorized.
- Fix warnings in the selected Clippy gate before later validation.
- When shared contracts change, review the IcyDB, Canic, `ic-timers`,
  `ic-backup`, IC Blob Storage test-probe and Toko Miner callers under
  [the downstream contract checks](docs/extraction.md#downstream-contract-checks).
  Each consumer owns its qualification; review does not authorize sibling edits.
- Do not patch snapshot-owned files. Refresh through the upstream distribution
  helper from a clean checkout of a reviewed revision, then verify the snapshot.
- Maintain one numbered, undated pending changelog under the shared rules;
  derive its version from the latest finalized release and the complete batch's
  compatibility impact. This does not authorize package version changes or a
  release. Track follow-up work exclusively in GitHub issues, not local task lists.

## Dependency qualification

- Follow [shared local setup](docs/local-setup.md) and the selected catalogs
  in `ci/tool-versions.env` and `ci/ic-tools.tsv`; Metrics has no tool-catalog
  exception. [make/consumer.mk](make/consumer.mk) owns common setup/check,
  formatting, hook and release recipes. Local host qualification and commands
  remain in [docs/hosts.md](docs/hosts.md).
- `make check-pins` requires prepared Git, jq and Mike Farah yq. Checks never
  install tools or unlock dependency graphs. Select product CLI adapters through
  the shared managed installer; keep application compiler policy local.
- Shared structural reviews use [the common methods](audits/README.md), with
  this overlay's allocation, units, counter identity and ownership constraints.
  Source scope is `crates/ic-metrics`, owning tooling and the affected downstream
  contracts in `docs/extraction.md`; focused commands remain in `docs/hosts.md`.
  Existing performance evidence under `docs/evidence` retains its domain scope
  and original identities. Audit adoption schedules no review or broad gate.
