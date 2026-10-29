//! Bounded heap retention of same-unit measurements, without platform or report policy.

use alloc::{boxed::Box, collections::BTreeMap};

use crate::MeasurementAggregate;

#[cfg(test)]
mod tests;

/// Consumer-selected retention limits.
///
/// Zero entry capacity omits every observation. Zero key-byte budgets still
/// permit the empty identity when entry capacity is available.
/// Key bytes bound retained UTF-8 content, not allocator or tree-node overhead.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct MeasurementTableLimits {
    /// Maximum number of retained identities.
    pub entries: usize,
    /// Maximum UTF-8 bytes in one retained identity.
    pub key_bytes: usize,
    /// Maximum sum of retained identity UTF-8 bytes.
    pub total_key_bytes: usize,
}

/// Why an observation was retained only in the unattributed aggregate.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementOmission {
    /// This identity exceeds the per-key byte limit.
    KeyBytes,
    /// No further identities may be retained.
    Entries,
    /// This identity exceeds the remaining total key-byte budget.
    TotalKeyBytes,
}

/// The retained attribution of one recorded observation.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementAttribution {
    /// The observation belongs to a retained identity.
    Retained,
    /// The observation remains accounted for, without retaining its identity.
    Omitted(MeasurementOmission),
}

/// First-admitted bounded identities with an aggregate for all omitted observations.
///
/// Every observation in this table must use the same consumer-selected unit and
/// attribution meaning. This store neither reads counters nor chooses names.
/// Existing identities continue recording at capacity. Omitted identities are
/// never allocated, hashed into a second registry, or counted as distinct entities.
/// Iteration is lexical by retained key, not a global top-cost selection.
///
/// Clearing loses the observations. Consumers coordinate resets with all related
/// state and establish heap/instance identity before comparing snapshots.
#[derive(Clone, Debug)]
pub struct BoundedMeasurementTable {
    limits: MeasurementTableLimits,
    entries: BTreeMap<Box<str>, MeasurementAggregate>,
    retained_key_bytes: usize,
    omitted: MeasurementAggregate,
}

impl BoundedMeasurementTable {
    /// Construct an empty table without allocating storage.
    #[must_use]
    pub const fn new(limits: MeasurementTableLimits) -> Self {
        Self {
            limits,
            entries: BTreeMap::new(),
            retained_key_bytes: 0,
            omitted: MeasurementAggregate::EMPTY,
        }
    }

    /// Record once, either under an admitted identity or in the omitted aggregate.
    /// No key allocation occurs for repeated identities or rejected new identities.
    ///
    /// The per-key byte limit is checked first. An existing identity then records
    /// even at capacity. For a new identity, entry capacity is checked before the
    /// remaining total key-byte budget; the first failing check supplies the reason.
    pub fn record(&mut self, key: &str, observation: u64) -> MeasurementAttribution {
        if key.len() > self.limits.key_bytes {
            return self.omit(observation, MeasurementOmission::KeyBytes);
        }
        if let Some(aggregate) = self.entries.get_mut(key) {
            aggregate.record(observation);
            return MeasurementAttribution::Retained;
        }
        if self.entries.len() >= self.limits.entries {
            return self.omit(observation, MeasurementOmission::Entries);
        }
        if key.len()
            > self
                .limits
                .total_key_bytes
                .saturating_sub(self.retained_key_bytes)
        {
            return self.omit(observation, MeasurementOmission::TotalKeyBytes);
        }
        let mut aggregate = MeasurementAggregate::EMPTY;
        aggregate.record(observation);
        self.entries.insert(Box::from(key), aggregate);
        self.retained_key_bytes += key.len();
        MeasurementAttribution::Retained
    }

    const fn omit(
        &mut self,
        observation: u64,
        reason: MeasurementOmission,
    ) -> MeasurementAttribution {
        self.omitted.record(observation);
        MeasurementAttribution::Omitted(reason)
    }

    /// Borrow retained keys and copy their arithmetic state without allocating a report.
    pub fn entries(&self) -> impl ExactSizeIterator<Item = (&str, MeasurementAggregate)> + '_ {
        self.entries
            .iter()
            .map(|(key, value)| (key.as_ref(), *value))
    }

    /// All omitted observations, including measured zero and actual-overflow quality.
    /// Its sample count is observations, never distinct omitted identities.
    #[must_use]
    pub const fn omitted(&self) -> MeasurementAggregate {
        self.omitted
    }

    /// Bytes of retained key content, excluding map and allocator overhead.
    #[must_use]
    pub const fn retained_key_bytes(&self) -> usize {
        self.retained_key_bytes
    }

    /// The immutable retention policy chosen by the consumer.
    #[must_use]
    pub const fn limits(&self) -> MeasurementTableLimits {
        self.limits
    }

    /// Clear all observations and keys, preserving the retention policy.
    /// This does not establish or advance a consumer's reset/instance identity.
    pub fn clear(&mut self) {
        self.entries.clear();
        self.retained_key_bytes = 0;
        self.omitted = MeasurementAggregate::EMPTY;
    }
}
