
## Application-owned measurements

Choose a small set of named observations and keep one unit per aggregate. The
application decides which completed operations may record a sample. This example
receives already admitted instruction values; it does not read an IC counter.
Bounds are illustrative, not recommended budgets or measured cost limits.

```rust
use ic_metrics::{HistogramBoundsError, MeasurementCounter, MeasurementHistogram, MeasurementSummary};

#[derive(Clone, Copy)]
enum Span {
    Readiness,
    Mint,
}

impl Span {
    const fn index(self) -> usize {
        match self {
            Self::Readiness => 0,
            Self::Mint => 1,
        }
    }
}

struct ApplicationMetrics {
    instructions: [MeasurementHistogram<2>; 2],
    rows_per_batch: MeasurementSummary,
    budget_stops: MeasurementCounter,
}

impl ApplicationMetrics {
    fn new() -> Result<Self, HistogramBoundsError> {
        Ok(Self {
            instructions: [MeasurementHistogram::new([10_000, 100_000])?; 2],
            rows_per_batch: MeasurementSummary::EMPTY,
            budget_stops: MeasurementCounter::ZERO,
        })
    }

    fn record_instructions(&mut self, span: Span, instructions: u64) {
        self.instructions[span.index()].record(instructions);
    }

    fn record_budget_stop(&mut self) {
        self.budget_stops.add(1);
    }
}

# fn main() -> Result<(), Box<dyn std::error::Error>> {
let mut metrics = ApplicationMetrics::new()?;
assert_eq!(metrics.instructions[Span::Readiness.index()].aggregate().mean()?, None);
metrics.record_instructions(Span::Readiness, 0);
metrics.record_instructions(Span::Readiness, 12_000);
metrics.record_instructions(Span::Mint, 120_000);
metrics.rows_per_batch.record(128);
metrics.record_budget_stop();

let readiness = &metrics.instructions[Span::Readiness.index()];
assert_eq!(readiness.bucket_counts(), &[1, 1]);
assert_eq!(readiness.aggregate().samples(), 2);
assert_eq!(readiness.aggregate().maximum(), Some(12_000));
assert_eq!(readiness.aggregate().mean()?, Some(6_000));
assert_eq!(metrics.instructions[Span::Mint.index()].overflow(), 1);
assert_eq!(metrics.rows_per_batch.latest(), Some(128));
assert_eq!(metrics.budget_stops.exact_total()?, 1);
# Ok(())
# }
```

Summaries and histograms already own their mergeable aggregate. Project count, total, maximum
and mean from `aggregate()` rather than maintaining another instruction aggregate
for the same observations. Separate rows, bytes, instructions and outcome
counts. Independent summaries do not retain per-call correlations: a mean of
per-call instructions per item differs from total instructions divided by total
items. Buckets describe ranges, not exact percentiles.

An ordered summary adds `latest()` to that aggregate. For example,
`metrics.rows_per_batch.aggregate().mean()` projects rows per completed batch
while `metrics.rows_per_batch.latest()` returns the most recent batch size.

### Scalar totals

Use [`MeasurementCounter`] when only the accumulated quantity matters: retries,
items processed or bytes transferred. Its `u128` total and sticky actual-overflow
flag retain no sample count, maximum, latest value or distribution. `add(amount)`
accepts an already exact quantity in the existing unit; `merge(other)` adds a
deliberately attributed batch and carries its quality. Both include zero.

`exact_total()` returns zero for a zero counter and a typed error after actual
overflow. An absent metric remains the consumer registry's decision; the scalar
does not have a separate empty-observation state. For a narrow report, use a
checked conversion of the admitted total and explicitly represent a failed
projection. A total above `u64::MAX` is still exact when it fits `u128`.
`delta_since(previous)` checks actual overflow before decreasing totals; consumers
must first establish common counter/window identity, units and append-only
continuity. Reset by replacing the counter with `MeasurementCounter::ZERO` at
the same owning boundary as its identity change.

Report a scalar's wide total together with its source quality. The same numeric
value can be exact or a clipped lower bound:

```rust
use ic_metrics::{MeasurementCounter, MeasurementCounterError};

let mut events = MeasurementCounter::ZERO;
events.add(u128::MAX);
events.add(0);
assert_eq!(events.exact_total(), Ok(u128::MAX));
let before = events;

events.add(1);
assert_eq!(events.total(), u128::MAX);
assert!(events.total_overflowed());
assert_eq!(events.exact_total(), Err(MeasurementCounterError::TotalOverflow));
assert_eq!(events.delta_since(before), Err(MeasurementCounterError::TotalOverflow));
```

