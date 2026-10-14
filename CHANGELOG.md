# Changelog

## [0.9.4]

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
