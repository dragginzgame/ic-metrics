//! Optional durable snapshots in one host-owned stable B-tree map.
//!
//! The host bootstraps `ic-memory`, opens exactly one map for its metrics store,
//! and supplies it here. This crate owns no global registry, lifecycle hook,
//! platform read or endpoint. Keys are namespaced, not authentication boundaries.
//! Stable writes must run in update execution; queries cannot make them durable.
//!
//! Stored values have an explicit V1 encoding, independent of Rust layout. The
//! adapter rejects incompatible identities/configuration and malformed values.
//! Underlying collection geometry, allocation failures and IC execution traps
//! retain the upstream stable-structures contract, not recoverable codec errors.

#![doc = include_str!("../README.md")]

use std::{error::Error, fmt};

use ic_memory::ic_stable_structures::{BTreeMap, Memory};
use ic_metrics::MeasurementStateError;

mod codec;
mod metric;

#[cfg(test)]
mod tests;

/// A supported arithmetic type with an admitted durable encoding.
///
/// Implemented only for `MeasurementAggregate`, `MeasurementSummary` and
/// `MeasurementHistogram<N>`. Histograms support at most 256 finite bounds.
/// Supported snapshots have exact structural equality.
/// The bound supports generic store operations; raw codec and continuity
/// dispatch require an adapter-private capability.
///
/// ```
/// use ic_memory::ic_stable_structures::Memory;
/// use ic_metrics_stable::{DurableMetric, MetricIdentity, MetricKey, MetricsStore, StoreError};
/// fn checkpoint<M: Memory, T: DurableMetric>(
///     store: &mut MetricsStore<M>, key: &MetricKey, identity: &MetricIdentity, value: &T,
/// ) -> Result<Option<T>, StoreError> {
///     store.save(key, identity, value)?;
///     store.load(key, identity, value)
/// }
/// ```
///
/// The sealed bound alone cannot dispatch raw state encoding, size admission,
/// kind selection or continuity checks:
///
/// ```compile_fail,E0061
/// use ic_metrics_stable::DurableMetric;
/// fn raw<T: DurableMetric>(value: &T) {
///     let _ = value.encode_state(&mut Vec::new());
/// }
/// ```
///
/// ```compile_fail,E0061
/// use ic_metrics_stable::DurableMetric;
/// fn raw<T: DurableMetric>() {
///     let _ = T::encoded_size();
/// }
/// ```
///
/// ```compile_fail,E0061
/// use ic_metrics_stable::DurableMetric;
/// fn raw<T: DurableMetric>() {
///     let _ = T::kind();
/// }
/// ```
///
/// ```compile_fail,E0061
/// use ic_metrics_stable::DurableMetric;
/// fn raw<T: DurableMetric>(value: &T) {
///     let _ = value.continues(value);
/// }
/// ```
///
/// An inferred argument cannot manufacture the private capability:
///
/// ```compile_fail,E0277
/// use ic_metrics_stable::DurableMetric;
/// fn raw<T: DurableMetric>(value: &T) {
///     let _ = value.encode_state(Default::default(), &mut Vec::new());
/// }
/// ```
pub trait DurableMetric: metric::Sealed {}

/// Maximum finite bounds per stored histogram, bounding codec work and records.
pub const MAX_HISTOGRAM_BOUNDS: usize = 256;

/// Typed failures at key, identity, stored-value and snapshot admission boundaries.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum StoreError {
    /// Namespace, name or unit is empty, too long or contains unsupported bytes.
    InvalidIdentifier,
    /// The stored record exceeds the admitted byte budget.
    RecordTooLarge,
    /// Missing bytes, invalid flags or trailing data in a V1 record.
    MalformedRecord,
    /// The record has an unknown format discriminator; it is never reinterpreted.
    UnsupportedFormat,
    /// The stored metric uses a different arithmetic kind.
    KindMismatch,
    /// Unit or reset epoch differs from the caller's expected identity.
    IdentityMismatch,
    /// Histogram finite bounds differ from the caller's expected configuration.
    BoundsMismatch,
    /// The histogram exceeds the adapter's bound-count limit.
    TooManyBounds,
    /// Restored numeric fields fail core arithmetic admission.
    InvalidState(MeasurementStateError),
    /// A checkpoint decreases counts/totals/maxima or clears sticky overflow.
    StateRegression,
}

impl fmt::Display for StoreError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidState(error) => write!(formatter, "invalid metric state: {error}"),
            Self::InvalidIdentifier => formatter.write_str("invalid bounded metric identifier"),
            Self::RecordTooLarge => formatter.write_str("metric record exceeds byte budget"),
            Self::MalformedRecord => formatter.write_str("malformed metric record"),
            Self::UnsupportedFormat => formatter.write_str("unsupported metric record format"),
            Self::KindMismatch => formatter.write_str("metric kind differs"),
            Self::IdentityMismatch => formatter.write_str("metric unit or reset epoch differs"),
            Self::BoundsMismatch => formatter.write_str("histogram bounds differ"),
            Self::TooManyBounds => formatter.write_str("histogram has too many finite bounds"),
            Self::StateRegression => formatter.write_str("metric checkpoint regresses"),
        }
    }
}

impl Error for StoreError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self {
            Self::InvalidState(error) => Some(error),
            _ => None,
        }
    }
}

impl From<MeasurementStateError> for StoreError {
    fn from(error: MeasurementStateError) -> Self {
        Self::InvalidState(error)
    }
}

fn identifier(value: &str, limit: usize) -> Result<(), StoreError> {
    if value.is_empty()
        || value.len() > limit
        || !value
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || b"._/-:".contains(&byte))
    {
        return Err(StoreError::InvalidIdentifier);
    }
    Ok(())
}

