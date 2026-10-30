# Current handoff — 2026-10-30

Source base is release 0.17.7, `358cb16`. The maintainer accepted all proposed
Logging contract additions and summary/histogram transport, plus the archive
wording correction. This batch extends the already accepted dirty dependency/
MSRV tooling work. Pending notes now select 0.18.0 because Logging source and
checkpoint contracts break. Own package versions, manifests, lockfile, compiler
policy and tool pins remain unchanged; release/publication are not authorized.

## Implemented 0.18 contract

Logging adds `Limits::max_text_bytes` for retained source/topic/message payload.
Individually oversized rows refuse before mutation; oldest rows are evicted until
both count and text ceilings fit. `AppendReceipt` returns sequence, truncation
and eviction count. Retention updates cached payload accounting; restoration
independently derives and admits it. Metadata, allocator/spare capacity and
transient copies are excluded from the payload ceiling.

`TopicMatch::{Any, Absent, Exact}` replaces optional topic matching. `visit_page`
uses one bounded scan with `page`, without allocating a result collection.
Callback `Break` consumes its delivered row and returns an older continuation.
`Log::checkpoint()` borrows complete ordered rows, limits and append watermarks
without cloning or consuming history. Existing owned snapshot operations remain
explicit; there are no old-filter or old-append compatibility shims.

Metrics adds standard Serde and native Wire metadata for summaries and const-
bound histograms. Private fixed arrays decode without dynamic collections,
including counts above 32. All decoded shapes pass canonical arithmetic admission.
Existing arithmetic and aggregate/counter layouts are unchanged. These are report
contracts, not replacements for Persistence's durable codecs.

The [migration guide](../migration-018.md), package guides, compiled application
example and logging boundary describe caller changes and source/storage limits.
`package-check` documentation now correctly names both package archives.

## Validation and evidence

Current evidence is `target/audits/hard-cut-018/`:

- Selected strict Logging library/test/example and Metrics library/test Clippy
  pass on the pinned compiler. Formatting and documentation links pass.
- All 28 Logging tests pass on pinned Rust and 1.91, including the independent
  mixed-operation model extended for byte pressure and receipts. Six dedicated
  contract tests cover refusal atomicity, multi-eviction, zero budgets, byte
  accounting after restore/prune, topic presence, borrowed buffers and visitors.
- Eight transport tests pass on both compilers. They cover canonical refusal,
  empty/zero state, total/count overflow, 0/3/37 histogram bounds, array lengths,
  native schema/encoding parity and composed browser metadata generation.
- Two Logging and 15 Metrics doctests pass on Rust 1.91, including the updated
  compiled transport report. Both libraries compile as Wasm at that floor;
  the real allocator-free Metrics Wasm link also passes.
- Initial lint-length and test JSON-intermediate failures are retained separately.
  The JSON test now uses the serializer's wide-integer text path, without passing
  wide totals through a narrower JSON value representation. No numeric behavior
  was weakened to satisfy it.

No full local CI/MSRV matrix, native macOS acceptance, installed canister, IC cost
experiment, release or registry upload ran. Root changes remain uncommitted and
its index is untouched. No sibling source checkout or retained state was changed.

## Consumer and durable adoption

Required arithmetic consumer review covered IcyDB, Canic, IC Timers, IC Backup,
Blob Storage and Toko Miner. Existing arithmetic/report projections need no API
rewrite; new summary/histogram report fields are opt-in. The reviewed Backup
checkout has no current direct Metrics declaration/import; earlier receipts stay
historical. This was source inspection, not compilation or owning qualification.
No private sibling source excerpts or issue bodies are distributed here.

Actual Logging adopters have separate concrete work:

- [Persistence #141 — Qualify 0.18 checkpoints and borrowed encoding](https://github.com/dragginzgame/ic-persistence/issues/141).
- [Canic #715 — Adopt the 0.18 Logging contract](https://github.com/dragginzgame/canic/issues/715).
- [IC Jobs #79 — Adopt 0.18 in job-consumer logging](https://github.com/dragginzgame/ic-jobs/issues/79).

These remain adoption work after an appropriate release is available. Persistence
must identify frozen bytes/installations and choose an explicit retained-data
transition or retirement disposition before any format replacement. No old bytes
are reinterpreted, missing budgets inferred, automatic resets performed or parallel
compatibility reader introduced by this heap-crate change. The normal Persistence
checkout already has unrelated dirty work and remains untouched.

## Earlier accepted work and recovery

The dependency/MSRV batch is still included under pending 0.18 notes. Its focused
receipts are `target/audits/dependency-msrv-20261030/`: real-Cargo transport
placement/feature admission, substituted MSRV workflow failure/artifact-custody
proof, the native caller fixture, real linked-artifact capture and tooling/docs
lint. Those scripts are unchanged by this product batch; those receipts are not a
full qualification of the newly changed Rust graph.

`358cb16:docs/status/current.md` retains previous Shared publication, allocator-
free and Logging model receipt locations, and earlier Logging/stable-adapter
publication history. Shared remains at reviewed `a245bb49312a5ccafbb71532cfa5346741e3ba28`;
no snapshot-owned payload was changed. No root staging, Git/ref mutation, sibling
source edits, own-version change, publication or artifact cleanup was selected.
