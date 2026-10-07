# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` measurement arithmetic.
`record_sample`, `MeasurementSummary` and the separate `MeasurementHistogram`
preserve explicit units, empty/zero and independent saturation contracts.
Consumers own platform reads, attribution, identities, registries, labels,
persistence, lifecycle and endpoints. See [the extraction contract](../extraction.md).

## Current release

Published 0.2.5, tag `v0.2.5`, local HEAD and remote main identify
`d8b3a46f24518a033cd36e40bf1f1895099b809f`. The official registry index
reports a non-yanked, dependency-free, feature-free package with checksum
`f03846f188137170575ee48c04ece8a5d2d54096206d55bd7f56cd97afeac2fe`.
The downloaded archive matches its checksum, embedded Git identity, Rust source,
original manifest, tagged README, license and lock. Cargo metadata remains 0.2.5;
Released Rust source is unchanged from v0.2.4. The working tree now contains
the compatible mean API and guide described below.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37589261498)
now passes Linux, both native macOS hosts and MSRV.
[#14](https://github.com/dragginzgame/ic-metrics/issues/14) is completed.
The [release record](../evidence/release-025.md) retains exact
source, archive and downstream workflow observations.

## Shared Tooling

The prepared 63-file snapshot and AGENTS identify reviewed
`bfb50bd0884b5e6c5ee9592056531c6108f96d73` (0.1.15), distributed from a
separate clean detached checkout. All declared files match its committed bytes
and modes. Six explicitly added files supply the common Make include, workspace
and tooling reports, and their focused fixtures. The existing Make execution
guard is declared with all release/logger/hook dependencies; consumer fixture
exports and native source receipts include it. Rejected execution modes do not
produce validation or formatting evidence; nested selections and parallel
controls retain their existing contract. The virtual root and `crates/ic-metrics`
layout conform to the refreshed `crates/` or application-owned `apps/` rule.

The [0.2.5 preparation record](../evidence/adoption-025.md) retains focused GNU
Bash 3.2 rejection, preservation, release recovery and source-equality evidence.
[Upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37593142226)
passes all three native hosts and lint/security at the adopted source.
Remote and local committed upstream main select the adopted revision.
[Shared Tooling #37](https://github.com/dragginzgame/shared-tooling/issues/37)
owns Canic's logger-convergence proposal; no new committed API is available.
[Tooling adoption #16](https://github.com/dragginzgame/ic-metrics/issues/16)
now has its consumer implementation prepared. The common include owns setup,
offline verification, `cloc` and `cloc-tooling`; copied setup recipes are removed.
Pinned host setup selects jq/yq/ripgrep with PCRE2/cloc. CI uses the same targets,
records the complete source/tool inputs and no longer selects system ripgrep.
Release and formatting exports carry the include. Existing pins are preserved;
only the reviewed cloc identity is added.

The [0.2.6 adoption record](../evidence/adoption-026.md) retains the actual pinned
Linux installation/offline workspace report and focused default-Bash fixture,
lint and source comparison results. The same focused pass also succeeds under
verified real GNU Bash 3.2.57. Snapshot, links, pins and formatting pass.
This dirty consumer wiring has no matching hosted/native CI yet. Pending 0.2.6
combines compatible developer-tooling and arithmetic/documentation additions
from finalized 0.2.5; Cargo versions and the root lock remain unchanged.
Existing release-note history is preserved.
The finalizer whitespace fix is still absent from 0.1.15 and remains in
[#18](https://github.com/dragginzgame/ic-metrics/issues/18), awaiting its shared owner.

## Downstream qualification

All four inspected local committed graphs select registry ic-metrics 0.2.
[The release record](../evidence/release-025.md#downstream-inspection) binds their
exact revisions, lock selections and all applicable workflow observations.
IC Timers 0.14.6 passes native Linux/macOS, MSRV and separate tag truth. IC Backup
0.5.0 passes main and tag CI on all three native hosts. IcyDB's full CI still
fails in formatting-tool installation and portable automation qualification;
its passing SQL Tier C lane does not replace that full gate. Canic's local 0.2
migration remains ahead of remote main, whose preflight fails.

The separate uncommitted IC Backup custody repair retains its own source and
native requirements in [IC Backup #13](https://github.com/dragginzgame/ic-backup/issues/13).
Invocation accounting and actual IC interleaving evidence remain with
[Canic #99](https://github.com/dragginzgame/canic/issues/99).
Root adoption coordination remains in [#4](https://github.com/dragginzgame/ic-metrics/issues/4)
and [#10](https://github.com/dragginzgame/ic-metrics/issues/10); new root publication
and the two passing consumer releases do not complete other owners' obligations.
No sibling file, build or dependency changes ran.

## Bounded distributions

The histogram API is available starting with registry 0.2.4; consumers using it
need that published minimum in their root catalog. Immutable inclusive bounds
produce disjoint saturating counts, separate overflow and the canonical summary.
Construction and recording support constant evaluation. Bounds and reporting
remain consumer-owned; no quantile estimate or global consumer ID is added.
The [preparation record](../evidence/histogram-024.md) retains its original inputs.

The prior read-only counter audit found no existing measurement histogram to
replace. Counts/totals, summaries, chronological histories and category/domain
buckets have separate contracts. Histogram use samples admitted raw values at
the producer and projects its canonical summary once. Owning investigations are
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
IC Timers retains its summary-only runtime after its owning evaluation; a named
application distribution need and acceptable budget are prerequisites to revisit it.
Publication availability has been reported; workloads, bounds, storage budgets
and owning qualification remain their decisions. IC cost evidence must include
recording work outside the existing sampled callback envelope and preserve
completion/trap/stale/terminal-removal admission and registration/reset identity.
The new [two-bound cost experiment](../evidence/histogram-cost-026.md) qualifies
an isolated Canic source-copy recording path on Linux PocketIC 16.0.0. All 138
observations validate the canonical count/total and buckets. At 1,000 repeated-key
records, histogram recording adds 42,000–75,000 instructions and 42,035–75,035
observed whole-update cycles over count/total. Slot size is 72 versus 16 bytes;
raw fixture Wasm grows by 208 bytes. These results do not qualify another bound
count, map cardinality, full application, timer admission, mainnet or macOS.
The owning fixture sources, locks, logs, artifacts and receipts remain under
`target/evidence/histogram-cost-026/`; sibling files were not changed.

The subsequent read-only arithmetic review found one concrete projection gap:
IcyDB's CLI divides independently saturating instruction totals and counts.
[IcyDB #313](https://github.com/dragginzgame/icydb/issues/313) owns unavailable
average display; [root #17](https://github.com/dragginzgame/ic-metrics/issues/17)
now has a compatible constant-capable `checked_mean(samples, total)` and
`MeasurementSummary::mean()` prepared without new storage. Empty is `None`,
measured zero is `Some(0)`, and unsaturated means round down. Typed
`MeasurementMeanError` rejects inconsistent empty pairs and either counter at
the cap, including exactly reached saturation. The summary delegates to one
canonical raw-field projection. This API is not in published 0.2.5 yet.
Timer memory-page pairs, Canic u128 history and exact
journal/catalog accounting retain their distinct consumer contracts. Reviewed
Canic local source advanced to `8db6ff3ac40e49783a98fdd50a0ea0088c2872c4`
and was clean; remote main still identifies the older source in the release
record, with no hosted run for that new local identity. The other three
consumer working trees were dirty; inspected measurement files matched HEAD.

The [packaged application guide](../../crates/ic-metrics/src/application.md)
for [#20](https://github.com/dragginzgame/ic-metrics/issues/20) is included in crate
documentation. Its focused compiled example uses fixed named histograms,
separate units and a simple event count; it projects each histogram's existing
summary once. Sampling, async attribution, reset identity, exact enforcement,
authorization and endpoints remain consumer-owned. Toko's saved audit supplied
the design motivation; its application source was unavailable and no Toko
integration or per-role Wasm estimate is qualified.

The [arithmetic preparation record](../evidence/arithmetic-026.md) binds final
source to focused Linux host/Wasm warning-denied Clippy, named mean and existing
histogram tests, guide/API doctests, MSRV and documentation/package checks.
No package versions, dependencies or established recording semantics change.

## Historical evidence

The [v0.2.5 handoff](https://github.com/dragginzgame/ic-metrics/blob/v0.2.5/docs/status/current.md)
retains that release's preparation-era wording; it is not current publication
status. Source-bound reports remain under `docs/evidence/` and in
[the host record](../hosts.md). The earlier continuation inspected publication,
issues and CI. This batch adds the mean API and guide and runs the bounded cost
experiment. No full local CI/test gate, sibling mutation, commit, push, tag,
package version change or release command ran. The dirty 0.2.6 batch still
requires committed owning native CI.
