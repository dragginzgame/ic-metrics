//! Saturating arithmetic without sampling or attribution policy.

use core::fmt;

use crate::MeasurementAggregate;

#[cfg(test)]
mod tests;

/// Why a measurement aggregate cannot supply an integer mean.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementMeanError {
    /// A nonzero total has no observations to account for it.
    TotalWithoutSamples,
    /// Tracked samples overflowed, or a raw count is at the ambiguous numeric cap.
    SaturatedSamples,
    /// The tracked total overflowed, or a raw total is at the ambiguous numeric cap.
    SaturatedTotal,
}

impl fmt::Display for MeasurementMeanError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::TotalWithoutSamples => "nonzero measurement total without samples",
            Self::SaturatedSamples => "measurement sample count is saturated",
            Self::SaturatedTotal => "measurement total is saturated",
        })
    }
}

impl core::error::Error for MeasurementMeanError {}

/// Project the integer mean of consumer-owned sample count and total fields.
///
/// Returns `Ok(None)` for `(0, 0)` and `Ok(Some(0))` for nonempty measured zero.
/// Other unsaturated nonempty inputs use floor division, in the total's unit.
/// Consumers must establish that both fields describe the same observations,
/// unit and window; this function cannot establish their identity or provenance.
///
/// # Errors
///
/// Rejects a nonzero total with zero samples first. Otherwise a count or total
/// at `u64::MAX` is unavailable, even when reached exactly. If both are at the
/// cap, [`MeasurementMeanError::SaturatedSamples`] takes precedence.
///
/// ```
/// use ic_metrics::{checked_mean, MeasurementMeanError};
///
/// assert_eq!(checked_mean(0, 0), Ok(None));
/// assert_eq!(checked_mean(2, 0), Ok(Some(0)));
/// assert_eq!(checked_mean(2, 9), Ok(Some(4)));
/// assert_eq!(checked_mean(1, u64::MAX), Err(MeasurementMeanError::SaturatedTotal));
/// ```
pub const fn checked_mean(samples: u64, total: u64) -> Result<Option<u64>, MeasurementMeanError> {
    if samples == 0 {
        return if total == 0 {
            Ok(None)
        } else {
            Err(MeasurementMeanError::TotalWithoutSamples)
        };
    }
    if samples == u64::MAX {
        return Err(MeasurementMeanError::SaturatedSamples);
    }
    if total == u64::MAX {
        return Err(MeasurementMeanError::SaturatedTotal);
    }
    Ok(Some(total / samples))
}

/// Record one value into a sample count and total, saturating independently.
///
/// Zero is a completed sample. `value` and `total` must use the same unit.
/// This primitive supports consumer-owned report shapes without serialization
/// dependencies. It does not validate continuity or make saturated counters
/// suitable for exact interval arithmetic.
pub const fn record_sample(samples: &mut u64, total: &mut u64, value: u64) {
    *samples = samples.saturating_add(1);
    *total = total.saturating_add(value);
}

/// Ordered observations with a mergeable aggregate and a separate latest value.
///
/// Count and total saturate independently, tracking actual overflow. An exactly
/// reached `u64::MAX` remains exact; inspect the aggregate's saturation flags
/// before using raw counts/totals for exact arithmetic. Latest and maximum remain
/// individual observations after overflow. Empty and measured zero are distinct.
/// Consumers own units, identity, ordering and reset boundaries.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct MeasurementSummary {
    aggregate: MeasurementAggregate,
    latest: u64,
}

impl MeasurementSummary {
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

    /// Observation total, clipped at `u64::MAX`; saturation is in [`Self::aggregate`].
    #[must_use]
    pub const fn total(self) -> u64 {
        self.aggregate.total()
    }

    /// Floor-rounded mean, or `None` when empty. An exactly reached cap is valid.
    ///
    /// # Errors
    /// Returns [`MeasurementMeanError`] on actual count or total overflow.
    pub const fn mean(self) -> Result<Option<u64>, MeasurementMeanError> {
        self.aggregate.mean()
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
