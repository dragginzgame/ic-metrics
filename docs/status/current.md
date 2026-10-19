# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
The optional stable package owns validated V1 snapshots in one governed Storage
map. Consumers own sampling, attribution, units, identities, registries, lifecycle
and endpoints. [The extraction contract](../extraction.md),
[stable guide](../../crates/ic-metrics-stable/README.md) and
[host guide](../hosts.md) own those boundaries and local qualification commands.

## Current finalized source — 0.14.6

The checkout is based on finalized release `69e086af4aaa7f07a4b6664b500a5a9c53eceb12`;
both workspace packages are 0.14.6. This local source observation does not assert
registry publication or hosted CI for that release. Shared Tooling adoption
below is included in that source.

## Prepared 0.14.7

The maintainer's incoming manifest/lock selects Memory 0.49.0 and Storage 0.5.7.
The Storage requirement now starts at 0.5.7 to admit the aligned Memory 0.49
governed-handle API. Memory's serde_cbor replacement preserves the current ledger
format; Metrics neither names nor exposes the changed upstream decoder error.
Both libraries retain their public APIs, Metrics V1 bytes and Rust 1.91 floor.

All 22 stable units, three doctests, strict native/Wasm stable Clippy and the
native/Wasm production-graph checks with exclusion fixtures pass locally against
that selected graph. The arithmetic production graph remains dependency-free;
Ciborium is absent from the selected library graph. Logs are
`/tmp/metrics-0147-{clippy,wasm-clippy,stable-tests,graph}.log`.
These focused receipts do not claim full release CI or Rust-floor qualification.
Production admission now requires one Memory, Storage and substrate identity
through Shared's canonical observer, with controlled duplicate-version refusals.
The new mutation matrix exercises all four stored families without changing V1
or the production implementation. Rejected checkpoints preserve retained bytes.

The separate [Memory 0.49 IC comparison](../evidence/memory-0147.md) uses the same
copied product source with before/after graphs and a separately locked host driver.
The candidate canister lock matches every selected product registry row/checksum;
Testkit's host pins do not constrain that graph. Same-graph and cross-graph
upgrades, continuation, lease transfer, query discard, trap rollback and explicit
epochs pass. The durable fixture grows by 85,907 raw bytes; bootstrap instructions
fall slightly and checkpoint instructions rise slightly. Native substitutes are
not used for those cost observations. The prior frozen receipt below is unchanged;
neither experiment supplies application acceptance or a universal write price.
The clean rebuild, independent run and replay from a fresh archive extraction
reproduce all eight Wasms and ten raw result files byte-for-byte. Archive payloads
and distribution checksums pass; the original evidence archives remain unchanged.

## Delivered local qualification — 0.14.6

The 0.14.6 batch adds an independent bounded histogram-restoration oracle and
separate release-editor availability/pin-drift rejection cases. Twelve arithmetic
state tests, strict arithmetic all-target Clippy, the release-admission fixture
and ShellCheck pass. No product arithmetic API or V1 encoding changes.

The incoming lock selection of Storage 0.5.6 with Memory 0.48.2 is preserved.
Four focused native V1/lease/cap/reset tests and the native/Wasm production-graph
checks, including exclusion fixtures, pass against that product lock.
The separate [governed-store IC receipt](../evidence/stable-current-0146.md)
binds copied product source, its own lock, compiler, server and workload.
It checks mixed-kind upgrade retention, query discard, trap rollback, typed
refusals, map lease transfer, explicit epochs and matched checkpoint costs.
Two independent runs and a clean-target rebuild agree byte-for-byte. Testkit's
`thiserror` pin differs from the product graph; the receipt states that limit.
Historical archives remain unchanged. Those focused receipts do not establish
full release CI, Rust-floor gates, consumer qualification or publication.

## Earlier delivered 0.14.4

The finalized release is `19a07804875ff880b1f0f9f0c59d0fd22c49a759`; both workspace
packages are 0.14.4 and both official registry index rows are published, not yanked.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/39142551001)
passes. The release incorporates the Storage 0.5.4 lock selection and prior
qualification handoff; arithmetic and stable V1 contracts remain unchanged.

The preceding 0.14.3 source is `ba0aaf5b22237a92ddbb5a58ac33d22c70b8b929`.
Both of that release's official registry archives match their index checksums
and embed that exact Git identity.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/39138337261)
passed Linux x86_64, native macOS arm64/Intel and native/Wasm Rust 1.91.
The 0.14.2 release corrects Testkit adoption guidance. Released 0.14.3
documentation clarifies exact-cap versus actual-overflow scalar
reports and prevents restoring uncertain forwarded readings as known exact.
All 13 arithmetic doctests, local documentation links and diff checks pass.
This does not change the public API, storage format, dependency graph or Rust floor.

