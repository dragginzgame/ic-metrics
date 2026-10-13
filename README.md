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
reset boundaries before comparing observations; overflowed totals cannot supply
exact interval arithmetic.

`MeasurementCounter` supports scalar event, item or byte totals.
It holds a `u128` total and sticky actual-overflow flag, with `add`, `merge`,
validated `from_parts`, `exact_total` and identity-qualified `delta_since`.
Zero is an exact scalar value; an absent metric stays consumer-owned. An exactly
reached cap remains exact, and narrow reports use checked conversions. This
counter retains no observation statistics and has no stable-store encoding.

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
`Some(0)`, and exact means round down. Actual sample-count overflow returns
`SampleCountOverflow`; an exact count guarantees an exact total. Exactly reaching
the cap remains valid. `scaled_mean(scale)` checks count quality and retains
fractional information: samples 3 and 4 yield 35 at scale ten. Admitted scaled
means fit `u128` without a ratio-projection failure.
Accumulator flags cannot restore a clamped input sample.

`MeasurementAggregate::merge` combines count/total and maximum without claiming
ordering or deduplication. `interval_since(previous)` returns checked count/total
differences and mean after the owner establishes common identity, units and
append-only continuity. It rejects actual overflow and numeric discontinuity;
maximum and latest values cannot be subtracted. Ordered summaries do not merge.

The 0.9 API removes the unreachable mean `SaturatedTotal`/`Projection` and interval
`SaturatedTotal` variants. Update matches or explicit construction of those errors
when selecting 0.9. Overflow flags use `*_overflowed` names, including
`bucket_overflowed()` and `overflow_count_overflowed()` for histogram counts.
Remaining overflow errors use `SampleCountOverflow`, `TotalOverflow`,
`CountOverflow` and `InvalidOverflowFlag`; arithmetic and quality stay unchanged.
Generic-ratio errors remain unchanged. Raw stable codec dispatch is internal;
use the supported generic `MetricsStore` operations.
The stable V1 encoding and host allocation lifecycle require no reset.

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
overflow flags distinguish exact caps from lost counts.

`cumulative_count(index)` provides exact counts through a configured
bound and `quantile_bucket(numerator, denominator)` for nearest-rank ranges, such
as p95 with `(95, 100)`. Empty quantiles are `None`; required count overflow
returns `HistogramQueryError`. Overflow has no configured ceiling.
`checked_scaled_ratio(numerator, denominator, scale)` floors an exact scaled
integer ratio from a `u128` numerator, without floating point or overflowing
intermediate multiplication. Callers establish exact inputs and handle empty or
overflowed diagnostics before using it. Consumer adoption remains separately qualified.

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
separately. Shared arithmetic allocates nothing; registry lookups, labels,
encoding and stable writes are separate consumer costs. Build profiles belong
to each application, and native timing is not IC measurement evidence.

The [tracked-recording comparison](docs/evidence/tracked-080.md),
[quantile comparison](docs/evidence/quantile-cost-062.md) and
[durable-store experiment](docs/evidence/stable-cost-072.md) retain reproducible
sources, locked graphs, Wasms and raw IC readings. Their bounded workloads do
not establish whole-application or mainnet savings. Original reader, histogram
and consumer-lookup evidence remains unchanged under `docs/evidence`; the
[cleanup receipt](docs/evidence/cleanup-082.md) retains the previous guide text.
Compute distribution queries during reporting when possible.

## Development

Common contributor commands use the reviewed [Shared Tooling Make
interface](docs/make-interface.md). Product builds, compiler floors, validation,
publication and release metadata remain owned here.

Use rustup with the pinned Rust 1.99.0 toolchain, Git, GNU Make and Bash 3.2 or
newer. Install `wasm32-unknown-unknown` for Wasm checks. The arithmetic library's
minimum compiler is Rust 1.85.0.

The published [IC Host Wasm inspector](https://github.com/dragginzgame/ic-host-tooling/tree/main/apps/ic-host-wasm-inspect)
reports raw/encoded bytes and structural counts for explicitly supplied Wasms
with caller-selected bounds. Metrics selects version 0.17.4 as a managed tool,
separate from both library dependency graphs. After explicit tool setup, run
`bash scripts/dev/wasm-inspector.sh run module.wasm 20000000 1000 10000 1000`.
It executes no canister; bare Cargo commands select the arithmetic package.

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
implementation, and use `make check`, `make check-wasm` and `make clippy` for
the affected package. `make wasm-inspect-check` checks the selected host tool.
Completed code delivery uses `make ci`, `make msrv` and `make stable-msrv`;
inspection and documentation
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
