use super::{
    HistogramBoundsError, HistogramQueryError, HistogramRange, MeasurementHistogram, quantile_rank,
};
use crate::MeasurementAggregate;

#[test]
fn rejects_first_duplicate_or_descending_bound() {
    for (bounds, index) in [([3, 3, 4], 1), ([3, 2, 4], 1), ([1, 4, 3], 2)] {
        assert_eq!(
            MeasurementHistogram::new(bounds),
            Err(HistogramBoundsError { index })
        );
        assert_eq!(HistogramBoundsError { index }.index(), index);
    }
}

#[test]
fn inclusive_bounds_assign_each_sample_to_one_bucket() {
    let mut histogram = MeasurementHistogram::new([10, 20]).unwrap();
    for value in [0, 9, 10, 11, 19, 20, 21, 22] {
        histogram.record(value);
    }
    assert_eq!(histogram.upper_bounds(), &[10, 20]);
    assert_eq!(histogram.bucket_counts(), &[3, 3]);
    assert_eq!(histogram.overflow(), 2);
    assert_eq!(histogram.aggregate().samples(), 8);
    assert_eq!(histogram.aggregate().total(), 112);
    assert_eq!(histogram.aggregate().maximum(), Some(22));
}

#[test]
fn empty_and_measured_zero_are_distinct() {
    let mut histogram = MeasurementHistogram::new([0, 10]).unwrap();
    assert_eq!(histogram.bucket_counts(), &[0, 0]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.aggregate().samples(), 0);
    assert_eq!(histogram.aggregate().maximum(), None);

    histogram.record(0);
    assert_eq!(histogram.bucket_counts(), &[1, 0]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.aggregate().samples(), 1);
    assert_eq!(histogram.aggregate().total(), 0);
    assert_eq!(histogram.aggregate().maximum(), Some(0));
}

#[test]
fn no_bounds_count_all_samples_in_overflow() {
    let mut histogram = MeasurementHistogram::new([]).unwrap();
    for value in [0, 7, u64::MAX] {
        histogram.record(value);
    }
    assert_eq!(histogram.upper_bounds(), &[]);
    assert_eq!(histogram.bucket_counts(), &[]);
    assert_eq!(histogram.overflow(), 3);
    assert_eq!(histogram.aggregate().samples(), 3);
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX) + 7);
    assert_eq!(histogram.aggregate().maximum(), Some(u64::MAX));
}

#[test]
fn maximum_bound_includes_maximum_sample() {
    let mut histogram = MeasurementHistogram::new([0, u64::MAX]).unwrap();
    for value in [0, 1, u64::MAX] {
        histogram.record(value);
    }
    assert_eq!(histogram.bucket_counts(), &[1, 2]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.aggregate().samples(), 3);
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX) + 1);
}

#[test]
fn overflowed_bucket_does_not_freeze_other_buckets_or_aggregate() {
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX - 1,
        2 * u128::from(u64::MAX - 1),
        Some(2),
        false,
        false,
    )
    .unwrap();
    let mut histogram = MeasurementHistogram::from_parts(
        [2, 4],
        [u64::MAX - 1, 0],
        0,
        [false; 2],
        false,
        aggregate,
    )
    .unwrap();
    for value in [1, 2, 3, 5] {
        histogram.record(value);
    }
    assert_eq!(histogram.bucket_counts(), &[u64::MAX, 1]);
    assert_eq!(histogram.overflow(), 1);
    assert_eq!(histogram.bucket_overflowed(), &[true, false]);
    assert_eq!(histogram.aggregate().samples(), u64::MAX);
    assert!(histogram.aggregate().samples_overflowed());
    assert_eq!(
        histogram.aggregate().total(),
        2 * u128::from(u64::MAX - 1) + 11
    );
    assert_eq!(histogram.aggregate().maximum(), Some(5));
}

