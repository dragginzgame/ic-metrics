# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.11.6

The private storage and development-tooling candidate is 0.11.6: compatible cleanup,
with no public API, V1 storage, dependency or Rust-floor change of its own. Fixed-size
reads now share bounded cursor admission. The matched four-type probe saves
46 raw Wasm bytes and 19 instructions per valid four-bound histogram load; all
other measured outcomes and the limitations are in
[the decoder comparison](../evidence/decoder-cleanup-0116.md).

Retention checks use the existing shared selected-assertion and exit helpers.
The fake parser/JSON rewrite and per-case synthetic Git checkouts are removed;
Metrics retains its roster, retained-success policy, real metadata bodies and
payload checks. Caller-selected TMPDIR is honored, with native CI evidence as
the default parent.

The reviewed snapshot now selects committed Shared Tooling source
`9b555ad46b7a74e8fbbeba234b8df60829be58ce` (base display version 0.15.8),
including the TOML-driven Rust setup in
[PR #239](https://github.com/dragginzgame/shared-tooling/pull/239). That PR is not
merged; this source selection does not claim a supplying release. CI prepares
pinned host parsers first, reads development/floor policy from the existing TOML
files and retains parser setup failures. The normal common-tool action reuses
the prepared host set. The upstream contribution uses an isolated checkout;
the normal Shared Tooling checkout is unchanged.

The hook wrapper no longer repeats formatter admission. Its baseline-failure
probe preserves nested diagnostics, while generic formatter-version failures
stay upstream. Unusual filenames use the real workflow hashing step; the focused
selector fixture retains inclusion, exclusion and missing-tracked-source checks.

CI now dispatches complete release/hook fixtures only through their retention
suite, preserving standalone focused entrypoints. Unexpected child failures
replay their active log before reporting retained evidence. Both native artifact
uploads disable recompression of the gzip archives. The observer replacement
remains publication-gated under [#82](https://github.com/dragginzgame/ic-metrics/issues/82).

The MSRV gate now derives its default from Cargo at execution time and keeps an
explicit prepared-toolchain override. The metadata adapter owns one NUL-delimited
release-file roster for Make, source admission and diff checks. The unit's private
representation is now immutable `Box<str>`; the
[matched identity study](../evidence/identity-storage-0116.md) qualifies its
construction/clone savings and unchanged decoder costs without changing V1 bytes.

Earlier focused stable tests, native/Wasm Clippy and actual Rust 1.91 package
checks passed with selected Memory 0.43. The incoming workspace/lock selection of
Memory 0.44 is preserved. The later unit-storage batch separately passes the 16
stable tests, native/Wasm Clippy and Rust 1.91 stable-package checks on that graph;
it does not establish complete downstream adoption or full release acceptance.
The retained release/hook/evidence fixture passes on Bash 5 and genuine Bash
3.2.57 on Linux; a relative parent with spaces preserves its failure status and
evidence. Full CI/MSRV release gates and new native macOS qualification were not
run. Package versions remain 0.11.5; source changes remain uncommitted.
Before-images and focused logs remain at `/tmp/metrics-decoder-cleanup.qnfxcC/`.
The tooling batch's separate before-images and logs remain at
`/tmp/metrics-workflow-cleanup.43ct3Y/`.
Its focused workflow, source-selector and retention checks pass on Bash 5 and
genuine Bash 3.2.57 on Linux, including baseline formatter failure and retained
host-tool candidates after early setup failure. The isolated Shared installer
fixtures pass on both shells. ShellCheck, workflow lint, offline host-tool
admission, documentation links and all 114 snapshot digests pass. The source
selection also adopts the upstream Make-executable routing; the release fixture
now forwards its tool calls through the selected substitute. Full CI/MSRV and
native macOS runs were not performed for this tooling batch. At the final review,
PR #239 was open at the selected commit with no hosted check results reported.

The dispatch/upload cleanup passes the actual `make release-tools-check` entry
on Bash 5 and the retention suite on genuine Bash 3.2.57, selected for its children
too. A substituted-gate probe executes the actual CI recipe and verifies its
roster and fail-fast behavior without running full CI. A separate unexpected
metadata-child failure verifies stdout/stderr replay, refused success and retained
status/input logs. Workflow lint, unchanged upload fields, documentation links
and ShellCheck pass. Before-images and logs for this slice remain at
`/tmp/metrics-ci-dispatch.0gOp7e/`; no Rust or dependency edits were made here.

Policy/unit before-images and logs remain at `/tmp/metrics-policy-unit.VGvbsA/`.
The MSRV default/override, failed compiler and failed parser cases use substitute
compilers against the actual Make/validation adapters. Real package-floor checks
are separately recorded above. Release/hook retention and roster projection pass
on Bash 5; no-tool roster reads preserve byte boundaries in ordinary and spaced
checkouts. The same retention suite passes on genuine Bash 3.2.57, selected for
its children. The frozen IC replay reproduces all four Wasms byte-for-byte and all
576 instruction/projection observations. No package version, root index or Git
ref is changed by this batch; full CI/MSRV release gates remain unrun.

## Finalized 0.11.5

Commit `0efa8d8d7aadb2bcebbd929364a50d3c317924ca` and tag `v0.11.5` identify
the finalized baseline. Its
[source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/0efa8d8d7aadb2bcebbd929364a50d3c317924ca/docs/status/current.md)
retains the original local observations, source identities and upstream
contributions. Finalization alone does not establish registry publication or
complete hosted/native acceptance.

## Released 0.11.4

Commit `9665613f05f6477fe97ad60562e54185ed875aac` and tag `v0.11.4` identify
that finalized release. At its recorded review, the registry listed both packages as
non-yanked with Rust 1.91; stable selects Memory 0.43.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38874976758)
had passed Linux, Apple Silicon and native/Wasm floors; Intel macOS remained in
progress, so complete native acceptance was not yet established by that observation.

This release shares common-tool preparation and Make fixture setup, keeps
exhaustive test permutations at Shared Tooling and preserves Metrics release,
corruption and evidence-custody checks. Its
[source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/9665613f05f6477fe97ad60562e54185ed875aac/docs/status/current.md)
retains the original local observations and selected snapshot identities.
Shared PRs [#231](https://github.com/dragginzgame/shared-tooling/pull/231) and
[#232](https://github.com/dragginzgame/shared-tooling/pull/232) now have complete
passing hosted matrices. The separately refreshed [PR #228](https://github.com/dragginzgame/shared-tooling/pull/228)
passes focused Bash 5/3.2 preflight, ShellCheck and documentation checks; its
new branch source needs its own hosted acceptance. No PR was merged.

## Released 0.11.3

Commit `362406df49365ef7894f52ad53a843760517a0b7` and tag `v0.11.3` identify
that finalized release. [Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38781538090)
has completed Linux, Intel macOS, Apple Silicon and native/Wasm floor acceptance.
This release adopts explicit shared Rust setup, trims maintenance payload copies
and keeps simulated preflight cases with their producer. Its
[retained preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/362406df49365ef7894f52ad53a843760517a0b7/docs/status/current.md)
owns the original local observations and snapshot identities; they do not qualify
later changes.

## Earlier releases

[Earlier release receipts](https://github.com/dragginzgame/ic-metrics/blob/362406df49365ef7894f52ad53a843760517a0b7/docs/status/current.md#released-0112)
retain the 0.11.2/0.11.1 source identities, publication observations and exact-source
CI results. [Older narratives](history-through-0110.md) keep their original scope.
The [arithmetic convergence review](../evidence/arithmetic-convergence-0112.md)
retains the rejected rank and quotient/remainder prototypes and their matched IC
measurements; those results do not qualify later source.

## Consumer owners

The supplying sample-statistics issue [#85](https://github.com/dragginzgame/ic-metrics/issues/85)
is complete after publication and exact-source native acceptance; Testkit's normal
registry adoption/delivery remains with [Testkit #103](https://github.com/dragginzgame/ic-testkit/issues/103).
Ratio [PR #81](https://github.com/dragginzgame/ic-metrics/pull/81) is closed as
superseded by published code, with its branch retained. Query's independent input
and percentage acceptance is recorded in [#80](https://github.com/dragginzgame/ic-metrics/issues/80).

The test-only memory observer replacement remains with [#82](https://github.com/dragginzgame/ic-metrics/issues/82)
and [Testkit PR #97](https://github.com/dragginzgame/ic-testkit/pull/97); adopt only a
reviewed published registry package with the same stable-memory trait identity.
Rechecked on 2026-10-16: the official `ic-testkit-native` index returns HTTP 404
and the supplying PR remains open at `741e2e8e89cd1442e29dd3a8e1ff235260806bf0`.
The local `WriteCountingMemory` observer remains until the supplying package is
published; no path dependency or replacement observer was introduced.
[The first durable consumer qualification](https://github.com/dragginzgame/ic-metrics/issues/83)
remains host-owned. Existing callers are not opted into persistence by publication.

Downstream acceptance stays with [the owning contract issues](../extraction.md#downstream-contract-checks).
Direct summary projections are tracked by [Timers #59](https://github.com/dragginzgame/ic-timers/issues/59)
and [Backup #47](https://github.com/dragginzgame/ic-backup/issues/47), while
the original remaining Canic qualification stays with
[#447](https://github.com/dragginzgame/canic/issues/447) and
[#99](https://github.com/dragginzgame/canic/issues/99).
The coordination-only [#10](https://github.com/dragginzgame/ic-metrics/issues/10)
is retired as not planned, preserving its evidence. Canic acceptance remains
unresolved; publication, registry selection and producer CI do not establish it.
