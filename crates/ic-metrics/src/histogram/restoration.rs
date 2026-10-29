//! Derive distribution facts before admitting a restored aggregate.

use crate::{MeasurementAggregate, MeasurementStateError, add_count, add_total};

struct TotalRange {
    minimum: u128,
    minimum_overflowed: bool,
    maximum: u128,
    maximum_overflowed: bool,
}

impl TotalRange {
    const EMPTY: Self = Self {
        minimum: 0,
        minimum_overflowed: false,
        maximum: 0,
        maximum_overflowed: false,
    };

    const fn include_bucket(&mut self, count: u64, lost: bool, lower: u64, upper: u64) {
        // Clipping preserves a lower count bound but loses a positive bucket's
        // upper total bound. Each individual product still fits in u128.
        let minimum_count = count as u128 + lost as u128;
        add_total(
            &mut self.minimum,
            &mut self.minimum_overflowed,
            minimum_count * lower as u128,
        );
        if lost && upper != 0 {
            self.maximum_overflowed = true;
        }
        add_total(
            &mut self.maximum,
            &mut self.maximum_overflowed,
            count as u128 * upper as u128,
        );
    }

    const fn include_maximum(&mut self, maximum: u64, bucket_lower: u64) {
        // At least one observation attains the stored maximum, rather than
        // merely its bucket's lower bound.
        add_total(
            &mut self.minimum,
            &mut self.minimum_overflowed,
            maximum.saturating_sub(bucket_lower) as u128,
        );
    }

    const fn admits(&self, aggregate: MeasurementAggregate) -> bool {
        if aggregate.total_overflowed() {
            self.maximum_overflowed
        } else {
            !self.minimum_overflowed
                && aggregate.total() >= self.minimum
                && (self.maximum_overflowed || aggregate.total() <= self.maximum)
        }
    }
}

struct DistributionFacts {
    samples: u64,
    samples_overflowed: bool,
    maximum_matches: bool,
    totals: TotalRange,
}

impl DistributionFacts {
    const fn derive<const N: usize>(
        upper_bounds: &[u64; N],
        bucket_counts: &[u64; N],
        overflow: u64,
        bucket_overflowed: &[bool; N],
        overflow_count_overflowed: bool,
        maximum: u64,
    ) -> Result<Self, MeasurementStateError> {
        let mut facts = Self {
            samples: 0,
            samples_overflowed: false,
            maximum_matches: false,
            totals: TotalRange::EMPTY,
        };
        let mut maximum_lower = 0;
        let mut index = 0;
        while index <= N {
            let (count, lost) = if index < N {
                (bucket_counts[index], bucket_overflowed[index])
            } else {
                (overflow, overflow_count_overflowed)
            };
            if lost && count != u64::MAX {
                return Err(MeasurementStateError::InvalidOverflowFlag);
            }
            add_count(&mut facts.samples, &mut facts.samples_overflowed, count);
            facts.samples_overflowed |= lost;
            if count != 0 {
                let (lower, upper) = bucket_limits(upper_bounds, index, maximum);
                facts.maximum_matches = if index < N {
                    maximum <= upper_bounds[index]
                        && (index == 0 || maximum > upper_bounds[index - 1])
                } else {
                    N == 0 || maximum > upper_bounds[N - 1]
                };
                maximum_lower = lower;
                facts.totals.include_bucket(count, lost, lower, upper);
            }
            index += 1;
        }
        if facts.samples != 0 {
            facts.totals.include_maximum(maximum, maximum_lower);
        }
        Ok(facts)
    }

    const fn admits(&self, aggregate: MeasurementAggregate) -> bool {
        if self.samples != aggregate.samples()
            || self.samples_overflowed != aggregate.samples_overflowed()
            || (self.samples != 0 && !self.maximum_matches)
        {
            return false;
        }
        self.samples == 0 || self.totals.admits(aggregate)
    }
}

// Bounds and index are already admitted. Maximum placement is checked separately,
// so saturation here cannot admit an overflow bucket beyond u64::MAX.
const fn bucket_limits(upper_bounds: &[u64], index: usize, maximum: u64) -> (u64, u64) {
    let lower = if index == 0 {
        0
    } else {
        upper_bounds[index - 1].saturating_add(1)
    };
    let upper = if index < upper_bounds.len() && upper_bounds[index] < maximum {
        upper_bounds[index]
    } else {
        maximum
    };
    (lower, upper)
}

pub(super) const fn validate_distribution<const N: usize>(
    upper_bounds: &[u64; N],
    bucket_counts: &[u64; N],
    overflow: u64,
    bucket_overflowed: &[bool; N],
    overflow_count_overflowed: bool,
    aggregate: MeasurementAggregate,
) -> Result<(), MeasurementStateError> {
    let maximum = match aggregate.maximum() {
        Some(value) => value,
        None => 0,
    };
    let facts = match DistributionFacts::derive(
        upper_bounds,
        bucket_counts,
        overflow,
        bucket_overflowed,
        overflow_count_overflowed,
        maximum,
    ) {
        Ok(facts) => facts,
        Err(error) => return Err(error),
    };
    if facts.admits(aggregate) {
        Ok(())
    } else {
        Err(MeasurementStateError::InvalidDistribution)
    }
}
