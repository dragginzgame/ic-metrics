//! Fixed-size distributions without sampling or reporting policy.

use core::fmt;

use crate::{MeasurementAggregate, MeasurementStateError, add_count};

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
    /// A required count or cumulative sum has actually overflowed.
    CountOverflow,
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
            Self::CountOverflow => formatter.write_str("histogram reporting count has overflowed"),
        }
    }
}

impl core::error::Error for HistogramQueryError {}

/// Why two histogram distributions cannot be combined.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HistogramMergeError {
    index: usize,
}

impl HistogramMergeError {
    /// Zero-based index of the first differing inclusive upper bound.
    #[must_use]
    pub const fn index(self) -> usize {
        self.index
    }
}

impl fmt::Display for HistogramMergeError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "histogram merge bound {} differs", self.index)
    }
}

impl core::error::Error for HistogramMergeError {}

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
/// [`MeasurementAggregate`]. Counts clip independently at `u64::MAX`, with sticky
/// flags for actual overflow; exactly reached caps remain exact. Exact
/// bucket counts remain useful after the aggregate's total overflows. Overflow
/// can prevent bucket counts from summing to the aggregate's sample count.
/// Buckets describe ranges, not exact percentiles; no latest value is retained.
///
/// Storage is fixed arrays, overflow state and one aggregate, with no heap
/// allocation. Recording searches at most `N` bounds. Consumers choose bounds,
/// units, sample admission, identity and reset boundaries. Bounds are immutable
/// after construction; report encoding and persistence remain consumer-owned.
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
/// assert_eq!(histogram.aggregate().samples(), 4);
/// # Ok(())
/// # }
/// ```
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct MeasurementHistogram<const N: usize> {
    upper_bounds: [u64; N],
    bucket_counts: [u64; N],
    overflow: u64,
    bucket_overflowed: [bool; N],
    overflow_count_overflowed: bool,
    aggregate: MeasurementAggregate,
}