#[test]
fn overflow_bucket_and_total_overflow_do_not_freeze_other_observations() {
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX,
        u128::from(u64::MAX).pow(2),
        Some(u64::MAX),
        false,
        false,
    )
    .unwrap();
    let mut histogram =
        MeasurementHistogram::from_parts([1], [0], u64::MAX, [false], false, aggregate).unwrap();
    histogram.record(u64::MAX);
    histogram.record(u64::MAX);
    assert!(!histogram.aggregate().total_overflowed());
    histogram.record(u64::MAX);
    assert_eq!(histogram.overflow(), u64::MAX);
    assert_eq!(histogram.aggregate().total(), u128::MAX);
    assert!(histogram.aggregate().total_overflowed());
    histogram.record(u64::MAX);
    histogram.record(1);
    assert_eq!(histogram.bucket_counts(), &[1]);
    assert_eq!(histogram.overflow(), u64::MAX);
    assert_eq!(histogram.aggregate().samples(), u64::MAX);
    assert_eq!(histogram.aggregate().maximum(), Some(u64::MAX));
}

#[test]
fn construction_rejection_and_recording_are_available_in_constant_evaluation() {
    const HISTOGRAM: Result<MeasurementHistogram<2>, HistogramBoundsError> =
        match MeasurementHistogram::new([0, 10]) {
            Ok(mut histogram) => {
                histogram.record(0);
                histogram.record(5);
                histogram.record(11);
                Ok(histogram)
            }
            Err(error) => Err(error),
        };
    const INVALID: Result<MeasurementHistogram<2>, HistogramBoundsError> =
        MeasurementHistogram::new([1, 1]);
    const UNBOUNDED: Result<MeasurementHistogram<0>, HistogramBoundsError> =
        MeasurementHistogram::new([]);

    let histogram = HISTOGRAM.unwrap();
    assert_eq!(histogram.bucket_counts(), &[1, 1]);
    assert_eq!(histogram.overflow(), 1);
    assert_eq!(histogram.aggregate().samples(), 3);
    assert_eq!(histogram.aggregate().total(), 16);
    assert_eq!(INVALID, Err(HistogramBoundsError { index: 1 }));
    assert_eq!(UNBOUNDED.unwrap().aggregate().samples(), 0);
}

#[test]
fn cumulative_counts_use_only_the_requested_finite_prefix() {
    let mut histogram = MeasurementHistogram::new([0, 10, 100]).unwrap();
    assert_eq!(histogram.cumulative_count(1), Ok(0));
    for value in [0, 0, 1, 10, 11, 100, 101] {
        histogram.record(value);
    }
    for (index, expected) in [2, 4, 6].into_iter().enumerate() {
        assert_eq!(histogram.cumulative_count(index), Ok(expected));
    }
    assert_eq!(
        histogram.cumulative_count(3),
        Err(HistogramQueryError::BucketOutOfBounds {
            index: 3,
            buckets: 3
        })
    );
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX,
        201 * u128::from(u64::MAX) + 120,
        Some(101),
        true,
        false,
    )
    .unwrap();
    let histogram = MeasurementHistogram::from_parts(
        [0, 10, 100],
        [2, 2, u64::MAX],
        u64::MAX,
        [false, false, true],
        false,
        aggregate,
    )
    .unwrap();
    assert_eq!(histogram.cumulative_count(1), Ok(4));
    assert_eq!(
        histogram.cumulative_count(2),
        Err(HistogramQueryError::CountOverflow)
    );
    let aggregate = MeasurementAggregate::from_parts(u64::MAX, 1, Some(1), false, false).unwrap();
    let mut histogram = MeasurementHistogram::from_parts(
        [0, 10, 100],
        [u64::MAX - 1, 1, 0],
        0,
        [false; 3],
        false,
        aggregate,
    )
    .unwrap();
    assert_eq!(histogram.cumulative_count(0), Ok(u64::MAX - 1));
    assert_eq!(histogram.cumulative_count(1), Ok(u64::MAX));
    histogram.record(1);
    assert_eq!(
        histogram.cumulative_count(1),
        Err(HistogramQueryError::CountOverflow)
    );
}

