# ic-metrics

Allocation-free, dependency-free measurement arithmetic.

The `no_std` library exports `MeasurementAggregate` for mergeable
count/total/maximum with sticky actual-overflow flags,
and `MeasurementSummary` for ordered observations with a latest value.
`MeasurementHistogram` adds a mergeable fixed-size distribution with caller-selected bounds.
Zero is a valid observation; an empty summary has no latest or maximum value.
Tracked count and total clip independently, with sticky actual-overflow flags.
Counts and individual samples use `u64`; totals and means use `u128`. Every
exact counted batch fits its total. An exactly reached numeric cap remains exact. Consumers establish units, identity and
reset boundaries before comparing observations; saturated totals cannot supply
exact interval arithmetic.

```rust
use ic_metrics::MeasurementSummary;

let mut summary = MeasurementSummary::EMPTY;
assert_eq!(summary.latest(), None);
summary.record(0);
assert_eq!(summary.samples(), 1);
assert_eq!(summary.latest(), Some(0));
```

Tracked `MeasurementAggregate::mean()` and `MeasurementSummary::mean()` return
`Result<Option<u128>, MeasurementMeanError>`: empty is `None`, measured zero is
`Some(0)`, and exact means round down. Actual overflow returns a typed error;
exactly reaching the cap remains valid. `scaled_mean(scale)` checks the same
flags and retains fractional information: samples 3 and 4 yield 35 at scale ten.
Accumulator flags cannot restore a clamped input sample.

`MeasurementAggregate::merge` combines count/total and maximum without claiming
ordering or deduplication. `interval_since(previous)` returns checked count/total
differences and mean after the owner establishes common identity, units and
append-only continuity. It rejects actual overflow and numeric discontinuity;
maximum and latest values cannot be subtracted. Ordered summaries do not merge.

The prepared **0.8.0 hard cut** removes `record_sample`, raw-field `checked_mean`
and `MeasurementMeanError::TotalWithoutSamples`. Record into a tracked aggregate,
summary or histogram; project consumer-owned reports from that state and preserve
its overflow flags or explicit unavailable results. Means return a typed
`Projection` error if the exact ratio owner rejects a scaled result. Units,
identity, attribution, reset windows and any once-per-window alert remain local.
The stable V1 bytes, map/key/epoch contract and allocation lifecycle are unchanged;
this cut requires no stored-data reset. The dependency example selects 0.8 after
publication; package metadata remains on the prior release during preparation.

The [optional stable adapter](crates/ic-metrics-stable/README.md) stores
aggregates, summaries and histograms in one host-owned stable B-tree map using
`ic-memory`'s collection types. Namespaced records retain units, reset epochs,
wide totals and overflow flags. Adding `ic-metrics-stable` is the opt-in; existing
arithmetic callers remain volatile. The adapter requires Rust 1.88 on host and
Wasm. Hosts own allocation/bootstrap, synchronization, write cadence and resets;
the arithmetic core remains dependency-free and `no_std` on Rust 1.85.

