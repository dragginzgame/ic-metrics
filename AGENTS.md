# IC Observability Agent Rules

Read [DRAGGINZGAME.md](DRAGGINZGAME.md) first. The reviewed Shared Tooling revision
`a245bb49312a5ccafbb71532cfa5346741e3ba28` (0.27.8 base plus reviewed publication adapter)
and file digests are recorded in
[.shared-tooling.snapshot](.shared-tooling.snapshot). This is the local overlay;
there are no baseline exceptions. Read [the current handoff](docs/status/current.md)
at startup and [the extraction contract](docs/extraction.md) before arithmetic,
consumer-contract or persistence-boundary changes.

## Ownership

- This renamed workspace owns the independent `ic-metrics` and `ic-logging`
  packages. They share the root catalog, lockfile and version, with no dependency
  on one another. Existing Metrics package identities remain unchanged.
- Logging owns a dependency-free `no_std` + `alloc` heap engine with explicit
  input time, fixed text/count bounds, retention batches and cursor scans.
  It owns no global recorder, endpoint, authorization, clock or timer.
  Canic adoption and governed stable-adapter qualification remain separate work;
  see [the logging boundary](docs/logging.md). Publication is selected per package.

- Metrics owns allocation-free measurement arithmetic and optional bounded heap recording. Keep its library
  `no_std`, with allocation-free arithmetic; consumers own platform counter reads.
- Serde transport for aggregates, counters, summaries and fixed-bound histograms,
  plus default-enabled `native-wire` metadata, are standard. Arithmetic consumers
  can disable default features to exclude native Wire; Serde stays available.
  Decode only through canonical arithmetic admission. Heap recording stays optional.
- IC Persistence owns the separately opted-in `ic-metrics-stable` package, its
  governed Memory/Storage integration, tests and release. This repository owns
  arithmetic and the explicitly selected `recording` store. Hosts retain allocator
  selection, lifecycle, instance identity and write cadence.
  Never add stable-memory dependencies to the arithmetic package.
- IC Persistence likewise owns the separately selected `ic-logging-stable`
  adapter, durable codec and governed storage qualification. Logging owns passive
  checkpoints and canonical restoration, including sequence/time watermarks after
  complete retention. Keep its heap engine dependency-free; hosts select durable
  identity, allocation, lifecycle and checkpoint cadence.
- IC Host owns the published `ic-host-wasm-inspect` CLI, its installation guide
  and Rust floor. Optional evidence experiments select their own qualified tool
  identity; Metrics owns no inspector wrapper, pin or workspace dependency.
  Source-less lock packages must be workspace-owned; external path dependencies
  are not permitted. Release metadata advances coordinated workspace members,
  including Logging. Publication remains selected per package.
- Consumer code owns measurement attribution, labels, registry limits, replication
  policy, reset authorization, restart identity, persistence, lifecycle hooks, and endpoints.
- Metrics' maintainer-selected bounded recording extension (2026-10-28) permits
  `alloc` only behind the `recording` feature. The shared table owns retention
  and omitted-observation accounting; generic windows own nonwrapping reset
  sequences, never platform clocks or globally unique identity.
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
  authorized. The shared [contribution rules](rules/contributions.md) govern
  authorized PRs and release effects.
- This consumer supports `RELEASE_DELIVERY=direct` only. PR release delivery
  needs separately adopted merged-checkout adapters and qualification; ordinary
  contribution PRs retain the shared contribution rules.
- Use Rust edition 2024. No string matching on errors or production panics.
- Check for active builds before source edits or compilation. Use this repo's
  `target/` and locked dependencies; do not upgrade dependencies as a side effect.
- After Rust edits, run `make fmt`, then selected package checks or named tests.
  Focused commands and host qualification are in [docs/hosts.md](docs/hosts.md).
  Full `make ci` and `make msrv` are release gates or explicit
  check requests. Follow [the validation policy](DRAGGINZGAME.md#validation-and-evidence)
  for batched focused checks and evidence reuse. Documentation-only work needs
  link, consistency and diff checks.
- Fix warnings in the selected Clippy gate before later validation.
- When shared contracts change, review the IcyDB, Canic, `ic-timers`,
  `ic-backup`, IC Blob Storage test-probe and Toko Miner callers under
  [the downstream contract checks](docs/extraction.md#downstream-contract-checks).
  Each consumer owns its qualification; review does not authorize sibling edits.

## Dependency qualification

- Follow [shared local setup](docs/local-setup.md) and the selected catalogs
  in `ci/tool-versions.env` and `ci/ic-tools.tsv`; Metrics has no tool-catalog
  exception. [make/consumer.mk](make/consumer.mk) owns common setup/check,
  formatting, hook and release recipes. Local host qualification and commands
  remain in [docs/hosts.md](docs/hosts.md).
- Metrics selects the released IC Build metadata editor in `ci/release-tools.env`.
  Explicit setup installs it through the shared managed installer; checks and
  metadata preparation only admit an already prepared selection. It is tooling,
  never a dependency of the arithmetic library.
- `make check-pins` requires prepared Git, jq and Mike Farah yq. Checks never
  install tools or unlock dependency graphs. Select product CLI adapters through
  the shared managed installer; keep application compiler policy local.
- Shared structural reviews use [the common methods](audits/README.md), with
  this overlay's allocation, units, counter identity and ownership constraints.
  Source scope includes `crates/ic-metrics`, `crates/ic-logging`, owning
  tooling and the affected downstream contracts in `docs/extraction.md`; focused
  commands remain in `docs/hosts.md`.
  Existing performance evidence under `docs/evidence` retains its domain scope
  and original identities. Audit adoption schedules no review or broad gate.
