use super::{HistogramBoundsError, MeasurementHistogram};

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
