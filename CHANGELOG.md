# Changelog

## [0.22.0] - Unreleased

### ⚠️ Breaking

- Make native Wire metadata optional through the default-enabled `native-wire`
  feature. Callers disabling defaults must explicitly select it for schemas;
  arithmetic and validated Serde transport remain available without Wire.
  See [migration](docs/migration-022.md) and [#101 — Allow native arithmetic consumers to exclude Wire metadata dependencies](https://github.com/dragginzgame/ic-observability/issues/101).

### 🧪 Testing

- Execute Serde round trips and malformed-state admission without native Wire,
  sharing report fixtures with the generated TypeScript codec checks. CI also
  checks resolved minimal, recording, default and Wasm production dependency
  graphs so optional metadata remains an explicit selection.

### 🧹 Cleanup

- Reuse admitted message parts when constructing log entries, keeping truncation
  and retained-text accounting on one calculation with unchanged behavior.

## [0.21.1] - 2026-10-31

### 🧪 Testing

- Execute generated Metrics TypeScript codecs against Rust report bytes, covering
  wide integers, exact caps, overflow quality and fixed-bound histograms. Run
  `make typescript-check` with the pinned Node runtime; a separate CI job retains
  the generated inputs and outputs without adding npm dependencies.
- Exercise logging's independent event-history model with reproducible generated
  operation schedules across append, retention, restoration and cursor scans.

### 📚 Documentation

- Reconcile current guides with the 0.20–0.21 releases and their Wire 0.10 contract.

## [0.21.0] - 2026-10-30

### 📝 Summary

- Repeat the 0.20.0 release under 0.21.0 after an accidental second minor release.
  IC Wire remains at 0.10.0; there are no additional API, behavior or dependency
  changes. The [0.20 migration guide](docs/migration-020.md) also applies to 0.21.

## [0.20.0] - 2026-10-30

### ⚠️ Breaking

- Adopt IC Wire 0.10.0 for Metrics' native metadata. Consumers deriving Wire or
  generating schemas for reports containing Metrics values must align their
  direct Wire dependency to 0.10. Numeric layouts, arithmetic and Logging behavior
  are unchanged. Endpoint applications separately coordinate Platform 0.11;
  this workspace enables no endpoint runtime. See the
  [native metadata migration guide](docs/migration-020.md).

## [0.19.0] - 2026-10-30

### ⚠️ Breaking

- Adopt IC Wire 0.8.0 for Metrics' native metadata. Consumers composing Metrics
  values in Wire reports must align their direct Wire dependency to 0.8; Wire
  0.7's metadata trait is a different Rust dependency identity. Arithmetic,
  Serde layouts and Logging behavior are unchanged. Endpoint users separately
  coordinate Platform 0.9; this workspace enables no endpoint runtime.
  See the [native metadata migration guide](docs/migration-019.md).

## [0.18.1] - 2026-10-30

### ⬆️ Dependencies

- Adopt IC Wire 0.7.25 and Shared Tooling 0.27.11. Align the Wire declaration
  with the selected lockfile and retain shared publication gate ordering,
  ordinary Rust module discovery and scoped lint-expectation guidance.
  Public APIs, report layouts and compiler requirements are unchanged.

## [0.18.0] - 2026-10-30

### ⚠️ Breaking

- Logging requires an explicit combined retained-text budget and returns append
  receipts with identity, truncation and eviction count. Topic filters now choose
  any, absent or exact topics. Update callers and coordinate durable checkpoint
  adoption with IC Persistence; existing stored layouts are not reinterpreted.
  See the [0.18 migration guide](docs/migration-018.md).

### ➕ Added

- Borrow complete Logging checkpoints without copying history, and visit bounded
  cursor pages without allocating a result collection, including early-stop cursors.
- Serialize summaries and fixed-bound histograms with standard Serde and native
  Wire metadata. Decoding uses fixed arrays and canonical arithmetic admission,
  retaining bounds, latest values and all overflow-quality flags.

### 🧪 Testing

- Enforce native-only Wire metadata and explicit transport features in dependency
  admission, including attempts to enable dependency features through local switches.

### 🔧 Changed

- Retain MSRV source/compiler identities, setup and validation logs, outcomes and
  checksummed artifacts on success or failure. Capture allocator-free Wasm as
  soon as linking succeeds so a later check failure preserves that evidence.

## [0.17.7] - 2026-10-30

### 🧪 Testing

- Link a runtime-input Metrics arithmetic consumer as Wasm without supplying an
  allocator, on the pinned and minimum compilers. Compare mixed Logging append,
  refusal, retention, paging and checkpoint operations with an independent
  event-history model, including sequence exhaustion and UTF-8 limits.

### 📚 Documentation

- Align the package publication instructions with the two-package default and
  record the consuming Logging checkpoint accessor as released in 0.17.5.

### 🧹 Cleanup

- Delegate package selection and upload/dry-run dispatch to Shared Tooling's
  retained publication adapter. Keep the local package roster, registry and
  native/Wasm lint gate declarative, with consumer tests focused on their wiring.
  Both packages remain selected by default; `PACKAGE=` selects a declared subset.

## [0.17.6] - 2026-10-30

### 🩹 Fixed

- Make `publish` and `publish-check` select both Metrics and Logging by default,
  retaining `PACKAGE=...` for single-package publication and partial recovery.

### 🧹 Cleanup

- Group release-admission scenarios and share independent command expectations,
  fault writers and native archive assertions, preserving failure evidence and
  the current scenario coverage.
- Move native source capture into a directly exercised script and keep scenario
  setup alongside its expected boundary results.
- Separate Logging checkpoint validation from construction and share histogram
  range construction without changing public APIs or admission semantics.
- Adopt reviewed Shared Tooling cleanup for captured input-checkpoint companions
  and coordinated Cargo workspace admission, retaining original-lock checks and
  first-error evidence at each boundary.

## [0.17.5] - 2026-10-30

### ➕ Added

- Add `Log::into_snapshot` to move retained entries into a checkpoint without
  cloning their owned text, preserving limits, ordering and append watermarks.
  Borrowed snapshots and canonical restoration retain their existing behavior.
  [Checkpoint guide](crates/ic-logging/README.md).

### 🧪 Testing

- Exercise default Metrics publication and explicit Metrics/Logging selection,
  including upload and native/Wasm lint failures. Clarify the separate workspace
  release and per-package publication commands.

## [0.17.4] - 2026-10-29

### 🧹 Cleanup

- Share Logging's truncation-suffix policy between message construction and
  checkpoint admission, preserving independent retained-message validation.
- Separate histogram restoration facts and total-range arithmetic from final
  admission, preserving constant evaluation, overflow rules and typed refusals.
- Move native CI evidence collection into an owned script and let release
  fixtures own assertion-failure inputs, preserving diagnostic/recovery custody
  and first-error propagation.
- Share dependency-declaration fixture construction across both packages and
  derive minimum-compiler doctest coverage from the workspace.

## [0.17.3] - 2026-10-29

### 🩹 Fixed

- Reject impossible empty Logging checkpoints at the final representable timestamp,
  while preserving valid terminal rows and fully pruned histories.
- Reserve the complete truncated Logging message buffer once, avoiding growth
  when appending the truncation suffix.

### ➕ Added

- Implement `Display` and `core::error::Error` for Logging append refusals,
  supporting standard error propagation without adding dependencies.

## [0.17.2] - 2026-10-29

### ➕ Added

- Add validated Logging checkpoints and restoration, preserving sequence/time
  watermarks after full retention and exhaustion. IC Persistence can build an
  independently selected stable adapter without introducing storage dependencies
  into the heap engine.

## [0.17.1] - 2026-10-29

### ➕ Added

- Add an unpublished, independent Logging crate with bounded heap history,
  UTF-8-safe messages, explicit age retention and scan-bounded cursor paging.

### 🔧 Changed

- Rename the repository to IC Observability and share one workspace between
  Metrics and Logging. Keep the published Metrics crate identity, arithmetic
  behavior and dependency boundaries; durable adapters remain with IC Persistence.
- Give Metrics its own package guide and admit both libraries in workspace
  dependency, compiler-floor and documentation checks.

## [0.17.0] - 2026-10-29

### ⚠️ Breaking

- Make validated aggregate/counter transport and native IC Wire metadata standard.
  Remove `wire` from consumer feature lists; Serde and native Wire dependencies
  are now required. Heap recording remains opt-in, measurement operations remain
  allocation-free, and Rust `no_std` support is retained.

## [0.16.7] - 2026-10-29

### ➕ Added

- Opt-in `wire` transport for measurement aggregates and scalar counters, with
  Serde decoding through numeric admission and native IC Wire browser metadata
  ([#99](https://github.com/dragginzgame/ic-metrics/issues/99)). Default arithmetic
  remains dependency-free; consumers retain report composition and codec limits.

## [0.16.6] - 2026-10-29

### 🧹 Cleanup

- Separate histogram bucket-limit calculation from restored-state validation and
  share ratio decomposition between floor and nearest rounding, preserving public
  APIs and numeric admission behavior.
- Reuse tracked overflow arithmetic for histogram admission and store retained
  table identities as immutable boxed strings.

### 🧪 Testing

- Keep shape-specific restoration coverage beside its arithmetic owner and cover
  empty identities under zero byte budgets and reuse of cleared, populated tables.
- Cover omission-reason precedence when recording limits overlap.

### 📚 Documentation

- Include optional recording APIs in docs.rs builds and compile the bounded-table
  usage example from the application guide. Document recording admission order.
- Show feature selection in focused recording validation instructions and make
  recording README links usable outside the repository checkout.

## [0.16.5] - 2026-10-28

### ➕ Added

- Optional bounded same-unit measurement tables with explicit key/entry budgets,
  borrowed snapshots and accounted omitted observations, without platform reads.
- Generic heap-local measurement windows with nonwrapping reset sequences;
  consumers retain units, instance identity, reset authorization and endpoints.
  Default arithmetic stays allocation-free; recording uses `alloc` without
  adding production dependencies.

### 🧪 Testing

- Include optional recording in package and lint gates, with release fixtures
  covering the selected feature flags and failure propagation.

## [0.16.4] - 2026-10-28

### 📝 Summary

- Adopt reviewed Shared Tooling 0.27.4, including timed Rust formatting with
  exact-input reuse and snapshot comparison against the reviewed upstream commit.
- Derive formatting-hook fixture inputs from the shared companion closure,
  preserving actual consumer formatting and failure-retention checks.

## [0.16.3] - 2026-10-26

### 📝 Summary

- Adopt reviewed Shared Tooling 0.26.20 with a compact agent baseline,
  Cargo-tool setup diagnostics and clearer fixture-retention failures.
- Normal release commands start fresh from committed metadata; use
  `make release-resume VERSION=X.Y.Z` to recover a specific saved attempt.
  Offline tool admission distinguishes contention with exit status 75.

## [0.16.2] - 2026-10-25

- Simplify dependency-free admission to locked Cargo declarations across all
  targets and features, removing redundant native/Wasm graph observations.
  Failed, malformed and incomplete metadata still refuse admission.
- Update the arithmetic adoption example to 0.16 and remove obsolete local
  stable-adapter qualification guidance in favour of IC Persistence's owner docs.

## [0.16.1] - 2026-10-25

- Enforce dependency-free arithmetic across optional and target-specific normal
  and build declarations; simplify fixtures and require the intended rejection.
- Make local dependency/source fixtures independent of inherited `CDPATH`, and
  include the packaged README in native source evidence.
- Qualify public doctests at Rust 1.91 and retire obsolete migration guidance in
  favour of IC Persistence's canonical stable-adapter documentation.

## [0.16.0] - 2026-10-24

- Move `ic-metrics-stable` to IC Persistence, retaining its crate name, public
  API and V1 stored bytes. This repository now publishes only dependency-free
  `ic-metrics`; its arithmetic API and Rust 1.91 floor are unchanged.
- **Upgrade:** stable-adapter users select its published Persistence release
  line together with Memory and Storage. See the
  [migration guide](https://github.com/dragginzgame/ic-persistence/blob/main/docs/migration/ic-metrics-stable.md).
  Existing published 0.15 adapter archives remain available; no data reset is needed.

## [0.15.8] - 2026-10-24

- Adopt reviewed Shared Tooling 0.26.10, including literal formatting catalog
  admission, dependency diagnostics and offline tool reporting.
- Verify both actual Cargo package archives in CI and after release metadata
  preparation, before staging; publication remains a separate command.
- Strengthen durable checkpoint qualification with an independent bounded
  reachability model, populated frozen V1 reopening and multi-bit byte mutations.
- Clarify that the record byte budget applies after Storage reads the value;
  it does not bound allocation for host-inserted oversized rows.
- Qualify the incoming Memory/Storage 0.50.13 and Platform 0.6.12 selection.

## [0.15.7] - 2026-10-23

- Adopt reviewed Shared Tooling 0.26.8: explicit Cargo-tool setup waits for an
  admitted shared-slot owner and handles lock withdrawal during cleanup. Source
  cache initialization no longer uses a global installation lock; offline checks
  still refuse immediately. Run `make install-tools` once after adoption for the
  changed build-policy identity. Previous generations and evidence remain retained.

## [0.15.6] - 2026-10-22

- Update the release metadata editor to IC Build 0.64.0 with its required `cli`
  feature, adopting current IC Host tooling outside the library graphs. Run
  `make install-release-editor` before offline checks, or let normal release
  preflight prepare it. Existing tool generations remain retained.
- Point optional Wasm inspection documentation at the consolidated IC Tooling
  repository; frozen experiments retain their original tool identities.

## [0.15.5] - 2026-10-22

- Adopt reviewed Shared Tooling 0.26.6 with explicit optional IC tool selection
  and hardened validation logs, checksums and failure evidence. Normal setup
  remains host/Cargo-only; optional IC setup and checks require the same
  `IC_TOOLS` list. Existing tool bundles and release evidence remain retained.
- Qualify the resolved Memory/Storage 0.50.10 graph, which supplies the unchanged
  stable substrate through IC Platform 0.6.7. Metrics APIs, V1 records and the
  Rust 1.91 floor are unchanged; no data reset is required.
- Clarify that narrow reports must retain metric rows when an exact wide total
  cannot fit, preserving source overflow quality separately from narrowing failure.

## [0.15.4] - 2026-10-21

- Reject stable aggregate, summary and histogram checkpoints whose exact-count
  changes cannot be explained by appended observations. Return the existing
  `StateRegression` error before writing, preserving retained rows. Valid appends,
  clipped-count behavior, public signatures and V1 record bytes are unchanged.

## [0.15.3] - 2026-10-21

- Remove withdrawn evidence archives and paired checksums from published branch
  and tag histories, preserving the current 0.15.2 source tree and sanitized
  receipts. Other existing clones must adopt the rewritten history without
  merging old ancestry. Close [#72 — Review private consumer source in existing evidence archives](https://github.com/dragginzgame/ic-metrics/issues/72)
  as not planned at the maintainer's request; remaining GitHub-held ref/cache
  cleanup will not be pursued.
- Delete seven obsolete contribution branches whose work was delivered or
  intentionally retired. Main, release tags and closed PR records are retained.
- Close [#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82)
  as not planned at the maintainer's request. The existing local test observer
  remains in place; no replacement or adoption is claimed.

## [0.15.2] - 2026-10-21

- Refresh the lockfile to Memory 0.50.5 and Storage 0.50.5 within the existing
  0.50 manifest requirements.
- Close [#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83)
  as not planned until an owning application and retention policy are identified.
  Existing volatile defaults and the optional persistence API are unchanged.

## [0.15.1] - 2026-10-21

- Enforce Metrics' standalone application-capability boundary: production graphs
  reject IC Build as well as Host and Testkit, including renamed transitive edges.
  Update the adoption guide to the 0.15 contract and aligned Memory/Storage 0.50.
- Qualify Memory 0.50.1 and Storage 0.50.1. Their library implementations,
  production features and Rust floors match 0.50.0; Metrics APIs and
  stored formats are unchanged.
- Adopt reviewed Shared Tooling 0.25.9's release retry protection. A committed
  preparation must have confirmed Git delivery before another version increment;
  failed or uncertain delivery retains the saved plan and evidence.

## [0.15.0] - 2026-10-20

- **Breaking stable dependency identities:** adopt `ic-memory` 0.50 and
  `ic-storage` 0.50 from their consolidated IC Persistence repository. Hosts
  supplying maps to `ic-metrics-stable` must select both 0.50 dependencies;
  earlier Memory handles and Storage maps have different Rust type identities.
- Library implementations, Metrics V1 records and upstream allocation/map formats
  are unchanged by this dependency alignment; no data reset is required.
  The arithmetic package remains dependency-free, with Rust 1.91 retained.

## [0.14.12] - 2026-10-20

- Adopt reviewed Shared Tooling 0.25.8, including automatic finalization of
  numbered `- Unreleased` changelog headings during release preparation.
- Run the existing native/Wasm Clippy gate before CI test suites and publication
  packaging. Lint failure stops later stages, including under parallel Make;
  library APIs and release/publication authority are unchanged.

## [0.14.11] - 2026-10-20

- Adopt reviewed Shared Tooling 0.25.6. Failed release metadata checks retain
  Cargo output, root manifest/lock inputs and separate Cargo/logger statuses;
  Cargo's original failure takes priority. Checks do not retry or repair inputs.
  Library APIs, dependency selections and release policy are unchanged.

## [0.14.10] - 2026-10-20

- Preserve the native recovery archive when diagnostic collection fails, while
  retaining the original failure status. Report a secondary packaging failure
  without hiding the first error. Addresses
  [#95 — Retain native recovery archives after diagnostic collection failure](https://github.com/dragginzgame/ic-metrics/issues/95).
- Adopt reviewed Shared Tooling 0.25.5's clarified failure-evidence contract.
  Selected executable helpers and tool pins are unchanged.
- Qualify the selected Memory 0.49.2 / Storage 0.5.8 graph. Their library
  sources, features, normal dependencies and Rust floors match the preceding
  qualified patches; Metrics APIs and V1 storage bytes remain unchanged.
- Refresh the current handoff after 0.14.9 and remove the stale Storage patch
  selection from the extraction contract. Manifests and the lock own selections;
  earlier IC receipts retain their original dependency identities.

## [0.14.9] - 2026-10-20

- Adopt reviewed Shared Tooling 0.25.3, including feature-aware selected-tool
  admission and more specific repair diagnostics. Rerun `make install-tools`
  after adoption to prepare tools for the updated build policy; existing
  installations and failed attempts remain retained. Library contracts, compiler
  selections and dependency versions are unchanged.
- Include native test targets and development dependencies in the Rust 1.91
  gate, retaining the library-only Wasm floor check.
- Check histogram recording, merging and restoration against exact weighted
  observations across count/total overflow boundaries, using the existing
  test-only arbitrary-precision dependency.
- Add read-only `make evidence-check` to CI and release validation. It verifies
  distributed evidence archives and retained inspection reports from their
  recorded working directories, preserving frozen archive and manifest bytes.

## [0.14.8] - 2026-10-19

- Qualify Memory 0.49.1 with the existing Storage 0.5.7 selection. Its library
  source, normal dependencies, features and Rust floor match Memory 0.49.0;
  focused checks cover the new locked graph. Frozen IC measurements retain their
  original 0.49.0 identity.
- Check floor and nearest scaled ratios against an independent arbitrary-precision
  reference across full-width boundaries and deterministic mixed-bit inputs.
  `num-bigint` 0.5.1 is test-only; production arithmetic remains dependency-free and
  `no_std`, with unchanged public APIs and Rust floors.
- Shorten the handoff to qualification scope and owning issue/evidence links.
  Package manifests and the changelog own versions and release state.

## [0.14.7] - 2026-10-19

- Adopt Memory 0.49 with Storage 0.5.7; require at least Storage 0.5.7 so the
  declared dependencies admit the matching governed runtime-handle API.
  Memory now uses serde_cbor in place of Ciborium. Metrics does not expose the
  changed upstream decoder error; arithmetic APIs and Metrics V1 bytes are unchanged.
- Update allocation-format guidance: Memory 0.49 retains current 0.48 ledger
  bytes without a reset. Earlier retired images remain subject to Memory's
  host-owned disposition. Frozen IC experiments retain their original graphs.
- Require one Memory, Storage and stable-substrate identity in each production
  graph, using Shared Tooling's existing observer and duplicate-version fixtures.
- Exercise bit and adjacent-bit mutations of persisted V1 records across all
  four metric families. Admitted records round-trip canonically; refused loads
  and checkpoints preserve retained bytes and perform no stable writes.
- Qualify the Memory 0.48.2 / Storage 0.5.6 to Memory 0.49.0 / Storage 0.5.7
  transition with a matched IC fixture. Retained values, leases, rollback and
  reset checks pass. The durable fixture grows by 85,907 raw Wasm bytes; bootstrap
  instructions decrease slightly and checkpoint instructions increase slightly.
  See the [version-bound comparison](docs/evidence/memory-0147.md).

## [0.14.6] - 2026-10-19

- Check histogram restoration against an independent exhaustive oracle of small
  raw observation sequences, including unreachable bucket/count/total states.
- Qualify missing release-editor selection and editor-pin drift independently of
  the formatter; refusal preserves metadata, the index and existing executables.
- Refresh the separately frozen IC durability and checkpoint-cost qualification
  for the governed Memory 0.48.2 / Storage 0.5.6 graph, with published Platform,
  Wire and Testkit interfaces. Historical experiment identities remain unchanged.
  See the [current-graph receipt](docs/evidence/stable-current-0146.md).

## [0.14.5] - 2026-10-19

- Adopt reviewed Shared Tooling 0.25.0 at
  `2a79f5f93383f3d2a8a38d65406c7d52c2f77913`. Match grouped manifest formatting
  in hooks and release checks, and retire the old Perl metadata renderers.
- Prepare the published IC Build 0.18.0 release editor through explicit managed
  tool setup and release preflight. Metadata preparation admits that selection
  read-only with a 1 MiB per-document limit; neither library depends on IC Build.
- Delegate resolved production-graph checks to Shared Tooling while retaining
  Metrics' package, target, dependency-free core and stable-adapter exclusions.
  Arithmetic, stable V1 records, dependency selections and Rust floors are unchanged.

## [0.14.4] - 2026-10-18

- Refresh released-source and downstream qualification status; record focused
  stable-adapter and production-dependency checks for Storage 0.5.4. Arithmetic
  and stable V1 contracts are unchanged.

## [0.14.3] - 2026-10-18

- Document lossless scalar reporting and exact-cap versus overflow behavior.
  Forwarded readings with unknown clipping remain a consumer-owned lower bound
  or unavailable value; restoration cannot reconstruct discarded quality.

## [0.14.2] - 2026-10-18

- Correct Testkit adoption guidance for its integrated private statistics reporter.
  Metrics 0.14 adoption does not require merging the closed contribution or
  replacing Testkit's consumer-owned cohort builder. Arithmetic and stable V1
  contracts are unchanged.

## [0.14.1] - 2026-10-18

- Enforce native/Wasm production dependency boundaries in CI and release checks:
  arithmetic stays dependency-free, and the stable adapter excludes Host, Testkit
  and Memory's test-support feature. Renamed and transitive dependencies are
  checked without changing the selected graph
  ([#94 — Enforce production dependency and test-support exclusions in library CI](https://github.com/dragginzgame/ic-metrics/issues/94)).
- Select Rust 1.99.1 for development formatting, lint and builds. Both published
  packages retain their Rust 1.91 minimum
  ([#93 — Qualify Rust 1.99.1 as the development compiler](https://github.com/dragginzgame/ic-metrics/issues/93)).

## [0.14.0] - 2026-10-18

### Breaking

- Remove `summarize_samples`, `SampleStatistics` and `SampleStatisticsError`.
  Complete floating-point sample projections now belong to Testkit's private
  development reporter; other callers must move them to their owning report code.
  Tracked integer APIs, Rust 1.91 support and stable V1 records are unchanged.
  Integrate [Testkit PR #125](https://github.com/dragginzgame/ic-testkit/pull/125)
  before selecting Metrics 0.14 there.

### Added

- Add `CheckedMeasurementAggregate` for exact `u128` observations, count, total
  and extrema. Recording rejects count/total overflow without partial updates;
  empty and measured zero remain distinct. Existing tracked accumulators and
  stable V1 records are unchanged ([PR #92](https://github.com/dragginzgame/ic-metrics/pull/92)).

### Changed

- Adopt Shared Tooling 0.24.0 with the reviewed committed fixture correction at
  `8e90cbdad8b12c9c2f8cb507d60266b162c0dabf` from
  [Shared PR #276](https://github.com/dragginzgame/shared-tooling/pull/276).
  Label production packages/dependencies and the development-only Memory feature;
  retain matching global manifest order in formatting and release checks.
  Common Rust setup now selects only the two formatters. Verify diagnostic
  sidecars through the checksum owner and keep workflow outcome policy local.
  Production graph inspection is separate from automated exclusion enforcement
  ([#94](https://github.com/dragginzgame/ic-metrics/issues/94)). Nested evidence
  fixtures now admit their complete companion closure while rejecting copies
  that would overwrite selected inputs. The normal release-tooling gate passes;
  this snapshot selects an unmerged upstream fix, not a released 0.24.1.

- Clarify report ownership with a compiled exact-wide-total example: preserve
  source quality and distinguish accumulated observations from independent
  latest-value diagnostics before deriving means. No arithmetic API changes.

- Retain the existing `MetricsMap` alias for IC Storage's exact byte map type,
  avoiding an unnecessary public API migration. Direct Storage map construction
  and lease-preserving transfer remain supported.

- Qualify staged formatting against the durable package and real workspace
  dependencies, using Shared Tooling's fixture generator instead of the former
  dependency-free hook selection. Remove the retired platform-reader pin exception
  placeholder and keep old API migration instructions in release history. Include
  both packages in structural review scope and classify the full MSRV gate
  consistently in command help.
- Read fixed-width codec fields through one checked slice operation, retaining
  typed truncation errors. Link generic tooling qualification to its shared owner
  while keeping Metrics' commands and recovery-evidence obligations local.
- Prepare the release-admission fixture from the metadata adapter's declared
  companion closure, replacing its duplicated helper list. Keep the minimal
  tool-free bootstrap fixture and actual two-package release checks.
- Correct the stable guide for already selected Memory 0.48: its allocation
  format retires earlier images. Unchanged Metrics V1 rows do not establish
  allocator compatibility or authorize an automatic reset.
- Remove the direct stable-structures test dependency and raw collection import.
  Frozen V1 rows still exercise all four metric kinds through IC Storage's
  governed map; Storage owns its underlying collection-format qualification.

## [0.13.4] - 2026-10-17

- Consolidate truncated-record checks across all four durable metric families,
  including empty and populated summaries. Every rejected prefix must preserve
  stored bytes and perform no writes; independent V1 byte fixtures remain intact.
- Remove overlapping native/Wasm check passes from CI while retaining strict
  Clippy coverage and standalone check commands. Point arithmetic documentation
  to the stable adapter's current store guide for persistence capabilities.
- Delegate hook failure-log replay and scratch custody to Shared Tooling; remove
  the extra fixture and redundant assertion meta-test while preserving actual
  metadata and retention checks. Correct README adoption to the 0.13 contract
  and IC Storage's governed map over IC Memory handles.
- Adopt reviewed Shared Tooling 0.23.0 and its companion-closure fixture preparer,
  retaining unchanged tool pins and the workflow executor from
  [Shared PR #276 — Consumer fixture execution and formatting diagnostics](https://github.com/dragginzgame/shared-tooling/pull/276).

## [0.13.3] - 2026-10-17

- Reuse Shared Tooling's shell fixture executor while retaining Metrics' workflow
  scenarios and archive checks. Keep generic release-recovery assertions with
  their shared owner and current guidance separate from historical handoffs
  ([Shared PR #276 — Share ordered shell fixture execution and outcomes](https://github.com/dragginzgame/shared-tooling/pull/276)).
- Adopt Shared Tooling 0.21.0, including Rust policy admission fixes. Common tool
  pins are unchanged; optional IC tools select ICP CLI 1.7.0. Developers using
  that bundle must rerun `make install-ic-tools` before its offline check.

## [0.13.2] - 2026-10-17

- Reuse IC Memory's admitted fixture bootstrap and express fixed codec sizes as
  constants, retaining typed oversized-histogram refusal and unchanged V1 rows.
- Adopt committed Shared Tooling 0.20.0, including literal tool-catalog admission
  and common release-version validation. Tool pins remain unchanged.
- Own native recovery-archive packaging and its fixtures locally, preserving
  hidden Git state, checksum replay and partial-failure evidence. Sanitized
  diagnostic exports remain shared
  ([#89 — Own native recovery-archive packaging in Metrics](https://github.com/dragginzgame/ic-metrics/issues/89)).

## [0.13.1] - 2026-10-17

- Restore the arithmetic dependency's registry version requirement so the stable
  package can be published. Release preparation keeps this requirement aligned
  with future workspace minor versions.

## [0.13.0] - 2026-10-17

### Breaking

- Require IC Storage's governed upstream-map facade for durable metrics. Open
  `MetricsMap` with the host's admitted `ic-memory` runtime handle; its generic
  parameter now names the runtime backing. Replace raw-map constructors and
  update explicit store types under the [stable guide](https://github.com/dragginzgame/ic-metrics/blob/92ff804125fb07370fad4cb24cc620f52122ac36/crates/ic-metrics-stable/README.md#store-operations).
  The upstream B-tree format, Metrics V1 records and permanent allocation keys
  are preserved; this cut requires no Metrics store reset.

- Select IC Memory 0.47 and IC Storage 0.4 together. Use Memory's narrow
  root backing imports; handles are exclusive leases. Drop the owning store/map
  before reopening its allocation, and preserve host backing custody across
  runtimes. Existing Memory 0.45 allocation images and Metrics V1 records need
  no reset ([#87 — Finish narrow imports in the governed metrics-map adoption](https://github.com/dragginzgame/ic-metrics/issues/87)).

### Changed

- Declare supported release delivery once and reuse Shared Tooling admission in
  Make and standalone metadata checks. Unsupported modes still refuse before
  effects ([Shared PR #259](https://github.com/dragginzgame/shared-tooling/pull/259)).

- Expose allocation-free `validate_histogram_bounds` for borrowed bounds and use
  it for histogram construction, restoration and stable-load configuration.
  Keep first-invalid-bound reporting, size-before-row admission and V1 records.
- Retain separate rank and scaled-ratio paths after reviewing their IC costs.
  The [narrower rank trial](docs/evidence/bounds-rank-0121.md) preserves histogram
  costs but grows sample-statistics Wasm and regresses wide fractions; the
  [existing ratio trial](docs/evidence/arithmetic-convergence-0112.md) remains
  applicable to the unchanged ratio implementation.

## [0.12.0] - 2026-10-16

### Breaking

- Replace public `DurableMetric` and generic stable `load`/`save` with concrete
  counter, aggregate, summary and histogram operations. Use `load_counter`,
  `load_aggregate`, `load_summary` or `load_histogram`, and the matching `save_*`.
  Histogram loads take finite bounds directly. V1 records, kind IDs, corruption
  refusal and host-owned `ic-memory` allocation/bootstrap are preserved.

### Changed

- Select IC Memory 0.45 through its unchanged stable-structures collection
  re-export. Keep host allocation/bootstrap guidance bound to the supplying
  source, distinguishing Memory's allocator-format retirement from Metrics'
  unchanged V1 record layout.

- Adopt the reviewed Shared Tooling optional IC-bundle contract. Common setup,
  checks, version reports and PATH use host/Cargo tools; remove Metrics' unused
  IC receipt projection. Standalone IC setup remains available for experiments
  ([Shared PR #254](https://github.com/dragginzgame/shared-tooling/pull/254)).
- Retain sorted finite-sample statistics after the partitioning trial increased
  raw Wasm size and common small-sample IC costs. The
  [frozen comparison](docs/evidence/sample-selection-0120.md) records the rejected
  candidate and independent replay; the statistics API remains unchanged.

## [0.11.8] - 2026-10-16

- Keep Memory allocation/bootstrap instructions at their version-bound owner,
  retaining the adapter’s `ic-memory` integration and host-owned memory ID.
- Keep generic logger fallback/retry qualification in Shared Tooling while
  preserving Metrics’ actual release-adapter routing and recovery checks.
- Reuse stable-record rejection checks after reopening a corrupted summary,
  including zero-write verification. Test encoded lengths and round trips without
  treating allocator capacity as proof of allocation history.

## [0.11.7] - 2026-10-16

- Let Git create isolated release-fixture checkouts and read selected metadata
  from the same source. Remove redundant snapshot roots while retaining their
  required companion payloads unchanged.

- Keep generic release-preflight, common-tool reporting and archive failure
  qualification at their Shared Tooling owners. Metrics fixtures retain adapter
  authority, workflow status/log handling and actual recovery-payload checks.

- Retire the unused failure-upload action and CI binary installer from the
  selected Shared Tooling snapshot; active collection and common setup remain
  at their canonical owners.
- Share the workspace Rust-floor reader with explicit Rust setup, preserving
  prepared-toolchain overrides, parser failures and validation without installs.
  Adopt reviewed Shared Tooling source `d33cb5251b537636d6d0619c75accf658592f99e`
  through the snapshot exporter.
- Retain the measured histogram implementation: the proposed shared range
  construction saves only 5 Wasm bytes and increases common query costs. The
  [matched IC comparison](docs/evidence/quantile-range-0117.md) records the decision.

## [0.11.6] - 2026-10-16

### Changed

- Share bounded cursor admission for fixed-size stable record reads, preserving
  V1 bytes and typed errors. The matched four-type probe is smaller and reduces
  histogram decoding instructions; see the
  [decoder comparison](docs/evidence/decoder-cleanup-0116.md).
- Reuse shared assertion and exit probes without fake parser responses or
  per-case Git repositories. Retention fixtures honor caller-selected `TMPDIR`,
  preserving actual metadata, release and retained-input checks.
- Read CI Rust setup from existing TOML policy through the reviewed Shared
  Tooling helper ([PR #239](https://github.com/dragginzgame/shared-tooling/pull/239)),
  preparing pinned host parsers first and retaining setup failures. Remove the
  hook wrapper's repeated formatter admission and exercise unusual filenames
  through the actual workflow hashing step.
- Run complete release/hook fixtures through their retention suite without
  duplicate CI dispatch, replay unexpected child failures, and upload compressed
  evidence without another compression pass.
- Derive the validation Rust floor from Cargo unless explicitly overridden, and
  give the metadata adapter one release-file roster for Make and source checks.
- Store immutable metric units without growable-string capacity metadata,
  preserving V1 records and reducing measured construction/clone instructions;
  see the [identity comparison](docs/evidence/identity-storage-0116.md).

## [0.11.5] - 2026-10-16

### Changed

- Admit histogram quantile inputs once and validate ASCII durable units directly
  as bytes, preserving public results, typed failures and stable V1 records.
  Matched IC probes show lower quantile and valid-unit instruction costs, with
  a bounded invalid-UTF-8 trade-off; see the
  [measured cleanup decisions](docs/evidence/admission-cleanup-0115.md).
- Keep common installation/PATH mechanics and real Cargo offline-policy
  qualification at Shared Tooling. Metrics retains workflow result projection,
  recovery evidence and actual release-adapter checks
  ([Shared PR #235](https://github.com/dragginzgame/shared-tooling/pull/235)).
- Retire `install-wasm-inspector`, `wasm-inspector-tools-check` and
  `wasm-inspect-check`. Optional experiments select and invoke the published
  inspector directly through the managed installer; the
  [IC Host guide](https://github.com/dragginzgame/ic-host-tooling/pull/156)
  owns the commands. Existing experiment identities and artifacts are retained.

## [0.11.4] - 2026-10-16

### Changed

- Adopt the reviewed 114-file Shared Tooling 0.15.2 candidate at
  `c550bc7b8bcff48723402c7dfcb94e73bd440284`, carrying the common hosted-tool
  action and Make-fixture bootstrap onto the existing Metrics baseline
  ([Shared PR #229](https://github.com/dragginzgame/shared-tooling/pull/229) and
  [#231](https://github.com/dragginzgame/shared-tooling/pull/231)).
- Delegate common CI installation/check/PATH mechanics to the shared action,
  preserving Metrics' setup/check diagnostic filenames and failed-setup logs.
  Release fixtures share the Make bootstrap and retain their local logger inputs.
- Share malformed-row refusal assertions across aggregate/counter tests; verify
  typed load/save errors, unchanged retained bytes and zero stable writes.
  Encoding vectors, explicit removal and runtime arithmetic remain unchanged.
- Keep exhaustive Make flag and common-tool leaf failure permutations at Shared
  Tooling. Check each Metrics target with four unsafe Make behaviors, retaining
  parallel dispatch, publication arguments, representative setup/check/admission
  failures, diagnostic selection and hidden Git recovery evidence.
- Keep generic selected-source metadata rejection and validation-runner flag
  coverage at Shared Tooling ([PR #232](https://github.com/dragginzgame/shared-tooling/pull/232)),
  retaining the actual Metrics release adapter and recovery checks. Current
  onboarding links to historical changes and release receipts at their owners.

## [0.11.3] - 2026-10-15

### Changed

- Adopt the reviewed 112-file Shared Tooling 0.15.2 candidate at
  `6ed2e1c048e3a56b6993ac20372dd1b7aaf366ab`. Retire the unused maintenance
  runner and systemd copies through canonical distribution; retain the task
  catalog, guidance and explicit upstream operational-file selection list
  ([Shared PR #220](https://github.com/dragginzgame/shared-tooling/pull/220)).
- Use Shared Tooling's explicit Rust installer for local and CI preparation,
  replacing the separate CI action while preserving compiler/component/target
  selections and setup failure status.
- Move ten overlapping simulated cache/tool scenarios to Shared Tooling's
  producer fixture ([PR #228](https://github.com/dragginzgame/shared-tooling/pull/228));
  retain actual release-adapter routing, Cargo offline-policy and Git-state checks.

## [0.11.2] - 2026-10-15

### Changed

- Delegate metadata, release and hook fixture log replay to Shared Tooling while
  retaining local log selection, original failure statuses and retention policy
  ([Shared PR #221](https://github.com/dragginzgame/shared-tooling/pull/221)).
- Adopt the reviewed 113-file Shared Tooling 0.15.2 candidate at
  `ebca2ba2cbab7dba6427bac8151644e9d0960332` through canonical distribution.
- Consolidate native/Wasm checks, Clippy, documentation and tests into workspace
  gates covering both packages; retire `stable-check`. Focused package checks
  remain available through Cargo.
- Move six generic tool-store and candidate-archive regression scenarios to
  Shared Tooling ([PR #222](https://github.com/dragginzgame/shared-tooling/pull/222)).
  Keep actual workflow ordering, collector status propagation, readable logs and
  outer Git recovery-state checks in Metrics.
- Construct the summary overflow test's admitted cap directly; aggregate tests
  retain the merge/record sequence that reaches it. Runtime arithmetic is unchanged.

## [0.11.1] - 2026-10-15

### Added

- Add allocation-free finite sample statistics over caller-owned slices, with
  approximate means, midpoint medians and observed nearest-rank quantiles.
  Invalid fractions, non-finite samples and rounded mean overflow return typed
  errors ([#85](https://github.com/dragginzgame/ic-metrics/issues/85),
  [PR #86](https://github.com/dragginzgame/ic-metrics/pull/86)).
- Add constant-evaluable `checked_scaled_ratio_nearest`, rounding exact halves
  upward with checked final overflow. Existing floor projections are unchanged
  ([#80](https://github.com/dragginzgame/ic-metrics/issues/80),
  [PR #81](https://github.com/dragginzgame/ic-metrics/pull/81)).

### Changed

- Delegate read-only changelog preflight to Shared Tooling's canonical helper
  through the reviewed 113-file 0.15.2 candidate snapshot
  ([Shared PR #217](https://github.com/dragginzgame/shared-tooling/pull/217)).
- Consolidate release-validation fixture setup and remove the redundant shell
  publication-chain test; retain direct release rejection and publication checks.
- Keep the exhaustive logger-depth matrix at Shared Tooling; retain one actual
  Metrics release-adapter refusal check before either validation gate runs.
- Move older release and preparation narratives into a linked historical handoff,
  keeping current versions, qualification and consumer owners easy to find.

### Fixed

- Correct current adoption and release guidance for published 0.11.0: Rust 1.91,
  the selected Memory 0.41 graph and shared literal metadata preparation. Keep
  preparation evidence distinct from released-source native acceptance.

## [0.11.0] - 2026-10-15

### Breaking

- Raise both packages' native and Wasm minimum supported Rust version to 1.91.

### Changed

- Use one Rust 1.91 native/Wasm workspace floor gate; retire the separate stable
  floor target and duplicate CI/release dispatch.
- Keep 22 exhaustive shared regression suites at Shared Tooling, retiring unused
  snapshot test payloads while retaining actual Metrics integration/admission checks.
- Delegate complete native archive packaging to Shared Tooling, preserving hidden
  Git recovery state, readable diagnostics and original partial-failure evidence
  ([Shared PR #215 — Native evidence packaging](https://github.com/dragginzgame/shared-tooling/pull/215)).
- Keep the published Wasm inspector opt-in: common setup/check, CI and release
  preflight need only common tools. Explicit inspector setup and smoke checks
  remain available; frozen experiments retain their original identities.
- Keep Shared checker fixture-layout assertions at their producer, while retaining
  Metrics' own failure status, diagnostic forwarding and metadata/publication custody
  ([Shared PR #211 — Checker retention](https://github.com/dragginzgame/shared-tooling/pull/211)).
- Adopt the Shared Tooling 0.15.0 integration candidate, preserving existing
  qualification helpers and adding explicit manifest-order checks against the
  selected release source ([Shared PR #205 — Integration candidate](https://github.com/dragginzgame/shared-tooling/pull/205)).

## [0.10.1] - 2026-10-15

### Changed

- Keep exhaustive release-root isolation at Shared Tooling, retaining one actual
  consumer wiring check; use its validated workflow run-body extractor in native
  evidence fixtures ([Shared PR #207](https://github.com/dragginzgame/shared-tooling/pull/207)).
- Restore histogram bucket counts, maximum placement and total-range consistency
  in one admission pass, preserving typed failures and stored V1 records.
- Use canonical current-source formatter discovery and shared locked release
  preparation, retaining source admission, tool selection and pin-change refusal
  ([Shared PR #204 — Share release preparation and formatter discovery](https://github.com/dragginzgame/shared-tooling/pull/204)).
- Share fixture completion admission with Shared Tooling while preserving
  successful diagnostic retention and original failure statuses
  ([Shared PR #200 — Share completion admission](https://github.com/dragginzgame/shared-tooling/pull/200)).
- Delegate generic Make admission, fixture execution/retention and native
  diagnostic collection to Shared Tooling; retain consumer target rosters,
  effect stubs, payload assertions and complete Git recovery archives
  ([Shared PR #201 — Share consumer validation flows](https://github.com/dragginzgame/shared-tooling/pull/201)).
- Keep allocation/bootstrap qualification at IC Memory; retain Metrics' mixed-kind
  one-map reopening, identity and checkpoint assertions here.

## [0.10.0] - 2026-10-14

### Breaking

- Remove summary forwarding methods for count, total, maximum, mean and scaled
  mean. Use `summary.aggregate().samples()`, `.total()`, `.maximum()`, `.mean()`
  or `.scaled_mean(scale)`; ordered recording and `latest()` stay summary-owned.
  Existing stable V1 layouts and host allocation/reset policy are unchanged.

### Added

- Checkpoint scalar `MeasurementCounter` totals through the optional stable
  adapter, preserving wide totals, actual-overflow flags and reset identities.
  Existing V1 record layouts and the one-map allocation remain unchanged.

### Fixed

- Advance the stable package's local Metrics dependency requirement when
  preparing a minor release, keeping package and lock versions coherent
  ([Shared PR #197 — Fix coordinated Cargo requirements](https://github.com/dragginzgame/shared-tooling/pull/197)).

### Changed

- Use a minimal isolated Git baseline for synthetic release-admission cases;
  retain the real committed graph for offline Cargo and selected-source checks.
- Keep generic archive filename, mode and link coverage at Shared Tooling while
  preserving Metrics' workflow ordering, payload replay and outer Git custody.
- Keep current handoff guidance separate from historical qualification receipts,
  preserving the earlier sources, graphs and measured evidence.

## [0.9.6] - 2026-10-14

### Changed

- Reuse one NUL-delimited native source selection for provenance hashes and
  workflow fixtures, including pending source while excluding generated/private
  evidence and historical archives.
- Report all admitted common host, Rust and IC tools through Shared Tooling,
  recording live versions and executable hashes; compiler and inspector evidence
  stay local, and failed partial reports survive diagnostic recovery.
- Reuse shared pipe jobserver observation in release fixtures, preserving actual
  Make forwarding checks without consuming tokens.
- Allocate and physically anchor local fixture directories through Shared
  Tooling, preserving caller cleanup, diagnostics and intentional retention.
- Keep inspector report-schema assertions at IC Host; Metrics' managed dispatch
  smoke test binds the report to its input digest and byte count.
- Prepare the stable compiler's Wasm target through the existing pinned action,
  preserving independent arithmetic and stable package floors.

## [0.9.5] - 2026-10-14

### Changed

- Share cleanup probes, Git source-admission coverage and formatter-log discovery
  with Shared Tooling, retaining Metrics' release ordering, diagnostic retention,
  archive layout and Git custody. Library APIs and stored V1 bytes are unchanged.
- Remove the obsolete Cargo-edit prerequisite and release-fixture substitute;
  metadata preparation remains owned by Shared Tooling's literal renderer.
- Admit native hosts through the shared validator, preserving local matrices and
  PATH ordering while refusing failed observations with plausible output.
- Encode already admitted durable state without unreachable runtime errors;
  compile-time layout budgets preserve record limits and decoder validation.

## [0.9.4] - 2026-10-14

### Changed

- Adopt Shared Tooling 0.12.2 through a clean committed snapshot, preserving
  selected tool pins, library dependencies, APIs and stored V1 bytes.
- Run canonical metadata edge-case coverage at its shared owner; retain a
  smaller Metrics fixture for two-package delegation and stale-adapter refusal.
- Delegate native tool-evidence selection and archiving to the shared collector,
  retaining local diagnostics, formatter logs, outer Git custody and uploads.
- Reuse shared fixture cleanup with physically anchored scratch paths, preserving
  failure status, diagnostic logs and intentional successful evidence retention.
- Select published Host inspector 0.17.10, containing the checked permission
  conversion that repairs macOS tool compilation. Library dependencies and
  stored V1 bytes are unchanged
  ([#78](https://github.com/dragginzgame/ic-metrics/issues/78)).
- Consolidate durable size admission before row reads and carry its payload size
  into encoding, preserving V1 bytes and oversized-histogram error ordering.
- Decode fixed-width fields with one length check; truncation remains a typed
  malformed-record failure.
- Limit native-evidence fixture copies to workflow sources and Make/helper
  inputs, retaining all failure, archive and Git-custody scenarios.

## [0.9.3] - 2026-10-14

### Changed

- Prepare locked application sources explicitly before native CI's offline
  selected-commit release fixtures, including on cold runners.
- Upload a separate small diagnostic archive with complete available logs and
  source/tool/outcome identities; preserve the full native evidence archive.
- Reserve each durable V1 record's complete bounded size before encoding,
  preserving stored bytes and oversized-histogram refusal.
- Reject changed histogram checkpoints using overflow/aggregate equality before
  full equality for four or more bounds. Tiny histograms keep direct equality;
  identity, corruption, sticky flags and bounds admission remain unchanged.

## [0.9.2] - 2026-10-13

### Changed

- Skip encoding and stable-map writes for an identical admitted checkpoint,
  preserving identity/configuration and corruption checks before the no-op.
- Validate histogram bounds directly during restoration instead of constructing
  an empty temporary histogram; preserve constant evaluation and error order.
- Check each histogram bucket's count and overflow flag together during durable
  continuity admission. Existing store signatures and V1 bytes remain unchanged;
  the sealed durable bound carries its supported snapshots’ exact equality.

## [0.9.1] - 2026-10-13

### Changed

- Admit supported metric sizes once at the stable-store boundary, preserving
  oversized-histogram rejection before absent or corrupt rows are inspected.
  Stored V1 bytes and public errors stay unchanged.
- Adopt Shared Tooling 0.11.1 snapshot-owned common catalogs, preserving selected
  tool versions and digests. Host overrides no longer select Rust pins; release
  preflight binds the selected Rust catalog. Lock failures retain native errors
  and statuses ([#70](https://github.com/dragginzgame/ic-metrics/issues/70),
  [Shared #153](https://github.com/dragginzgame/shared-tooling/issues/153)).
- Keep Cargo-tool CI cache keys stable across unrelated literal catalog edits;
  Cargo pins, compiler/native/build identities and opaque catalogs still bind
  cache selection ([Shared #154](https://github.com/dragginzgame/shared-tooling/issues/154)).
- Select published `ic-host-wasm-inspect` 0.17.4 through the managed tool installer
  and remove the private CLI package and its duplicate gates. Structural report
  behavior stays with IC Host; arithmetic/stable graphs no longer include Host.
- Delegate transactional Cargo metadata preparation and selected-commit checks to
  Shared Tooling, retaining Metrics source admission, cache/tool setup and delivery
  policy locally ([Shared #167](https://github.com/dragginzgame/shared-tooling/issues/167)).
- Replace six current-tree evidence distributions with separately named public
  receipts that omit private consumer material. Preserve original archives and
  checksums privately and record the published-history disposition separately
  ([#72](https://github.com/dragginzgame/ic-metrics/issues/72)).

## [0.9.0] - 2026-10-13

### Breaking

- Remove unreachable `MeasurementMeanError::{SaturatedTotal, Projection}` and
  `MeasurementIntervalError::SaturatedTotal`; update matches or construction of
  these variants. Exact sample counts already guarantee exact totals and bounded
  scaled means. Numeric overflow handling and stable V1 bytes remain unchanged;
  no stored-data reset is needed
  ([#69](https://github.com/dragginzgame/ic-metrics/issues/69)).

- Rename actual-overflow flags from saturation names to `*_overflowed`, with
  histogram `bucket_overflowed()` and `overflow_count_overflowed()`. Update
  remaining error cases to `SampleCountOverflow`, `TotalOverflow`, `CountOverflow`
  and `InvalidOverflowFlag`; an exactly reached numeric cap is still exact.
- Keep raw stable codec/kind/continuity dispatch internal to the adapter; use
  `MetricsStore` with the supported `DurableMetric` bound. Stored V1 bytes,
  identity validation and host lifecycle stay unchanged
  ([#71](https://github.com/dragginzgame/ic-metrics/issues/71)).

### Changed

- Qualify the incoming Host 0.17.0 selection for the private Wasm inspector;
  arithmetic and stable dependency boundaries and Rust floors stay unchanged.

## [0.8.4] - 2026-10-13

### Changed

- Keep native/wide mean projection inside the aggregate/interval owner and
  refresh the current handoff after 0.8.3. Current README guidance leaves release
  history with the changelog. Public APIs and stored bytes remain unchanged.
- Qualify the incoming Memory 0.36.1 lock selection for the optional stable store,
  preserving exact collection types, bootstrap ownership and Rust floors.

## [0.8.3] - 2026-10-13

### Changed

- Adopt the incoming Memory 0.36.0 and private inspector Host 0.16.0 selections.
  The stable bootstrap fixture supplies an owned explicit request list; hosts
  still own composition and bootstrap. Exact collection types, V1 snapshot bytes
  and package Rust floors remain unchanged; constructor dependencies are removed
  from the stable graph.
- Decode stable snapshot fields through one checked slice split, preserving
  typed truncation failures and V1 bytes. Current guides identify the scalar
  counter as released and distinguish publication from native qualification.

## [0.8.2] - 2026-10-13

### Added

- Accumulate scalar diagnostic quantities with `MeasurementCounter`: a wide total
  with actual-overflow tracking, validated restoration, batch merging and checked
  totals/differences. Event, item and byte units stay consumer-owned; existing
  observation APIs and stable V1 records remain unchanged
  ([#68](https://github.com/dragginzgame/ic-metrics/issues/68)).

### Changed

- Adopt the incoming Host 0.15.2 selection for the private Wasm inspector and
  Memory 0.35.19 for the optional store, retaining existing package Rust floors
  and the dependency-free arithmetic graph.
- Adopt Shared Tooling 0.9.10: reject non-boolean Cargo offline configuration and
  isolate tool fixtures from consumer compiler settings and commit effects.
  Run explicit `make install-rust-tools` after updating the build policy; prior
  tool sets remain retained
  ([Shared #140](https://github.com/dragginzgame/shared-tooling/issues/140),
  [Shared #143](https://github.com/dragginzgame/shared-tooling/issues/143),
  [Shared #144](https://github.com/dragginzgame/shared-tooling/issues/144)).
- Consolidate current integration and host guidance, preserving historical
  evidence separately. Boundary fixtures use validated public state and retain
  independent checks without duplicate arithmetic tests.
- Histogram quantile reporting uses admitted aggregate count quality instead of
  scanning the same overflow flags again; recording, ranges and typed failures
  remain unchanged.

## [0.8.1] - 2026-10-12

### Fixed

- Reject restored summaries whose exact total cannot include the latest sample
  without exceeding the maximum for another observation. Durable loads and saves
  preserve inconsistent stored bytes and return the existing typed state error
  ([#67](https://github.com/dragginzgame/ic-metrics/issues/67)).

### Changed

- Adopt Shared Tooling 0.9.6: retry transient tool downloads within bounded
  limits and reject malformed Git identities before snapshot/release effects
  ([Shared #138](https://github.com/dragginzgame/shared-tooling/issues/138),
  [Shared #133](https://github.com/dragginzgame/shared-tooling/issues/133),
  [Shared #139](https://github.com/dragginzgame/shared-tooling/issues/139)).
- Reject newline-suffixed PR release identities before shell extraction or saved
  state writes through the shared adapter; Metrics retains direct-only releases.

### Testing

- Exercise the real download retry classifier with a local HTTP fixture, covering
  transient recovery, terminal refusals and checksum rejection.

## [0.8.0] - 2026-10-12

### Breaking

- Remove `record_sample`, raw-field `checked_mean` and the raw-only
  `MeasurementMeanError::TotalWithoutSamples` variant. Record with tracked
  aggregates, summaries or histograms, then preserve overflow quality in reports.
  The stable V1 encoding remains unchanged; no library-owned data reset is needed
  ([#66](https://github.com/dragginzgame/ic-metrics/issues/66)).

### Added

- Project fractional averages with aggregate/summary `scaled_mean(scale)`, checking
  actual overflow before scaling; empty and measured zero remain distinct.
  Ratio failures retain a typed cause in `MeasurementMeanError::Projection`
  ([#66](https://github.com/dragginzgame/ic-metrics/issues/66)).

### Changed

- Adopt Shared Tooling 0.9.2: installers share lock and cleanup ownership,
  reject invalid checkout paths before setup, and checksum verification rejects
  NUL bytes before hashing evidence.
- Derive internal Shared Tooling companions from their canonical entrypoints,
  retaining the complete reviewed payload and existing commands.

## [0.7.3] - 2026-10-12

### Changed

- Adopt Shared Tooling 0.9.0, including the Cargo-tool freshness task. Run the read-only
  checker from Shared Tooling; installation and offline admission remain separate.
- Read workspace LOC counts as JSON with `bash scripts/dev/cloc.sh --json`;
  the existing human-readable report remains unchanged.
- Qualify Host 0.14.8 for the private Wasm inspector and Memory 0.35.17 for the
  optional store; consumed library sources and Rust floors remain unchanged.

### Fixed

- Share snapshot syntax admission between refresh and verification, rejecting
  NUL bytes before parsing and emitting no records for malformed input
  ([Shared #133](https://github.com/dragginzgame/shared-tooling/issues/133)).
- Use the selected Rust tool catalog for formatting admission and refuse
  redirected build-observation files before writing diagnostics
  ([Shared #135](https://github.com/dragginzgame/shared-tooling/issues/135),
  [Shared #136](https://github.com/dragginzgame/shared-tooling/issues/136)).
- Make shared snapshot payload replacement atomic and include common installers
  in minimal Make exports, preserving retry after an interrupted copy
  ([Shared #131](https://github.com/dragginzgame/shared-tooling/issues/131)).

## [0.7.2] - 2026-10-12

### Changed

- Adopt Shared Tooling 0.8.1's entrypoint/companion snapshot interface and
  automatic retirement of unchanged obsolete owned files,
  retaining the complete existing selection. Refresh contributor Rust tools
  with `make install-rust-tools`, then `make rust-tools-check`, to select
  cargo-sort-derives 0.14.1 and preserve literal macro paths. Formatter builds
  require Rust 1.88 or newer; library floors remain unchanged
  ([#65](https://github.com/dragginzgame/ic-metrics/issues/65),
  [Shared #113](https://github.com/dragginzgame/shared-tooling/issues/113),
  [Shared #131](https://github.com/dragginzgame/shared-tooling/issues/131)).
- Reject malformed snapshot fields consistently and retain both build-identity
  observations when Rust-tool installation detects drift, preserving the previous
  selection ([Shared #133](https://github.com/dragginzgame/shared-tooling/issues/133),
  [Shared #134](https://github.com/dragginzgame/shared-tooling/issues/134)).
- Qualify the incoming Host 0.14.4 inspector and IC Memory 0.35.14 adapter graph;
  consumed library sources, stored layout and Rust floors remain unchanged.

### Testing

- Add replayable IC upgrade, query-discard, trap-rollback and reset qualification
  for the optional one-map store, with matched volatile/checkpoint-cadence
  instruction, cycle and raw Wasm evidence
  ([#64](https://github.com/dragginzgame/ic-metrics/issues/64)).

## [0.7.1] - 2026-10-12

### Changed

- Adopt Shared Tooling 0.6.5's common Make entrypoint for setup, formatting,
  hooks, snapshot checks and releases. Preserve the existing product gates,
  compiler floors and publication/metadata adapters
  ([#61](https://github.com/dragginzgame/ic-metrics/issues/61)).
- Stop release validation between gates if its prepared Cargo manifest or lock
  changes, retaining the canonical input checkpoints and failure evidence.
- Qualify the incoming IC Memory 0.35.13 lock selection for the optional adapter;
  its library code, durable format and Rust floor remain unchanged.

### Fixed

- Update adoption examples and documentation to the published 0.7 arithmetic
  and optional durable-store contracts.

## [0.7.0] - 2026-10-12

### Breaking

- Accumulate observation totals and project integer means as `u128`, retaining
  `u64` individual samples and counts. Every exact counted batch now fits its
  total; actual overflow remains explicit and never wraps. Update raw-field
  totals, report/codec boundaries and public re-exports together, using checked
  conversions when a narrower report is required
  ([#63](https://github.com/dragginzgame/ic-metrics/issues/63)).


### Added

- Opt into durable metrics with the separate `ic-metrics-stable` package: one
  host-owned stable map holds namespaced aggregates, summaries and histograms
  across upgrades. Validate stored identities, bounds and numeric state; preserve
  wide totals and overflow flags, and require explicit reset/retirement. The
  adapter requires Rust 1.88; the arithmetic package stays dependency-free and
  `no_std` on Rust 1.85. Publication now selects both public packages.

## [0.6.6] - 2026-10-11

### Fixed

- Focus the README on current measurement APIs, setup and consumer adoption,
  referencing the shared setup, hook and release contracts instead of repeating
  them. Update the registry example to the current arithmetic contract
  ([#62](https://github.com/dragginzgame/ic-metrics/issues/62)).

## [0.6.5] - 2026-10-11

### Changed

- Use IC Host 0.14 for the private Wasm inspector, retaining its existing bounded
  inspection and report contracts. The published arithmetic library remains
  dependency-free; [the dependency review](docs/evidence/host-dependencies-0140.md)
  covers the unchanged consumed APIs and Rust floors.

### Fixed

- Adopt Shared Tooling 0.6.3 so failed Cargo setup reports its original failure
  without activating an incomplete common tool set or disturbing another
  installer's lock. Earlier selections and failed build evidence remain retained.
  Rerun `make install-tools`, then `make tools-check`
  ([#61](https://github.com/dragginzgame/ic-metrics/issues/61),
  [Shared #120](https://github.com/dragginzgame/shared-tooling/issues/120)).
- Handle padded build counts in Cargo setup regression checks, including macOS
  output ([Shared #124](https://github.com/dragginzgame/shared-tooling/issues/124)).
- Restart stale direct-release preparation from clean committed metadata, retaining
  the old plan and running fresh validation. A committed workspace at 0.6.4 now
  selects 0.6.5 despite an older 0.6.4 preparation attempt
  ([Shared #126](https://github.com/dragginzgame/shared-tooling/issues/126)).

## [0.6.4] - 2026-10-11

### Changed

- Adopt Shared Tooling 0.6.0 to share Cargo tools across checkouts using exact
  compiler, native-environment and packaged-lock identities. Rerun explicit
  `make install-tools`, then `make tools-check`; `.tools/rust/common/bin` remains
  the shell path. Tool builds use the shared standard environment while application
  settings remain local. Earlier installations and build evidence are retained;
  the published arithmetic contract is unchanged
  ([#61](https://github.com/dragginzgame/ic-metrics/issues/61)).

### Fixed

- Retain safe local CI failure evidence and incomplete-collection diagnostics
  when shared-store admission fails, including referenced Cargo builds during
  successful collection
  ([#61](https://github.com/dragginzgame/ic-metrics/issues/61),
  [Shared #121](https://github.com/dragginzgame/shared-tooling/issues/121)).

## [0.6.3] - 2026-10-11

### Changed

- Adopt Shared Tooling 0.5.0 to reuse verified host/IC bundles across checkouts
  and admit the complete common Rust tool set before activation. Contributors
  must rerun `make install-tools`, then `make tools-check`, and select
  `.tools/rust/common/bin` in their shell. Previous installations and failed
  evidence are preserved; the published library contract is unchanged
  ([#60](https://github.com/dragginzgame/ic-metrics/issues/60),
  [Shared #118](https://github.com/dragginzgame/shared-tooling/issues/118),
  [Shared #120](https://github.com/dragginzgame/shared-tooling/issues/120)).

### Testing

- Verify that CI failure artifacts retain referenced shared tool payloads while
  excluding unrelated stored bundles
  ([#60](https://github.com/dragginzgame/ic-metrics/issues/60)).

## [0.6.2] - 2026-10-11

### Changed

- Reduce common histogram quantile work with checked narrow-product arithmetic,
  retaining exact wide arithmetic for larger products and unchanged range/error
  semantics. The measured fast path adds 89 raw Wasm bytes; see
  [the IC comparison](docs/evidence/quantile-cost-062.md)
  ([#59](https://github.com/dragginzgame/ic-metrics/issues/59)).

### Testing

- Retain a reproducible IC instruction, cycle and raw Wasm comparison of
  recording, prepared-batch merging and histogram queries, including exact-cap,
  overflow and atomic merge-rejection checks. See
  [the source-bound observations](docs/evidence/arithmetic-cost-061.md).

## [0.6.1] - 2026-10-11

### Fixed

- Adopt Shared Tooling 0.3.12 so formatting and release checks preserve relative
  or symlinked temporary-directory selections, Rust tool setup consistently uses
  the selected checkout, and retained validation summaries include the same
  diagnostics as live output
  ([#58](https://github.com/dragginzgame/ic-metrics/issues/58),
  [Shared #116](https://github.com/dragginzgame/shared-tooling/issues/116),
  [Shared #112](https://github.com/dragginzgame/shared-tooling/issues/112),
  [Shared #111](https://github.com/dragginzgame/shared-tooling/issues/111),
  [Shared #101](https://github.com/dragginzgame/shared-tooling/issues/101),
  [Shared #110](https://github.com/dragginzgame/shared-tooling/issues/110)).

## [0.6.0] - 2026-10-11

### Breaking

- Tracked summaries and histogram queries distinguish actual overflow from an
  exactly reached `u64::MAX`. Replace histogram `summary()` with `aggregate()`;
  latest-observation tracking stays with ordered summaries or consumer code.
  [#57](https://github.com/dragginzgame/ic-metrics/issues/57).

### Added

- Merge count/total/maximum aggregates and histograms with matching bounds,
  without claiming observation ordering. Check count/total intervals between
  snapshots after establishing common identity, units and append-only continuity.

### Changed

- Use IC Host 0.12.9 for the private Wasm inspector; reports, bounded input reads
  and the arithmetic dependency graph remain unchanged.

## [0.5.6] - 2026-10-10

### Fixed

- Refuse incomplete release preparation and selected-commit metadata checks on
  Bash 3.2 even when an aborted command enters cleanup with a success status.
  Missing release inputs restore original metadata or retain the selected commit's
  evidence without reporting success
  ([#56](https://github.com/dragginzgame/ic-metrics/issues/56)).

### Changed

- Use IC Host 0.12.8 for the private Wasm inspector; reports, bounded input reads
  and the arithmetic dependency graph remain unchanged.

## [0.5.5] - 2026-10-10

### Fixed

- Reject failed release metadata, fixture and native-host assertions explicitly
  on Bash 3.2, stopping before preparation or false success and retaining evidence
  ([#55](https://github.com/dragginzgame/ic-metrics/issues/55),
  [Shared #107](https://github.com/dragginzgame/shared-tooling/issues/107)).
- Stop pre-commit formatting when Git cannot confirm the index tree, preserving
  failed observations even if they print the expected tree ID. Formatting
  adoption checks also require completed execution before reporting success
  ([#54](https://github.com/dragginzgame/ic-metrics/issues/54),
  [Shared #106](https://github.com/dragginzgame/shared-tooling/issues/106),
  [Shared #103](https://github.com/dragginzgame/shared-tooling/issues/103)).

### Changed

- Adopt Shared Tooling 0.3.7 and Binaryen 133 for the common IC toolset. Run
  `make install-ic-tools` to prepare the new selection; previous bundles remain
  retained. Arithmetic APIs and frozen measurements are unchanged
  ([#54](https://github.com/dragginzgame/ic-metrics/issues/54),
  [Shared #102](https://github.com/dragginzgame/shared-tooling/issues/102)).
- Use IC Host 0.12.6 for the private Wasm inspector; reports, input reads and the
  arithmetic dependency graph remain unchanged.
- Keep only the newest CI run per workflow and branch or PR, cancelling older
  queued and running checks while retaining the existing host matrix and gates
  ([Shared #108](https://github.com/dragginzgame/shared-tooling/issues/108)).

### Added

- Select consumer Cargo executables from an explicit lockfile through the shared
  installer, with strict registry admission and selection-change refusal before
  activation; offline checks use the same selection without resolving a graph
  ([#54](https://github.com/dragginzgame/ic-metrics/issues/54),
  [Shared #96](https://github.com/dragginzgame/shared-tooling/issues/96)).

## [0.5.4] - 2026-10-10

### Fixed

- Allow native CI up to 60 minutes for cold tool setup and the complete checks,
  avoiding Intel macOS cancellation at the previous 30-minute limit
  ([#52](https://github.com/dragginzgame/ic-metrics/issues/52)).
- Isolate release-admission test logs and summaries from parent validation runs,
  preventing false failures and synthetic results in parent evidence
  ([#53](https://github.com/dragginzgame/ic-metrics/issues/53)).

### Changed

- Use IC Host 0.12.4 for the private Wasm inspector; consumed APIs, reports and
  the arithmetic dependency graph are unchanged.

## [0.5.3] - 2026-10-10

### Fixed

- Reject malformed validation nesting metadata before targets run and require
  completed dispatch before reporting success. Incomplete exits retain evidence,
  including Bash 3.2 unset-variable failures
  ([#51](https://github.com/dragginzgame/ic-metrics/issues/51),
  [Shared #104](https://github.com/dragginzgame/shared-tooling/issues/104)).

## [0.5.2] - 2026-10-10

### Fixed

- Check platform and Rust/Cargo availability before tool installation starts,
  and identify the exact failing host tool without executing unauthenticated
  binaries ([#49](https://github.com/dragginzgame/ic-metrics/issues/49),
  [Shared #101](https://github.com/dragginzgame/shared-tooling/issues/101)).
- Preserve Cargo's job budget through shared formatting and tool commands,
  retaining unsafe Make-mode refusal ([#49](https://github.com/dragginzgame/ic-metrics/issues/49),
  [Shared #99](https://github.com/dragginzgame/shared-tooling/issues/99)).
- Reject incomplete fixture runs before reporting success or deleting evidence,
  including Bash 3.2 unset-variable failures
  ([#50](https://github.com/dragginzgame/ic-metrics/issues/50),
  [Shared #103](https://github.com/dragginzgame/shared-tooling/issues/103)).

### Changed

- Use IC Host 0.12.2 for the private Wasm inspector; consumed APIs, reports and
  the arithmetic dependency graph are unchanged.

## [0.5.1] - 2026-10-10

### Fixed

- Preserve Cargo's shared job budget in parallel build, test, publication and
  release-metadata commands without weakening unsafe Make-mode refusal
  ([#48](https://github.com/dragginzgame/ic-metrics/issues/48)).

### Changed

- Use IC Host 0.12.1 for the private Wasm inspector; consumed APIs, reports and
  the arithmetic dependency graph are unchanged.

## [0.5.0] - 2026-10-10

### Breaking

- Standardize tool setup/checks on all 12 common executables, running host,
  IC and Rust sets in order even under parallel Make. The host installer no
  longer accepts `--with-ripgrep` or `--with-cloc`; remove those flags and run
  `make install-tools`, then `make tools-check`. Matching complete bundles are
  reused and earlier evidence is retained. Arithmetic APIs and consumer data
  are unchanged ([Shared #98](https://github.com/dragginzgame/shared-tooling/issues/98),
  [#47](https://github.com/dragginzgame/ic-metrics/issues/47)).

### Changed

- Use the same ordered common toolset in native CI, retaining setup/check logs,
  failed candidates and source-bound outcomes.
- Use IC Host 0.12.0 for the private Wasm inspector; consumed inspection/read
  APIs, report output and the arithmetic dependency graph are unchanged.

## [0.4.0] - 2026-10-10

### Breaking

- Reject LF/CR characters in supplied or resolved snapshot directory paths,
  preventing verification or refresh of a neighboring checkout. Explicitly rename
  affected operational directories before use; existing evidence is retained
  ([Shared #95](https://github.com/dragginzgame/shared-tooling/issues/95),
  [#45](https://github.com/dragginzgame/ic-metrics/issues/45)).

### Changed

- Update the private Wasm inspector's IC Host dependencies to 0.11.0; the
  consumed inspection/read APIs, report output and arithmetic graph are unchanged.
- Prepare the pinned Rust executable set in admitted release preflight, then
  check it offline before validation. Standalone checks never install tools
  ([Shared #96](https://github.com/dragginzgame/shared-tooling/issues/96),
  [#46](https://github.com/dragginzgame/ic-metrics/issues/46)).

## [0.3.7] - 2026-10-10

### Changed

- Keep `make fmt` and `make fmt-check` output concise, retaining full diagnostics
  and failing status on errors. Native CI archives include retained formatting
  logs ([Shared #92](https://github.com/dragginzgame/shared-tooling/issues/92),
  [#44](https://github.com/dragginzgame/ic-metrics/issues/44)).

### Fixed

- Refuse unsafe Make execution modes even when command-line `MAKEFLAGS` hides
  them, preventing false success and unintended release, formatting or publication
  dispatch ([Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30),
  [#44](https://github.com/dragginzgame/ic-metrics/issues/44)).

## [0.3.6] - 2026-10-10

### Changed

- Record the reviewed Shared Tooling version alongside its snapshot revision,
  with validation of malformed or duplicate version metadata.
- Update the private Wasm inspector's locked IC Host dependencies to 0.10.1;
  arithmetic APIs and report output remain unchanged.

## [0.3.5] - 2026-10-09

### Fixed

- Bind Make admission to the selected Shared Tooling snapshot when a tooling root
  is inherited or overridden, and support recursive Make commands with additional
  arguments while retaining rejection of ordinary direct and inherited unsafe modes
  ([Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30)).

### Changed

- Use IC Host 0.10.0 in the private Wasm inspector;
  arithmetic APIs and report output remain unchanged.

### Testing

- Exercise all four inspector budgets, invalid arguments and closed-pipe output
  through the actual CLI, preserving input bytes and refusal-before-report behavior.

## [0.3.4] - 2026-10-09

### Fixed

- Reject Make modes that hide failed release or formatting commands
  ([Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30)).
- Keep release qualification inside its disposable checkout despite inherited
  tooling-root settings ([Shared #7](https://github.com/dragginzgame/shared-tooling/issues/7)).
- Qualify formatting hooks in checkout paths ending in newlines
  ([Shared #90](https://github.com/dragginzgame/shared-tooling/issues/90)).

## [0.3.3] - 2026-10-09

### Changed

- Use shared release and formatting commands while retaining direct-only delivery,
  locked cache preparation and local validation gates
  ([#44](https://github.com/dragginzgame/ic-metrics/issues/44)).
- Update the private Wasm inspector's locked IC Host dependencies to 0.9.4;
  the arithmetic crate remains dependency-free.

### Fixed

- Preserve literal hook paths and checkout names ending in newlines; failed Git
  observations stop hook setup without changing configuration
  ([Shared Tooling #89](https://github.com/dragginzgame/shared-tooling/issues/89)).

## [0.3.2] - 2026-10-09

### Changed

- Update the private Wasm inspector's locked IC Host dependencies to 0.9.2,
  preserving structural report output and the dependency-free arithmetic crate.

### Testing

- Exercise the Wasm inspector's actual command-line file admission and report
  publication in focused checks and native CI.

## [0.3.1] - 2026-10-09

### Fixed

- Install and verify the final IC tool pin even when the catalog has no trailing
  newline ([Shared Tooling #87](https://github.com/dragginzgame/shared-tooling/issues/87)).
- Publish CI tools to the exact executable path, preserving existing contents
  and failed candidates if a directory appears during setup; replace late
  symlinks without following their targets
  ([Shared Tooling #88](https://github.com/dragginzgame/shared-tooling/issues/88)).

## [0.3.0] - 2026-10-09

### Breaking

- Remove PocketIC from the shared IC tool bundle and transfer its setup/admission
  ownership to IC Testkit. Run `make install-ic-tools` to select the five-tool
  bundle; existing bundles and historical measurement evidence are retained.
  Metrics has no active server caller and adds no Testkit dependency. Arithmetic
  APIs and consumer state are unchanged; no data reset is required
  ([#41](https://github.com/dragginzgame/ic-metrics/issues/41),
  [Shared Tooling #76](https://github.com/dragginzgame/shared-tooling/issues/76)).

### Changed

- Move the private Wasm inspector's shared errors to the executable boundary,
  removing the argument/report module dependency cycle without changing CLI
  diagnostics or report output.

### Fixed

- Keep offline-cache release fixtures independent of the repository's pending
  release notes, so a minor-release draft does not block their CI checks.

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