`from_parts(total, false)` admits already known exact retained state. It cannot
establish that a forwarded untracked reading was never clipped. If the source
cannot distinguish an exact cap from overflow, keep that uncertainty in a
consumer-owned lower-bound or unavailable report; neither invent an actual-overflow
flag from the numeric cap nor restore the reading as known exact. Wire formats
and JSON parsers must retain the full integer width as well as that quality.

For per-operation means, maxima or distributions, keep aggregates, summaries or
histograms. Counting events with `MeasurementAggregate::record(1)` also preserves
quality, but retains observation statistics that a scalar total does not need.
The optional stable adapter's [store guide](https://github.com/dragginzgame/ic-persistence/blob/main/crates/ic-metrics-stable/README.md#store-operations)
owns supported durable operations and host integration. Do not reinterpret an
existing stored kind or extract persistence and lifecycle policy into this arithmetic type.

### Admission and attribution

Before sampling, define the operation's unit, completion boundary and inclusion
policy. `IcyDB`'s overlapping inclusive spans and Canic's exclusive endpoint
accounting answer different questions; nested totals may not be additive.
For async work, the application owns invocation state and establishes counter
identity across resumptions. A larger numeric reading alone is not proof that
two readings belong to the same call context.

Define whether returned failures, cancellation, traps and stale timer
registrations admit a sample, and which execution modes may retain it. Do not
assume a generic drop guard observes every completion or survives a trap.
Consumer native substitutes provide no IC measurement evidence. Timer scheduler
and work roles remain with their owning runtime; recording the same completed
work in several aggregates requires an explicit attribution reason.

### Reporting and resets

Only derive a mean when the total accumulates the same admitted observations
represented by the sample count. A timer's latest armed delay and its work-start
count are independent diagnostics: report them separately, rather than dividing
the latest delay by that count. A latest value is not an accumulated total.

Consumer report payloads must preserve the total's `u128` width and carry the
source's actual-overflow flags alongside count and total. A generic pair of
numbers cannot establish their units, observation cohort or quality. For example,
this instruction total remains exact both at and above the narrow numeric cap:

```rust
use ic_metrics::MeasurementAggregate;

# fn main() -> Result<(), Box<dyn std::error::Error>> {
let mut instructions = MeasurementAggregate::EMPTY;
instructions.record(u64::MAX);
assert_eq!(instructions.total(), u128::from(u64::MAX));
assert!(!instructions.total_overflowed());

instructions.record(1);
assert_eq!(instructions.samples(), 2);
assert_eq!(instructions.total(), u128::from(u64::MAX) + 1);
assert!(!instructions.samples_overflowed());
assert!(!instructions.total_overflowed());
assert_eq!(instructions.mean()?, Some((u128::from(u64::MAX) + 1) / 2));
// This exact total is unavailable only in the narrower reporting field.
assert_eq!(u64::try_from(instructions.total()).ok(), None);
# Ok(())
# }
```

Transport encoding, decimal presentation and authorization remain consumer-owned.
Preserve a row with its quality or an explicit unavailable projection when a
narrow consumer cannot represent it; silently dropping the row loses its identity.
A failed narrowing conversion is distinct from accumulator overflow. In the
example above, the total is exact and both overflow flags remain false. Keep
the row and mark the narrow field unavailable; do not filter out its row.

Use checked histogram projections when reporting a distribution. A cumulative
count applies to a configured upper bound; a nearest-rank quantile locates a
bucket range rather than interpolating an exact observed value. For example:

```rust
use ic_metrics::{MeasurementHistogram, checked_scaled_ratio};

# fn main() -> Result<(), Box<dyn std::error::Error>> {
let mut bytes = MeasurementHistogram::new([0, 32_768, 262_144, 1_048_576])?;
for value in [0, 16_384, 32_768, 65_536] { bytes.record(value); }
let small_chunks = bytes.cumulative_count(1)?; // at most 32 KiB
assert_eq!(small_chunks, 3);
let p95 = bytes.quantile_bucket(95, 100)?.unwrap();
assert_eq!(p95.lower_exclusive(), Some(32_768));
assert_eq!(p95.upper_inclusive(), Some(262_144));
// The tracked projection checks exactness before scaling the full total.
let aggregate = bytes.aggregate();
let mean_tenths = aggregate.scaled_mean(10)?;
assert_eq!(mean_tenths, Some(286_720)); // 28,672.0 bytes, in tenths
assert_eq!(checked_scaled_ratio(u128::from(small_chunks), aggregate.samples(), 10_000)?, 7_500);
# Ok(())
# }
```

