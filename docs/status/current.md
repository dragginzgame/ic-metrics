# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
The optional stable package owns validated V1 snapshots in one governed Storage
map. Consumers own sampling, attribution, units, identities, registries, lifecycle
and endpoints. [The extraction contract](../extraction.md),
[stable guide](../../crates/ic-metrics-stable/README.md) and
[host guide](../hosts.md) own those boundaries and local qualification commands.

## Delivered 0.14.1

The finalized release is `d773b0512172c1e93de6d8a696ce5901758fa073`; both workspace
packages are 0.14.1.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/39121309886)
passed Linux x86_64, native macOS arm64/Intel and native/Wasm Rust 1.91.
This identifies delivered source and hosted qualification, not an independent
registry-publication observation.

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

Shared Tooling remains at reviewed revision
`8e90cbdad8b12c9c2f8cb507d60266b162c0dabf`, labelled 0.24.0 with its committed
fixture correction (115 payloads). [Shared PR #276](https://github.com/dragginzgame/shared-tooling/pull/276)
remains open. Its newer head `6faecb79bb2ec8ab6eb64c3b2225deb938600c72` passes
[upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/39121036733)
on Linux and both macOS architectures, but is not this snapshot's identity.
The selected nested-fixture correction is not a claimed Shared 0.24.1 release.
Neither run relabels earlier failed or cancelled attempts.

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
  `b3a0500aa7823110fa1eb548b3f2bea0a7116df0`. Alongside typed performance and
  producer-owned operation projections, Canic-owned diagnostic scalar recorders
  now use the selected published Metrics 0.11.7 counter. This removes 19 copied
  saturation sites while retaining attribution, keys, reset/lifecycle ownership
  and authoritative financial/policy arithmetic. Protected wide scalars carry
  explicit exactness through Candid, CLI and JSON; public process/operation rows
  preserve actual source/merge overflow. Forwarded untracked caps stay conservative.
  The scalar batch passes 101 focused tests, strict selected native/Wasm and
  governed-caller lint, and actual Rust 1.91 library checks. An extra 1.91 test-target
  attempt fails at existing development-test macros authored for Rust 1.99; it
  is retained separately from library-floor acceptance. Six IC Wasm cases pass
  through an aliased temporary parent after correcting the latest macOS fixture
  failure, alongside the typed Testkit membership assertion repair.
  [Fresh hosted CI](https://github.com/dragginzgame/canic/actions/runs/39135238669)
  is running; no PocketIC/deployment acceptance is claimed. Counter values occupy
  32 bytes on native/Wasm at Rust 1.91, excluding table padding/allocations.
  [Canic #535](https://github.com/dragginzgame/canic/issues/535#issuecomment-6250963919)
  remains open for governed IC heap/recording-cost acceptance. Protected client,
  artifact/runtime qualification and integration with pending Platform work stay
  with Canic. The normal dirty integration checkout is untouched; its complete
  0.112 batch retains its owning Auth/release blockers.
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
