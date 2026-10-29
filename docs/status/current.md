# Current handoff — 2026-10-29

Source base is `72f1e4beaa5dcc31c3ed59033aed71f3a2207726` (workspace 0.17.3).
Shared Tooling remains reviewed 0.27.4, revision
`83f87cca71a420a61e69b6bdd018be27d4455daf`, with unchanged payloads.

## Accepted complexity cleanup

The maintainer authorized and committed all six candidates from the full code
audit, with compatible pending 0.17.4 changelog notes:

- Native CI calls an owned evidence collector. Fixtures directly exercise it
  and check the workflow's outcome mappings and invocation. Sanitized diagnostics,
  full recovery custody and first-error precedence remain distinct contracts.
- Release fixture children own named assertion-failure cases and retained-input
  checksum manifests. The parent verifies those manifests; unexpected command
  failures and nested hook logs retain their separate probes.
- Logging shares one private truncation-suffix policy between construction and
  independent checkpoint validation.
- Histogram restoration separates derived distribution/range facts from final
  admission. It stays allocation-free and const, with the same typed refusals;
  recording, merging and quantile paths are unchanged.
- Both package dependency fixtures share declaration construction while retaining
  independent admission policies.
- Minimum-compiler doctests select the workspace; existing default/native/Wasm
  checks remain in place.

Public APIs, valid checkpoint formats, dependencies, version metadata and package
identities are unchanged. No sibling edits, staging, commit, merge, release or
publication is selected. The maintainer committed the cleanup and separately
updated the lock to Wire 0.7.22; the earlier code evidence below retains its
original Wire 0.7.21 graph identity.

## Release-heading correction

The maintainer's fresh 0.17.4 release refused during preflight because the draft
heading was dated before preparation. No validation, version preparation or saved
0.17.4 release attempt started. The pending correction is `## [0.17.4]`; the
release runner owns date finalization. Package versions remain at 0.17.3.

Latest remote Shared Tooling was checked at 0.27.7,
`11d519c604b1727a2bf6272557a97e770a63b29f`. Its changelog checker and finalizer
are byte-identical to the adopted copies, so an update would retain this refusal.
No snapshot refresh is selected. Evidence in `target/audits/release-heading.md1C2u/`
reproduces the old refusal, admits the corrected draft and proves preparation
recreates the original dated document without changing its notes or history.
Commit the correction before retrying the fresh release; no release was run here.

## Current validation

Evidence is `target/audits/complexity-cleanup.U2Fhfb/`. Formatting, shell syntax,
selected ShellCheck and strict package Clippy pass. Focused tests pass: 27 Metrics
histogram tests (including independent restoration oracles, const evaluation and
error priority), 19 Logging tests and its two doctests, all 17 workspace doctests
on Rust 1.91, and both libraries' all-feature Rust 1.91 Wasm compilation.
Native-evidence, release fixture-retention and dependency-admission fixtures pass.
Their retained inputs are identified by the corresponding logs in that directory.
These substituted effects do not qualify hosted CI or live release behavior.
No full local CI/MSRV matrix, native macOS qualification or IC cost measurement ran.

The affected downstream boundaries were reviewed read-only. Numeric admission
and consumer-owned attribution, identity, persistence and endpoints are unchanged;
each consumer still owns new-source qualification. The
[host guide](../hosts.md) owns maintained commands and evidence limits.

## Logging and separate consumer work

Logging remains dependency-free `no_std` + `alloc`, independent of Metrics.
Its canonical [guide](../../crates/ic-logging/README.md) and
[ownership boundary](../logging.md) cover bounded history, UTF-8 truncation,
explicit retention, cursor scans and validated checkpoints. Hosts own clocks,
identity, lifecycle, authorization, decoding limits and checkpoint cadence.

The earlier fit audit is retained in `target/audits/logging-fit.3ciyEJ/`; released
0.17.3 fixes are qualified in `target/audits/logging-fixes.obEV1R/`, including the
131,072-step independent model. They reject impossible final-time empty states,
reserve truncated payloads once and provide standard append-error traits.
Those receipts retain their own source identities.

Canic adoption is handled separately by the maintainer. The
[Jobs contribution #77](https://github.com/dragginzgame/ic-jobs/pull/77) is merged
and remains heap-only. No consumer checkout was modified by this cleanup.

IC Persistence owns `ic-logging-stable` and all stable-adapter qualification.
[Qualification PR #138](https://github.com/dragginzgame/ic-persistence/pull/138)
uses `/tmp/ic-logging-stable-20261029`; stacked
[publication PR #139](https://github.com/dragginzgame/ic-persistence/pull/139)
uses `/tmp/ic-logging-publication-20261029`. Their last recorded heads are
`1928117a04655cfc3319060379eae682b2f12e8c` and
`ac53f1bfa4f8861d2c94bcc65d2f489e95bae85d`. No new external status was observed
in this batch. The earlier handoff at `6ed52fa:docs/status/current.md` preserves
the full delivery sequence, observed CI status and source-specific receipt roster.
Review current PR state before resuming; merge order, required CI, a clean tagged
release and actual publication remain separate actions.

The installed original-Wasm receipt remains at
`/tmp/ic-logging-stable-20261029/target/qualification/runtime/attempt.pUTvdW/`
(Persistence 0.54.1, Testkit CLI 0.69.11, PocketIC 16.1.0). Publication qualification
retains `/tmp/ic-logging-publication-*.log` and its
`target/package-qualification/attempt.4wr4s9/`. Neither qualifies Canic/Jobs adoption.

Metrics uses standard Serde/native Wire transport; recording remains opt-in and
stable storage stays at IC Persistence. Historical evidence remains under
`target/evidence/standard-transport/` and `target/evidence/transport-99/`, plus
`/tmp/ic-observability-integration.wIEP78/ic-observability` and
`/tmp/ic-logging-bootstrap.aOgJT4/ic-logging`. Preserve original inputs and scopes.
