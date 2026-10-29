use crate::{
    MeasurementAggregate as Aggregate, MeasurementStateError as Error,
    MeasurementSummary as Summary,
};

#[test]
fn summary_restoration_rejects_totals_incompatible_with_latest() {
    let aggregate = Aggregate::from_parts(2, 20, Some(10), false, false).unwrap();
    assert_eq!(
        Summary::from_parts(aggregate, Some(0)),
        Err(Error::InvalidLatest)
    );
    let aggregate = Aggregate::from_parts(2, 10, Some(10), false, false).unwrap();
    assert_eq!(
        Summary::from_parts(aggregate, Some(0)).unwrap().latest(),
        Some(0)
    );

    let maximum = u128::from(u64::MAX);
    let full =
        Aggregate::from_parts(u64::MAX, maximum * maximum, Some(u64::MAX), false, false).unwrap();
    assert_eq!(
        Summary::from_parts(full, Some(u64::MAX - 1)),
        Err(Error::InvalidLatest)
    );
    let boundary = Aggregate::from_parts(
        u64::MAX,
        maximum * maximum - 1,
        Some(u64::MAX),
        false,
        false,
    )
    .unwrap();
    assert!(Summary::from_parts(boundary, Some(u64::MAX - 1)).is_ok());

    // After count overflow, the clipped count cannot bound the actual total.
    let mut summary = Summary::from_parts(full, Some(u64::MAX)).unwrap();
    summary.record(u64::MAX - 1);
    assert!(summary.aggregate().samples_overflowed());
    assert_eq!(
        Summary::from_parts(summary.aggregate(), summary.latest()),
        Ok(summary)
    );
}

#[test]
fn summary_restoration_matches_bounded_observation_sequences() {
    for samples in 1_u32..=4 {
        for maximum in 0_u64..=3 {
            for total in 0..=u128::from(samples) * 3 {
                let Ok(aggregate) =
                    Aggregate::from_parts(u64::from(samples), total, Some(maximum), false, false)
                else {
                    continue;
                };
                for latest in 0..=maximum {
                    let mut represented = false;
                    // Enumerate actual sequences, independently of admission formulas.
                    for mut sequence in 0..4_u64.pow(samples) {
                        let mut summary = Summary::EMPTY;
                        for _ in 0..samples {
                            summary.record(sequence % 4);
                            sequence /= 4;
                        }
                        if summary.aggregate() == aggregate && summary.latest() == Some(latest) {
                            represented = true;
                            break;
                        }
                    }
                    assert_eq!(
                        Summary::from_parts(aggregate, Some(latest)).is_ok(),
                        represented,
                        "samples={samples}, total={total}, maximum={maximum}, latest={latest}"
                    );
                }
            }
        }
    }
}