The 0.14.4 lock selects Storage 0.5.4 with Memory 0.48.2.
All 21 stable-adapter tests, the stable library Wasm check and native/Wasm
production-dependency admission (including its exclusion fixtures) pass with
that graph. Logs are `/tmp/metrics-storage054-{tests,wasm,boundaries}.log`.
Those focused local receipts retain their original scope, separate from
released-source CI. The current adoption preserves the lock without further
dependency changes.

The preceding 0.14.0 release removes floating-point sample statistics and supplies
the checked wide accumulator. [PR #92](https://github.com/dragginzgame/ic-metrics/pull/92)
is closed without merging because its checked implementation and test blobs are
identical to those delivered in 0.14.0; its source branch is retained. Existing
tracked arithmetic, stable V1 kinds and Rust 1.91 support remain unchanged.
The release lock selects Memory 0.48.2 and Storage 0.5.3.

Hosts supply Storage's public governed map to `MetricsStore::new`; `into_map`
transfers that same allocation lease. The retained `MetricsMap` alias supplies
only the byte shape. Hosts own allocation/bootstrap, fresh-versus-retained
selection, synchronization, write cadence and reset. Unchanged Metrics V1 bytes
do not establish compatibility with a different Memory allocation format.
Metrics never automatically resets retained backing.

## Delivered Shared Tooling adoption — 0.14.5

Shared Tooling is refreshed from clean reviewed main at
`2a79f5f93383f3d2a8a38d65406c7d52c2f77913`, labelled 0.25.0 (116 payloads).
[Its upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/39227583959)
passes; this identifies the exact reviewed source, not a claim of a finalized
Shared release/tag. The canonical exporter retires both old Perl metadata
renderers and imports the preparation transaction and Cargo graph checker.

Metrics explicitly selects published IC Build 0.18.0's release editor through
`ci/release-tools.env`, with a 1 MiB per-document bound. Shared managed setup/check
owns its source/compiler/executable qualification. Common setup/check invokes
Metrics' local tool targets after the common tools; release preflight admits
source first, then prepares/checks the editor and rechecks both pin files.
Metadata preparation only resolves a prepared absolute path before delegating.
Both libraries retain their dependency selections and Rust 1.91 floor.

Formatting, hooks and selected-source release checks now use grouped ordering.
Shared's graph observer replaces local Cargo tree parsing; Metrics retains its
two-root classification, direct substrate prohibition, dependency-free arithmetic
and native/Wasm Host/Testkit/PocketIC and Memory test-support exclusions.
Tools, formatting, production boundary fixtures, actual two-package metadata and
standard release/publication adapter fixtures pass locally. Logs are under
`/tmp/metrics-shared025-*.log`. Release/hook success and failure-retention cases
and native-evidence fixtures also pass in disposable committed source
`dda85ff587e7e0987b91d7de41381defcb67b75e` at
`/tmp/metrics-shared025-qualification.mkXKKG/repo`. That copy qualifies retired
tracked files without changing the real index or refs. Snapshot/pin/link checks,
source-aware ShellCheck and maintained/package-file symlink reviews pass.
Full local CI/MSRV and native macOS acceptance
are not claimed for this prepared source. No product API or stable byte change
and no library dependency on Build, Platform or Wire is introduced.

## Delivered development and dependency qualification

The 0.14.1 batch changes development/CI policy without changing arithmetic,
stable V1 records, dependency selections or either package's Rust 1.91 floor.

[#94 — Production dependency exclusions](https://github.com/dragginzgame/ic-metrics/issues/94)
is delivered by `make production-dependencies-check`, included in
`make ci` and therefore release verification. Each package is observed separately
for the prepared compiler host and Wasm using locked Cargo normal/build edges
and enabled features. Arithmetic admits no production dependency. Stable excludes
Host/Testkit/PocketIC packages and Memory test-support, while retaining the expected
transitive substrate. Both packages reject direct substrate declarations, including
renamed development dependencies. The two workspace packages have explicit
classification; a new member requires a policy review.

The guard's offline local-package fixtures cover allowed development-only
features/packages, governed substrate use, arithmetic dependencies, renamed and
transitive Host dependencies, Wasm-only dependencies, Testkit build dependencies,
transitive test-support activation, direct development substrate access and a
failed child that emitted plausible output. Cargo remains the graph resolver;
this guard is consumer policy, not a new shared dependency framework. Library
admission does not qualify downstream feature unification or deployment artifacts.

[#93 — Development compiler qualification](https://github.com/dragginzgame/ic-metrics/issues/93)
selects Rust 1.99.1 with the existing Clippy/rustfmt/Wasm roster. Package floors
remain Rust 1.91. Local strict native all-target and Wasm library Clippy pass for
both packages. Four checked-wide units, three stable checkpoint/lease/frozen-V1
regressions and fifteen doctests pass locally. The exact-source hosted run above
also passes the configured native CI suite on all three hosts and the separate
native/Wasm floor gate. Issues #93 and #94 are closed against that delivered source.

The real production graphs and boundary fixtures pass using both Rust 1.99.1 and
1.91. Receipt logs are under `target/maintenance-0141/`. Earlier fixture layout
failures are retained under `/tmp/metrics-production-graph.bFy7i2` and
`/tmp/metrics-production-graph.NonCHS`; no failed attempt is relabelled as passing.
The local receipts remain focused checks; the hosted gate supplies broader
qualification. Publication is a separate observation.

## Downstream and upstream follow-up

- Testkit 0.54.0 at `ff88087d6757121ac92e0dec4705ecaccfd8ebed` integrates the
  private floating-point reporter and selects Metrics 0.14 through its owning
  release path. [PR #125](https://github.com/dragginzgame/ic-testkit/pull/125)
  is closed without merging. Its prepared checked-cohort rewrite was not adopted;
  the reviewed consumer keeps one cohort count and atomic multi-counter admission.
  The earlier contribution's green CI retains its own source identity; it does
  not qualify this release or the separate pending Platform work.
- [Canic PR #599](https://github.com/dragginzgame/canic/pull/599) remains open at
  `be16b9c3e58d426777f90757b925b53d381e0d04`. Canic-owned scalar recorders use
  the selected published Metrics 0.11.7 counter, removing 19 copied saturation
  sites while retaining attribution, keys, lifecycle/reset ownership and
  authoritative financial/policy arithmetic. Wide protected scalars preserve
  exactness through Candid/CLI/JSON; public rows retain actual source/merge
  overflow and forwarded untracked caps remain conservative. The preceding 101
  focused tests and source-bound native/Wasm lint/library-floor receipts retain
  their scope in Canic's handoff.
  Ten governed Linux timer-authority cases now pass with actual built Wasm,
  qualifying bounded sampling/history, authorization, registration and same-source
  restoration. The existing fixture also measures the scalar recorder separately:
  2,851 IC instructions for its first Wasm-store record and 1,482 for a warm record,
  including facade/table work and measurement overhead. It verifies exact
  publication of the two events. Probe/timer strict lint and an actual Rust 1.91
  all-target probe check pass. Counter value storage is 32 bytes on native/Wasm;
  this excludes table padding/allocations and supplies no old-recorder comparison
  or cycle/Wasm-size improvement claim.
  Its latest repair includes the shared validator in release-flow sandboxes,
  admits macOS Binaryen's verified bundle layout and regenerates the embedded
  allocation peer through its canonical producer. All 17 release-flow tests,
  eight installer tests, the build-toolchain warning test, four embedded-root
  units and real-Wasm path/version reproduction pass; selected strict lint and
  final read-only artifact verification also pass. These focused Linux receipts
  do not qualify macOS or the complete PocketIC suite. The preceding hosted
  PocketIC job refused preflight before executing its suites.
  [Fresh hosted CI](https://github.com/dragginzgame/canic/actions/runs/39141120567)
  is pending. [Canic #535](https://github.com/dragginzgame/canic/issues/535#issuecomment-6251298002)
  retains owner review of the storage/cost tradeoff and remaining whole-table
  acceptance. Complete installed-Fleet, held-HTTP and pending Platform/Auth release
  qualification remain Canic responsibilities. The normal dirty integration
  checkout is untouched.
- [#82 — Published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82)
  owns replacing the local write observer after the canonical package is published
  and its trait, clone/reset and overflow contracts are qualified. Keep the local
  observer until then; do not revive the alternative Memory observation engine.
  On 2026-10-18 the official `ic-testkit-native` sparse index still returns HTTP
  404, and [Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97)
  remains open at `741e2e8e89cd1442e29dd3a8e1ff235260806bf0`.
- [#83 — First durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83)
  owns durable-consumer acceptance. Persistence and reset identity stay with hosts.
- [Storage #12 — Discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12)
  owns the substrate investigation. Merely dropping returned old values downstream
  does not eliminate their extraction. No performance gain is claimed.
- [#72 — Review private source in evidence archives](https://github.com/dragginzgame/ic-metrics/issues/72)
  retains evidence-distribution review. Follow the
  [archive distribution record](../evidence/archive-distribution-072.md); original
  evidence and separately identified sanitized receipts must retain their identities.

[The changelog](../../CHANGELOG.md) owns released changes and caller actions.
The [0.14.0 source-bound handoff](https://github.com/dragginzgame/ic-metrics/blob/6f4787751b8af242bb8eab42215c9609f51dfaa5/docs/status/current.md)
retains the earlier preparation narratives, local evidence paths and exact graph
limits. Frozen IC studies retain their original sources and dependency identities;
they do not qualify the current Memory/Storage graph or new compiler.
