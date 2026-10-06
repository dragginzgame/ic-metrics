# Current handoff

ic-metrics owns allocation-free sample arithmetic and the optional IC
call-context instruction reader. Default arithmetic stays dependency-free and
`no_std`. Feature `ic` exposes `call_context_instructions` only on
`wasm32-unknown-unknown`, using the safe ic0 1.2.0 binding, which explicitly uses
`std`. `unsafe_code = "forbid"` is unchanged. Attribution, counter identity,
replication, reset/persistence policy, labels, lifecycle and endpoints remain
consumer-owned. Native builds have no shared counter or substitute. See the
[extraction contract](../extraction.md).

## Release identity

The maintainer committed and tagged 0.1.5 at
`bb28e217c5b3069715c1a58322b7900bec7fbb84`; Cargo metadata is 0.1.5. The official
crates.io sparse index records a non-yanked release with Rust 1.88 minimum and
optional target-specific ic0. The downloaded archive checksum
`93e1e69de216c78594571678fea2531cded9d586e9c2e23b3131539b4cc302c4`, embedded
Git identity, Rust library sources and license match the tag. A registry-dependent
fixture with `ic` passes locked offline Rust 1.88 host and Wasm compilation using
this repository's target. These are package/build checks, not new IC measurements.

The exact-release [CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37370018375)
passed both macOS native gates and Linux MSRV. Its first Linux native job was
cancelled without a runner or repository steps; GitHub's annotation reports that
the job was not acquired after multiple attempts. A targeted job retry passed
the complete Ubuntu native gate, completing all declared host/MSRV qualification
for the exact 0.1.5 source. This configured-CI result does not relabel previous
evidence or qualify the later documentation worktree; see [host support](../hosts.md).
The public repository description still accurately describes shared measurement
primitives; no metadata write was needed.

The [changelog](../../CHANGELOG.md) preserves finalized 0.1.5 and opens one
undated, compatible 0.1.6 entry for published reader adoption, descriptive metadata
expanded query execution qualification and explicit pinned PocketIC CI execution.
There is no new core Rust API change or package-version mutation. Publication
remains separate from Git releases: `make publish` uploads the current package;
`make publish-check` is an upload-free dry run. Commits and release commands remain
maintainer-owned. No agent commit, tag, push or upload occurred.

## Consumer reader adoption

All three named primary consumers now select registry ic-metrics 0.1.5 with
feature `ic` and use the shared reader on Wasm. Native zero remains local to
IcyDB/Canic; IC Timers retains its existing non-Wasm production binding and
its test fake. Inclusive IcyDB spans, exclusive Canic endpoints, timer callback
roles/registration identity, saturation, measured-zero and report shapes remain
local and unchanged. No sibling-path fallback was introduced.

Canic's reader-adoption batch has native and Wasm Core library Clippy passing
with warnings denied, plus all four endpoint-accounting tests. Formatting ran
before validation and preserved concurrent release-flow fixture edits. Only the
metrics lock entry changed; package versions and other dependency selections
are preserved. Its [handoff](/home/adam/projects/canic/docs/status/current.md)
scopes the results separately from concurrent release-script/fixture repairs.
The maintainer committed the 0.110.53 batch at
`05707b8c06f658297915c96c4727a8accf98dbdc`; that commit does not relabel the focused
reader checks as complete release or hosted qualification.

IC Timers' exact reader source passed native/Wasm library Clippy, Rust 1.88
Wasm compilation and four named measurement/completion/identity/abandonment
regressions while its package still identified as 0.13.0. The maintainer committed
that source and selected 0.13.1 at `54bbcfc`; the release commit changed metadata
only. Both independent locked graphs select one registry metrics package. All
other external selections are preserved; the local timer package version changed
only through the maintainer's release. Its [handoff](/home/adam/projects/ic-timers/docs/status/current.md)
records the distinction between these native-substitute results and complete
owning PocketIC/release/hosted qualification.

Fresh hosted inspection of IC Timers 0.13.1 finds the Linux checks successful,
both macOS release gates failing at the fixture's logical-versus-physical cache
path comparison, and MSRV/tag jobs cancelled before obtaining runners. The
owning workflow subsequently committed the repository-only 0.13.2 fixture fix and
alias coverage, with release commit `134899f`. Its native rerun remains separately owned; this extraction workflow
did not duplicate or qualify that concurrent repair.

IcyDB was initially running its maintainer release gate. An isolated worktree at
`/tmp/icydb-reader-015-worktree`, based on `43a66e10a` and package version
0.264.10, passed metrics-enabled native/Wasm strict Core Clippy and all nine
metrics-state tests. Its selected cache initially lacked the new index entry;
explicitly fetching the locked registry fixture into IcyDB's designated Cargo
home resolved that failure without upgrading other dependencies. Copied owned
artifacts were retained in the worktree's own target directory; package-cache
contention occurred but no primary source or build directory was disturbed.

The maintainer then released 0.265.0 at `6b6b5edb7`. After primary source,
clean-tree, process and lock checks, the reader/dependency migration was applied
there, with new 0.265.1 notes preserving all finalized history. Package versions
and every other lock record remain unchanged. Primary native/Wasm strict Core
Clippy and all nine selected state tests pass at 0.265.0, supplying their own
results rather than relabelling the earlier isolated package evidence. Its
[adoption record](/home/adam/projects/icydb/docs/governance/shared-tooling.md)
contains the current qualification details.
The maintainer committed the 0.265.1 batch at
`20a9aa7d9802cf73ad17ed9444fc06a2c37e2909`; the earlier focused qualification
remains scoped to its actual package and inputs.