#[test]
fn nearest_rank_quantiles_return_ranges_including_overflow() {
    let mut histogram = MeasurementHistogram::new([0, 10, 100]).unwrap();
    for value in [0, 0, 1, 10, 11, 100, 101, 1_000] {
        histogram.record(value);
    }
    let before = histogram;
    for (numerator, denominator, lower, upper) in [
        (1, 8, None, Some(0)),
        (1, 4, None, Some(0)),
        (1, 3, Some(0), Some(10)), // ceil(8/3) = rank 3
        (1, 2, Some(0), Some(10)),
        (3, 4, Some(10), Some(100)),
        (95, 100, Some(100), None),
        (1, 1, Some(100), None),
        (u64::MAX, u64::MAX, Some(100), None),
    ] {
        let range = histogram
            .quantile_bucket(numerator, denominator)
            .unwrap()
            .unwrap();
        assert_eq!(range.lower_exclusive(), lower);
        assert_eq!(range.upper_inclusive(), upper);
    }
    assert_eq!(histogram, before);
}

#[test]
fn query_empty_zero_no_bounds_and_maximum_bound() {
    let mut histogram = MeasurementHistogram::new([0, u64::MAX]).unwrap();
    assert_eq!(histogram.quantile_bucket(1, 2), Ok(None));
    histogram.record(0);
    assert_eq!(
        histogram.quantile_bucket(1, 2),
        Ok(Some(HistogramRange {
            lower_exclusive: None,
            upper_inclusive: Some(0),
        }))
    );
    histogram.record(u64::MAX);
    histogram.record(1);
    // Wide value totals do not invalidate exact distribution counts.
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX) + 1);
    assert_eq!(histogram.cumulative_count(1), Ok(3));
    assert_eq!(
        histogram.quantile_bucket(1, 1),
        Ok(Some(HistogramRange {
            lower_exclusive: Some(0),
            upper_inclusive: Some(u64::MAX),
        }))
    );
    let mut unbounded = MeasurementHistogram::new([]).unwrap();
    assert_eq!(unbounded.quantile_bucket(1, 2), Ok(None));
    assert_eq!(
        unbounded.cumulative_count(0),
        Err(HistogramQueryError::BucketOutOfBounds {
            index: 0,
            buckets: 0,
        })
    );
    unbounded.record(0);
    assert_eq!(
        unbounded.quantile_bucket(1, 2),
        Ok(Some(HistogramRange {
            lower_exclusive: None,
            upper_inclusive: None,
        }))
    );
}

#[test]
fn quantiles_reject_invalid_fractions_and_all_required_overflowed_counts() {
    let mut histogram = MeasurementHistogram::new([10, 100]).unwrap();
    for (numerator, denominator) in [(0, 0), (1, 0), (0, 1), (2, 1)] {
        assert_eq!(
            histogram.quantile_bucket(numerator, denominator),
            Err(HistogramQueryError::InvalidQuantile)
        );
    }
    let aggregate = MeasurementAggregate::from_parts(u64::MAX, 0, Some(0), true, false).unwrap();
    histogram = MeasurementHistogram::from_parts(
        [10, 100],
        [u64::MAX, 0],
        0,
        [true, false],
        false,
        aggregate,
    )
    .unwrap();
    assert_eq!(
        histogram.quantile_bucket(1, 100),
        Err(HistogramQueryError::CountOverflow)
    );
    assert_eq!(
        histogram.quantile_bucket(0, 0),
        Err(HistogramQueryError::InvalidQuantile)
    );
}

