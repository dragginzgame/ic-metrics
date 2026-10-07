# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` measurement arithmetic.
`record_sample` and `MeasurementSummary` preserve zero/empty and independent
saturation semantics. `MeasurementHistogram` adds a separate fixed-size
distribution with consumer-selected bounds. Consumers own platform reads,
attribution, identities, registries, labels, persistence, lifecycle and endpoints. The arithmetic-only
0.2 hard cut and downstream contracts are in [the extraction contract](../extraction.md).

## Current release

Tag `v0.2.3` identifies source `89f8c6947fb3253991c65479f04bf14acb676328`.
The official registry index reports non-yanked 0.2.3 with checksum
`27bb8ca9caa9b67570031d26f2f35f9e113f69b73278cca59b08e9447e13b593`.
The downloaded archive matches that checksum, embedded tag identity, Rust source,
original manifest, license, README and lockfile. Normalized metadata contains
no dependencies or features; library source is unchanged from 0.2.2.
See the [release record](../evidence/release-023.md).

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37502954597)
passes all three native hosts and MSRV. All three downloaded native tarballs,
tagged source hashes, twelve fixture outcomes per host and retained Git indexes
verify. Cargo metadata remains 0.2.3. The pending 0.2.4 changelog collects the
compatible histogram addition and Shared Tooling fixes below. Existing arithmetic
APIs and semantics are unchanged; no consumer update or reset is required.
No package version is changed here.

## Bounded distributions

The pending source exports `MeasurementHistogram<N>` and `HistogramBoundsError`.
Strictly increasing inclusive upper bounds define disjoint saturating counts,
with separate overflow and the canonical summary of all admitted values.
Construction and recording are constant-capable; empty and measured zero remain
distinct. No bounds means every value goes into overflow; a final `u64::MAX`
bound includes every remaining value. Storage and search are bounded by `N`.
No quantile estimate, reader, consumer registry or reporting policy is added.
Published 0.2.3 does not contain this API.

Focused Linux host/Wasm Clippy, eight new histogram tests, the existing named
sample-count saturation test, the public histogram example, host/Wasm docs and
Rust 1.88 checks pass. Source inputs and limitations are recorded in
[the histogram evidence](../evidence/histogram-024.md) and
[#15](https://github.com/dragginzgame/ic-metrics/issues/15).
The read-only IC Timers review identifies its admitted work-envelope sample as
the first candidate; the concrete proposal is in
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22).
The other owning investigations are
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
Inspection found no existing measurement histogram to replace in their recording
paths. Counts/totals, summaries, chronological history and categorical/domain
buckets preserve separate contracts; future histogram use samples admitted raw
values at the producer and projects the histogram's canonical summary.
No consumer files or endpoints change here. IC workload measurements and native
macOS qualification of this dirty source have not run; no size or IC cost saving
is claimed.

## Shared Tooling adoption

The verified 56-file snapshot records
`e378671d90afa237ff63a4b0e3b9551eb2c222b6` (Shared Tooling 0.1.13), distributed
from a separate clean checkout of that committed revision. The executable fixes
are unchanged from 0.1.12, whose
[upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37511845192)
passes Linux, both supported native macOS hosts and lint/security. Release
dispatch uses the captured URL and rejects destination changes. Snapshot hashing
is independent of inspected helpers. The standalone yq wrapper includes its
common installer dependency, and the governance list is explicitly declared.
The baseline and maintenance rule refresh together; relevant GitHub issue work
has standing authority across repositories. Sibling file edits, commits and
release effects retain their separate authority.

Focused Linux checks with GNU Bash 3.2.57 pass release destination/recovery,
metadata preparation/rollback, selected-commit admission and twelve retained
failure scenarios. Disposable probes reject helper-only, helper-plus-payload and
payload-only corruption without executing the changed helper. Both checksum
backends pass; all 56 files independently match committed source and digests.
Standalone yq probes reject failed version status, digest mismatch and directory
destinations while preserving the old tool and failed inputs. Selected ShellCheck,
document links, isolated governance links and dependency declarations pass.
See the [adoption evidence](../evidence/adoption-024.md).