[`checked_scaled_ratio`] floors the scaled result using exact integer arithmetic.
It accepts exact `u128` totals and does not infer overflow from their numeric
value. Callers must admit count/total provenance first, choose the scale and
unit, and handle empty data before supplying a denominator. It neither formats
decimals nor checks an accumulator's quality; use `scaled_mean` for tracked means.
For the histogram example, the proportion's denominator also must be known exact;
the aggregate availability check above establishes that before using it.

An empty aggregate differs from measured zero. Tracked aggregates and ordered
summaries return `None` when empty, floor exact means and record actual overflow.
Sample and bucket counts and individual observations use `u64`; scalar totals,
accumulated measurement totals and means use `u128`. Every possible exact sample
count of `u64` observations fits the total.
An exactly reached numeric cap remains exact; adding zero does not lose exactness.
Inspect overflow flags before using clipped counts/totals in other arithmetic.
Flags describe accumulation only: consumers must admit exact input observations
and must not treat a clamped or otherwise lossy sample as an exact measurement.
Record into a tracked accumulator and display unavailable means rather than
substituting zero. Project report fields from that state; raw numeric caps cannot
establish whether overflow occurred. [`MeasurementSummary`] retains the latest ordered sample;
mergeable aggregates and histograms retain no latest value. Maximum remains an
individual observation after overflow. Bucket counts saturate independently;
they need not sum to an overflowed sample count.

Consumers own overflow reporting. Check `samples_overflowed()` and
`total_overflowed()` on the aggregate, expose unavailable exact projections, and
log or alert once when a flag first becomes true in a measurement window. Keep
that transition state with the consumer's window/reset identity; logging on every
record after overflow can flood logs and waste cycles. The arithmetic library
never logs, traps or wraps on overflow. Its recording contract retains actual
overflow flags; do not discard them when projecting or restoring reports.
When a report or codec still requires `u64`, use a checked conversion and an
explicit unavailable/overflow representation rather than truncating the total.
[`MeasurementHistogram::cumulative_count`] needs only its selected bucket prefix
to remain exact; [`MeasurementHistogram::quantile_bucket`] requires an exact
sample count and all buckets. An overflowed value total alone does not invalidate
quantile ranges. Overflow has no configured upper bound, and a zero-bound-count
histogram covers all unsigned values. Invalid indices/fractions and required
overflow produce [`HistogramQueryError`].

The application owns window/reset identity. Reset an accumulator by replacing
it with a newly constructed empty one and update its window identity at the
same owning boundary. Establish matching units, bounds and identities before
comparing snapshots; overflowed counters cannot supply exact interval deltas.

### Batches and intervals

Use [`MeasurementAggregate`] for unordered batches. `merge` adds count/total and
retains the maximum; it is not deduplication. Use [`MeasurementSummary`] when
latest matters, and extract its `aggregate()` for unordered reporting. There is
no way to merge summaries and invent a latest observation. Histograms merge only
when every finite bound matches; a typed mismatch leaves the destination unchanged.
Consumers must establish common units, windows and deliberate attribution before
merging. Combining overlapping spans does not turn them into exclusive work.

```rust
use ic_metrics::{MeasurementAggregate, MeasurementHistogram};
# fn main() -> Result<(), Box<dyn std::error::Error>> {
let mut all = MeasurementAggregate::EMPTY;
all.record(0);
let before = all;
let mut batch = MeasurementAggregate::EMPTY;
batch.record(10);
batch.record(20);
all.merge(batch);
// The owner first establishes the same append-only window and attribution.
let interval = all.interval_since(before)?;
assert_eq!(interval.samples(), 2);
assert_eq!(interval.total(), 30);
assert_eq!(interval.mean(), Some(15));

let mut left = MeasurementHistogram::new([10, 100])?;
let mut right = MeasurementHistogram::new([10, 100])?;
left.record(0);
right.record(20);
left.merge(&right)?;
assert_eq!(left.bucket_counts(), &[1, 1]);
# Ok(())
# }
```

`interval_since` rejects actual overflow, decreasing counters and a changed total
without new samples. Numeric success does not establish counter identity or detect
a reset followed by larger values. It returns only count/total and mean: maximum,
latest and quantiles cannot be obtained by subtracting cumulative snapshots.
Consumers keep reset/restart identity, synchronization and persistence policy.

