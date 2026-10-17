# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.
The [stable guide](../../crates/ic-metrics-stable/README.md) owns the compiled
host example and current durable-store API.

## Source and prepared changes

The finalized source is 0.13.2 at
`acb0a1eeeb838a4c0a1b14317dcba06da7cb92b3`. This identifies the release commit,
not an independent registry-publication observation. The prepared 0.13.3 batch
changes contributor tooling and documentation only; package versions, locked
product dependencies, public APIs and stored V1 records remain unchanged.

Shared Tooling 0.21.0 is selected at clean committed revision
`f31abf666e4d1d050a835e013125d2db4aabbc42` (114 payloads), supplied by
[Shared PR #276 — Share ordered shell fixture execution and outcomes](https://github.com/dragginzgame/shared-tooling/pull/276).
Its common shell fixture executor owns ordered execution, logs and outcome propagation. Metrics keeps
scenario selection, expected order, action substitutes and archive custody.
Generic retained-source assertions stay with Shared's metadata fixture; Metrics
retains its actual two-package selected-source checks and rejection routing.

The refresh also brings single-document Rust policy admission and direct host
catalog consumption. Common host/Cargo pins are unchanged. The optional IC
catalog now selects ICP CLI 1.7.0; users of those tools must run
`make install-ic-tools` before `make ic-tools-check`. Common Metrics setup, CI and
release validation do not require the optional IC executable bundle.

## Qualification and limits

Focused workflow/archive, release-admission and failure-retention fixtures pass,
as do actual common setup/offline checks, formatting, ShellCheck, snapshot, pin
and documentation checks. Logs are under `target/flow-cleanup-0133/`. Producer
executor, metadata, Rust-policy and host-tool fixtures also pass. Workflow/action
effects are substituted; these are local preparation results, not hosted native
acceptance. Full CI/MSRV release gates and native macOS qualification remain
separate under [host qualification](../hosts.md). Optional IC executable setup
was not run; its updated catalog does not establish product qualification.

The [frozen upgrade study](../evidence/governed-store-0130.md) retains its exact
Memory 0.45/Storage 0.3.1 identities and IC measurements. It does not measure the
currently selected Memory 0.47/Storage 0.4 graph. Existing evidence archives are
unchanged. The [archive distribution record](../evidence/archive-distribution-072.md)
continues to govern public evidence payloads.

## Owning issues and history

- [#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82)
  owns replacement of the local observer after publication and qualification.
- [#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83)
  owns first durable-consumer acceptance.
- [#89 — Own native recovery-archive packaging in Metrics](https://github.com/dragginzgame/ic-metrics/issues/89)
  owns delivery of the locally implemented recovery packaging.

[The changelog](../../CHANGELOG.md) owns released changes and caller actions.
The [0.13.2 source-bound handoff](https://github.com/dragginzgame/ic-metrics/blob/acb0a1eeeb838a4c0a1b14317dcba06da7cb92b3/docs/status/current.md)
preserves earlier preparation narratives, original evidence locations and their
qualification limits. Historical receipts are not relabelled as current checks.
