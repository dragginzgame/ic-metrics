
## Application-owned measurements

Choose a small set of named observations and keep one unit per aggregate. The
application decides which completed operations may record a sample. This example
receives already admitted instruction values; it does not read an IC counter.
Bounds are illustrative, not recommended budgets or measured cost limits.

```rust
use ic_metrics::{HistogramBoundsError, MeasurementHistogram, MeasurementSummary};

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
    budget_stops: u64,
}

impl ApplicationMetrics {
    fn new() -> Result<Self, HistogramBoundsError> {
        Ok(Self {
            instructions: [MeasurementHistogram::new([10_000, 100_000])?; 2],
            rows_per_batch: MeasurementSummary::EMPTY,
            budget_stops: 0,
        })
    }

    fn record_instructions(&mut self, span: Span, instructions: u64) {
        self.instructions[span.index()].record(instructions);
    }

    fn record_budget_stop(&mut self) {
        self.budget_stops = self.budget_stops.saturating_add(1);
    }
}

# fn main() -> Result<(), Box<dyn std::error::Error>> {
let mut metrics = ApplicationMetrics::new()?;
assert_eq!(metrics.instructions[Span::Readiness.index()].summary().mean()?, None);
metrics.record_instructions(Span::Readiness, 0);
metrics.record_instructions(Span::Readiness, 12_000);
metrics.record_instructions(Span::Mint, 120_000);
metrics.rows_per_batch.record(128);
metrics.record_budget_stop();

let readiness = &metrics.instructions[Span::Readiness.index()];
assert_eq!(readiness.bucket_counts(), &[1, 1]);
assert_eq!(readiness.summary().samples(), 2);
assert_eq!(readiness.summary().maximum(), Some(12_000));
assert_eq!(readiness.summary().mean()?, Some(6_000));
assert_eq!(metrics.instructions[Span::Mint.index()].overflow(), 1);
assert_eq!(metrics.rows_per_batch.latest(), Some(128));
assert_eq!(metrics.budget_stops, 1);
# Ok(())
# }
```

The histogram already owns its summary. Project count, total, latest, maximum
and mean from `summary()` rather than maintaining another instruction summary
for the same observations. Separate rows, bytes, instructions and outcome
counts. Independent summaries do not retain per-call correlations: a mean of
per-call instructions per item differs from total instructions divided by total
items. Buckets describe ranges, not exact percentiles.

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

An empty aggregate differs from measured zero. [`checked_mean`] and
[`MeasurementSummary::mean`] return `None` when empty, floor the mean of
unsaturated observations, and return a typed error when exact inputs are
unavailable. Display that unavailability rather than substituting zero.
Latest and maximum remain individual observations after saturation. Bucket
counts saturate independently; they need not sum to a saturated sample count.

The application owns window/reset identity. Reset an accumulator by replacing
it with a newly constructed empty one and update its window identity at the
same owning boundary. Establish matching units, bounds and identities before
comparing snapshots; saturated counters cannot supply exact interval deltas.

Budget-stop counts are diagnostics. Actual budget enforcement, balances,
journal debt and other authoritative accounting need their existing exact
consumer contracts. Reporting DTOs, admin authorization, endpoints,
persistence and synchronization also remain application-owned.

### Cost qualification

Each named histogram stores its bounds, counts, overflow and summary. Select
bounds and cardinality for a demonstrated workload. Measure target-specific
storage and raw Wasm bytes, IC instructions and actual cycle charges separately.
Include the recording work itself; samples whose measurement ends before
recording do not measure that overhead. Source-bound compiler checks and this
arithmetic example do not qualify any application's IC cost or lifecycle.
