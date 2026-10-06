# Repository improvement audit — 2026-10-06

## Scope, identity and verdict

Requested repository audit of ic-metrics HEAD
`083254a6a7c24f1e07d1e952a867059746f6feb5` (released 0.1.9), using
[code hygiene](../../audits/code-hygiene.md) and the
[flow-convergence method](../../audits/flow-convergence-and-duplication.md).
Both belong to reviewed Shared Tooling
`a37771f1b6b5fc9a88ed6ab3b705bdda35cd8fa3`; the 44-file snapshot verifies.
The local authority is [AGENTS.md](../../AGENTS.md), with its identity captured
in the input manifest. Existing README, extraction, host and handoff edits were
preserved. A concurrent edit changed the ic-testkit declaration/lock from 0.18.3
to 0.19.0 during the audit; the two validation phases remain separately bound.

Scope: all production Rust, arithmetic tests, reader fixture/harness, manifests,
Make entrypoints, consumer-owned release adapters/fixtures, native CI and current
public documentation. Shared snapshot code was inspected at its integration
boundary, without repeating its complete upstream audit. Sibling applications,
live releases/deployments, vulnerability freshness and complete consumer
qualification were not audited. The existing performance report is reused only
within its original source, artifact and workload scope; this is not a new cost
measurement or a comparable structural score history.

**Verdict: FAIL for release-fixture failure-evidence retention.** A focused
substitute demonstrates loss of the only captured child diagnostic. Production
arithmetic review and selected checks pass; no production correctness defect or
justified arithmetic/reader optimization was found. Two additional LOW findings
concern test dependency ownership and documentation. Findings are tracked solely
in the linked GitHub issues; this report freezes the audit evidence.

## Owner and flow inventory

| Behavior | Owner and flow | Retained boundary |
| --- | --- | --- |
| Count/total update | `record_sample` independently saturates two caller-owned fields. `MeasurementSummary::record` delegates, then updates latest/maximum. | Units, observation admission and counter identity remain with consumers. |
| Empty/zero summary | Private four-`u64` state, `EMPTY`/`Default`, optional latest/maximum getters. | Recorded zero is distinct from absence; saturated count/total cannot establish exact intervals. |
| IC read | Wasm-only `ic` feature → safe ic0 1.2.0 counter-1 binding. | Native substitutes, attribution, resets, persistence and endpoints remain consumer-owned. |
| Reader proof | Explicit Make target → built Wasm → digest/version-checked PocketIC → direct reads and actual callbacks/queries. | Per-context deltas and downstream exclusion; no native timing or estimated cycles. |
| Release routing | Patch/minor/major/resume → reviewed common runner → local metadata/admission callbacks. | Maintainer commit/release authority, exact selected commit and separate Cargo publication. |
| Fixture evidence | Local smoke/metadata tests redirect output into invocation-owned scratch. | Failure diagnostics must survive unexpected exits; admission fixture already retains failed scratch. |

Production Rust contains no unsafe code, panic/unwrap/expect, allocation,
formatting, serialization or collection. The two `expect` calls are in the host
integration test and reject unexpected fixture failures; they are not library
panic contracts. Fixture `Vec`/Candid/CDK code serves real runtime qualification
and is not the published arithmetic runtime. The raw PocketIC digest remains an
independent harness boundary, distinct from installer archive verification.

The allocation-free summary, explicit optional binding and independent consumer
attribution contracts are intentional retention decisions. Removing saturation,
latest/maximum or empty/zero distinctions would break behavior. Adding shared
memory IDs, registries, endpoint ownership or an attribution-mode switch would
contradict the extraction contract rather than improve this library.

## Findings

### MEDIUM — Release fixtures lose unexpected-failure evidence

