# Current handoff

ic-metrics owns allocation-free measurement arithmetic. `record_sample` updates
borrowed count/total fields; `MeasurementSummary` owns count, total, latest and
maximum, with independent saturation and distinct empty/zero states. The library
remains dependency-free and `no_std`; consumer attribution, identity, persistence,
endpoints and IC readers stay local. See the [extraction contract](../extraction.md).

The maintainer tagged 0.1.2 at `7a302c9542619c7252f6c62584e771ccb86a4cd8`.
Cargo metadata remains 0.1.2. The reported missing publish target is corrected:
`make publish` delegates to locked, verified Cargo publication of only ic-metrics
on crates.io, and `make publish-check` runs its upload-free dry run. The crate's
manifest now permits only crates.io. These targets use the current version,
perform no Git release effects and retain artifacts. Commit publication edits
before using the targets; Cargo's dirty-tree check remains enabled.
The [changelog](../../CHANGELOG.md) preserves finalized history and extends one
undated 0.1.3 candidate for compatible publication tooling. Notes do not authorize
a version bump or registry upload.
No agent commit, tag, push, registry upload or consumer artifact cleanup occurred.

IcyDB and Canic use shared sample arithmetic while retaining inclusive and
exclusive attribution respectively. ic-timers directly re-exports the summary
while retaining callback roles and registration identity. Their root dependency
pins and four applicable lockfiles select local ic-metrics 0.1.1. Temporary paths
remain integration wiring rather than published adoption;
[publication/adoption #4](https://github.com/dragginzgame/ic-metrics/issues/4)
links the consumers' registry dependency work.

The current snapshot records reviewed Shared Tooling revision
`f52c0e2476aee094359ed21de91c468540d3969f`, verified as GitHub's latest committed
main during adoption. The final remote recheck detected this newly committed
revision after the initial c0206f1 refresh; the canonical helper then exported
its committed bytes from the now-clean Shared Tooling checkout.
All 20 declared files verify, including the new dependency/hook rules, standard
pre-commit hook and installer. AGENTS.md follows automatically numbered pending
notes. Root/member formatting covers all maintained manifests; there are no
runtime dependencies or independent nested workspaces to centralize.

`make fmt` runs pinned cargo-sort 2.1.4 before Rustfmt; `fmt-check` checks both
without mutation. Developer setup and native CI use that same formatter version.
`make install-hooks` is documented and has enabled repository-local
`core.hooksPath=.githooks` in this clone; no prior effective hook setting or
executable private hook was present. CI runs the consumer's actual-Makefile hook
fixture on each declared host, independently of its non-mutating formatting gate.

The latest shared installer includes the physical-path correction from
[Shared Tooling #1](https://github.com/dragginzgame/shared-tooling/issues/1).
The temporary consumer setup workaround was removed; Make invokes the unchanged
shared installer directly. Its aliased-path fixture passes on Linux. The snapshot
also includes automatic same-kind release recovery. Corrected native macOS
execution remains unqualified for this working-tree adoption.

All three standard release targets use the adopted shared runner and the same
consumer-owned gate. Preflight/validation-only failures allow fresh normal-target
retries; after preparation starts, rerunning the same target reconciles saved intent
without another increment or duplicated effects. Exact-version release-resume
remains available; identity, payload and destination conflicts stop recovery.
Preparation formats only the changed root manifest, retains dependency selections
and historical notes, and restores metadata after failure. The complete gate
includes independent formatting and hook checks; no real release was executed.

Focused Linux checks pass for snapshot integrity, formatting, shell/workflow lint,
release runner/entry-point fixtures and consumer metadata/hook fixtures. The hook
fixture verifies selected refresh, unrelated edit preservation, partial-stage
rejection and formatter failure isolation, including aliased setup. Metadata
fixtures use real offline sorting/metadata with Cargo-edit and Git substitutions;
formatter, metadata and conflicting-note failures restore original files and
retain member manifests/artifacts. An initial fixture attempt omitted its relative
changelog helper and failed; copying that helper into scratch resolved it.
Separate temporary fixtures also exercised all increments with real offline
Cargo-edit and substituted Git reads. No full local CI ran.

The earlier arithmetic extraction passed strict Clippy, six core tests, Wasm and
Rust 1.88 host/Wasm checks and warning-free docs; IcyDB's nine state tests, Canic's
four endpoint tests and ic-timers' three projection tests passed on Linux. Later
selected Canic and IcyDB library builds passed. IcyDB's first build attempt met an
occupied lock and was stopped; its unfiltered metadata also needed uncached
Windows-only clipboard-win 5.4.1, while focused Linux metadata passed. IC Timers'
selected build completed with an unused-assignment warning in separate delivery
retirement work at runtime/mod.rs:1090; this is not warning-free qualification.
These observations do not qualify concurrent unrelated consumer edits.

The tagged 0.1.1 [native CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37339148886)
passed Linux, both declared macOS hosts and Linux MSRV. The
[host record](../hosts.md) preserves earlier failures and scopes that evidence to
its exact revision; the current adoption needs its own native macOS run. Shared
Tooling's corrected dirty-source portable suite stopped at missing cloc after
validation-runner, installer and hook fixtures passed; its separate distribution
and release-runner fixtures passed. This is not a complete portable-suite pass.

Package preparation inherits the public repository URL and includes a regular
package-local copy of the canonical MIT license. README links work outside the
checkout. Offline Cargo packaging verifies the archive; archived license bytes
match the root exactly. Its standalone manifest passed Rust 1.88 host/Wasm checks
using this repository's target directory. An earlier SPDX-plus-license-file
attempt warned; the conflicting declaration was removed before verification.
Registry publication has not been executed by the agent. The [reader audit](../extraction.md#ic-reader-contract-audit)
records continuity and native-substitute boundaries. ic0 uses std; raw FFI conflicts
with the unchanged unsafe-code policy. No IC backend was added; qualified reader
work remains scoped in [#3](https://github.com/dragginzgame/ic-metrics/issues/3).

Publication target command fixtures cover exact package/registry selection,
separate dry-run semantics and propagated Cargo failures without registry effects.
Shell lint, formatting and locked metadata pass; Cargo metadata retains version
0.1.2 and publish=["crates-io"]. Offline Cargo publication dry runs, both directly
and through Make, stopped because Cargo required an HTTP request. No online retry
or registry upload was attempted. Offline archive verification supplies package
build evidence separately from registry dry-run qualification.
