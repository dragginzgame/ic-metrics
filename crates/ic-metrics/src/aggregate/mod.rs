//! Order-independent observations and exact interval arithmetic.

mod checked;
pub use checked::{CheckedMeasurementAggregate, MeasurementRecordError};

use core::fmt;

use crate::{MeasurementStateError, add_count, add_total};

#[cfg(test)]
mod tests;

// Preserve native-width division for ordinary windows; wide totals stay exact.
const fn mean_total(samples: u64, total: u128) -> Option<u128> {
    if total <= u64::MAX as u128 {
        // TryFrom is not const at the arithmetic support floor.
        #[expect(
            clippy::cast_possible_truncation,
            reason = "the branch admits a u64 total"
        )]
        let narrow = total as u64;
        match narrow.checked_div(samples) {
            Some(mean) => Some(mean as u128),
            None => None,
        }
    } else {
        total.checked_div(samples as u128)
    }
}

/// Why a measurement aggregate cannot supply an integer or scaled mean.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementMeanError {
    /// The tracked sample count has actually overflowed.
    SampleCountOverflow,
}

impl fmt::Display for MeasurementMeanError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str("measurement sample count has overflowed")
    }
}

impl core::error::Error for MeasurementMeanError {}

/// Why two tracked snapshots cannot supply an exact count/total interval.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementIntervalError {
    /// A sample count has actually overflowed.
    SampleCountOverflow,
    /// The current sample count is below the previous count.
    DecreasingSamples,
    /// The current total is below the previous total.
    DecreasingTotal,
    /// The total changed without any additional observations.
    TotalWithoutSamples,
}

impl fmt::Display for MeasurementIntervalError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::SampleCountOverflow => "interval sample count has overflowed",
            Self::DecreasingSamples => "interval sample count decreased",
            Self::DecreasingTotal => "interval total decreased",
            Self::TotalWithoutSamples => "interval total changed without samples",
        })
    }
}

impl core::error::Error for MeasurementIntervalError {}

/// Exact count and total differences, without a maximum or latest observation.
///
/// Constructed by [`MeasurementAggregate::interval_since`] only after numeric
/// admission. Consumers must establish common units, identity and append-only
/// continuity; increasing numbers alone cannot establish any of those facts.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct MeasurementInterval {
    samples: u64,
    total: u128,
}

impl MeasurementInterval {
    /// Number of added observations, including measured zero.
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.samples
    }

    /// Exact sum of added observations in the consumer's unit.
    #[must_use]
    pub const fn total(self) -> u128 {
        self.total
    }

    /// Floor-rounded mean, or `None` when no observations were added.
    #[must_use]
    pub const fn mean(self) -> Option<u128> {
        mean_total(self.samples, self.total)
    }
}

/// Mergeable count, total and maximum in one consumer-selected unit.
///
/// Counts clip at `u64::MAX` and totals at `u128::MAX`; sticky flags record actual
/// overflow, so an exactly reached cap remains exact. Maximum is an individual
/// observation and remains valid after overflow. There is no latest observation:
/// unordered batches cannot establish ordering. Every `u64` sample fits in a
/// `u128` total while the sample count remains exact. No allocation or platform reads.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct MeasurementAggregate {
    samples: u64,
    total: u128,
    maximum: u64,
    samples_overflowed: bool,
    total_overflowed: bool,
}

impl MeasurementAggregate {
    /// Restore explicit fields after numeric consistency checks.
    ///
    /// Exactly reached caps with false flags stay exact. This admits arithmetic
    /// consistency only; the caller owns provenance, units and window identity.
    ///
    /// # Errors
    /// Rejects invalid empty state, missing maxima, inconsistent overflow flags
    /// and totals outside the range allowed by count and maximum.
    pub const fn from_parts(
        samples: u64,
        total: u128,
        maximum: Option<u64>,
        samples_overflowed: bool,
        total_overflowed: bool,
    ) -> Result<Self, MeasurementStateError> {
        if samples == 0 {
            return if total == 0 && maximum.is_none() && !samples_overflowed && !total_overflowed {
                Ok(Self::EMPTY)
            } else {
                Err(MeasurementStateError::InvalidEmpty)
            };
        }
        let Some(maximum) = maximum else {
            return Err(MeasurementStateError::MissingMaximum);
        };
        if (samples_overflowed && samples != u64::MAX)
            || (total_overflowed && (total != u128::MAX || !samples_overflowed))
        {
            return Err(MeasurementStateError::InvalidOverflowFlag);
        }
        if total < maximum as u128
            || (maximum == 0 && total != 0)
            || (!samples_overflowed && total > samples as u128 * maximum as u128)
        {
            return Err(MeasurementStateError::InvalidTotal);
        }
        Ok(Self {
            samples,
            total,
            maximum,
            samples_overflowed,
            total_overflowed,
        })
    }

    /// Empty aggregate, without a maximum observation.
    pub const EMPTY: Self = Self {
        samples: 0,
        total: 0,
        maximum: 0,
        samples_overflowed: false,
        total_overflowed: false,
    };

