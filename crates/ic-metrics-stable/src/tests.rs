use ic_memory::ic_stable_structures::{BTreeMap, VectorMemory};
use ic_metrics::{
    MeasurementAggregate as Aggregate, MeasurementHistogram as Histogram,
    MeasurementSummary as Summary,
};

use crate::{MetricIdentity, MetricKey, MetricsStore, StoreError, codec};

fn identity() -> MetricIdentity {
    MetricIdentity::new("instructions", 0).unwrap()
}
fn key(namespace: &str) -> MetricKey {
    MetricKey::new(namespace, "work").unwrap()
}
fn store() -> MetricsStore<VectorMemory> {
    MetricsStore::new(BTreeMap::init(VectorMemory::default()))
}

#[test]
fn one_map_reopens_mixed_types_and_namespaces_with_wide_totals() {
    let memory = VectorMemory::default();
    let mut store = MetricsStore::new(BTreeMap::init(memory.clone()));
    let mut aggregate = Aggregate::EMPTY;
    let mut summary = Summary::EMPTY;
    let mut histogram = Histogram::new([0, 10]).unwrap();
    for value in [0, u64::MAX, u64::MAX, 9] {
        aggregate.record(value);
        summary.record(value);
        histogram.record(value);
    }
    store.save(&key("icydb"), &identity(), &aggregate).unwrap();
    store.save(&key("canic"), &identity(), &summary).unwrap();
    store.save(&key("timers"), &identity(), &histogram).unwrap();
    drop(store);
    let reopened = MetricsStore::new(BTreeMap::init(memory));
    assert_eq!(
        reopened.load(&key("icydb"), &identity(), &Aggregate::EMPTY),
        Ok(Some(aggregate))
    );
    assert_eq!(
        reopened.load(&key("canic"), &identity(), &Summary::EMPTY),
        Ok(Some(summary))
    );
    assert_eq!(
        reopened.load(
            &key("timers"),
            &identity(),
            &Histogram::new([0, 10]).unwrap()
        ),
        Ok(Some(histogram))
    );
    assert_eq!(
        reopened.load(&key("missing"), &identity(), &Aggregate::EMPTY),
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
        store.load(&key, &identity(), &histogram),
        Ok(Some(histogram))
    );
    assert!(store.remove(&key, &identity()).unwrap());
    let next = MetricIdentity::new("instructions", 1).unwrap();
    store.save(&key, &next, &Aggregate::EMPTY).unwrap();
    assert_eq!(
        store.load(&key, &next, &Aggregate::EMPTY),
        Ok(Some(Aggregate::EMPTY))
    );
}