/// Permanent bounded namespace/name pair; neither component can contain NUL.
///
/// Encoded as `namespace`, NUL, `name`. No hashes, implicit consumer IDs or
/// process-local registration order participate in durable identity.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct MetricKey(Vec<u8>);

impl MetricKey {
    /// Admit an ASCII namespace (up to 64 bytes) and name (up to 128 bytes).
    ///
    /// # Errors
    /// Rejects empty/oversized identifiers or bytes other than letters, digits,
    /// dot, underscore, slash, hyphen and colon.
    pub fn new(namespace: &str, name: &str) -> Result<Self, StoreError> {
        identifier(namespace, 64)?;
        identifier(name, 128)?;
        let mut bytes = Vec::with_capacity(namespace.len() + 1 + name.len());
        bytes.extend_from_slice(namespace.as_bytes());
        bytes.push(0);
        bytes.extend_from_slice(name.as_bytes());
        Ok(Self(bytes))
    }
}

/// Caller-owned measurement unit and reset epoch, stored in every record.
///
/// Upgrade alone does not advance the epoch of a deliberately retained lifetime
/// metric. A reset does; counter/call-context continuity is a separate contract.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct MetricIdentity {
    unit: String,
    epoch: u64,
}

impl MetricIdentity {
    /// Admit a unit (same ASCII alphabet as keys, up to 64 bytes) and reset epoch.
    ///
    /// # Errors
    /// Returns `StoreError::InvalidIdentifier` for an invalid unit.
    pub fn new(unit: &str, epoch: u64) -> Result<Self, StoreError> {
        identifier(unit, 64)?;
        Ok(Self {
            unit: unit.to_owned(),
            epoch,
        })
    }
}

/// The one stable collection supplied by the host after allocation admission.
///
/// Byte values make decoding fallible outside `Storable::from_bytes`; both keys
/// and record writes are bounded by this adapter. The underlying map owns its
/// structural allocation/decoding contract and may allocate while reading bytes.
pub type MetricsMap<M> = BTreeMap<Vec<u8>, Vec<u8>, M>;

/// Shared durable metric snapshots in one application memory region.
pub struct MetricsStore<M: Memory> {
    map: MetricsMap<M>,
}

impl<M: Memory> MetricsStore<M> {
    /// Take ownership of an already opened metrics-only map.
    ///
    /// Hosts own collection initialization/reopening and `ic-memory` bootstrap.
    /// Never independently open another collection on this same memory region.
    #[must_use]
    pub const fn new(map: MetricsMap<M>) -> Self {
        Self { map }
    }

    /// Load a snapshot, checking identity, kind and histogram bounds.
    ///
    /// `configuration` selects the type and, for histograms, the finite bounds;
    /// its current observations are ignored. Absence is `None`, not measured zero.
    ///
    /// # Errors
    /// Rejects malformed/incompatible stored records or unsupported bound counts.
    pub fn load<T: DurableMetric>(
        &self,
        key: &MetricKey,
        identity: &MetricIdentity,
        configuration: &T,
    ) -> Result<Option<T>, StoreError> {
        T::encoded_size(crate::metric::ACCESS)?;
        self.load_admitted(key, identity, configuration)
    }

    // Both public entrypoints admit the static size before inspecting stored bytes.
    fn load_admitted<T: DurableMetric>(
        &self,
        key: &MetricKey,
        identity: &MetricIdentity,
        configuration: &T,
    ) -> Result<Option<T>, StoreError> {
        self.map
            .get(&key.0)
            .map(|bytes| codec::decode(&bytes, identity, configuration))
            .transpose()
    }

    /// Checkpoint a complete snapshot, preserving append-only numeric continuity.
    ///
    /// An identical retained snapshot succeeds without encoding or writing again.
    /// This is replacement, not
    /// merging; hosts own sample admission and commit cadence. Batch observations
    /// within an update message, then save at its chosen attribution boundary.
    ///
    /// # Errors
    /// Rejects load errors, incompatible identity/configuration or regressing
    /// counts, totals, maxima, buckets and overflow flags before any map mutation.
    pub fn save<T: DurableMetric>(
        &mut self,
        key: &MetricKey,
        identity: &MetricIdentity,
        value: &T,
    ) -> Result<(), StoreError> {
        let payload_size = T::encoded_size(crate::metric::ACCESS)?;
        if let Some(previous) = self.load_admitted(key, identity, value)? {
            if value.same_state(crate::metric::ACCESS, &previous) {
                return Ok(());
            }
            if !value.continues(crate::metric::ACCESS, &previous) {
                return Err(StoreError::StateRegression);
            }
        }
        let bytes = codec::encode(identity, value, payload_size)?;
        self.map.insert(key.0.clone(), bytes);
        Ok(())
    }

    /// Explicitly discard a row after checking its stored envelope and identity.
    ///
    /// This deliberate reset/retirement does not free the map's memory ID. The
    /// payload may be corrupt: removal is an explicit disposition, never a load
    /// fallback. Save a replacement with a new epoch in the same update message,
    /// without an intervening await. The host owns that atomic reset boundary.
    ///
    /// # Errors
    /// Rejects invalid/unknown envelopes or differing unit/reset epoch.
    pub fn remove(
        &mut self,
        key: &MetricKey,
        identity: &MetricIdentity,
    ) -> Result<bool, StoreError> {
        let Some(bytes) = self.map.get(&key.0) else {
            return Ok(false);
        };
        codec::envelope(&bytes, identity)?;
        self.map.remove(&key.0);
        Ok(true)
    }

    /// Return the collection for host-owned administration or lifecycle handling.
    #[must_use]
    pub fn into_map(self) -> MetricsMap<M> {
        self.map
    }
}
