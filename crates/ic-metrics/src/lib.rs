//! Allocation-free measurement arithmetic for Internet Computer consumers.
//!
//! Values use one consumer-selected unit per aggregate. Consumers own sampling,
//! attribution, counter identity, reset windows and reporting. This crate does
//! not manufacture measurements on native hosts. The default arithmetic core
//! is dependency-free. The opt-in `ic` feature exposes an IC call-context
//! instruction reader only on `wasm32-unknown-unknown`; its binding uses `std`.

#![no_std]

mod summary;

#[cfg(all(feature = "ic", target_arch = "wasm32", target_os = "unknown"))]
mod ic;

#[cfg(all(feature = "ic", target_arch = "wasm32", target_os = "unknown"))]
pub use ic::call_context_instructions;

pub use summary::{MeasurementSummary, record_sample};
