# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and
endpoints. See [the extraction contract](../extraction.md).

## Released source

Published 0.2.6, tag `v0.2.6`, local HEAD and remote main identify
`df8fd43b95673360bcc6740624c8c361745f58d1`. The official registry package is
non-yanked, dependency-free and feature-free, with checksum
`9ac61152c3645ba0cad34331301db14ca096ced6ace6fc7d2cbbd4f4fe511f63`.
The downloaded archive matches its checksum, embedded Git identity, Rust source,
packaged guide, original manifest, README, license and lock. Cargo versions stay
0.2.6. The [0.2.6 release record](../evidence/release-026.md) binds those observations.

`checked_mean(samples, total)` and `MeasurementSummary::mean()` are available
from this release: empty `(0, 0)` is `None`, observed zero is `Some(0)` and valid
nonempty means round down. Inconsistent empty pairs and either counter at
`u64::MAX` return typed errors, including an exactly reached cap. Recording,
storage and ownership contracts are unchanged. The
[application guide](../../crates/ic-metrics/src/application.md) is packaged and
compiled. [Arithmetic evidence](../evidence/arithmetic-026.md) retains focused
host/Wasm, MSRV, tests and documentation results at their original source.

The [histogram experiment](../evidence/histogram-cost-026.md) measures an isolated
Canic recording source-copy on Linux PocketIC 16.0.0, with 138 validated calls.
At 1,000 repeated-key records, two histogram bounds add 42,000–75,000
instructions, 42,035–75,035 observed whole-update cycles and 208 raw Wasm bytes
over count/total; slots use 72 versus 16 bytes. This does not qualify a full
consumer, other bound counts/cardinalities, timer admission, mainnet or macOS.

## Tooling adoption and qualification

The 65-file snapshot now records reviewed committed Shared Tooling
`88f1d70cdf671aefb9507d7a81411ed5daa358b3` (the 0.1.16 tooling plus its
committed LOC fixture correction), refreshed through its
canonical helper from a separate clean detached checkout. The added canister
audit guide completes the updated catalog; the distribution helper completes
the tooling-inventory fixture dependency. Changelog heading whitespace,
validation log retention and explicit independent-workspace reporting come from
their canonical owners. No frontend formatter is activated in this Rust library.

The [0.2.6 CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37598415861)
passes MSRV but Linux fails in the LOC fixture before native Rust gates; both
macOS jobs remain queued at the recorded inspection. Checkout-local TMPDIR lets
the fixture discover the enclosing repository instead of its own manifest.
[Shared Tooling #48](https://github.com/dragginzgame/shared-tooling/issues/48)
owns that repair, distinct from inherited target-directory isolation in
[#47](https://github.com/dragginzgame/shared-tooling/issues/47).
The maintainer committed the authorized correction, which explicitly selects
fixture manifests and clears only the inherited target selection. Its portable
suite, ShellCheck and focused Bash 3.2/5.2 probes inside/outside the checkout pass.
The corrected source is now distributed into this consumer through the clean
reviewed checkout; the historical 0.1.16 source retains its failing fixture. The
[adoption record](../evidence/adoption-027.md) retains the exact boundary and checks.

Pending 0.2.7 contains compatible tooling corrections from finalized 0.2.6;
package versions and arithmetic source remain unchanged. Publication does not
prove owning native CI. Feature qualification remains with
[#17](https://github.com/dragginzgame/ic-metrics/issues/17),
[#19](https://github.com/dragginzgame/ic-metrics/issues/19),
[#20](https://github.com/dragginzgame/ic-metrics/issues/20) and tooling adoption
[#16](https://github.com/dragginzgame/ic-metrics/issues/16),
[#18](https://github.com/dragginzgame/ic-metrics/issues/18).

## Downstream boundaries

[IcyDB #313](https://github.com/dragginzgame/icydb/issues/313) owns the authorized
CLI projection onto published 0.2.6. The local renderer uses `checked_mean`,
keeps numeric zero and floor rounding, and displays `unavailable` for empty,
inconsistent or saturated input. Its catalog and lock select 0.2.6. No DTO,
Candid, span attribution, endpoint, storage or reset behavior changes. Its pending
notes select 0.267.0 for the diagnostic CLI output change and carry the existing
unpublished batch; Cargo package versions are unchanged. Other dirty IcyDB work
is preserved. The owning issue records focused checks and release qualification.

Histogram workload/bounds/storage decisions remain with
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
The prior audit found no existing measurement histogram to replace. Counts,
chronological history and domain buckets have separate contracts. The histogram
minimum is published 0.2.4; the checked-mean minimum is published 0.2.6.

Existing consumer adoption and attribution qualification remain with
[#4](https://github.com/dragginzgame/ic-metrics/issues/4),
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) and
[Canic #99](https://github.com/dragginzgame/canic/issues/99). Other consumer
repositories were not mutated by this batch. Historical source-bound evidence
stays under `docs/evidence/`; [the host record](../hosts.md) distinguishes focused
Linux execution from owning native macOS CI. No full local CI/test gate,
commit, push, tag, package version change or release command ran.
