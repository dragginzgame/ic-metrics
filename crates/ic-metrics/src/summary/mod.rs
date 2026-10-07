//! Saturating arithmetic without sampling or attribution policy.

use core::fmt;

#[cfg(test)]
mod tests;

/// Why a measurement aggregate cannot supply an integer mean.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementMeanError {
    /// A nonzero total has no observations to account for it.
    TotalWithoutSamples,
    /// The sample count is at `u64::MAX`, including an exactly reached cap.
    SaturatedSamples,
    /// The total is at `u64::MAX`, including an exactly reached cap.
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

/// Saturating summary of observations in one consumer-selected unit.
///
/// Count and total saturate independently at `u64::MAX`. Treat either counter
/// at that value as unavailable for exact interval arithmetic, including when
/// reached exactly. Latest and maximum remain individual observations after
/// saturation. Empty and measured zero are distinct states.
///
/// Consumers establish identity and reset boundaries before comparing snapshots.
/// The summary does not decide whether observations overlap or are additive.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct MeasurementSummary {
    samples: u64,
    total: u64,
    latest: u64,
    maximum: u64,
}

impl MeasurementSummary {
    /// Empty summary, with no latest or maximum observation.
    pub const EMPTY: Self = Self {
        samples: 0,
        total: 0,
        latest: 0,
        maximum: 0,
    };

    /// Record one completed observation, including zero.
    ///
    /// Every observation must use the same unit as earlier observations.
    pub const fn record(&mut self, value: u64) {
        record_sample(&mut self.samples, &mut self.total, value);
        self.latest = value;
        if value > self.maximum {
            self.maximum = value;
        }
    }

    /// Number of completed samples, saturating independently of the total.
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.samples
    }

    /// Sum of all observations, saturating independently of the sample count.
    #[must_use]
    pub const fn total(self) -> u64 {
        self.total
    }

    /// Integer mean in the observation's unit, rounded down, or `None` if empty.
    ///
    /// # Errors
    ///
    /// Returns [`MeasurementMeanError`] when either counter is at `u64::MAX`,
    /// including an exactly reached cap. Uses the same contract as [`checked_mean`].
    pub const fn mean(self) -> Result<Option<u64>, MeasurementMeanError> {
        checked_mean(self.samples, self.total)
    }

    /// Latest observation, or `None` when no sample has been recorded.
    #[must_use]
    pub const fn latest(self) -> Option<u64> {
        if self.samples == 0 {
            None
        } else {
            Some(self.latest)
        }
    }

    /// Largest observation, or `None` when no sample has been recorded.
    #[must_use]
    pub const fn maximum(self) -> Option<u64> {
        if self.samples == 0 {
            None
        } else {
            Some(self.maximum)
        }
    }
}
