//! Exact wide observations with rejection before any state change.

use core::fmt;

/// Why recording an exact wide observation cannot be represented.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementRecordError {
    /// The next observation would exceed the sample count.
    Samples,
    /// The next observation would exceed the exact total.
    Total,
}

impl fmt::Display for MeasurementRecordError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::Samples => "measurement sample count would overflow",
            Self::Total => "measurement total would overflow",
        })
    }
}

impl core::error::Error for MeasurementRecordError {}

/// Exact count, total and extrema of `u128` observations in one selected unit.
///
/// Unlike [`super::MeasurementAggregate`], this accepts wide observations and
/// rejects overflow without clipping or changing any field. Empty and measured
/// zero remain distinct. Consumers own units, attribution, grouping and identity;
/// this type reads no platform counters and retains no labels or timestamps.
///
/// ```
/// use ic_metrics::{CheckedMeasurementAggregate, MeasurementRecordError};
///
/// let mut values = CheckedMeasurementAggregate::EMPTY;
/// assert_eq!(values.minimum(), None);
/// values.try_record(u128::MAX)?;
/// let before = values;
/// assert_eq!(values.try_record(1), Err(MeasurementRecordError::Total));
/// assert_eq!(values, before);
/// values.try_record(0)?;
/// assert_eq!(values.minimum(), Some(0));
/// # Ok::<(), MeasurementRecordError>(())
/// ```
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct CheckedMeasurementAggregate {
    samples: u64,
    total: u128,
    minimum: u128,
    maximum: u128,
}

impl CheckedMeasurementAggregate {
    /// No observations, with no extrema.
    pub const EMPTY: Self = Self {
        samples: 0,
        total: 0,
        minimum: 0,
        maximum: 0,
    };

    /// Record a wide observation, including zero, without partial updates.
    ///
    /// # Errors
    /// Rejects count overflow first, then total overflow; every field is unchanged.
    pub const fn try_record(&mut self, value: u128) -> Result<(), MeasurementRecordError> {
        let Some(samples) = self.samples.checked_add(1) else {
            return Err(MeasurementRecordError::Samples);
        };
        let Some(total) = self.total.checked_add(value) else {
            return Err(MeasurementRecordError::Total);
        };
        if self.samples == 0 || value < self.minimum {
            self.minimum = value;
        }
        if value > self.maximum {
            self.maximum = value;
        }
        self.samples = samples;
        self.total = total;
        Ok(())
    }

    /// Number of successfully recorded observations.
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.samples
    }

    /// Exact sum of successfully recorded observations.
    #[must_use]
    pub const fn total(self) -> u128 {
        self.total
    }

    /// Smallest observation, or `None` when empty, including measured zero.
    #[must_use]
    pub const fn minimum(self) -> Option<u128> {
        if self.samples == 0 {
            None
        } else {
            Some(self.minimum)
        }
    }

    /// Largest observation, or `None` when empty, including measured zero.
    #[must_use]
    pub const fn maximum(self) -> Option<u128> {
        if self.samples == 0 {
            None
        } else {
            Some(self.maximum)
        }
    }
}

#[cfg(test)]
mod tests;
