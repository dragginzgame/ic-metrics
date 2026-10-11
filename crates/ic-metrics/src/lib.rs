//! Allocation-free measurement arithmetic for Internet Computer consumers.
//!
//! Values use one consumer-selected unit per aggregate. Consumers own sampling,
//! attribution, counter identity, reset windows and reporting. This crate does
//! not read platform counters or manufacture measurements. The library is
//! dependency-free and `no_std` on every target.

#![doc = include_str!("application.md")]
#![no_std]

mod aggregate;
mod histogram;
mod ratio;
mod summary;

pub use aggregate::{MeasurementAggregate, MeasurementInterval, MeasurementIntervalError};
pub use histogram::{
    HistogramBoundsError, HistogramMergeError, HistogramQueryError, HistogramRange,
    MeasurementHistogram,
};
pub use ratio::{MeasurementRatioError, checked_scaled_ratio};
pub use summary::{MeasurementMeanError, MeasurementSummary, checked_mean, record_sample};

// One owner for tracked overflow; flags never infer loss from the numeric cap.
const fn add_count(value: &mut u64, saturated: &mut bool, increment: u64) {
    if let Some(next) = value.checked_add(increment) {
        *value = next;
    } else {
        *value = u64::MAX;
        *saturated = true;
    }
}
