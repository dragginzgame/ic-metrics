use crate::MeasurementStateError;

use super::{MeasurementCounter as Counter, MeasurementCounterError as Error};

#[test]
fn zero_events_and_wide_quantities_are_exact() {
    let mut counter = Counter::ZERO;
    assert_eq!(counter, Counter::default());
    assert_eq!(counter.total(), 0);
    assert_eq!(counter.exact_total(), Ok(0));
    counter.add(0);
    assert_eq!(counter, Counter::ZERO);
    counter.add(1);
    counter.add(u128::from(u64::MAX));
    assert_eq!(counter.total(), u128::from(u64::MAX) + 1);
    assert!(!counter.total_saturated());
    assert!(u64::try_from(counter.exact_total().unwrap()).is_err());
}

#[test]
fn exact_caps_and_actual_overflow_remain_distinct_and_sticky() {
    let mut counter = Counter::ZERO;
    counter.add(u128::MAX - 1);
    counter.add(1);
    assert_eq!(counter.exact_total(), Ok(u128::MAX));
    counter.add(0);
    assert_eq!(counter.exact_total(), Ok(u128::MAX));
    counter.add(1);
    assert_eq!(counter.total(), u128::MAX);
    assert!(counter.total_saturated());
    assert_eq!(counter.exact_total(), Err(Error::SaturatedTotal));
    counter.add(0);
    counter.merge(Counter::ZERO);
    assert_eq!(counter.exact_total(), Err(Error::SaturatedTotal));
}

#[test]
fn merge_adds_batches_without_deduplication_and_propagates_loss() {
    let mut first = Counter::ZERO;
    first.add(7);
    let mut batch = Counter::ZERO;
    batch.add(3);
    first.merge(batch);
    first.merge(batch);
    assert_eq!(first.exact_total(), Ok(13));

    let mut exact = Counter::ZERO;
    exact.merge(Counter::from_parts(u128::MAX, false).unwrap());
    assert_eq!(exact.exact_total(), Ok(u128::MAX));
    exact.merge(batch);
    assert!(exact.total_saturated());

    let lost = Counter::from_parts(u128::MAX, true).unwrap();
    let mut destination = Counter::ZERO;
    destination.merge(lost);
    assert_eq!(destination.total(), u128::MAX);
    assert!(destination.total_saturated());
    assert_eq!(destination.exact_total(), Err(Error::SaturatedTotal));
}

#[test]
fn restoration_admits_numeric_quality_and_recording_continues() {
    assert_eq!(Counter::from_parts(0, false), Ok(Counter::ZERO));
    for total in [0, 1, u128::from(u64::MAX), u128::MAX - 1] {
        assert_eq!(
            Counter::from_parts(total, true),
            Err(MeasurementStateError::InvalidSaturation)
        );
        assert_eq!(
            Counter::from_parts(total, false).unwrap().exact_total(),
            Ok(total)
        );
    }
    let mut exact = Counter::from_parts(u128::MAX, false).unwrap();
    exact.add(1);
    assert_eq!(Counter::from_parts(exact.total(), true), Ok(exact));
    let mut restored = Counter::from_parts(exact.total(), exact.total_saturated()).unwrap();
    restored.add(9);
    assert_eq!(restored, exact);
}

#[test]
fn differences_check_loss_before_numeric_discontinuity() {
    let previous = Counter::from_parts(7, false).unwrap();
    let current = Counter::from_parts(12, false).unwrap();
    assert_eq!(current.delta_since(previous), Ok(5));
    assert_eq!(previous.delta_since(previous), Ok(0));
    assert_eq!(Counter::ZERO.delta_since(Counter::ZERO), Ok(0));
    assert_eq!(previous.delta_since(current), Err(Error::DecreasingTotal));
    let exact_cap = Counter::from_parts(u128::MAX, false).unwrap();
    assert_eq!(exact_cap.delta_since(previous), Ok(u128::MAX - 7));
    let lost = Counter::from_parts(u128::MAX, true).unwrap();
    assert_eq!(lost.delta_since(previous), Err(Error::SaturatedTotal));
    assert_eq!(current.delta_since(lost), Err(Error::SaturatedTotal));
    assert_eq!(lost.delta_since(lost), Err(Error::SaturatedTotal));
}

#[test]
fn addition_merge_restoration_and_differences_are_const() {
    const RESULT: Result<u128, Error> = {
        let mut counter = Counter::ZERO;
        counter.add(5);
        let before = counter;
        let Ok(batch) = Counter::from_parts(9, false) else {
            panic!("exact batch")
        };
        counter.merge(batch);
        counter.delta_since(before)
    };
    const EXACT: Result<u128, Error> = {
        let mut counter = Counter::ZERO;
        counter.add(u128::MAX);
        counter.exact_total()
    };
    assert_eq!(RESULT, Ok(9));
    assert_eq!(EXACT, Ok(u128::MAX));
}
