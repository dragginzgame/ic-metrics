# Preparing for the 0.18 contract

This is the pending coordinated workspace contract, not a registry-availability
claim. Package metadata remains at the maintainer's current release until the
separately authorized minor-release workflow advances it. Publish selected
packages before consumers resolve the new dependency. No compatibility aliases,
old topic-filter field, or alternate append method are provided.

## Logging caller changes

Every `Limits` construction now supplies `max_text_bytes`, the combined retained
UTF-8 length of source, optional topic and message content. Choose that budget
as application policy. It excludes row metadata, allocator/spare-capacity costs,
transient append buffers and checkpoint copies; it is not a complete heap cap.
Message truncation still uses the individual message ceiling. An individually
oversized row returns `AppendError::TextBudgetExceeded` without evicting rows or
advancing watermarks. Otherwise append removes oldest rows until both count and
text ceilings fit. Appending can remove multiple rows and visit up to the
configured retained count. Hosts select limits suitable for their execution budget.

`append` now returns `AppendReceipt { sequence, truncated, evicted }`. Project
`receipt.sequence` where an application exposes an identity. Choose separately
whether to account for eviction or truncation; neither is a refused observation
or proof that an external effect completed. Exhaustive append-error handling
must include the new refusal. Label/time/sequence error precedence is preserved,
with total-text admission checked last.

Replace optional topic filters with `TopicMatch::Any` or
`TopicMatch::Exact(topic)`. `TopicMatch::Absent` selects only missing topics and
differs from `TopicMatch::Exact("")`. Existing optional-topic endpoints can map
`None` to `Any` and `Some(topic)` to `Exact(topic)` without changing their endpoint
contract. Enabling absence selection in an endpoint is a consumer decision.

`visit_page` accepts a callback returning `ControlFlow<()>` and returns
`PageScan { matched, scanned, next_before }` without allocating a result vector.
An early-breaking callback has consumed its row; continuation starts before it.
An empty filtered scan can still have a cursor. Keep filters fixed while following
the cursor; history may be evicted or pruned between calls. `page` collects from
that same visitor scan. The callback's allocations, encoding and failures remain
with its caller.

`checkpoint()` returns a borrowed `LogCheckpoint`. It exposes fixed limits,
oldest-first borrowed rows, the next sequence and last admitted timestamp,
including empty/exhausted histories. It allocates nothing and does not consume
the engine. `snapshot()` still explicitly clones a complete owned checkpoint;
`into_snapshot()` moves owned rows. `restore()` derives retained-text accounting
and rejects over-budget checkpoints independently. The cached byte count is
never accepted from external state.

## Durable Logging adoption

IC Persistence owns stored bytes, discriminator selection and installed
qualification. The additional limit changes the checkpoint contract. A byte
decoder must still bound allocation before constructing a `LogSnapshot` and
admit it through `Log::restore`.

Identify retained installations and their frozen format before adapter adoption.
Do not reinterpret old bytes as a new layout, infer a missing text budget, reset
logs silently or introduce a parallel compatibility reader. The owning host must
choose an explicit retained-data transition or retirement disposition. Linking
the new heap crate does not make that decision or qualify rollback/upgrade safety.

Owning adoption work is tracked by
[Persistence #141 — Qualify 0.18 checkpoints and borrowed encoding](https://github.com/dragginzgame/ic-persistence/issues/141),
[Canic #715 — Adopt the 0.18 Logging contract](https://github.com/dragginzgame/canic/issues/715)
and [IC Jobs #79 — Adopt 0.18 in job-consumer logging](https://github.com/dragginzgame/ic-jobs/issues/79).
These are integration tasks, not evidence of a released dependency or qualified
consumer. Their checkouts and retained data were not modified by this batch.

## Metrics report additions

Summaries and fixed-bound histograms now implement standard Serde transport and
native IC Wire metadata, alongside aggregates/counters. Existing arithmetic and
aggregate/counter layouts are unchanged. No consumer must replace its current
report merely because these capabilities exist.

A summary carries `aggregate` and optional `latest`. A histogram carries
`upper_bounds`, `bucket_counts`, `overflow`, `bucket_overflowed`,
`overflow_count_overflowed` and `aggregate`. The const bound count fixes array
lengths without dynamic decoding collections, including lengths above 32.
Every decoder invokes canonical numeric admission. Empty/zero state, ordering,
bounds, maximum placement, totals and actual-overflow flags retain their meaning.
Metadata supports browser generation; Rust validation remains authoritative.

Consumers adopting these fields regenerate their report contracts and choose
codec byte/node/depth/allocation limits appropriate to their const bounds.
Labels, units, identity, resets and attribution remain consumer-owned. These
report layouts do not replace IC Persistence's separate durable metric codecs.
