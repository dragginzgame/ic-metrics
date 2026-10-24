# Historical handoff through 0.11.0

These release and preparation observations are retained verbatim from the earlier
handoff. Their original source, dependency and validation scopes remain unchanged;
use [the current handoff](current.md) for active versions and qualification.
Paths to ignored local evidence are historical references, not retained artifacts.
At archival time, both packages were published as 0.11.0 with Memory 0.41 in the
stable graph; [the current handoff](current.md) owns later release observations.

## Preparation for 0.11.0

The preparation observations below retain their original source and Memory graph;
they are not a qualification receipt for the later released source.

Both packages declare Rust 1.91 for native and Wasm. `make msrv` checks the
whole workspace; the separate stable floor target, override and CI/release
dispatch are removed. Preparation used package version 0.10.1 and Memory 0.40;
the delivered package and Memory versions are recorded above.

The reviewed 112-file Shared Tooling 0.15.0 snapshot is
`1d261fe396c6158c5e0bcd9b35d4c914f1d5489f`, from
[Shared PR #215](https://github.com/dragginzgame/shared-tooling/pull/215), stacked
on [#211](https://github.com/dragginzgame/shared-tooling/pull/211). It retains the
now-merged [integration PR #205](https://github.com/dragginzgame/shared-tooling/pull/205).
Twenty-two exhaustive regression-suite calls move to the Shared producer's CI;
unused test payloads retire through distribution. Actual tool/snapshot/pin,
Make/hook, metadata/source-admission and evidence custody checks remain here.
Preflight, workflow extraction and jobserver helpers are explicit snapshot roots.

Shared owns full native archive packaging as well as sanitized diagnostic
collection. Metrics keeps file selection, identity/outcome records, incomplete
collection status, Git custody and upload policy. Hidden index/intent, hashes,
filenames and modes remain retained; partial-write failures keep original inputs
and readable diagnostics. Common CI and preflight still omit the optional Host
inspector. Explicit evidence-tool commands and frozen experiment identities remain.

The producer packaging fixture passes on current Bash and genuine Bash 3.2.57,
including direct filesystem-root refusal. Final-source full `make ci` and actual
native workflow qualification pass in the source-equivalent disposable committed
checkout at `target/evidence/tooling-cleanup.1Ot0RX/`. The unified Rust 1.91 native
and Wasm workspace gate passes on unchanged package/compiler inputs, including
Memory 0.40. Bash 3.2 workflow, release-admission and standard-release fixtures
pass; ShellCheck, workflow lint, snapshot, formatting and documentation checks
pass. Substituted workflow effects establish local wiring and custody, not hosted
native acceptance or IC performance. Shared PR #215's hosted matrix remains
separate from this local qualification.

During preparation, tracked scripts retired by refresh remained missing from the
real index until committed, so source hashing deliberately refused there. Local
qualification changed no real index, refs, package versions or dependency selections.
Earlier evidence under `target/evidence/without-inspector.oFamcc/` retains its original source,
Memory 0.39 graph and separate compiler-floor commands.

## Released 0.10.0

Summaries now project counts, totals, maximum and means through `aggregate()`,
matching histograms. Their five direct forwarding methods are removed, without
aliases. Ordered recording, restoration and `latest()` remain summary-owned;
underlying arithmetic, quality flags and empty/zero semantics are unchanged.
Consumers selecting the new minor must update summary projections. Both packages
are published from `63a6bd7ee79cc892f9894ab307c990520842ffc7`; the root catalog
requires local Metrics 0.10.

## Released 0.10.1

The finalized release is `305325df2baa0cfc1763070a8c7e975b1f8d0bdd`.
Both package versions are 0.10.1. The preparation observations below retain
their original scope; they do not establish new hosted acceptance.

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
the prior 133-file snapshot and mechanical workflow run-body extraction.
Metrics retains YAML selection, workflow ordering/conditions and evidence custody.
The extractor refuses missing/duplicate IDs, action steps, blank bodies and
malformed or multiple JSON documents before publishing a script. Shared owns the
exhaustive release-root matrix; Metrics retains one actual Makefile include check.
Producer selection/root-isolation fixtures and actual consumer release, native
evidence and effectful-retention fixtures pass on current Bash and Bash 3.2.57.
The complete local `make ci` gate passed on that snapshot; unchanged native/Wasm
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
existing one-map store; [the stable README](https://github.com/dragginzgame/ic-metrics/blob/92ff804125fb07370fad4cb24cc620f52122ac36/crates/ic-metrics-stable/README.md) owns supported
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

[The retained 0.10.0 CI receipt](https://github.com/dragginzgame/ic-metrics/actions/runs/38633947812)
passes Linux, Intel macOS, Apple Silicon and both native/Wasm package floors.
Each native log records 50 arithmetic units, 16 stable units and eight doctests
per package. [The released-source receipt](../evidence/release-0100.md) binds
the source, registry archives and all three native diagnostics. Owning consumer
acceptance and earlier IC performance experiments retain their separate scope.

Earlier qualification used Memory 0.39.0: complete local CI, stable codec tests,
strict native/Wasm Clippy and actual Rust 1.88 checks passed on that graph. The
released 0.11.0 graph instead selects Memory 0.41, as recorded above. Hosted
acceptance and owning application workloads remain separate.
Both packages select Rust 1.91 native/Wasm through one workspace gate. Shared's
recorded revision is `1d261fe396c6158c5e0bcd9b35d4c914f1d5489f` (Shared 0.15.0). The separately
managed published Host inspector remains 0.17.10. Executable-tool selections
remain unchanged.

[Shared PR #197](https://github.com/dragginzgame/shared-tooling/pull/197) repairs
coordinated local dependency requirements. The released 0.10.0 source contains
that snapshot and the updated local requirement. The earlier refused attempt
and its restoration evidence remain historical; this handoff requests no plan
retirement or release recovery.

