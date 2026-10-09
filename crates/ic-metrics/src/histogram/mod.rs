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

/// Why a histogram cannot supply an exact reporting projection.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum HistogramQueryError {
    /// The index does not name one of the configured finite upper bounds.
    BucketOutOfBounds {
        /// Requested zero-based bound index.
        index: usize,
        /// Number of configured finite upper bounds.
        buckets: usize,
    },
    /// A nearest-rank fraction must satisfy `0 < numerator <= denominator`.
    InvalidQuantile,
    /// A required count or cumulative sum is at the `u64::MAX` cap.
    SaturatedCount,
}

impl fmt::Display for HistogramQueryError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::BucketOutOfBounds { index, buckets } => {
                write!(
                    formatter,
                    "histogram bound index {index} is outside {buckets} bounds"
                )
            }
            Self::InvalidQuantile => {
                formatter.write_str("quantile must be greater than zero and at most one")
            }
            Self::SaturatedCount => formatter.write_str("histogram reporting count is saturated"),
        }
    }
}

impl core::error::Error for HistogramQueryError {}

/// The observation range of a histogram bucket, not an exact percentile value.
///
/// A missing lower bound includes zero; otherwise the lower bound is exclusive.
/// The upper bound is inclusive when present. A missing upper bound is overflow
/// beyond the configured bounds. With no configured bounds both are absent and
/// the range covers all `u64` observations.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HistogramRange {
    lower_exclusive: Option<u64>,
    upper_inclusive: Option<u64>,
}

impl HistogramRange {
    /// Exclusive lower bound, or `None` when zero is included.
    #[must_use]
    pub const fn lower_exclusive(self) -> Option<u64> {
        self.lower_exclusive
    }

    /// Inclusive upper bound, or `None` for overflow without a configured ceiling.
    #[must_use]
    pub const fn upper_inclusive(self) -> Option<u64> {
        self.upper_inclusive
    }
}

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

    /// Count observations at or below the finite upper bound at `index`.
    ///
    /// Sums disjoint buckets through that index, excluding overflow. Empty
    /// histograms return zero for valid indices. Later buckets, overflow and
    /// summary saturation do not invalidate an otherwise exact prefix count.
    /// Arbitrary thresholds inside a bucket cannot be answered exactly.
    ///
    /// # Errors
    ///
    /// Returns [`HistogramQueryError::BucketOutOfBounds`] when `index >= N`, or
    /// [`HistogramQueryError::SaturatedCount`] when a contributing count or sum
    /// reaches `u64::MAX`, including an exactly reached cap.
    pub const fn cumulative_count(&self, index: usize) -> Result<u64, HistogramQueryError> {
        if index >= N {
            return Err(HistogramQueryError::BucketOutOfBounds { index, buckets: N });
        }
        let mut total = 0_u64;
        let mut position = 0;
        while position <= index {
            total = total.saturating_add(self.bucket_counts[position]);
            if total == u64::MAX {
                return Err(HistogramQueryError::SaturatedCount);
            }
            position += 1;
        }
        Ok(total)
    }

    /// Locate the bucket containing the nearest-rank quantile `numerator / denominator`.
    ///
    /// The one-based rank is `ceil(samples * numerator / denominator)`, with
    /// `0 < numerator <= denominator`. Returns `None` for no observations and
    /// otherwise a range, including overflow. It never interpolates an exact
    /// percentile value. Recording and retained state are unchanged.
    ///
    /// # Errors
    ///
    /// Returns [`HistogramQueryError::InvalidQuantile`] first for an invalid
    /// fraction, or [`HistogramQueryError::SaturatedCount`] if the sample count
    /// or any bucket count is at `u64::MAX`. A saturated value total does not
    /// invalidate a distribution whose counts remain exact.
    ///
    /// ```
    /// use ic_metrics::MeasurementHistogram;
    /// # fn main() -> Result<(), Box<dyn std::error::Error>> {
    /// let mut histogram = MeasurementHistogram::new([10, 100])?;
    /// for value in [0, 10, 11, 101] { histogram.record(value); }
    /// assert_eq!(histogram.cumulative_count(0)?, 2);
    /// let median = histogram.quantile_bucket(1, 2)?.unwrap();
    /// assert_eq!(median.upper_inclusive(), Some(10));
    /// assert_eq!(histogram.quantile_bucket(95, 100)?.unwrap().upper_inclusive(), None);
    /// # Ok(())
    /// # }
    /// ```
    pub const fn quantile_bucket(
        &self,
        numerator: u64,
        denominator: u64,
    ) -> Result<Option<HistogramRange>, HistogramQueryError> {
        let rank = match quantile_rank(self.summary.samples(), numerator, denominator) {
            Ok(Some(rank)) => rank,
            Ok(None) => return Ok(None),
            Err(error) => return Err(error),
        };
        // Check every count before returning a whole-distribution projection.
        let mut index = 0;
        while index < N {
            if self.bucket_counts[index] == u64::MAX {
                return Err(HistogramQueryError::SaturatedCount);
            }
            index += 1;
        }
        if self.overflow == u64::MAX {
            return Err(HistogramQueryError::SaturatedCount);
        }
        let mut cumulative = 0_u128;
        index = 0;
        while index < N {
            cumulative += self.bucket_counts[index] as u128;
            if cumulative >= rank {
                return Ok(Some(HistogramRange {
                    lower_exclusive: if index == 0 {
                        None
                    } else {
                        Some(self.upper_bounds[index - 1])
                    },
                    upper_inclusive: Some(self.upper_bounds[index]),
                }));
            }
            index += 1;
        }
        Ok(Some(HistogramRange {
            lower_exclusive: if N == 0 {
                None
            } else {
                Some(self.upper_bounds[N - 1])
            },
            upper_inclusive: None,
        }))
    }
}

// Wide multiplication retains exact ranks for every valid u64 count and fraction.
const fn quantile_rank(
    samples: u64,
    numerator: u64,
    denominator: u64,
) -> Result<Option<u128>, HistogramQueryError> {
    if numerator == 0 || numerator > denominator {
        return Err(HistogramQueryError::InvalidQuantile);
    }
    if samples == u64::MAX {
        return Err(HistogramQueryError::SaturatedCount);
    }
    if samples == 0 {
        return Ok(None);
    }
    Ok(Some(
        ((samples as u128) * (numerator as u128)).div_ceil(denominator as u128),
    ))
}
