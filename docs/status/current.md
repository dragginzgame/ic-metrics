# Current handoff — 2026-10-29

Source base is `06911b9ef7c3c8630602e52c05427b19725322bd` (workspace 0.17.1).
The maintainer selected a separate stable Logging option, following Metrics'
checkpoint model. Pending 0.17.2 notes describe compatible checkpoint APIs;
package versions, refs, registry publication and the Metrics graph are unchanged.
Core changes are local working-tree edits. Shared Tooling remains reviewed 0.27.4,
revision `83f87cca71a420a61e69b6bdd018be27d4455daf`, with unchanged payloads.

## Logging checkpoint contract

Logging stays dependency-free `no_std` + `alloc`, independent of Metrics. It owns
bounded append admission, UTF-8 truncation, explicit age retention, scan-bounded
cursor pages and now canonical checkpoint restoration. Hosts retain clocks,
identity, lifecycle, authorization and retention/checkpoint scheduling.

`Log::snapshot()` copies oldest-first rows, fixed limits, next sequence and last
admitted time. `Log::restore()` validates count/text bounds, contiguous sequence
order, nondecreasing timestamps, tail watermarks and truncated-message consistency.
An empty retained log preserves prior time and sequence/exhaustion. Restoration
proves internal consistency, never authenticity or global continuity. Decoders
must bound allocation before constructing a passive `LogSnapshot`.

This is not a persisted format or a storage dependency. The
[Logging guide](../../crates/ic-logging/README.md) and
[ownership boundary](../logging.md) are canonical. Canic adoption remains separate;
no Canic or Jobs checkout is modified by this stable-option batch. The earlier
[Jobs contribution](https://github.com/dragginzgame/ic-jobs/pull/77) stays heap-only.

## Persistence adapter handoff

IC Persistence owns separately selected `ic-logging-stable`, its bounded V1 codec,
checked Memory/Storage map, corruption/continuity admission and qualification.
The maintainer selected
[#138 — Prepare governed stable checkpoints for IC Logging](https://github.com/dragginzgame/ic-persistence/pull/138)
as a separate draft awaiting Logging 0.17.2. Candidate
source is isolated in `/tmp/ic-logging-stable-20261029`; the normal Persistence
checkout's uncommitted scaffold and release-roster work remains untouched.

The candidate loads/saves complete engine checkpoints; it has no second append,
retention or paging implementation. It retains empty-history watermarks, rejects
rewritten/resurrected rows and regressed state, skips writes for identical saves,
and exposes explicit old-identity-checked removal. Hosts choose stable generations
and checkpoint cadence. Publication stays disabled in the adapter.

`/tmp/ic-logging-stable-candidate` qualifies both candidate packages as workspace
members, with published Memory/Storage 0.54.0. Their runtime source trees match
the Persistence base. Only fixture manifests adapt the unpublished engine graph;
no production sibling path dependency or registry override is introduced.
Candidate source passes strict Clippy, seven native storage/codec regressions,
a complete governed-host doctest, the raw-backing compile-fail proof and Rust
1.91 Wasm compilation. This is source-candidate evidence, not a published Logging
0.17.2 graph, installed upgrade/rollback acceptance or IC cost measurement.

## Current validation and next boundary

Core evidence is `/tmp/ic-logging-checkpoints-*.log`: strict Logging
library/test/example Clippy, Rust 1.91 unit tests (16) and doctests (2), Rust 1.91
Wasm compilation, dependency-admission/refusal fixtures and documentation links
pass. The Metrics arithmetic, transport, recorder and lock selections are unchanged;
its earlier evidence remains applicable to those unchanged inputs. No full local
CI/MSRV matrix or native macOS qualification ran.

Persistence candidate evidence is `/tmp/ic-logging-stable-candidate-*.log`. Normal
locked adapter qualification requires release/selection of Logging 0.17.2 and its
root lock update. Existing Persistence release-roster preparation and publication
remain with their owner. A draft does not qualify the default registry graph.

Metrics 0.17 transport is standard Serde/native Wire; the former `wire` feature is
removed and heap recording still requires `recording`. Stable Metrics remains at
IC Persistence. Existing standard-transport receipts remain under
`target/evidence/standard-transport/`; older #99 evidence preserves its opt-in
feature identity in `target/evidence/transport-99/`. Existing consolidation checks
remain at `/tmp/ic-observability-integration.wIEP78/ic-observability`, and the prior
standalone bootstrap at `/tmp/ic-logging-bootstrap.aOgJT4/ic-logging`. Preserve
those original inputs and evidence; no old receipt qualifies the new adapter.
