# Current handoff

ic-metrics owns allocation-free measurement arithmetic. `record_sample` updates
borrowed count/total fields; `MeasurementSummary` owns count, total, latest and
maximum, with independent saturation and distinct empty/zero states. The library
keeps its default core dependency-free and `no_std`; consumer attribution, identity,
persistence and endpoints stay local. The pending opt-in `ic` feature adds the safe
Wasm-only `call_context_instructions` reader. Its ic0 binding uses `std` explicitly;
native builds have no shared reader or fake. See the [extraction contract](../extraction.md).

The maintainer published 0.1.4 and tagged `v0.1.4` at
`1a144139a2b84e7a389d721febe79aaac3775b0c`; Cargo metadata is 0.1.4.
The official sparse index records a non-yanked, dependency-free release with
Rust 1.88 minimum. Its downloaded archive checksum
`7f2180745a0953a797b45f540d9a29d3236bc24a27b25e1cb835179be8305a9e`,
Rust sources, license and embedded Git revision match the tag. The registry
`no_std` fixture passes locked offline Rust 1.88 host and Wasm checks using this
repository's target directory. The tagged 0.1.4 native CI run passed Linux,
both declared macOS hosts and MSRV:
[37353066599](https://github.com/dragginzgame/ic-metrics/actions/runs/37353066599).
The earlier verified 0.1.3 archive and successful CI remain scoped to that release;
the REST API's earlier HTTP 403 did not prevent sparse-index/artifact verification.

`make publish` publishes only the current ic-metrics package to crates.io;
`make publish-check` runs Cargo's upload-free dry run. Publication remains separate
from Git release commands. The [changelog](../../CHANGELOG.md) preserves finalized
0.1.4 notes and opens undated 0.1.5 for the compatible opt-in reader API and its
focused runtime fixture. Cargo package/workspace versions remain 0.1.4. Registry
adoption notes belong to their consumer release. No agent commit, tag, push,
registry upload or consumer artifact cleanup occurred.

IcyDB and Canic use shared sample arithmetic while retaining inclusive and
exclusive attribution respectively. IC Timers directly re-exports the summary
while retaining callback roles and registration identity. IcyDB's maintainer
already selected registry 0.1.3. IC Timers now selects registry 0.1.3 in both
independent lockfiles; every other lock record is preserved. The maintainer
committed this adoption and focused guard/fixture repairs at `685b4ff` while
checks were in progress, changing the root requirement to the compatible `0.1.3`
range. The maintainer subsequently committed the documentation and fixture lint
corrections at `bd37cba`. Later platform/runtime-test repairs are dirty and
outside the earlier passing results; their maintainer workflow owns broader
qualification. The earlier focused Linux
measurement, registration/reset identity, stale delivery and abandonment tests
pass, as does warning-denied library Clippy. The first Clippy attempt reported
three delivery-guard diagnostics; preserving the whole guard through normal
completion and using `let ... else` corrected them. A completion fixture initially
aborted during thread-local teardown with a still-armed recurring timer; explicit
unregistration repairs that fixture without altering the platform substitute.
Two initial test filters matched no tests; exact maintained names supplied the
reported evidence. No broad timer or PocketIC gate ran.

Canic now selects registry 0.1.4 without the sibling path, retaining its
compatible `0.1` requirement, every other lock record and package metadata.
The previous path changed its lock entry from 0.1.3 to 0.1.4 during active
maintainer validation. An isolated worktree first qualified the replacement
with locked offline Linux metadata, manifest sorting, strict Core library Clippy
and all four endpoint tests. Its primary release command subsequently stopped;
source and lock identities were rechecked before applying the patch there.
Primary locked offline Linux metadata, manifest sorting, strict Core library
Clippy and all four endpoint tests pass using Canic's own target directory. A
first primary test attempt was stopped after another validator acquired the
build lock; the completed rerun followed active-process and free-lock checks.
Concurrent CLI/host repairs and later Core replay-policy/guard edits are
preserved. Those later edits are outside this passing adoption evidence; the
selected results do not qualify the complete current consumer worktree.
Current Canic root and
detailed 0.110.53 notes link the
[adoption issue](https://github.com/dragginzgame/canic/issues/447).

IcyDB's clean committed registry adoption at `1a8511c3a` now has fresh focused
Linux qualification. An isolated worktree at `/tmp/icydb-metrics-worktree.TqlusC`
passed metrics-enabled strict Core Clippy and all nine metrics-state tests using
the explicitly checked selected cache, the designated IcyDB Cargo home and its
own `target/icydb` with two build jobs. These checks cover saturation, reset
identity/exhaustion, failed owner attempts, lifecycle/journal separation, report
bounds/order and Candid shape. Primary Rust source, manifest and lock inputs
were checked against the captured qualification revision.

The primary release command then stopped with a clean checkout at that same
revision. Active-process/free-lock and source/lock identity checks admitted the
prepared registry notes and obsolete local-path comment removal. Primary locked
offline Linux metadata and manifest sorting pass; typed Cargo metadata and all
lock bytes are unchanged. An initial one-off history check assumed a second
release heading in the pending-only detailed ledger and failed; exact intended
bullet comparison then verified that all other root/detailed changelog bytes
were preserved. Adoption-note edits remain uncommitted; no production Rust changed.

All three named primary consumers now resolve registry packages with focused
arithmetic/adoption evidence: Canic 0.1.4, IcyDB 0.1.3 and IC Timers 0.1.3 in both
lockfiles. The existing [coordination issue](https://github.com/dragginzgame/ic-metrics/issues/4)
links owning consumer qualification. These checks do not establish complete
consumer native release/CI or publication. The shared reader now uses an explicit,
optional Wasm binding; `unsafe_code = "forbid"` remains unchanged and no policy
exception is needed. The earlier audit treated ic0's std dependency as a universal
blocker; isolating it behind `ic` preserves the required default arithmetic graph.
Consumer migration depends on publication of the new API and remains tracked in
[#3](https://github.com/dragginzgame/ic-metrics/issues/3).

The implemented reader now passes the named direct-counter/replicated-callback
PocketIC fixture, strict native/Wasm Clippy, warning-denied docs, Rust 1.88
host/Wasm library checks, and isolated offline package verification. Normal
dependency trees confirm zero default host/Wasm dependencies and only ic0 in the
enabled Wasm graph. Exact zero/empty and independent-saturation tests pass.
The [execution record](../evidence/ic-reader.md) retains inputs, artifact digests,
instruction readings and initial failed attempts. These results qualify this
reader batch on Linux, not composite queries, current consumer lifecycles or a
complete new native CI run. The reader test runs explicitly through `make
reader-check`; ordinary tests do not launch or download PocketIC.
The issue received a concise [coordination update](https://github.com/dragginzgame/ic-metrics/issues/3#issuecomment-6002189269).
Automatic approval review rejected the attempted detailed public comment because
it included unpublished implementation and internal evidence; those details
remain in the local execution record. The accepted comment omits them and keeps
publication and consumer ownership as the coordination boundary.

The current snapshot records reviewed Shared Tooling revision
`f52c0e2476aee094359ed21de91c468540d3969f`, verified as GitHub's latest committed
main during adoption. The final remote recheck detected this newly committed
revision after the initial c0206f1 refresh; the canonical helper then exported
its committed bytes from the now-clean Shared Tooling checkout.
All 20 declared files verify, including the new dependency/hook rules, standard
pre-commit hook and installer. AGENTS.md follows automatically numbered pending
notes. Root/member formatting covers all maintained manifests. The root catalog
owns the optional IC binding and fixture dependencies; child target-specific
tables inherit them. There is no independent nested workspace.

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
also includes automatic same-kind release recovery. The tagged 0.1.3 CI now
qualifies these maintained fixtures on both declared macOS hosts; live maintainer
release-adapter execution remains a separate boundary.

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
its exact revision. The tagged 0.1.3
[CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37351475035) also
passed Linux, both declared macOS hosts and Linux MSRV, qualifying the refreshed
snapshot, packaging and maintained hook/formatter fixtures at that release. Shared
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
records continuity and native-substitute boundaries. The opt-in backend calls the
safe ic0 API without project-owned unsafe code. Earlier raw-FFI suggestions were
not implemented; consumer adoption remains scoped in
[#3](https://github.com/dragginzgame/ic-metrics/issues/3).

Before the 0.1.3 release, publication target command fixtures covered exact package/registry selection,
separate dry-run semantics and propagated Cargo failures without registry effects.
At that preparation revision, shell lint, formatting and locked metadata passed;
Cargo metadata was 0.1.2 with publish=["crates-io"]. Offline Cargo publication dry runs, both directly
and through Make, stopped because Cargo required an HTTP request. No online retry
or registry upload was attempted. Offline archive verification supplies package
build evidence separately from registry dry-run qualification.
