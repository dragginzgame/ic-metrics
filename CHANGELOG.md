# Changelog

## [0.2.20] - 2026-10-09

### Fixed

- Reject multi-document dependency-pinning exception files, keeping exception
  admission and suppression bound to one validated catalog
  ([Shared Tooling #86](https://github.com/dragginzgame/shared-tooling/issues/86)).

## [0.2.19] - 2026-10-09

### Fixed

- Prepare missing locked dependencies during standard releases before offline
  validation, honouring explicitly selected offline mode and stopping on fetch
  failures before validation or metadata changes
  ([#40](https://github.com/dragginzgame/ic-metrics/issues/40),
  [Shared Tooling #84](https://github.com/dragginzgame/shared-tooling/issues/84)).
- Find prepared checkout-local tools when formatting isolated staged inputs,
  without requiring an interactive PATH export
  ([Shared Tooling #85](https://github.com/dragginzgame/shared-tooling/issues/85)).

### Added

- Adopt shared Cargo binary/example setup with explicit package/profile selection,
  single-document offline receipt and byte checks, retained failed builds and
  original Cargo failure statuses
  ([Shared Tooling #65](https://github.com/dragginzgame/shared-tooling/issues/65)).

### Changed

- Qualify the private Wasm inspector's existing Host 0.8.9 lock selection with
  unchanged structural reports, keeping the arithmetic crate dependency-free.

## [0.2.18] - 2026-10-09

### Changed

- Run fleet tooling reports centrally in Shared Tooling, removing unused consumer
  copies and their dedicated CI fixture while retaining local setup and workspace
  LOC reporting ([#38](https://github.com/dragginzgame/ic-metrics/issues/38),
  [Shared Tooling #83](https://github.com/dragginzgame/shared-tooling/issues/83)).

### Fixed

- Reuse verified IC tool bundles across comment-only or reordered pin catalogs
  without downloads or receipt changes
  ([Shared Tooling #79](https://github.com/dragginzgame/shared-tooling/issues/79)).
- Preserve running and queued CI for each pushed source while allowing newer PR
  revisions to replace older review runs
  ([Shared Tooling #80](https://github.com/dragginzgame/shared-tooling/issues/80)).

## [0.2.17] - 2026-10-09

### Added

- Add checked cumulative histogram counts and nearest-rank quantile bucket
  ranges, preserving empty/zero and saturation distinctions without extra
  recording state ([#39](https://github.com/dragginzgame/ic-metrics/issues/39)).
- Add exact scaled integer ratios for fractional means and proportions from
  wide totals, rejecting zero denominators and unrepresentable results
  ([Testkit #40](https://github.com/dragginzgame/ic-testkit/issues/40)).

### Changed

- Update the private Wasm inspector's locked IC Host dependencies to 0.8.5,
  keeping the public arithmetic crate dependency-free.

## [0.2.16] - 2026-10-08

### Fixed

- Report all staged, unstaged and untracked release-source blockers before
  validation or version preparation, using the shared source checker
  ([Shared Tooling #74](https://github.com/dragginzgame/shared-tooling/issues/74),
  [#37](https://github.com/dragginzgame/ic-metrics/issues/37)).

### Changed

- Update the private Wasm inspector's locked IC Host dependencies to 0.8.4,
  keeping the public arithmetic crate dependency-free
  ([#37](https://github.com/dragginzgame/ic-metrics/issues/37)).
- Adopt current Shared Tooling rules and pinned PocketIC 16.1.0 executables
  ([Shared Tooling #76](https://github.com/dragginzgame/shared-tooling/issues/76),
  [#37](https://github.com/dragginzgame/ic-metrics/issues/37)).

## [0.2.15] - 2026-10-08

### Added

- Add a private host Wasm inspector with explicit input budgets and digest-bound
  size/structure reports, using IC Host libraries while keeping the arithmetic
  crate dependency-free ([#36](https://github.com/dragginzgame/ic-metrics/issues/36)).

### Fixed

- Validate complete committed workspaces during release checks, including the
  private host package, instead of failing on missing member manifests
  ([#36](https://github.com/dragginzgame/ic-metrics/issues/36)).
- Resolve relative tool-setup consumer and IC pin paths correctly with inherited
  `CDPATH`, preserving literal directory names
  ([#34](https://github.com/dragginzgame/ic-metrics/issues/34),
  [Shared Tooling #67](https://github.com/dragginzgame/shared-tooling/issues/67)).
- Adopt explicit installer-test companion declarations so incomplete tooling
  snapshots are refused before replacement
  ([Shared Tooling #73](https://github.com/dragginzgame/shared-tooling/issues/73)).
- Reject malformed active tool links before execution or downloads, preserving
  literal link targets ([Shared Tooling #75](https://github.com/dragginzgame/shared-tooling/issues/75),
  [#34](https://github.com/dragginzgame/ic-metrics/issues/34)).

### Changed

- Lower the minimum supported Rust version from 1.88 to 1.85 while retaining
  edition 2024 and the existing arithmetic APIs
  ([#35](https://github.com/dragginzgame/ic-metrics/issues/35)).
- Adopt Shared Tooling 0.1.28 with separate release simulation and real-Git
  tracking fixtures, retaining both in the native gate
  ([Shared Tooling #70](https://github.com/dragginzgame/shared-tooling/issues/70),
  [#34](https://github.com/dragginzgame/ic-metrics/issues/34)).

## [0.2.14] - 2026-10-08

### Fixed

- Keep release and tooling entry points working with inherited `CDPATH` and
  literal newline checkout paths ([#33](https://github.com/dragginzgame/ic-metrics/issues/33),
  [Shared Tooling #67](https://github.com/dragginzgame/shared-tooling/issues/67)).
- Count dotted shared snapshot names correctly in tooling LOC reports
  ([Shared Tooling #69](https://github.com/dragginzgame/shared-tooling/issues/69)).

### Changed

- Adopt Shared Tooling 0.1.27 with explicit installer evidence-fixture companions,
  including their inputs in native source receipts while preserving the consumer's
  archive and recovery-state policy ([#33](https://github.com/dragginzgame/ic-metrics/issues/33),
  [Shared Tooling #73](https://github.com/dragginzgame/shared-tooling/issues/73)).

## [0.2.13] - 2026-10-08

### Fixed

- Refresh an unchanged verified tooling snapshot again before committing it,
  while preserving consumer edits and refusing staged or concurrent conflicts
  ([#32](https://github.com/dragginzgame/ic-metrics/issues/32),
  [Shared Tooling #64](https://github.com/dragginzgame/shared-tooling/issues/64)).

## [0.2.12] - 2026-10-08

### Changed

- Adopt Shared Tooling 0.1.25 to refresh matching release tracking refs safely,
  include `bin/` and unborn repositories in tooling LOC reports, and check
  declared snapshot companions ([#31](https://github.com/dragginzgame/ic-metrics/issues/31),
  [Shared Tooling #62](https://github.com/dragginzgame/shared-tooling/issues/62)).
- Reuse the shared archiver for failed tool candidates while preserving Git
  recovery state in the outer native evidence archive
  ([#30](https://github.com/dragginzgame/ic-metrics/issues/30)).

## [0.2.11] - 2026-10-08

### Fixed

- Adopt Shared Tooling 0.1.23 to recheck release payloads and exact tags before
  pushing, and verify published identity when resuming completed releases.
  Conflicts stop without repeating release effects
  ([#28](https://github.com/dragginzgame/ic-metrics/issues/28),
  [Shared Tooling #58](https://github.com/dragginzgame/shared-tooling/issues/58)).

## [0.2.10] - 2026-10-08

### Changed

- Adopt Shared Tooling 0.1.20 contribution rules: an explicit PR request includes
  scoped commits and the topic-branch push; merges and releases retain separate
  authorization ([#24](https://github.com/dragginzgame/ic-metrics/issues/24)).
- Refresh to Shared Tooling 0.1.22 release tooling and explicitly retain direct
  delivery. Unsupported PR delivery is rejected before release effects
  ([#27](https://github.com/dragginzgame/ic-metrics/issues/27)).

## [0.2.9] - 2026-10-07

### Fixed

- Adopt Shared Tooling 0.1.19: reject redirected Rust-tool installation paths,
  handle macOS temporary-directory aliases in tooling fixtures, and preserve
  historical changelog bytes while rejecting ambiguously dated release targets
  ([#23](https://github.com/dragginzgame/ic-metrics/issues/23),
  [Shared Tooling #54](https://github.com/dragginzgame/shared-tooling/issues/54),
  [#55](https://github.com/dragginzgame/shared-tooling/issues/55),
  [#56](https://github.com/dragginzgame/shared-tooling/issues/56)).
- Preserve source receipts, setup logs, outcomes and failed tool candidates when
  native CI setup fails before the library gates
  ([#25](https://github.com/dragginzgame/ic-metrics/issues/25)).
- Supply a checksum-bound histogram replay bundle with locked sources, raw
  measurements and Wasms; retain the unavailable earlier experiment as distinct
  historical evidence ([#26](https://github.com/dragginzgame/ic-metrics/issues/26)).

## [0.2.8] - 2026-10-07

### Changed

- Adopt Shared Tooling 0.1.18 and prepare pinned Cargo tools through the same
  checkout-local setup and offline checks in Make and native CI
  ([#22](https://github.com/dragginzgame/ic-metrics/issues/22)).
- Refresh the verified release and downstream documentation, including Blob
  Storage's test probe and Toko Miner's production action metrics
  ([#21](https://github.com/dragginzgame/ic-metrics/issues/21)).

### Fixed

- Reject Make options and assignments before validation starts, isolate LOC
  fixtures from enclosing Cargo configuration, and exclude physical build output
  selected through symlinks. Consumer tooling-inventory fixtures now validate
  adopted working-tree bytes without depending on the upstream exporter
  ([#22](https://github.com/dragginzgame/ic-metrics/issues/22)).

## [0.2.7] - 2026-10-07

### Fixed

- Adopt the corrected Shared Tooling revision: changelog finalization keeps notes attached to
  headings with trailing whitespace, and validation can retain complete logs
  and preserves Make failure status
  ([#18](https://github.com/dragginzgame/ic-metrics/issues/18),
  [Shared Tooling #37](https://github.com/dragginzgame/shared-tooling/issues/37)).

- Keep LOC fixtures on their own workspace when CI retains temporary files in
  the checkout, isolate inherited Cargo target settings, and export the
  distribution helper required by the tooling-inventory fixture
  ([Shared Tooling #48](https://github.com/dragginzgame/shared-tooling/issues/48),
  [#47](https://github.com/dragginzgame/shared-tooling/issues/47)).

### Changed

- Refresh shared LOC reporting and audit guidance, including explicit workspace
  selection and correct ownership for snapshots with custom manifest paths.

## [0.2.6] - 2026-10-07

- Add constant-capable `checked_mean` and `MeasurementSummary::mean()` with
  typed errors for saturated or inconsistent aggregates, preserving empty and
  measured-zero results
  ([#17](https://github.com/dragginzgame/ic-metrics/issues/17)).
- Add a compiled application integration guide and source-bound two-bucket
  histogram cost evidence for an isolated Canic recording path
  ([#20](https://github.com/dragginzgame/ic-metrics/issues/20),
  [#19](https://github.com/dragginzgame/ic-metrics/issues/19)).
- Use shared Make commands to install and verify pinned jq, yq, ripgrep and cloc,
  and add workspace Rust and sibling tooling reports
  ([#16](https://github.com/dragginzgame/ic-metrics/issues/16)).

## [0.2.5] - 2026-10-07

- Reject inherited Make modes that ignore failures or skip execution before
  release, validation and pre-commit formatting, while preserving release
  selections and parallel-job controls
  ([#14](https://github.com/dragginzgame/ic-metrics/issues/14),
  [Shared Tooling #30](https://github.com/dragginzgame/shared-tooling/issues/30)).

## [0.2.4] - 2026-10-07

- Add `MeasurementHistogram` with fixed caller-selected bounds, disjoint
  saturating buckets, overflow and the existing summary semantics. Invalid
  bounds return a typed `HistogramBoundsError`; construction and recording
  support constant evaluation
  ([#15](https://github.com/dragginzgame/ic-metrics/issues/15)).
- Bind release validation and atomic push to the recorded destination URL,
  rejecting changed or additional destinations before dispatch
  ([#13](https://github.com/dragginzgame/ic-metrics/issues/13),
  [Shared Tooling #25](https://github.com/dragginzgame/shared-tooling/issues/25)).
- Verify snapshot files independently of their checksum helper
  ([Shared Tooling #27](https://github.com/dragginzgame/shared-tooling/issues/27)).
- Reject failed standalone yq version probes and directory destinations while
  preserving installed tools and failed inputs through the common installer
  ([Shared Tooling #26](https://github.com/dragginzgame/shared-tooling/issues/26)).
- Include the complete governance file list for isolated consumer link checks
  ([Shared Tooling #28](https://github.com/dragginzgame/shared-tooling/issues/28)).

## [0.2.3] - 2026-10-06

- Preserve pending changelog notes when version components exceed floating-point
  integer precision; older undated history stays intact
  ([Shared Tooling #23](https://github.com/dragginzgame/shared-tooling/issues/23)).
- Keep passing and ignored Rust tests with `error::` names out of highlighted
  errors, while retaining real diagnostics and neutral failure context
  ([Shared Tooling #22](https://github.com/dragginzgame/shared-tooling/issues/22)).
- Retain failed shared release and dependency-pin fixtures for inspection
  ([Shared Tooling #21](https://github.com/dragginzgame/shared-tooling/issues/21)).

## [0.2.2] - 2026-10-06

- Attempt every metadata restore after a preparation failure, report incomplete
  recovery and retain all originals when a file cannot be restored
  ([#11](https://github.com/dragginzgame/ic-metrics/issues/11)).
- Archive native CI evidence before upload so valid fixture filenames and hidden
  Git state survive artifact restrictions
  ([#7](https://github.com/dragginzgame/ic-metrics/issues/7)).
- Adopt the reviewed shared host-tool fixture fix, preserving authenticated
  archive bytes and exposing failed installer diagnostics.
- Use the shared TOML workspace-version reader and offline formatter prerequisite
  checks. Valid TOML comments work, invalid manifests and failed parsers are
  rejected, and formatting uses the same reviewed pin as setup and CI
  ([#12](https://github.com/dragginzgame/ic-metrics/issues/12)).
- Preserve older undated changelog entries during release preparation by passing
  the saved previous version to the shared finalizer.

## [0.2.1] - 2026-10-06

- Retain failed release, metadata and formatting-hook fixture inputs and logs,
  report their scratch paths, and cover child-command and assertion failures
  without release or publication effects. Native CI uploads failed scratch
  directories, including their Git index evidence
  ([#7](https://github.com/dragginzgame/ic-metrics/issues/7)).
- Stop release checks when version readers, Git object checks or formatter
  prerequisites fail, even if they print expected output; retain failed
  selected-commit metadata exports for diagnosis.
- Use reviewed shared release-command, local-lockfile and dependency-free hook
  checks, retaining failed evidence after restoring the selected metadata
  ([#11](https://github.com/dragginzgame/ic-metrics/issues/11)).
- Enforce Cargo workspace version and dependency inheritance in `make check-pins`.
- Make downstream evidence links usable outside the local workspace and align
  current release/adoption guidance with published 0.2.0; check local document
  references in CI with `make check-doc-links`
  ([#9](https://github.com/dragginzgame/ic-metrics/issues/9)).

## [0.2.0] - 2026-10-06

- **Breaking:** remove `call_context_instructions` and feature `ic`. Consumers
  must read the IC counter through their existing CDK/System API adapter and
  remove the feature selection. `record_sample`, `MeasurementSummary`, zero/empty
  semantics and saturation are unchanged
  ([#10](https://github.com/dragginzgame/ic-metrics/issues/10)).
- Keep the entire library dependency-free and `no_std` on host and Wasm. Retire
  `make reader-check`, its fixture and host harness; arithmetic checks no longer
  compile IC test infrastructure. CI retains native/tooling evidence and historical
  reader records remain tied to their original releases
  ([#8](https://github.com/dragginzgame/ic-metrics/issues/8)).

## [0.1.9] - 2026-10-06

- Prepare ripgrep explicitly on Linux and macOS CI so dependency-pin fixtures
  can run, and retain native gate logs when validation fails before reader setup
  ([#5](https://github.com/dragginzgame/ic-metrics/issues/5)).
- Add common repository-local host and IC tools through `make install-tools`
  and offline `make tools-check`. Use pinned local jq/yq and the common PocketIC
  installer, preserving explicit setup, failed candidates and reader qualification
  ([#6](https://github.com/dragginzgame/ic-metrics/issues/6)).

## [0.1.8] - 2026-10-06

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
