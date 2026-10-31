//! Serde admission independent of the optional native metadata dependency.

extern crate std;

use super::*;
use std::{fmt::Debug, vec::Vec};

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[cfg_attr(
    all(feature = "native-wire", not(target_family = "wasm")),
    derive(ic_wire::Wire)
)]
pub(super) struct Report {
    aggregate: MeasurementAggregate,
    counter: MeasurementCounter,
    summary: MeasurementSummary,
    histogram: MeasurementHistogram<37>,
}

// Shared Rust fixtures for Serde and generated-codec conformance. The JavaScript
// consumer declares its expected values separately, without decoding JSON numbers.
pub(super) fn reports() -> Vec<(&'static str, Report)> {
    [
        ("empty", 0, 0, None, false),
        ("zero", 1, 0, Some(0), false),
        ("wide", 2, 2 * u128::from(u64::MAX), Some(u64::MAX), false),
        (
            "cap",
            u64::MAX,
            u128::from(u64::MAX).pow(2),
            Some(u64::MAX),
            false,
        ),
        ("lost", u64::MAX, u128::MAX, Some(u64::MAX), true),
    ]
    .into_iter()
    .map(|(name, samples, total, maximum, lost)| {
        let aggregate =
            MeasurementAggregate::from_parts(samples, total, maximum, lost, lost).unwrap();
        let mut counts = [0; 37];
        let overflow = if name == "zero" {
            counts[0] = 1;
            0
        } else {
            samples
        };
        let report = Report {
            aggregate,
            counter: MeasurementCounter::from_parts(if samples > 1 { u128::MAX } else { 0 }, lost)
                .unwrap(),
            summary: MeasurementSummary::from_parts(aggregate, maximum).unwrap(),
            histogram: MeasurementHistogram::from_parts(
                core::array::from_fn(|index| index as u64),
                counts,
                overflow,
                [false; 37],
                lost,
                aggregate,
            )
            .unwrap(),
        };
        (name, report)
    })
    .collect()
}

fn round_trip<T: Serialize + serde::de::DeserializeOwned + Debug + PartialEq>(value: &T) {
    // Text serialization preserves u128 exactly; a serde_json::Value intermediary
    // would narrow these numbers without the arbitrary_precision feature.
    let json = serde_json::to_string(value).unwrap();
    assert_eq!(serde_json::from_str::<T>(&json).unwrap(), *value);
}

#[test]
fn serde_preserves_empty_zero_wide_caps_and_loss_without_metadata() {
    for (_, report) in reports() {
        round_trip(&report);
    }
}

fn histogram_round_trip<const N: usize>(bounds: [u64; N]) {
    let mut histogram = MeasurementHistogram::new(bounds).unwrap();
    for sample in [0, 1, 10, 100, u64::MAX] {
        histogram.record(sample);
    }
    round_trip(&histogram);
}

#[test]
fn serde_arrays_keep_zero_small_and_large_const_bounds() {
    histogram_round_trip([]);
    histogram_round_trip([0, 10, u64::MAX]);
    histogram_round_trip(core::array::from_fn::<_, 37, _>(|index| index as u64));
    for json in ["[1]", "[1,2,3]"] {
        assert!(
            serde_json::from_str::<FixedArray<u64, 2>>(json)
                .err()
                .unwrap()
                .is_data()
        );
    }
    let mut fields = serde_json::to_value(MeasurementHistogram::new([10, 20]).unwrap()).unwrap();
    fields["bucket_counts"] = serde_json::json!([0]);
    assert!(
        serde_json::from_value::<MeasurementHistogram<2>>(fields)
            .unwrap_err()
            .is_data()
    );
}

fn rejects<S: Serialize, T: serde::de::DeserializeOwned>(fields: &S) {
    let json = serde_json::to_string(fields).unwrap();
    let error = serde_json::from_str::<T>(&json)
        .err()
        .expect("invalid state must refuse");
    assert!(error.is_data());
}

#[test]
fn serde_decode_requires_canonical_numeric_admission() {
    rejects::<_, MeasurementAggregate>(&AggregateFields {
        samples: 1,
        total: 2,
        maximum: Some(1),
        samples_overflowed: false,
        total_overflowed: false,
    });
    rejects::<_, MeasurementCounter>(&CounterFields {
        total: 1,
        total_overflowed: true,
    });
    let aggregate = MeasurementAggregate::from_parts(1, 5, Some(5), false, false).unwrap();
    rejects::<_, MeasurementSummary>(&SummaryFields {
        aggregate,
        latest: Some(6),
    });
    rejects::<_, MeasurementHistogram<2>>(&HistogramFields {
        upper_bounds: FixedArray([10, 20]),
        bucket_counts: FixedArray([0, 1]),
        overflow: 0,
        bucket_overflowed: FixedArray([false; 2]),
        overflow_count_overflowed: false,
        aggregate,
    });
}

#[test]
fn serde_rejects_missing_and_unknown_record_fields() {
    for json in [
        r#"{"total":0}"#,
        r#"{"total":0,"total_overflowed":false,"other":0}"#,
    ] {
        assert!(
            serde_json::from_str::<MeasurementCounter>(json)
                .unwrap_err()
                .is_data()
        );
    }
}
