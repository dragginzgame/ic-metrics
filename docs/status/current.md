# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` measurement arithmetic.
`record_sample`, `MeasurementSummary` and the separate `MeasurementHistogram`
preserve explicit units, empty/zero and independent saturation contracts.
Consumers own platform reads, attribution, identities, registries, labels,
persistence, lifecycle and endpoints. See [the extraction contract](../extraction.md).

## Current release

Published 0.2.4 and tag `v0.2.4` identify source
`21e980b3ed4f1a8d9b6203079ef1e457a3fea588`, also verified as remote main.
The official registry index reports a non-yanked, dependency-free, feature-free
package with checksum
`7bec2da218f678f1e91693bb890a30e185daf0ac1b97475bf42e280dade2d9b6`.
The downloaded archive matches that checksum, embedded Git identity, Rust source,
original manifest, license, tagged README and lock. Cargo metadata remains 0.2.4.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37587072330)
passes Linux, both native macOS hosts and MSRV, with native evidence uploads
successful. The [release record](../evidence/release-024.md) keeps publication
and compiler/tooling qualification separate from consumer and IC cost evidence.
The completed histogram and prior Shared Tooling adoption belong to
[#15](https://github.com/dragginzgame/ic-metrics/issues/15) and
[#13](https://github.com/dragginzgame/ic-metrics/issues/13).

## Shared Tooling adoption

The current uncommitted 57-file snapshot records reviewed
`25e7ce83149e081e4dcc52c55c33724e44153f2a` (0.1.14), distributed through its
helper from a separate clean detached checkout. The new Make execution guard is
explicitly declared with its release/logger/hook callers. AGENTS identifies the
same source. The broader `crates/` or application-owned `apps/` rule and corrected
IC Host Tooling ownership guides are refreshed together; this library's existing
virtual root and `crates/ic-metrics` layout need no change. Dirty upstream 0.1.15
LOC work was inspected separately and is not copied.

Release, validation and pre-commit formatting reject inherited Make modes that
ignore failures or skip execution before dispatch. Normal release selections
and jobserver settings remain supported. Consumer fixtures copy the new helper,
clear independently owned Make controls and test actual logger rejection without
running real CI or a release. Native CI's source receipt includes the new guard.

Focused Linux GNU Bash 3.2.57 checks pass release destination/recovery, metadata
rollback, selected-commit admission, six rejected consumer logger modes, twelve
retention scenarios and actual formatting-hook preservation/installation. The
matching upstream logger and hook-mode fixtures pass locally too, including
legitimate nested selections and parallel controls. Selected ShellCheck,
workflow lint, snapshot/source comparison, links, pins and formatting pass.
See [the adoption record](../evidence/adoption-025.md).

[Upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37586649650)
passes all three native hosts and lint/security at the exact adopted source.
This dirty consumer batch has no matching hosted run and remains tracked in
[#14](https://github.com/dragginzgame/ic-metrics/issues/14).
The pending 0.2.5 changelog is a compatible tooling fix from finalized 0.2.4;
library APIs, units, storage, dependency graph and package versions are unchanged.
No reset or consumer migration is required by this patch.

## Bounded distributions and consumers

The histogram API is available starting with registry 0.2.4. Consumers using it
need that published minimum in their root catalog. Inclusive immutable bounds
produce disjoint saturating counts, separate overflow and the canonical summary.
Construction and recording support constant evaluation. Bounds and reporting
remain consumer-owned; no exact quantile estimate or global consumer ID is added.
The [preparation record](../evidence/histogram-024.md) retains its original inputs.

The last read-only counter audit found no existing measurement histogram to
replace. Counts/totals, summaries, chronological histories and category/domain
buckets have separate contracts. Histogram use samples admitted raw values at
the producer and projects its canonical summary once. Owning investigations are
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
Publication availability has been reported to those owners; workload bounds,
storage budgets and owning qualification remain their decisions.

IC Timers' read-only evaluation confirms that recording follows the sampled
callback envelope and that missing/superseded/terminal-removed registrations
cannot retain a sample. Actual IC cost qualification must include recording
work and preserve those admission/identity contracts. No histogram Wasm-size,
IC instruction or cycle measurement is claimed here. Existing arithmetic-only
adoption coordination remains in [#4](https://github.com/dragginzgame/ic-metrics/issues/4)
and [#10](https://github.com/dragginzgame/ic-metrics/issues/10).

## Historical preparation and evidence

The [v0.2.4 handoff](https://github.com/dragginzgame/ic-metrics/blob/v0.2.4/docs/status/current.md)
retains prior preparation, exact consumer source/lock observations and older CI
qualification. Its pending/unpublished statements describe that earlier state.
Source-bound reports remain under `docs/evidence/` and in [the host record](../hosts.md).
This continuation ran focused tooling checks and read publication/CI evidence;
no Rust source edit, full local CI/test gate, sibling file edit, commit, push,
tag, package version change or release command ran.
