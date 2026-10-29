use crate::{MeasurementAggregate as Aggregate, MeasurementStateError as Error};

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
    assert!(wide.total_overflowed());
    assert_eq!(
        Aggregate::from_parts(1, u128::MAX, Some(u64::MAX), false, true),
        Err(Error::InvalidOverflowFlag)
    );
}