[Issue #7](https://github.com/dragginzgame/ic-metrics/issues/7) owns the correction.
`scripts/release/test-standard-release.sh:6-7` unconditionally removes its
fixture. Make output at lines 25–28, 34–35 and 55–58 is captured inside it.
A failing child can therefore leave no diagnostic in the parent CI/release log.
The metadata fixture also deletes failed scratch after printing only the current
result log. The hook fixture has a related cleanup pattern. The admission fixture
already demonstrates bounded success cleanup and failure retention.

The unchanged standard-release script was executed with a private Make
substitute emitting `AUDIT_ONLY_INJECTED_MAKE_FAILURE` and exiting 42. Its trace
confirms invocation. The fixture exited 1, the outer log had **zero bytes**, and
the private TMPDIR had **zero retained fixture entries**. This demonstrates
diagnostic loss, not a production release failure. The ordinary fixture passes.

Correction: report and preserve failed scratch and relevant logs, while cleaning
successful owned scratch. The common smoke block already has an upstream owner,
[Shared Tooling #8](https://github.com/dragginzgame/shared-tooling/issues/8).
Its proposed helper retains failures but was uncommitted at inspection; adopt
only a reviewed committed snapshot. Publication/metadata obligations remain local.

### LOW — Arithmetic unit checks prepare the unused host IC harness graph

[Issue #8](https://github.com/dragginzgame/ic-metrics/issues/8) records the design
tradeoff. Native ic-testkit/sha2 dev-dependencies belong to the reader integration
test, but the selected six arithmetic unit tests also compiled ic-testkit 0.18.3,
PocketIC 16 and their host graph. Those tests use neither dependency.
The later dev-dependency inventory selects ic-testkit 0.19.0; it is not relabelled
as the earlier test run.

Assess one private reader-test package to give the existing harness and its
dependencies a separate owner. Keep ordinary arithmetic checks dependency-light,
without adding a public feature matrix or duplicating reader logic. The extra
package/Make wiring is a real maintenance tradeoff, not a predetermined win.
No compile-time benchmark or production size/cycle claim was made. Default
normal dependency trees on native and Wasm are empty; Wasm `ic` adds only ic0.

### LOW — Public downstream references depend on a local machine

[Issue #9](https://github.com/dragginzgame/ic-metrics/issues/9) owns portability and
wording. The extraction document links IC Backup records to absolute
`/home/adam/projects/...` paths; retained handoff sections do likewise for Canic,
IC Timers and IcyDB. These are not portable public references. A local existence
checker alone would not detect their public usability problem.

README still calls IC Backup's integration prepared, while the current evidence
records it in committed 0.3.7. Use appropriate public owner/source links where
available, explain unpublished evidence, and reconcile current release wording
without rewriting historical source identities or claiming pending graphs passed
older release CI. Reader minimum-version 0.1.5 examples are intentional and are
not mistaken for current-release declarations.

## Checks and comparison limits

Evidence is retained under `target/evidence/repo-audit-019/`. Initial input hashes
verified after the first validation phase. Rust/Cargo 1.99.0 on Linux x86-64,
locked offline dependencies and the owning `target/` were used. Active builds
were checked before compilation. No full local test/CI gate or IC measurement ran.

| Check | Result and actual scope |
| --- | --- |
| `cargo clippy -p ic-metrics --lib --all-features --locked --offline -- -D warnings` | PASS on the original 0.18.3 testkit graph; native library only. |
| `cargo test -p ic-metrics --lib --locked --offline summary::tests::` | PASS, six maintained arithmetic tests; original input hashes verified afterward. |
| Normal dependency trees, native/default Wasm/IC Wasm | Empty default runtime graphs; opt-in Wasm graph contains ic0 1.2.0. |
| `bash scripts/release/test-standard-release.sh` | PASS, command substitutes; no release or publication effects. |
| Unexpected Make failure injection | Confirms diagnostic loss as described above. |
| `cargo clippy -p ic-metrics --lib --test ic_reader --all-features --locked --offline -- -D warnings` | PASS after the concurrent ic-testkit 0.19.0 update; separate manifest/lock/harness hashes verified afterward. This is compilation, not current-graph IC execution. |
| Snapshot and diff whitespace checks | PASS; existing edits preserved. |
| Library source compared with v0.1.6 | Unchanged. Earlier compiler/cost evidence retains its original toolchain, dependencies and workload. |
| Exact 0.1.9 hosted CI | [Run 37452356472](https://github.com/dragginzgame/ic-metrics/actions/runs/37452356472) passes MSRV and all three native hosts. This qualifies the committed graph, not the concurrent dependency update. |

The first fault-injection attempt used an env-based Bash shebang, intercepted by
the fixture's own substituted dispatcher. It did not execute the intended Make
substitute. Its nonempty outer log and missing substitute trace remain under
`fault.PWN4uA/`; they supply no Make-failure proof. The corrected absolute-Bash
substitute and result are retained under `fault.dJWbhF/`.

No new Wasm size, instruction or cycle reduction is asserted. The
[earlier performance audit](performance-audit.md) already finds the shared
arithmetic/reader equivalent to direct bodies in its selected compiler probes.
Its canister transform measurements concern the complete reader fixture, not
ic-metrics' marginal contribution or arbitrary consumer workloads. Consumer
labels, map updates, Candid replies and build profiles remain the appropriate
owners for further measured application optimization.

The audit changed no implementation, dependency, version, release notes or
existing handoff. It added this report and GitHub follow-ups under the prior
issue-tracking authorization. The concurrent dependency change remains owned by
its author; this report does not complete its release batch or native qualification.
