# Changelog

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
