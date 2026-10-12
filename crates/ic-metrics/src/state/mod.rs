//! Admission of restored arithmetic state, without a storage format or identity.

use core::fmt;

#[cfg(test)]
mod tests;

/// Why restored fields cannot represent a consistent measurement state.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementStateError {
    /// An empty count has nonempty observations, totals or overflow flags.
    InvalidEmpty,
    /// A nonempty count must have a maximum observation.
    MissingMaximum,
    /// An overflow flag requires its corresponding clipped numeric cap.
    InvalidSaturation,
    /// The total is inconsistent with the count and maximum.
    InvalidTotal,
    /// The latest observation is absent or inconsistent with the aggregate.
    InvalidLatest,
    /// Histogram bounds must be strictly increasing.
    InvalidBounds,
    /// Histogram counts, flags or maximum disagree with the aggregate.
    InvalidDistribution,
}

impl fmt::Display for MeasurementStateError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::InvalidEmpty => "nonempty state without observations",
            Self::MissingMaximum => "observations without a maximum",
            Self::InvalidSaturation => "overflow flag without a clipped cap",
            Self::InvalidTotal => "total disagrees with count or maximum",
            Self::InvalidLatest => "latest observation disagrees with aggregate",
            Self::InvalidBounds => "histogram bounds are not strictly increasing",
            Self::InvalidDistribution => "distribution disagrees with aggregate",
        })
    }
}

impl core::error::Error for MeasurementStateError {}
