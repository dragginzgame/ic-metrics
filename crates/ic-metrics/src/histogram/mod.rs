//! Fixed-size distributions without sampling or reporting policy.

use core::fmt;

use crate::MeasurementSummary;

#[cfg(test)]
mod tests;

/// A bound is not strictly greater than the preceding bound.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HistogramBoundsError {
    index: usize,
}

impl HistogramBoundsError {
    /// Zero-based index of the first invalid bound, always at least one.
    #[must_use]
    pub const fn index(self) -> usize {
        self.index
    }
}

impl fmt::Display for HistogramBoundsError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            formatter,
            "histogram bound {} is not strictly increasing",
            self.index
        )
    }
}

impl core::error::Error for HistogramBoundsError {}

/// Fixed-size histogram of observations in one consumer-selected unit.
///
/// `N` strictly increasing inclusive upper bounds define `N` disjoint buckets.
/// The first bucket includes zero; later buckets exclude the preceding bound.
/// Values above the last bound go into a separate overflow bucket. With no
/// bounds, every observation goes into overflow. A final bound of `u64::MAX`
/// is valid and leaves overflow empty.
///
/// Each observation updates one bucket and the accompanying
/// [`MeasurementSummary`]. Bucket counts saturate independently at `u64::MAX`.
/// Treat a count at that value as unavailable for exact arithmetic, even when
/// reached exactly. Unsaturated bucket counts remain useful after the summary's
/// total saturates. Saturation can prevent bucket counts from summing to the
/// summary's sample count. Buckets describe ranges, not exact percentiles.
///
/// Storage is fixed arrays, one overflow count and one summary, with no heap
/// allocation. Recording searches at most `N` bounds. Consumers choose bounds,
/// units, sample admission, identity and reset boundaries. Bounds are immutable
/// after construction; cumulative reporting and persistence remain consumer-owned.
///
/// ```
/// use ic_metrics::MeasurementHistogram;
///
/// # fn main() -> Result<(), ic_metrics::HistogramBoundsError> {
/// let mut histogram = MeasurementHistogram::new([10, 100])?;
/// for value in [0, 10, 11, 101] {
///     histogram.record(value);
/// }
/// assert_eq!(histogram.bucket_counts(), &[2, 1]);
/// assert_eq!(histogram.overflow(), 1);
/// assert_eq!(histogram.summary().samples(), 4);
/// # Ok(())
/// # }
/// ```
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct MeasurementHistogram<const N: usize> {
    upper_bounds: [u64; N],
    bucket_counts: [u64; N],
    overflow: u64,
    summary: MeasurementSummary,
}

impl<const N: usize> MeasurementHistogram<N> {
    /// Construct an empty histogram with inclusive upper bounds.
    ///
    /// Bounds and observations must use the same unit. A bound of zero and an
    /// empty bounds array are valid.
    ///
    /// # Errors
    ///
    /// Returns [`HistogramBoundsError`] for the first duplicate or descending
    /// bound. The error identifies the right-hand bound in that pair.
    pub const fn new(upper_bounds: [u64; N]) -> Result<Self, HistogramBoundsError> {
        let mut index = 1;
        while index < N {
            // Both indices are within the array, including when N is zero.
            if upper_bounds[index - 1] >= upper_bounds[index] {
                return Err(HistogramBoundsError { index });
            }
            index += 1;
        }
        Ok(Self {
            upper_bounds,
            bucket_counts: [0; N],
            overflow: 0,
            summary: MeasurementSummary::EMPTY,
        })
    }

    /// Record one completed observation, including zero.
    ///
    /// Updates the summary and exactly one disjoint bucket. Every observation
    /// must use the same unit as the bounds and earlier observations.
    pub const fn record(&mut self, value: u64) {
        self.summary.record(value);
        let mut index = 0;
        while index < N {
            // Both arrays have length N; the guard establishes valid indices.
            if value <= self.upper_bounds[index] {
                self.bucket_counts[index] = self.bucket_counts[index].saturating_add(1);
                return;
            }
            index += 1;
        }
        self.overflow = self.overflow.saturating_add(1);
    }

    /// Immutable inclusive upper bounds corresponding to [`Self::bucket_counts`].
    #[must_use]
    pub const fn upper_bounds(&self) -> &[u64; N] {
        &self.upper_bounds
    }

    /// Disjoint bucket counts, each saturating independently at `u64::MAX`.
    ///
    /// These exclude overflow and are not cumulative counts.
    #[must_use]
    pub const fn bucket_counts(&self) -> &[u64; N] {
        &self.bucket_counts
    }

    /// Count above the last bound, saturating independently at `u64::MAX`.
    ///
    /// With no bounds, this counts all observations.
    #[must_use]
    pub const fn overflow(&self) -> u64 {
        self.overflow
    }

    /// Summary of all observations, including overflow.
    #[must_use]
    pub const fn summary(&self) -> MeasurementSummary {
        self.summary
    }
}
