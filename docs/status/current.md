# Current handoff — 2026-10-30

## Accepted scope and source

The IC Tooling maintainer accepted an arithmetic-only dependency profile for
Testkit's exact ratio reuse. This isolated contribution is based on release
0.18.0, `f8d52905dea917b6fbc89b708b7a29ccfea4d4d8`. Pending notes select 0.19.0
because native callers that disabled defaults previously received Wire metadata.
Own package versions, lockfile, compiler policy and tool pins are unchanged.
No release, publication, deployment or normal sibling checkout edit ran.

[Issue #101 — Allow native arithmetic consumers to exclude Wire metadata dependencies](https://github.com/dragginzgame/ic-observability/issues/101)
owns the supplier capability. The default-enabled `native-wire` feature retains
native metadata for default consumers; disabling defaults excludes native Wire.
Serde transport and numeric admission remain unconditional. Recording remains
independent, and Wasm still excludes the native dependency even with all features.
No arithmetic implementation, units, errors, rounding or encoded shape changed.

The declaration policy retains exact native placement and TypeScript capability,
requires only the named optional-dependency edge, and rejects other dependency
feature forwarding. Logging remains dependency-free and independent. Documentation
and the 0.19 migration guide describe explicit metadata selection when defaults
are disabled. The existing Make/CI minimal checks and all-feature gates cover the
new profile selections; no new aggregate validation or package was added.

## Focused qualification

Evidence is `/tmp/ic-tooling-converge-0706.sw5uqp/`. Selected Metrics strict
library/test/all-feature Clippy passes on prepared Rust 1.99.1. Actual Rust 1.91
passes six ratio tests with defaults disabled and eight default metadata/transport
tests. Minimal-profile doctests pass. The all-feature Metrics library compiles
for Wasm on Rust 1.91. Native minimal/default and all-feature Wasm graphs prove
Wire exclusion/inclusion and no Platform dependency as selected.

The actual production declaration check and its admission/refusal fixtures pass.
Formatting, selected ShellCheck, product documentation links and diff checks pass.
The first fixture attempt exposed a required-dependency/optional-feature mismatch
in a negative test; it was corrected and the failure evidence remains retained.
No full workspace/release gate, native macOS execution, installed IC experiment
or performance measurement ran. Native macOS acceptance remains separate.

## Consumer adoption and retained boundaries

[IC Tooling #268 — Delegate Testkit scaled benchmark averages to ic-metrics](https://github.com/dragginzgame/ic-tooling/issues/268)
remains consumer adoption work after the supplier change is integrated and
released. Testkit's existing graph guards stay intact in its normal checkout;
this source contribution does not establish registry availability or adoption.
Native schema callers that disable defaults must select `native-wire` after
upgrading. Default-enabled callers, numeric Serde layouts and persisted records
need no migration from this feature selection alone.

Logging's separate 0.18 lifecycle/checkpoint adoption and retained-data obligations
remain with their owners. Prior evidence, sanitized/public distribution limits,
original archives and stable-adapter migration facts are preserved in
`f8d52905dea917b6fbc89b708b7a29ccfea4d4d8:docs/status/current.md`, its linked
history and canonical evidence documents. No historical receipts or artifacts
were rewritten, removed or reclassified by this contribution.
