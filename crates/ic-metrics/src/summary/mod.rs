//! Saturating arithmetic without sampling or attribution policy.

use crate::{MeasurementAggregate, MeasurementStateError};

#[cfg(test)]
mod tests;

/// Ordered observations with a mergeable aggregate and a separate latest value.
///
/// Count and total saturate independently, tracking actual overflow. An exactly
/// reached numeric cap remains exact; inspect the aggregate's overflow flags
/// before using raw counts/totals for exact arithmetic. Latest and maximum remain
/// individual observations after overflow. Empty and measured zero are distinct.
/// Consumers own units, identity, ordering and reset boundaries.
/// Project counts, totals, maximum and means through [`Self::aggregate`], just
/// as for a histogram; this type adds ordered recording and [`Self::latest`].
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
            || (!aggregate.samples_overflowed()
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

    /// Latest observation, or `None` when empty. Summaries cannot be merged.
    #[must_use]
    pub const fn latest(self) -> Option<u64> {
        if self.aggregate.samples() == 0 {
            None
        } else {
            Some(self.latest)
        }
    }
}
