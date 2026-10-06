# Current handoff

ic-metrics owns allocation-free sample arithmetic and the optional IC
call-context instruction reader. Default arithmetic stays dependency-free and
`no_std`. Feature `ic` exposes `call_context_instructions` only on
`wasm32-unknown-unknown`, using the safe ic0 1.2.0 binding, which explicitly uses
`std`. `unsafe_code = "forbid"` is unchanged. Attribution, counter identity,
replication, reset/persistence policy, labels, lifecycle and endpoints remain
consumer-owned. Native builds have no shared counter or substitute. See the
[extraction contract](../extraction.md).

## Shared Tooling adoption after 0.1.7

The maintainer released 0.1.7 at
`adf9c3f5676b8ce7983fe2f35724c800d1b00a59`; the local tag and package metadata
agree, and the public registry index confirms a non-yanked 0.1.7 with Rust 1.88
minimum. Its index checksum is
`9e8632a16ca69a8a9ab1fd4daa276f7739d9996bd970373992e6c97087a04378`.
This index observation does not claim a separately verified archive or hosted
0.1.7 run. The release and earlier evidence below retain their original scope.

A subsequent issue-closeout review observed the exact 0.1.7 source in
[CI run 37441090866](https://github.com/dragginzgame/ic-metrics/actions/runs/37441090866),
attempt 1. Linux, macOS Intel, macOS Apple Silicon and Linux MSRV jobs all
succeeded. Each native job executed the PocketIC reader qualification and
uploaded its evidence successfully. This is workflow/job evidence; this review
did not independently download or verify the 0.1.7 artifacts. Runtime library
source is unchanged from 0.1.5. These results qualify the tagged source, not the
uncommitted 0.1.8 tooling below or the consumer worktrees.

At adoption, the clean Shared Tooling checkout and its remote HEAD identified reviewed
`a7efade1a68e43f148252a1a73908a46c4cbe9e9`. Its distribution helper refreshed
27 declared files, including pinning and agent-maintenance rules, the checker,
parser installer, updated hook and release runner, and validation logger.
Snapshot-owned files were not patched. Local AGENTS and the consumer adapters
apply the new contract; ordinary CI/issue inspection remains distinct from repair.

CI and release gates now invoke the offline declaration checker with explicitly
prepared Git/jq/yq. Consumer parser versions/digests live in `ci/tool-versions.env`.
Development registry requirements are compatible; the optional exact ic0 1.2.0
constraint documents its existing qualified IC boundary. The pre-existing dirty
ic-testkit 0.18.3 lock selection is preserved byte for byte. No dependency upgrade,
runtime Rust change or package-version mutation belongs to this adoption.

Release preflight checks staged and unstaged paths independently and validates
the pending candidate before fetching or validation. Commit admission checks the
entire allowed index against prepared metadata. Late checks read metadata from
`RELEASE_COMMIT`; normal commands use the shared reconciliation behavior before
fresh validation for newer fixes. The actual release gate retains failed raw logs
outside release inputs, including temporary-log fallback if retention fails.
Independent fixtures isolate their Make/logger inputs while normal nested gates
retain release selections.

The compatible next draft is 0.1.8 from finalized 0.1.7: it strengthens tooling
and admission without changing the library API or consumer measurement contracts.
Package metadata stays 0.1.7. Linux snapshot verification, checksum/version-checked
parser setup, pin declarations and rejection fixtures, manifest/Rust formatting,
locked offline metadata, ShellCheck and workflow lint all pass. Release-runner
stubs, the consumer Make/publication adapters, preparation/rollback fixtures,
real Git admission/selected-commit checks and hook fixtures pass. The actual
Make/logger fixture verifies CI-before-MSRV ordering, fail-fast behavior, retained
first/second-gate failures, retry retention and temporary-log fallback.

The release/hook fixtures also pass through the actual logger in a distinct parent
checkout under inherited `RELEASE_VERSION=9.8.7` and a parent commit selection.
No parent gate was dispatched. Evidence and source/input identities remain in
`target/evidence/shared-tooling-a7efade/`; substitutes are identified in the logs.
These are focused Linux tooling/metadata results, not runtime qualification of
the preserved development dependency update or a native macOS pass for this batch.
Hosted Linux/macOS adoption qualification remains pending the new committed
source's configured CI. No full local gate, commit, tag, push or publication ran.

The downstream review set now includes IcyDB, Canic, ic-timers and ic-backup.
IC Backup's pending host integration selects registry 0.1.7 without the IC reader,
using guard-local summaries for nanosecond durations and prepared chunk bytes.
Its source/tests were reviewed read-only; no consumer command or edit ran here.
The [extraction contract](../extraction.md#downstream-contract-checks) records
the distinct qualification obligations and the prepared adoption's source scope.
This documentation extends the compatible 0.1.8 batch without changing core APIs,
package versions or qualification of consumer releases.

## Earlier release identity and 0.1.7 preparation

The maintainer committed, tagged and pushed 0.1.6 at
`6cf2c3851019b1e989e42c5f79a4845ae911dc7f`; Cargo metadata is 0.1.6. The crates.io
sparse index separately confirms a non-yanked release with Rust 1.88 minimum.
The downloaded archive checksum is
`30fa04fd11a6f844355ed8016f3df7d923d057325db9c3089f11246cacb1ff82`.
Embedded Git identity, every Rust library/fixture source, README and license
match `v0.1.6`. Library runtime source also matches 0.1.5. A separate registry
consumer requiring exactly 0.1.6 passes locked offline Rust 1.88 host and Wasm
compilation, with default arithmetic and with feature `ic`, using this
repository's target. These are build checks, not new IC measurements.

The exact 0.1.6 [CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37431032911)
passed Linux MSRV and the complete native gate, pinned PocketIC execution,
rejection checks and artifact upload on Ubuntu, Intel macOS and Apple Silicon
macOS. All four jobs succeeded on attempt 1. All three downloaded artifact ZIP
digests, captured source hashes and log/Wasm identities were verified independently.
See the [release record](../evidence/release-016.md) for source-bound evidence.
The published-release qualification is also recorded in
[reader issue #3](https://github.com/dragginzgame/ic-metrics/issues/3#issuecomment-6011950984).

The earlier 0.1.5 [CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37370018375)
passed both macOS native gates and Linux MSRV. Its first Linux native job was
cancelled without a runner or repository steps; GitHub's annotation reports that
the job was not acquired after multiple attempts. A targeted job retry passed
the complete Ubuntu native gate, completing all declared host/MSRV qualification
for the exact 0.1.5 source. This configured-CI result does not relabel previous
evidence or qualify the later documentation worktree; see [host support](../hosts.md).
The public repository description still accurately describes shared measurement
primitives; no metadata write was needed.

The [changelog](../../CHANGELOG.md) preserves finalized 0.1.6 and opens one
undated, compatible 0.1.7 documentation entry. README shows the platform-gated
Rust reader import beside the opt-in dependency, addressing the native lint/Candid
build clarification in [reader issue #3](https://github.com/dragginzgame/ic-metrics/issues/3#issuecomment-6011590931).
It identifies published 0.1.6 while retaining the reader's actual 0.1.5 floor.
README also links the separate consumer lookup measurements and explains their
first-insertion tradeoff. Those changes belong to consumer code; upgrading this
crate alone does not apply them. Core source review and the existing compiler
probes establish no further useful arithmetic or reader optimization for 0.1.7.
There is no new core Rust API change or package-version mutation. Publication
remains separate from Git releases: `make publish` uploads the current package;
`make publish-check` is an upload-free dry run. Commits and release commands remain
maintainer-owned. No agent commit, tag, push or upload occurred.

The current documentation batch passes manifest/Rust formatting, snapshot
verification, warning-denied host/Wasm documentation and locked offline package
verification. Its development archive still identifies as 0.1.6 and contains
the pending README; it is distinct from the verified published archive above.
Finalized changelog history, library sources, package versions and repository
dependency selections are preserved. No full local test/CI gate ran.

## Consumer reader adoption

The subsequent [consumer lookup record](../evidence/consumer-lookups.md) covers
authorized primary IcyDB/Canic implementation. Borrowed lookups allocate keys
only on insertion; Canic also uses its map's existing report order. Public keys,
reports, zero/saturation/reset contracts and attribution functions are preserved.
Repeated-key probe work uses about 53–60% fewer instructions; new-key work costs
about 71% more in IcyDB and 85% more in Canic. Canic's isolated fixture loses
3,698 raw Wasm bytes; IcyDB's isolated recorder fixture gains 207 bytes. These
are actual local IC fixture results, not whole-consumer savings.

Focused native/Wasm strict Clippy and 15 selected tests pass; Canic's Rust 1.91
Wasm check passes. Consumer notes extend compatible 0.265.1 and 0.110.53 drafts;
package versions, root lock selections and unrelated dirty work are preserved.
The async probe confirms both interleaved endpoint totals fall outside their own
IC intervals; [Canic #99](https://github.com/dragginzgame/canic/issues/99#issuecomment-6012668977)
records that defect. Attribution was verified, not repaired. No sibling commit,
push, release or broad gate ran. ic-metrics itself still has only documentation
changes under pending 0.1.7; IC Timers was not changed in this batch.

The [performance audit](../evidence/performance-audit.md) records Linux compiler
probes and actual PocketIC execution for the unchanged 0.1.6 reader canister.
Strip/re-encode reduces its raw Wasm from 704,146 to 524,154 bytes; adding Binaryen
`-Oz` yields 469,706 bytes. All three artifacts pass the named reader cases.
Three measured updates per artifact show identical baseline/stripped charges
and roughly 0.08% lower charges with `-Oz`; these are local fixture observations,
not consumer or mainnet savings. Shared reader/arithmetic probes inline without
extra library calls at optimization levels `3` and `z`. No core or consumer Rust
was changed. The compatible pending 0.1.7 remains a documentation batch.
Source-only repeated-label allocation findings are tracked in
[IcyDB #300](https://github.com/dragginzgame/icydb/issues/300) and
[Canic #456](https://github.com/dragginzgame/canic/issues/456). Current generated
async-wrapper evidence was added to [Canic #99](https://github.com/dragginzgame/canic/issues/99).
No sibling was modified or compiled for this audit.

The initial reader adoption selected registry ic-metrics 0.1.5 with feature `ic`
in all three named consumers. All use the shared reader on Wasm; IcyDB's lock
selects 0.1.6 in the subsequent lookup record above. Native zero remains local to
IcyDB/Canic; IC Timers retains its existing non-Wasm production binding and
its test fake. Inclusive IcyDB spans, exclusive Canic endpoints, timer callback
roles/registration identity, saturation, measured-zero and report shapes remain
local and unchanged. No sibling-path fallback was introduced.

A read-only recheck after the 0.1.6 push confirms all three Wasm reader calls and
root requirements remain in place. Their `0.1.5` requirements admit compatible
0.1.6 without a forced floor change. IcyDB is at `20a9aa7d9802cf73ad17ed9444fc06a2c37e2909`
with concurrent dirty publication/workflow/canister changes; Canic is clean at
`e1a211a00f01568ccc99bedc494c62a7141444dd`; IC Timers is at
`864397a7c21eec4f396fe9617dbb8d8e1f9cfc73` (`Release 0.13.3`) with concurrent dirty
shared-tooling/release work. No sibling was modified or compiled. The focused
adoption histories below remain scoped to their original inputs, rather than
qualifying complete later releases or those concurrent changes.

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

Earlier hosted inspection of IC Timers 0.13.1 found the Linux checks successful,
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
expanded pre-release 0.1.6 fixture to its exact source, server, lock and artifacts.
Linux PocketIC 16.0.0 execution passes ordinary query bracketing and composite
callback continuity. The caller's measured interval remains 584,958 instructions
while downstream work increases from 438 to 10,000,455 instructions. Each delta
uses one established local context; the comparison is between completed intervals,
not absolute snapshots from unrelated identities. Reader library sources and
dependency selections matched published 0.1.5 at that qualification. No new consumer IC measurements or
broad local gate ran for that pre-release evidence. Hosted qualification is now
recorded separately under the exact 0.1.6 release above.

The earlier reviewed Shared Tooling snapshot recorded
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

The released 0.1.6 native CI matrix provisions PocketIC 16.0.0 explicitly after the
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
for inputs and retained attempts. Those local checks did not qualify hosted
execution. The new release record separately records observed hosted results;
all three hosts' reader execution and artifact upload passed on the release tag.
The local preparation evidence retains its original scope. Follow-up stays in
reader issue #3.

A subsequent maintainer-side development dependency update selects ic-testkit
0.18.2 through the root `0.18` requirement and want 0.3.2 in Cargo.lock. These
existing working edits were preserved; the agent did not change dependency or
package versions. Strict locked offline host Clippy, Rust 1.88 compilation of the
named reader harness and actual Linux PocketIC execution pass on this graph. The
development package also verifies offline; formatting and snapshot checks pass.
Instruction readings and fixture Wasm are unchanged. The [query execution record](../evidence/ic-reader-query.md)
retains both sets of inputs and distinct harness/log identities, rather than
relabelling the earlier dependency evidence. This development-only update leaves
the compatible 0.1.6 selection and the production API unchanged. The original
pre-release handoff is retained in the immutable
[0.1.6-tagged record](https://github.com/dragginzgame/ic-metrics/blob/v0.1.6/docs/status/current.md).