#[test]
fn exact_caps_and_overflow_flags_survive_storage_and_continue() {
    let mut store = store();
    let key = key("app");
    let mut value = Aggregate::from_parts(u64::MAX, 0, Some(0), false, false).unwrap();
    store.save(&key, &identity(), &value).unwrap();
    let exact = store
        .load(&key, &identity(), &Aggregate::EMPTY)
        .unwrap()
        .unwrap();
    assert!(!exact.samples_overflowed());
    value.record(0);
    store.save(&key, &identity(), &value).unwrap();
    assert_eq!(
        store.save(&key, &identity(), &exact),
        Err(StoreError::StateRegression)
    );
    assert_eq!(
        store.load(&key, &identity(), &Aggregate::EMPTY),
        Ok(Some(value))
    );
    let wide = Aggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    store.save(&key, &identity(), &wide).unwrap();
    assert_eq!(
        store.load(&key, &identity(), &Aggregate::EMPTY),
        Ok(Some(wide))
    );
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
fn corrupted_records_never_reset_or_overwrite_implicitly() {
    let mut store = store();
    let key = key("app");
    let bytes = codec::encode(&identity(), &Aggregate::EMPTY).unwrap();
    for length in 0..bytes.len() {
        let truncated = bytes[..length].to_vec();
        store.map.insert(key.0.clone(), truncated.clone());
        assert!(store.load(&key, &identity(), &Aggregate::EMPTY).is_err());
        assert!(store.save(&key, &identity(), &Aggregate::EMPTY).is_err());
        assert_eq!(store.map.get(&key.0), Some(truncated));
    }
    let mut unknown = bytes.clone();
    unknown[3] = 99;
    assert_eq!(
        codec::decode(&unknown, &identity(), &Aggregate::EMPTY),
        Err(StoreError::UnsupportedFormat)
    );
    let mut trailing = bytes.clone();
    trailing.push(0);
    assert_eq!(
        codec::decode(&trailing, &identity(), &Aggregate::EMPTY),
        Err(StoreError::MalformedRecord)
    );
    let mut flags = bytes;
    *flags.last_mut().unwrap() = 4;
    assert_eq!(
        codec::decode(&flags, &identity(), &Aggregate::EMPTY),
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
    let bytes = codec::encode(&identity, &value).unwrap();
    let mut expected = b"ICM\x01\x01\x01x".to_vec();
    expected.extend_from_slice(&3_u64.to_le_bytes());
    expected.extend_from_slice(&1_u64.to_le_bytes());
    expected.extend_from_slice(&7_u128.to_le_bytes());
    expected.extend_from_slice(&7_u64.to_le_bytes());
    expected.push(0);
    assert_eq!(bytes, expected);
    let mut invalid = bytes;
    // The admitted V1 envelope is 15 bytes here; change exact total to zero.
    invalid[23..39].fill(0);
    assert!(matches!(
        codec::decode(&invalid, &identity, &Aggregate::EMPTY),
        Err(StoreError::InvalidState(_))
    ));
}

#[test]
fn inconsistent_summary_latest_rejects_load_and_save_without_overwrite() {
    let memory = VectorMemory::default();
    let mut store = MetricsStore::new(BTreeMap::init(memory.clone()));
    let key = key("app");
    let identity = identity();
    let mut summary = Summary::EMPTY;
    summary.record(10);
    summary.record(10);
    let mut bytes = codec::encode(&identity, &summary).unwrap();
    // V1 stores latest as the final eight bytes. Zero contradicts two tens.
    let latest_offset = bytes.len() - 8;
    bytes[latest_offset..].copy_from_slice(&0_u64.to_le_bytes());
    store.map.insert(key.0.clone(), bytes.clone());
    drop(store);
    let mut reopened = MetricsStore::new(BTreeMap::init(memory));
    assert_eq!(
        reopened.load(&key, &identity, &Summary::EMPTY),
        Err(StoreError::InvalidState(
            ic_metrics::MeasurementStateError::InvalidLatest,
        ))
    );
    assert_eq!(
        reopened.save(&key, &identity, &summary),
        Err(StoreError::InvalidState(
            ic_metrics::MeasurementStateError::InvalidLatest,
        ))
    );
    assert_eq!(reopened.map.get(&key.0), Some(bytes));
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
        store.load(&key, &identity(), &value),
        Ok(Some(Summary::EMPTY))
    );
    value.record(0);
    store.save(&key, &identity(), &value).unwrap();
    store.save(&key, &identity(), &value).unwrap();
    assert_eq!(
        store
            .load(&key, &identity(), &Summary::EMPTY)
            .unwrap()
            .unwrap()
            .latest(),
        Some(0)
    );
    let bounds = std::array::from_fn::<_, 257, _>(|index| u64::try_from(index).unwrap());
    let unsupported = Histogram::new(bounds).unwrap();
    let oversized_key = crate::MetricKey::new("app", "oversize").unwrap();
    assert_eq!(
        store.load(&oversized_key, &identity(), &unsupported),
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(
        store.save(&oversized_key, &identity(), &unsupported),
        Err(StoreError::TooManyBounds)
    );
    assert!(store.map.get(&oversized_key.0).is_none());
    store.map.insert(oversized_key.0.clone(), vec![0]);
    assert_eq!(
        store.load(&oversized_key, &identity(), &unsupported),
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(
        store.save(&oversized_key, &identity(), &unsupported),
        Err(StoreError::TooManyBounds)
    );
    assert_eq!(store.map.get(&oversized_key.0), Some(vec![0]));
    let bytes = vec![0; 4609];
    assert_eq!(
        codec::decode(&bytes, &identity(), &Aggregate::EMPTY),
        Err(StoreError::RecordTooLarge)
    );
}

#[test]
fn histogram_corruption_and_maximum_bound_size_are_admitted_explicitly() {
    let identity = identity();
    let mut histogram = Histogram::new([0, 10]).unwrap();
    histogram.record(5);
    let bytes = codec::encode(&identity, &histogram).unwrap();
    for length in 0..bytes.len() {
        assert!(codec::decode(&bytes[..length], &identity, &histogram).is_err());
    }
    let bounds = std::array::from_fn::<_, 256, _>(|index| u64::try_from(index).unwrap());
    let mut value = Histogram::new(bounds).unwrap();
    for observation in [0, 127, 255, 256] {
        value.record(observation);
    }
    let bytes = codec::encode(&identity, &value).unwrap();
    assert_eq!(codec::decode(&bytes, &identity, &value), Ok(value));
    let mut zero = Histogram::new([]).unwrap();
    zero.record(0);
    let bytes = codec::encode(&identity, &zero).unwrap();
    assert_eq!(codec::decode(&bytes, &identity, &zero), Ok(zero));
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
        store.load(&summary_key, &identity(), &Summary::EMPTY),
        Ok(Some(summary))
    );
}

#[test]
fn ic_memory_bootstrap_retains_one_application_binding_for_all_metrics() {
    use ic_memory::{
        GenericAllocationPolicy, MemoryAllocationPool, MemoryAuthority, MemoryRequest,
        MemoryRuntime, SchemaMetadata, SealedDeclarationSnapshot,
    };
    let backing = VectorMemory::default();
    let pool =
        MemoryAllocationPool::new(vec![MemoryAuthority::new("app", "app.").unwrap()], vec![])
            .unwrap();
    let declarations = SealedDeclarationSnapshot::new(vec![
        MemoryRequest::new("app", "app.metrics.v1", SchemaMetadata::default()).unwrap(),
    ])
    .unwrap();
    let mut host = MemoryRuntime::new(backing.clone()).unwrap();
    host.bootstrap(&declarations, &pool, &GenericAllocationPolicy)
        .unwrap();
    let first_id = host.memory_id("app.metrics.v1").unwrap();
    let mut store = MetricsStore::new(BTreeMap::init(host.open_memory("app.metrics.v1").unwrap()));
    let mut aggregate = Aggregate::EMPTY;
    aggregate.record(42);
    for namespace in ["icydb", "canic", "timers"] {
        store
            .save(&key(namespace), &identity(), &aggregate)
            .unwrap();
    }
    drop(store);
    drop(host);
    let mut host = MemoryRuntime::new(backing).unwrap();
    host.bootstrap(&declarations, &pool, &GenericAllocationPolicy)
        .unwrap();
    assert_eq!(host.memory_id("app.metrics.v1").unwrap(), first_id);
    let store = MetricsStore::new(BTreeMap::init(host.open_memory("app.metrics.v1").unwrap()));
    for namespace in ["icydb", "canic", "timers"] {
        assert_eq!(
            store.load(&key(namespace), &identity(), &Aggregate::EMPTY),
            Ok(Some(aggregate))
        );
    }
}
