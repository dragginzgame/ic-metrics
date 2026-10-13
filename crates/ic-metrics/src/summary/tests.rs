use crate::MeasurementAggregate;

use super::{MeasurementMeanError, MeasurementSummary};

#[test]
fn summary_mean_preserves_recording_and_overflow_contracts() {
    let mut summary = MeasurementSummary::EMPTY;
    assert_eq!(summary.mean(), Ok(None));
    summary.record(0);
    assert_eq!(summary.mean(), Ok(Some(0)));
    summary.record(9);
    assert_eq!(summary.mean(), Ok(Some(4)));
    summary.record(u64::MAX - 9);
    assert_eq!(summary.total(), u128::from(u64::MAX));
    assert_eq!(summary.mean(), Ok(Some(u128::from(u64::MAX) / 3)));
    assert!(!summary.aggregate().total_overflowed());
    summary.record(1);
    assert_eq!(summary.mean(), Ok(Some((u128::from(u64::MAX) + 1) / 4)));
    assert!(!summary.aggregate().total_overflowed());
    assert_eq!(summary.latest(), Some(1));
    let mut overflowed_count =
        MeasurementSummary::from_parts(maximum_zero_count(), Some(0)).unwrap();
    assert_eq!(overflowed_count.mean(), Ok(Some(0)));
    overflowed_count.record(9);
    assert_eq!(
        overflowed_count.mean(),
        Err(MeasurementMeanError::SampleCountOverflow)
    );
}

#[test]
fn summary_means_are_available_in_constant_evaluation() {
    const PROJECTIONS: (MeasurementSummary, Option<u128>, Option<u128>) = {
        let mut summary = MeasurementSummary::EMPTY;
        summary.record(9);
        summary.record(0);
        let Ok(mean) = summary.mean() else {
            panic!("exact mean")
        };
        let Ok(scaled) = summary.scaled_mean(10) else {
            panic!("exact scaled mean")
        };
        (summary, mean, scaled)
    };
    assert_eq!((PROJECTIONS.1, PROJECTIONS.2), (Some(4), Some(45)));
    assert_eq!(PROJECTIONS.0.samples(), 2);
    assert_eq!(PROJECTIONS.0.total(), 9);
    assert_eq!(PROJECTIONS.0.latest(), Some(0));
    assert_eq!(PROJECTIONS.0.maximum(), Some(9));
    let mut summary = MeasurementSummary::EMPTY;
    assert_eq!(summary.scaled_mean(10), Ok(None));
    summary.record(0);
    assert_eq!(summary.scaled_mean(10), Ok(Some(0)));
    summary = MeasurementSummary::from_parts(maximum_zero_count(), Some(0)).unwrap();
    assert_eq!(summary.scaled_mean(u64::MAX), Ok(Some(0)));
    summary.record(0);
    assert_eq!(
        summary.scaled_mean(0),
        Err(MeasurementMeanError::SampleCountOverflow)
    );
}

#[test]
fn empty_and_measured_zero_are_distinct() {
    let mut summary = MeasurementSummary::EMPTY;
    assert_eq!(summary, MeasurementSummary::default());
    assert_eq!(summary.samples(), 0);
    assert_eq!(summary.total(), 0);
    assert_eq!(summary.latest(), None);
    assert_eq!(summary.maximum(), None);

    summary.record(0);
    assert_eq!(summary.samples(), 1);
    assert_eq!(summary.total(), 0);
    assert_eq!(summary.latest(), Some(0));
    assert_eq!(summary.maximum(), Some(0));
}

#[test]
fn latest_and_maximum_follow_individual_observations() {
    let mut summary = MeasurementSummary::EMPTY;
    for value in [7, 12, 3, 0] {
        summary.record(value);
    }
    assert_eq!(summary.samples(), 4);
    assert_eq!(summary.total(), 22);
    assert_eq!(summary.latest(), Some(0));
    assert_eq!(summary.maximum(), Some(12));
}

#[test]
fn total_overflow_preserves_count_latest_and_maximum() {
    let mut aggregate = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        aggregate.merge(aggregate);
        aggregate.record(u64::MAX);
    }
    aggregate.record(u64::MAX);
    aggregate.record(u64::MAX);
    let mut summary = MeasurementSummary::from_parts(aggregate, Some(u64::MAX)).unwrap();
    assert_eq!(summary.total(), u128::MAX);
    assert!(!summary.aggregate().total_overflowed());
    summary.record(1);
    summary.record(2);
    assert_eq!(summary.samples(), u64::MAX);
    assert_eq!(summary.total(), u128::MAX);
    assert!(summary.aggregate().samples_overflowed());
    assert!(summary.aggregate().total_overflowed());
    assert_eq!(summary.latest(), Some(2));
    assert_eq!(summary.maximum(), Some(u64::MAX));
}

#[test]
fn count_overflow_does_not_freeze_other_observations() {
    let mut summary = MeasurementSummary::from_parts(maximum_zero_count(), Some(0)).unwrap();
    summary.record(4);
    assert_eq!(summary.samples(), u64::MAX);
    assert_eq!(summary.total(), 4);
    assert_eq!(summary.latest(), Some(4));
    assert_eq!(summary.maximum(), Some(4));
}

fn maximum_zero_count() -> MeasurementAggregate {
    MeasurementAggregate::from_parts(u64::MAX, 0, Some(0), false, false).unwrap()
}
