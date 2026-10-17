use std::{cell::Cell, rc::Rc};

use ic_memory::{
    Memory, MemoryManagerConfig, RuntimeMemory, RuntimeOpenError, VectorMemory,
    testing::fixture_runtime,
};
use ic_metrics::{
    MeasurementAggregate as Aggregate, MeasurementCounter as Counter,
    MeasurementHistogram as Histogram, MeasurementSummary as Summary,
};

use crate::{MetricIdentity, MetricKey, MetricsMap, MetricsStore, StoreError, codec};

// Independent original-collection compatibility boundary. Even this test-only
// upstream map receives a checked runtime handle, never an independently assigned ID.
use ic_stable_structures::BTreeMap as RawMap;

// Isolated native host: declare a permanent key and commit allocation before opening.
fn memory<M: Memory>(backing: M) -> RuntimeMemory<M> {
    let runtime = fixture_runtime(
        backing,
        "metrics_test",
        "metrics.",
        &["metrics.store.v1"],
        MemoryManagerConfig::default(),
    )
    .unwrap();
    runtime.open_memory("metrics.store.v1").unwrap()
}

fn map<M: Memory>(backing: M) -> MetricsMap<M> {
    MetricsMap::init(memory(backing))
}

#[test]
fn store_retains_allocation_lease_through_map_transfer() {
    let runtime = fixture_runtime(
        VectorMemory::default(),
        "metrics_test",
        "metrics.",
        &["metrics.store.v1"],
        MemoryManagerConfig::default(),
    )
    .unwrap();
    let mut store = MetricsStore::new(MetricsMap::init(
        runtime.open_memory("metrics.store.v1").unwrap(),
    ));
    store
        .save_counter(&key("app"), &identity(), &Counter::ZERO)
        .unwrap();
    assert!(matches!(
        runtime.open_memory("metrics.store.v1"),
        Err(RuntimeOpenError::AlreadyOpen { .. })
    ));
    let map = store.into_map();
    assert!(matches!(
        runtime.open_memory("metrics.store.v1"),
        Err(RuntimeOpenError::AlreadyOpen { .. })
    ));
    drop(map);
    let reopened = MetricsStore::new(MetricsMap::load(
        runtime.open_memory("metrics.store.v1").unwrap(),
    ));
    assert_eq!(
        reopened.load_counter(&key("app"), &identity()),
        Ok(Some(Counter::ZERO))
    );
}

#[test]
fn governed_map_preserves_original_collection_bytes_and_kind_tags() {
    let backing = VectorMemory::default();
    let mut original = RawMap::<Vec<u8>, Vec<u8>, _>::init(memory(backing.clone()));
    let id = MetricIdentity::new("x", 3).unwrap();
    // Independent frozen V1 empty rows for all four metric families. In the
    // zero-bound histogram the finite-bound count and overflow are both zero.
    for (name, kind, payload) in [
        ("aggregate", 1, 33),
        ("summary", 2, 41),
        ("histogram", 3, 44),
        ("counter", 4, 17),
    ] {
        let key = MetricKey::new("app", name).unwrap();
        let mut bytes = b"ICM\x01".to_vec();
        bytes.extend_from_slice(&[kind, 1, b'x']);
        bytes.extend_from_slice(&3_u64.to_le_bytes());
        bytes.resize(bytes.len() + payload, 0);
        original.insert(key.0, bytes);
    }
    let before: Vec<_> = original
        .iter()
        .map(|entry| (entry.key().clone(), entry.value()))
        .collect();
    drop(original);
    let store = MetricsStore::new(map(backing.clone()));
    let key = |name| MetricKey::new("app", name).unwrap();
    assert_eq!(
        store.load_aggregate(&key("aggregate"), &id),
        Ok(Some(Aggregate::EMPTY))
    );
    assert_eq!(
        store.load_summary(&key("summary"), &id),
        Ok(Some(Summary::EMPTY))
    );
    assert_eq!(
        store.load_histogram(&key("histogram"), &id, &[]),
        Ok(Some(Histogram::new([]).unwrap()))
    );
    assert_eq!(
        store.load_counter(&key("counter"), &id),
        Ok(Some(Counter::ZERO))
    );
    assert_eq!(
        store
            .into_map()
            .iter()
            .map(|entry| (entry.key().clone(), entry.value()))
            .collect::<Vec<_>>(),
        before
    );
    let mut store = MetricsStore::new(map(backing.clone()));
    store
        .save_counter(
            &key("counter"),
            &id,
            &Counter::from_parts(9, false).unwrap(),
        )
        .unwrap();
    drop(store);
    let original = RawMap::<Vec<u8>, Vec<u8>, _>::load(memory(backing));
    let bytes = original.get(&key("counter").0).unwrap();
    assert_eq!(&bytes[..7], b"ICM\x01\x04\x01x");
    assert_eq!(&bytes[15..31], &9_u128.to_le_bytes());
}

