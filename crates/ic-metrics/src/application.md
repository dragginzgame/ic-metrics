
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

For per-operation means, maxima or distributions, keep aggregates, summaries or
histograms. Counting events with `MeasurementAggregate::record(1)` also preserves
quality, but retains observation statistics that a scalar total does not need.
The optional stable adapter's [store guide](https://github.com/dragginzgame/ic-metrics/blob/main/crates/ic-metrics-stable/README.md#store-operations)
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
Counts and individual observations use `u64`; accumulated totals and means use
`u128`. Every possible exact sample count of `u64` observations fits the total.
An exactly reached numeric cap remains exact; adding zero does not lose exactness.
Inspect overflow flags before using clipped counts/totals in other arithmetic.
Flags describe accumulation only: consumers must admit exact input observations
and must not treat a clamped or otherwise lossy sample as an exact measurement.
Record into a tracked accumulator and display unavailable means rather than
substituting zero. Project report fields from that state; raw numeric caps cannot
establish whether overflow occurred. [`MeasurementSummary`] retains the latest ordered sample;
mergeable aggregates and histograms retain no latest value. Maximum remains an
individual observation after overflow. Bucket counts saturate independently;
they need not sum to a overflowed sample count.

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
sample count and all buckets. A overflowed value total alone does not invalidate
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
