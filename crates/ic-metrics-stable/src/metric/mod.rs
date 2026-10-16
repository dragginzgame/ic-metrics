//! Private adapters to the core's canonical restored-state admission.

use ic_metrics::{
    MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary,
};

use crate::{
    MAX_HISTOGRAM_BOUNDS, StoreError,
    codec::{self, Decoder},
};

pub trait StoredMetric: Sized + Eq {
    type Configuration: ?Sized;
    fn configuration(&self) -> &Self::Configuration;
    fn kind() -> u8;
    fn same_state(&self, previous: &Self) -> bool {
        self == previous
    }
    fn encoded_size() -> Result<usize, StoreError>;
    // Called only after encoded_size admits this metric's static shape.
    fn encode_state(&self, bytes: &mut Vec<u8>);
    fn decode_state(
        configuration: &Self::Configuration,
        decoder: &mut Decoder<'_>,
    ) -> Result<Self, StoreError>;
    fn continues(&self, previous: &Self) -> bool;
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

impl StoredMetric for MeasurementCounter {
    type Configuration = ();

    fn configuration(&self) -> &() {
        &()
    }

    fn kind() -> u8 {
        4
    }

    fn encoded_size() -> Result<usize, StoreError> {
        Ok(codec::COUNTER_BYTES)
    }

    fn encode_state(&self, bytes: &mut Vec<u8>) {
        bytes.extend_from_slice(&self.total().to_le_bytes());
        bytes.push(u8::from(self.total_overflowed()));
    }

    fn decode_state((): &(), decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
        Ok(Self::from_parts(decoder.u128()?, decoder.flag()?)?)
    }

    fn continues(&self, previous: &Self) -> bool {
        self.total() >= previous.total()
            && (!previous.total_overflowed() || self.total_overflowed())
    }
}

impl StoredMetric for MeasurementAggregate {
    type Configuration = ();

    fn configuration(&self) -> &() {
        &()
    }

    fn kind() -> u8 {
        1
    }

    fn encoded_size() -> Result<usize, StoreError> {
        Ok(codec::AGGREGATE_BYTES)
    }

    fn encode_state(&self, bytes: &mut Vec<u8>) {
        codec::aggregate(bytes, *self);
    }

    fn decode_state((): &(), decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
        decoder.aggregate()
    }

    fn continues(&self, previous: &Self) -> bool {
        continues(*self, *previous)
    }
}

impl StoredMetric for MeasurementSummary {
    type Configuration = ();

    fn configuration(&self) -> &() {
        &()
    }

    fn kind() -> u8 {
        2
    }

    fn encoded_size() -> Result<usize, StoreError> {
        Ok(codec::SUMMARY_BYTES)
    }

    fn encode_state(&self, bytes: &mut Vec<u8>) {
        codec::aggregate(bytes, self.aggregate());
        bytes.extend_from_slice(&self.latest().unwrap_or(0).to_le_bytes());
    }

    fn decode_state((): &(), decoder: &mut Decoder<'_>) -> Result<Self, StoreError> {
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
            && (self.aggregate().samples_overflowed()
                || self.aggregate().samples() != previous.aggregate().samples()
                || self.latest() == previous.latest())
    }
}

impl<const N: usize> StoredMetric for MeasurementHistogram<N> {
    type Configuration = [u64; N];

    fn configuration(&self) -> &[u64; N] {
        self.upper_bounds()
    }

    fn kind() -> u8 {
        3
    }

    fn same_state(&self, previous: &Self) -> bool {
        // Tiny arrays already reject cheaply. Larger matching arrays are costly
        // when recording changes a bucket but leaves overflow unchanged.
        if N < 4 {
            self == previous
        } else {
            self.overflow() == previous.overflow()
                && self.aggregate() == previous.aggregate()
                && self == previous
        }
    }

    fn encoded_size() -> Result<usize, StoreError> {
        if N > MAX_HISTOGRAM_BOUNDS {
            return Err(StoreError::TooManyBounds);
        }
        Ok(codec::HISTOGRAM_BASE_BYTES + codec::HISTOGRAM_BUCKET_BYTES * N)
    }

    fn encode_state(&self, bytes: &mut Vec<u8>) {
        codec::aggregate(bytes, self.aggregate());
        #[expect(
            clippy::cast_possible_truncation,
            reason = "encoded_size admits at most 256 bounds before encoding"
        )]
        let count = N as u16;
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
    }

    fn decode_state(
        configuration: &Self::Configuration,
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
        if value.upper_bounds() != configuration {
            return Err(StoreError::BoundsMismatch);
        }
        Ok(value)
    }

    fn continues(&self, previous: &Self) -> bool {
        continues(self.aggregate(), previous.aggregate())
            && self.overflow() >= previous.overflow()
            && (!previous.overflow_count_overflowed() || self.overflow_count_overflowed())
            && self
                .bucket_counts()
                .iter()
                .zip(self.bucket_overflowed())
                .zip(
                    previous
                        .bucket_counts()
                        .iter()
                        .zip(previous.bucket_overflowed()),
                )
                .all(|((now, now_overflowed), (before, before_overflowed))| {
                    now >= before && (!before_overflowed || *now_overflowed)
                })
    }
}
