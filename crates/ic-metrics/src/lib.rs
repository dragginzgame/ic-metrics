//! Allocation-free measurement arithmetic for Internet Computer consumers.
//!
//! Values use one consumer-selected unit per aggregate. Consumers own sampling,
//! attribution, counter identity, reset windows and reporting. This crate does
//! not read platform counters or manufacture measurements. The library is
//! dependency-free and `no_std` on every target.

#![doc = include_str!("application.md")]
#![no_std]

mod aggregate;
mod counter;
mod histogram;
mod ratio;
mod sample_statistics;
mod state;
mod summary;

pub use aggregate::{
    MeasurementAggregate, MeasurementInterval, MeasurementIntervalError, MeasurementMeanError,
};
pub use counter::{MeasurementCounter, MeasurementCounterError};
pub use histogram::{
    HistogramBoundsError, HistogramMergeError, HistogramQueryError, HistogramRange,
    MeasurementHistogram,
};
pub use ratio::{MeasurementRatioError, checked_scaled_ratio, checked_scaled_ratio_nearest};
pub use sample_statistics::{SampleStatistics, SampleStatisticsError, summarize_samples};
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
