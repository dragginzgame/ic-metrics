use super::{
    HistogramBoundsError, HistogramQueryError, HistogramRange, MeasurementHistogram, quantile_rank,
};

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
    assert_eq!(histogram.summary().samples(), 8);
    assert_eq!(histogram.summary().total(), 112);
    assert_eq!(histogram.summary().latest(), Some(22));
    assert_eq!(histogram.summary().maximum(), Some(22));
}

#[test]
fn empty_and_measured_zero_are_distinct() {
    let mut histogram = MeasurementHistogram::new([0, 10]).unwrap();
    assert_eq!(histogram.bucket_counts(), &[0, 0]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.summary().samples(), 0);
    assert_eq!(histogram.summary().latest(), None);
    assert_eq!(histogram.summary().maximum(), None);

    histogram.record(0);
    assert_eq!(histogram.bucket_counts(), &[1, 0]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.summary().samples(), 1);
    assert_eq!(histogram.summary().total(), 0);
    assert_eq!(histogram.summary().latest(), Some(0));
    assert_eq!(histogram.summary().maximum(), Some(0));
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
    assert_eq!(histogram.summary().samples(), 3);
    assert_eq!(histogram.summary().total(), u64::MAX);
    assert_eq!(histogram.summary().maximum(), Some(u64::MAX));
}

#[test]
fn maximum_bound_includes_maximum_sample() {
    let mut histogram = MeasurementHistogram::new([0, u64::MAX]).unwrap();
    for value in [0, 1, u64::MAX] {
        histogram.record(value);
    }
    assert_eq!(histogram.bucket_counts(), &[1, 2]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.summary().samples(), 3);
    assert_eq!(histogram.summary().total(), u64::MAX);
}

#[test]
fn saturated_bucket_does_not_freeze_other_buckets_or_summary() {
    let mut histogram = MeasurementHistogram::new([2, 4]).unwrap();
    histogram.bucket_counts[0] = u64::MAX - 1;
    for value in [1, 2, 3, 5] {
        histogram.record(value);
    }
    assert_eq!(histogram.bucket_counts(), &[u64::MAX, 1]);
    assert_eq!(histogram.overflow(), 1);
    assert_eq!(histogram.summary().samples(), 4);
    assert_eq!(histogram.summary().total(), 11);
    assert_eq!(histogram.summary().latest(), Some(5));
    assert_eq!(histogram.summary().maximum(), Some(5));
}

#[test]
fn saturated_overflow_and_total_do_not_freeze_other_observations() {
    let mut histogram = MeasurementHistogram::new([1]).unwrap();
    histogram.overflow = u64::MAX - 1;
    histogram.record(u64::MAX);
    assert_eq!(histogram.overflow(), u64::MAX);
    assert_eq!(histogram.summary().total(), u64::MAX);
    histogram.record(u64::MAX);
    histogram.record(1);
    assert_eq!(histogram.bucket_counts(), &[1]);
    assert_eq!(histogram.overflow(), u64::MAX);
    assert_eq!(histogram.summary().samples(), 3);
    assert_eq!(histogram.summary().latest(), Some(1));
    assert_eq!(histogram.summary().maximum(), Some(u64::MAX));
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
    assert_eq!(histogram.summary().samples(), 3);
    assert_eq!(histogram.summary().total(), 16);
    assert_eq!(INVALID, Err(HistogramBoundsError { index: 1 }));
    assert_eq!(UNBOUNDED.unwrap().summary().samples(), 0);
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
    histogram.bucket_counts[2] = u64::MAX;
    histogram.overflow = u64::MAX;
    assert_eq!(histogram.cumulative_count(1), Ok(4));
    assert_eq!(
        histogram.cumulative_count(2),
        Err(HistogramQueryError::SaturatedCount)
    );
    histogram.bucket_counts = [u64::MAX - 1, 1, 0];
    assert_eq!(histogram.cumulative_count(0), Ok(u64::MAX - 1));
    assert_eq!(
        histogram.cumulative_count(1),
        Err(HistogramQueryError::SaturatedCount)
    );
    histogram.bucket_counts[1] = 2;
    assert_eq!(
        histogram.cumulative_count(1),
        Err(HistogramQueryError::SaturatedCount)
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
    // Saturated value totals do not invalidate exact distribution counts.
    assert_eq!(histogram.summary().total(), u64::MAX);
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
fn quantiles_reject_invalid_fractions_and_all_required_saturated_counts() {
    let mut histogram = MeasurementHistogram::new([10, 100]).unwrap();
    for (numerator, denominator) in [(0, 0), (1, 0), (0, 1), (2, 1)] {
        assert_eq!(
            histogram.quantile_bucket(numerator, denominator),
            Err(HistogramQueryError::InvalidQuantile)
        );
    }
    histogram.record(0);
    // A later saturated count cannot be ignored just because rank 1 is earlier.
    histogram.bucket_counts[1] = u64::MAX;
    assert_eq!(
        histogram.quantile_bucket(1, 100),
        Err(HistogramQueryError::SaturatedCount)
    );
    histogram.bucket_counts[1] = 0;
    histogram.overflow = u64::MAX;
    assert_eq!(
        histogram.quantile_bucket(1, 100),
        Err(HistogramQueryError::SaturatedCount)
    );
    assert_eq!(
        quantile_rank(u64::MAX, 1, 2),
        Err(HistogramQueryError::SaturatedCount)
    );
    assert_eq!(
        quantile_rank(u64::MAX, 0, 0),
        Err(HistogramQueryError::InvalidQuantile)
    );
    assert_eq!(
        quantile_rank(u64::MAX - 1, u64::MAX - 1, u64::MAX),
        Ok(Some(u128::from(u64::MAX - 1)))
    );
    assert_eq!(quantile_rank(u64::MAX - 1, 1, u64::MAX), Ok(Some(1)));
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
