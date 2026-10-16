# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Pending 0.11.4

The reviewed 114-file Shared Tooling 0.15.2 candidate is
`c550bc7b8bcff48723402c7dfcb94e73bd440284`
([Shared PR #231](https://github.com/dragginzgame/shared-tooling/pull/231), stacked on
[#229](https://github.com/dragginzgame/shared-tooling/pull/229)). It ports
[PR #227](https://github.com/dragginzgame/shared-tooling/pull/227)'s unchanged common-tool
action and Make-fixture bootstrap onto Metrics' existing reviewed baseline. The
supplying PR's older complete tree lacks evidence helpers Metrics still selects;
this scoped branch preserves them and the optional maintenance selection contract.
No baseline-rule, compiler, Cargo dependency or library API change is included.

Native CI delegates common installation, checks and PATH publication to the
selected action. Metrics' always-run collector projects the action logs into the
existing setup/check diagnostic filenames, including failed setup; skipped setup
does not select unrelated temp files. The actual action body remains exercised
by the Metrics fixture, including command order, failure status, logs, PATH timing
and outer Git recovery-state retention. Release fixtures use the shared Make
bootstrap and add their local validation logger/checksum inputs. Every Metrics
target retains four-mode unsafe-execution refusal and the actual Cargo/metadata
targets retain pipe-jobserver checks. Exhaustive flag aliases/inheritance and
common-tool leaf failures stay at Shared Tooling. Metrics keeps representative
install/check/admission failures, diagnostic projection and Git recovery custody.

Aggregate/counter corruption tests share one private refusal assertion. It checks
typed load/save errors, exact retained bytes and zero stable writes. Encoding
vectors, explicit removal, summary reopening and all runtime arithmetic remain
unchanged. The earlier pending source at
`1a10c4a593e93835455f669dfb5ee2b2ba78dd49` passed full local `make ci` and
Rust 1.91 native/Wasm workspace checks,
including all stable tests/doctests and warning-denied Clippy. Producer common-tool/
Make cases and actual Metrics native evidence/release/admission fixtures pass on
Bash 5 and genuine Bash 3.2, with affected retention, ShellCheck, actionlint and
documentation checks. That upstream port's exact-source hosted Linux, Intel
macOS and Apple Silicon checks also completed successfully. Those results retain
their earlier source identity; the new fixture-selection batch uses focused
producer/consumer checks. Local/substitute results do not establish hosted
acceptance of the pending Metrics working tree.

The current selection batch passes the actual release/evidence fixtures on Bash
5 and genuine Bash 3.2, consumer retention/admission checks, snapshot/pin checks,
focused ShellCheck and documentation links. Shared's changed flow/action fixtures
also pass both Bash versions and its retention checks. PR #231 has passing scope
and lint checks; the hosted native matrix remains in progress. No full local
suite was rerun for this fixture-only batch; package/compiler/dependency metadata
and all Rust files are byte-identical to its starting working tree.

Generic selected-source metadata rejection cases now live in
[Shared PR #232](https://github.com/dragginzgame/shared-tooling/pull/232). Its unchanged
runtime helper matches the selected snapshot; this test-only contribution needs
no snapshot refresh. Metrics retains the actual two-package selected-commit check
and rejected-version receipt, while dropping the duplicate direct-runner flag
matrix. Both producer fixtures and the actual Metrics admission fixture pass on
Bash 5 and genuine Bash 3.2; consumer parent/retention checks also pass. README
usage is current, with older release receipts retained through the fixed link below.
The independent incoming Memory 0.43 manifest/lock update is preserved; these
fixture checks do not qualify that dependency graph.

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
and percentage acceptance remains with [#80](https://github.com/dragginzgame/ic-metrics/issues/80).

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
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) owns the original
remaining arithmetic-reader qualification. Publication, registry selection and
producer CI do not establish an owning application's acceptance.
