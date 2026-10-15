# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Released 0.10.0

Summaries now project counts, totals, maximum and means through `aggregate()`,
matching histograms. Their five direct forwarding methods are removed, without
aliases. Ordered recording, restoration and `latest()` remain summary-owned;
underlying arithmetic, quality flags and empty/zero semantics are unchanged.
Consumers selecting the new minor must update summary projections. Both packages
are published from `63a6bd7ee79cc892f9894ab307c990520842ffc7`; the root catalog
now requires local Metrics 0.10. Package versions remain unchanged.

## Pending 0.10.1

Retained-success fixtures delegate completion admission to Shared Tooling without
changing their cleanup or diagnostic policy. The snapshot also shares generic
Make admission/parallel probes, effectful fixture execution and native diagnostic
collection; catalogs and release metadata helpers remain unchanged. Metrics owns
target rosters, stubs, payload assertions and outer Git custody. Allocation and
bootstrap assertions
stay with Memory's own runtime tests; Metrics retains mixed-kind, wide-total and
namespace reopening through its host-supplied map.

[Shared PR #200](https://github.com/dragginzgame/shared-tooling/pull/200) supplies
the clean committed completion-helper snapshot stacked on the existing owner
contributions. Formatting, snapshot/document checks, changed-script ShellCheck,
named mixed-kind reopening/no-write tests and stable native/Wasm Clippy pass on
the earlier Memory 0.38 graph.
Both real native-evidence and fixture-retention scripts pass under modern Bash
and actual Bash 3.2.57. These are focused local checks with substituted external
effects; they do not establish new hosted macOS, full-release or IC-cost acceptance.

[Shared PR #201](https://github.com/dragginzgame/shared-tooling/pull/201) supplies
the three further flow extractions. Actual
Metrics standard-release, effectful-retention and native-evidence fixtures pass
under modern Bash and Bash 3.2.57. Producer boundary tests, source-following
ShellCheck, workflow lint, snapshot/documentation and diff checks pass. The
earlier missing-import probe failure is retained; helper imports now follow
EXIT-trap installation so cleanup-prefix probes remain minimal. Generic checks
preserve actual Make dispatch, exact failure statuses, retained payloads and
outer Git evidence. These fixtures do not establish hosted source acceptance or
full release validation; those flow extractions run no Rust or IC workload.

[Shared PR #204](https://github.com/dragginzgame/shared-tooling/pull/204) supplies
canonical current-source formatter discovery and
locked release-cache/tool preparation. Metrics keeps source/recovery admission,
preparation authority, ordered tool targets and pin selection. Producer boundary
tests and actual Metrics metadata, release-admission, hook and retention fixtures
pass under modern Bash and Bash 3.2.57. Source-following ShellCheck and snapshot,
documentation and diff checks pass. [IC Build #39](https://github.com/dragginzgame/ic-build/issues/39)
owns its separate two-catalog adoption; its active checkout is unchanged. The
first upstream macOS run exposed space-padded `wc` output in a fixture assertion;
numeric comparison fixes it, with padded-output checks on both local Bash versions.
That substitute remains distinct from hosted native acceptance.

[Shared PR #207](https://github.com/dragginzgame/shared-tooling/pull/207) supplies
the current 133-file snapshot and mechanical workflow run-body extraction.
Metrics retains YAML selection, workflow ordering/conditions and evidence custody.
The extractor refuses missing/duplicate IDs, action steps, blank bodies and
malformed or multiple JSON documents before publishing a script. Shared owns the
exhaustive release-root matrix; Metrics retains one actual Makefile include check.
Producer selection/root-isolation fixtures and actual consumer release, native
evidence and effectful-retention fixtures pass on current Bash and Bash 3.2.57.
The complete local `make ci` gate passes on this snapshot; unchanged native/Wasm
package-floor inputs retain their earlier passing evidence.
This batch changes no Rust source, manifest, lock or executable-tool selection.

Histogram restoration now derives count agreement, maximum placement and total
range in one numeric admission pass after bounds admission. Public APIs, error
priority and stable V1 layouts are unchanged. The [frozen comparison](../evidence/histogram-restoration-0101.md)
records 318,456 matching before/after inputs and a 1,398-to-1,326-byte raw Wasm
probe. That reduction belongs only to the probe; no IC execution or cycle cost
is measured. All histogram/restored-state tests, selected stable histogram and
corrupt-record cases, strict native/Wasm Clippy and both package compiler floors
pass. The complete local `make ci` gate also passes; its first sandboxed attempt
refused the loopback download-test server, with the unchanged gate passing after
granting local socket access. Hosted acceptance and release execution remain separate.

The released 0.10.0 batch also adds optional durable scalar counters to the
existing one-map store; [the stable README](../../crates/ic-metrics-stable/README.md) owns supported
kinds, identity, reset and write policy. Existing V1 layouts require no reset.
[The frozen counter qualification](../evidence/durable-counter-097.md) retains
its exact source before this API cut, including the earlier passing CI/floors
and reproducible IC upgrade/rollback/cost results. It does not qualify this later
source or an owning application's workload; its identities and archives are unchanged.

Earlier pending fixture changes keep synthetic release cases on a minimal Git
baseline and generic archive fidelity at Shared Tooling. Product-commit offline
Cargo admission, workflow ordering, payload replay and outer Git custody remain
local. [The retained handoff](../evidence/handoff-before-summary-cut-0100.md)
preserves their original qualification and all earlier release observations.

## Selected owners and qualification

[Exact-release CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38633947812)
passes Linux, Intel macOS, Apple Silicon and both native/Wasm package floors.
Each native log records 50 arithmetic units, 16 stable units and eight doctests
per package. [The released-source receipt](../evidence/release-0100.md) binds
the source, registry archives and all three native diagnostics. Owning consumer
acceptance and earlier IC performance experiments retain their separate scope.

The incoming Memory 0.39.0 manifest and lock selection is preserved. Complete
local CI, including stable codec tests and strict native/Wasm Clippy, and actual
Rust 1.88 checks pass on that graph. Hosted acceptance and owning application
workloads remain separate.
Arithmetic retains Rust 1.85 native/Wasm; the optional stable package retains
Rust 1.88. Shared's recorded candidate is
`1d53395b4c861e4a41e8cd70243c488c41377b4f`; the separately managed published
Host inspector remains 0.17.10. Executable-tool selections remain unchanged.

[Shared PR #197](https://github.com/dragginzgame/shared-tooling/pull/197) repairs
coordinated local dependency requirements. The released 0.10.0 source contains
that snapshot and the updated local requirement. The earlier refused attempt
and its restoration evidence remain historical; this handoff requests no plan
retirement or release recovery.

[Memory PR #103](https://github.com/dragginzgame/ic-memory/pull/103) was closed
without merging in favor of the canonical
[Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97).
Its opt-in `ic-testkit-native` stable-memory observer remains unpublished; the
official package index returns 404. The incoming Memory graph selects 0.39.0.
The local test observer remains until that reviewed replacement is published,
as tracked in [#82 — Adopt published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82).
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned after publication. Existing callers are not opted into persistence.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary callers are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47); adopt the
published API with aggregate projections, preserving attribution, quality and resets.
The arithmetic-reader closeout remains [#10 — Complete arithmetic-only consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/10).
Current migration guidance uses aggregate projections; historical wire names,
measurement archives and already accepted consumer receipts retain their scope.
