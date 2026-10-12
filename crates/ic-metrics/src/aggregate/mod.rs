//! Order-independent observations and exact interval arithmetic.

use core::fmt;

use crate::{MeasurementMeanError, MeasurementStateError, add_count, add_total, mean_total};

#[cfg(test)]
mod tests;

/// Why two tracked snapshots cannot supply an exact count/total interval.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementIntervalError {
    /// A sample count has actually overflowed.
    SaturatedSamples,
    /// An observation total has actually overflowed.
    SaturatedTotal,
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
            Self::SaturatedSamples => "interval sample count has overflowed",
            Self::SaturatedTotal => "interval total has overflowed",
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
    samples_saturated: bool,
    total_saturated: bool,
}

impl MeasurementAggregate {
    /// Restore explicit fields after numeric consistency checks.
    ///
    /// Exactly reached caps with false flags stay exact. This admits arithmetic
    /// consistency only; the caller owns provenance, units and window identity.
    ///
    /// # Errors
    /// Rejects invalid empty state, missing maxima, inconsistent saturation flags
    /// and totals outside the range allowed by count and maximum.
    pub const fn from_parts(
        samples: u64,
        total: u128,
        maximum: Option<u64>,
        samples_saturated: bool,
        total_saturated: bool,
    ) -> Result<Self, MeasurementStateError> {
        if samples == 0 {
            return if total == 0 && maximum.is_none() && !samples_saturated && !total_saturated {
                Ok(Self::EMPTY)
            } else {
                Err(MeasurementStateError::InvalidEmpty)
            };
        }
        let Some(maximum) = maximum else {
            return Err(MeasurementStateError::MissingMaximum);
        };
        if (samples_saturated && samples != u64::MAX)
            || (total_saturated && (total != u128::MAX || !samples_saturated))
        {
            return Err(MeasurementStateError::InvalidSaturation);
        }
        if total < maximum as u128
            || (maximum == 0 && total != 0)
            || (!samples_saturated && total > samples as u128 * maximum as u128)
        {
            return Err(MeasurementStateError::InvalidTotal);
        }
        Ok(Self {
            samples,
            total,
            maximum,
            samples_saturated,
            total_saturated,
        })
    }

    /// Empty aggregate, without a maximum observation.
    pub const EMPTY: Self = Self {
        samples: 0,
        total: 0,
        maximum: 0,
        samples_saturated: false,
        total_saturated: false,
    };

    /// Record one admitted observation, including zero, in the existing unit.
    pub const fn record(&mut self, value: u64) {
        add_count(&mut self.samples, &mut self.samples_saturated, 1);
        add_total(&mut self.total, &mut self.total_saturated, value as u128);
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
            &mut self.samples_saturated,
            other.samples,
        );
        add_total(&mut self.total, &mut self.total_saturated, other.total);
        self.samples_saturated |= other.samples_saturated;
        self.total_saturated |= other.total_saturated;
        if other.maximum > self.maximum {
            self.maximum = other.maximum;
        }
    }

    /// Sample count, clipped at `u64::MAX`; check [`Self::samples_saturated`].
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.samples
    }

    /// Total, clipped at `u128::MAX`; check [`Self::total_saturated`].
    #[must_use]
    pub const fn total(self) -> u128 {
        self.total
    }

    /// Whether recording or merging has actually overflowed the sample count.
    #[must_use]
    pub const fn samples_saturated(self) -> bool {
        self.samples_saturated
    }

    /// Whether recording or merging has actually overflowed the value total.
    #[must_use]
    pub const fn total_saturated(self) -> bool {
        self.total_saturated
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
    /// Returns [`MeasurementMeanError::SaturatedSamples`] before
    /// [`MeasurementMeanError::SaturatedTotal`] when actual overflow is recorded.
    pub const fn mean(self) -> Result<Option<u128>, MeasurementMeanError> {
        if self.samples_saturated {
            return Err(MeasurementMeanError::SaturatedSamples);
        }
        if self.total_saturated {
            return Err(MeasurementMeanError::SaturatedTotal);
        }
        Ok(mean_total(self.samples, self.total))
    }

    /// Exact count/total difference from an earlier snapshot of this accumulator.
    ///
    /// Consumers must first establish matching units, window/reset identity and
    /// append-only continuity. This cannot detect a reset followed by numerically
    /// larger values or changed attribution. Maxima and latest values are not
    /// subtractable and are not returned. Empty intervals differ from added zeros.
    ///
    /// # Errors
    /// Rejects sample overflow, total overflow, decreasing samples, decreasing
    /// totals, then a changed total with no added samples, in that order.
    pub const fn interval_since(
        self,
        previous: Self,
    ) -> Result<MeasurementInterval, MeasurementIntervalError> {
        if self.samples_saturated || previous.samples_saturated {
            return Err(MeasurementIntervalError::SaturatedSamples);
        }
        if self.total_saturated || previous.total_saturated {
            return Err(MeasurementIntervalError::SaturatedTotal);
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