#[test]
fn nearest_rank_matches_wide_oracle_across_product_boundaries() {
    for (numerator, denominator) in [
        (1, 1),
        (1, 2),
        (2, 3),
        (95, 100),
        (1, u64::MAX),
        (u64::MAX / 2, u64::MAX),
        (u64::MAX - 1, u64::MAX),
        (u64::MAX, u64::MAX),
    ] {
        let boundary = u64::MAX / numerator;
        for samples in [
            0,
            1,
            2,
            3,
            5,
            100,
            u64::from(u32::MAX),
            u64::from(u32::MAX) + 1,
            boundary - 1,
            boundary,
            boundary.saturating_add(1),
            u64::MAX - 1,
            u64::MAX,
        ] {
            let product = u128::from(samples) * u128::from(numerator);
            let divisor = u128::from(denominator);
            let expected = product / divisor + u128::from(product % divisor != 0);
            assert_eq!(quantile_rank(samples, numerator, denominator), expected);
        }
    }
    // Invalid fractions precede emptiness on both sides of the product boundary.
    for samples in [0, 1, u64::MAX] {
        let aggregate =
            MeasurementAggregate::from_parts(samples, 0, (samples != 0).then_some(0), false, false)
                .unwrap();
        let histogram =
            MeasurementHistogram::from_parts([], [], samples, [], false, aggregate).unwrap();
        for (numerator, denominator) in [(0, 0), (0, 1), (1, 0), (u64::MAX, u64::MAX - 1)] {
            assert_eq!(
                histogram.quantile_bucket(numerator, denominator),
                Err(HistogramQueryError::InvalidQuantile)
            );
        }
    }
}

#[test]
fn reporting_queries_are_available_in_constant_evaluation() {
    const REPORT: (
        Result<u64, HistogramQueryError>,
        Result<Option<HistogramRange>, HistogramQueryError>,
    ) = match MeasurementHistogram::new([10]) {
        Ok(mut histogram) => {
            histogram.record(0);
            histogram.record(11);
            (
                histogram.cumulative_count(0),
                histogram.quantile_bucket(1, 1),
            )
        }
        Err(_) => panic!("test bounds are increasing"),
    };
    assert_eq!(REPORT.0, Ok(1));
    assert_eq!(
        REPORT.1,
        Ok(Some(HistogramRange {
            lower_exclusive: Some(10),
            upper_inclusive: None
        }))
    );
}

#[test]
fn merged_partitions_match_recording_and_reject_different_bounds_atomically() {
    let mut left = MeasurementHistogram::new([0, 10]).unwrap();
    let mut right = left;
    let mut expected = left;
    for (index, value) in [0, 1, 10, 11, u64::MAX, 3].into_iter().enumerate() {
        expected.record(value);
        if index % 2 == 0 {
            left.record(value);
        } else {
            right.record(value);
        }
    }
    let source = right;
    left.merge(&right).unwrap();
    assert_eq!(left, expected);
    assert_eq!(right, source);
    let before = left;
    let mut mismatched = MeasurementHistogram::new([0, 11]).unwrap();
    mismatched.record(2);
    assert_eq!(left.merge(&mismatched).unwrap_err().index(), 1);
    assert_eq!(left, before);
    assert_eq!(
        left.quantile_bucket(1, 2)
            .unwrap()
            .unwrap()
            .upper_inclusive(),
        Some(10)
    );
}

