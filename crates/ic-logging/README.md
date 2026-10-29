# ic-logging

Bounded, caller-owned heap logs without a framework or IC runtime dependency.
The library is `no_std` with `alloc`; it has no dependency on Metrics or any other crate.

```rust
use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
use std::num::NonZeroUsize;

let mut log = Log::new(Limits {
    max_entries: NonZeroUsize::new(100).unwrap(),
    max_message_bytes: 1_024,
    max_label_bytes: 64,
});
log.append(EntryInput {
    created_at_secs: 10,
    level: Level::Info,
    source: "worker",
    topic: Some("delivery"),
    message: "delivery accepted",
}).unwrap();

let page = log.page(Filter::default(), PageRequest {
    before: None,
    max_results: NonZeroUsize::new(10).unwrap(),
    max_scanned: NonZeroUsize::new(100).unwrap(),
});
assert_eq!(page.entries[0].message, "delivery accepted");
assert_eq!(log.next_expiry_secs(5), Some(16));
assert_eq!(log.prune_expired(16, 5, 20).removed, 1);
```

Limits are fixed for the lifetime of a log. Source and topic limits apply
individually; oversized labels refuse before mutation. Message limits apply to
retained UTF-8 bytes, including any truncation suffix. A zero message limit keeps
metadata and an empty message. The count is always positive; a caller disables
logging by not appending or not constructing a log.
Append refusals implement `core::error::Error` and preserve typed label/size/time
context for callers using `?` or their own error wrappers.

Sequence IDs start at zero and never repeat within one log, even after all rows
expire. Timestamps cannot move backwards after retention. Sequence exhaustion
returns a typed error before eviction. This is an in-memory generation only:
creating another log starts a new sequence namespace.

An entry remains retained through `created_at_secs + max_age_secs`; it becomes
due in the next second. Overflowing deadlines return `None` and are never
scheduled early. Pruning removes at most the caller's batch limit. Appending
does not prune by age automatically; callers invoke retention and schedule their
own work using the reported deadline.

Pages scan from newest to oldest, after an optional exclusive sequence cursor.
Positioning uses a binary search; filtering examines at most `max_scanned` rows
and returns at most `max_results` borrowed entries. Follow `next_before` even
when a page contains no matches. Filters should stay the same across pages.
Retention may remove rows between calls; paging is not a frozen snapshot and
`scanned` is not a total matching count. Borrowed rows cannot mutate the log.

`Log::snapshot()` explicitly copies a complete checkpoint, including limits,
oldest-first entries and sequence/time watermarks. `Log::restore()` admits that
checkpoint without replaying entries. It rejects invalid bounds, noncontiguous
identities, regressed timestamps, contradictory watermarks and inconsistent
truncation state. Fully pruned and sequence-exhausted checkpoints retain their
append restrictions. Restoration proves internal consistency, not authenticity,
instance identity or continuity with another checkpoint. Byte decoders must bound
allocation before constructing it; `LogSnapshot` is not a serialized format.
An empty checkpoint cannot retain `u64::MAX` as its last timestamp: a row at that
timestamp can never expire. Nonempty checkpoints at that timestamp remain valid.

```rust
# use ic_logging::{Log, Limits};
# use std::num::NonZeroUsize;
# let log = Log::new(Limits { max_entries: NonZeroUsize::new(10).unwrap(), max_message_bytes: 128, max_label_bytes: 32 });
let checkpoint = log.snapshot();
let restored = Log::restore(checkpoint.clone()).unwrap();
assert_eq!(restored.snapshot(), checkpoint);
```

The library performs no authorization, timer registration, IC calls, serialization
or stable writes. IC Persistence owns the separately selected `ic-logging-stable`
adapter, its durable format and governed Memory/Storage integration. Hosts own
checkpoint cadence, lifecycle, retention scheduling and stable identity; linking
the heap crate selects no persistence. Diagnostic logs must not be treated as
evidence that a paid effect completed.