    /// Record one admitted observation, including zero, in the existing unit.
    pub const fn record(&mut self, value: u64) {
        add_count(&mut self.samples, &mut self.samples_overflowed, 1);
        add_total(&mut self.total, &mut self.total_overflowed, value as u128);
        if value > self.maximum {
            self.maximum = value;
        }
    }

    /// Combine observations from a batch without claiming ordering or identity.
    ///
    /// Consumers must establish common units and deliberate sample attribution.
    /// This is addition, not deduplication: merging the same batch twice records
    /// it twice. Source overflow remains sticky even when its clipped value fits.
    pub const fn merge(&mut self, other: Self) {
        add_count(
            &mut self.samples,
            &mut self.samples_overflowed,
            other.samples,
        );
        add_total(&mut self.total, &mut self.total_overflowed, other.total);
        self.samples_overflowed |= other.samples_overflowed;
        self.total_overflowed |= other.total_overflowed;
        if other.maximum > self.maximum {
            self.maximum = other.maximum;
        }
    }

    /// Sample count, clipped at `u64::MAX`; check [`Self::samples_overflowed`].
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.samples
    }

    /// Total, clipped at `u128::MAX`; check [`Self::total_overflowed`].
    #[must_use]
    pub const fn total(self) -> u128 {
        self.total
    }

    /// Whether recording or merging has actually overflowed the sample count.
    #[must_use]
    pub const fn samples_overflowed(self) -> bool {
        self.samples_overflowed
    }

    /// Whether recording or merging has actually overflowed the value total.
    #[must_use]
    pub const fn total_overflowed(self) -> bool {
        self.total_overflowed
    }

    /// Largest observation, or `None` when empty, including after overflow.
    #[must_use]
    pub const fn maximum(self) -> Option<u64> {
        if self.samples == 0 {
            None
        } else {
            Some(self.maximum)
        }
    }

    /// Floor-rounded mean, or `None` when empty. Exactly reached caps are valid.
    ///
    /// # Errors
    /// Returns [`MeasurementMeanError::SampleCountOverflow`] on actual count overflow.
    /// An exact count guarantees that the accumulated total is also exact.
    pub const fn mean(self) -> Result<Option<u128>, MeasurementMeanError> {
        if self.samples_overflowed {
            return Err(MeasurementMeanError::SampleCountOverflow);
        }
        Ok(mean_total(self.samples, self.total))
    }

    /// Compute `floor(total * scale / samples)` after checking actual overflow.
    ///
    /// Scales the exact total before division, retaining fractional information
    /// that multiplying the integer mean would lose. A scale of ten reports
    /// tenths; callers own units and display. Empty is `None`, measured zero is
    /// `Some(0)`, and an exactly reached count cap remains exact.
    ///
    /// # Errors
    /// Returns [`MeasurementMeanError::SampleCountOverflow`] on actual count overflow,
    /// even with scale zero. An exact count bounds the scaled result within `u128`.
    ///
    /// ```
    /// use ic_metrics::MeasurementAggregate;
    /// # fn main() -> Result<(), ic_metrics::MeasurementMeanError> {
    /// let mut values = MeasurementAggregate::EMPTY;
    /// assert_eq!(values.scaled_mean(10)?, None);
    /// values.record(3);
    /// values.record(4);
    /// assert_eq!(values.mean()?, Some(3));
    /// assert_eq!(values.scaled_mean(10)?, Some(35));
    /// # Ok(())
    /// # }
    /// ```
    pub const fn scaled_mean(self, scale: u64) -> Result<Option<u128>, MeasurementMeanError> {
        if self.samples_overflowed {
            return Err(MeasurementMeanError::SampleCountOverflow);
        }
        if self.samples == 0 {
            return Ok(None);
        }
        let samples = self.samples as u128;
        let scale = scale as u128;
        // Admitted exact state has total <= samples * maximum. The quotient
        // is at most u64::MAX, and the final result is at most maximum * scale.
        // Decomposition avoids a potentially overflowing total * scale product.
        Ok(Some(
            (self.total / samples) * scale + (self.total % samples) * scale / samples,
        ))
    }

    /// Exact count/total difference from an earlier snapshot of this accumulator.
    ///
    /// Consumers must first establish matching units, window/reset identity and
    /// append-only continuity. This cannot detect a reset followed by numerically
    /// larger values or changed attribution. Maxima and latest values are not
    /// subtractable and are not returned. Empty intervals differ from added zeros.
    ///
    /// # Errors
    /// Rejects sample overflow, decreasing samples, decreasing totals, then a
    /// changed total with no added samples, in that order. An exact sample count
    /// guarantees total exactness in both snapshots.
    pub const fn interval_since(
        self,
        previous: Self,
    ) -> Result<MeasurementInterval, MeasurementIntervalError> {
        if self.samples_overflowed || previous.samples_overflowed {
            return Err(MeasurementIntervalError::SampleCountOverflow);
        }
        let Some(samples) = self.samples.checked_sub(previous.samples) else {
            return Err(MeasurementIntervalError::DecreasingSamples);
        };
        let Some(total) = self.total.checked_sub(previous.total) else {
            return Err(MeasurementIntervalError::DecreasingTotal);
        };
        if samples == 0 && total != 0 {
            return Err(MeasurementIntervalError::TotalWithoutSamples);
        }
        Ok(MeasurementInterval { samples, total })
    }
}