#[test]
fn stored_kind_admission_rejects_every_unknown_tag_before_identity() {
    let id = identity();
    let mut bytes = encode(&id, &Counter::ZERO);
    for kind in 0..=u8::MAX {
        bytes[4] = kind;
        let result = codec::envelope(&bytes, &id);
        assert_eq!(result.is_ok(), (1..=4).contains(&kind));
        if !(1..=4).contains(&kind) {
            assert!(matches!(result, Err(StoreError::KindMismatch)));
        }
    }
}

fn identity() -> MetricIdentity {
    MetricIdentity::new("instructions", 0).unwrap()
}
fn key(namespace: &str) -> MetricKey {
    MetricKey::new(namespace, "work").unwrap()
}
fn store() -> MetricsStore<VectorMemory> {
    MetricsStore::new(map(VectorMemory::default()))
}

fn encode<T: crate::metric::StoredMetric>(identity: &MetricIdentity, value: &T) -> Vec<u8> {
    let payload_size = T::ENCODED_SIZE.unwrap();
    codec::encode(identity, value, payload_size)
}

fn assert_rejected_record<T: crate::metric::StoredMetric + std::fmt::Debug>(
    store: &mut MetricsStore<WriteCountingMemory>,
    writes: &Cell<usize>,
    key: &MetricKey,
    identity: &MetricIdentity,
    value: &T,
    (bytes, error): (Vec<u8>, StoreError),
) {
    // Callers install the record before this check, including before reopening.
    writes.set(0);
    assert_eq!(
        store.load::<T>(key, identity, value.configuration()),
        Err(error)
    );
    assert_eq!(store.save(key, identity, value), Err(error));
    assert_eq!(store.map.get(&key.0), Some(bytes));
    assert_eq!(writes.get(), 0);
}

#[test]
fn truncated_records_reject_all_metric_families_without_writes() {
    fn check<T: crate::metric::StoredMetric + std::fmt::Debug>(value: &T) {
        let memory = WriteCountingMemory::default();
        let writes = memory.writes.clone();
        let mut store = MetricsStore::new(map(memory));
        let key = key("app");
        let identity = identity();
        let bytes = encode(&identity, value);
        for length in 0..bytes.len() {
            let truncated = bytes[..length].to_vec();
            store.map.insert(key.0.clone(), truncated.clone());
            assert_rejected_record(
                &mut store,
                &writes,
                &key,
                &identity,
                value,
                (truncated, StoreError::MalformedRecord),
            );
        }
    }

    check(&Aggregate::EMPTY);
    let mut aggregate = Aggregate::EMPTY;
    aggregate.record(7);
    check(&aggregate);
    check(&Summary::EMPTY);
    check(&Summary::from_parts(aggregate, Some(7)).unwrap());
    check(&Counter::ZERO);
    check(&Counter::from_parts(7, false).unwrap());
    let mut histogram = Histogram::new([0, 10]).unwrap();
    check(&histogram);
    histogram.record(5);
    check(&histogram);
    check(&Histogram::new([]).unwrap());
}

#[test]
fn stored_unit_bytes_preserve_malformed_and_identity_errors() {
    let identity = MetricIdentity::new("x", 3).unwrap();
    let encoded = encode(&identity, &Aggregate::EMPTY);
    let memory = WriteCountingMemory::default();
    let writes = memory.writes.clone();
    let mut store = MetricsStore::new(map(memory));
    let key = key("app");
    for byte in 0..=u8::MAX {
        let mut bytes = encoded.clone();
        bytes[6] = byte;
        if byte == b'x' {
            assert_eq!(
                codec::decode::<Aggregate>(&bytes, &identity, &()),
                Ok(Aggregate::EMPTY)
            );
            continue;
        }
        let error = if byte.is_ascii_alphanumeric() || b"._/-:".contains(&byte) {
            StoreError::IdentityMismatch
        } else {
            StoreError::MalformedRecord
        };
        store.map.insert(key.0.clone(), bytes.clone());
        assert_rejected_record(
            &mut store,
            &writes,
            &key,
            &identity,
            &Aggregate::EMPTY,
            (bytes, error),
        );
    }
}

