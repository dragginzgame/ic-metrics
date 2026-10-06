# Changelog

## [0.1.8]

- Adopt the reviewed Shared Tooling rules and dependency declaration checker in
  CI and release validation. Use compatible development dependency requirements
  with locked builds and document the qualified exact IC binding constraint.
- Strengthen release admission and recovery: reject hidden staged edits and
  conflicting pending notes before validation, check the selected release commit,
  and retain failed validation logs across retries. Normal release targets can
  reconcile a saved committed release before validating newer fixes
  ([#5](https://github.com/dragginzgame/ic-metrics/issues/5),
  [Shared Tooling #5](https://github.com/dragginzgame/shared-tooling/issues/5),
  [#7](https://github.com/dragginzgame/shared-tooling/issues/7)).
- Document ic-backup's prepared arithmetic-only host adoption and include its
  duration/byte diagnostics in downstream contract reviews.

## [0.1.7] - 2026-10-06

- Document the platform-gated Rust reader import alongside its opt-in dependency,
  so native linting and Candid generation preserve the Wasm-only API boundary.
  Update the registry adoption example to published 0.1.6
  ([#3](https://github.com/dragginzgame/ic-metrics/issues/3)).

- Document how to assess canister Wasm size, instruction work and actual cycle
  charges separately, with a scoped reader-canister audit and consumer ownership.
  Record consumer lookup measurements and their new-key cost tradeoff, separately
  from the unchanged shared core and reader.

## [0.1.6] - 2026-10-06

- Document published 0.1.5 reader adoption, including the required `ic` feature
  and registry dependency floor. Describe both arithmetic and the opt-in reader
  in package metadata
  ([#3](https://github.com/dragginzgame/ic-metrics/issues/3)).

- Extend `make reader-check` with actual query and composite-query execution,
  verifying callback continuity and exclusion of downstream query work. Configure
  pinned PocketIC execution on Linux and both macOS CI architectures, retaining
  instruction logs, source/artifact identities and failure outcomes. Use the
  ic-testkit 0.18 harness while preserving the core runtime dependencies
  ([#3](https://github.com/dragginzgame/ic-metrics/issues/3)).

## [0.1.5] - 2026-10-05

- Add an opt-in, Wasm-only call-context instruction reader through the safe IC
  binding. Keep the default arithmetic core dependency-free and `no_std`, with
  attribution and native substitutes owned by consumers
  ([#3](https://github.com/dragginzgame/ic-metrics/issues/3)).
- Add `make reader-check` for direct-counter and async-callback qualification in
  PocketIC, with an explicit, checksum-verified 16.0.0 binary.

## [0.1.4] - 2026-10-05

- Document published crates.io adoption with a root workspace dependency example,
  so consumers can use ic-metrics without a sibling checkout
  ([#4](https://github.com/dragginzgame/ic-metrics/issues/4)).

## [0.1.3] - 2026-10-05

### Fixed

- Add `make publish` for the ic-metrics crate on crates.io and `make publish-check`
  for upload-free validation. Enable the crate's publication policy while keeping
  publication separate from version bumps, Git releases and artifact cleanup.
  [#4](https://github.com/dragginzgame/ic-metrics/issues/4).

## [0.1.2] - 2026-10-05

### Changed

- Clarify IC instruction-counter continuity, native-substitute boundaries and
  the requirements for a backend that preserves the dependency-free arithmetic core.
- Run Cargo manifest sorting before Rust formatting in `make fmt` and enforce
  both in `make fmt-check`, CI and release validation. Developer setup requires
  pinned `cargo-sort` 2.1.4; release metadata preparation preserves this ordering.
- Adopt the latest committed Shared Tooling rules, including automatically
  numbered pending notes and complete workspace dependency inheritance. Enable
  the standard formatting hook per clone with `make install-hooks`; partial
  staging is rejected and unrelated working edits are preserved.

### Fixed

- Include the MIT license text and repository URL in the Cargo package, with
  README documentation links usable outside the workspace.
- Rerun the same release target after interruption: early failures repeat
  validation and prepared releases reconcile the saved candidate without another
  bump, duplicate commit/tag or uncertain push replay. Exact-version
  `release-resume` remains available; evidence and conflict checks are preserved.
- Install the standard formatting hook through logical checkout aliases using
  the corrected shared installer.
  [Shared Tooling #1](https://github.com/dragginzgame/shared-tooling/issues/1).

### Testing

- Check the standard hook against this workspace's Makefile in native CI,
  including aliased-path installation, selected-file refresh, partial staging
  and failure isolation without creating commits.
- Exercise release metadata preparation and failure restoration in CI, preserving
  historical notes, member manifests and artifacts when formatting, metadata
  validation or candidate selection fails. Fixtures create no release commits.

## [0.1.1] - 2026-10-05

Development toward `0.1.1`; the release is not selected or published.

### Added

- Allocation-free `record_sample` and `MeasurementSummary` APIs with independent
  saturation, latest/maximum observations and distinct empty versus measured-zero
  states. IcyDB, Canic and ic-timers use explicit local integration dependencies.
- Maintainer release commands `make release-patch`, `release-minor`, `release-major`
  and exact-version `release-resume`, using the reviewed Shared Tooling runner.
  All increments run the same gate, retain artifacts and atomically push only the
  selected branch and annotated tag; publication remains separate.

### Fixed

- Adopt the Shared Tooling snapshot verifier fix for macOS Bash 3.2 empty arrays.

## [0.1.0] - 2026-10-05

Initial repository scaffold. The library has no public measurement API or
consumer adoption, and the Cargo package remains unpublished.

### Added

- Rust edition 2024 workspace with one dependency-free `no_std` library,
  inherited package metadata and lint settings, and disabled package publication.
- Pinned Rust 1.99.0 toolchain, declared Rust 1.88.0 MSRV, and native and
  `wasm32-unknown-unknown` compilation targets.
- Measurement extraction contract and agent instructions defining shared
  arithmetic ownership and consumer-owned attribution, identity and persistence.
- Reviewed Shared Tooling governance snapshot at
  `e16c9c99bd800567189c8024eaf4242a5d1c9e29`, including engineering guides,
  checksum verification and snapshot integrity checks.
- Focused formatting, compilation, Clippy, documentation and MSRV commands;
  native CI for Ubuntu 24.04 and macOS 15 on Intel and Apple Silicon.
- MIT license, development documentation and a public
  [GitHub repository](https://github.com/dragginzgame/ic-metrics) with `main`
  tracking `origin/main`.
