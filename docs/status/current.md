# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
Consumers own sampling, attribution, units, identities, registries, lifecycle and
endpoints. [The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and release gates.
The [stable guide](../../crates/ic-metrics-stable/README.md) owns the compiled
host example and current durable-store API.

## Source and prepared changes

The finalized source is 0.13.4 at
`76cca76c8e591d91c9dbed6b276ac2ef57533335`. This identifies the release commit,
not an independent registry-publication observation. The prepared 0.14.0 hard
cut removes `summarize_samples`, `SampleStatistics` and `SampleStatisticsError`.
[The Testkit contribution](https://github.com/dragginzgame/ic-testkit/pull/125)
moves the implementation and boundary tests into the private development
reporter, retaining count/mean/p50/p95 and original typed error sources. Unused
minimum/maximum projections are removed there. Integrate that contribution
before adopting Metrics 0.14 in Testkit; other sample-API callers must move
those projections to their owning reporters. Reviewed IcyDB, Canic, Timers,
Backup, Blob restoration-probe and Toko Miner callers do not use the removed API;
their integration qualification remains with each owner.

The stable store uses IC Storage's public `adapter::StableBTreeMap` directly.
Retain the existing `MetricsMap` alias for that exact byte key/value type; it
adds no collection implementation or lifecycle policy, so removing it would
create avoidable public API churn. Hosts supply the opened map to
`MetricsStore::new` and can recover it with `into_map`; neither operation
initializes storage or releases its allocation lease. Hosts retain allocation,
bootstrap, fresh-versus-retained selection, write cadence, resets and collection
lifecycle. Drop the store or transferred map before reopening its allocation.
The governed map, public map type identity and Metrics V1 bytes stay unchanged.

[Canic PR #599](https://github.com/dragginzgame/canic/pull/599) owns the public
performance projection and offline timer-comparison correction. It carries source
quality and registration directly without a new Metrics API or dependency upgrade.
Its isolated checks qualify that Canic contribution, not the pending Metrics release.
The remaining protected-report contract belongs to
[Canic #600](https://github.com/dragginzgame/canic/issues/600): separate latest
timer delay from work-start counts and carry measurement width and quality.
Metrics' application guide illustrates exact wide totals using existing APIs;
wire semantics, client updates and release qualification stay with Canic.

The checked wide accumulator from [PR #92](https://github.com/dragginzgame/ic-metrics/pull/92)
is prepared in this working tree. `CheckedMeasurementAggregate` records exact
`u128` observations, count, total and extrema; count/total overflow rejects before
any state change. Existing tracked accumulators and stable V1 records are
unchanged. It has no persistence API or reporting policy. The old PR remains open
until this batch is committed and its delivered source is qualified.

The release-admission fixture now uses the metadata adapter's declared companion
closure instead of its own helper list. The deliberately minimal tool-free
bootstrap fixture, actual two-package metadata checks and custody assertions
remain. Package versions are unchanged. The incoming Memory 0.48.1 and
Storage 0.5.2 lock selections are preserved as supplied; this store cleanup changes no
external package version, integer API or Metrics V1 row. The stable test package
drops its direct stable-structures dependency and imports, using only IC Storage
for collections. Frozen V1 vectors retain all four kind/byte checks; underlying
collection-format qualification belongs to Storage. Memory owns allocation
admission and its backing interfaces. The substrate remains a transitive
dependency of the governed owners.

The stable guide is corrected for already selected Memory 0.48 and Storage 0.5.
Memory 0.48 retires earlier allocation images under its own fresh/reset
requirements. Unchanged Metrics V1 or B-tree bytes do not establish allocator
compatibility; the adapter never automatically resets backing.

Shared Tooling 0.24.0 with its reviewed fixture correction is selected at
committed revision `8e90cbdad8b12c9c2f8cb507d60266b162c0dabf` (115 payloads),
refreshed from a clean checkout of
[Shared PR #276](https://github.com/dragginzgame/shared-tooling/pull/276).
The PR remains unmerged; no Shared 0.24.1 release is claimed.
Both members and all root dependencies are production;
only the stable package's Memory development feature is test-only. Existing
global sorting matches the current and committed-source release checks.
Common Rust setup now admits only the two existing pinned formatters; Metrics
has no Candid extractor caller. Diagnostic archive verification follows the
shared bare-digest sidecar contract. The native fixture keeps its own step
outcome projection without the retired shared executor.

The initial 0.24.0 adoption qualified locked production graphs and library builds
on native Linux and Wasm with defaults: the core is dependency-free, and the
stable graph excludes Host, Testkit and Memory's `test-support` feature. This repository has
no deployment command. The missing transitive library CI guard is
[#94](https://github.com/dragginzgame/ic-metrics/issues/94); role comments and pin
checks are not that enforcement. See the [host guide](../hosts.md#dependency-roles-and-production-graphs).

The delivered 0.24.0 preparer rejected this consumer's nested evidence fixtures
with `roots overlap`. The selected correction admits the full companion closure
before any copy and rejects outputs that would overwrite selected source inputs.
Plain `make release-tools-check` and the configured CI-style nested scratch
selection now pass under `target/evidence/native-ci`, including child/assertion failures,
hook diagnostics and current/committed-source metadata checks. The original
failed-release logs and fixture remain untouched. Snapshot integrity and the
upstream focused nested/collision tests pass; receipts are under
`target/fixture-overlap-fix/`. The upstream PR's full hosted matrix still has a
separate retention-fixture failure; this focused consumer repair does not claim
that matrix or a full Metrics CI/MSRV pass.

The initial 0.24.0 adoption passed snapshot/pin/tool admission, formatting with
preserved role annotations, the real hook sorting fixture, and native/Wasm production
library builds. Release fixtures pass with an explicitly external temporary root,
including current and selected committed-source metadata checks. Native workflow
source/setup/archive and recovery tests pass in an isolated current-source fixture;
action results and Make effects were substituted. The original nested-custody failure
is retained separately. These initial receipts retain their recorded source and
dependency identities; they do not claim full CI/MSRV, hosted native
hosts or deployment qualification. Adoption receipts and incoming before-images
are under `target/shared-tooling-0240/`.

The architectural-sediment review removes the empty dependency-pin exception
left after the IC reader retired and replaces the arithmetic-only hook fixture's
no-dependency selection with the real workspace Metrics/Storage pair. The same
reviewed Shared revision supplies fixture generation; the stable package supplies
the Rust perturbation. Failure evidence retains the generated input and nested
shared checker logs. Current guides describe today's APIs; published migration
instructions remain in the changelog. The
[review](../reports/audits/2026/10/18/architectural-sediment/01/report.md) records
ownership traces, retained integration code and publication limits. This audit
adds no product API, dependency version or stored-format change.

## Qualification and limits

The checked-wide addition passes four focused units, eleven core doctests, strict
core native/all-target and Wasm Clippy, and actual Rust 1.91 native/all-target and
Wasm compilation. Formatting and documentation links pass. These checks qualify
the prepared source only; no full local CI or new hosted/macOS/IC-cost acceptance
is claimed. Review receipts and before-images are under `target/issues-prs-0140/`.

Delivered 0.13.4 at the source above passes [exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/39049781488)
on Linux, native macOS arm64 and Intel, and native/Wasm Rust 1.91. That delivered
source contains the narrow-import adoption, local recovery packaging and common
release-delivery admission. Issues #87, #89 and #90 close against that evidence;
superseded PRs #88 and #91 close without merging. This delivered acceptance does
not qualify the pending 0.14 changes.

The retained `MetricsMap` spelling passes the lease-transfer regression and
all three stable-package doctests, plus strict native/all-target and Wasm Clippy.
Source-bound receipts and task before-images are under `target/metrics-canic-0140/`.

The corrected public-map boundary passes strict stable-package native all-target
and Wasm library Clippy, 21 stable units and three stable-guide/compile-fail
doctests. Map transfer preserves lease custody; all four frozen V1 kinds, byte
and truncation checks, and typed corruption/regression errors remain covered.
Collection opening belongs to Storage rather than a duplicate Metrics constructor.
The fixed-width decoder uses one checked slice operation. Formatting, snapshot
integrity, dependency declarations and documentation links pass. Correction
receipts and starting before-images are under `target/storage-map-correction-0140/`;
the preceding decoder/guide cleanup remains under `target/store-cut-0140/`.
Actual stable-package Rust 1.91 checks pass on native all-targets and the Wasm
library with the selected Memory 0.48.1/Storage 0.5.2 graph.

Earlier arithmetic doctests and release-admission/metadata fixture checks remain
at `target/hardcut-0140/` for their unchanged inputs. They cover catalog override
routing, retained Git state, selected-commit metadata and preparation refusal.
The host guide now links generic mechanics to Shared Tooling and retains only
the local commands, integration proofs and recovery-evidence obligations.

The isolated Testkit contribution passes five moved statistics units, three
report-boundary units, strict development-package all-target Clippy, Rust 1.91
all-target compilation, warning-denied documentation, formatting and local links.
Its only lock change removes the private development package's direct Metrics
edge; the published Testkit library retains integer benchmark arithmetic.
These are source-qualified checks, not native macOS, hosted CI or live benchmark
acceptance. No full local CI/MSRV gate or new IC cost experiment was run.

The architectural review passes workspace-native/Wasm Clippy, 76 unit tests and
13 doctests, actual hook sorting/staging and release/metadata/hook retention
checks. CI evidence checks pass in an isolated current-source checkout that
represents pending deletions without touching the real index; workflow effects
are substituted, and archive custody is exercised locally. Snapshot/pin/format,
ShellCheck and documentation checks pass. Receipts remain under
`target/architectural-sediment-0140/`.

The [frozen upgrade study](../evidence/governed-store-0130.md) retains its exact
Memory 0.45/Storage 0.3.1 identities and IC measurements. It does not qualify
the current Memory 0.48.1/Storage 0.5.2 graph or its allocator-format transition.
Existing evidence archives are unchanged. The
[archive distribution record](../evidence/archive-distribution-072.md) continues
to govern public evidence payloads.

## Owning issues and history

- [#82 — Adopt published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82)
  retains the accepted Testkit owner; the earlier alternative Memory engine must
  not be revived. Testkit PR #97 remains open at
  `741e2e8e89cd1442e29dd3a8e1ff235260806bf0`, and the official package index
  still returns HTTP 404. Keep the local write observer until publication and
  exact trait/overflow/clone/reset qualification; no source override is added.
- [#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83)
  owns first durable-consumer acceptance.
- [Storage #12 — Investigate discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12)
  owns the substrate investigation. The selected governed facade still returns
  old values; dropping them downstream does not remove substrate extraction.

[The changelog](../../CHANGELOG.md) owns released changes and caller actions.
The [0.13.4 source-bound handoff](https://github.com/dragginzgame/ic-metrics/blob/76cca76c8e591d91c9dbed6b276ac2ef57533335/docs/status/current.md)
preserves earlier preparation narratives, evidence locations and qualification
limits. Historical receipts are not relabelled as current checks.