#[test]
fn exact_count_cap_is_queryable_until_real_overflow_and_stays_sticky() {
    let mut histogram = MeasurementHistogram::new([0]).unwrap();
    for _ in 0..64 {
        let previous = histogram;
        histogram.merge(&previous).unwrap();
        histogram.record(0);
    }
    assert_eq!(histogram.cumulative_count(0), Ok(u64::MAX));
    assert_eq!(histogram.bucket_overflowed(), &[false]);
    assert!(!histogram.aggregate().samples_overflowed());
    assert_eq!(
        histogram
            .quantile_bucket(1, 1)
            .unwrap()
            .unwrap()
            .upper_inclusive(),
        Some(0)
    );
    histogram.record(0);
    assert_eq!(histogram.bucket_overflowed(), &[true]);
    assert!(histogram.aggregate().samples_overflowed());
    assert_eq!(
        histogram.cumulative_count(0),
        Err(HistogramQueryError::CountOverflow)
    );
    assert_eq!(
        histogram.quantile_bucket(1, 1),
        Err(HistogramQueryError::CountOverflow)
    );
    let mut destination = MeasurementHistogram::new([0]).unwrap();
    destination.merge(&histogram).unwrap();
    assert_eq!(destination, histogram);
    destination
        .merge(&MeasurementHistogram::new([0]).unwrap())
        .unwrap();
    assert!(destination.bucket_overflowed()[0]);
}

#[test]
fn merging_no_bounds_and_exact_value_caps_preserves_overflow_provenance() {
    let mut left = MeasurementHistogram::new([]).unwrap();
    let mut right = left;
    left.record(0);
    right.record(u64::MAX);
    left.merge(&right).unwrap();
    assert_eq!(left.overflow(), 2);
    assert!(!left.overflow_count_overflowed());
    assert_eq!(left.aggregate().mean(), Ok(Some(u128::from(u64::MAX) / 2)));
    left.record(1);
    assert!(!left.aggregate().total_overflowed());
    assert_eq!(left.aggregate().total(), u128::from(u64::MAX) + 1);
    assert_eq!(
        left.quantile_bucket(1, 1)
            .unwrap()
            .unwrap()
            .upper_inclusive(),
        None
    );
    // Distribution-count overflow propagates even into an empty destination.
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX,
        u128::from(u64::MAX),
        Some(u64::MAX),
        true,
        false,
    )
    .unwrap();
    left = MeasurementHistogram::from_parts([], [], u64::MAX, [], true, aggregate).unwrap();
    let mut destination = MeasurementHistogram::new([]).unwrap();
    destination.merge(&left).unwrap();
    assert!(destination.overflow_count_overflowed());
    assert_eq!(
        destination.quantile_bucket(1, 2),
        Err(HistogramQueryError::CountOverflow)
    );
}

#[test]
fn histogram_merging_supports_constant_evaluation() {
    const MERGED: Result<MeasurementHistogram<1>, super::HistogramMergeError> = {
        let Ok(mut left) = MeasurementHistogram::new([10]) else {
            panic!("test bounds");
        };
        let mut right = left;
        left.record(0);
        right.record(11);
        match left.merge(&right) {
            Ok(()) => Ok(left),
            Err(error) => Err(error),
        }
    };
    let merged = MERGED.unwrap();
    assert_eq!(merged.bucket_counts(), &[1]);
    assert_eq!(merged.overflow(), 1);
    assert_eq!(merged.aggregate().mean(), Ok(Some(5)));
}

#[test]
fn maximum_count_of_maximum_values_retains_exact_total_and_distribution() {
    let mut histogram = MeasurementHistogram::new([u64::MAX]).unwrap();
    for _ in 0..64 {
        histogram.merge(&histogram.clone()).unwrap();
        histogram.record(u64::MAX);
    }
    assert_eq!(histogram.aggregate().samples(), u64::MAX);
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX).pow(2));
    assert_eq!(histogram.aggregate().mean(), Ok(Some(u128::from(u64::MAX))));
    assert_eq!(histogram.cumulative_count(0), Ok(u64::MAX));
    assert_eq!(
        histogram.quantile_bucket(95, 100),
        Ok(Some(HistogramRange {
            lower_exclusive: None,
            upper_inclusive: Some(u64::MAX),
        }))
    );
    histogram.record(1);
    assert!(!histogram.aggregate().total_overflowed());
    assert_eq!(
        histogram.quantile_bucket(95, 100),
        Err(HistogramQueryError::CountOverflow)
    );
}
