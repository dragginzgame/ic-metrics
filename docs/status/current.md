# Current handoff — 2026-10-30

Source base is release 0.17.5, `74839f1`. The maintainer authorized all ten
complexity reductions from the fresh review. Compatible pending notes select
0.17.6; package versions, dependency selections and both crate identities remain
unchanged. The incoming checkout was clean.

## Accepted implementation

The local batch completes eight reductions:

- Native-evidence scenarios select fault inputs and expected boundary statuses
  together; diagnostic-checksum and recovery-input assertions are shared locally.
- Release admission has one entrypoint and private cache/tool, source/index and
  validation-adapter scenario groups, with shared metadata/index custody checks.
- Publication fixtures share an independent expected lint-command prefix.
- Native input capture is an owned script called directly by workflow and fixture;
  unusual filenames and source hash admission retain their real execution proof.
- Cargo, Bash and Make retention-fault writers have explicit local owners.
- Logging independently validates a borrowed checkpoint before constructing its
  engine; histogram queries share private constant-evaluated range construction.

Public APIs, error priority, canonical admission, checkpoint formats and numeric
semantics are unchanged. No platform clocks, endpoints, storage dependencies,
performance claims or new product modes are introduced.

## Shared Tooling contribution and adoption

The two upstream reductions are in
[PR #324 — Converge validation checkpoints and Cargo workspace admission](https://github.com/dragginzgame/shared-tooling/pull/324),
head `045d7bea69dfb09af721de0ba89a32d6b21a2429`, based on remote main
`11d519c604b1727a2bf6272557a97e770a63b29f` (0.27.7).
The contribution uses `/tmp/shared-tooling-complexity-ten-20261030`; the dirty
normal Shared checkout is untouched. No upstream version bump or merge ran.

Input checkpointing is a declared Perl companion captured with the runner before
any gate. The source-replacement regression proves later checks use captured
bytes. Coordinated Cargo workspace admission has one private flow, independently
called at preparation, post-write and selected-source boundaries. The backed-up
original lock remains the preparation authority; Cargo JSON, stderr and child/
logger statuses remain separate, with the first Cargo failure preserved.

The canonical exporter adopted that exact clean committed PR head here, rather
than a moving branch or edited vendored payload. `.shared-tooling.snapshot` owns
all 123 payload hashes/modes. Its display version remains the 0.27.7 source base;
this is an explicitly reviewed unmerged cleanup revision, not released 0.27.8.
The impact review includes the intervening observability governance and task
clarifications. Catalogs, compiler policy and executable pins are unchanged;
no maintenance schedule or fleet sweep was activated.

## Validation and evidence

Root evidence is `target/audits/complexity-ten.O8GTvB/`. Formatting and strict
Logging/Metrics Clippy pass, followed by 21 Logging tests, two Logging doctests,
27 histogram tests and both libraries' Rust 1.91 Wasm compilation. The native
workflow and release-retention fixtures, selected ShellCheck, actionlint, local documentation links and
snapshot integrity/source comparison pass. Earlier failed lint/preview logs are
retained separately from the corrected checks.

Upstream evidence is the isolated checkout's `target/qualification/complexity-ten/`.
The validation runner, Cargo release metadata and Shared release-metadata fixtures
pass, including source replacement, nested drift, rollback, original-lock custody
and child/logger error precedence. Selected ShellCheck, Perl syntax and links pass.
No broad local CI/MSRV matrix, native macOS qualification, installed IC runtime,
release or registry upload ran. Hosted PR qualification remains independently
observable; an open PR is not a merge or release.
Hosted [CI run 41037893369](https://github.com/dragginzgame/shared-tooling/actions/runs/41037893369)
was still running at the last observation; no hosted pass is claimed.

## Prior consumer work and recovery

Persistence's consuming-checkpoint adoption remains separately tracked by
[draft PR #140](https://github.com/dragginzgame/ic-persistence/pull/140), with its
source and candidate evidence at `/tmp/ic-persistence-consuming-checkpoint-20261030`.
Read current PR and registry state before resuming; this batch does not repeat
its prior publication observation or qualify a released dependency. Canic's
read budgets, timer reconciliation and duplicate limits remain at #100, #101
and [#712](https://github.com/dragginzgame/canic/issues/712). No sibling consumer
checkout was changed by this batch.

The preceding handoff at `74839f1:docs/status/current.md` preserves original
Logging, stable-adapter, transport and installed-proof receipt locations and
source identities. User-owned build cleanup may remove local artifacts; old
receipts never qualify the current graph. The complexity batch selected no root
staging, commit, own version change, tag, release, publication or artifact cleanup.

## Publication follow-up — 2026-10-30

The maintainer separately authorized ensuring both packages are published.
Metrics 0.17.5 was already present; Logging 0.17.5 was uploaded from clean release
commit `74839f1072c6ddac980ff6c9de5273fbb68033db` in
`/tmp/ic-observability-publish-0175`. Native/Wasm Clippy and Cargo package
verification passed. Both registry entries are present and not yanked; Logging's
registry checksum matches the uploaded archive, whose VCS metadata names that
release commit. The isolated checkout retains its log under
`target/publication/0.17.5-logging/`. The first root attempt refused dirty source
before upload when concurrent work appeared; those edits were preserved.

Local `publish` and `publish-check` now select both packages by default and retain
explicit `PACKAGE=ic-metrics` or `PACKAGE=ic-logging` selection. The actual Make
fixture passes default/explicit dispatch and upload/native/Wasm failure cases;
ShellCheck, shell syntax, documentation links and diff checks pass. Root evidence
is `target/publication/0.17.5-logging/`. These tooling edits join pending 0.17.6
notes without changing package versions or committing concurrent work.