Follow-up and owning release/CI coordination remain in
[reader extraction #3](https://github.com/dragginzgame/ic-metrics/issues/3),
[publication #4](https://github.com/dragginzgame/ic-metrics/issues/4),
[IcyDB #298](https://github.com/dragginzgame/icydb/issues/298),
[Canic #447](https://github.com/dragginzgame/canic/issues/447) and
[IC Timers #9](https://github.com/dragginzgame/ic-timers/issues/9).
The reader issue now records the published prerequisite and explicit safe-binding
resolution. Consumer review findings are tracked by
[Canic #451](https://github.com/dragginzgame/canic/issues/451) for redundant sorting
and [Canic #321](https://github.com/dragginzgame/canic/issues/321) for bounded label
admission and projected metrics availability.

## Core evidence and shared tooling

The [execution record](../evidence/ic-reader.md) preserves pre-release source,
lock/server/Wasm identities and actual PocketIC instruction readings, including
replicated callback continuity. Its recorded package metadata was 0.1.4; release
verification established identical library source in published 0.1.5. It does
not qualify composite queries, consumer lifecycle behavior, native timing or a
performance improvement.

The separate [query execution record](../evidence/ic-reader-query.md) binds the
expanded pending 0.1.6 fixture to its exact source, server, lock and artifacts.
Linux PocketIC 16.0.0 execution passes ordinary query bracketing and composite
callback continuity. The caller's measured interval remains 584,958 instructions
while downstream work increases from 438 to 10,000,455 instructions. Each delta
uses one established local context; the comparison is between completed intervals,
not absolute snapshots from unrelated identities. Reader library sources and
dependency selections matched published 0.1.5 at that qualification. No new consumer IC measurements or
broad local gate ran; macOS execution of the expanded fixture remains unqualified.

The reviewed Shared Tooling snapshot remains
`f52c0e2476aee094359ed21de91c468540d3969f`, with 20 declared files. Snapshot-owned
files were not patched. Formatting uses pinned cargo-sort 2.1.4 before Rustfmt;
root and child dependency declarations inherit from the workspace catalog.
The standard repository hook is enabled in this clone; hook activation remains
separate from independent formatting and CI qualification. Standard SemVer release
entry points use the shared runner, preserve artifacts and reconcile interrupted
same-kind intent. None was invoked by the agent.

Earlier arithmetic, packaging, tooling-fixture and failed-attempt observations
remain retained in the immutable [0.1.5-tagged handoff](https://github.com/dragginzgame/ic-metrics/blob/v0.1.5/docs/status/current.md),
[host record](../hosts.md), extraction contract and linked issues. That historical
handoff's pre-release version and consumer statements do not describe this worktree.

The earlier 0.1.6 fixture and CI-preparation inputs pass snapshot verification, manifest/Rust formatting,
warning-denied host/Wasm Clippy, warning-denied API documentation, Rust 1.88 Wasm
example compilation and the single named PocketIC reader test covering updates,
queries and callbacks. A locked offline development package verifies successfully;
the earlier extracted IC-feature library also passes Rust 1.88 Wasm compilation.
That development archive still identifies as 0.1.5 and contains the pending README;
it is not another registry release. The package description includes the opt-in
reader. Library runtime source and package versions are unchanged; Rust changes
are confined to the qualification fixture and harness. Those checks used the
original ic-testkit 0.17.3 lock selection.
No full local test/CI gate was run.

The pending native CI matrix now provisions PocketIC 16.0.0 explicitly after the
native gate, prepares locked dependencies and runs `make reader-check` offline on
Linux and both macOS architectures. Always-run retention steps preserve outcomes,
logs, source/lock/server/harness hashes and the Wasm fixture as per-host 30-day
artifacts. Ordinary local tests and `make ci` retain their existing opt-in boundary.
The snapshot checksum helper is reused without changes; the installer and its
rejection fixture are consumer-owned.

Actions lint, ShellCheck and focused rejection fixtures pass. A real Linux
download initially passed archive verification but failed its version invocation
because PocketIC requires the executable basename `pocket-ic` or `pocket-ic-server`.
The helper now uses that required basename in a fresh directory. The corrected
download and exact workflow execution/retention shell steps pass locally, including
the query cases. A controlled failed reader command also retains its nonzero exit,
log and failure outcome through the pipeline. These substitute rejection checks
are not IC measurements. See the [CI preparation record](../evidence/reader-ci.md)
for inputs and retained attempts. Hosted workflow execution, macOS runtime behavior
and Actions artifact upload await maintainer commit/push and configured CI;
this local execution does not qualify them. Follow-up remains in reader issue #3.

A subsequent maintainer-side development dependency update selects ic-testkit
0.18.2 through the root `0.18` requirement and want 0.3.2 in Cargo.lock. These
existing working edits were preserved; the agent did not change dependency or
package versions. Strict locked offline host Clippy, Rust 1.88 compilation of the
named reader harness and actual Linux PocketIC execution pass on this graph. The
development package also verifies offline; formatting and snapshot checks pass.
Instruction readings and fixture Wasm are unchanged. The [query execution record](../evidence/ic-reader-query.md)
retains both sets of inputs and distinct harness/log identities, rather than
relabelling the earlier dependency evidence. This development-only update leaves
the compatible pending 0.1.6 selection and the production API unchanged.
