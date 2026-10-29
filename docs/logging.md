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
Sequence and timestamp watermarks remain after all rows expire. These are new
library contracts; no old stable format is imported or migrated.

Canic continues to own its current logger, configuration, endpoint authorization,
topic roster, rendering, memory declarations and retention timer. There is no
Canic dependency, Metrics dependency or local Cargo override in Logging.

Before adoption, select the storage boundary using IC Memory/Storage, define
bounded serialization/Wire projections if required, and qualify actual Canic
update/query/trap and same-release restoration behavior. Delete replaced Canic
mechanisms as one coherent adoption; do not leave two authoritative log engines.
An independent native example demonstrates framework independence only, not IC
message rollback, persistence or production application acceptance.
