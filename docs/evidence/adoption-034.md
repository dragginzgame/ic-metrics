# Shared Tooling 0.2.7 adoption

Pending compatible Metrics 0.3.4 adopts committed Shared Tooling
`47d6ae6488b8007323fa7c2e22a6efa11d77ae63` through a clean detached clone and
the canonical exporter. Its HTTPS source matches public main. Explicitly adding
`make/execution.mk` brings the verified selection to 92 files; its execution
probe was already selected. All declared companions are present. Product source,
manifests/lock, IC pins and prepared tool selections remain unchanged.

The shared include rejects ignore-errors and non-executing Make modes during
Makefile parsing, before recipe failures could be ignored
([Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30)). Existing
direct runner/logger/hook guards retain their independent boundaries. All scratch
Makefile copies, smoke inputs, formatting overlays and native source receipts now
carry the new companion. Unsupported delivery still stops before runner/metadata
dispatch; the fixture permits only the real parse-time execution probe.

Release qualification now binds its disposable tooling root explicitly, preventing
an inherited external root from redirecting its substitute runner
([Shared #7](https://github.com/dragginzgame/shared-tooling/issues/7)). The consumer
fixture covers direct invocation and a parallel parent Make exporting that root;
the external sentinel never runs. Production routing and direct-only delivery,
cache preparation and local metadata/validation/publication adapters are preserved.

The formatting qualifier preserves literal newline-ending paths and Git object
access through C-quoted alternates
([Shared #90](https://github.com/dragginzgame/shared-tooling/issues/90)). The actual
consumer adapter now passes in newline-ending disposable roots under Bash 5 and
genuine Bash 3.2.57, with CDPATH set. Production setup/idempotence/formatting,
partial staging and formatter failure cases pass; the original index/Rust bytes,
lock and unrelated README edits remain unchanged. Literal conflicting hook paths
are refused without config mutation. Earlier failed evidence remains historical;
it is not relabeled as passing.

Focused Linux checks pass with prepared tools:

- Actual consumer release/publication adapters with substituted effects, all four
  cache selections and exact increment/resume/destination arguments, policy/conflict
  refusal and ordinary failure propagation. Both direct and inherited unsafe modes
  reject before release/formatting dispatch, including an inherited admission marker.
- Actual non-mutating Cargo formatting and consumer hook checks under both shells.
- Release admission, real scratch Git/offline-fetch behavior, selected-commit
  metadata and logger retention with remaining Cargo/gate effects substituted.
- Shared formatting fixture, including prepared PATH, prerequisite/sorter failures,
  unsafe modes and ordinary parallel Make; no downloads or installation.
- Final failure-retention fixtures under both shells, with evidence in
  `target/evidence/native-ci/fixture-retention.rMtUr8` (Bash 5) and
  `fixture-retention.F9l4QV` (Bash 3.2).
- Actual native workflow source/setup/archive bodies under both shells with Make
  effects substituted; this checks the changed receipt selection and collector IO.
- Snapshot/pin verification, source-following ShellCheck, workflow lint,
  documentation links and preservation hashes.

Inputs and logs remain under `target/evidence/adoption-034/`, including retained
newline-root fixtures. No live hooks/index are changed. No production Rust function,
method or type is removed. Package/workspace versions remain 0.3.3; no dependency
resolution, full local CI/test gate, commit, push, tag, release or publication runs.

[Upstream exact CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37949344055)
passes Linux portable regression and lint/security; both native macOS jobs remain
queued at observation. Local Bash 3.2 execution does not qualify supported native
macOS hosts. Consumer delivered-source acceptance remains in
[#44](https://github.com/dragginzgame/ic-metrics/issues/44) and literal hook-path
acceptance in [#43](https://github.com/dragginzgame/ic-metrics/issues/43).
