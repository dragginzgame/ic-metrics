//! Measurement arithmetic and optional bounded recording for Internet Computer consumers.
//!
//! Values use one consumer-selected unit per aggregate. Consumers own sampling,
//! attribution, instance identity, reset policy and reporting. This crate does
//! not read platform counters or manufacture measurements. The library is
//! dependency-free and `no_std` on every target. Default arithmetic needs no allocator;
//! the opt-in `recording` feature uses `alloc` for bounded keyed retention.

#![doc = include_str!("application.md")]
#![no_std]

#[cfg(feature = "recording")]
extern crate alloc;
#[cfg(feature = "recording")]
mod recording;
#[cfg(feature = "recording")]
pub use recording::{
    BoundedMeasurementTable, MeasurementAttribution, MeasurementOmission, MeasurementTableLimits,
};

mod aggregate;
mod counter;
mod histogram;
mod ratio;
mod state;
mod summary;
mod window;
pub use window::MeasurementWindow;

pub use aggregate::{
    CheckedMeasurementAggregate, MeasurementAggregate, MeasurementInterval,
    MeasurementIntervalError, MeasurementMeanError, MeasurementRecordError,
};
pub use counter::{MeasurementCounter, MeasurementCounterError};
pub use histogram::{
    HistogramBoundsError, HistogramMergeError, HistogramQueryError, HistogramRange,
    MeasurementHistogram, validate_histogram_bounds,
};
pub use ratio::{MeasurementRatioError, checked_scaled_ratio, checked_scaled_ratio_nearest};
pub use state::MeasurementStateError;
pub use summary::MeasurementSummary;

// One owner for tracked overflow; flags never infer loss from the numeric cap.
const fn add_count(value: &mut u64, overflowed: &mut bool, increment: u64) {
    if let Some(next) = value.checked_add(increment) {
        *value = next;
    } else {
        *value = u64::MAX;
        *overflowed = true;
    }
}

// Wide totals can represent every admitted u64 observation while count is exact.
const fn add_total(value: &mut u128, overflowed: &mut bool, increment: u128) {
    if let Some(next) = value.checked_add(increment) {
        *value = next;
    } else {
        *value = u128::MAX;
        *overflowed = true;
    }
}
