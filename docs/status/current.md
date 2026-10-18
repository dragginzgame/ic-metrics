# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
The optional stable package owns validated V1 snapshots in one governed Storage
map. Consumers own sampling, attribution, units, identities, registries, lifecycle
and endpoints. [The extraction contract](../extraction.md),
[stable guide](../../crates/ic-metrics-stable/README.md) and
[host guide](../hosts.md) own those boundaries and local qualification commands.

## Delivered 0.14.0

The finalized release is `6f4787751b8af242bb8eab42215c9609f51dfaa5`.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/39113568073)
passed Linux x86_64, native macOS arm64/Intel and native/Wasm Rust 1.91.
This identifies delivered source and hosted qualification, not an independent
registry-publication observation.

The release removes floating-point sample statistics and supplies the checked
wide accumulator. [PR #92](https://github.com/dragginzgame/ic-metrics/pull/92)
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
remains open. Its nested-fixture correction is selected source, not a claimed
Shared 0.24.1 release. The delivered Metrics CI above qualifies this consumer;
it does not relabel upstream failed or cancelled runs.

## Prepared 0.14.1

Package versions and the selected dependency graph remain 0.14.0 and unchanged.
The numbered pending changelog records compatible development/CI work only.

[#94 — Production dependency exclusions](https://github.com/dragginzgame/ic-metrics/issues/94)
is implemented locally by `make production-dependencies-check`, included in
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
regressions and fifteen doctests pass. These are focused Linux checks; hosted
native macOS acceptance of this pending selector remains outstanding.

The real production graphs and boundary fixtures pass using both Rust 1.99.1 and
1.91. Receipt logs are under `target/maintenance-0141/`. Earlier fixture layout
failures are retained under `/tmp/metrics-production-graph.bFy7i2` and
`/tmp/metrics-production-graph.NonCHS`; no failed attempt is relabelled as passing.
No full local CI/MSRV gate, release or publication is claimed for this batch.

## Downstream and upstream follow-up

- [Testkit PR #125](https://github.com/dragginzgame/ic-testkit/pull/125) remains open
  at `ab8690f52d5a489f5969dffc7c5724f1e0b5d6ed`. It owns private floating-point
  reporting and removes that reporter's direct Metrics dependency. Its controlled
  Metrics 0.14 variant passes focused tests and compiler checks; the normal dirty
  checkout still needs integration with its pending Platform migration.
- [Canic PR #599](https://github.com/dragginzgame/canic/pull/599) remains open at
  `67e199faec7fbb2798e97e25969d0cfb367097ba`. It carries wide/quality-aware
  public/protected performance projections and separate scalar timer diagnostics.
  Protected client migration and owning runtime/artifact qualification remain
  Canic responsibilities. Its source-qualified checks do not qualify a deployment.
- [#82 — Published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82)
  owns replacing the local write observer after the canonical package is published
  and its trait, clone/reset and overflow contracts are qualified. Keep the local
  observer until then; do not revive the alternative Memory observation engine.
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
