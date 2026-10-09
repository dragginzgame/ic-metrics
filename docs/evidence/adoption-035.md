# Shared Tooling 0.2.8 adoption

Pending compatible Metrics 0.3.5 adopts committed Shared Tooling
`b2646cde9abbc8861857a4379c683a0c19eba43e` through its canonical exporter from
a clean detached clone with the canonical HTTPS remote. The existing 92-file
selection is unchanged; only `make/execution.mk` and `docs/releases.md` change.
Snapshot verification confirms the recorded revision and selected file digests.
Public repository purpose remains accurate: reusable IC measurement primitives.

The execution probe now follows its selected include, independently of ambient
or command-line `SHARED_TOOLING_ROOT`. It probes the real Make executable via
`MAKE_COMMAND`, preserving argument-bearing recursive `MAKE` for actual calls
([Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30)). Runtime
tooling routing remains consumer-selected. Unsafe Make modes still reject before
release or formatting dispatch; the probe never loads consumer Makefiles.

The consumer's actual release fixture now covers harmless help with environment
and command-line external roots, proving that an unselected probe sentinel never
runs. A parallel recursive invocation with both the real consumer Makefile and
an additional overrides Makefile preserves the selected remote, cache preparation
and explicit offline mode. Existing policy refusal, all four standard entries,
failure propagation, inherited-root smoke isolation and unsafe-mode checks pass.
Release/publication effects remain substituted; no real Git or registry effects
run in that fixture.

Focused Linux checks pass under Bash 5 and genuine Bash 3.2.57:

- Consumer standard release/publication, release admission, actual formatting
  hooks, and child/assertion/publication failure retention.
- Upstream selected-include formatting and release fixtures, including external
  roots, missing companions, argument-bearing recursion and rejection of ordinary
  direct/inherited unsafe modes.
- Final snapshot/pin and prepared host/Rust tool checks, actual formatting check,
  ShellCheck for the changed consumer fixture, documentation links and diff checks.

Logs and preservation hashes are under `target/evidence/adoption-035/`; retention
fixtures retain their own evidence under `target/evidence/native-ci/`.
Production Rust, Cargo manifest/lock, IC pins and tool versions remain unchanged.
Host 0.9.5 was already selected by released Metrics 0.3.4 and has its own
[qualification record](host-dependencies-095.md).

[Upstream exact CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37955525946)
passes Linux portable regression and lint/security; both macOS lanes remain queued
at observation. Local Bash 3.2 checks do not establish native macOS acceptance.
Consumer delivered-source acceptance remains in
[#44](https://github.com/dragginzgame/ic-metrics/issues/44).
No production function, method or type is removed. Package/workspace versions
stay 0.3.4. No full local CI/product test suite, dependency resolution, commit,
push, release or publication runs.

## Subsequent qualification limit

A later issue review reproduced the command-line `MAKEFLAGS` override gap already
reported in [Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30),
using this consumer's actual Makefile and selected includes with a runner substitute
that records dispatch and exits 23. On Linux GNU Make 4.3 with Bash 5 and genuine
Bash 3.2.57, normal `release-patch` returns 2 after dispatch; `-i release-patch`
refuses before dispatch; `-i release-patch MAKEFLAGS=` dispatches and returns 0,
ignoring the substitute failure. No actual release or formatter runs.

Raw copies, commands and logs are retained under
`target/evidence/issues-035/make-admission/`. Earlier passing checks did not cover
this override case and do not establish complete execution-mode admission.
The canonical snapshot is not patched; no committed upstream repair exists at
observation. Consumer acceptance remains open in
[#44](https://github.com/dragginzgame/ic-metrics/issues/44) for this common boundary
as well as native macOS results.

An independently incoming Host 0.9.6 lock edit subsequently changed the graph.
The earlier preservation statement remains scoped to Host 0.9.5; the incoming
selection now has [its own qualification](host-dependencies-096.md).