impl<const N: usize> MeasurementHistogram<N> {
    /// Restore disjoint buckets and an admitted aggregate without replaying samples.
    ///
    /// This checks structural arithmetic consistency, not observation provenance.
    /// Consumers retain units, attribution and reset identity.
    ///
    /// # Errors
    /// Rejects invalid bounds, overflow flags without clipped caps, disagreement
    /// between bucket counts and the aggregate, or an incompatible maximum.
    pub const fn from_parts(
        upper_bounds: [u64; N],
        bucket_counts: [u64; N],
        overflow: u64,
        bucket_overflowed: [bool; N],
        overflow_count_overflowed: bool,
        aggregate: MeasurementAggregate,
    ) -> Result<Self, MeasurementStateError> {
        if validate_histogram_bounds(&upper_bounds).is_err() {
            return Err(MeasurementStateError::InvalidBounds);
        }
        if let Err(error) = validate_distribution(
            &upper_bounds,
            &bucket_counts,
            overflow,
            &bucket_overflowed,
            overflow_count_overflowed,
            aggregate,
        ) {
            return Err(error);
        }
        Ok(Self {
            upper_bounds,
            bucket_counts,
            overflow,
            bucket_overflowed,
            overflow_count_overflowed,
            aggregate,
        })
    }

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
        if let Err(error) = validate_histogram_bounds(&upper_bounds) {
            return Err(error);
        }
        Ok(Self {
            upper_bounds,
            bucket_counts: [0; N],
            overflow: 0,
            bucket_overflowed: [false; N],
            overflow_count_overflowed: false,
            aggregate: MeasurementAggregate::EMPTY,
        })
    }

    /// Record one completed observation, including zero.
    ///
    /// Updates the aggregate and exactly one disjoint bucket. Every observation
    /// must use the same unit as the bounds and earlier observations.
    pub const fn record(&mut self, value: u64) {
        self.aggregate.record(value);
        let mut index = 0;
        while index < N {
            // Both arrays have length N; the guard establishes valid indices.
            if value <= self.upper_bounds[index] {
                add_count(
                    &mut self.bucket_counts[index],
                    &mut self.bucket_overflowed[index],
                    1,
                );
                return;
            }
            index += 1;
        }
        add_count(&mut self.overflow, &mut self.overflow_count_overflowed, 1);
    }

    /// Immutable inclusive upper bounds corresponding to [`Self::bucket_counts`].
    #[must_use]
    pub const fn upper_bounds(&self) -> &[u64; N] {
        &self.upper_bounds
    }

    /// Disjoint bucket counts, each saturating independently at `u64::MAX`.
    ///
    /// These exclude overflow and are not cumulative counts. Inspect
    /// [`Self::bucket_overflowed`] before using clipped counts as exact values.
    #[must_use]
    pub const fn bucket_counts(&self) -> &[u64; N] {
        &self.bucket_counts
    }

    /// Count above the last bound, saturating independently at `u64::MAX`.
    ///
    /// With no bounds, this counts all observations. Inspect
    /// [`Self::overflow_count_overflowed`] before treating the clipped count as exact.
    #[must_use]
    pub const fn overflow(&self) -> u64 {
        self.overflow
    }

    /// Sticky actual-overflow flags corresponding to [`Self::bucket_counts`].
    #[must_use]
    pub const fn bucket_overflowed(&self) -> &[bool; N] {
        &self.bucket_overflowed
    }

    /// Whether the overflow bucket's count has actually overflowed.
    #[must_use]
    pub const fn overflow_count_overflowed(&self) -> bool {
        self.overflow_count_overflowed
    }

    /// Mergeable aggregate of all observations, including overflow.
    #[must_use]
    pub const fn aggregate(&self) -> MeasurementAggregate {
        self.aggregate
    }

    /// Combine a distribution with exactly the same finite bounds.
    ///
    /// Consumers establish matching units and deliberate sample attribution.
    /// This adds observations without deduplication or ordering. Source overflow
    /// propagates independently for each count and the aggregate.
    ///
    /// # Errors
    /// Returns [`HistogramMergeError`] for the first differing bound, leaving
    /// the entire destination unchanged. Different bound counts are different
    /// Rust types and cannot be merged.
    pub const fn merge(&mut self, other: &Self) -> Result<(), HistogramMergeError> {
        let mut index = 0;
        while index < N {
            if self.upper_bounds[index] != other.upper_bounds[index] {
                return Err(HistogramMergeError { index });
            }
            index += 1;
        }
        index = 0;
        while index < N {
            add_count(
                &mut self.bucket_counts[index],
                &mut self.bucket_overflowed[index],
                other.bucket_counts[index],
            );
            self.bucket_overflowed[index] |= other.bucket_overflowed[index];
            index += 1;
        }
        add_count(
            &mut self.overflow,
            &mut self.overflow_count_overflowed,
            other.overflow,
        );
        self.overflow_count_overflowed |= other.overflow_count_overflowed;
        self.aggregate.merge(other.aggregate);
        Ok(())
    }

    /// Count observations at or below the finite upper bound at `index`.
    ///
    /// Sums disjoint buckets through that index, excluding overflow. Empty
    /// histograms return zero for valid indices. Later buckets, overflow and
    /// aggregate overflow do not invalidate an otherwise exact prefix count.
    /// Arbitrary thresholds inside a bucket cannot be answered exactly.
    ///
    /// # Errors
    ///
    /// Returns [`HistogramQueryError::BucketOutOfBounds`] when `index >= N`, or
    /// [`HistogramQueryError::CountOverflow`] when a contributing count or sum
    /// has actually overflowed; an exactly reached `u64::MAX` is valid.
    pub const fn cumulative_count(&self, index: usize) -> Result<u64, HistogramQueryError> {
        if index >= N {
            return Err(HistogramQueryError::BucketOutOfBounds { index, buckets: N });
        }
        let mut total = 0_u64;
        let mut position = 0;
        while position <= index {
            if self.bucket_overflowed[position] {
                return Err(HistogramQueryError::CountOverflow);
            }
            total = match total.checked_add(self.bucket_counts[position]) {
                Some(next) => next,
                None => return Err(HistogramQueryError::CountOverflow),
            };
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
    /// fraction, or [`HistogramQueryError::CountOverflow`] if the sample count
    /// or any bucket count has actually overflowed. A overflowed value total does not
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
        if numerator == 0 || numerator > denominator {
            return Err(HistogramQueryError::InvalidQuantile);
        }
        if self.aggregate.samples() == 0 {
            return Ok(None);
        }
        if self.aggregate.samples_overflowed() {
            return Err(HistogramQueryError::CountOverflow);
        }
        let rank = quantile_rank(self.aggregate.samples(), numerator, denominator);
        // Recording, merging and restoration carry every bucket's count loss
        // into the aggregate. An exact aggregate count admits the distribution.
        let mut index = 0;
        let mut cumulative = 0_u128;
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

/// Validate borrowed inclusive histogram bounds without constructing a histogram.
///
/// Empty bounds, zero and `u64::MAX` are valid. This checks ordering only;
/// storage adapters own their bound-count limits and units remain caller-owned.
///
/// # Errors
/// Returns [`HistogramBoundsError`] for the first duplicate or descending bound,
/// identifying the right-hand bound in that pair.
///
/// ```
/// use ic_metrics::validate_histogram_bounds;
/// assert_eq!(validate_histogram_bounds(&[]), Ok(()));
/// assert_eq!(validate_histogram_bounds(&[0, 10, u64::MAX]), Ok(()));
/// assert_eq!(validate_histogram_bounds(&[10, 10]).unwrap_err().index(), 1);
/// ```
pub const fn validate_histogram_bounds(upper_bounds: &[u64]) -> Result<(), HistogramBoundsError> {
    let mut index = 1;
    while index < upper_bounds.len() {
        // Both indices are within the slice, including when it is empty.
        if upper_bounds[index - 1] >= upper_bounds[index] {
            return Err(HistogramBoundsError { index });
        }
        index += 1;
    }
    Ok(())
}

// Use native-width division when the product fits; otherwise retain exact wide ranks.
const fn quantile_rank(samples: u64, numerator: u64, denominator: u64) -> u128 {
    // The sole query caller admits a nonzero count and 0 < numerator <= denominator.
    if let Some(product) = samples.checked_mul(numerator) {
        return product.div_ceil(denominator) as u128;
    }
    ((samples as u128) * (numerator as u128)).div_ceil(denominator as u128)
}

// Canonical admission derives counts, highest bucket and total range together.
const fn validate_distribution<const N: usize>(
    upper_bounds: &[u64; N],
    bucket_counts: &[u64; N],
    overflow: u64,
    bucket_overflowed: &[bool; N],
    overflow_count_overflowed: bool,
    aggregate: MeasurementAggregate,
) -> Result<(), MeasurementStateError> {
    if overflow_count_overflowed && overflow != u64::MAX {
        return Err(MeasurementStateError::InvalidOverflowFlag);
    }
    let maximum = match aggregate.maximum() {
        Some(value) => value,
        None => 0,
    };
    let mut samples = 0;
    let mut samples_overflowed = false;
    let mut maximum_matches = false;
    let mut minimum_total = 0_u128;
    let mut maximum_total = 0_u128;
    let mut maximum_overflow = false;
    let mut minimum_overflow = false;
    let mut maximum_lower = 0_u64;
    let mut index = 0;
    // Counts retain a lower bound after clipping. Exact bucket counts
    // also constrain totals; a clipped positive bucket has no upper
    // count bound. Keep all admission arithmetic checked or saturating.
    while index <= N {
        let (count, lost, lower, upper) = if index < N {
            let lower = if index == 0 {
                0
            } else {
                upper_bounds[index - 1].saturating_add(1)
            };
            (
                bucket_counts[index],
                bucket_overflowed[index],
                lower,
                if upper_bounds[index] < maximum {
                    upper_bounds[index]
                } else {
                    maximum
                },
            )
        } else {
            let lower = if N == 0 {
                0
            } else {
                upper_bounds[N - 1].saturating_add(1)
            };
            (overflow, overflow_count_overflowed, lower, maximum)
        };
        if lost && count != u64::MAX {
            return Err(MeasurementStateError::InvalidOverflowFlag);
        }
        add_count(&mut samples, &mut samples_overflowed, count);
        samples_overflowed |= lost;
        if count != 0 {
            maximum_matches = if index < N {
                maximum <= upper_bounds[index] && (index == 0 || maximum > upper_bounds[index - 1])
            } else {
                N == 0 || maximum > upper_bounds[N - 1]
            };
            maximum_lower = lower;
            let minimum_count = count as u128 + lost as u128;
            let minimum = minimum_count * lower as u128;
            if let Some(next) = minimum_total.checked_add(minimum) {
                minimum_total = next;
            } else {
                minimum_overflow = true;
            }
            if lost && upper != 0 {
                maximum_overflow = true;
            }
            let upper_total = count as u128 * upper as u128;
            if let Some(next) = maximum_total.checked_add(upper_total) {
                maximum_total = next;
            } else {
                maximum_overflow = true;
            }
        }
        index += 1;
    }
    if samples != aggregate.samples()
        || samples_overflowed != aggregate.samples_overflowed()
        || (samples != 0 && !maximum_matches)
    {
        return Err(MeasurementStateError::InvalidDistribution);
    }
    if samples == 0 {
        return Ok(());
    }
    // At least one observation actually attains the stored maximum.
    if let Some(next) = minimum_total.checked_add(maximum.saturating_sub(maximum_lower) as u128) {
        minimum_total = next;
    } else {
        minimum_overflow = true;
    }
    let valid_total = if aggregate.total_overflowed() {
        maximum_overflow
    } else {
        !minimum_overflow
            && aggregate.total() >= minimum_total
            && (maximum_overflow || aggregate.total() <= maximum_total)
    };
    if valid_total {
        Ok(())
    } else {
        Err(MeasurementStateError::InvalidDistribution)
    }
}
