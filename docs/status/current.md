# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.11.5

The next pending version is 0.11.5: compatible private admission cleanup, with no
public API, stored-format, dependency or Rust-floor change. Quantile admission
avoids redundant result plumbing and arithmetic on rejected count quality;
durable ASCII identifiers share byte validation. The early overflow-bucket guard
remains after its removal proved expensive on malformed large histograms.
[The matched IC experiment](../evidence/admission-cleanup-0115.md) retains both
accepted candidates, the rejected prototype and the invalid-UTF-8 cost trade-off.

Contributor tooling keeps common action installation/PATH mechanics with its
shared producer, while Metrics supplies action outcomes to its actual diagnostic
collector. Real Cargo offline-policy qualification now uses a minimal frozen
graph in [Shared PR #235](https://github.com/dragginzgame/shared-tooling/pull/235),
passing on Bash 5/3.2 with ShellCheck and documentation checks. Metrics retains
release-authority routing, the actual two-package graph and Git/index custody.
The optional inspector wrapper, pin, three Make targets and smoke-only dispatch
are retired; [Host PR #156](https://github.com/dragginzgame/ic-host-tooling/pull/156)
documents direct managed installation/check/run. Both producer contributions are
topic-branch PRs; neither has been merged. No snapshot payload was patched.
The earlier simulated cases from [PR #228](https://github.com/dragginzgame/shared-tooling/pull/228)
were separately incorporated at Shared `5910c9f` and that PR is closed.

Metrics' native-source/evidence and release-tool fixtures pass in an isolated
committed copy, preserving the real index. The changed evidence/admission
fixtures also pass on genuine Bash 3.2.57 on Linux; affected ShellCheck,
documentation links and snapshot verification pass. Shared's common action
fixture passes Bash 5/3.2 at its producer. These substituted/local checks do not
establish new native macOS or hosted Metrics acceptance. Source before-images
and focused logs remain at `/tmp/metrics-tooling-cleanup.EjxscE/`.

Focused histogram/state tests and stable library tests, native/Wasm Clippy and
both package Rust 1.91 floors pass. Full CI and release gates were not run for
this batch; source remains local and package versions remain 0.11.4. Consumer
contracts are unchanged, so this slice requires no downstream source migration.

## Released 0.11.4

Commit `9665613f05f6477fe97ad60562e54185ed875aac` and tag `v0.11.4` identify
the latest finalized release. The official registry lists both packages as
non-yanked with Rust 1.91; stable selects Memory 0.43.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38874976758)
has passed Linux, Apple Silicon and native/Wasm floors; Intel macOS remains in
progress at this review, so complete native acceptance is not yet established.

This release shares common-tool preparation and Make fixture setup, keeps
exhaustive test permutations at Shared Tooling and preserves Metrics release,
corruption and evidence-custody checks. Its
[source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/9665613f05f6477fe97ad60562e54185ed875aac/docs/status/current.md)
retains the original local observations and selected snapshot identities.
Shared PRs [#231](https://github.com/dragginzgame/shared-tooling/pull/231) and
[#232](https://github.com/dragginzgame/shared-tooling/pull/232) now have complete
passing hosted matrices. The separately refreshed [PR #228](https://github.com/dragginzgame/shared-tooling/pull/228)
passes focused Bash 5/3.2 preflight, ShellCheck and documentation checks; its
new branch source needs its own hosted acceptance. No PR was merged.

## Released 0.11.3

Commit `362406df49365ef7894f52ad53a843760517a0b7` and tag `v0.11.3` identify
the latest finalized release. [Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38781538090)
has completed Linux, Intel macOS, Apple Silicon and native/Wasm floor acceptance.
This release adopts explicit shared Rust setup, trims maintenance payload copies
and keeps simulated preflight cases with their producer. Its
[retained preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/362406df49365ef7894f52ad53a843760517a0b7/docs/status/current.md)
owns the original local observations and snapshot identities; they do not qualify
later changes.

## Earlier releases

[Earlier release receipts](https://github.com/dragginzgame/ic-metrics/blob/362406df49365ef7894f52ad53a843760517a0b7/docs/status/current.md#released-0112)
retain the 0.11.2/0.11.1 source identities, publication observations and exact-source
CI results. [Older narratives](history-through-0110.md) keep their original scope.
The [arithmetic convergence review](../evidence/arithmetic-convergence-0112.md)
retains the rejected rank and quotient/remainder prototypes and their matched IC
measurements; those results do not qualify later source.

## Consumer owners

The supplying sample-statistics issue [#85](https://github.com/dragginzgame/ic-metrics/issues/85)
is complete after publication and exact-source native acceptance; Testkit's normal
registry adoption/delivery remains with [Testkit #103](https://github.com/dragginzgame/ic-testkit/issues/103).
Ratio [PR #81](https://github.com/dragginzgame/ic-metrics/pull/81) is closed as
superseded by published code, with its branch retained. Query's independent input
and percentage acceptance is recorded in [#80](https://github.com/dragginzgame/ic-metrics/issues/80).

The test-only memory observer replacement remains with [#82](https://github.com/dragginzgame/ic-metrics/issues/82)
and [Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97); adopt only a
reviewed published registry package with the same stable-memory trait identity.
Rechecked on 2026-10-16: the official `ic-testkit-native` index returns HTTP 404
and the supplying PR remains open at `741e2e8e89cd1442e29dd3a8e1ff235260806bf0`.
The local `WriteCountingMemory` observer remains until the supplying package is
published; no path dependency or replacement observer was introduced.
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned. Existing callers are not opted into persistence by publication.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary projections are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47), while
the original remaining Canic qualification stays with
[#447](https://github.com/dragginzgame/canic/issues/447) and
[#99](https://github.com/dragginzgame/canic/issues/99).
The coordination-only [#10](https://github.com/dragginzgame/ic-metrics/issues/10)
is retired as not planned, preserving its evidence. Canic acceptance remains
unresolved; publication, registry selection and producer CI do not establish it.
