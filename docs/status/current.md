# Current handoff

ic-metrics now owns allocation-free measurement arithmetic only. Published
**0.2.0** removes the public `call_context_instructions` function and `ic` feature.
`record_sample`, `MeasurementSummary`,
zero/empty and saturation semantics are unchanged. Consumers own counter reads,
attribution, identities, persistence and endpoints. The library is dependency-free
and `no_std` on host and Wasm. See the [current contract](../extraction.md).

## Current release and compatible 0.2.1 cleanup

Tag `v0.2.0` identifies source `8657c35e441a0f2e6add7f784892e85c9b5e1117`.
The non-yanked registry package has SHA-256
`e6df432373e44c1956cbaa15548625efbebdbad4070a916e9fe0c7e4359f6265`;
the downloaded archive's embedded source, original manifest, README, license
and arithmetic source match that tag. Runtime and development dependencies and
feature declarations are empty. Archive evidence remains under
`target/evidence/release-020/`. Exact-source
[CI run 37461297392](https://github.com/dragginzgame/ic-metrics/actions/runs/37461297392)
passes all three native hosts and MSRV.

The maintainer reports downstream adoption. Read-only manifest/lock inspection
finds registry ic-metrics 0.2.0 in IcyDB and Canic's current worktrees, both with
IC Timers 0.14.0. Those dependency edits remain uncommitted among concurrent
work. IC Timers release 0.14.0 (`902323a`) selects 0.2; IC Backup release 0.3.9
(`2587259`) still selects arithmetic-only 0.1.9. Consumer source/graph observations
do not establish complete owning release/CI qualification or a cost improvement.
[Adoption #10](https://github.com/dragginzgame/ic-metrics/issues/10) retains those
owning obligations; no sibling is changed by this cleanup.

The single undated pending changelog is **0.2.1**: fixture failure evidence and
portable documentation are compatible tooling fixes, with no arithmetic API or
sample-semantics change. Failed release, metadata and hook fixtures retain inputs
and outputs, print their scratch paths and return their original failure status.
Release and formatter prerequisite checks now inspect producer exit status before
comparing output: valid-looking output from a failed command cannot advance a
release. Failed selected-commit checks retain exported metadata and report its
path; successful checks remove only their owned scratch. Preparation still
restores the original metadata when its final version reader fails.
The retention check runs real fixtures with controlled child/assertion failures
and also verifies successful scratch cleanup; its evidence is uploaded by the
existing native CI artifact owner. Linux passes all twelve scenarios, shell syntax
and selected ShellCheck. Native macOS qualification remains owning configured CI
work under [#7](https://github.com/dragginzgame/ic-metrics/issues/7).
Documentation portability is tracked in
[#9](https://github.com/dragginzgame/ic-metrics/issues/9).
Package versions remain 0.2.0; no commit or release is selected by these notes.

## Shared Tooling 0.1.8 adoption

The current snapshot is reviewed commit
`d957d1f8801885c5b69e4a9ef900155f5f2a8a9d`, exported through the upstream
distribution helper from a clean detached checkout. All 50 declared files verify.
The previous snapshot was verified and differing snapshot-owned bytes backed up
before reconciling the earlier unfinished refresh; unrelated edits and the real
index were preserved. Refresh inputs/logs remain under
`target/evidence/adoption-018/`.

`make hook-check` now delegates to the committed shared checker with explicit
Rust/manifest/formatter inputs and `--no-dependency-tables`. The local adapter
retains its pinned formatter prerequisite and nested failure diagnostics; its
duplicated export and hook cases are retired. The shared checker preserves
formatting, idempotence, partial Rust/manifest staging, failed-formatter isolation,
locks, unrelated edits and installer alias/conflict behavior. The retention
fixture follows the shared exports and verifies failed expected/actual inputs.
`make check-pins` additionally selects the shared Cargo inheritance checks.

Focused native Linux hook checks, Bash 3.2.57 retention scenarios, Cargo inheritance
fixtures, metadata preparation/restoration, release admission, formatting,
workflow/ShellCheck lint, document links and snapshot checks pass. The upstream
[0.1.8 CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/37484175750)
passes Linux and lint/security but fails both native macOS jobs between the IC
installer pass and host-installer completion; no precise failed assertion is
established by the public log. Those logs are retained separately. This snapshot
adoption does not establish native macOS consumer qualification; owning evidence
remains in [#7](https://github.com/dragginzgame/ic-metrics/issues/7) and
[#11](https://github.com/dragginzgame/ic-metrics/issues/11). The compatible pending
release remains 0.2.1; package version, lockfile and library source remain 0.2.0.

## Earlier 0.2.1 helper preparation

Shared Tooling was refreshed from a clean, detached checkout of reviewed commit
`9f8c7c768793f4ce8f25be9e88282c0f63a06e7f`. The expanded 49-file snapshot verifies;
it adds the helper guide, referenced tag-maintenance guide, documentation-link
checker, release-command checker and local-lockfile transformer. Tag deletion
tooling is not adopted or executed. Release-command routing now uses the shared
checker, while publication and admission/recovery remain local. Preparation
transforms a retained lockfile candidate, checks its status before replacement,
and restores files while retaining failed preparation evidence. The affected
metadata/admission fixtures, host/IC installer fixtures, checksum fixtures and
dependency pins pass on Linux. `make check-doc-links` covers the maintained
Markdown roster: 134 local references across 40 documents, including newly
adopted files. The five new public link destinations are verified through GitHub;
Canic's historical handoff remains represented by its public owning issue because
its local commit is unavailable through GitHub at this inspection.

Upstream [CI run 37479591040](https://github.com/dragginzgame/shared-tooling/actions/runs/37479591040)
passes Linux portable regressions and lint/security; both native macOS jobs
subsequently failed after the IC installer fixture and before the host installer
fixture reported success. The public log does not establish the exact failed
assertion. The host installer fixture passes under GNU Bash 3.2.57 on Linux;
that does not reproduce or qualify the native macOS failure.
This does not qualify the changed consumer source.
The formatting-hook helper in that revision requires an ordering-only unsorted
dependency table. This crate has no dependency tables, so the local real-target
hook fixture remains necessary. That adoption constraint stays in
[#11](https://github.com/dragginzgame/ic-metrics/issues/11) and upstream
[#16](https://github.com/dragginzgame/shared-tooling/issues/16).
Refresh/check logs and the pre-refresh snapshot remain under
`target/evidence/cleanup-021/`; the first rejected additional snapshot lacked
required verifiers and changed no helper files. The successful expanded refresh
uses the complete roster and preserves the consumer's unrelated edits.

The #7 follow-up corrects CI evidence ownership: native validation creates its
TMPDIR under the uploaded evidence tree, includes hidden scratch Git state in
the artifact and records release/hook/helper inputs with the source roster.
The actual revised native step passes a controlled failing Make gate under GNU
Bash 3.2.57: status 43, the log and both ordinary/hidden fixture inputs survive.
The eleven retention scenarios also pass under that shell on Linux. Workflow
lint passes. No new native macOS consumer result is claimed; #7 remains open for
that owning qualification after the maintainer commits the batch.

For #11, the maintainer authorized and the agent applied the four-file upstream
patch retained under `target/evidence/issues-021/shared-hook-proposal.patch`.
It adds explicit
`--no-dependency-tables` selection to the shared checker, omitting only dependency
order perturbation while preserving real fmt/fmt-check, partial Rust/manifest
staging, idempotence, lock/unrelated-edit preservation, formatter failures and
installer checks. The applied helper passes against this actual dependency-free
consumer under GNU Bash 3.2.57 on Linux; the upstream real-Cargo hook fixture also
passes both selected modes. Selected and full required upstream ShellCheck pass.
The applied portable suite passes through hook qualification, then stops at
its missing cloc prerequisite; its log is retained. The upstream checker, its
real-Cargo fixture, helper guide and changelog were patched without disturbing
concurrent upstream work. This fix remains uncommitted, so it is not adopted in
the consumer snapshot. Source commit and native qualification remain
maintainer/CI-owned. Logs, inputs and rejected
attempts remain under `target/evidence/issues-021/`.

## Earlier arithmetic-only 0.2.0 preparation

The following preparation observations precede the publication and adoption
updates above; their source identities and qualification scope are preserved.

The reader module, canister example, host harness, their dependency catalog and
`make reader-check` are retired. Native CI retains common pinned tool setup and
source/outcome/log artifacts without executing a reader fixture. Historical
reader reports and release evidence are preserved, including the
[frozen pre-cut extraction record](../evidence/extraction-through-019.md).
The before-cut manifests include a concurrent ic-testkit 0.19 update; removing
that graph is deliberate harness retirement, not qualification of the update.

IcyDB/Canic adapters and IcyDB audit/test callers use the existing named CDK
counter-1 API; IC Timers uses its existing ic0 counter-1 binding. Their native
handling, inclusive/exclusive/role attribution, sample admission and reports
stay unchanged. Consumer registry arithmetic requirements remain 0.1 until 0.2
publication. Published IC Timers 0.13.5 still requests the old `ic` feature
transitively in IcyDB/Canic; direct consumer declarations no longer request it.
IC Timers publication removes that remaining feature edge. Subsequent shared
summary re-exports need coordinated 0.2 type identity, tracked in #10. IC Backup
already uses arithmetic-only summaries. Preparation and owning adoption are
coordinated in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) and
[#4](https://github.com/dragginzgame/ic-metrics/issues/4).

Package versions remain unchanged. No commit, push, release or publication ran.
Focused Linux validation passes: six unchanged arithmetic tests, strict host/
Wasm lint, warning-denied docs, Rust 1.88 host/Wasm checks, formatting, the 44-file
snapshot, dependency pins, workflow lint and verified offline development
packaging. The actual revised CI shell blocks preserve a controlled failed-gate
exit, log and outcome; the metadata fixture passes with Cargo-edit/Git substitutes.
No full local test/CI/release gate ran. New hosted qualification remains separate.

IcyDB passes strict Core metrics library/tests lint, ten named state tests and
strict library lint for thirteen selected Wasm packages/twelve native callers.
The first Wasm attempt exposed incomplete child-module reader renames; its log
is preserved separately from the corrected passes. IC Timers passes strict
host/Wasm library lint, two named role/projection tests and both independent
locked/offline metadata checks. Canic passes strict Core host/Wasm lint, eight
native performance tests and its exact governed PocketIC interleaving case in
both completion orders. Current IcyDB/Canic graphs select ic-memory 0.28.0 and
ic-testkit 0.19.0 from concurrent work; those selections were preserved, with
explicit offline preparation from already verified local archives where needed.
IC Timers' independent graph selections remain unchanged. Qualification input
hashes match after execution. These are focused proofs, not complete consumer
release/native CI or a cost comparison. A later Canic fixture/PocketIC dependency
edit was qualified separately with strict fixture host lint and the same governed
IC case; five new input hashes match after execution. Its admitted Wasm cache was
reused. A rejected direct fixture Wasm check remains recorded; the canonical build
guard was not bypassed. See the
[preparation record](../evidence/arithmetic-cut-020.md) and retained inputs/logs
under `target/evidence/arithmetic-cut-020/`.

[#8](https://github.com/dragginzgame/ic-metrics/issues/8) is resolved by deleting
the retired harness graph; #10 retains publication/type-identity/adoption
coordination. Package versions remain maintainer-owned. GitHub's repository
description, “Shared measurement primitives for Internet Computer crates.”,
remains accurate for this narrower worktree and the published release.

## Released 0.1.9

The maintainer published 0.1.9 at tag `v0.1.9`, commit
`083254a6a7c24f1e07d1e952a867059746f6feb5`. The non-yanked registry index and
downloaded archive agree on SHA-256
`14478c4b7c31f0b9ac3226cd33056d273b8488dc5cb8820b13e64dff171ded65`.
The archive's embedded Git identity, original manifest, README, license, library
source, example and reader harness match the tag. Normalized package metadata
reports edition 2024 and Rust 1.88. Archive comparison evidence remains under
`target/evidence/release-019/`; it is publication/source evidence, not a new build
or runtime qualification. Runtime library source is unchanged from 0.1.8.

The exact-source [CI run 37452356472](https://github.com/dragginzgame/ic-metrics/actions/runs/37452356472)
has passed MSRV and all three native jobs: Ubuntu 24.04 x86-64, macOS 15 Intel
and macOS 15 Apple Silicon. Each completed the native gate, local host/IC setup,
actual PocketIC reader execution and evidence upload. All three artifact ZIPs,
their bundled logs/Wasm, 21 source hashes per host and IC pins were independently
verified against the tagged source and retained manifests.
The harness/server binary bytes are not bundled; their recorded hashes were not
independently recomputed from CI binaries. This completes the supported-host
adoption proof for [release recovery #5](https://github.com/dragginzgame/ic-metrics/issues/5)
and [local tool adoption #6](https://github.com/dragginzgame/ic-metrics/issues/6).
Recovery fixtures retain their command-substitute/real-Git scope; no live
interrupted-release or deployment behavior is inferred from those passes.

Shared Tooling's committed local HEAD and remote main still identify the adopted
`a37771f1b6b5fc9a88ed6ab3b705bdda35cd8fa3`; the 44-file snapshot verifies.
Its local checkout now contains uncommitted documentation-link, release-command
and exact registry-version helpers. None has been distributed into this snapshot;
the adopted rules and tooling retain their reviewed committed identity.
Fresh locked offline Linux checks used the current IcyDB and Canic graphs,
both selecting registry ic-metrics 0.1.9 and ic-memory 0.27.3. Logs, locked
metadata and before/after input hashes remain in `target/evidence/consumer-review-019/`.
IcyDB's metrics-enabled strict Core Clippy and ten selected state tests passed
on the then-0.265.0 manifest, based on `1f4737a9486fa2d0fb0f72927c92b15b6da4d0d4`.
Its owning Cargo home and `target/icydb` were used. A subsequent Wasm Clippy pass
overlapped a newly started maintainer release; that mistake is retained in
`icydb-overlap.txt`, and the check is not exclusive release-gate evidence.
The measured source and lock hashes stayed unchanged. The maintainer then
completed a clean 0.265.1 checkout at `84fa00fd4a765f9bdcd6e587f6598b0725a63da5`;
that newer revision has no matching hosted run in the observed listing.

Canic's uncommitted batch based on `e1a211a00f01568ccc99bedc494c62a7141444dd`
passed strict selected Core/macros/facade/internal-test Clippy, eight Core perf
tests, fifteen expansion tests and the public facade checkpoint test. The governed
`interleaved_endpoint_and_checkpoint_metrics_preserve_call_contexts` PocketIC
case also passed against actual IC counters in both completion orders, with
source/manifest/lock hashes unchanged. This requalifies the
[async attribution fix #99](https://github.com/dragginzgame/canic/issues/99)
on lock SHA-256 `2fa2330bfac3a441eb4b9f9492fc1a63cb88c97beec6398b34ab842708e5d60e`;
earlier child-lifecycle evidence retains its older dependency graph.
Direct Core instrumentation changes require a minor release. The selected Canic
0.110.53 patch remains incompatible; its exact 0.110 human closeout audit and
accepted verdict are required before crossing that boundary. Complete owning
native release/CI evidence remains separate, coordinated under
[consumer adoption #4](https://github.com/dragginzgame/ic-metrics/issues/4),
[IcyDB #298](https://github.com/dragginzgame/icydb/issues/298) and
[Canic #447](https://github.com/dragginzgame/canic/issues/447).
IC Timers remains a downstream consumer; its ongoing work was preserved.
IC Backup's metrics integration is now in release 0.3.7 at
`1a23d66dd65b1e36e986b8c7d13758cf3c92d193`, selecting arithmetic-only ic-metrics
0.1.7 in that committed graph. Its exact-source
[main CI](https://github.com/dragginzgame/ic-backup/actions/runs/37453307419) and
[tag CI](https://github.com/dragginzgame/ic-backup/actions/runs/37453307321)
have passed Linux and Apple Silicon; Intel macOS is still running at this
observation. The pending 0.3.8 worktree selects ic-metrics 0.1.9 with default
features disabled, preserving the same guard-local metrics source. This is not
the graph tested by those 0.3.7 runs. Read-only source/lock/CI evidence remains
under `target/evidence/downstream-review-019/`; see the
[downstream boundary](../evidence/extraction-through-019.md#ic-backup-host-adoption).
No IC Timers/IC Backup build commands, sibling source mutation or agent release
effect were performed.

This continuation records publication and qualification evidence. Finalized
0.1.9 notes are preserved; no new behavior/tooling batch or pending release is
selected by these evidence updates. Package versions and Cargo.lock stay 0.1.9.

## Earlier 0.1.9 tooling preparation after 0.1.8

The maintainer released 0.1.8 at
`1bcca2020a3190f5130d6279eeef997dc1bcba01`. Its non-yanked registry entry has
checksum `a2ac963f667122ad6bb64cee4380aa5bbd51fd585bde1d4dbd652a1247fe650b`
and Rust 1.88 minimum. This is index verification, not a separately downloaded
archive comparison. Package versions remain 0.1.8. The compatible next draft is
0.1.9 for CI prerequisites and local tooling; no library API, attribution or
measurement contract changes.

Exact 0.1.8 [CI run 37450502931](https://github.com/dragginzgame/ic-metrics/actions/runs/37450502931)
passed MSRV but failed native validation on all three hosts because the pin
fixture requires ripgrep and setup omitted it. Failed Linux/Apple Silicon job
logs remain in `target/evidence/ci-018/`. This batch explicitly prepares ripgrep
and xz through apt/Homebrew before fixtures, and uploads native CI logs/outcomes
even when validation stops before reader setup. The original failed run retains
its source identity; new hosted qualification requires the maintainer's committed
fix. [Release recovery #5](https://github.com/dragginzgame/ic-metrics/issues/5)
owns that remaining consumer proof.

The clean reviewed Shared Tooling source and remote HEAD identified
`a37771f1b6b5fc9a88ed6ab3b705bdda35cd8fa3`. Its distribution helper refreshed
44 declared files, including common host/IC setup, pins, checksum fixtures and
structural audit methods. No snapshot-owned file was patched. `make install-tools`
explicitly installs local jq/yq and Quill/ICP CLI/didc/ic-wasm/PocketIC/Binaryen;
`make tools-check` verifies both sets offline. Make/CI select the local paths.
The shared PocketIC 16.0.0 archive pins match the old qualified installer on all
three hosts. That local downloader and its obsolete fixture are removed; shared
tool fixtures cover rejection/retention, while the reader harness retains its
independently qualified raw-binary checksum and real execution contract.

Actual Linux installation of all eight binaries, checksum/version checks and
repeat setup with curl disabled pass. Shared tool/manifest rejection fixtures,
selected consumer release/hook fixtures, formatting, pin declarations, ShellCheck
and workflow lint pass. Source, inputs and logs remain under
`target/evidence/tooling-a37771f/`. These are consumer-local Linux results;
substitute platform fixtures establish mapping/refusal behavior, not native
macOS execution. [Local tool adoption #6](https://github.com/dragginzgame/ic-metrics/issues/6)
retains the complete consumer host qualification requirement.

Warning-denied locked offline host/reader-harness and Wasm library/example
Clippy pass with the unchanged ic-testkit 0.18.3 lock selection. The named
`make reader-check` passes against the newly installed local PocketIC binary,
covering replicated updates/callbacks, ordinary queries and composite-query
downstream exclusion. The first attempt failed because the sandbox denied a
localhost bind; that log remains alongside the successful socket-enabled retry.
No performance gain is claimed. An isolated execution of the workflow's actual
retention block also preserves a native-gate failure before reader setup,
including its source identity, raw log, outcome and artifact checksum. CI uploads
failed installer candidates separately when host or IC setup fails.

Upstream exact-source [CI run 37450707625](https://github.com/dragginzgame/shared-tooling/actions/runs/37450707625)
passes lint/security and portable regression on Linux, macOS Intel and Apple
Silicon. This qualifies the recorded upstream source, not this uncommitted
consumer wiring or a live release.

The shared audit definitions apply through this AGENTS overlay, the extraction
contract and host commands. The existing performance audit and consumer lookup
records remain unchanged domain evidence, with no structural score comparison,
new product audit or scheduled gate. This is definition/ownership adoption review.
The GitHub description still accurately identifies shared measurement primitives.

Root/library/fixture Rust and Cargo.lock are unchanged from the released source.
IcyDB/Canic's adopting local HEADs still have no matching hosted run; their owning
release/native qualification remains in [consumer adoption #4](https://github.com/dragginzgame/ic-metrics/issues/4).
No sibling source, version, commit, tag, push, workflow rerun/dispatch, publication
or cleanup was performed.

## Earlier 0.1.8 Shared Tooling preparation

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
are preserved. The handoff was inspected locally; public coordination in
[Canic #447](https://github.com/dragginzgame/canic/issues/447) retains the owning
scope separately from concurrent release-script/fixture repairs.
The maintainer committed the 0.110.53 batch at
`05707b8c06f658297915c96c4727a8accf98dbdc`; that commit does not relabel the focused
reader checks as complete release or hosted qualification.

IC Timers' exact reader source passed native/Wasm library Clippy, Rust 1.88
Wasm compilation and four named measurement/completion/identity/abandonment
regressions while its package still identified as 0.13.0. The maintainer committed
that source and selected 0.13.1 at `54bbcfc`; the release commit changed metadata
only. Both independent locked graphs select one registry metrics package. All
other external selections are preserved; the local timer package version changed
only through the maintainer's release. Its [release handoff](https://github.com/dragginzgame/ic-timers/blob/54bbcfc4985d4657578150cbe7112795297115fd/docs/status/current.md)
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
[adoption record](https://github.com/dragginzgame/icydb/blob/20a9aa7d9802cf73ad17ed9444fc06a2c37e2909/docs/governance/shared-tooling.md)
contains the qualification details for that historical batch.
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
