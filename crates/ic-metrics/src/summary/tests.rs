use crate::MeasurementAggregate;

use super::MeasurementSummary;

#[test]
fn summary_recording_and_restoration_support_constant_evaluation() {
    const SUMMARY: MeasurementSummary = {
        let mut summary = MeasurementSummary::EMPTY;
        summary.record(9);
        summary.record(0);
        summary
    };
    const RESTORED: MeasurementSummary =
        match MeasurementSummary::from_parts(SUMMARY.aggregate(), SUMMARY.latest()) {
            Ok(summary) => summary,
            Err(_) => panic!("consistent constant summary"),
        };
    assert_eq!(RESTORED, SUMMARY);
    assert_eq!(RESTORED.latest(), Some(0));
    assert_eq!(
        RESTORED.aggregate(),
        MeasurementAggregate::from_parts(2, 9, Some(9), false, false).unwrap()
    );
}

#[test]
fn empty_and_measured_zero_are_distinct() {
    let mut summary = MeasurementSummary::EMPTY;
    assert_eq!(summary, MeasurementSummary::default());
    assert_eq!(summary.aggregate().samples(), 0);
    assert_eq!(summary.aggregate().total(), 0);
    assert_eq!(summary.latest(), None);
    assert_eq!(summary.aggregate().maximum(), None);

    summary.record(0);
    assert_eq!(summary.aggregate().samples(), 1);
    assert_eq!(summary.aggregate().total(), 0);
    assert_eq!(summary.latest(), Some(0));
    assert_eq!(summary.aggregate().maximum(), Some(0));
}

#[test]
fn latest_and_maximum_follow_individual_observations() {
    let mut summary = MeasurementSummary::EMPTY;
    for value in [7, 12, 3, 0] {
        summary.record(value);
    }
    assert_eq!(summary.aggregate().samples(), 4);
    assert_eq!(summary.aggregate().total(), 22);
    assert_eq!(summary.latest(), Some(0));
    assert_eq!(summary.aggregate().maximum(), Some(12));
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
    assert_eq!(summary.aggregate().total(), u128::MAX);
    assert!(!summary.aggregate().total_overflowed());
    summary.record(1);
    summary.record(2);
    assert_eq!(summary.aggregate().samples(), u64::MAX);
    assert_eq!(summary.aggregate().total(), u128::MAX);
    assert!(summary.aggregate().samples_overflowed());
    assert!(summary.aggregate().total_overflowed());
    assert_eq!(summary.latest(), Some(2));
    assert_eq!(summary.aggregate().maximum(), Some(u64::MAX));
}

#[test]
fn count_overflow_does_not_freeze_other_observations() {
    let mut summary = MeasurementSummary::from_parts(maximum_zero_count(), Some(0)).unwrap();
    summary.record(4);
    assert_eq!(summary.aggregate().samples(), u64::MAX);
    assert_eq!(summary.aggregate().total(), 4);
    assert_eq!(summary.latest(), Some(4));
    assert_eq!(summary.aggregate().maximum(), Some(4));
}

fn maximum_zero_count() -> MeasurementAggregate {
    MeasurementAggregate::from_parts(u64::MAX, 0, Some(0), false, false).unwrap()
}
