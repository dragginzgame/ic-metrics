# Current handoff — 2026-10-31

## Optional native metadata

PR #102 incorporates release 0.21.1 (e3b20e0) and selects pending 0.22 notes.
Native schema callers disabling defaults must explicitly select `native-wire`.
Default consumers retain metadata; arithmetic and canonical Serde stay available
without Wire. Wasm excludes Wire even with all features. Recording is independent
and Logging stays dependency-free. Numeric APIs, bytes and retained layouts do
not change. See [the 0.22 migration](../migration-022.md) and
[issue #101](https://github.com/dragginzgame/ic-observability/issues/101).

The merge preserves the released TypeScript conformance and Logging model work.
The TypeScript target now explicitly selects native-wire, so its ignored codec
test remains active when defaults are disabled. The exact prepared Node version
remains in ci/node-version.txt; the check never installs Node or npm inputs.

## Evidence and boundaries

The previous PR head cb66dd3 passed Linux, both macOS native jobs and MSRV CI.
Its earlier missing-autocfg failure was fixed through explicit locked application
source preparation before the offline gate; setup failures retain logs/outcomes.
Focused validation for this merge is recorded in the PR; no full release suite,
own-version bump, publication or deployment is included.

Release 0.21.1's generated codec evidence remains at
`target/audits/repo-improvements-021-20261030/` and
`target/typescript-conformance/` in its owning checkout, with its original scope.
Five reports exercise Rust/JavaScript codec parity, wide integers, exact caps,
overflow quality and fixed histograms. Rust restoration remains the canonical
arithmetic admission; these checks do not establish browser-side arithmetic.
The Logging event-history model retains its fixed schedule and eight seeded
256-operation schedules, without new dependencies or clock inputs.

Previous Wire adoption receipts remain at
`target/audits/wire-0100-20261030/`; their identity/scope is unchanged.
Release e3b20e0 preserves the prior handoff and canonical evidence links.
Shared Tooling remains reviewed 0.27.11, revision
`62edfbd43087a718bf0283e9040676a49211976d`.

## Adoption

[Tooling #268](https://github.com/dragginzgame/ic-tooling/issues/268) owns adoption
after this supplier capability is integrated and released. The supplier issue
can close on merge; this does not prove registry publication or consumer uptake.
Existing durable adapters and consumer runtime acceptance remain at their owners.
No normal sibling checkout was edited.
