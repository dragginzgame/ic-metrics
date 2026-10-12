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
    assert_eq!(result.mean(), Ok(Some(u128::from(u64::MAX))));
    result.record(0);
    result.record(1);
    assert_eq!(result.total(), u128::from(u64::MAX) + 1);
    assert!(!result.total_saturated());
    assert_eq!(result.mean(), Ok(Some((u128::from(u64::MAX) + 1) / 3)));
    assert_eq!(result.maximum(), Some(u64::MAX));

    // u64::MAX samples of the largest value still have an exact total and mean.
    let mut largest_batch = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        largest_batch.merge(largest_batch);
        largest_batch.record(u64::MAX);
    }
    assert_eq!(largest_batch.samples(), u64::MAX);
    assert_eq!(largest_batch.total(), u128::from(u64::MAX).pow(2));
    assert_eq!(largest_batch.mean(), Ok(Some(u128::from(u64::MAX))));
    assert!(!largest_batch.samples_saturated());
    assert!(!largest_batch.total_saturated());
    let interval = largest_batch
        .interval_since(MeasurementAggregate::EMPTY)
        .unwrap();
    assert_eq!(interval.total(), largest_batch.total());
    assert_eq!(interval.mean(), Some(u128::from(u64::MAX)));

    // Two further maximum observations reach u128::MAX exactly. Only the
    // sample count has overflowed; another zero cannot lose total exactness.
    largest_batch.record(u64::MAX);
    largest_batch.record(u64::MAX);
    assert_eq!(largest_batch.total(), u128::MAX);
    assert!(largest_batch.samples_saturated());
    assert!(!largest_batch.total_saturated());
    largest_batch.record(0);
    assert!(!largest_batch.total_saturated());
    largest_batch.record(1);
    assert!(largest_batch.total_saturated());
    assert_eq!(largest_batch.total(), u128::MAX);
    assert_eq!(
        largest_batch.mean(),
        Err(MeasurementMeanError::SaturatedSamples)
    );
    let mut inherited = MeasurementAggregate::EMPTY;
    inherited.merge(largest_batch);
    assert_eq!(inherited, largest_batch);
    result.merge(largest_batch);
    assert!(result.samples_saturated());
    assert!(result.total_saturated());
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
    assert_eq!(
        (added.samples(), added.total()),
        (2, u128::from(u64::MAX) - 5)
    );
    assert_eq!(added.mean(), Some((u128::from(u64::MAX) - 5) / 2));
    let cap = aggregate(&[u64::MAX])
        .interval_since(MeasurementAggregate::EMPTY)
        .unwrap();
    assert_eq!(cap.mean(), Some(u128::from(u64::MAX)));
    current.record(1);
    let wide = current.interval_since(previous).unwrap();
    assert_eq!(
        (wide.samples(), wide.total()),
        (3, u128::from(u64::MAX) - 4)
    );
    current.record(u64::MAX);
    let wider = current.interval_since(previous).unwrap();
    assert_eq!(wider.total(), 2 * u128::from(u64::MAX) - 4);
    assert_eq!(wider.mean(), Some(wider.total() / 4));
    assert_eq!(
        previous.interval_since(current),
        Err(MeasurementIntervalError::DecreasingSamples)
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

#[test]
fn scaled_means_keep_fractional_information_and_admitted_wide_products() {
    let inputs = [0, 1, 3, 4, 10_001, u64::MAX];
    for left in inputs {
        for right in inputs {
            let value = aggregate(&[left, right]);
            for scale in [0, 1, 10, 10_000, u64::MAX] {
                // An independent decomposition avoids multiplying the wide total.
                let total = u128::from(left) + u128::from(right);
                let expected =
                    (total / 2) * u128::from(scale) + (total % 2) * u128::from(scale) / 2;
                assert_eq!(value.scaled_mean(scale), Ok(Some(expected)));
            }
        }
    }
    let value = aggregate(&[3, 4]);
    assert_eq!(value.mean(), Ok(Some(3)));
    assert_eq!(value.scaled_mean(10), Ok(Some(35)));
    assert_eq!(MeasurementAggregate::EMPTY.scaled_mean(0), Ok(None));
    assert_eq!(aggregate(&[0]).scaled_mean(10), Ok(Some(0)));
}

#[test]
fn scaled_means_admit_exact_caps_and_reject_loss_even_with_zero_scale() {
    const VALUE: Result<Option<u128>, MeasurementMeanError> = {
        let mut value = MeasurementAggregate::EMPTY;
        value.record(u64::MAX);
        value.record(u64::MAX);
        value.scaled_mean(u64::MAX)
    };
    let mut exact = MeasurementAggregate::from_parts(
        u64::MAX,
        u128::from(u64::MAX).pow(2),
        Some(u64::MAX),
        false,
        false,
    )
    .unwrap();
    assert_eq!(
        exact.scaled_mean(u64::MAX),
        Ok(Some(u128::from(u64::MAX).pow(2)))
    );
    exact.record(0);
    assert_eq!(
        exact.scaled_mean(0),
        Err(MeasurementMeanError::SaturatedSamples)
    );
    exact.record(u64::MAX);
    exact.record(u64::MAX);
    assert!(!exact.total_saturated());
    exact.record(1);
    assert!(exact.total_saturated());
    assert_eq!(
        exact.scaled_mean(10),
        Err(MeasurementMeanError::SaturatedSamples)
    );
    assert_eq!(VALUE, Ok(Some(u128::from(u64::MAX).pow(2))));
}
