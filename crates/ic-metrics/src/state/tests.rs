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
        aggregate.samples_overflowed(),
        aggregate.total_overflowed(),
    )
    .unwrap();
    let mut restored = Summary::from_parts(restored, original.latest()).unwrap();
    assert_eq!(restored, original);
    original.record(0);
    restored.record(0);
    assert_eq!(restored, original);
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
        Err(Error::InvalidOverflowFlag)
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
                        *histogram.bucket_overflowed(),
                        histogram.overflow_count_overflowed(),
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
