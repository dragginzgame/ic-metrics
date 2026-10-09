# Five-tool IC setup hard cut

The user-requested hard cut prepares a breaking 0.3.0 tooling boundary from
published Metrics 0.2.20 `97064b0806699b60b475879ea7530135f1b540c8`. A clean detached
checkout of reviewed Shared Tooling `8140e3dd1b44409d682c721889ab702f438c6a17`
supplies the canonical distribution helper and unchanged 89-file selection.
Every selected file, including the five-tool IC matrix, matches that committed
source. No snapshot copy is patched locally.

The bundle now contains quill, icp, didc, ic-wasm and wasm-opt. Removing
PocketIC changes explicit setup/check behavior and requires reinstallation, so
this is a pre-1.0 minor boundary. Arithmetic APIs, sample semantics, units and
consumer data remain unchanged; no consumer reset is required. Package/workspace
metadata remains 0.2.20. The pre-existing independent Host 0.8.10 lock edit is
preserved byte-for-byte and is outside this tooling qualification.

After the checks below, a concurrent edit changed the root Host requirements to
0.9 while the selected lock still contains 0.8.10. The earlier passing pin check
belongs to the preceding requirement state. This review preserves the new edit;
it does not claim a qualified current Cargo graph or resolve that independent
dependency transition. Current tool/snapshot checks do not compile the inspector.

## Callers and ownership

Current Make/CI setup and offline checks already delegate to the common helpers
and matrix, so no separate recipes or runtime paths require replacement. Metrics
has no active server provisioning, client/server equality, startup or
`.tools/ic/bin/pocket-ic` caller. The separate retired alignment/binary checkers
and their fixture were never selected here. No Testkit dependency, executable
selection or new server installer is needed in this workspace.

Published Testkit 0.25.4 `085756dd0e0e2304de7e4a0b6b887201918646b6` establishes the
replacement owner prerequisite: explicit setup/check and managed launch pass
Linux, Intel and Apple Silicon in
[owner CI](https://github.com/dragginzgame/ic-testkit/actions/runs/37901828971).
Consumer runtime attribution remains separately qualified by its owner.

Read-only setup review covers IcyDB, Canic, IC Timers, IC Backup, the Blob test
probe and Toko Miner worktrees. Their HEAD/dirty identities and selected caller
matches are retained in `downstream-callers-review.log` beside the local logs.
IcyDB and Blob currently project Testkit-admitted paths; Canic and Timers still
have owning setup/alignment callers to retire. These are worktree observations,
not adoption or native acceptance. Existing sibling handoff issues under Shared
#76 own their changes; no sibling file or arithmetic attribution contract changes
in this batch.

Frozen histogram replay inputs still contain the former setup instructions and
original PocketIC 16.0.0 identity. Their archive remains byte-identical. The
[outer replay guide](histogram-replay-029.md#verification-and-replay) now explains
that current root setup supplies no server and new owner defaults cannot replace
the frozen experiment's admitted server silently. No replay or measurement is
performed or relabelled. Historical reader/runtime evidence remains intact.

## Focused Linux checks

- Snapshot/pin validation passes; the three PocketIC matrix rows are removed
  canonically without changing the five remaining tools' versions/digests.
- Updated installer/refusal/retention fixtures pass on Bash 5 and genuine Bash
  3.2.57 with substituted downloads/native host selection. They cover old
  six-tool refusal, failed setup and successful five-tool replacement while
  preserving prior pins, receipts and server bytes.
- Common Make command fixtures and the actual native-collector shell bodies pass
  under both Bash versions, with Make effects substituted where declared. These
  establish dispatch/archive IO, not hosted native execution.
- Actual new offline admission refuses the existing six-tool bundle. Explicit
  official five-tool Linux download/install verifies selected archive checksums
  and executable versions before activating `.tools/ic`. The prepared set passes
  `make ic-tools-check`, and repeated setup reuses the same selection offline.
- The former `ic-set.oFIroT` retains all seven receipt-covered executable/library
  byte identities plus original pins/receipt/host. The new active selection is
  `ic-set.EahBYy`; its five executable names exclude PocketIC and its six-file
  receipt includes Binaryen's runtime library. No prior bundle is cleaned up.
- Aggregate offline tool checks, ShellCheck, workflow lint, maintained document
  links and `git diff --check` pass. No Rust edit, compilation, package version
  change, broad local gate, commit or release runs.

Logs, prior/current selection identities, initial snapshot and source/input
hashes remain under `target/evidence/adoption-030/`; native-collector fixture
scratch remains under `target/evidence/native-ci/`.
[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37916384666)
passes Linux and lint/security at inspection; both macOS lanes remain queued.
This is partial upstream and local Linux qualification, not delivered Metrics
native acceptance. [#41](https://github.com/dragginzgame/ic-metrics/issues/41)
owns the latter; [Shared #76](https://github.com/dragginzgame/shared-tooling/issues/76)
owns fleet coordination. No function, method or type is removed from this
consumer; only PocketIC matrix entries and installer/version/archive branches
are retired by the canonical snapshot.
