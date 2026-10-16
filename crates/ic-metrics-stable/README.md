# IC Metrics Stable

Optional durable counter, aggregate, summary and histogram snapshots in **one stable
B-tree map per canister**. Multiple components share that map with permanent
namespace/name keys. Adding this package is the opt-in: `ic-metrics` alone stays
allocation-free, dependency-free, `no_std` and volatile. This adapter uses `std`,
allocates bounded records and supports native hosts and Wasm with Rust 1.91.

The host owns one `ic-memory` allocation pool and bootstrap. It declares one
permanent metrics-store key, such as `app.metrics.v1`, and admits that allocation
before opening the map. Follow the
[IC Memory 0.45 allocation and bootstrap guide](https://github.com/dragginzgame/ic-memory/blob/93463259a07295f50146beb57c36adab303d9a37/crates/ic-memory/README.md#quick-start-for-developers)
for the selected dependency's declaration and lifecycle APIs.

After bootstrap, the host opens the admitted memory and one `MetricsMap`, then
passes that map to `MetricsStore::new`. Components share access to that store;
namespace/name keys distinguish rows without allocating an ID per metric or
component. `ic-memory`'s governance allocations are separate. This package never
initializes memory, registers keys, creates a global store or installs lifecycle
hooks.

Metrics' V1 record layout is separate from Memory's allocation-ledger format.
Hosts upgrading their allocator to Memory 0.45 must follow its
[durable-format disposition](https://github.com/dragginzgame/ic-memory/blob/93463259a07295f50146beb57c36adab303d9a37/crates/ic-memory/README.md#operations-and-advanced-integration):
earlier allocator images require fresh/reset memory. An unchanged Metrics record
format does not qualify that host upgrade or authorize clearing existing memory.

## Store operations

Use the concrete operations for each metric family. Loads need only the row key,
identity and, for histograms, finite bounds; they do not take a dummy observation.

| Arithmetic type | Load | Checkpoint |
| --- | --- | --- |
| `MeasurementCounter` | `load_counter(key, identity)` | `save_counter(key, identity, value)` |
| `MeasurementAggregate` | `load_aggregate(key, identity)` | `save_aggregate(key, identity, value)` |
| `MeasurementSummary` | `load_summary(key, identity)` | `save_summary(key, identity, value)` |
| `MeasurementHistogram<N>` | `load_histogram(key, identity, bounds)` | `save_histogram(key, identity, value)` |

The 0.12 API removes the public `DurableMetric` bound and generic `load`/`save`.
Replace generic caller helpers with operations for their actual metric types.
Histogram loads admit at most 256 strictly increasing bounds before reading a row;
invalid expected bounds return `StoreError::InvalidState(InvalidBounds)`.
Serialization, kind selection and continuity dispatch are private implementation.

The following example reopens the same collection in native memory. It proves
storage/codec behavior, not IC upgrade execution or instruction/cycle costs:

```rust
use ic_memory::ic_stable_structures::{BTreeMap, VectorMemory};
use ic_metrics::MeasurementSummary;
use ic_metrics_stable::{MetricIdentity, MetricKey, MetricsStore};

# fn main() -> Result<(), ic_metrics_stable::StoreError> {
let memory = VectorMemory::default();
let mut store = MetricsStore::new(BTreeMap::init(memory.clone()));
let key = MetricKey::new("canic", "endpoint.create")?;
let identity = MetricIdentity::new("instructions", 0)?;
let mut summary = store.load_summary(&key, &identity)?
    .unwrap_or(MeasurementSummary::EMPTY);
summary.record(42);
store.save_summary(&key, &identity, &summary)?;
drop(store);

let reopened = MetricsStore::new(BTreeMap::init(memory));
assert_eq!(reopened.load_summary(&key, &identity)?, Some(summary));
# Ok(())
# }
```

For an IC host, import collections through
`ic_memory::ic_stable_structures` so their memory types match, and supply
`ic_memory::RuntimeMemory` issued by the admitted, committed runtime. The host retains its
bootstrapped runtime and injects the opened memory for the permanent metrics key;
open that store's map under its existing collection lifecycle contract. `BTreeMap::init`
can initialize unrecognized memory: never use it as a recovery fallback for an
unknown or corrupt store. The host must establish that a region is new or belongs
to this map. Allocator/collection corruption and capacity traps remain upstream
contracts; typed adapter errors cover identifiers, values and numeric admission.

## Durable contract

- Namespace/name keys are stable ASCII identifiers, up to 64/128 bytes. Units
  use the same alphabet and have a 64-byte limit. These namespaces separate rows;
  the canister still owns authorization and label cardinality.
- Every V1 record has a format discriminator, kind, unit, reset epoch and explicit
  little-endian state. Kinds 1/2/3 remain aggregate/summary/histogram; kind 4 is
  a scalar counter's 16-byte `u128` total followed by one overflow byte (0 or 1).
  Counters have no sample count, maximum or latest value. Existing kinds retain
  their exact layouts; this adapter introduces no record-format reset. An older
  adapter cannot read kind 4, so hosts must retain counter-aware code when reopening
  those rows.
  Records retain `u128` totals, maxima/latest, count/total overflow
  flags, histogram bounds, disjoint bucket counts and their flags. It never copies
  raw Rust struct memory. Histograms admit at most 256 finite bounds; records are
  limited to 4,608 bytes at the codec boundary. Constructor-admitted units and
  shape-admitted encoders are bounded together at compile time; the largest
  current encoded record is 4,474 bytes. Stored bytes still undergo independent
  size, envelope and numeric validation.
- Load checks kind, unit, epoch and exact histogram bounds, then restores through
  the core's typed numeric admission. Unknown formats, truncation, trailing bytes
  and malformed state are errors; they never silently create an empty metric.
- Save replaces a full snapshot rather than adding it again. Repeated identical
  saves validate the retained row and skip encoding/map writes when unchanged.
  Numeric regressions and clearing overflow flags are
  rejected before writing. Supply the latest retained state before recording;
  numeric checks do not establish sample attribution, ordering or provenance.
- Deliberate reset/retirement uses `remove` with the old identity. It verifies the
  envelope and discards the payload explicitly, including unreadable payloads.
  For a reset, save the replacement with a new epoch in the same update message,
  without an await between operations. It never retires/reuses the allocation ID.

Batch observations within an update message and checkpoint at an attribution
boundary chosen by the host. Stable writes during successful update execution
survive upgrades; query writes do not persist, and writes in a trapping message
roll back with that message. Async callbacks are separate message boundaries.
Checkpointing less frequently explicitly permits loss since the last checkpoint.
Neither persistence nor an upgrade establishes counter/call-context continuity;
unfinished spans must be re-established by the consumer.

Host-owned endpoints, resets, sample admission and synchronization remain local.

For diagnostic byte or event totals, use `load_counter`, start an absent row
with `MeasurementCounter::ZERO`, add only admitted exact quantities, then checkpoint at the host's
update-message boundary. Absent and stored zero remain distinct. Exact
`u128::MAX` and actual overflow remain distinct too; an overflowed counter cannot
later clear its flag or decrease without explicit removal and a new reset epoch.
These diagnostics never replace authoritative balances, quotas or ledger debt.

```rust
use ic_memory::ic_stable_structures::{BTreeMap, VectorMemory};
use ic_metrics::MeasurementCounter;
use ic_metrics_stable::{MetricIdentity, MetricKey, MetricsStore};

# fn main() -> Result<(), ic_metrics_stable::StoreError> {
let mut store = MetricsStore::new(BTreeMap::init(VectorMemory::default()));
let key = MetricKey::new("app", "processed.bytes")?;
let identity = MetricIdentity::new("bytes", 0)?;
let mut bytes = store.load_counter(&key, &identity)?
    .unwrap_or(MeasurementCounter::ZERO);
bytes.add(32_768);
store.save_counter(&key, &identity, &bytes)?;
assert_eq!(store.load_counter(&key, &identity)?, Some(bytes));
# Ok(())
# }
```

This native example verifies codec/storage behavior, not IC checkpoint costs or
upgrade execution. Hosts choose which completed work contributes and when to
write; persistence does not establish attribution or reset continuity.
Stable map reads/writes add allocation and IC costs. The repository's frozen
[IC store qualification](https://github.com/dragginzgame/ic-metrics/issues/64)
checks upgrades, query discard, trap rollback and reset, with actual checkpoint
costs under a matched workload. Batch observations before checkpointing at the
owning message boundary; measured costs depend on workload, map state and cadence.
The arithmetic-only cost evidence and native reopen tests retain their separate
scope and do not qualify live consumer execution.

```rust
use ic_memory::ic_stable_structures::{BTreeMap, VectorMemory};
use ic_metrics::{MeasurementAggregate, MeasurementHistogram};
use ic_metrics_stable::{MetricIdentity, MetricKey, MetricsStore};
# fn main() -> Result<(), Box<dyn std::error::Error>> {
let mut store = MetricsStore::new(BTreeMap::init(VectorMemory::default()));
let identity = MetricIdentity::new("items", 0)?;
let total_key = MetricKey::new("app", "batch.size")?;
let mut aggregate = store.load_aggregate(&total_key, &identity)?
    .unwrap_or(MeasurementAggregate::EMPTY);
aggregate.record(3);
store.save_aggregate(&total_key, &identity, &aggregate)?;
let distribution_key = MetricKey::new("app", "batch.distribution")?;
let bounds = [0, 10];
let mut histogram = store.load_histogram(&distribution_key, &identity, &bounds)?
    .unwrap_or(MeasurementHistogram::new(bounds)?);
histogram.record(3);
store.save_histogram(&distribution_key, &identity, &histogram)?;
# Ok(())
# }
```
