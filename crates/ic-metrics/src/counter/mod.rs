//! Tracked scalar accumulation without observation statistics or attribution.

use core::fmt;

use crate::{MeasurementStateError, add_total};

#[cfg(test)]
mod tests;

/// Why a scalar counter cannot supply an exact total or difference.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementCounterError {
    /// A required counter total has actually overflowed.
    SaturatedTotal,
    /// The current total is below the previous total.
    DecreasingTotal,
}

impl fmt::Display for MeasurementCounterError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::SaturatedTotal => "counter total has overflowed",
            Self::DecreasingTotal => "counter total decreased",
        })
    }
}

impl core::error::Error for MeasurementCounterError {}

/// A scalar total in one consumer-selected unit with tracked actual overflow.
///
/// Use for diagnostic event counts, item counts or quantities such as bytes.
/// Each addition increases the total without retaining a sample count, maximum,
/// latest value or distribution. Zero is an exact total, not an absent metric;
/// consumers own whether a counter exists and which events may increment it.
///
/// Totals clip at `u128::MAX` with a sticky flag for actual overflow. An exactly
/// reached cap remains exact. Inputs must already be exact: adding a clamped
/// quantity cannot restore its lost quality. Consumers own units, identities,
/// reset boundaries and reporting. No allocation, platform reads or logging.
/// Diagnostic totals do not replace authoritative budgets, balances or debt.
///
/// ```
/// use ic_metrics::MeasurementCounter;
/// # fn main() -> Result<(), ic_metrics::MeasurementCounterError> {
/// let mut retries = MeasurementCounter::ZERO;
/// retries.add(1);
/// retries.add(1);
/// assert_eq!(retries.exact_total()?, 2);
/// let mut bytes = MeasurementCounter::ZERO;
/// let before = bytes;
/// bytes.add(32_768);
/// bytes.add(0);
/// assert_eq!(bytes.delta_since(before)?, 32_768);
/// # Ok(())
/// # }
/// ```
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct MeasurementCounter {
    total: u128,
    total_saturated: bool,
}

impl MeasurementCounter {
    /// Zero total with no actual overflow; zero additions remain exact.
    pub const ZERO: Self = Self {
        total: 0,
        total_saturated: false,
    };

    /// Restore a total and its actual-overflow flag after numeric admission.
    ///
    /// A cap with a false flag remains exact. The caller owns provenance, units
    /// and identity; missing or previously discarded quality cannot be inferred.
    ///
    /// # Errors
    /// Returns [`MeasurementStateError::InvalidSaturation`] when a true flag
    /// accompanies a total below its clipped cap.
    pub const fn from_parts(
        total: u128,
        total_saturated: bool,
    ) -> Result<Self, MeasurementStateError> {
        if total_saturated && total != u128::MAX {
            return Err(MeasurementStateError::InvalidSaturation);
        }
        Ok(Self {
            total,
            total_saturated,
        })
    }

    /// Add an admitted exact quantity, including zero, in the existing unit.
    ///
    /// Use one for an event; larger quantities can account for a whole batch.
    /// This never wraps or clears an existing overflow flag.
    pub const fn add(&mut self, amount: u128) {
        add_total(&mut self.total, &mut self.total_saturated, amount);
    }

    /// Add a counter's total while preserving any source overflow.
    ///
    /// Consumers establish matching units and deliberate attribution. This is
    /// addition, not deduplication: merging the same batch twice counts it twice.
    pub const fn merge(&mut self, other: Self) {
        self.add(other.total);
        self.total_saturated |= other.total_saturated;
    }

    /// Total clipped at `u128::MAX`; check [`Self::total_saturated`].
    #[must_use]
    pub const fn total(self) -> u128 {
        self.total
    }

    /// Whether addition or merging has actually overflowed the total.
    #[must_use]
    pub const fn total_saturated(self) -> bool {
        self.total_saturated
    }

    /// Exact total, including zero and an exactly reached cap.
    ///
    /// Use a checked conversion when a consumer report requires a narrower type;
    /// a narrowing failure is distinct from this accumulator's overflow.
    ///
    /// # Errors
    /// Returns [`MeasurementCounterError::SaturatedTotal`] on actual overflow.
    pub const fn exact_total(self) -> Result<u128, MeasurementCounterError> {
        if self.total_saturated {
            Err(MeasurementCounterError::SaturatedTotal)
        } else {
            Ok(self.total)
        }
    }

    /// Exact difference from an earlier snapshot of this counter, including zero.
    ///
    /// Consumers must first establish matching units, counter/window identity and
    /// append-only continuity. Numeric success cannot detect a reset followed by
    /// larger values, changed attribution or an unrelated counter.
    ///
    /// # Errors
    /// Rejects actual overflow in either snapshot before a decreasing total.
    pub const fn delta_since(self, previous: Self) -> Result<u128, MeasurementCounterError> {
        if self.total_saturated || previous.total_saturated {
            return Err(MeasurementCounterError::SaturatedTotal);
        }
        match self.total.checked_sub(previous.total) {
            Some(delta) => Ok(delta),
            None => Err(MeasurementCounterError::DecreasingTotal),
        }
    }
}
