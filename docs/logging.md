# Logging ownership and consumer boundary

IC Observability owns the independent `ic-logging` heap engine alongside Metrics.
Both packages share workspace release metadata; neither depends on the other.
Logging remains dependency-free `no_std` + `alloc`.

## Heap engine and checkpoints

Logging owns bounded append admission, UTF-8 truncation, explicit age-retention
batches and scan-bounded cursor pages. Callers supply time and choose limits,
labels, authorization, scheduling and instance identity. Paging borrows retained
rows rather than copying the complete history or computing an exact match total.
The [0.18 contract](migration-018.md) adds a combined retained-text budget,
append receipts and explicit topic presence matching. The budget counts text
payload, not all heap costs; count and byte pressure evict oldest rows.
`visit_page` provides the same bounded scan without a result collection.

`Log::checkpoint()` borrows all rows, limits and append watermarks without copying
text or consuming the log. Hosts can encode that immutable view directly within
their own record/allocation budgets. It introduces no serialization dependency.

`Log::snapshot()` copies a complete checkpoint while retaining the original log.
`Log::into_snapshot()` consumes the log and moves its owned text into that same
checkpoint representation. The consuming accessor was introduced in
[PR #100 — Add consuming Logging checkpoint accessor](https://github.com/dragginzgame/ic-observability/pull/100)
and included in release 0.17.5. Consumers must select a published
Logging version containing that API before adopting it in their registry graph.

`Log::restore()` independently admits fixed bounds, contiguous sequence order,
nondecreasing timestamps, watermarks, total text budget and consistent truncated messages. Empty
retained history preserves sequence/time watermarks and permanent exhaustion.
A checkpoint is passive state, not a byte format, authenticity proof or globally
unique instance identity. Decoders must bound allocation before constructing it.
No prior stable format is imported or migrated by the heap engine.

## Durable adapter

IC Persistence owns the independently selected `ic-logging-stable` package,
its bounded IC Wire codec, governed Memory/Storage map, continuity checks and
installed qualification. Hosts load a log, use the heap engine's append/prune/page
operations and save at explicit checkpoint boundaries. Neither package installs
a clock, timer, endpoint, lifecycle hook or global recorder.

The adapter qualification and publication integration are merged:
[PR #138 — Qualify stable Logging rollback and upgrade behavior](https://github.com/dragginzgame/ic-persistence/pull/138)
and [PR #139 — Enable coordinated publication of IC Logging Stable](https://github.com/dragginzgame/ic-persistence/pull/139).
The [adapter guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-logging-stable)
owns its current codec, bounds and dependency requirements. These PRs and workspace
release tags do not by themselves establish registry availability.

Original installed receipts qualify their exact source, graph and tools for
query non-persistence, update/upgrade rollback, reopen and empty-history
watermarks. They do not establish a later consumer's installed acceptance or IC
costs. Consumer lifecycle, decoding, identity, retention and checkpoint cadence
remain independently qualified contracts.

## Framework composition

Canic owns its configuration, topics, rendering, endpoint authorization and
retention timer. A heap-only integration may reset logs on upgrade/reinstall;
stable checkpoint adoption is a separate host choice with governed allocation
and installed qualification. There must be one authoritative log engine.
The [worker example](../crates/ic-logging/examples/worker.rs) demonstrates framework
independence, without qualifying IC rollback or application acceptance.

The [publication guide](../README.md#release-and-package-publication) distinguishes
workspace release from explicit publication of each package. The
[current handoff](status/current.md) records observed release/adoption state and
source-bound qualification, rather than maintaining another version roster here.
