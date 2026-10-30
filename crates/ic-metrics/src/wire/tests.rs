extern crate std;
use super::*;
use ic_wire::{Limits, native};

mod shapes;

const fn limits() -> Limits {
    Limits {
        bytes: 1024,
        allocation: 65536,
        nodes: 128,
        depth: 16,
    }
}

#[derive(Serialize, Deserialize, ic_wire::Wire, Debug, PartialEq)]
struct OwnerReport {
    instructions: MeasurementAggregate,
    movements: MeasurementCounter,
}

#[test]
fn reports_preserve_empty_zero_exact_caps_and_actual_loss() {
    for aggregate in [
        MeasurementAggregate::EMPTY,
        MeasurementAggregate::from_parts(1, 0, Some(0), false, false).unwrap(),
        MeasurementAggregate::from_parts(
            u64::MAX,
            u128::from(u64::MAX).pow(2),
            Some(u64::MAX),
            false,
            false,
        )
        .unwrap(),
        MeasurementAggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap(),
    ] {
        for lost in [false, true] {
            let report = OwnerReport {
                instructions: aggregate,
                movements: MeasurementCounter::from_parts(u128::MAX, lost).unwrap(),
            };
            let bytes = native::encode(&report, limits()).unwrap();
            assert_eq!(native::decode::<OwnerReport>(&bytes, limits()), Ok(report));
            assert_eq!(
                native::decode::<OwnerReport>(
                    &bytes,
                    Limits {
                        nodes: 1,
                        ..limits()
                    }
                ),
                Err(ic_wire::Error::Limit)
            );
        }
    }
}

#[test]
fn malformed_fields_cannot_bypass_numeric_admission() {
    for fields in [
        AggregateFields {
            samples: 0,
            total: 1,
            maximum: None,
            samples_overflowed: false,
            total_overflowed: false,
        },
        AggregateFields {
            samples: 1,
            total: 2,
            maximum: Some(1),
            samples_overflowed: false,
            total_overflowed: false,
        },
        AggregateFields {
            samples: 1,
            total: 1,
            maximum: None,
            samples_overflowed: false,
            total_overflowed: false,
        },
        AggregateFields {
            samples: 1,
            total: 1,
            maximum: Some(1),
            samples_overflowed: true,
            total_overflowed: false,
        },
    ] {
        let bytes = native::encode(&fields, limits()).unwrap();
        assert_eq!(
            native::decode::<MeasurementAggregate>(&bytes, limits()),
            Err(ic_wire::Error::Malformed)
        );
    }
    let bytes = native::encode(
        &CounterFields {
            total: 1,
            total_overflowed: true,
        },
        limits(),
    )
    .unwrap();
    assert_eq!(
        native::decode::<MeasurementCounter>(&bytes, limits()),
        Err(ic_wire::Error::Malformed)
    );
}

#[test]
fn browser_metadata_matches_serialized_records() {
    use ic_wire::__private::serde_json::json;
    use ic_wire::typescript::{generate_payload_registry, native_schema};
    use std::collections::BTreeMap;
    let schema = native_schema::<OwnerReport>().unwrap();
    assert_eq!(
        native_schema::<MeasurementAggregate>().unwrap(),
        native_schema::<AggregateFields>().unwrap()
    );
    assert_eq!(
        native_schema::<MeasurementCounter>().unwrap(),
        native_schema::<CounterFields>().unwrap()
    );
    let payload =
        json!({"name":"OwnerReportCodec", "schema":schema, "bytes":1024,"nodes":128,"depth":16});
    let generated = generate_payload_registry(
        &BTreeMap::new(),
        &[payload],
        "./wire-runtime.js",
        &BTreeMap::new(),
        |_| {},
    )
    .unwrap();
    assert!(generated.contains("bigint"));
    assert!(generated.contains("maximum"));
}