The 0.1.13 workspace/hook rule and its linked guide are adopted together.
The existing virtual root and sole package at `crates/ic-metrics` already conform;
no files move. Focused locked offline metadata and formatting checks pass.
The [0.1.13 upstream run](https://github.com/dragginzgame/shared-tooling/actions/runs/37581058940)
now passes Linux, both native macOS hosts and lint/security. The local adoption
is uncommitted; it has no matching consumer native CI result.
[#13](https://github.com/dragginzgame/ic-metrics/issues/13) retains that qualification
boundary. Optional CI inventory and the upstream portable-suite prerequisite gate
are outside this consumer's selected tooling.
The inspected release/logger/hook bytes still share the upstream Make-mode gap;
that separate consumer exposure is tracked in
[#14](https://github.com/dragginzgame/ic-metrics/issues/14). Normal-environment
passes do not qualify ignore-errors or non-executing Make modes.

## Downstream observations

The earlier read-only committed-source qualification inspection found:

| Consumer | Source | Registry ic-metrics lock |
| --- | --- | --- |
| IcyDB | `049e561a843a8d3f4526460fd15876a4a238df10` | 0.2.0 |
| Canic | `d7698e1f0541cb52ad8d762bc1549a700b412e88` | 0.2.3 |
| IC Timers | `c84d4e4d26f968a9d7f2d37f30f7fed447692c0f` | 0.2.1 |
| IC Backup | `b68299410d3cb577e6b5f8fd4cc9971359620775` | 0.2.3 |

The table records local committed sources. Canic now commits its 0.2/IC Timers
0.14 migration; IC Backup's local 0.5.0 preparation also locks metrics 0.2.3.
Neither inspected local commit has an owning CI run. Canic's remote main still
resolves to a different, older source; IC Backup's remote main remains released
0.4.2. IcyDB's separate working lock selects 0.2.2. IcyDB's
[owning CI](https://github.com/dragginzgame/icydb/actions/runs/37496328220) passes
Rust lanes and MSRV but fails macOS workstation tooling and static formatter
setup. IC Timers 0.14.5's [branch CI](https://github.com/dragginzgame/ic-timers/actions/runs/37526800896)
passes Linux, both macOS hosts and MSRV. IC Backup 0.4.2's
[main CI](https://github.com/dragginzgame/ic-backup/actions/runs/37501973677) passes
all three native hosts; its [tag CI](https://github.com/dragginzgame/ic-backup/actions/runs/37501973053)
at the same source fails both macOS jobs when the command-custody test reacquires
a lock after guard release. That unresolved observation belongs to
[IC Backup #13](https://github.com/dragginzgame/ic-backup/issues/13).
Graph observations and native gates
do not replace attribution/callback qualification. Remaining owning adoption is
tracked only in [#4](https://github.com/dragginzgame/ic-metrics/issues/4) and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).

The later histogram investigation observes local IC Timers 0.14.6 source
`0c90c391dff5960a7502fc15a0718b03631f2515` and IC Backup 0.5.0 source
`eece44dac79da1bfb36f82ce2cd30d51edd3a9c1`; both committed locks select
ic-metrics 0.2.3. IcyDB and Canic HEAD identities above are unchanged, and all
four current working locks select 0.2.3. The reviewed counter/history files
match their owning HEADs while other work is dirty. This source inspection
does not extend the earlier CI/publication qualification; precise inputs and
counter findings are in [the histogram record](../evidence/histogram-024.md).

## Historical preparation and evidence

The complete earlier handoff, including pre-release 0.2.3 preparation and
pre-0.2 publication/reader observations, remains in the immutable
[v0.2.3 handoff](https://github.com/dragginzgame/ic-metrics/blob/v0.2.3/docs/status/current.md).
Its pending versions and consumer statements describe those earlier observations.
Source-bound reports remain under `docs/evidence/` and in [the host record](../hosts.md).
This continuation prepared Shared Tooling adoption and a bounded histogram with
focused local qualification; it ran no full local CI gate, consumer builds,
commits, pushes or release commands.
