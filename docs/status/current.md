# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Pending 0.11.1

The working tree now includes the reviewed sample-statistics implementation from
[PR #86](https://github.com/dragginzgame/ic-metrics/pull/86) for
[#85](https://github.com/dragginzgame/ic-metrics/issues/85), and nearest scaled
ratios from [PR #81](https://github.com/dragginzgame/ic-metrics/pull/81) for
[#80](https://github.com/dragginzgame/ic-metrics/issues/80). Both are additive,
allocation-free and dependency-free. Sampling, floating storage, units, quantile
selection and reports stay caller-owned. Integer projections and stable V1 bytes
are unchanged. The sample-statistics mean is approximate; even medians preserve
equal subnormal values through `midpoint`. Invalid input refuses before sorting;
rounded mean overflow is explicit after sorting. These APIs are not published,
and the PRs are not merged by this preparation. Their hosted receipts qualify
their own heads, not this combined dirty tree.
GitHub reports conflicts on PR #81's older branch; this local preparation resolves
its source and pending-note integration without changing that branch.

The reviewed 113-file Shared Tooling 0.15.2 candidate is
`ba41f29a2d2a3d92e8ba593daa9f7cf0c2fb6912`
([Shared PR #217](https://github.com/dragginzgame/shared-tooling/pull/217)).
Canonical refresh preserves existing archive helpers and adds read-only changelog
preflight. Metrics calls it before cache/tool preparation; shared producer tests
own its reader/selector failure matrix. Release-validation fixtures share one
local Make/logger copy list. Direct release rejection and publication checks
remain; the redundant shell short-circuit test is removed. Compiler, Cargo graph
and executable-tool selections are unchanged.

Current adoption and release guidance now identifies published 0.11.0, its
Rust 1.91 floor, selected Memory 0.41 graph and literal metadata preparation.
The exhaustive logger-depth matrix stays at Shared Tooling; one actual Metrics
release-adapter check verifies invalid inherited depth refuses before dispatch.
Older release/preparation narratives move into the linked historical handoff.
The [histogram equality ownership experiment](../evidence/equality-owner-0111.md)
rejects manual equality because it breaks constant patterns and regresses costs;
the released histogram equality implementation remains unchanged. Package versions and graphs
are unchanged.

The combined working tree passes local `make ci`, strict native/Wasm Clippy,
58 arithmetic units and ten arithmetic doctests. The unified Rust 1.91 native/Wasm
workspace gate passes on this additive source with the unchanged selected graph.
The earlier changed-script ShellCheck, metadata/release/admission fixtures on
actual Bash 3.2 and shared producer/adoption checks retain their unchanged inputs.
The frozen equality experiment's archive replay retains its byte-identical Wasms,
repeated IC instruction results and constant-pattern outcomes. These local checks
do not establish hosted acceptance of the pending batch. PR #86's exact head
`f71eb96514d4318a681b4a16edf24c7422b37962` has passing Linux, Apple Silicon and
MSRV jobs; its Intel macOS job remains in progress at this review.

## Released 0.11.0

Release commit `d68886af183688e365338196a17b83f5d0ed050d` and tag `v0.11.0`
identify both published packages. The official registry records Rust 1.91 for
both; arithmetic has no dependencies, and stable selects Memory 0.41 and Metrics
0.11. [Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38728966486)
has passed Linux, Intel macOS, Apple Silicon and the native/Wasm workspace MSRV
job. The required released-source native matrix is complete;
[#84 — Optional Wasm inspector](https://github.com/dragginzgame/ic-metrics/issues/84)
is closed with that exact-source qualification recorded.

Both packages use the unified Rust 1.91 native/Wasm floor gate. The reviewed
112-file Shared Tooling 0.15.0 snapshot is
`1d261fe396c6158c5e0bcd9b35d4c914f1d5489f`; the optional published Host inspector
remains 0.17.10, outside both package graphs. Shared owns exhaustive producer
regressions and archive packaging; Metrics retains its own admission and custody.
[Historical release and preparation observations](history-through-0110.md) retain
their original identities and qualification scopes.

The latest read-only manifest review finds Timers and Backup selecting Metrics
0.11 and declaring Rust 1.91. These are source selections, not owning runtime
acceptance. Other downstream obligations remain with the linked consumer issues;
this review changes no sibling manifests.

## Selected owners and qualification

[Memory PR #103](https://github.com/dragginzgame/ic-memory/pull/103) was closed
without merging in favor of the canonical
[Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97).
Its opt-in `ic-testkit-native` stable-memory observer remains unpublished; the
official package index still returns 404. This blocks the observer replacement,
independently of the released Memory 0.41 selection.
The local test observer remains until that reviewed replacement is published,
as tracked in [#82 — Adopt published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82).
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned after publication. Existing callers are not opted into persistence.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary callers are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47); adopt the
published API with aggregate projections, preserving attribution, quality and resets.
The arithmetic-reader closeout remains [#10 — Complete arithmetic-only consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/10).
Current migration guidance uses aggregate projections; historical wire names,
measurement archives and already accepted consumer receipts retain their scope.
