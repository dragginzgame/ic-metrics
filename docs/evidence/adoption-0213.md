# Shared Tooling 0.1.26 preparation

The consumer starts from released 0.2.12
`d16aa0aeb0e0f4fcbbc6962ba3f86c7348ecff88`. Reviewed upstream is committed
Shared Tooling `75a8a60f49cec11d3f6aecab5c977029c42cc549`, exported from a
clean detached checkout with canonical HTTPS origin at
`/tmp/ic-metrics-shared-026-reviewed`. The canonical helper refreshes the existing
72-file selection without additions, staging, commits or sibling edits.

The five-file upstream diff changes only distribution, its tests and guidance,
changelog and version. The common baseline, runner and archiver remain unchanged.
The exporter may advance an uncommitted previous snapshot only when its changing
files match the previous manifest and exact committed upstream bytes/modes.
The prior source commit must be locally available. Edited files, forged digests,
staged conflicts, redirected parents and changed file/manifest identities are
refused. Captured index entries are rechecked before replacement. There is no
force flag, implicit fetch or additional updater. Per-file publication remains
non-atomic; callers must stop concurrent selected-path editing and validation.

Preparation logs and selected inputs are retained under
`target/evidence/adoption-0213/`. Focused upstream distribution fixtures use
isolated real Git checkouts; source review, local shell execution and native
qualification remain distinct. The complete focused distribution fixture passes
under Linux Bash 5.2 and 3.2.57, including previous-export admission, staged/edit
refusals and preparation-time conflicts. An immediate canonical repeat refresh
also verifies the actual 72-file selection without staging or commits. ShellCheck,
documentation, pins, snapshot, formatting and diff checks pass. Finalized
changelog history is preserved; manifests/lock, Rust source and tool pins are unchanged.
[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37770856593)
was queued at initial review; Linux, Apple Silicon and lint subsequently passed
with Intel still queued. The sibling's separate dirty release-fixture/docs
follow-up was inspected as uncommitted work and is not included in the snapshot.

Pending 0.2.13 is compatible from finalized 0.2.12. It changes snapshot-refresh
admission without changing arithmetic, release delivery or consumer storage.
Cargo workspace/package/lock remain 0.2.12; dependency pins are unchanged.
No Rust edit, product build, full local CI, package version change, commit, push,
tag, publication or release is part of this preparation. No named function,
method or type was removed.
[#32](https://github.com/dragginzgame/ic-metrics/issues/32) retains this
distribution batch's exact committed consumer native acceptance, distinct from
0.2.12's runner/collector qualification.

## Subsequent committed observation

The maintainer finalized this batch in release 0.2.13 at
`4091366bcd97ddf4f31d5993c954f6f4a269bc63`. The
[release observation](release-0213.md) independently verifies its published
archive, all three native source/payload/outcome receipts and passing MSRV.
This does not change the preparation identities above. Consumer acceptance is
complete at this release; #32 is closed. The newer 0.2.14 preparation is separate.
Upstream Intel's snapshot and complete portable suite pass before a step-budget
timeout; subsequent native qualification is skipped. The owning budget repair
is [Shared Tooling #71](https://github.com/dragginzgame/shared-tooling/issues/71).
