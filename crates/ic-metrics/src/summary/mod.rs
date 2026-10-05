//! Saturating arithmetic without sampling or attribution policy.

#[cfg(test)]
mod tests;

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
