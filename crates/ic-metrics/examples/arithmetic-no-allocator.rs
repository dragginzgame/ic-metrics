//! Link fixture for default arithmetic without a Wasm allocator or standard library.
//! The qualification command retains all generated code, including this entrypoint.

#![cfg_attr(target_family = "wasm", no_std)]
#![cfg_attr(target_family = "wasm", no_main)]
#![forbid(unsafe_code)]

use ic_metrics::{
    CheckedMeasurementAggregate, MeasurementAggregate, MeasurementCounter, MeasurementHistogram,
    MeasurementSummary, MeasurementWindow, checked_scaled_ratio, checked_scaled_ratio_nearest,
};

/// Exercise arithmetic with runtime input so constant folding cannot replace the work.
#[must_use]
pub fn arithmetic(input: u64) -> Option<u128> {
    let mut aggregate = MeasurementAggregate::EMPTY;
    aggregate.record(input);
    let previous = aggregate;
    aggregate.record(0);
    aggregate.merge(previous);
    let interval = aggregate.interval_since(previous).ok()?;

    let mut wide = CheckedMeasurementAggregate::EMPTY;
    wide.try_record(u128::from(input)).ok()?;
    let mut counter = MeasurementCounter::ZERO;
    counter.add(wide.total());
    let mut summary = MeasurementSummary::EMPTY;
    summary.record(input);
    let mut histogram = MeasurementHistogram::new([10, 100]).ok()?;
    histogram.record(input);
    let mut other = MeasurementHistogram::new([10, 100]).ok()?;
    other.record(0);
    histogram.merge(&other).ok()?;
    let quantile = histogram.quantile_bucket(1, 2).ok()??;
    let restored = MeasurementAggregate::from_parts(
        aggregate.samples(),
        aggregate.total(),
        aggregate.maximum(),
        aggregate.samples_overflowed(),
        aggregate.total_overflowed(),
    )
    .ok()?;
    let mut window = MeasurementWindow::new(restored);
    window.reset(summary.aggregate());

    Some(
        checked_scaled_ratio(counter.total(), 3, 10).ok()?
            + checked_scaled_ratio_nearest(wide.total(), 3, 10).ok()?
            + aggregate.scaled_mean(10).ok()??
            + interval.total()
            + u128::from(histogram.cumulative_count(0).ok()?)
            + u128::from(quantile.upper_inclusive().unwrap_or(u64::MAX))
            + window.state().total(),
    )
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    assert!(arithmetic(7).is_some());
}

// The fixture must provide its own abort boundary, with no std or allocator.
#[cfg(target_family = "wasm")]
#[panic_handler]
fn panic(_: &core::panic::PanicInfo<'_>) -> ! {
    loop {}
}
