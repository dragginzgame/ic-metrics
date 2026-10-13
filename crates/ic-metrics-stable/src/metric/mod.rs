//! Sealed adapters to the core's canonical restored-state admission.

use ic_metrics::{MeasurementAggregate, MeasurementHistogram, MeasurementSummary};

use crate::{
    DurableMetric, MAX_HISTOGRAM_BOUNDS, StoreError,
    codec::{self, Decoder},
};

// Public inside this private module so the sealed signatures remain legal.
// Its private field prevents safe external construction, even through an
// inferred generic supertrait call. Store dispatch alone supplies this token.
#[derive(Clone, Copy)]
pub struct Access(());

pub const ACCESS: Access = Access(());

pub trait Sealed: Sized {
    fn kind(access: Access) -> u8;
    fn check_size(_: Access) -> Result<(), StoreError> {
        Ok(())
    }
    fn encode_state(&self, _: Access, bytes: &mut Vec<u8>) -> Result<(), StoreError>;
    fn decode_state(
        configuration: &Self,
        _: Access,
        decoder: &mut Decoder<'_>,
    ) -> Result<Self, StoreError>;
    fn continues(&self, _: Access, previous: &Self) -> bool;
}

fn continues(current: MeasurementAggregate, previous: MeasurementAggregate) -> bool {
    current.samples() >= previous.samples()
        && current.total() >= previous.total()
        && current.maximum() >= previous.maximum()
        && (!previous.samples_overflowed() || current.samples_overflowed())
        && (!previous.total_overflowed() || current.total_overflowed())
        && (current.samples_overflowed()
            || current.samples() != previous.samples()
            || current == previous)
}

impl DurableMetric for MeasurementAggregate {}

impl Sealed for MeasurementAggregate {
    fn kind(_: Access) -> u8 {
        1
    }

    fn encode_state(&self, _: Access, bytes: &mut Vec<u8>) -> Result<(), StoreError> {
        codec::aggregate(bytes, *self);
        Ok(())
    }

    fn decode_state(_: &Self, _: Access, decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
        decoder.aggregate()
    }

    fn continues(&self, _: Access, previous: &Self) -> bool {
        continues(*self, *previous)
    }
}

impl DurableMetric for MeasurementSummary {}

impl Sealed for MeasurementSummary {
    fn kind(_: Access) -> u8 {
        2
    }

    fn encode_state(&self, _: Access, bytes: &mut Vec<u8>) -> Result<(), StoreError> {
        codec::aggregate(bytes, self.aggregate());
        bytes.extend_from_slice(&self.latest().unwrap_or(0).to_le_bytes());
        Ok(())
    }

    fn decode_state(_: &Self, _: Access, decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
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

    fn continues(&self, _: Access, previous: &Self) -> bool {
        continues(self.aggregate(), previous.aggregate())
            && (self.aggregate().samples_overflowed()
                || self.samples() != previous.samples()
                || self.latest() == previous.latest())
    }
}

impl<const N: usize> DurableMetric for MeasurementHistogram<N> {}

impl<const N: usize> Sealed for MeasurementHistogram<N> {
    fn kind(_: Access) -> u8 {
        3
    }

    fn check_size(_: Access) -> Result<(), StoreError> {
        if N > MAX_HISTOGRAM_BOUNDS {
            Err(StoreError::TooManyBounds)
        } else {
            Ok(())
        }
    }

    fn encode_state(&self, _: Access, bytes: &mut Vec<u8>) -> Result<(), StoreError> {
        codec::aggregate(bytes, self.aggregate());
        let count = u16::try_from(N).map_err(|_| StoreError::TooManyBounds)?;
        bytes.extend_from_slice(&count.to_le_bytes());
        for ((bound, count), flag) in self
            .upper_bounds()
            .iter()
            .zip(self.bucket_counts())
            .zip(self.bucket_overflowed())
        {
            bytes.extend_from_slice(&bound.to_le_bytes());
            bytes.extend_from_slice(&count.to_le_bytes());
            bytes.push(u8::from(*flag));
        }
        bytes.extend_from_slice(&self.overflow().to_le_bytes());
        bytes.push(u8::from(self.overflow_count_overflowed()));
        Ok(())
    }

    fn decode_state(
        configuration: &Self,
        _: Access,
        decoder: &mut Decoder<'_>,
    ) -> Result<Self, StoreError> {
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
        let overflow_count_overflowed = decoder.flag()?;
        let value = Self::from_parts(
            bounds,
            counts,
            overflow,
            flags,
            overflow_count_overflowed,
            aggregate,
        )?;
        if value.upper_bounds() != configuration.upper_bounds() {
            return Err(StoreError::BoundsMismatch);
        }
        Ok(value)
    }

    fn continues(&self, _: Access, previous: &Self) -> bool {
        continues(self.aggregate(), previous.aggregate())
            && self.overflow() >= previous.overflow()
            && (!previous.overflow_count_overflowed() || self.overflow_count_overflowed())
            && self
                .bucket_counts()
                .iter()
                .zip(previous.bucket_counts())
                .all(|(now, before)| now >= before)
            && self
                .bucket_overflowed()
                .iter()
                .zip(previous.bucket_overflowed())
                .all(|(now, before)| !before || *now)
    }
}
