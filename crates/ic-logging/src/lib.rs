//! Bounded caller-owned logs with explicit time, retention and scan limits.
//!
//! The heap engine owns no global recorder, endpoint, clock, timer or lifecycle.
//! See the package guide for paging and retention semantics.

#![doc = include_str!("../README.md")]
#![no_std]

extern crate alloc;

mod log;

pub use log::{
    AppendError, Entry, EntryInput, Filter, Label, Level, Limits, Log, Page, PageRequest,
    RetentionBatch,
};