#[test]
fn one_map_reopens_mixed_types_and_namespaces_with_wide_totals() {
    let memory = VectorMemory::default();
    let mut store = MetricsStore::new(map(memory.clone()));
    let mut aggregate = Aggregate::EMPTY;
    let mut summary = Summary::EMPTY;
    let mut histogram = Histogram::new([0, 10]).unwrap();
    for value in [0, u64::MAX, u64::MAX, 9] {
        aggregate.record(value);
        summary.record(value);
        histogram.record(value);
    }
    store
        .save_aggregate(&key("icydb"), &identity(), &aggregate)
        .unwrap();
    store
        .save_summary(&key("canic"), &identity(), &summary)
        .unwrap();
    store
        .save_histogram(&key("timers"), &identity(), &histogram)
        .unwrap();
    let bytes_identity = MetricIdentity::new("bytes", 0).unwrap();
    let counter = Counter::from_parts(u128::from(u64::MAX) + 42, false).unwrap();
    store
        .save_counter(&key("backup"), &bytes_identity, &counter)
        .unwrap();
    drop(store);
    let reopened = MetricsStore::new(map(memory));
    assert_eq!(
        reopened.load_aggregate(&key("icydb"), &identity()),
        Ok(Some(aggregate))
    );
    assert_eq!(
        reopened.load_summary(&key("canic"), &identity()),
        Ok(Some(summary))
    );
    assert_eq!(
        reopened.load_histogram(&key("timers"), &identity(), &[0, 10]),
        Ok(Some(histogram))
    );
    assert_eq!(
        reopened.load_counter(&key("backup"), &bytes_identity),
        Ok(Some(counter))
    );
    assert_eq!(
        reopened.load_aggregate(&key("missing"), &identity()),
        Ok(None)
    );
    assert!(aggregate.total() > u128::from(u64::MAX));
}

#[test]
fn identity_kind_bounds_and_regression_reject_without_mutation() {
    let mut store = store();
    let mut histogram = Histogram::new([10]).unwrap();
    histogram.record(7);
    let key = key("app");
    store.save(&key, &identity(), &histogram).unwrap();
    assert_eq!(
        store.save(&key, &MetricIdentity::new("bytes", 0).unwrap(), &histogram),
        Err(StoreError::IdentityMismatch)
    );
    assert_eq!(
        store.save(
            &key,
            &MetricIdentity::new("instructions", 1).unwrap(),
            &histogram
        ),
        Err(StoreError::IdentityMismatch)
    );
    assert_eq!(
        store.save(&key, &identity(), &Aggregate::EMPTY),
        Err(StoreError::KindMismatch)
    );
    assert_eq!(
        store.save(&key, &identity(), &Histogram::new([11]).unwrap()),
        Err(StoreError::BoundsMismatch)
    );
    assert_eq!(
        store.save(&key, &identity(), &Histogram::new([10]).unwrap()),
        Err(StoreError::StateRegression)
    );
    assert_eq!(
        store.load_histogram(&key, &identity(), histogram.upper_bounds()),
        Ok(Some(histogram))
    );
    assert!(store.remove(&key, &identity()).unwrap());
    let next = MetricIdentity::new("instructions", 1).unwrap();
    store.save(&key, &next, &Aggregate::EMPTY).unwrap();
    assert_eq!(
        store.load_aggregate(&key, &next),
        Ok(Some(Aggregate::EMPTY))
    );
}

#[test]
fn exact_caps_and_overflow_flags_survive_storage_and_continue() {
    let mut store = store();
    let key = key("app");
    let mut value = Aggregate::from_parts(u64::MAX, 0, Some(0), false, false).unwrap();
    store.save(&key, &identity(), &value).unwrap();
    let exact = store.load_aggregate(&key, &identity()).unwrap().unwrap();
    assert!(!exact.samples_overflowed());
    value.record(0);
    store.save(&key, &identity(), &value).unwrap();
    assert_eq!(
        store.save(&key, &identity(), &exact),
        Err(StoreError::StateRegression)
    );
    assert_eq!(store.load_aggregate(&key, &identity()), Ok(Some(value)));
    let wide = Aggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    store.save(&key, &identity(), &wide).unwrap();
    assert_eq!(store.load_aggregate(&key, &identity()), Ok(Some(wide)));
    let histogram = Histogram::from_parts([0], [u64::MAX], 0, [true], false, value).unwrap();
    store
        .save(
            &crate::MetricKey::new("app", "distribution").unwrap(),
            &identity(),
            &histogram,
        )
        .unwrap();
}

