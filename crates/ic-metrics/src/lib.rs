//! Allocation-free measurement arithmetic for Internet Computer consumers.
//!
//! Values use one consumer-selected unit per aggregate. Consumers own sampling,
//! attribution, counter identity, reset windows and reporting. This crate does
//! not read an IC counter or manufacture measurements on native hosts.

#![no_std]

mod summary;

pub use summary::{MeasurementSummary, record_sample};
