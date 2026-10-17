# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.13.0

This is a stable-package collection API cut. MetricsMap now uses IC Storage's
governed upstream B-tree facade; its generic argument is the runtime backing,
rather than an already opened virtual handle. Hosts open the map with an admitted
Memory runtime handle and supply it to MetricsStore. The
[stable guide](../../crates/ic-metrics-stable/README.md#store-operations) owns caller
changes and the compiled host example. Package versions remain 0.12.0. The lock
adds Storage 0.3.1; Memory 0.45.0 and all other selected packages are unchanged.
The arithmetic package remains dependency-free.

Host-owned bootstrap, permanent allocation keys, concurrency, checkpoint cadence
and resets are preserved. IC Storage's custom tree format is not selected. The
upstream collection format and Metrics V1 rows remain unchanged; the codec owns
typed admission of frozen kind IDs 1/2/3/4. Raw backing and raw upstream map inputs
are rejected by compiled examples. Memory 0.45's cloneable handles do not enforce
exclusive collection ownership; hosts still prevent concurrent stores per region.
Memory's separate allocator-format disposition is not a Metrics store reset.

The [frozen IC upgrade study](../evidence/governed-store-0130.md) retains original
0.12 and prepared sources, the exact fixture graph, two Wasms and 24 observations.
All four kinds survive the forward upgrade byte-for-byte at the same allocation;
new checkpoints, including actual scalar overflow, remain readable after a
reverse binary upgrade. Independent fresh-target replay reproduces both Wasms,
all raw replies and every instruction/cycle row. The whole probe is 79 Wasm bytes
smaller; overlapping load-cost ranges establish no general performance gain.
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

Focused Linux qualification passes: 19 stable units, the complete four-family
host example and two negative admission examples, native/Wasm Clippy and native/
Wasm Rust 1.91 package checks. Pin/snapshot, formatting, documentation and diff
checks pass. Full local CI/MSRV gates and native macOS checks were not run for this
batch. Before-images and logs remain under `/tmp/metrics-governed.5eerdy/`.
Root staging, Git refs and package versions are unchanged; Metrics changes remain
uncommitted. Only the isolated Shared contribution has scoped commits and a
review-branch push.

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