#[test]
fn aggregate_v1_envelope_errors_and_explicit_removal() {
    let mut store = store();
    let key = key("app");
    let bytes = encode(&identity(), &Aggregate::EMPTY);
    let mut unknown = bytes.clone();
    unknown[3] = 99;
    assert_eq!(
        codec::decode::<Aggregate>(&unknown, &identity(), &()),
        Err(StoreError::UnsupportedFormat)
    );
    let mut trailing = bytes.clone();
    trailing.push(0);
    assert_eq!(
        codec::decode::<Aggregate>(&trailing, &identity(), &()),
        Err(StoreError::MalformedRecord)
    );
    let mut flags = bytes;
    *flags.last_mut().unwrap() = 4;
    assert_eq!(
        codec::decode::<Aggregate>(&flags, &identity(), &()),
        Err(StoreError::MalformedRecord)
    );
    store.map.insert(key.0.clone(), trailing);
    assert!(store.remove(&key, &identity()).unwrap());
}

#[test]
fn v1_encoding_is_explicit_and_rejects_invalid_numeric_state() {
    let mut value = Aggregate::EMPTY;
    value.record(7);
    let identity = MetricIdentity::new("x", 3).unwrap();
    let bytes = encode(&identity, &value);
    let mut expected = b"ICM\x01\x01\x01x".to_vec();
    expected.extend_from_slice(&3_u64.to_le_bytes());
    expected.extend_from_slice(&1_u64.to_le_bytes());
    expected.extend_from_slice(&7_u128.to_le_bytes());
    expected.extend_from_slice(&7_u64.to_le_bytes());
    expected.push(0);
    assert_eq!(bytes, expected);
    let summary = Summary::from_parts(value, Some(7)).unwrap();
    let mut summary_bytes = expected.clone();
    summary_bytes[4] = 2;
    summary_bytes.extend_from_slice(&7_u64.to_le_bytes());
    assert_eq!(encode(&identity, &summary), summary_bytes);
    assert_eq!(
        codec::decode::<Summary>(&summary_bytes, &identity, &()),
        Ok(summary)
    );
    let mut histogram = Histogram::new([10]).unwrap();
    histogram.record(7);
    let mut histogram_bytes = expected;
    histogram_bytes[4] = 3;
    histogram_bytes.extend_from_slice(&1_u16.to_le_bytes());
    histogram_bytes.extend_from_slice(&10_u64.to_le_bytes());
    histogram_bytes.extend_from_slice(&1_u64.to_le_bytes());
    histogram_bytes.push(0);
    histogram_bytes.extend_from_slice(&0_u64.to_le_bytes());
    histogram_bytes.push(0);
    assert_eq!(encode(&identity, &histogram), histogram_bytes);
    assert_eq!(
        codec::decode::<Histogram<1>>(&histogram_bytes, &identity, &[10]),
        Ok(histogram)
    );
    let mut invalid = bytes;
    // The admitted V1 envelope is 15 bytes here; change exact total to zero.
    invalid[23..39].fill(0);
    assert!(matches!(
        codec::decode::<Aggregate>(&invalid, &identity, &()),
        Err(StoreError::InvalidState(_))
    ));
}

#[test]
fn counter_checkpoints_preserve_wide_caps_identity_and_explicit_resets() {
    let memory = WriteCountingMemory::default();
    let writes = memory.writes.clone();
    let mut store = MetricsStore::new(map(memory.clone()));
    let key = key("app");
    let identity = MetricIdentity::new("bytes", 7).unwrap();
    assert_eq!(store.load_counter(&key, &identity), Ok(None));
    for value in [
        Counter::ZERO,
        Counter::from_parts(u128::from(u64::MAX) + 1, false).unwrap(),
        Counter::from_parts(u128::MAX, false).unwrap(),
        Counter::from_parts(u128::MAX, true).unwrap(),
    ] {
        store.save(&key, &identity, &value).unwrap();
        assert_eq!(store.load_counter(&key, &identity), Ok(Some(value)));
    }
    drop(store);
    let mut store = MetricsStore::new(map(memory));
    let retained = Counter::from_parts(u128::MAX, true).unwrap();
    assert_eq!(store.load_counter(&key, &identity), Ok(Some(retained)));
    writes.set(0);
    for regression in [
        Counter::ZERO,
        Counter::from_parts(u128::MAX, false).unwrap(),
    ] {
        assert_eq!(
            store.save(&key, &identity, &regression),
            Err(StoreError::StateRegression)
        );
    }
    for wrong in [
        MetricIdentity::new("items", 7).unwrap(),
        MetricIdentity::new("bytes", 8).unwrap(),
    ] {
        assert_eq!(
            store.load_counter(&key, &wrong),
            Err(StoreError::IdentityMismatch)
        );
        assert_eq!(
            store.save(&key, &wrong, &retained),
            Err(StoreError::IdentityMismatch)
        );
        assert_eq!(
            store.remove(&key, &wrong),
            Err(StoreError::IdentityMismatch)
        );
    }
    assert_eq!(
        store.load_aggregate(&key, &identity),
        Err(StoreError::KindMismatch)
    );
    assert_eq!(
        store.save(&key, &identity, &Aggregate::EMPTY),
        Err(StoreError::KindMismatch)
    );
    assert_eq!(writes.get(), 0);
    assert_eq!(store.load_counter(&key, &identity), Ok(Some(retained)));
    assert!(store.remove(&key, &identity).unwrap());
    let next = MetricIdentity::new("bytes", 8).unwrap();
    store.save(&key, &next, &Counter::ZERO).unwrap();
    assert_eq!(store.load_counter(&key, &next), Ok(Some(Counter::ZERO)));
    assert_eq!(
        store.load_counter(&key, &identity),
        Err(StoreError::IdentityMismatch)
    );
}

