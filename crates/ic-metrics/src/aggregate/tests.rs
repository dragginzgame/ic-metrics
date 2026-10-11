use super::*;

fn aggregate(values: &[u64]) -> MeasurementAggregate {
    let mut result = MeasurementAggregate::EMPTY;
    for &value in values {
        result.record(value);
    }
    result
}

#[test]
fn exact_caps_and_actual_overflow_have_distinct_projections() {
    let mut result = aggregate(&[u64::MAX]);
    assert_eq!(result.mean(), Ok(Some(u64::MAX)));
    assert!(!result.total_saturated());
    result.record(0);
    assert_eq!(result.mean(), Ok(Some(u64::MAX / 2)));
    result.record(1);
    assert_eq!(result.total(), u64::MAX);
    assert!(result.total_saturated());
    assert_eq!(result.mean(), Err(MeasurementMeanError::SaturatedTotal));
    assert_eq!(result.maximum(), Some(u64::MAX));
    result.merge(MeasurementAggregate::EMPTY);
    assert!(result.total_saturated());

    let mut count = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        count.merge(count);
        count.record(0);
    }
    assert_eq!(count.samples(), u64::MAX);
    assert!(!count.samples_saturated());
    assert_eq!(count.mean(), Ok(Some(0)));
    count.record(0);
    assert!(count.samples_saturated());
    assert_eq!(count.mean(), Err(MeasurementMeanError::SaturatedSamples));
    let mut empty = MeasurementAggregate::EMPTY;
    empty.merge(count);
    assert_eq!(empty, count);
}

#[test]
fn merge_is_additive_commutative_associative_and_preserves_empty_zero() {
    let empty = MeasurementAggregate::EMPTY;
    assert_eq!(empty, MeasurementAggregate::default());
    assert_eq!(empty.maximum(), None);
    assert_eq!(empty.mean(), Ok(None));
    assert_eq!(aggregate(&[0]).maximum(), Some(0));
    for values in [&[0, 2, 9][..], &[u64::MAX, 0, 1][..]] {
        let a = aggregate(&values[..1]);
        let b = aggregate(&values[1..2]);
        let c = aggregate(&values[2..]);
        let mut forward = a;
        forward.merge(b);
        let mut reverse = b;
        reverse.merge(a);
        assert_eq!(forward, reverse);
        forward.merge(c);
        let mut tail = b;
        tail.merge(c);
        let mut grouped = a;
        grouped.merge(tail);
        assert_eq!(forward, grouped);
        assert_eq!(forward, aggregate(values));
        forward.merge(empty);
        assert_eq!(forward, grouped);
    }
    let mut duplicate = aggregate(&[3]);
    duplicate.merge(duplicate);
    assert_eq!((duplicate.samples(), duplicate.total()), (2, 6));
}

#[test]
fn intervals_distinguish_no_work_zero_work_and_exact_cap() {
    let mut current = aggregate(&[5]);
    let previous = current;
    let empty = current.interval_since(previous).unwrap();
    assert_eq!((empty.samples(), empty.total(), empty.mean()), (0, 0, None));
    current.record(0);
    let zero = current.interval_since(previous).unwrap();
    assert_eq!((zero.samples(), zero.total(), zero.mean()), (1, 0, Some(0)));
    current.record(u64::MAX - 5);
    let added = current.interval_since(previous).unwrap();
    assert_eq!((added.samples(), added.total()), (2, u64::MAX - 5));
    assert_eq!(added.mean(), Some((u64::MAX - 5) / 2));
    let cap = aggregate(&[u64::MAX])
        .interval_since(MeasurementAggregate::EMPTY)
        .unwrap();
    assert_eq!(cap.mean(), Some(u64::MAX));
    current.record(1);
    assert_eq!(
        current.interval_since(previous),
        Err(MeasurementIntervalError::SaturatedTotal)
    );
    assert_eq!(
        previous.interval_since(current),
        Err(MeasurementIntervalError::SaturatedTotal)
    );
}

#[test]
fn intervals_reject_numeric_discontinuity_and_all_required_overflow() {
    use MeasurementIntervalError::*;
    assert_eq!(
        aggregate(&[5]).interval_since(aggregate(&[0, 0])),
        Err(DecreasingSamples)
    );
    assert_eq!(
        aggregate(&[0, 0]).interval_since(aggregate(&[5])),
        Err(DecreasingTotal)
    );
    assert_eq!(
        aggregate(&[6]).interval_since(aggregate(&[5])),
        Err(TotalWithoutSamples)
    );
    let mut lost_count = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        lost_count.merge(lost_count);
        lost_count.record(0);
    }
    lost_count.record(0);
    assert_eq!(
        lost_count.interval_since(MeasurementAggregate::EMPTY),
        Err(SaturatedSamples)
    );
    assert_eq!(
        MeasurementAggregate::EMPTY.interval_since(lost_count),
        Err(SaturatedSamples)
    );
}

#[test]
fn recording_merging_and_interval_queries_support_constant_evaluation() {
    const RESULT: (
        MeasurementAggregate,
        Result<MeasurementInterval, MeasurementIntervalError>,
    ) = {
        let mut left = MeasurementAggregate::EMPTY;
        left.record(0);
        let mut right = MeasurementAggregate::EMPTY;
        right.record(7);
        left.merge(right);
        (left, left.interval_since(MeasurementAggregate::EMPTY))
    };
    assert_eq!(RESULT.0, aggregate(&[0, 7]));
    assert_eq!(RESULT.1.unwrap().mean(), Some(3));
}
