//! The single bounded V1 stored-record encoder and decoder.
//!
//! Store entrypoints admit the static metric size before codec dispatch.
//! This module admits stored bytes, identities and numeric state.

use ic_metrics::MeasurementAggregate;

use crate::{DurableMetric, MetricIdentity, StoreError};

const MAGIC: &[u8; 4] = b"ICM\x01";
const MAX_RECORD_BYTES: usize = 4608;

pub struct Decoder<'a> {
    remaining: &'a [u8],
}

impl<'a> Decoder<'a> {
    fn take(&mut self, length: usize) -> Result<&'a [u8], StoreError> {
        let (bytes, remaining) = self
            .remaining
            .split_at_checked(length)
            .ok_or(StoreError::MalformedRecord)?;
        self.remaining = remaining;
        Ok(bytes)
    }

    fn array<const N: usize>(&mut self) -> Result<[u8; N], StoreError> {
        self.take(N)?
            .try_into()
            .map_err(|_| StoreError::MalformedRecord)
    }

    pub fn byte(&mut self) -> Result<u8, StoreError> {
        Ok(u8::from_le_bytes(self.array()?))
    }

    pub fn flag(&mut self) -> Result<bool, StoreError> {
        match self.byte()? {
            0 => Ok(false),
            1 => Ok(true),
            _ => Err(StoreError::MalformedRecord),
        }
    }

    pub fn u16(&mut self) -> Result<u16, StoreError> {
        Ok(u16::from_le_bytes(self.array()?))
    }

    pub fn u64(&mut self) -> Result<u64, StoreError> {
        Ok(u64::from_le_bytes(self.array()?))
    }

    pub fn aggregate(&mut self) -> Result<MeasurementAggregate, StoreError> {
        let samples = self.u64()?;
        let total = u128::from_le_bytes(self.array()?);
        let maximum = self.u64()?;
        let flags = self.byte()?;
        if flags > 3 || (samples == 0 && maximum != 0) {
            return Err(StoreError::MalformedRecord);
        }
        Ok(MeasurementAggregate::from_parts(
            samples,
            total,
            (samples != 0).then_some(maximum),
            flags & 1 != 0,
            flags & 2 != 0,
        )?)
    }
}

pub fn aggregate(bytes: &mut Vec<u8>, value: MeasurementAggregate) {
    bytes.extend_from_slice(&value.samples().to_le_bytes());
    bytes.extend_from_slice(&value.total().to_le_bytes());
    bytes.extend_from_slice(&value.maximum().unwrap_or(0).to_le_bytes());
    bytes.push(u8::from(value.samples_overflowed()) | (u8::from(value.total_overflowed()) << 1));
}

pub fn envelope<'a>(
    bytes: &'a [u8],
    identity: &MetricIdentity,
) -> Result<(u8, Decoder<'a>), StoreError> {
    if bytes.len() > MAX_RECORD_BYTES {
        return Err(StoreError::RecordTooLarge);
    }
    let mut decoder = Decoder { remaining: bytes };
    if decoder.take(4)? != MAGIC {
        return Err(StoreError::UnsupportedFormat);
    }
    let kind = decoder.byte()?;
    if !(1..=3).contains(&kind) {
        return Err(StoreError::KindMismatch);
    }
    let length = usize::from(decoder.byte()?);
    let unit = decoder.take(length)?;
    let unit = std::str::from_utf8(unit).map_err(|_| StoreError::MalformedRecord)?;
    crate::identifier(unit, 64).map_err(|_| StoreError::MalformedRecord)?;
    let epoch = decoder.u64()?;
    if unit != identity.unit || epoch != identity.epoch {
        return Err(StoreError::IdentityMismatch);
    }
    Ok((kind, decoder))
}

pub fn encode<T: DurableMetric>(
    identity: &MetricIdentity,
    value: &T,
) -> Result<Vec<u8>, StoreError> {
    let length = u8::try_from(identity.unit.len()).map_err(|_| StoreError::InvalidIdentifier)?;
    let mut bytes = Vec::new();
    bytes.extend_from_slice(MAGIC);
    bytes.extend_from_slice(&[T::kind(crate::metric::ACCESS), length]);
    bytes.extend_from_slice(identity.unit.as_bytes());
    bytes.extend_from_slice(&identity.epoch.to_le_bytes());
    value.encode_state(crate::metric::ACCESS, &mut bytes)?;
    if bytes.len() > MAX_RECORD_BYTES {
        return Err(StoreError::RecordTooLarge);
    }
    Ok(bytes)
}

pub fn decode<T: DurableMetric>(
    bytes: &[u8],
    identity: &MetricIdentity,
    configuration: &T,
) -> Result<T, StoreError> {
    let (kind, mut decoder) = envelope(bytes, identity)?;
    if kind != T::kind(crate::metric::ACCESS) {
        return Err(StoreError::KindMismatch);
    }
    let value = T::decode_state(configuration, crate::metric::ACCESS, &mut decoder)?;
    if !decoder.remaining.is_empty() {
        return Err(StoreError::MalformedRecord);
    }
    Ok(value)
}
