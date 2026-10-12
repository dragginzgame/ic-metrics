//! Saturating arithmetic without sampling or attribution policy.

use core::fmt;

use crate::{MeasurementAggregate, MeasurementRatioError, MeasurementStateError};

#[cfg(test)]
mod tests;

/// Why a measurement aggregate cannot supply an integer mean.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementMeanError {
    /// The tracked sample count has actually overflowed.
    SaturatedSamples,
    /// The tracked total has actually overflowed.
    SaturatedTotal,
    /// The exact scaled-ratio projector rejected the result.
    Projection(MeasurementRatioError),
}

impl fmt::Display for MeasurementMeanError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::SaturatedSamples => formatter.write_str("measurement sample count is saturated"),
            Self::SaturatedTotal => formatter.write_str("measurement total is saturated"),
            Self::Projection(error) => {
                write!(formatter, "measurement mean projection failed: {error}")
            }
        }
    }
}

impl core::error::Error for MeasurementMeanError {
    fn source(&self) -> Option<&(dyn core::error::Error + 'static)> {
        match self {
            Self::Projection(error) => Some(error),
            _ => None,
        }
    }
}

/// Ordered observations with a mergeable aggregate and a separate latest value.
///
/// Count and total saturate independently, tracking actual overflow. An exactly
/// reached numeric cap remains exact; inspect the aggregate's saturation flags
/// before using raw counts/totals for exact arithmetic. Latest and maximum remain
/// individual observations after overflow. Empty and measured zero are distinct.
/// Consumers own units, identity, ordering and reset boundaries.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct MeasurementSummary {
    aggregate: MeasurementAggregate,
    latest: u64,
}

impl MeasurementSummary {
    /// Restore an admitted aggregate and its latest ordered observation.
    ///
    /// The caller establishes identity and ordering; this validates numeric fields.
    ///
    /// # Errors
    /// Rejects absent/nonempty latest values, values above the maximum and
    /// observations inconsistent with the aggregate's exact total. With an exact
    /// count, the other observations cannot contribute more than their maximum.
    pub const fn from_parts(
        aggregate: MeasurementAggregate,
        latest: Option<u64>,
    ) -> Result<Self, MeasurementStateError> {
        if aggregate.samples() == 0 {
            return if latest.is_none() {
                Ok(Self::EMPTY)
            } else {
                Err(MeasurementStateError::InvalidLatest)
            };
        }
        let (Some(latest), Some(maximum)) = (latest, aggregate.maximum()) else {
            return Err(MeasurementStateError::InvalidLatest);
        };
        if latest > maximum
            || (latest < maximum && aggregate.total() < latest as u128 + maximum as u128)
            || (!aggregate.samples_saturated()
                && aggregate.total()
                    > (aggregate.samples() - 1) as u128 * maximum as u128 + latest as u128)
        {
            return Err(MeasurementStateError::InvalidLatest);
        }
        Ok(Self { aggregate, latest })
    }

    /// Empty summary, with no latest or maximum observation.
    pub const EMPTY: Self = Self {
        aggregate: MeasurementAggregate::EMPTY,
        latest: 0,
    };

    /// Record one completed observation, including zero, in the existing unit.
    pub const fn record(&mut self, value: u64) {
        self.aggregate.record(value);
        self.latest = value;
    }

    /// Mergeable count/total/maximum snapshot without observation ordering.
    #[must_use]
    pub const fn aggregate(self) -> MeasurementAggregate {
        self.aggregate
    }

    /// Sample count, clipped at `u64::MAX`; saturation is in [`Self::aggregate`].
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.aggregate.samples()
    }

    /// Observation total, clipped at `u128::MAX`; saturation is in [`Self::aggregate`].
    #[must_use]
    pub const fn total(self) -> u128 {
        self.aggregate.total()
    }

    /// Floor-rounded mean, or `None` when empty. An exactly reached cap is valid.
    ///
    /// # Errors
    /// Returns [`MeasurementMeanError`] on actual count or total overflow.
    pub const fn mean(self) -> Result<Option<u128>, MeasurementMeanError> {
        self.aggregate.mean()
    }

    /// Compute `floor(total * scale / samples)`, retaining fractional information.
    ///
    /// Uses the aggregate's checked projection; a scale of ten reports tenths.
    /// Empty remains `None`, and scale zero does not conceal actual overflow.
    ///
    /// # Errors
    /// Returns [`MeasurementMeanError`] for inexact counts/totals or a failed
    /// scaled projection, with the same precedence as the aggregate.
    pub const fn scaled_mean(self, scale: u64) -> Result<Option<u128>, MeasurementMeanError> {
        self.aggregate.scaled_mean(scale)
    }

    /// Latest observation, or `None` when empty. Summaries cannot be merged.
    #[must_use]
    pub const fn latest(self) -> Option<u64> {
        if self.samples() == 0 {
            None
        } else {
            Some(self.latest)
        }
    }

    /// Largest observation, or `None` when empty, including after overflow.
    #[must_use]
    pub const fn maximum(self) -> Option<u64> {
        self.aggregate.maximum()
    }
}