The [application guide](https://github.com/dragginzgame/ic-metrics/blob/main/crates/ic-metrics/src/application.md) is included in
packaged crate documentation, with a compiled example of fixed named histograms,
separate units and event counts. It covers sample admission, async attribution,
resets, reporting and cost qualification; applications own those policies.

For a distribution, construct `MeasurementHistogram::new([10, 100])`. Its
disjoint buckets cover `0..=10` and `11..=100`; `overflow()` counts larger
observations. `bucket_counts()` returns those two counts, and `aggregate()`
includes every observation. Duplicate or descending bounds return a typed
`HistogramBoundsError` identifying the invalid bound. Construction and recording
support constant evaluation. Storage is fixed, recording searches at most the
configured number of bounds, and every bucket saturates independently. Buckets
describe ranges; they do not provide exact percentiles. Units, thresholds and
export encoding remain consumer-owned. `merge(&other)` requires matching bounds
and returns a typed mismatch without changing the destination. Bucket and overflow
saturation flags distinguish exact caps from lost counts.

`cumulative_count(index)` provides exact counts through a configured
bound and `quantile_bucket(numerator, denominator)` for nearest-rank ranges, such
as p95 with `(95, 100)`. Empty quantiles are `None`; required count saturation
returns `HistogramQueryError`. Overflow has no configured ceiling.
`checked_scaled_ratio(numerator, denominator, scale)` floors an exact scaled
integer ratio from a `u128` numerator, without floating point or overflowing
intermediate multiplication. Callers establish exact inputs and handle empty or
saturated diagnostics before using it. Consumer adoption remains separately qualified.

Known callers are IcyDB, Canic, ic-timers, ic-backup, IC Blob Storage's
restoration test probe and Toko Miner's production game-shard action metrics. Their
attribution, registries, callback roles, replication, persistence and reporting
remain local. ic-backup's host integration measures local durations in nanoseconds
and prepared chunk sizes in bytes, with a four-bound byte histogram in the
inspected implementation. Its diagnostics establish no IC instruction or cycle cost.
The crate has no global consumer registry, stable-memory allocation or endpoints.
Consumers own their summary and histogram instances, labels and persistence policy.
[The extraction contract](https://github.com/dragginzgame/ic-metrics/blob/main/docs/extraction.md)
records scope and evidence.

Platform reads belong in consumer adapters:
IcyDB and Canic use `ic_cdk::api::call_context_instruction_counter()`; IC Timers
uses its existing `ic0::performance_counter(1)` binding. Both read counter 1.
Consumers own target gating, native handling, call-context identity and attribution.
IcyDB's inclusive overlapping spans and Canic's exclusive endpoint accounting
remain different consumer contracts.

## Measuring cost

Measure raw canister Wasm bytes, IC instructions and actual cycle charges
separately. The shared arithmetic allocates nothing; labels, map updates and
report encoding are consumer costs. Build profiles belong to the consumer
workspace. The [performance audit](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/performance-audit.md)
records historical compiler checks and size/instruction/cycle comparisons for
the retired reader test canister, with their workload limits. It does not establish consumer savings.

The separate [consumer lookup measurements](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/consumer-lookups.md)
cover IcyDB and Canic's borrowed-key changes. Their isolated IC fixtures show
lower instruction work and cycle charges for repeated keys, but higher costs
for first insertions. Use the recorded workload and artifact identities when
assessing those consumer changes; upgrading ic-metrics alone does not apply them.

The [two-bound histogram cost experiment](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/histogram-cost-026.md)
compares Canic's source-copied recording path with count/total, summary and
histogram storage. It measures IC instructions and actual cycle charges in
Linux PocketIC, plus raw Wasm bytes and target-specific slot sizes. Its repeated-key,
two-bound workload does not establish whole-application cost or histogram adoption.
Its original replay inputs are unavailable. The separate
[durable arithmetic replay](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/histogram-replay-029.md)
provides a checksum-bound bundle of new fixture sources, locks, raw results and
measured Wasms. It measures direct arithmetic without Canic lookup or attribution;
its observations have their own source and workload identity.

The [0.6 arithmetic comparison](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/arithmetic-cost-061.md)
measures recording, merging already prepared batches and reporting queries on
exact released sources. The separate
[quantile fast-path comparison](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/quantile-cost-062.md)
isolates the checked narrow-product improvement and its wide-product fallback
cost. Both retain reproducible sources, locks, Wasms and raw IC readings.
Batch preparation is excluded from merge costs; these synthetic workloads do not
qualify consumer applications. Compute distribution queries during reporting
when possible, rather than on every recorded observation.

## Development

Common contributor commands use the reviewed [Shared Tooling Make
interface](docs/make-interface.md). Product builds, compiler floors, validation,
publication and release metadata remain owned here.

Use rustup with the pinned Rust 1.99.0 toolchain, Git, GNU Make and Bash 3.2 or
newer. Install `wasm32-unknown-unknown` for Wasm checks. The arithmetic library's
minimum compiler is Rust 1.85.0.

The private [Wasm evidence inspector](https://github.com/dragginzgame/ic-metrics/blob/main/crates/ic-metrics-wasm-inspect/README.md)
requires Rust 1.88.0. It uses IC Host libraries to report raw/encoded bytes and
structural counts for explicitly supplied Wasms with caller-selected bounds,
without executing a canister. Bare Cargo commands select the arithmetic package.

Prepare and check the reviewed tools, select their paths, then install the
repository's formatting hook:

```sh
make install-tools
make tools-check
export PATH="$PWD/.tools/host/bin:$PWD/.tools/ic/bin:$PWD/.tools/rust/common/bin:$PATH"
make install-hooks
```

[Local setup](https://github.com/dragginzgame/ic-metrics/blob/main/docs/local-setup.md)
owns bootstrap prerequisites, tool inventory, shared storage, installer failure
handling and PATH selection. [Git hook rules](https://github.com/dragginzgame/ic-metrics/blob/main/rules/git-hooks.md)
own staged formatting and hook installation. The reviewed shared tooling is
vendored; normal commands need no Shared Tooling sibling checkout.

`make fmt` sorts workspace manifests and formats Rust; `make fmt-check` checks
without editing. `make help` lists focused commands. Select named tests during
implementation, and use `make check`, `make check-wasm`, `make clippy` and
`make wasm-inspect-check` for the affected package. Completed code delivery uses
`make ci`, `make msrv`, `make stable-msrv` and `make wasm-inspect-msrv`; inspection and documentation
changes use narrower checks. The [host support and qualification guide](https://github.com/dragginzgame/ic-metrics/blob/main/docs/hosts.md#prerequisites-and-focused-checks)
owns local gates and native acceptance. [Agent rules](https://github.com/dragginzgame/ic-metrics/blob/main/AGENTS.md)
own command authority.

Common IC executable setup and PocketIC ownership are documented in
[IC tools](https://github.com/dragginzgame/ic-metrics/blob/main/docs/ic-tools.md).
Metrics has no active server caller or Testkit dependency. Repository maintenance
procedures live in the [task catalog](https://github.com/dragginzgame/ic-metrics/blob/main/tasks/README.md).

## Releases and adoption

Declare the current arithmetic contract in the consumer's root catalog:

```toml
[workspace.dependencies]
ic-metrics = "0.8"
```

Members inherit with `ic-metrics = { workspace = true }`. Published consumers
resolve the registry package; consumers exposing shared types coordinate the
same released dependency identity. The [changelog](https://github.com/dragginzgame/ic-metrics/blob/main/CHANGELOG.md)
owns release history and required hard-cut changes. The [extraction contract](https://github.com/dragginzgame/ic-metrics/blob/main/docs/extraction.md)
and [consumer qualification issue](https://github.com/dragginzgame/ic-metrics/issues/10)
own integration scope and acceptance; the [current handoff](https://github.com/dragginzgame/ic-metrics/blob/main/docs/status/current.md)
distinguishes local preparation, publication and hosted qualification.

Contributions follow the [shared contribution rules](https://github.com/dragginzgame/ic-metrics/blob/main/rules/contributions.md).
Maintainer releases use `make release-patch`, `make release-minor` or
`make release-major` under the [shared release contract](https://github.com/dragginzgame/ic-metrics/blob/main/docs/releases.md).
This repository supports `RELEASE_DELIVERY=direct` only, defaulting to remote
`origin` and branch `main`. Release execution requires cargo-edit
(`cargo set-version`). The shared contract owns preparation, validation,
commit/tag delivery and interrupted-release recovery.

Publication is separate from release delivery:

```sh
make publish-check
make publish
```

`publish-check` is Cargo's dry run; `publish` uploads only the existing
`ic-metrics` and `ic-metrics-stable` package versions to crates.io in dependency
order, using normal Cargo credentials and
locked dependencies. Both retain Cargo's package verification and dirty-tree
rejection. Publication does not bump versions, create Git commits/tags or clean
artifacts. See [Cargo's publication documentation](https://doc.rust-lang.org/cargo/commands/cargo-publish.html).
