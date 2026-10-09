# Locked release cache preparation

The compatible pending 0.2.19 batch starts from released Metrics
`3b1f461ed9aacce6c3d04d391178fecb9ce283dd`. The canonical distribution helper
refreshes the unchanged 89-file selection from a clean detached checkout of
reviewed Shared Tooling `be550afa57fe9e16872e5110b5cd69c24b4fa9e8`.
[Its exact CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37904190217)
passes Linux, both macOS architectures and lint/security. This is upstream
qualification, not committed consumer acceptance.

For [#40](https://github.com/dragginzgame/ic-metrics/issues/40), standard patch,
minor, major and resume entries select locked cache preparation. The shared
runner still selects unfinished intent and admits source/candidate before
consumer preflight. That adapter uses `cargo fetch --locked` for the complete
workspace, allowing missing selected inputs to be prepared without changing
dependencies. Explicit Cargo offline environment/configuration remains effective.
Standalone preflight retains `cargo fetch --locked --offline`.

The adapter consumes the internal `IC_METRICS_RELEASE_CACHE_PREPARE` selection
before dispatching helpers or Cargo. The validation adapter removes it and sets
`CARGO_NET_OFFLINE=true`. Preparation failure retains Cargo's status in the
consumer adapter; the shared runner reports its existing preflight refusal and
never starts validation or version preparation. Local-version rewriting,
restoration, exact-version recovery and delivery effects remain unchanged.

Focused Linux verification passes:

- Release tooling/recovery fixtures under Bash 5 and genuine Bash 3.2.57,
  including nested Bash calls. The final integrated admission extension passes
  separately on Bash 5 and in the complete Bash 3.2 tooling run.
- Cold-cache population and warm explicit-offline reuse with substituted Cargo;
  controlled offline/network refusals preserve status and metadata/index bytes.
- Actual Cargo fetch against the committed workspace graph with empty isolated
  caches and offline policy selected separately through environment/configuration.
  Both return Cargo's status 101 with the lock unchanged. No online fetch runs.
- Actual shared runner with consumer metadata admission and substitute validation:
  cold preparation reaches the deliberately failing gate; offline/network refusal
  never reaches it and creates no preparation plan. No commit, tag or push occurs.
- Dirty-source/candidate refusal, selected-commit checks, metadata restoration,
  real-Git tracking/recovery and failure-evidence retention remain covered.
- Adopted Rust installer fixtures under both Bash versions: fixed tool bundle and
  optional explicitly selected binary/example admission, byte/receipt checks,
  offline reuse, failed-build retention and locking, with Cargo installation
  substituted. This repository selects no additional package/profile.
- Snapshot/pin checks, ShellCheck, actionlint, documentation links and
  `git diff --check`; existing native evidence collectors pass with substituted
  Make effects.

Logs, interpreter identity, base/source hashes and the prior snapshot are retained
under `target/evidence/adoption-0219/`; retained collector fixtures remain under
`target/evidence/native-ci/`. No timing, IC execution or performance claim is made.
No functions, methods or types are removed. No Rust source, package version,
release command, broad local gate or sibling file changes in this batch.

The pre-existing independent dirty Host 0.8.9 lock selection is preserved
byte-for-byte and is outside this tooling qualification. Package/workspace
versions remain 0.2.18. #40 remains open for delivery and exact-source native
qualification of the changed consumer callers.

## Subsequent Shared Tooling 0.1.37 review

The same pending batch later refreshes the unchanged 89-file selection through
the canonical helper from clean committed
`dc4fdf0f78928d75b69bbf43b37c690c53a04d1e`. The preceding 0.1.35 evidence retains
its original identity; those results are not relabelled as 0.1.37 execution.

0.1.36 tightens selected Cargo tool admission: receipts must contain exactly one
JSON document, setup rechecks installation ancestors after Cargo returns, and
failed installs retain Cargo's original status. 0.1.37 fixes executable lookup
for the staged-input formatting hook and its adoption checker, using the original
checkout's prepared host, IC and Rust tool paths. Formatter source/configuration
remain isolated index inputs; missing or incorrectly pinned tools still refuse.
The release runner, version pins and dependency selection are unchanged.

Focused Linux checks pass under Bash 5 and genuine Bash 3.2.57: the updated
installer's substituted-Cargo receipts/path/failure cases, actual consumer hook
formatting and preservation, and failure-retention fixtures. The actual shared
formatting checker also passes with PATH limited to the Rust toolchain and system
directories, without caller-selected `.tools` paths. Snapshot/pin checks and
ShellCheck pass. Every selected snapshot copy matches the committed distribution
source, and the existing Host 0.8.9 lock hash remains unchanged. Logs are under
`target/evidence/upstream-0219/`.

[Upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37909074809)
has passed lint/security and the complete Linux portable job, including real
formatter/hook and IC tool qualification; both macOS jobs are queued at final
inspection. This is partial upstream evidence, not completed
consumer native acceptance. No new tool is installed, Rust source or symbol is
removed, and no version change or release runs. The separate
[Host 0.8.9 review](host-dependencies-089.md) qualifies that preserved lock
selection without changing the earlier tooling-only proof's scope.
