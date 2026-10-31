//! Qualification consumer of published Wire/Types and the current Metrics source.

use ic_metrics::{
    MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary,
};
use ic_platform_types::{Account, Principal, Subaccount};
use serde::{Deserialize, Serialize};

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[cfg_attr(not(target_family = "wasm"), derive(ic_wire::Wire))]
pub struct IdentityReport {
    pub principal: Principal,
    pub account: Account,
    pub aggregate: MeasurementAggregate,
    pub counter: MeasurementCounter,
    pub summary: MeasurementSummary,
    pub histogram: MeasurementHistogram<2>,
}

pub fn report(subaccount: Option<Subaccount>) -> IdentityReport {
    let principal = Principal::anonymous();
    let mut aggregate = MeasurementAggregate::EMPTY;
    aggregate.record(u64::MAX);
    aggregate.record(0);
    let mut summary = MeasurementSummary::EMPTY;
    summary.record(u64::MAX);
    let mut histogram = MeasurementHistogram::new([0, 10]).unwrap();
    histogram.record(0);
    histogram.record(11);
    IdentityReport {
        principal,
        account: Account {
            owner: principal,
            subaccount,
        },
        aggregate,
        counter: MeasurementCounter::from_parts(u128::MAX, false).unwrap(),
        summary,
        histogram,
    }
}

#[cfg(all(test, not(target_family = "wasm")))]
mod tests {
    use super::*;
    use ic_wire::{Limits, native, typescript::native_schema};
    use serde_json::json;

    const LIMITS: Limits = Limits {
        bytes: 4096,
        allocation: 65536,
        nodes: 2048,
        depth: 16,
    };

    #[test]
    fn canonical_principal_and_account_compose_with_metrics_schemas() {
        let principal = native_schema::<Principal>().unwrap();
        assert_eq!(principal, native_schema::<ic_wire::Bytes<29>>().unwrap());
        let account = native_schema::<Account>().unwrap();
        let _: ic_platform::Principal = Principal::anonymous();
        let _: ic_platform::Account = Account::from(Principal::anonymous());
        assert_eq!(
            native_schema::<ic_platform::Principal>().unwrap(),
            principal
        );
        assert_eq!(native_schema::<ic_platform::Account>().unwrap(), account);
        assert_eq!(
            account,
            json!({
                "k": "record", "fields": [
                    {"name": "owner", "value": principal},
                    {"name": "subaccount", "value": native_schema::<Option<Subaccount>>().unwrap()}
                ]
            })
        );
        let schema = native_schema::<IdentityReport>().unwrap();
        for (index, (name, expected)) in [
            ("principal", principal),
            ("account", account),
            (
                "aggregate",
                native_schema::<MeasurementAggregate>().unwrap(),
            ),
            ("counter", native_schema::<MeasurementCounter>().unwrap()),
            ("summary", native_schema::<MeasurementSummary>().unwrap()),
            (
                "histogram",
                native_schema::<MeasurementHistogram<2>>().unwrap(),
            ),
        ]
        .into_iter()
        .enumerate()
        {
            assert_eq!(schema["fields"][index]["name"], name);
            assert_eq!(schema["fields"][index]["value"], expected);
        }
    }

    #[test]
    fn identity_bytes_preserve_absent_and_explicit_zero_subaccounts() {
        let principal = Principal::anonymous();
        assert_eq!(native::encode(&principal, LIMITS).unwrap(), [1, 4]);
        let absent = Account {
            owner: principal,
            subaccount: None,
        };
        let explicit = Account {
            owner: principal,
            subaccount: Some([0; 32]),
        };
        assert_eq!(native::encode(&absent, LIMITS).unwrap(), [1, 4, 0]);
        let mut explicit_bytes = vec![1, 4, 1];
        explicit_bytes.extend_from_slice(&[0; 32]);
        assert_eq!(native::encode(&explicit, LIMITS).unwrap(), explicit_bytes);
        // Account equality intentionally normalizes None/zero; compare the field.
        assert_eq!(
            native::decode::<Account>(&[1, 4, 0], LIMITS)
                .unwrap()
                .subaccount,
            None
        );
        assert_eq!(
            native::decode::<Account>(&explicit_bytes, LIMITS)
                .unwrap()
                .subaccount,
            Some([0; 32])
        );
    }

    #[test]
    fn composed_reports_round_trip_and_keep_typed_refusals() {
        for subaccount in [None, Some([0; 32]), Some([7; 32])] {
            let expected = report(subaccount);
            let bytes = native::encode(&expected, LIMITS).unwrap();
            let decoded = native::decode::<IdentityReport>(&bytes, LIMITS).unwrap();
            assert_eq!(decoded.account.subaccount, subaccount);
            assert_eq!(decoded, expected);
            assert_eq!(
                native::decode::<IdentityReport>(&bytes, Limits { nodes: 1, ..LIMITS }),
                Err(ic_wire::Error::Limit)
            );
            assert_eq!(
                native::decode::<IdentityReport>(&bytes[..bytes.len() - 1], LIMITS),
                Err(ic_wire::Error::Malformed)
            );
        }
        let mut oversized = vec![30];
        oversized.extend_from_slice(&[0; 30]);
        assert_eq!(
            native::decode::<Principal>(&oversized, LIMITS),
            Err(ic_wire::Error::Malformed)
        );
    }
}
