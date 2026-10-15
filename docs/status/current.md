# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Pending 0.11.3

The reviewed 112-file Shared Tooling 0.15.2 candidate is
`6ed2e1c048e3a56b6993ac20372dd1b7aaf366ab`. It retains the selected log-replay
helper from [Shared PR #221](https://github.com/dragginzgame/shared-tooling/pull/221)
and incorporates the merged [optional maintenance payload selection](https://github.com/dragginzgame/shared-tooling/pull/220).
Canonical refresh retires the unused runner and two systemd copies while retaining
the task catalog, schedule guidance and explicit upstream operational-file list.
No Metrics caller selects the retired files; the operational owner remains Shared
Tooling. The arithmetic/stable APIs, Cargo graph and compiler selections are unchanged.

The explicit shared Rust installer now serves local preparation and both CI
lanes. Its canonical snapshot entrypoint is selected directly; each lane retains
its compiler/components/target policy and recorded setup outcome. Actual workflow
setup bodies are exercised with substituted rustup. Ten overlapping simulated
cache/tool scenarios move to [Shared PR #228](https://github.com/dragginzgame/shared-tooling/pull/228),
whose expanded producer fixture passes on Bash 5 and genuine Bash 3.2. Metrics
retains internal preparation selection, real committed-graph offline Cargo checks,
runner refusal ordering, explicit pin overrides and original Git-state custody.

Snapshot verification, documentation links, dependency pins and diff checks pass.
Full `make ci` passes on a committed review checkout. After making yq's scalar
output format explicit, the affected native source/evidence fixture passes again
on Bash 5 and genuine Bash 3.2 without warnings; unchanged gates reuse the CI run.
Real Linux setup prepares the selected Rust 1.99/1.91 components/targets and
preserves the default toolchain. The Rust 1.91 native/Wasm workspace gate passes
after setup. The final review checkout has equivalent selected source inputs.
The real working tree retains the canonical deletions for the maintainer to
commit; its source-hash boundary deliberately refuses missing tracked files until
then. No root index or release metadata was changed by this cleanup. Current
workflow native acceptance remains with the configured hosted CI after delivery.

## Released 0.11.2

Commit `66582edd7748b94849494eeb3763345e7711e485` and tag `v0.11.2` identify
the latest finalized release. Both official non-yanked packages declare Rust 1.91;
their downloaded archives match the official index checksums and identify that
exact VCS source. Stable selects Memory 0.42. [Release CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38771889433)
has completed Linux, Intel macOS, Apple Silicon and the native/Wasm floor job
successfully.

This release consolidates workspace validation, shares fixture log replay and
keeps generic diagnostic regressions with their producer. Its
[retained preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/66582edd7748b94849494eeb3763345e7711e485/docs/status/current.md)
owns the original local CI/Bash 3.2 observations. The
[arithmetic convergence review](../evidence/arithmetic-convergence-0112.md)
retains the rejected rank and quotient/remainder prototypes and their matched IC
measurements. Runtime arithmetic remains unchanged by that experiment.

## Released 0.11.1

Git commit `98e5c2f6788d142b6d0fe3fb111f8bb8d1936632` and tag `v0.11.1`
identify the preceding release. The official registry lists both 0.11.1
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

The supplying sample-statistics issue [#85](https://github.com/dragginzgame/ic-metrics/issues/85)
is complete after publication and exact-source native acceptance; Testkit's normal
registry adoption/delivery remains with [Testkit #103](https://github.com/dragginzgame/ic-testkit/issues/103).
Ratio [PR #81](https://github.com/dragginzgame/ic-metrics/pull/81) is closed as
superseded by published code, with its branch retained. Query's independent input
and percentage acceptance remains with [#80](https://github.com/dragginzgame/ic-metrics/issues/80).

The test-only memory observer replacement remains with [#82](https://github.com/dragginzgame/ic-metrics/issues/82)
and [Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97); adopt only a
reviewed published registry package with the same stable-memory trait identity.
The official `ic-testkit-native` index still returns 404 at this review; the local
`WriteCountingMemory` observer remains until the supplying package is published.
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned. Existing callers are not opted into persistence by publication.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary projections are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47), while
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) owns the original
remaining arithmetic-reader qualification. Publication, registry selection and
producer CI do not establish an owning application's acceptance.
