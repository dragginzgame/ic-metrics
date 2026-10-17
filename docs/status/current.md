# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.
The [stable guide](../../crates/ic-metrics-stable/README.md) owns the compiled
host example and current durable-store API.

## Source and prepared changes

The finalized source is 0.13.3 at
`ab328d191a7ac72fd408dd25467b9179eb0d6f59`. This identifies the release commit,
not an independent registry-publication observation. The prepared 0.13.4 batch
consolidates truncated-record tests across all four families, including empty
and populated summaries. Each rejected prefix must preserve the row and perform
no writes. Independent frozen-byte and original-collection checks remain intact.
Package versions, locked dependencies, public APIs and stored V1 records are unchanged.
CI now relies on strict Clippy for native/Wasm type checking, retaining standalone
check commands. The arithmetic guide links to the stable guide for supported
persistence operations instead of maintaining a conflicting capability list.
README onboarding now selects the current 0.13 contract and attributes the
governed map to IC Storage over admitted IC Memory handles. Hook qualification
delegates diagnostics and scratch custody directly to Shared Tooling. The
source-rewriting assertion meta-test is removed; actual metadata and retained-input
checks remain.

Shared Tooling 0.23.0 is selected at committed revision
`88d398f01c9be74bd71d1ad67c27bf0ede87cc9b` (116 payloads), supplied by
[Shared PR #276 — Consumer fixture execution and formatting diagnostics](https://github.com/dragginzgame/shared-tooling/pull/276).
Metrics retains its workflow scenarios, action substitutes and archive custody.
The committed companion-closure preparer replaces the retired Make fixture
copier in both release fixtures. Tool catalogs and product dependencies are
unchanged. The earlier Testkit package-index observation was HTTP 404; the local
memory observer remains pending published-source qualification.

## Qualification and limits

The earlier eight selected stable-test results cover shared prefix rejection,
V1 encoding/admission, histogram boundaries and original-collection compatibility;
their receipts remain under `target/corruption-cleanup-0134/`.
The CI/guide cleanup passes strict native all-target and Wasm library Clippy,
11 core doctests, the actual Make/release adapter fixture, formatting and
documentation checks. Cargo metadata confirms that both workspace packages have
only library targets. These receipts are under `target/ci-guide-cleanup-0134/`.
The hook/fixture cleanup passes the actual release/hook retention suite, canonical
tool setup and offline verification, snapshot integrity, pins, formatting and
documentation checks. Its receipts are under `target/hook-replay-0134/`.
Native workflow source/setup/archive cases pass with substituted effects in a
disposable committed copy of the prepared source, so the retired tracked helper
is absent from its inventory; the real index and refs are untouched. Shared
PR #276 also passes its real Cargo/hook/frontend fixture, failure-log replay and
custody checks, companion-closure/nested-destination admission, assertion-probe
and ordered-runner fixtures, affected ShellCheck and documentation links.
No full local CI/MSRV gate or native macOS qualification was run for this cleanup;
release qualification remains separate under [host qualification](../hosts.md).

The [frozen upgrade study](../evidence/governed-store-0130.md) retains its exact
Memory 0.45/Storage 0.3.1 identities and IC measurements. It does not measure the
currently selected Memory 0.47/Storage 0.4 graph. Existing evidence archives are
unchanged. The [archive distribution record](../evidence/archive-distribution-072.md)
continues to govern public evidence payloads.

## Owning issues and history

- [#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82)
  owns replacement of the local observer after publication and qualification.
- [Shared #274 — Prepare script fixtures from their declared companion closure](https://github.com/dragginzgame/shared-tooling/issues/274)
  owns the supplying fixture helper, now adopted from a clean committed source.
- [#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83)
  owns first durable-consumer acceptance.
- [Storage #12 — Investigate discard-value mutations for governed stable maps](https://github.com/dragginzgame/ic-storage/issues/12)
  owns the substrate capability investigation. Existing mutations still extract
  old values internally; a facade that merely drops them would retain that work.
  Metrics keeps its current validation-before-write and map format.
- [#89 — Own native recovery-archive packaging in Metrics](https://github.com/dragginzgame/ic-metrics/issues/89)
  owns delivery of the locally implemented recovery packaging.

[The changelog](../../CHANGELOG.md) owns released changes and caller actions.
The [0.13.3 source-bound handoff](https://github.com/dragginzgame/ic-metrics/blob/ab328d191a7ac72fd408dd25467b9179eb0d6f59/docs/status/current.md)
preserves earlier preparation narratives, original evidence locations and their
qualification limits. Historical receipts are not relabelled as current checks.
