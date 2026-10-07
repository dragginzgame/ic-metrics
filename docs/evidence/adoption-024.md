# Shared Tooling 0.1.12 fixes and 0.1.13 rules for pending 0.2.4

This uncommitted consumer batch starts at released ic-metrics source
`89f8c6947fb3253991c65479f04bf14acb676328`. The initial reviewed upstream source
was `33c2a6f0018a94915f819ff219e270500ed5b73b` (Shared Tooling 0.1.12).
Its [exact-source CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37511845192)
passes the portable/native-tool gates on Ubuntu 24.04, macOS 15 Intel and
macOS 15 Apple Silicon, plus lint/security. Those results qualify upstream
source, not this uncommitted consumer batch.

The initial upstream distribution helper ran from a separate clean detached
checkout of that commit, with the recorded source remote. It refreshed all 53
existing files and explicitly added the common CI installer and canonical
governance file list. All 55 exported files independently matched committed source
and manifest digests. Existing dirty consumer documentation was preserved.
Refresh reported a Git status warning for the initially absent new distribution
directory; export and completed verification succeeded.

Shared Tooling then committed its workspace rule at
`e378671d90afa237ff63a4b0e3b9551eb2c222b6` (0.1.13). The final 56-file snapshot
comes from a second clean detached checkout, with the rule explicitly added.
All 56 files independently match that committed source and manifest digests;
snapshot verification checks executable modes. The executable tooling is unchanged
from 0.1.12. The [0.1.13 CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/37581058940)
was in progress at inspection, not a new green qualification claim.
The subsequent issue/upstream review verifies that same exact-source run as
completed success: all three native portable/tool jobs and lint/security pass.
No new artifacts were downloaded; this remains upstream qualification separate
from the uncommitted consumer batch.

The intermediate 0.1.12 manifest/baseline/list are retained before reconciling
those owned changes for the second refresh. A `git restore` attempt stopped at a
read-only index-lock error before changing files; its failure is recorded. The
owned baseline was then restored from the exact HEAD blob without an index write,
and the owned new list moved into evidence. The real distribution helper exported
the complete latest snapshot afterward. No shared implementation was hand-patched
and no unrelated edits were replaced.

The release runner binds observation and atomic branch/tag dispatch to the
captured destination URL, rejecting changed or additional URLs. The independent
snapshot verifier hashes inspected bytes through the host backend. Standalone
yq now uses the common installer while retaining caller-owned pins and arguments.
The governance list's Markdown links resolve within an isolated consumer export.
The baseline and maintenance rules were refreshed together, including standing
authority for relevant GitHub issue work across repositories. Consumer file edits
and release effects retain their separate authority.

Focused Linux validation uses GNU Bash 3.2.57, including nested fixture commands:

- `make release-tools-check` passes formatter admission, destination replacement
  and addition during validation/hooks/observation, exact-version retry and
  lost-response recovery, the actual release/publication Make adapters, metadata
  preparation/rollback, selected-commit admission, logger retention and twelve
  child/assertion failure-retention cases. Release effects and publication use
  command substitutes; metadata/index checks use real read-only Cargo/Git where
  stated by their fixture. No actual release commit, tag or push is created.
- Disposable copies of the intermediate 55-file and final 56-file snapshots
  pass unchanged verification.
  Helper-only, helper-plus-payload and payload-only changes each return 1; the
  modified helper is never executed. GNU SHA-256 and Perl `shasum` backend
  success are separately exercised. The earlier 0.2.3 gap reproduction remains
  scoped to its old source under `target/evidence/release-023/followup/`.
- Substituted-download probes of the actual vendored yq wrapper pass successful
  installation and reject matching-output/nonzero version status, digest
  mismatch and directory destinations. The installed executable remains intact;
  two failed authenticated candidates are retained. These are installer behavior
  checks, not a new live yq download or native macOS consumer execution.
- Selected ShellCheck, Bash syntax, dependency declarations/inheritance, current
  document links and isolated governance links pass. The isolated export checks
  86 references across 25 Markdown documents for 0.1.12 and 92 references across
  26 documents after the workspace rule is added.

The workspace policy already matches this repository: one virtual root declares
`crates/ic-metrics`, with no root package or independent maintained workspace.
The member retains its package name, inherited metadata/lints and existing
publication inputs. Locked offline `cargo metadata --no-deps` confirms the sole
member, exact path, version 0.2.3 and empty dependency graph. `make fmt-check`
passes. No package moves, version changes or layout exceptions are needed.

Inputs, previous dirty diff, Bash identity, probe scripts, exported fixtures and
logs remain under `target/evidence/adoption-024/`. The native retention fixture
also retains its failed inputs under `target/evidence/native-ci/`.
In this tooling qualification, Rust source, Cargo versions, lockfile, dependency
graph and tool pins were unchanged. No Rust build or full local CI gate ran;
no IC performance improvement is claimed. The later compatible histogram addition
and its Rust checks have separate [source-bound evidence](histogram-024.md).
Pending 0.2.4 is a compatible addition/tooling patch from finalized 0.2.3. Native consumer
qualification and committed adoption remain tracked in
[#13](https://github.com/dragginzgame/ic-metrics/issues/13).
