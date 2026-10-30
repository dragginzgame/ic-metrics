# Current handoff — 2026-10-30

Source base is release 0.17.6, `87759e7`. The incoming checkout was clean. The
maintainer requested shared publication ownership, followed by documentation
corrections, an allocator-free Wasm link proof and mixed Logging model coverage.
Pending notes select compatible 0.17.7; workspace
versions, dependencies, lockfile, compiler policy and tool pins are unchanged.

## Shared publication ownership

[Shared Tooling PR #325](https://github.com/dragginzgame/shared-tooling/pull/325)
implements the opt-in publication Make adapter. Its exact committed source is
`a245bb49312a5ccafbb71532cfa5346741e3ba28`, built on the validation cleanup at
`fe8d71c32cae0f9ca3d46d6bddc8770e90c3b806`. The prerequisite
[PR #324](https://github.com/dragginzgame/shared-tooling/pull/324) has merged;
GitHub retargeted #325 to main. No merge was performed by this task. The feature
PR owns the complete change; no separate issue was necessary.

The contribution is isolated at
`/tmp/shared-tooling-publication-adapter-20261030`, branch
`codex/cargo-publication-adapter`. The normal dirty Shared checkout is untouched.
The canonical exporter adopted that clean committed source here. All 127 payload
hashes/modes are recorded in `.shared-tooling.snapshot`; its display version is
the 0.27.8 source base, with an explicitly reviewed unpublished adapter. The
impact review includes the intervening Rust/native ownership guidance and
preserves the previously adopted validation cleanup.

Shared owns command-line package selection, locked offline Cargo metadata
projection to exact versioned selectors, validation-target dispatch and the
existing retained publication runner. Unique selection evidence lives alongside
attempt evidence under one stable parent lock. There is no automatic retry.
Credentials, registry reconciliation, eligibility and stronger consumer
provenance workflows remain with consumers.

This repository now declares only its eligible Metrics/Logging roster,
`crates-io` registry and `clippy` validation target before the common Make include.
Both packages remain the publication default; explicit `PACKAGE=ic-metrics` or
`PACKAGE=ic-logging` selects one. The normal development PACKAGE default remains
Metrics. Local tests retain the actual roster/override and exact native/Wasm
Clippy gate wiring, while generic selection/upload/status proofs live upstream.

## Validation and evidence

Latest follow-up evidence is `target/audits/contract-proof-20261030/`:

- Package publication docs now link to the canonical two-package flow; Logging
  records the consuming checkpoint accessor as included in release 0.17.5.
- `make allocation-free-check` links a runtime-input Metrics example without
  std or an allocator. Both Rust 1.99.1 and 1.91 pass. Code/export retention keeps
  the arithmetic entrypoint in the Wasm. Enabling `recording` on the same fixture
  fails specifically because no global allocator exists (expected control).
- CI selects the pinned link check; the MSRV adapter uses it instead of its
  default-feature Wasm library check. The actual Make fixture passes the new
  target's admission/jobserver dispatch and updated CI gate order.
- Strict Logging-test and Metrics-example Clippy pass. The independent Logging
  journal model executes 7,344 mixed operations on Rust 1.91, covering retention,
  live cursors, refusals, exhaustion, checkpoints and UTF-8/suffix boundaries.
  Formatting, selected ShellCheck, documentation links and diff checks pass.

Earlier proof for unchanged publication and custody behavior remains under
`target/audits/shared-publication.UqPkz4/`:

- The actual consumer standard-release Make fixture passes with substituted
  final publication effects, including parallel jobserver propagation and both
  Clippy failure boundaries.
- The retention fixture passes full-body success cleanup, child/assertion
  failure recovery and retained-input checks. Its recovery evidence is
  `target/evidence/native-ci/fixture-retention.Hrrv39/`.
- The native source/setup/archive fixture passes with substituted action and
  Make effects; evidence is `target/evidence/native-ci/native-evidence.sSKRQo/`.
- Snapshot integrity and independent comparison to the selected committed
  source pass. Real locked offline metadata admits `ic-metrics@0.17.6` and
  `ic-logging@0.17.6`; selected ShellCheck and documentation links pass.

Producer evidence is the isolated checkout's
`target/qualification/publication-adapter/`: the selection adapter and existing
attempt-runner fixtures, ShellCheck, Perl syntax and links pass. Generic selection,
registry/metadata admission, source drift, locking, statuses and retained no-replay
proof remain producer-owned. The new fixture is registered in the portable suite;
that broad local suite was not run.

Hosted [CI run 41042513972](https://github.com/dragginzgame/shared-tooling/actions/runs/41042513972)
was running at the last observation. No hosted pass is claimed. Production Rust
APIs and behavior are unchanged; no broad CI/MSRV gate, native macOS qualification, real upload or release
ran. The root edits remain uncommitted and its index is untouched.

## Prior work and recovery

The preceding ten complexity reductions and their validation are preserved at
`87759e7:docs/status/current.md`. That handoff also records the separately
authorized Logging 0.17.5 upload from clean release commit
`74839f1072c6ddac980ff6c9de5273fbb68033db`, with archive/registry reconciliation
in `/tmp/ic-observability-publish-0175/target/publication/0.17.5-logging/`.
This task does not repeat or qualify that historical upload against a new graph.

Persistence's checkpoint adoption remains separately tracked by
[draft PR #140](https://github.com/dragginzgame/ic-persistence/pull/140).
Canic's read budgets, timer reconciliation and duplicate limits remain separate
work at #100, #101 and [#712](https://github.com/dragginzgame/canic/issues/712).
Read their current state before resuming. No sibling consumer checkout was
changed. Earlier receipt/source locations remain in the preceding handoffs;
old receipts do not qualify a changed graph. No root staging, commit, own version
change, tag, publication or artifact cleanup was selected by this task.