#[test]
fn counter_v1_records_reject_corruption_before_checkpoint_or_reset() {
    let value = Counter::from_parts(7, false).unwrap();
    let identity = MetricIdentity::new("x", 3).unwrap();
    let bytes = encode(&identity, &value);
    let mut expected = b"ICM\x01\x04\x01x".to_vec();
    expected.extend_from_slice(&3_u64.to_le_bytes());
    expected.extend_from_slice(&7_u128.to_le_bytes());
    expected.push(0);
    assert_eq!(bytes, expected);
    let mut malformed = Vec::new();
    let mut trailing = bytes.clone();
    trailing.push(0);
    malformed.push((trailing, StoreError::MalformedRecord));
    let mut invalid_flag = bytes.clone();
    *invalid_flag.last_mut().unwrap() = 2;
    malformed.push((invalid_flag, StoreError::MalformedRecord));
    let mut impossible_overflow = bytes.clone();
    *impossible_overflow.last_mut().unwrap() = 1;
    malformed.push((
        impossible_overflow,
        StoreError::InvalidState(ic_metrics::MeasurementStateError::InvalidOverflowFlag),
    ));
    let mut unknown_kind = bytes.clone();
    unknown_kind[4] = 5;
    malformed.push((unknown_kind, StoreError::KindMismatch));
    let mut unknown_format = bytes;
    unknown_format[3] = 2;
    malformed.push((unknown_format, StoreError::UnsupportedFormat));
    let memory = WriteCountingMemory::default();
    let writes = memory.writes.clone();
    let mut store = MetricsStore::new(map(memory));
    let key = key("app");
    for record in malformed {
        store.map.insert(key.0.clone(), record.0.clone());
        assert_rejected_record(&mut store, &writes, &key, &identity, &value, record);
    }
    assert_eq!(
        store.remove(&key, &identity),
        Err(StoreError::UnsupportedFormat)
    );
    assert_eq!(writes.get(), 0);
    // Explicit disposition can retire a known envelope with invalid payload.
    store
        .map
        .insert(key.0.clone(), expected[..expected.len() - 1].to_vec());
    assert!(store.remove(&key, &identity).unwrap());
    assert!(!store.remove(&key, &identity).unwrap());
    // An aggregate's existing kind cannot be reinterpreted as a scalar counter.
    store.save(&key, &identity, &Aggregate::EMPTY).unwrap();
    writes.set(0);
    assert_eq!(
        store.load_counter(&key, &identity),
        Err(StoreError::KindMismatch)
    );
    assert_eq!(
        store.save(&key, &identity, &value),
        Err(StoreError::KindMismatch)
    );
    assert_eq!(writes.get(), 0);
}

#[test]
fn inconsistent_summary_latest_rejects_load_and_save_without_overwrite() {
    let memory = WriteCountingMemory::default();
    let writes = memory.writes.clone();
    let mut store = MetricsStore::new(map(memory.clone()));
    let key = key("app");
    let identity = identity();
    let mut summary = Summary::EMPTY;
    summary.record(10);
    summary.record(10);
    let mut bytes = encode(&identity, &summary);
    // V1 stores latest as the final eight bytes. Zero contradicts two tens.
    let latest_offset = bytes.len() - 8;
    bytes[latest_offset..].copy_from_slice(&0_u64.to_le_bytes());
    store.map.insert(key.0.clone(), bytes.clone());
    drop(store);
    let mut reopened = MetricsStore::new(map(memory));
    assert_rejected_record(
        &mut reopened,
        &writes,
        &key,
        &identity,
        &summary,
        (
            bytes,
            StoreError::InvalidState(ic_metrics::MeasurementStateError::InvalidLatest),
        ),
    );
}

