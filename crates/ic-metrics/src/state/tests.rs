use crate::{
    MeasurementAggregate as Aggregate, MeasurementHistogram as Histogram,
    MeasurementStateError as Error, MeasurementSummary as Summary,
};

#[test]
fn restored_observations_continue_without_replay() {
    let mut original = Summary::EMPTY;
    for value in [0, u64::MAX, u64::MAX, 7] {
        original.record(value);
    }
    let aggregate = original.aggregate();
    let restored = Aggregate::from_parts(
        aggregate.samples(),
        aggregate.total(),
        aggregate.maximum(),
        aggregate.samples_saturated(),
        aggregate.total_saturated(),
    )
    .unwrap();
    let mut restored = Summary::from_parts(restored, original.latest()).unwrap();
    assert_eq!(restored, original);
    original.record(0);
    restored.record(0);
    assert_eq!(restored, original);
}

#[test]
fn restored_caps_preserve_exactness_and_sticky_loss() {
    let exact = Aggregate::from_parts(u64::MAX, 0, Some(0), false, false).unwrap();
    assert_eq!(exact.mean(), Ok(Some(0)));
    let mut lost = exact;
    lost.record(0);
    assert_eq!(
        Aggregate::from_parts(lost.samples(), lost.total(), lost.maximum(), true, false),
        Ok(lost)
    );
    let wide = Aggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    assert!(wide.total_saturated());
    assert_eq!(
        Aggregate::from_parts(1, u128::MAX, Some(u64::MAX), false, true),
        Err(Error::InvalidSaturation)
    );
}

#[test]
fn inconsistent_aggregate_and_ordered_fields_are_rejected() {
    assert_eq!(
        Aggregate::from_parts(0, 0, Some(0), false, false),
        Err(Error::InvalidEmpty)
    );
    assert_eq!(
        Aggregate::from_parts(1, 0, None, false, false),
        Err(Error::MissingMaximum)
    );
    assert_eq!(
        Aggregate::from_parts(1, 2, Some(1), false, false),
        Err(Error::InvalidTotal)
    );
    assert_eq!(
        Aggregate::from_parts(1, 0, Some(0), true, false),
        Err(Error::InvalidSaturation)
    );
    let mut aggregate = Aggregate::EMPTY;
    aggregate.record(9);
    assert_eq!(
        Summary::from_parts(aggregate, Some(8)),
        Err(Error::InvalidLatest)
    );
    assert_eq!(
        Summary::from_parts(Aggregate::EMPTY, Some(0)),
        Err(Error::InvalidLatest)
    );
}

#[test]
fn histogram_restoration_preserves_distribution_and_rejects_disagreement() {
    let mut original = Histogram::new([0, 10]).unwrap();
    for value in [0, 0, 5, 11] {
        original.record(value);
    }
    let restored = Histogram::from_parts(
        *original.upper_bounds(),
        *original.bucket_counts(),
        original.overflow(),
        *original.bucket_saturation(),
        original.overflow_saturated(),
        original.aggregate(),
    )
    .unwrap();
    assert_eq!(restored, original);
    assert_eq!(
        Histogram::from_parts([0, 10], [1, 1], 1, [false; 2], false, original.aggregate()),
        Err(Error::InvalidDistribution)
    );
    assert_eq!(
        Histogram::from_parts([0, 0], [2, 1], 1, [false; 2], false, original.aggregate()),
        Err(Error::InvalidBounds)
    );
    assert_eq!(
        Histogram::from_parts(
            [0, 10],
            [2, 1],
            1,
            [true, false],
            false,
            original.aggregate()
        ),
        Err(Error::InvalidSaturation)
    );
    let zero = Aggregate::from_parts(1, 0, Some(0), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([0, 10], [0, 1], 0, [false; 2], false, zero),
        Err(Error::InvalidDistribution)
    );
}

#[test]
fn zero_bound_histogram_and_bucket_count_overflow_restore() {
    let mut original = Histogram::new([]).unwrap();
    original.record(0);
    assert_eq!(
        Histogram::from_parts([], [], 1, [], false, original.aggregate()),
        Ok(original)
    );
    let aggregate = Aggregate::from_parts(u64::MAX, 0, Some(0), true, false).unwrap();
    let value = Histogram::from_parts([0], [u64::MAX], 0, [true], false, aggregate).unwrap();
    assert!(value.bucket_saturation()[0]);
}

#[test]
fn histogram_range_totals_reject_impossible_observations() {
    let high = Aggregate::from_parts(2, 20, Some(10), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([0, 10], [1, 1], 0, [false; 2], false, high),
        Err(Error::InvalidDistribution)
    );
    let low = Aggregate::from_parts(2, 10, Some(10), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([0, 10], [0, 2], 0, [false; 2], false, low),
        Err(Error::InvalidDistribution)
    );
    let impossible = Aggregate::from_parts(u64::MAX, u128::MAX, Some(2), true, true).unwrap();
    assert_eq!(
        Histogram::from_parts([1, 2], [1, u64::MAX], 0, [false; 2], false, impossible),
        Err(Error::InvalidDistribution)
    );
}

#[test]
fn every_small_observation_sequence_restores_including_wide_values() {
    let values = [0, 1, 2, 3, 11, u64::MAX];
    for first in values {
        for second in values {
            for third in values {
                let mut histogram = Histogram::new([0, 2, 10, u64::MAX]).unwrap();
                let mut summary = Summary::EMPTY;
                for value in [first, second, third] {
                    histogram.record(value);
                    summary.record(value);
                }
                assert_eq!(
                    Histogram::from_parts(
                        *histogram.upper_bounds(),
                        *histogram.bucket_counts(),
                        histogram.overflow(),
                        *histogram.bucket_saturation(),
                        histogram.overflow_saturated(),
                        histogram.aggregate()
                    ),
                    Ok(histogram)
                );
                assert_eq!(
                    Summary::from_parts(summary.aggregate(), summary.latest()),
                    Ok(summary)
                );
            }
        }
    }
}
