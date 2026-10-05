use super::{MeasurementSummary, record_sample};

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
fn total_saturation_preserves_count_latest_and_maximum() {
    let mut summary = MeasurementSummary::EMPTY;
    summary.record(u64::MAX);
    assert_eq!(summary.total(), u64::MAX);
    summary.record(1);
    summary.record(2);
    assert_eq!(summary.samples(), 3);
    assert_eq!(summary.total(), u64::MAX);
    assert_eq!(summary.latest(), Some(2));
    assert_eq!(summary.maximum(), Some(u64::MAX));
}

#[test]
fn count_saturation_does_not_freeze_other_observations() {
    let mut summary = MeasurementSummary {
        samples: u64::MAX,
        total: 3,
        latest: 3,
        maximum: 3,
    };
    summary.record(4);
    assert_eq!(summary.samples(), u64::MAX);
    assert_eq!(summary.total(), 7);
    assert_eq!(summary.latest(), Some(4));
    assert_eq!(summary.maximum(), Some(4));
}

#[test]
fn consumer_owned_count_and_total_saturate_independently() {
    let mut samples = u64::MAX - 1;
    let mut total = 4;
    record_sample(&mut samples, &mut total, 0);
    assert_eq!((samples, total), (u64::MAX, 4));
    record_sample(&mut samples, &mut total, 6);
    assert_eq!((samples, total), (u64::MAX, 10));

    samples = 0;
    total = u64::MAX - 1;
    record_sample(&mut samples, &mut total, 1);
    assert_eq!((samples, total), (1, u64::MAX));
    record_sample(&mut samples, &mut total, 1);
    assert_eq!((samples, total), (2, u64::MAX));
}

#[test]
fn recording_is_available_in_constant_evaluation() {
    const SUMMARY: MeasurementSummary = {
        let mut summary = MeasurementSummary::EMPTY;
        summary.record(9);
        summary.record(2);
        summary
    };
    assert_eq!(SUMMARY.samples(), 2);
    assert_eq!(SUMMARY.total(), 11);
    assert_eq!(SUMMARY.latest(), Some(2));
    assert_eq!(SUMMARY.maximum(), Some(9));
}
