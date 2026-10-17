use super::{CheckedMeasurementAggregate, MeasurementRecordError};

#[test]
fn empty_zero_and_wide_observations_keep_exact_totals_and_extrema() {
    let mut values = CheckedMeasurementAggregate::EMPTY;
    assert_eq!(values, CheckedMeasurementAggregate::default());
    assert_eq!(values.samples(), 0);
    assert_eq!(values.total(), 0);
    assert_eq!(values.minimum(), None);
    assert_eq!(values.maximum(), None);
    values.try_record(0).unwrap();
    assert_eq!(values.minimum(), Some(0));
    assert_eq!(values.maximum(), Some(0));
    let wide = u128::from(u64::MAX) + 1;
    values.try_record(wide).unwrap();
    values.try_record(7).unwrap();
    assert_eq!(values.samples(), 3);
    assert_eq!(values.total(), wide + 7);
    assert_eq!(values.minimum(), Some(0));
    assert_eq!(values.maximum(), Some(wide));
}

#[test]
fn total_overflow_preserves_every_field_and_exact_cap_can_accept_zero() {
    let mut values = CheckedMeasurementAggregate::EMPTY;
    values.try_record(u128::MAX).unwrap();
    let before = values;
    assert_eq!(values.try_record(1), Err(MeasurementRecordError::Total));
    assert_eq!(values, before);
    values.try_record(0).unwrap();
    assert_eq!(values.samples(), 2);
    assert_eq!(values.total(), u128::MAX);
    assert_eq!(values.minimum(), Some(0));
    assert_eq!(values.maximum(), Some(u128::MAX));
}

#[test]
fn count_overflow_precedes_total_overflow_without_changing_state() {
    let mut values = CheckedMeasurementAggregate {
        samples: u64::MAX,
        total: u128::MAX,
        minimum: 0,
        maximum: u128::MAX,
    };
    let before = values;
    for value in [0, 1, u128::MAX] {
        assert_eq!(
            values.try_record(value),
            Err(MeasurementRecordError::Samples)
        );
        assert_eq!(values, before);
    }
}

#[test]
fn recording_order_does_not_change_exact_summary() {
    let mut forward = CheckedMeasurementAggregate::EMPTY;
    let mut reverse = CheckedMeasurementAggregate::EMPTY;
    for value in [9, 4, 12, 0] {
        forward.try_record(value).unwrap();
    }
    for value in [0, 12, 4, 9] {
        reverse.try_record(value).unwrap();
    }
    assert_eq!(forward, reverse);
    assert_eq!(forward.total(), 25);
}
