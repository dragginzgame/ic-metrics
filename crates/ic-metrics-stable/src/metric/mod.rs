//! Sealed adapters to the core's canonical restored-state admission.

use ic_metrics::{MeasurementAggregate, MeasurementHistogram, MeasurementSummary};

use crate::{
    DurableMetric, MAX_HISTOGRAM_BOUNDS, StoreError,
    codec::{self, Decoder},
};

pub trait Sealed: Sized {
    const KIND: u8;
    fn check_size() -> Result<(), StoreError> {
        Ok(())
    }
    fn encode_state(&self, bytes: &mut Vec<u8>) -> Result<(), StoreError>;
    fn decode_state(configuration: &Self, decoder: &mut Decoder<'_>) -> Result<Self, StoreError>;
    fn continues(&self, previous: &Self) -> bool;
}

fn continues(current: MeasurementAggregate, previous: MeasurementAggregate) -> bool {
    current.samples() >= previous.samples()
        && current.total() >= previous.total()
        && current.maximum() >= previous.maximum()
        && (!previous.samples_saturated() || current.samples_saturated())
        && (!previous.total_saturated() || current.total_saturated())
        && (current.samples_saturated()
            || current.samples() != previous.samples()
            || current == previous)
}

impl DurableMetric for MeasurementAggregate {}

impl Sealed for MeasurementAggregate {
    const KIND: u8 = 1;

    fn encode_state(&self, bytes: &mut Vec<u8>) -> Result<(), StoreError> {
        codec::aggregate(bytes, *self);
        Ok(())
    }

    fn decode_state(_: &Self, decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
        decoder.aggregate()
    }

    fn continues(&self, previous: &Self) -> bool {
        continues(*self, *previous)
    }
}

impl DurableMetric for MeasurementSummary {}

impl Sealed for MeasurementSummary {
    const KIND: u8 = 2;

    fn encode_state(&self, bytes: &mut Vec<u8>) -> Result<(), StoreError> {
        codec::aggregate(bytes, self.aggregate());
        bytes.extend_from_slice(&self.latest().unwrap_or(0).to_le_bytes());
        Ok(())
    }

    fn decode_state(_: &Self, decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
        let aggregate = decoder.aggregate()?;
        let latest = decoder.u64()?;
        if aggregate.samples() == 0 && latest != 0 {
            return Err(StoreError::MalformedRecord);
        }
        Ok(Self::from_parts(
            aggregate,
            (aggregate.samples() != 0).then_some(latest),
        )?)
    }

    fn continues(&self, previous: &Self) -> bool {
        continues(self.aggregate(), previous.aggregate())
            && (self.aggregate().samples_saturated()
                || self.samples() != previous.samples()
                || self.latest() == previous.latest())
    }
}

impl<const N: usize> DurableMetric for MeasurementHistogram<N> {}

impl<const N: usize> Sealed for MeasurementHistogram<N> {
    const KIND: u8 = 3;

    fn check_size() -> Result<(), StoreError> {
        if N > MAX_HISTOGRAM_BOUNDS {
            Err(StoreError::TooManyBounds)
        } else {
            Ok(())
        }
    }

    fn encode_state(&self, bytes: &mut Vec<u8>) -> Result<(), StoreError> {
        codec::aggregate(bytes, self.aggregate());
        let count = u16::try_from(N).map_err(|_| StoreError::TooManyBounds)?;
        bytes.extend_from_slice(&count.to_le_bytes());
        for ((bound, count), flag) in self
            .upper_bounds()
            .iter()
            .zip(self.bucket_counts())
            .zip(self.bucket_saturation())
        {
            bytes.extend_from_slice(&bound.to_le_bytes());
            bytes.extend_from_slice(&count.to_le_bytes());
            bytes.push(u8::from(*flag));
        }
        bytes.extend_from_slice(&self.overflow().to_le_bytes());
        bytes.push(u8::from(self.overflow_saturated()));
        Ok(())
    }

    fn decode_state(configuration: &Self, decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
        let aggregate = decoder.aggregate()?;
        let length = usize::from(decoder.u16()?);
        if length > MAX_HISTOGRAM_BOUNDS {
            return Err(StoreError::TooManyBounds);
        }
        if length != N {
            return Err(StoreError::BoundsMismatch);
        }
        let mut bounds = [0; N];
        let mut counts = [0; N];
        let mut flags = [false; N];
        for ((bound, count), flag) in bounds.iter_mut().zip(&mut counts).zip(&mut flags) {
            *bound = decoder.u64()?;
            *count = decoder.u64()?;
            *flag = decoder.flag()?;
        }
        let overflow = decoder.u64()?;
        let overflow_saturated = decoder.flag()?;
        let value = Self::from_parts(
            bounds,
            counts,
            overflow,
            flags,
            overflow_saturated,
            aggregate,
        )?;
        if value.upper_bounds() != configuration.upper_bounds() {
            return Err(StoreError::BoundsMismatch);
        }
        Ok(value)
    }

    fn continues(&self, previous: &Self) -> bool {
        continues(self.aggregate(), previous.aggregate())
            && self.overflow() >= previous.overflow()
            && (!previous.overflow_saturated() || self.overflow_saturated())
            && self
                .bucket_counts()
                .iter()
                .zip(previous.bucket_counts())
                .all(|(now, before)| now >= before)
            && self
                .bucket_saturation()
                .iter()
                .zip(previous.bucket_saturation())
                .all(|(now, before)| !before || *now)
    }
}
