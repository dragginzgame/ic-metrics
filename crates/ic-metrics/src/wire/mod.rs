//! Standard numeric transport. Consumers own report composition and codec limits.

use crate::{MeasurementAggregate, MeasurementCounter};
use serde::{Deserialize, Deserializer, Serialize, Serializer};

// The serialized fields are independent of private arithmetic layout. In
// particular, empty maxima use Option and every decoded value passes admission.
#[derive(Serialize, Deserialize)]
#[cfg_attr(not(target_family = "wasm"), derive(ic_wire::Wire))]
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
#[cfg_attr(not(target_family = "wasm"), derive(ic_wire::Wire))]
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

// Metadata follows the exact private Serde records, never the arithmetic fields.
// The records are fixed-size scalars; this adds no unbounded decoding work.
#[cfg(not(target_family = "wasm"))]
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
#[cfg(not(target_family = "wasm"))]
metadata!(MeasurementAggregate, AggregateFields);
#[cfg(not(target_family = "wasm"))]
metadata!(MeasurementCounter, CounterFields);

#[cfg(all(test, not(target_family = "wasm")))]
mod tests;
