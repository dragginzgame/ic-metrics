# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.13.2

Reuse Memory 0.47's `testing::fixture_runtime` in native store fixtures and the
lease-transfer test. Its `test-support` feature is selected only by the stable
package's development dependency; production hosts still own their bootstrap.
Private codec sizes are associated constants, including typed bound-count
refusal before stored-row reads. The over-limit constant is also checked at
`usize::MAX` without evaluating overflowing size arithmetic. V1 layouts,
identities, checkpoint ordering and no-write behavior remain unchanged.

Adopt committed Shared Tooling 0.20.0 at
`3f87ddc1a0c1616775b2114c42a4adee7376c9b1` through the canonical exporter from a
clean isolated checkout. Its 113 payloads include literal catalog admission,
canonical release-version validation and the include-owned delivery guard.
Host, Rust and IC pin catalogs are unchanged; common setup and offline checks
pass. The sibling's uncommitted 0.20.1 changes are excluded.

Metrics now owns `package-native-recovery-evidence.sh`, its focused packaging
fixture and workflow wiring, adopting the implementation prepared in
[PR #88](https://github.com/dragginzgame/ic-metrics/pull/88). The old shared
collector is retired through snapshot ownership proof. Full recovery archives
retain hidden Git state; sanitized diagnostics remain shared. Delivery remains
with [#89 — Own native recovery-archive packaging in Metrics](https://github.com/dragginzgame/ic-metrics/issues/89).

The Testkit observer package still has no official registry entry. The local
write observer remains until the replacement is published and qualified under
[#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82).
No sibling sources, product versions, locked package versions or existing evidence
archives are changed. The selected Memory/Storage pair remains 0.47.0/0.4.0.

Focused Linux Rust checks pass: 20 stable units, three doctests, strict native/
Wasm Clippy and actual Rust 1.91 native/Wasm package checks and doctests. The
actual release/hook/metadata/admission retention fixture passes. The workflow
source/setup/archive fixture passes in the isolated committed source; the local
packaging matrix, selected ShellCheck, workflow lint, LOC report and snapshot,
formatting, pin and documentation checks also pass. Logs and
before-images are under `target/cleanup-shared-020/review.GGcoKH/`. Workflow
qualification uses an isolated committed source because snapshot retirement
leaves a missing tracked file before the maintainer commits it. This does not
weaken the source selector's deliberate refusal of missing tracked inputs.
Full local CI/MSRV gates and native macOS checks were not run for this batch.
Changes remain uncommitted on `6cb257e4e8673a776fe50a90127d2a50036e01e2`;
the real index, Git refs and package versions are unchanged.

## Finalized 0.13.1

Restore the workspace arithmetic dependency's registry requirement (`0.13`)
alongside its local path. Cargo strips that path during publication; without
the requirement, the stable package cannot be packaged. The supplying release
source is `6cb257e4e8673a776fe50a90127d2a50036e01e2`; package versions are 0.13.1. The existing release renderer advances simple local version requirements
with workspace minor changes; its two-package metadata fixture qualifies that
boundary. Publication and release execution remain separate maintainer actions.
Both packages pass a real Cargo publication dry run with packaged compilation;
uploads were explicitly aborted by `--dry-run`. The metadata fixture, formatting,
pin and documentation checks pass. Logs remain under
`target/publish-metadata-repair/review.6uTSxJ/`. That dry run selected the prepared
0.13.0 package identity; it is not relabelled as publication of 0.13.1.

## Finalized 0.13.0

This is a stable-package collection API cut. MetricsMap now uses IC Storage's
governed upstream B-tree facade; its generic argument is the runtime backing,
rather than an already opened virtual handle. Hosts open the map with an admitted
Memory runtime handle and supply it to MetricsStore. The
[stable guide](../../crates/ic-metrics-stable/README.md#store-operations) owns caller
changes and the compiled host example. Package versions are 0.13.0. The lock
selects published Storage 0.4.0 and Memory 0.47.0 together; all other selected
package identities remain unchanged. The arithmetic package remains dependency-free.
The old Memory collection re-export is retired from production and examples.
Its narrow root backing imports remain the generic/host boundary; Storage owns
collection opening. The independent original-map byte-compatibility test uses
an explicitly test-only substrate dependency and still opens that map through
an admitted Memory runtime handle. No raw collection is publicly re-exported.
The adoption addresses
[#87 — Finish narrow imports in the governed metrics-map adoption](https://github.com/dragginzgame/ic-metrics/issues/87).

Host-owned bootstrap, permanent allocation keys, concurrency, checkpoint cadence
and resets are preserved. IC Storage's custom tree format is not selected. The
upstream collection format and Metrics V1 rows remain unchanged; the codec owns
typed admission of frozen kind IDs 1/2/3/4. Compiled examples reject raw backing
at map opening and reject an admitted handle where a governed map is required.
Memory handles are non-cloneable allocation leases. A second open through the
same runtime refuses while the store or its transferred map is alive; dropping
the collection permits reopening. Hosts retain exclusive backing custody across
runtimes. Memory 0.47 preserves 0.45 allocation images; no reset is part of this
adoption.

The [frozen IC upgrade study](../evidence/governed-store-0130.md) retains original
0.12 and prepared sources, the exact fixture graph, two Wasms and 24 observations.
All four kinds survive the forward upgrade byte-for-byte at the same allocation;
new checkpoints, including actual scalar overflow, remain readable after a
reverse binary upgrade. Independent fresh-target replay reproduces both Wasms,
all raw replies and every instruction/cycle row. The whole probe is 79 Wasm bytes
smaller; overlapping load-cost ranges establish no general performance gain.
That frozen study selects Memory 0.45 and Storage 0.3.1, not the newly selected
graph; its IC costs are not relabelled as measurements of this adoption.
An initially reused host driver was detected before execution and is identified
separately in the evidence. No product runtime endpoint or server caller is added.

Shared Tooling is selected at reviewed commit
`1bffab48a1c71015525c9f2d57bdbda215235711`, display version 0.17.2, through the
canonical exporter from a clean committed isolated checkout (114 files).
[PR #259](https://github.com/dragginzgame/shared-tooling/pull/259) is stacked on
[PR #254](https://github.com/dragginzgame/shared-tooling/pull/254), preserving the
already selected optional IC-tool contract. Metrics declares direct delivery once
in ci/release-delivery.txt. Make and standalone metadata reuse the same admission;
unsupported modes refuse before effects. Producer focused fixtures/ShellCheck and
Metrics' release, metadata, failure-retention and workflow fixtures pass. Shared
hosted lint checks pass; its required native matrix remains separately qualified.

Focused Linux qualification of the published graph passes: the actual
`make check` failure point, 20 stable units, the complete four-family host
example and two constructor-refusal doctests, strict native/Wasm Clippy and
actual Rust 1.91 native/Wasm checks and doctests. The new lease test verifies
that transferring the map out of the store retains its lease and dropping it
permits reopening with the stored counter intact. Logs and before-images are
under `target/memory-047-adoption/review.WdXJWZ/`. Full local CI/MSRV gates and
native macOS qualification were not run for this adoption. The earlier collection-cut
before-images and logs remain under `/tmp/metrics-governed.5eerdy/`; its passing
results do not qualify the newly selected dependencies. The previous Memory 0.45
build-repair evidence remains under `target/memory-ci-repair/review.9VQeRQ/`.
Staging, Git refs and package versions remain unchanged during this adoption.
The dependency adoption and caller updates were finalized at
`dec1510f594e132de9713916ced11996d68a95f7`. The attempted publication failed at
manifest verification; that release commit alone does not establish publication.

The incoming borrowed-bounds API and rejected rank/ratio refactors are preserved
in this minor batch. Their [earlier study](../evidence/bounds-rank-0121.md) keeps its
original 0.12.1 preparation identity; it is not relabelled as a new measurement.
Selected public sibling crate/manifest paths contain no stable-package callers;
their arithmetic interfaces require no changes for this cut. Excluded private
repositories were not inspected. First durable-consumer acceptance stays with
[#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83).
Observer publication/adoption stays with
[#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82).

## Finalized 0.12.0

Commit `1c56fdfdd331e1bd26cfdb14519b1296ad3e88f0` and tag `v0.12.0` identify the
finalized release source. The
[source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/1c56fdfdd331e1bd26cfdb14519b1296ad3e88f0/docs/status/current.md)
retains the stable API cut, Shared Tooling adoption, earlier rejected statistics
trial and their qualification limits. Its preparation checks are not relabelled
as hosted release or publication evidence.
