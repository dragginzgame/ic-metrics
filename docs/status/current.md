# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.11.7

This is compatible development-tooling cleanup. Package versions remain 0.11.6;
no arithmetic API, stable V1 bytes, product dependency or Rust floor changes.
The root index and Git refs remain maintainer-owned.

The snapshot selects reviewed committed Shared Tooling source
`d33cb5251b537636d6d0619c75accf658592f99e` (base display version 0.16.0),
including [PR #246](https://github.com/dragginzgame/shared-tooling/pull/246).
It removes the two unused entrypoints through the distribution helper:
`retain-failure-evidence/action.yml` and `install-ci-tool.sh`. Actual native
collection, direct uploads and common tool setup retain their active helpers.
The selected shared contracts require explicit assertion selection and narrowed
Make admission probes; Metrics already uses those contracts. Fleet tooling Make
commands stay upstream. The standalone floor reader is a declared companion of
Rust setup; the local validation adapter now delegates to it too, preserving
explicit prepared-toolchain overrides and disabled Rustup auto-install.

Generic runner/preflight failure qualification, common-tool reporting probes and
archive failure mechanics now stay at Shared Tooling's producer fixtures in
[PR #247](https://github.com/dragginzgame/shared-tooling/pull/247), exact source
`14c1a433273effd1a2449690f77ee484f37c2b8e`. The real runner/helper matrix
preserves source/index, old tools and destination refs without reaching release
preparation. Reporter checks preserve partial output; archive checks preserve
readable diagnostics and their checksum through partial writes. Production helper
bytes match the selected snapshot, so this fixture-only contribution requires no
new snapshot selection. The PR remains open for upstream review/integration.

Metrics retains its cold/standalone preparation-authority routing, exact catalog
and package selections, actual source refusal and Git custody. Its workflow
fixture substitutes the shared reporter and outer archive helper boundaries,
keeping real workflow ordering, partial-log retention, failure status and skipped
later work. Normal archive cases still execute the real collector and restore
Metrics' diagnostics, nested index and release intent; tar command spelling and
the repeated fake common-tool inventory are removed.

Release-admission fixtures now use ordinary Git clone/checkout operations with
per-case indexes and one baseline-owned source-object link. They read the selected
release's version/date from that checkout, removing the separate initial source
archive. Hidden staged edits, source/index custody and selected-commit checks
remain intact. The snapshot exporter removes three redundant explicit roots
(`rewrite-local-lock-versions.pl`, `archive-evidence.sh`, `select-tool-evidence.sh`);
all 113 payload identities and the selected revision remain unchanged.

The histogram range-construction prototype is rejected and the maintained Rust
source restored byte-for-byte. It saves 5 raw Wasm bytes but increases common
query costs by up to 511 IC instructions per call at 256 bounds. The
[matched experiment](../evidence/quantile-range-0117.md) retains the frozen
candidate, typed result parity, raw cycles and byte-identical independent replay.
There is no downstream runtime contract change to adopt.

Focused evidence and before-images remain under
`/tmp/metrics-floor-quantile.KevI5d/`. The Shared contribution uses an isolated
checkout; the normal sibling's incoming dirty work is untouched. PR #246 is open;
selection of its exact reviewed commit does not claim a merged/supplying release.
The reader/setup fixture and release-retention suite pass on Bash 5 and genuine
Bash 3.2.57 on Linux. Workflow evidence passes on both shells in disposable
committed source `a0ad2ccd0833081fff1778131b73853812aeb98f`, as do pin checks.
The real checkout still has tracked snapshot deletions pending commit: pin checks
and source hashing deliberately refuse those missing tracked inputs. The source
selection, not a weakened check, qualifies the intended post-commit tree.
MSRV adapter probes preserve default/override selection, parser/compiler failures
and disabled auto-install using compiler substitutes; they are not full MSRV.
All 113 snapshot digests, selected ShellCheck, workflow lint, maintained links and
both archive/inner checksums pass. The archive readback matches the independently
replayed payload. Full CI/MSRV gates and native macOS qualification were not run.
PR #246's hosted lint/security check passes; its three native portable jobs were
still running at the final observation. The observer follow-up stays under
[#82](https://github.com/dragginzgame/ic-metrics/issues/82).

The fixture-ownership slice retains incoming before-images and focused logs at
`/tmp/metrics-fixture-owners.z3nJha/`. All three producer fixtures pass on Bash 5
and genuine Bash 3.2.57, as do Metrics' release/hook retention and workflow
evidence checks. Workflow evidence uses disposable committed source
`b1fe4a4ac090585bba5f784e05e7fdc393d0e5e5` because the real checkout has tracked
snapshot deletions pending commit. Selected ShellCheck, docs and diff checks pass.
This slice changes no product Rust, package versions, dependency lock, root index
or root Git ref. Full CI/MSRV and native macOS qualification remain unrun.

The checkout/root-selection slice retains before-images and focused logs under
`/tmp/metrics-checkout-cleanup.EZMxLN/`. Release/hook retention passes on Bash 5
and genuine Bash 3.2.57; the admission fixture also passes on Bash 3.2 with a spaced
scratch parent. Snapshot integrity, selected ShellCheck, docs and diff checks pass.
The root index/ref, product Rust, manifests and lock remain unchanged by this
slice. No new full CI/MSRV or native macOS qualification is claimed.
The observer prerequisite was rechecked on 2026-10-16: the official registry index
for `ic-testkit-native` returns 404 and Testkit PR #97 remains open at
`741e2e8e89cd1442e29dd3a8e1ff235260806bf0`. Its existing owning issue #82 remains
open; the local observer and dependency graph remain intact until publication.

## Finalized 0.11.6

Commit `604276df62e898568a1f388851340dd6525a2d9f` identifies the finalized
baseline. Its
[source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/604276df62e898568a1f388851340dd6525a2d9f/docs/status/current.md)
retains the earlier focused observations, source identities, decoder/identity
experiments and upstream contributions. Finalization alone does not establish
registry publication or complete hosted/native acceptance.
