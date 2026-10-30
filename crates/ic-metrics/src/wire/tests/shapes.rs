//! Public summary/distribution transport, with independent malformed field inputs.

use super::*;
use ic_wire::{
    __private::serde_json::{self, json},
    typescript::native_schema,
};

const fn shape_limits() -> Limits {
    Limits {
        bytes: 4096,
        allocation: 65536,
        nodes: 2048,
        depth: 16,
    }
}

#[test]
fn summaries_preserve_order_empty_zero_caps_and_actual_loss() {
    let mut zero = MeasurementSummary::EMPTY;
    zero.record(0);
    let mut ordered = MeasurementSummary::EMPTY;
    ordered.record(9);
    ordered.record(2);
    let lost = MeasurementSummary::from_parts(
        MeasurementAggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap(),
        Some(1),
    )
    .unwrap();
    for summary in [MeasurementSummary::EMPTY, zero, ordered, lost] {
        let bytes = native::encode(&summary, shape_limits()).unwrap();
        assert_eq!(
            native::decode::<MeasurementSummary>(&bytes, shape_limits()),
            Ok(summary)
        );
    }
    assert_eq!(
        native_schema::<MeasurementSummary>().unwrap(),
        native_schema::<SummaryFields>().unwrap()
    );
    let invalid = SummaryFields {
        aggregate: ordered.aggregate(),
        latest: Some(10),
    };
    let bytes = native::encode(&invalid, shape_limits()).unwrap();
    assert_eq!(
        native::decode::<MeasurementSummary>(&bytes, shape_limits()),
        Err(ic_wire::Error::Malformed)
    );
    let invalid = SummaryFields {
        aggregate: MeasurementAggregate::EMPTY,
        latest: Some(0),
    };
    let bytes = native::encode(&invalid, shape_limits()).unwrap();
    assert_eq!(
        native::decode::<MeasurementSummary>(&bytes, shape_limits()),
        Err(ic_wire::Error::Malformed)
    );
}

fn histogram_round_trip<const N: usize>(bounds: [u64; N]) {
    let mut histogram = MeasurementHistogram::new(bounds).unwrap();
    for sample in [0, 1, 10, 100, u64::MAX] {
        histogram.record(sample);
    }
    let bytes = native::encode(&histogram, shape_limits()).unwrap();
    assert_eq!(
        native::decode::<MeasurementHistogram<N>>(&bytes, shape_limits()),
        Ok(histogram)
    );
    assert_eq!(
        native_schema::<MeasurementHistogram<N>>().unwrap(),
        native_schema::<HistogramFields<N>>().unwrap()
    );
    assert_eq!(
        native::decode::<MeasurementHistogram<N>>(
            &bytes,
            Limits {
                nodes: 1,
                ..shape_limits()
            }
        ),
        Err(ic_wire::Error::Limit)
    );
    let json = serde_json::to_string(&histogram).unwrap();
    assert_eq!(
        serde_json::from_str::<MeasurementHistogram<N>>(&json).unwrap(),
        histogram
    );
}

#[test]
fn histograms_transport_zero_and_large_const_bounds_without_dynamic_arrays() {
    histogram_round_trip([]);
    histogram_round_trip([0, 10, u64::MAX]);
    histogram_round_trip(core::array::from_fn::<_, 37, _>(|index| index as u64));
    // Small fixed-array metadata/bytes must agree with the canonical Wire type.
    assert_eq!(
        native_schema::<FixedArray<u64, 3>>().unwrap(),
        native_schema::<[u64; 3]>().unwrap()
    );
    assert_eq!(
        native::encode(&FixedArray([1_u64, 2, 3]), shape_limits()).unwrap(),
        native::encode(&[1_u64, 2, 3], shape_limits()).unwrap()
    );
}

#[test]
fn histogram_overflow_quality_survives_transport() {
    let mut histogram = MeasurementHistogram::new([0]).unwrap();
    histogram.record(u64::MAX);
    for _ in 0..128 {
        let copy = histogram;
        histogram.merge(&copy).unwrap();
    }
    assert!(histogram.aggregate().total_overflowed());
    assert!(histogram.overflow_count_overflowed());
    let bytes = native::encode(&histogram, shape_limits()).unwrap();
    assert_eq!(
        native::decode::<MeasurementHistogram<1>>(&bytes, shape_limits()),
        Ok(histogram)
    );
}

#[test]
fn malformed_distribution_fields_cannot_bypass_canonical_admission() {
    for (bounds, counts, lost, aggregate) in [
        ([10, 10], [0, 0], [false; 2], MeasurementAggregate::EMPTY),
        ([10, 20], [1, 0], [false; 2], MeasurementAggregate::EMPTY),
        (
            [10, 20],
            [1, 0],
            [true, false],
            MeasurementAggregate::from_parts(1, 5, Some(5), false, false).unwrap(),
        ),
        (
            [10, 20],
            [1, 0],
            [false; 2],
            MeasurementAggregate::from_parts(1, 11, Some(11), false, false).unwrap(),
        ),
    ] {
        let fields = HistogramFields {
            upper_bounds: FixedArray(bounds),
            bucket_counts: FixedArray(counts),
            overflow: 0,
            bucket_overflowed: FixedArray(lost),
            overflow_count_overflowed: false,
            aggregate,
        };
        let bytes = native::encode(&fields, shape_limits()).unwrap();
        assert_eq!(
            native::decode::<MeasurementHistogram<2>>(&bytes, shape_limits()),
            Err(ic_wire::Error::Malformed)
        );
    }
    for values in [json!([1]), json!([1, 2, 3])] {
        assert!(serde_json::from_value::<FixedArray<u64, 2>>(values).is_err());
    }
    let mut json = serde_json::to_value(MeasurementHistogram::new([10, 20]).unwrap()).unwrap();
    json["bucket_counts"] = json!([0]);
    assert!(serde_json::from_value::<MeasurementHistogram<2>>(json).is_err());
}

#[derive(Serialize, Deserialize, ic_wire::Wire, Debug, PartialEq)]
struct DistributionReport {
    summary: MeasurementSummary,
    histogram: MeasurementHistogram<37>,
}

#[test]
fn browser_metadata_generates_for_composed_summary_and_distribution_reports() {
    use ic_wire::typescript::generate_payload_registry;
    use std::collections::BTreeMap;
    let report = DistributionReport {
        summary: MeasurementSummary::EMPTY,
        histogram: MeasurementHistogram::new(core::array::from_fn(|index| index as u64)).unwrap(),
    };
    let bytes = native::encode(&report, shape_limits()).unwrap();
    assert_eq!(
        native::decode::<DistributionReport>(&bytes, shape_limits()),
        Ok(report)
    );
    let schema = native_schema::<DistributionReport>().unwrap();
    let payload = json!({"name":"DistributionReportCodec", "schema":schema, "bytes":4096, "nodes":2048, "depth":16});
    let generated = generate_payload_registry(
        &BTreeMap::new(),
        &[payload],
        "./wire-runtime.js",
        &BTreeMap::new(),
        |_| {},
    )
    .unwrap();
    assert!(generated.contains("bigint"));
    assert!(generated.contains("bucket_overflowed"));
}
