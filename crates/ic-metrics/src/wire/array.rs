//! Fixed-size Serde arrays for every const bound, with no decoding allocation.

use core::{fmt, marker::PhantomData};
use serde::{
    Deserialize, Deserializer, Serialize, Serializer,
    de::{SeqAccess, Visitor},
    ser::SerializeTuple,
};

pub(super) struct FixedArray<T, const N: usize>(pub [T; N]);

impl<T: Serialize, const N: usize> Serialize for FixedArray<T, N> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        let mut tuple = serializer.serialize_tuple(N)?;
        for value in &self.0 {
            tuple.serialize_element(value)?;
        }
        tuple.end()
    }
}

impl<'de, T: Deserialize<'de> + Copy + Default, const N: usize> Deserialize<'de>
    for FixedArray<T, N>
{
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        struct ArrayVisitor<T, const N: usize>(PhantomData<T>);
        impl<'de, T: Deserialize<'de> + Copy + Default, const N: usize> Visitor<'de>
            for ArrayVisitor<T, N>
        {
            type Value = FixedArray<T, N>;

            fn expecting(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
                write!(formatter, "an array of exactly {N} elements")
            }

            fn visit_seq<A: SeqAccess<'de>>(
                self,
                mut sequence: A,
            ) -> Result<Self::Value, A::Error> {
                let mut values = [T::default(); N];
                for (index, value) in values.iter_mut().enumerate() {
                    *value = sequence
                        .next_element()?
                        .ok_or_else(|| serde::de::Error::invalid_length(index, &self))?;
                }
                if sequence.next_element::<serde::de::IgnoredAny>()?.is_some() {
                    return Err(serde::de::Error::invalid_length(N.saturating_add(1), &self));
                }
                Ok(FixedArray(values))
            }
        }
        deserializer.deserialize_tuple(N, ArrayVisitor(PhantomData))
    }
}

#[cfg(not(target_family = "wasm"))]
impl<T: ic_wire::typescript::Wire, const N: usize> ic_wire::typescript::Wire for FixedArray<T, N> {
    fn native_schema(
        context: &mut ic_wire::typescript::SchemaContext,
    ) -> Result<ic_wire::__private::serde_json::Value, ic_wire::typescript::GenerationError> {
        // Same tuple encoding/schema as Wire's built-in [T; N], without Serde's
        // built-in array-trait length restriction.
        Ok(
            ic_wire::__private::serde_json::json!({"k":"array", "max":N, "item":context.describe::<T>()?}),
        )
    }
}
