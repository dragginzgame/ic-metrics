# Current handoff — 2026-10-31

The current task implements
[#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
The incoming checkout was clean at `bc450ef0c4cecdceb32b8f677eff7e6ae6e04f83`
(Release 0.23.0). Changes remain uncommitted. No staging, root release/tag/push,
registry publication or sibling checkout edits were performed.

## Independent groups

[The group policy](../../ci/cargo-release-groups.json) declares every current
member. Metrics is the default group, retaining workspace.package.version and
the root changelog. Logging uses literal package.version and its own
[canonical ledger](../../crates/ic-logging/CHANGELOG.md), linked to the shared
history through 0.23.0. Both numeric versions remain 0.23.0. The new numbered
pending notes are 0.23.1 in each ledger; no version bump was executed.

[The maintainer guide](../independent-releases.md) records selection, publication,
exact plans, group tags and recovery. Use RELEASE_GROUP=logging for Logging;
an explicit PACKAGE must belong to the chosen group. Full ci/msrv gates remain
mandatory for either release. The existing shared runner/editor owns rendering,
transactions, staging, commits, tags, pushes and resume; the adapter supplies
policy, validation and group-bound validated/prepared receipts.

Shared Tooling was refreshed through its canonical exporter from clean committed
revision `39ba9836a269ee7ea7f073a3f23d9cefe3c7d03c`, including merged
[#330 — Explicitly shared consumer metadata](https://github.com/dragginzgame/shared-tooling/pull/330).
The snapshot records version 0.27.16 despite the commit subject naming 0.27.17;
this is committed availability, not a claim of published 0.27.17. Common tool
catalog selections did not change. No additional shared metadata file is needed.

The managed metadata editor selection is published IC Build 0.73.0 with cli.
Explicit setup installed/admitted that selection. The initial unprivileged
shared-cache lock refusal and successful approved setup logs remain retained.
Other hosts must prepare this selection before group preparation.

## Focused results and limits

Logs are retained under `target/audits/independent-groups-104/`:

- `release-tools-check-2.log`: the complete focused release/hook/retention gate
  passes. Actual group plans, adapter, installed editor, runner and Git execute
  both directions in disposable repositories with local bare remotes. Tests
  cover exact staged/committed files, unchanged unrelated identities/requirements
  and pending notes, transactional rollback, source/index refusal, failed CI and
  MSRV gates, input drift, selected-commit checks, receipts and exact resume.
- The same fixture runs a consumer pinned to each unaffected identity, testing
  Logging append/page/prune or Metrics wide arithmetic and typed failures.
  Suppliers are workspace-owned source copies with unchanged bytes. This is
  source-level compatibility, not publication of simulated versions. Setup,
  full validation, archive compilation and registry uploads are substituted;
  actual publication admission selects only the chosen group and refuses the
  other package before uploading.
- Successful grouped inputs/receipts and injected failure evidence remain at
  `target/evidence/native-ci/fixture-retention.IfgB4u/`. Earlier failed runs and
  their inputs are preserved. The first enclosing run was invalidated by editing
  its running script; it is not claimed as a passing gate.
- Snapshot integrity, dependency pins, formatting, selected ShellCheck and
  documentation links pass. All four Metrics/Logging production graph profiles
  and four minimal Serde tests pass. Logging's library checks for Wasm on Rust
  1.91.0 with the same explicit version.

The root lock, dependency selections and both libraries' Rust sources are
unchanged. There is no Metrics/Logging dependency edge. Previous native Wire,
TypeScript/byte, arithmetic-only Wasm and compiler-floor evidence in
[the Wire identity receipt](../evidence/wire-stable-identities-0121/README.md)
retains its original inputs and scope; unchanged runtime checks were not repeated.
No full local ci/msrv, hosted matrix, macOS or installed IC qualification ran.
Hosted/native obligations remain in [the host guide](../hosts.md); the release
fixture's substituted gates do not establish them. No code blocker remains from
the focused checks; maintainer review/delivery and actual release gates remain.

## Retained integration boundaries

The base source already selects Wire/Derive 0.12.1. Canonical Platform Types is
0.1.0, also reexported by Platform 0.14; the earlier 0.14 clarification concerned
that façade, not a Types 0.14 release. Product dependencies exclude Platform,
Types and Endpoint. This task changes none of those selections or runtime
contracts, so it requires no paired upgrade of a persistence adapter or other
group. Native schema consumers still need a registry Metrics version supplying
their matching Wire identity; registry delivery of base 0.23.0 was not rechecked
for this release-group task.

Earlier Wire adoption work updated Wire #36 and Tooling #274/#268. Canic sediment
remains covered by Canic #712 and #100. Preserve the original release failure
logs under .git/release-state/validation-failures and earlier evidence under
target/audits/release-fixture-order-20261031, wasm-json-boundary-20261031 and
wire-0110-20261031; none was cleaned or repurposed.
