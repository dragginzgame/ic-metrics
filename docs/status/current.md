# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.11.8

This compatible batch updates Memory integration guidance and validation fixtures.
Package versions remain 0.11.7. The production `ic-memory` 0.44 dependency,
collection-type identity, arithmetic, stable V1 format and Rust 1.91 floor remain
unchanged. The proposed direct stable-structures dependency was declined and
was never applied.

The host declares one permanent metrics-store allocation, admits it through
`ic-memory` bootstrap and injects the opened map. Components share that store;
namespace/name keys distinguish rows without new memory IDs. The stable guide
links the exact published Memory 0.44 source for declaration/bootstrap APIs,
replacing the stale 0.41 selection and removed global opener. Its native examples
retain Memory's collection re-export and qualify storage behavior only.

The validation logger's generic fallback/retry qualification stays in Shared
Tooling's producer fixture through
[PR #249](https://github.com/dragginzgame/shared-tooling/pull/249), source
`09fc963a4c7ec7638009e6b01a7d41b428f297ff`. It verifies unchanged prior raw logs
after repeated ordinary and fallback failures, including directory/copy refusal
and distinct reported scratch logs. Metrics keeps one actual adapter failure
check for consumed setup authority, offline selection, release version/commit,
gate refusal and the configured evidence destination. Its second-gate, input
identity and recovery checks remain intact. The production logger bytes match
the selected snapshot, so no snapshot refresh is needed for this fixture-only
contribution. The PR is open for upstream review/integration.

Focused logs and before-images remain under
`/tmp/metrics-memory-docs-logger.5BkWbA/`. Metrics release/hook retention and the
Shared logger fixture pass on Bash 5 and genuine Bash 3.2.57 on Linux. The stable
package doctests pass on the unchanged locked graph. Selected ShellCheck, local
document links and diff checks pass. The linked Memory guide was checked against
the registry package's exact source. Full CI/MSRV gates and native macOS
qualification were not run. Local source changes are uncommitted; the root index,
Git refs, package versions and dependency lock remain unchanged.

Stable corruption tests now share rejection assertions after a summary's map is
reopened, preserving the corrupted bytes and checking zero stable writes. The
bounded V1 test retains exact encoded lengths, round trips and histogram limits;
it no longer treats final vector capacity as evidence of allocation history.
All five affected named tests and stable-package all-target Clippy pass on Linux
after `make fmt`. Before-images are retained under
`/tmp/metrics-stable-test-cleanup.bTdmU9/`. The local memory observer remains
until the package supplying Testkit PR #97 is published, as tracked by
[#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82).

## Finalized 0.11.7

Commit `a3a70170ef99c46f85fb635dba8e0b401e398e0e` identifies the finalized
baseline. Its
[source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/a3a70170ef99c46f85fb635dba8e0b401e398e0e/docs/status/current.md)
retains earlier snapshot, fixture and measured-experiment evidence, source
identities and upstream contributions. Finalization alone does not establish
registry publication or complete hosted/native acceptance. The existing observer
adoption follow-up stays with
[#82](https://github.com/dragginzgame/ic-metrics/issues/82).