Budget-stop counts are diagnostics. Actual budget enforcement, balances,
journal debt and other authoritative accounting need their existing exact
consumer contracts. Reporting DTOs, admin authorization, endpoints,
persistence and synchronization also remain application-owned.

### Cost qualification

Each named histogram stores its bounds, counts, overflow flags and aggregate. Select
bounds and cardinality for a demonstrated workload. Measure target-specific
storage and raw Wasm bytes, IC instructions and actual cycle charges separately.
Include the recording work itself; samples whose measurement ends before
recording do not measure that overhead. Source-bound compiler checks and this
arithmetic example do not qualify any application's IC cost or lifecycle.

### Bounded heap recording

A consumer can compose the shared store with its own fixed counters in one reset
window. The consumer chooses limits and supplies instruction/cycle values; the
library does not read them or publish an endpoint:

```rust
# #[cfg(feature = "recording")]
# {
use ic_metrics::{BoundedMeasurementTable, MeasurementTableLimits, MeasurementWindow};

let limits = MeasurementTableLimits { entries: 64, key_bytes: 1024, total_key_bytes: 8192 };
let mut window = MeasurementWindow::new(BoundedMeasurementTable::new(limits));
window.state_mut().record("accepted.entity", 120);
assert_eq!(window.state().entries().len(), 1);
window.reset(BoundedMeasurementTable::new(limits));
assert_eq!(window.sequence(), Some(1));
# }
```

This example requires the `recording` feature. Other fixed measurement shapes can
live alongside the table in a consumer-defined struct inside the same window.

### Numeric transport

Embed aggregates, counters, summaries and fixed-bound histograms directly in Serde/IC Wire
reports. Serde is always available on native and Wasm targets. Default-enabled
`native-wire` adds Wire TypeScript metadata on native
hosts. Measurement arithmetic remains allocation-free; heap recording is opt-in.
The 0.20–0.21 contract implements Wire 0.10's native metadata trait. Applications
deriving Wire for reports containing Metrics values must select that same Wire
line; earlier Wire traits cannot describe Wire 0.10 implementations. Serde record
layouts remain unchanged. See the [native metadata migration guide](https://github.com/dragginzgame/ic-observability/blob/main/docs/migration-020.md).

```rust
# #[cfg(all(feature = "native-wire", not(target_family = "wasm")))]
# {
#[derive(serde::Serialize, serde::Deserialize, ic_wire::Wire)]
struct OwnerReport {
    instructions: ic_metrics::MeasurementAggregate,
    movements: ic_metrics::MeasurementCounter,
    ordered: ic_metrics::MeasurementSummary,
    distribution: ic_metrics::MeasurementHistogram<3>,
}
# }
```

Migrate consumer numeric mirrors by replacing their fields with these canonical
values, then regenerate browser contracts. The aggregate record carries `samples`,
`total`, optional `maximum`, `samples_overflowed` and `total_overflowed`; the scalar
record carries `total` and `total_overflowed`. Totals stay `u128` (browser `bigint`).
An empty maximum is `None`, while a measured zero is `Some(0)`. Means are derived
with `mean()` after decoding; count overflow remains an unavailable exact mean.
All decoders call their owning `from_parts` and reject inconsistent numeric state.
Summaries carry an aggregate and optional latest value. Histograms carry fixed
upper bounds, disjoint counts, overflow count, all overflow flags and an aggregate.
The histogram's const bound count fixes all three array lengths; decoding uses
stack arrays and does not allocate a dynamic collection, including for bounds
beyond Serde's built-in array-trait lengths. Bounds, count/total consistency and
maximum placement are independently admitted after field decoding. Browser
metadata describes that same fixed layout; browser schema checks alone do not
replace Rust arithmetic admission.

Use IC Wire's bounded native codecs with consumer-selected byte, allocation,
node and depth limits. These fixed-size numeric records allocate no dynamic
collections during Serde decoding. Generated browser metadata describes the
serialized layout; Rust numeric admission remains authoritative on incoming
reports. No historical consumer codec fallback is provided. This integration does
not serialize windows, keyed tables or checked wide
accumulators. Those shapes require separately scoped transport contracts.

Applications still own labels, units, grouping, replicated admission, limits,
endpoints and reset authorization. This is a numeric transport contract, not a
stable-storage format. IC Persistence retains durable-adapter ownership.
