use crate::MeasurementAggregate;

use super::{MeasurementMeanError, MeasurementSummary, checked_mean, record_sample};

#[test]
fn checked_mean_preserves_empty_zero_and_floor_division() {
    for (samples, total, expected) in [
        (0, 0, None),
        (1, 0, Some(0)),
        (7, 0, Some(0)),
        (2, 9, Some(4)),
        (2, u128::from(u64::MAX), Some(u128::from(u64::MAX) / 2)),
        (2, u128::from(u64::MAX) + 1, Some(1_u128 << 63)),
        (2, u128::MAX - 1, Some((u128::MAX - 1) / 2)),
        (4, 3, Some(0)),
        (1, u128::MAX - 1, Some(u128::MAX - 1)),
        (u64::MAX - 1, u128::from(u64::MAX) - 1, Some(1)),
    ] {
        assert_eq!(checked_mean(samples, total), Ok(expected));
    }
}

#[test]
fn checked_mean_rejects_inconsistent_and_saturated_fields() {
    use MeasurementMeanError::{SaturatedSamples, SaturatedTotal, TotalWithoutSamples};
    for (samples, total, error) in [
        (0, 1, TotalWithoutSamples),
        (0, u128::MAX, TotalWithoutSamples),
        (u64::MAX, 0, SaturatedSamples),
        (u64::MAX, 9, SaturatedSamples),
        (1, u128::MAX, SaturatedTotal),
        (u64::MAX, u128::MAX, SaturatedSamples),
    ] {
        assert_eq!(checked_mean(samples, total), Err(error));
    }
}

#[test]
fn summary_mean_preserves_recording_and_saturation_contracts() {
    let mut summary = MeasurementSummary::EMPTY;
    assert_eq!(summary.mean(), Ok(None));
    summary.record(0);
    assert_eq!(summary.mean(), Ok(Some(0)));
    summary.record(9);
    assert_eq!(summary.mean(), Ok(Some(4)));
    summary.record(u64::MAX - 9);
    assert_eq!(summary.total(), u128::from(u64::MAX));
    assert_eq!(summary.mean(), Ok(Some(u128::from(u64::MAX) / 3)));
    assert!(!summary.aggregate().total_saturated());
    summary.record(1);
    assert_eq!(summary.mean(), Ok(Some((u128::from(u64::MAX) + 1) / 4)));
    assert!(!summary.aggregate().total_saturated());
    assert_eq!(summary.latest(), Some(1));
    let mut saturated_count = MeasurementSummary {
        aggregate: maximum_zero_count(),
        latest: 0,
    };
    assert_eq!(saturated_count.mean(), Ok(Some(0)));
    saturated_count.record(9);
    assert_eq!(
        saturated_count.mean(),
        Err(MeasurementMeanError::SaturatedSamples)
    );
}

#[test]
fn checked_mean_is_available_in_constant_evaluation() {
    const RAW: Result<Option<u128>, MeasurementMeanError> = checked_mean(2, 9);
    const WIDE: Result<Option<u128>, MeasurementMeanError> =
        checked_mean(2, 2 * (u64::MAX as u128));
    const EMPTY: Result<Option<u128>, MeasurementMeanError> = checked_mean(0, 0);
    const INVALID: Result<Option<u128>, MeasurementMeanError> = checked_mean(0, 1);
    const SATURATED: Result<Option<u128>, MeasurementMeanError> = checked_mean(1, u128::MAX);
    const SUMMARY: Result<Option<u128>, MeasurementMeanError> = {
        let mut summary = MeasurementSummary::EMPTY;
        summary.record(9);
        summary.record(0);
        summary.mean()
    };
    assert_eq!(RAW, Ok(Some(4)));
    assert_eq!(WIDE, Ok(Some(u128::from(u64::MAX))));
    assert_eq!(EMPTY, Ok(None));
    assert_eq!(INVALID, Err(MeasurementMeanError::TotalWithoutSamples));
    assert_eq!(SATURATED, Err(MeasurementMeanError::SaturatedTotal));
    assert_eq!(SUMMARY, RAW);
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
fn total_saturation_preserves_count_latest_and_maximum() {
    let mut aggregate = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        aggregate.merge(aggregate);
        aggregate.record(u64::MAX);
    }
    aggregate.record(u64::MAX);
    aggregate.record(u64::MAX);
    let mut summary = MeasurementSummary {
        aggregate,
        latest: u64::MAX,
    };
    assert_eq!(summary.total(), u128::MAX);
    assert!(!summary.aggregate().total_saturated());
    summary.record(1);
    summary.record(2);
    assert_eq!(summary.samples(), u64::MAX);
    assert_eq!(summary.total(), u128::MAX);
    assert!(summary.aggregate().samples_saturated());
    assert!(summary.aggregate().total_saturated());
    assert_eq!(summary.latest(), Some(2));
    assert_eq!(summary.maximum(), Some(u64::MAX));
}

#[test]
fn count_saturation_does_not_freeze_other_observations() {
    let mut summary = MeasurementSummary {
        aggregate: maximum_zero_count(),
        latest: 0,
    };
    summary.record(4);
    assert_eq!(summary.samples(), u64::MAX);
    assert_eq!(summary.total(), 4);
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
    total = 0;
    record_sample(&mut samples, &mut total, u64::MAX);
    record_sample(&mut samples, &mut total, u64::MAX);
    assert_eq!(total, 2 * u128::from(u64::MAX));
    assert_eq!(checked_mean(samples, total), Ok(Some(u128::from(u64::MAX))));

    samples = 0;
    total = u128::MAX - 1;
    record_sample(&mut samples, &mut total, 1);
    assert_eq!((samples, total), (1, u128::MAX));
    record_sample(&mut samples, &mut total, 1);
    assert_eq!((samples, total), (2, u128::MAX));
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

// Repeated disjoint zero-sample batches construct an exact cap without a fake
// production path or an impractically large recording loop.
fn maximum_zero_count() -> MeasurementAggregate {
    let mut aggregate = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        aggregate.merge(aggregate);
        aggregate.record(0);
    }
    aggregate
}
