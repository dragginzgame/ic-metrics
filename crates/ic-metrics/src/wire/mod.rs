//! Standard numeric transport. Consumers own report composition and codec limits.

use crate::{MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary};
use serde::{Deserialize, Deserializer, Serialize, Serializer};

mod array;
use array::FixedArray;

// The serialized fields are independent of private arithmetic layout. In
// particular, empty maxima use Option and every decoded value passes admission.
#[derive(Serialize, Deserialize)]
#[cfg_attr(
    all(feature = "native-wire", not(target_family = "wasm")),
    derive(ic_wire::Wire)
)]
#[serde(deny_unknown_fields)]
struct AggregateFields {
    samples: u64,
    total: u128,
    maximum: Option<u64>,
    samples_overflowed: bool,
    total_overflowed: bool,
}

impl Serialize for MeasurementAggregate {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        AggregateFields {
            samples: self.samples(),
            total: self.total(),
            maximum: self.maximum(),
            samples_overflowed: self.samples_overflowed(),
            total_overflowed: self.total_overflowed(),
        }
        .serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for MeasurementAggregate {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let fields = AggregateFields::deserialize(deserializer)?;
        Self::from_parts(
            fields.samples,
            fields.total,
            fields.maximum,
            fields.samples_overflowed,
            fields.total_overflowed,
        )
        .map_err(serde::de::Error::custom)
    }
}

#[derive(Serialize, Deserialize)]
#[cfg_attr(
    all(feature = "native-wire", not(target_family = "wasm")),
    derive(ic_wire::Wire)
)]
#[serde(deny_unknown_fields)]
struct CounterFields {
    total: u128,
    total_overflowed: bool,
}

impl Serialize for MeasurementCounter {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        CounterFields {
            total: self.total(),
            total_overflowed: self.total_overflowed(),
        }
        .serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for MeasurementCounter {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let fields = CounterFields::deserialize(deserializer)?;
        Self::from_parts(fields.total, fields.total_overflowed).map_err(serde::de::Error::custom)
    }
}

#[derive(Serialize, Deserialize)]
#[cfg_attr(
    all(feature = "native-wire", not(target_family = "wasm")),
    derive(ic_wire::Wire)
)]
#[serde(deny_unknown_fields)]
struct SummaryFields {
    aggregate: MeasurementAggregate,
    latest: Option<u64>,
}

impl Serialize for MeasurementSummary {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        SummaryFields {
            aggregate: self.aggregate(),
            latest: self.latest(),
        }
        .serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for MeasurementSummary {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let fields = SummaryFields::deserialize(deserializer)?;
        Self::from_parts(fields.aggregate, fields.latest).map_err(serde::de::Error::custom)
    }
}

#[derive(Serialize, Deserialize)]
#[cfg_attr(
    all(feature = "native-wire", not(target_family = "wasm")),
    derive(ic_wire::Wire)
)]
#[serde(deny_unknown_fields)]
struct HistogramFields<const N: usize> {
    upper_bounds: FixedArray<u64, N>,
    bucket_counts: FixedArray<u64, N>,
    overflow: u64,
    bucket_overflowed: FixedArray<bool, N>,
    overflow_count_overflowed: bool,
    aggregate: MeasurementAggregate,
}

impl<const N: usize> Serialize for MeasurementHistogram<N> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        HistogramFields {
            upper_bounds: FixedArray(*self.upper_bounds()),
            bucket_counts: FixedArray(*self.bucket_counts()),
            overflow: self.overflow(),
            bucket_overflowed: FixedArray(*self.bucket_overflowed()),
            overflow_count_overflowed: self.overflow_count_overflowed(),
            aggregate: self.aggregate(),
        }
        .serialize(serializer)
    }
}

impl<'de, const N: usize> Deserialize<'de> for MeasurementHistogram<N> {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let fields = HistogramFields::deserialize(deserializer)?;
        Self::from_parts(
            fields.upper_bounds.0,
            fields.bucket_counts.0,
            fields.overflow,
            fields.bucket_overflowed.0,
            fields.overflow_count_overflowed,
            fields.aggregate,
        )
        .map_err(serde::de::Error::custom)
    }
}

#[cfg(all(feature = "native-wire", not(target_family = "wasm")))]
impl<const N: usize> ic_wire::typescript::Wire for MeasurementHistogram<N> {
    fn native_schema(
        context: &mut ic_wire::typescript::SchemaContext,
    ) -> Result<ic_wire::__private::serde_json::Value, ic_wire::typescript::GenerationError> {
        context.describe::<HistogramFields<N>>()
    }
}

// Metadata follows the exact private Serde records, never the arithmetic fields.
// The records are fixed-size scalars; this adds no unbounded decoding work.
#[cfg(all(feature = "native-wire", not(target_family = "wasm")))]
macro_rules! metadata {
    ($value:ty, $fields:ty) => {
        impl ic_wire::typescript::Wire for $value {
            fn native_schema(
                context: &mut ic_wire::typescript::SchemaContext,
            ) -> Result<ic_wire::__private::serde_json::Value, ic_wire::typescript::GenerationError>
            {
                context.describe::<$fields>()
            }
        }
    };
}
#[cfg(all(feature = "native-wire", not(target_family = "wasm")))]
metadata!(MeasurementAggregate, AggregateFields);
#[cfg(all(feature = "native-wire", not(target_family = "wasm")))]
metadata!(MeasurementCounter, CounterFields);
#[cfg(all(feature = "native-wire", not(target_family = "wasm")))]
metadata!(MeasurementSummary, SummaryFields);

#[cfg(all(test, feature = "native-wire", not(target_family = "wasm")))]
mod tests;
