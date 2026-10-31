# Current handoff — 2026-10-31

Source base is release 0.22.0, `402168f`. The incoming checkout was clean. The
maintainer requested the published Wire stable-identity adoption and real
Principal/Account compatibility evidence. Current source selects Wire/Derive
0.12.1, the latest patch of core 0.12. Own metadata remains 0.22.0; pending 0.23
notes reflect the exposed native Wire trait change. No staging, commit, release
or publication was performed. Source changes are uncommitted.

## Selected boundary

Official registry versions/checksums and package VCS metadata identify published
Wire/Derive 0.12.1 at `ae9a3eda0449729008d849c6e078a8b7f849ab9e`, Rust floor 1.91.
Only the Wire pair changes in the root lock. The stable identity supplier is
published ic-platform-types 0.1.0. Published ic-platform 0.14.0 reexports those
same types; the maintainer's 0.14 clarification was verified against both index
records. There is no published Types 0.14 package.

Metrics keeps optional, default-enabled native-wire with native typescript only.
Its minimal/recording/Wasm graphs exclude Wire; all product profiles exclude
Platform, Types and Endpoint. The resolved graph guard now checks the new Types
and Endpoint package names too. No arithmetic, typed-error, Serde-layout or
Logging implementation changed. No endpoint caller exists here, so no endpoint
package was introduced. Shared Tooling remains reviewed 0.27.11 at
`62edfbd43087a718bf0283e9040676a49211976d`; no tooling adoption is included.

Current READMEs, compiled application prose and
[the pending 0.23 migration](../migration-023.md) describe one Metrics/Wire identity
for native schema consumers. The [0.22 guide](../migration-022.md) is historical
Wire 0.11 guidance. Dependency selections were reviewed read-only across the
required downstream owners; no sibling source was edited or qualified.

## Actual qualification and evidence

The [identity receipt](../evidence/wire-stable-identities-0121/README.md), probe
source and manifest snapshot are tracked inputs. Raw logs/graphs/source copies
are retained under `target/audits/wire-0121-20261031/`:

- Pre-edit graph verification recorded Wire 0.11 and passed all four profiles.
  The fresh baseline TypeScript check captured report bytes/generated codecs.
- Strict selected Metrics Clippy, eight native transport tests and 15 doctests
  pass; transport/doctest execution includes Rust 1.91. Node conformance passes
  five reports. Rust payload vectors and generated codecs exactly match baseline.
- All four dependency profiles and four minimal Serde tests pass. The separate
  allocator-free Wasm fixture links on Rust 1.91. Pins/declaration admission pass.
- Three real identity tests pass at Rust 1.91, and that consumer checks for Wasm.
  Canonical Types and Platform 0.14 reexports share schema traits; composed
  Metrics reports preserve subaccounts, numeric fields and typed failures.
- The probe's locked graph contains one Types/Core identity and no Endpoint,
  CDK, IC0 or runtime guard. Its façade dependency is principal-only. Root Metrics
  remains free of that façade/types selection.
- Probe and Metrics strict Clippy, formatting, docs links and diff checks pass.

The temporary probe workspace copies current Metrics source verbatim and adds
only a workspace-owned test consumer. Wire/Types/façade are published registry
suppliers; the Metrics dependency alignment is unpublished source evidence,
not registry Metrics 0.23. No package source was patched or sibling path used.
No full local CI/MSRV suite, hosted run, macOS, browser or installed IC test ran.

## Issues and publication prerequisites

[#36 — Keep codec and schema identities stable across Platform integration releases](https://github.com/dragginzgame/ic-wire/issues/36)
and [#274 — Align Testkit typed Wire calls with the Platform 0.12-compatible Wire release](https://github.com/dragginzgame/ic-tooling/issues/274)
were reviewed and updated with this scope/results.
[#268 — Delegate Testkit scaled benchmark averages to ic-metrics](https://github.com/dragginzgame/ic-tooling/issues/268)
records shipped arithmetic-only Metrics 0.22
use with defaults disabled. That use does not need a new Observability publication
before Tooling's own core 0.12 adoption. Native metadata consumers require a
published ic-metrics containing this candidate (pending 0.23). ic-logging has no
Wire publication prerequisite; Tooling owns its Limits/Error pairing acceptance.

Release 402168f preserves the earlier handoff, release-fixture ordering repair
and native-only JSON test fix. Preserve original failed release logs/artifacts
and earlier receipts at target/audits/release-fixture-order-20261031/,
wasm-json-boundary-20261031/ and wire-0110-20261031/; they retain their own graphs.
Canic sediment remains covered by
[#712 — Remove redundant limits from the runtime logging adapter](https://github.com/dragginzgame/canic/issues/712)
and [#100 — Bound observability read work and encoded page sizes](https://github.com/dragginzgame/canic/issues/100).