#[test]
fn bounded_inputs_empty_zero_and_idempotent_checkpoints() {
    assert_eq!(MetricKey::new("", "x"), Err(StoreError::InvalidIdentifier));
    assert_eq!(
        MetricKey::new("a\0b", "x"),
        Err(StoreError::InvalidIdentifier)
    );
    assert_eq!(
        MetricKey::new("a", &"x".repeat(129)),
        Err(StoreError::InvalidIdentifier)
    );
    assert_eq!(
        MetricIdentity::new("µs", 0),
        Err(StoreError::InvalidIdentifier)
    );
    assert_ne!(MetricKey::new("a", "b/c"), MetricKey::new("a/b", "c"));
    let mut store = store();
    let key = key("app");
    let mut value = Summary::EMPTY;
    store.save(&key, &identity(), &value).unwrap();
    assert_eq!(
        store.load_summary(&key, &identity()),
        Ok(Some(Summary::EMPTY))
    );
    value.record(0);
    store.save(&key, &identity(), &value).unwrap();
    store.save(&key, &identity(), &value).unwrap();
    assert_eq!(
        store
            .load_summary(&key, &identity())
            .unwrap()
            .unwrap()
            .latest(),
        Some(0)
    );
    let bounds = std::array::from_fn::<_, 257, _>(|index| u64::try_from(index).unwrap());
    let unsupported = Histogram::new(bounds).unwrap();
    let oversized_key = crate::MetricKey::new("app", "oversize").unwrap();
    assert_eq!(
        store.load_histogram(&oversized_key, &identity(), unsupported.upper_bounds()),
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(
        store.save_histogram(&oversized_key, &identity(), &unsupported),
        Err(StoreError::TooManyBounds)
    );
    assert!(store.map.get(&oversized_key.0).is_none());
    store.map.insert(oversized_key.0.clone(), vec![0]);
    assert_eq!(
        store.load_histogram(&oversized_key, &identity(), unsupported.upper_bounds()),
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(
        store.save_histogram(&oversized_key, &identity(), &unsupported),
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(store.map.get(&oversized_key.0), Some(vec![0]));
    let bytes = vec![0; 4609];
    assert_eq!(
        codec::decode::<Aggregate>(&bytes, &identity(), &()),
        Err(StoreError::RecordTooLarge)
    );
}

#[test]
fn histogram_checkpoints_cover_maximum_and_zero_bound_counts() {
    let identity = identity();
    let bounds = std::array::from_fn::<_, 256, _>(|index| u64::try_from(index).unwrap());
    let mut value = Histogram::new(bounds).unwrap();
    for observation in [0, 127, 255, 256] {
        value.record(observation);
    }
    let bytes = encode(&identity, &value);
    assert_eq!(
        codec::decode::<Histogram<256>>(&bytes, &identity, value.upper_bounds()),
        Ok(value)
    );
    let mut zero = Histogram::new([]).unwrap();
    zero.record(0);
    let bytes = encode(&identity, &zero);
    assert_eq!(
        codec::decode::<Histogram<0>>(&bytes, &identity, zero.upper_bounds()),
        Ok(zero)
    );
}

#[test]
fn checkpoints_reject_same_count_rewrites_and_admit_order_after_overflow() {
    let mut store = store();
    let key = key("app");
    let initial = Aggregate::from_parts(2, 8, Some(5), false, false).unwrap();
    store.save(&key, &identity(), &initial).unwrap();
    let rewrite = Aggregate::from_parts(2, 9, Some(5), false, false).unwrap();
    assert_eq!(
        store.save(&key, &identity(), &rewrite),
        Err(StoreError::StateRegression)
    );
    let summary_key = MetricKey::new("app", "ordered").unwrap();
    let aggregate = Aggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    let mut summary = Summary::from_parts(aggregate, Some(2)).unwrap();
    store.save(&summary_key, &identity(), &summary).unwrap();
    summary.record(3);
    store.save(&summary_key, &identity(), &summary).unwrap();
    assert_eq!(
        store.load_summary(&summary_key, &identity()),
        Ok(Some(summary))
    );
}

// Observe native Memory effects, not IC instructions, cycles or timings.
#[derive(Clone, Default)]
struct WriteCountingMemory {
    memory: VectorMemory,
    writes: Rc<Cell<usize>>,
}

impl Memory for WriteCountingMemory {
    fn size(&self) -> u64 {
        self.memory.size()
    }

    fn grow(&self, pages: u64) -> i64 {
        self.memory.grow(pages)
    }

    fn read(&self, offset: u64, dst: &mut [u8]) {
        self.memory.read(offset, dst);
    }

    fn write(&self, offset: u64, src: &[u8]) {
        self.writes.set(self.writes.get() + 1);
        self.memory.write(offset, src);
    }
}

#[test]
fn identical_checkpoints_validate_without_stable_writes() {
    fn check<T: crate::metric::StoredMetric>(initial: &T, changed: &T) {
        let memory = WriteCountingMemory::default();
        let writes = memory.writes.clone();
        let mut store = MetricsStore::new(map(memory));
        let key = key("app");
        writes.set(0);
        store.save(&key, &identity(), initial).unwrap();
        assert!(writes.get() > 0); // Absent is different from a retained empty row.
        for (value, changed) in [(initial, false), (changed, true)] {
            writes.set(0);
            store.save(&key, &identity(), value).unwrap();
            assert_eq!(writes.get() > 0, changed);
            writes.set(0);
            store.save(&key, &identity(), value).unwrap();
            assert_eq!(writes.get(), 0);
            assert!(
                store
                    .load::<T>(&key, &identity(), value.configuration())
                    .unwrap()
                    .as_ref()
                    == Some(value)
            );
        }
        writes.set(0);
        assert_eq!(
            store.save(&key, &MetricIdentity::new("bytes", 0).unwrap(), changed),
            Err(StoreError::IdentityMismatch)
        );
        assert_eq!(writes.get(), 0);
        store.map.insert(key.0.clone(), vec![0]);
        writes.set(0);
        assert_eq!(
            store.save(&key, &identity(), changed),
            Err(StoreError::MalformedRecord)
        );
        assert_eq!(writes.get(), 0);
        assert_eq!(store.map.get(&key.0), Some(vec![0]));
    }
    let mut aggregate = Aggregate::EMPTY;
    aggregate.record(0);
    check(&Aggregate::EMPTY, &aggregate);
    let mut counter = Counter::ZERO;
    counter.add(u128::from(u64::MAX) + 1);
    check(&Counter::ZERO, &counter);
    let exact_cap = Counter::from_parts(u128::MAX, false).unwrap();
    let overflowed = Counter::from_parts(u128::MAX, true).unwrap();
    check(&exact_cap, &overflowed);
    let mut summary = Summary::EMPTY;
    summary.record(1);
    check(&Summary::EMPTY, &summary);
    let mut histogram = Histogram::new([0; 0]).unwrap();
    histogram.record(0);
    check(&Histogram::new([]).unwrap(), &histogram);
    let bounds = std::array::from_fn::<_, 256, _>(|index| u64::try_from(index).unwrap());
    let mut histogram = Histogram::new(bounds).unwrap();
    histogram.record(255);
    check(&Histogram::new(bounds).unwrap(), &histogram);
}

#[test]
fn histogram_checkpoints_preserve_each_bucket_count_and_flag() {
    let exact = Aggregate::from_parts(2, 1, Some(1), false, false).unwrap();
    let redistributed = Aggregate::from_parts(3, 3, Some(1), false, false).unwrap();
    let zero = Aggregate::from_parts(u64::MAX, 1, Some(1), true, false).unwrap();
    let total = u128::from(u64::MAX) + 12;
    let overflow = Aggregate::from_parts(u64::MAX, total, Some(11), true, false).unwrap();
    let later_overflow =
        Aggregate::from_parts(u64::MAX, total + 11, Some(11), true, false).unwrap();
    // Every candidate passes core restoration. Other increasing fields cannot
    // compensate for a bucket decrease or a cleared flag in either array slot.
    let pairs = [
        (
            Histogram::from_parts([0, 10], [1, 1], 0, [false; 2], false, exact).unwrap(),
            Histogram::from_parts([0, 10], [0, 3], 0, [false; 2], false, redistributed).unwrap(),
        ),
        (
            Histogram::from_parts([0, 10], [u64::MAX, 1], 0, [true, false], false, zero).unwrap(),
            Histogram::from_parts([0, 10], [u64::MAX, 1], 0, [false; 2], false, zero).unwrap(),
        ),
        (
            Histogram::from_parts([0, 10], [0, u64::MAX], 1, [false, true], false, overflow)
                .unwrap(),
            Histogram::from_parts([0, 10], [0, u64::MAX], 2, [false; 2], false, later_overflow)
                .unwrap(),
        ),
    ];
    for (previous, regressing) in pairs {
        let memory = WriteCountingMemory::default();
        let writes = memory.writes.clone();
        let mut store = MetricsStore::new(map(memory));
        let key = key("app");
        store.save(&key, &identity(), &previous).unwrap();
        writes.set(0);
        assert_eq!(
            store.save(&key, &identity(), &regressing),
            Err(StoreError::StateRegression)
        );
        assert_eq!(writes.get(), 0);
        assert_eq!(
            store.load_histogram(&key, &identity(), previous.upper_bounds()),
            Ok(Some(previous))
        );
    }
}

#[test]
fn v1_encoding_has_exact_lengths_and_bounded_histograms() {
    fn check<T: crate::metric::StoredMetric>(value: &T, size: usize) {
        let identity = MetricIdentity::new(&"x".repeat(64), 3).unwrap();
        let bytes = encode(&identity, value);
        assert_eq!(bytes.len(), size + 64);
        assert!(codec::decode::<T>(&bytes, &identity, value.configuration()).unwrap() == *value);
    }
    check(&Aggregate::EMPTY, 47);
    check(&Counter::ZERO, 31);
    check(&Counter::from_parts(u128::MAX, true).unwrap(), 31);
    check(&Summary::EMPTY, 55);
    check(&Histogram::new([]).unwrap(), 58);
    check(
        &Histogram::new(std::array::from_fn::<_, 256, _>(|i| i as u64)).unwrap(),
        58 + 17 * 256,
    );
    let wide = Aggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    check(&wide, 47);
    check(&Summary::from_parts(wide, Some(u64::MAX)).unwrap(), 55);
    assert_eq!(
        <Histogram<257> as crate::metric::StoredMetric>::ENCODED_SIZE,
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(
        <Histogram<{ usize::MAX }> as crate::metric::StoredMetric>::ENCODED_SIZE,
        Err(StoreError::TooManyBounds)
    );
}

#[test]
fn histogram_equality_shortcut_preserves_full_state_comparison() {
    use crate::metric::StoredMetric;
    fn check<const N: usize>() {
        let bounds = std::array::from_fn::<_, N, _>(|i| i as u64);
        let empty = Histogram::new(bounds).unwrap();
        assert!(empty.same_state(&empty));
        let mut previous = empty;
        previous.record(0);
        assert!(previous.same_state(&previous));
        for sample in [0, u64::MAX] {
            let mut current = previous;
            current.record(sample);
            assert!(!current.same_state(&previous));
        }
        let other_bounds =
            Histogram::new(std::array::from_fn::<_, N, _>(|i| 1 + i as u64)).unwrap();
        assert_eq!(empty.same_state(&other_bounds), N == 0);
        // A clipped aggregate can remain unchanged while distribution changes.
        let aggregate =
            Aggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
        let clipped =
            Histogram::from_parts(bounds, [0; N], u64::MAX, [false; N], true, aggregate).unwrap();
        let mut continued = clipped;
        continued.record(0);
        assert_eq!(continued.aggregate(), clipped.aggregate());
        assert_eq!(continued.same_state(&clipped), N == 0);
        if N != 0 {
            let mut counts = [0; N];
            counts[0] = u64::MAX;
            let mut flags = [false; N];
            let exact_bucket =
                Histogram::from_parts(bounds, counts, u64::MAX, flags, true, aggregate).unwrap();
            flags[0] = true;
            let overflowed_bucket =
                Histogram::from_parts(bounds, counts, u64::MAX, flags, true, aggregate).unwrap();
            assert!(!exact_bucket.same_state(&overflowed_bucket));
        }
    }
    check::<0>();
    check::<1>();
    check::<4>();
    check::<8>();
    check::<256>();
}

#[test]
fn public_histogram_load_admits_expected_bounds_before_reading_a_row() {
    let memory = WriteCountingMemory::default();
    let writes = memory.writes.clone();
    let mut store = MetricsStore::new(map(memory));
    let key = key("app");
    let identity = identity();
    for retained in [None, Some(vec![0])] {
        if let Some(bytes) = retained.as_ref() {
            store.map.insert(key.0.clone(), bytes.clone());
        }
        writes.set(0);
        for bounds in [[10, 10], [10, 0]] {
            assert_eq!(
                store.load_histogram(&key, &identity, &bounds),
                Err(StoreError::InvalidState(
                    ic_metrics::MeasurementStateError::InvalidBounds
                ))
            );
        }
        assert_eq!(
            store.load_histogram(&key, &identity, &[0; 257]),
            Err(StoreError::TooManyBounds)
        );
        assert_eq!(store.map.get(&key.0), retained);
        assert_eq!(writes.get(), 0);
    }
}
