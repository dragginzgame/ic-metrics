# Logging extraction boundary

The maintainer selected Logging as a separate crate in the renamed
IC Observability workspace on 2026-10-29, consolidating it with Metrics rather
than creating another workspace. The initial non-Canic engine is usable before
replacing Canic's logger.

Inspected Canic HEAD: `b9ed7f298bdaf8c9cceac142edf7e56b15d33208`, with unrelated
working changes preserved. Source references:

- `crates/canic-core/src/storage/stable/log.rs`: bounded entries, strict retention and UTF-8 truncation.
- `crates/canic-core/src/ops/runtime/log.rs`: source/topic/severity filtering and paging.
- `crates/canic-core/src/workflow/runtime/log.rs`: caller-owned time and age deadlines.
- `crates/canic-contracts/src/log/mod.rs`: severity ordering.

The dependency-free `no_std` + `alloc` engine owns retention and paging mechanics. It retains the strict age
boundary and message truncation suffix. Labels are plain bounded strings; Canic
topics and role labels remain application policy. Paging uses explicit scan
bounds and sequence cursors rather than copying the whole retained history.
Sequence and timestamp watermarks remain after all rows expire. Validated
`LogSnapshot` restoration preserves those watermarks and admits bounds, contiguous
sequence order, nondecreasing time and consistent truncated messages. This passive
checkpoint is not a codec, instance identity or authenticity proof. No old stable
format is imported or migrated.

Canic continues to own its current logger, configuration, endpoint authorization,
topic roster, rendering, memory declarations and retention timer. There is no
Canic dependency, Metrics dependency or local Cargo override in Logging.

The maintainer selected a separate stable option on 2026-10-29, following Metrics'
checkpoint model. IC Persistence owns `ic-logging-stable`, its bounded durable
encoding, checked Memory/Storage map integration and reopen qualification. Hosts
explicitly load a log, use this engine's append/prune/page operations and save a
checkpoint at their chosen boundary. Neither package installs a clock, timer,
endpoint, lifecycle or global recorder. The Logging crate stays dependency-free.
The separate Persistence candidate is
[#138 — Qualify stable Logging rollback and upgrade behavior](https://github.com/dragginzgame/ic-persistence/pull/138).
It selects published Logging 0.17.2. Focused native/Wasm checks and an installed
original-Wasm probe pass for query non-persistence, update/upgrade rollback and
reopen with empty-history watermarks. The adapter remains unpublished pending
Persistence review/release. The PR's hosted runtime jobs also pass original/O3/Os/Oz
on Linux and both macOS architectures. These checks do not establish installed
Canic or application acceptance or cost measurements.

The maintainer subsequently selected publication preparation in
[#139 — Enable coordinated publication of IC Logging Stable](https://github.com/dragginzgame/ic-persistence/pull/139),
stacked on #138. It adds the fourth archive/receipt digest, extracted-package
consumer qualification and dependency-ordered publication. It performs no release
or registry upload; the heap Logging package gains no storage dependency.

Before Canic adoption, qualify that storage boundary using IC Memory/Storage, define
bounded serialization/Wire projections if required, and qualify actual Canic
update/query/trap and same-release restoration behavior. Delete replaced Canic
mechanisms as one coherent adoption; do not leave two authoritative log engines.
An independent native example demonstrates framework independence only, not IC
message rollback, persistence or production application acceptance.
