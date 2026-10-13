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
mod state;
mod summary;

pub use aggregate::{MeasurementAggregate, MeasurementInterval, MeasurementIntervalError};
pub use counter::{MeasurementCounter, MeasurementCounterError};
pub use histogram::{
    HistogramBoundsError, HistogramMergeError, HistogramQueryError, HistogramRange,
    MeasurementHistogram,
};
pub use ratio::{MeasurementRatioError, checked_scaled_ratio};
pub use state::MeasurementStateError;
pub use summary::{MeasurementMeanError, MeasurementSummary};

// One owner for tracked overflow; flags never infer loss from the numeric cap.
const fn add_count(value: &mut u64, saturated: &mut bool, increment: u64) {
    if let Some(next) = value.checked_add(increment) {
        *value = next;
    } else {
        *value = u64::MAX;
        *saturated = true;
    }
}

// Wide totals can represent every admitted u64 observation while count is exact.
const fn add_total(value: &mut u128, saturated: &mut bool, increment: u128) {
    if let Some(next) = value.checked_add(increment) {
        *value = next;
    } else {
        *value = u128::MAX;
        *saturated = true;
    }
}

// Preserve native-width division for ordinary windows; wide totals stay exact.
const fn mean_total(samples: u64, total: u128) -> Option<u128> {
    if total <= u64::MAX as u128 {
        // TryFrom is not const at the arithmetic support floor.
        #[expect(
            clippy::cast_possible_truncation,
            reason = "the branch admits a u64 total"
        )]
        let narrow = total as u64;
        match narrow.checked_div(samples) {
            Some(mean) => Some(mean as u128),
            None => None,
        }
    } else {
        total.checked_div(samples as u128)
    }
}
