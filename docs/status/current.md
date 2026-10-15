# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Pending 0.11.2

The reviewed 113-file Shared Tooling 0.15.2 candidate is
`ebca2ba2cbab7dba6427bac8151644e9d0960332`
([Shared PR #221](https://github.com/dragginzgame/shared-tooling/pull/221)).
Metadata, release and hook fixtures use its best-effort log replay helper.
Metrics retains explicit log selection, failure conditions, saved statuses and
cleanup/retention policy. Canonical refresh preserves the existing helper closure;
that log-replay update changes no compiler, dependency or executable selections.

Native/Wasm checks, Clippy, documentation and tests now use workspace-wide Cargo
gates for both packages. The separate `stable-check` command is retired; direct
package commands remain documented for focused development. Six generic
store/reference and candidate-archive cases move to
[Shared PR #222](https://github.com/dragginzgame/shared-tooling/pull/222), without
changing the selected helper payloads. Metrics retains actual workflow ordering,
collector status propagation, selected diagnostics and outer Git recovery-state
custody. Summary tests construct an admitted overflow boundary directly instead
of repeating aggregate merge/record setup.

The [arithmetic convergence review](../evidence/arithmetic-convergence-0112.md)
rejects shared rank and quotient/remainder prototypes after matched IC measurements.
Both preserve tested outputs, but introduce instruction regressions in other
cases. A fresh archive extraction rebuilds every raw Wasm byte-for-byte and repeats
both instruction/projection result sets. Runtime Rust source is restored to the
0.11.1 baseline; no API, stable layout or arithmetic cost change is retained.

Local `make ci` and the unified Rust 1.91 native/Wasm workspace gate pass on the
prepared working tree, including the incoming Memory 0.42 selection. That
manifest/lock change was preserved from the start of this tooling/test cleanup.
The producer's transferred cases and the streamlined Metrics evidence fixture
also pass on genuine Bash 3.2, with affected ShellCheck and documentation checks.
The earlier shared replay/completion and actual metadata/release/hook evidence
retains its original source scope. Shared PR #221 has completed Linux, Intel
macOS, Apple Silicon and lint acceptance on its exact source. Shared PR #222
has passing lint; its native matrix remains in progress. Neither producer
acceptance nor local validation establishes hosted acceptance of the pending
Metrics working tree.

## Released 0.11.1

Git commit `98e5c2f6788d142b6d0fe3fb111f8bb8d1936632` and tag `v0.11.1`
identify the latest finalized release. The official registry lists both 0.11.1
packages as non-yanked with Rust 1.91; stable selects Memory 0.41. This release
includes finite sample statistics and nearest scaled ratios. Sampling, floating
storage, units, quantile selection and reports stay caller-owned; stable V1 bytes
and integer floor projections retain their contracts.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38761839864)
has completed successfully. The prior [0.11.0 receipt](https://github.com/dragginzgame/ic-metrics/actions/runs/38728966486)
retains its own completed Linux, Intel macOS, Apple Silicon and MSRV acceptance.
[The handoff retained in released source](https://github.com/dragginzgame/ic-metrics/blob/98e5c2f6788d142b6d0fe3fb111f8bb8d1936632/docs/status/current.md)
preserves earlier preparation observations; they do not qualify later source.
[Older release narratives](history-through-0110.md) and frozen experiments retain
their original identities and scopes.

## Consumer owners

The test-only memory observer replacement remains with [#82](https://github.com/dragginzgame/ic-metrics/issues/82)
and [Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97); adopt only a
reviewed published registry package with the same stable-memory trait identity.
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned. Existing callers are not opted into persistence by publication.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary projections are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47), while
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) owns the original
remaining arithmetic-reader qualification. Publication, registry selection and
producer CI do not establish an owning application's acceptance.
