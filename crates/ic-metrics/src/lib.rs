//! Allocation-free measurement arithmetic for Internet Computer consumers.
//!
//! Values use one consumer-selected unit per aggregate. Consumers own sampling,
//! attribution, counter identity, reset windows and reporting. This crate does
//! not read platform counters or manufacture measurements. The library is
//! dependency-free and `no_std` on every target.

#![doc = include_str!("application.md")]
#![no_std]

mod histogram;
mod summary;

pub use histogram::{HistogramBoundsError, MeasurementHistogram};
pub use summary::{MeasurementMeanError, MeasurementSummary, checked_mean, record_sample};
