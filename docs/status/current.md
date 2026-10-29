# Current handoff — 2026-10-29

Source base is `775a47f` (released workspace 0.17.2).
The maintainer selected a separate stable Logging option, following Metrics'
checkpoint model. Logging 0.17.2 is published with compatible checkpoint APIs;
the Metrics graph is unchanged. Shared Tooling remains reviewed 0.27.4,
revision `83f87cca71a420a61e69b6bdd018be27d4455daf`, with unchanged payloads.

## Pending Logging audit fixes

The maintainer authorized all three audit fixes. Compatible 0.17.3 notes cover
rejecting unreachable empty checkpoints at timestamp `u64::MAX`, reserving the
final truncated message buffer once, and standard `Display`/`core::error::Error`
support for append refusals. Valid terminal rows and fully pruned watermarks at
`u64::MAX - 1` remain admitted. Versions, dependencies and both package identities
are unchanged; no staging, commit, release or publication is selected.

Strict Logging all-target Clippy passes. Rust 1.91 passes 19 unit tests, two
doctests and focused Wasm compilation. The original audit's independent model
still passes 131,072 interleaved steps; its two invalid empty checkpoints now
refuse, truncated message capacities match retained lengths at 32/192/1,024 bytes,
and the standard Error-trait compile probe now succeeds. Current evidence is
`target/audits/logging-fixes.obEV1R/`; the original audit remains separately bound
in `target/audits/logging-fit.3ciyEJ/`. Relevant Jobs, Canic and Persistence callers
were reviewed read-only; no caller signature or valid checkpoint format changes.
The other named Metrics consumers select no Logging dependency and are unaffected.
New-source consumer qualification remains with each owner; earlier installed
receipts keep their published 0.17.2 identity.

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
no Canic or Jobs checkout is modified by this stable-option batch. The
[Jobs contribution](https://github.com/dragginzgame/ic-jobs/pull/77) is merged
and stays heap-only.

## Persistence adapter handoff

IC Persistence owns separately selected `ic-logging-stable`, its bounded V1 codec,
checked Memory/Storage map, corruption/continuity admission and qualification.
The maintainer selected
[#138 — Qualify stable Logging rollback and upgrade behavior](https://github.com/dragginzgame/ic-persistence/pull/138)
as a separate contribution. Source is isolated in
`/tmp/ic-logging-stable-20261029`. The maintainer integrated the adapter and
release roster into Persistence 0.54.1 while this qualification was in progress;
the PR now incorporates that released base. The normal checkout remains untouched.

The adapter loads/saves complete engine checkpoints; it has no second append,
retention or paging implementation. It retains empty-history watermarks, rejects
rewritten/resurrected rows and regressed state, skips writes for identical saves,
and exposes explicit old-identity-checked removal. Hosts choose stable generations
and checkpoint cadence. The released adapter remains unpublished; separate
[publication PR #139](https://github.com/dragginzgame/ic-persistence/pull/139)
prepares its inclusion in archive receipts and publication.

Persistence's root lock now selects published Logging 0.17.2, without a path
patch. Seven native storage/codec tests, two doctests, Rust 1.91 Wasm compilation
and strict adapter/probe/helper/host Clippy pass. The installed original-Wasm
probe passes query non-persistence, trapped update/upgrade rollback, successful
reopen and empty-history watermarks on PocketIC 16.1.0. Evidence remains in
`/tmp/ic-logging-stable-20261029/target/qualification/runtime/attempt.pUTvdW/`.
This repeat uses Persistence 0.54.1 and Testkit CLI 0.69.11, preserving the
released main branch's Platform 0.7.6 and host tooling 0.69.12 selections.
Hosted [CI run 40873315791](https://github.com/dragginzgame/ic-persistence/actions/runs/40873315791)
qualifies the same PR head `1928117a04655cfc3319060379eae682b2f12e8c` on Linux,
Apple Silicon macOS and Intel macOS. All three runtime jobs pass original/O3/Os/Oz
with four successful Logging assertions per host. All three MSRV jobs, tooling
lint, Linux native and Apple Silicon native validation pass; Intel macOS native
validation is still running at the last observation.
This does not qualify Canic/Jobs adoption or IC costs.

## Current validation and next boundary

Core evidence is `/tmp/ic-logging-checkpoints-*.log`: strict Logging
library/test/example Clippy, Rust 1.91 unit tests (16) and doctests (2), Rust 1.91
Wasm compilation, dependency-admission/refusal fixtures and documentation links
pass. The Metrics arithmetic, transport, recorder and lock selections are unchanged;
its earlier evidence remains applicable to those unchanged inputs. No full local
CI/MSRV matrix or native macOS qualification ran.

Persistence published-dependency evidence uses
`/tmp/ic-logging-stable-merged-*.log` for the reconciled 0.54.1 graph. Earlier
`/tmp/ic-logging-stable-registry-*.log`, `/tmp/ic-logging-stable-roster-*.log`,
`/tmp/ic-logging-stable-host-*.log` and `/tmp/ic-logging-stable-installed.log`
retain their earlier graph/tool identities.
Its version projection/recovery includes four workspace members while preserving
the three-package publication roster. Both existing lock identity sets are
preserved; additions support Logging and the probe. The earlier
`/tmp/ic-logging-stable-candidate-*.log` retains its candidate-source identity.
The maintainer selected publication preparation. PR #139 is stacked on #138 from
`/tmp/ic-logging-publication-20261029`, head
`ac53f1bfa4f8861d2c94bcc65d2f489e95bae85d`. It selects one four-package roster,
requires the Logging archive digest and qualifies extracted Logging reopen and
empty-history watermarks. Strict Clippy, 68 helper regressions, actual four-archive
native/Rust 1.91/Wasm qualification, archive refusal and interrupted bootstrap
checks pass; both tracked locks are unchanged. Evidence uses
`/tmp/ic-logging-publication-*.log` and its `target/package-qualification/attempt.4wr4s9/`.
Merge #138 first, then retarget #139 to main. Review, required CI, a clean tagged
release and actual adapter publication remain separate. No local release or merge
is selected here.

Metrics 0.17 transport is standard Serde/native Wire; the former `wire` feature is
removed and heap recording still requires `recording`. Stable Metrics remains at
IC Persistence. Existing standard-transport receipts remain under
`target/evidence/standard-transport/`; older #99 evidence preserves its opt-in
feature identity in `target/evidence/transport-99/`. Existing consolidation checks
remain at `/tmp/ic-observability-integration.wIEP78/ic-observability`, and the prior
standalone bootstrap at `/tmp/ic-logging-bootstrap.aOgJT4/ic-logging`. Preserve
those original inputs and evidence; no old receipt qualifies the new adapter.
