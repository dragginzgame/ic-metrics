//! Exact scaled projections of already admitted numeric measurements.

use core::fmt;

#[cfg(test)]
mod tests;

/// Why an exact scaled ratio cannot be represented.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementRatioError {
    /// Division by zero has no defined ratio, including for a zero numerator.
    ZeroDenominator,
    /// The scaled result with the selected rounding exceeds `u128::MAX`.
    Overflow,
}

impl fmt::Display for MeasurementRatioError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::ZeroDenominator => "measurement ratio denominator is zero",
            Self::Overflow => "scaled measurement ratio exceeds u128",
        })
    }
}

impl core::error::Error for MeasurementRatioError {}

/// Compute `floor(numerator * scale / denominator)` without floating point.
///
/// The wide numerator supports exact accumulated totals; the denominator and
/// scale are `u64`. For example, scale 10 reports tenths of a mean, while scale
/// `10_000` reports a proportion in basis points. A nonzero denominator with zero
/// numerator or scale returns zero. Only the final answer must fit in `u128`:
/// an overflowing intermediate product does not reject a representable result.
///
/// Inputs must already be exact and comparable. This function does not establish
/// units, sample/window identity, or overflow provenance. In particular, it
/// accepts `u128::MAX` as an exact input; never pass an overflowed diagnostic total
/// as though it were exact. Empty measurement sets remain consumer-owned and
/// must be handled before calling with their zero sample count.
///
/// # Errors
///
/// Returns [`MeasurementRatioError::ZeroDenominator`] first when the denominator
/// is zero, otherwise [`MeasurementRatioError::Overflow`] if the answer exceeds
/// `u128::MAX`. Rounding is always down; no decimal formatting is performed.
///
/// ```
/// use ic_metrics::checked_scaled_ratio;
///
/// assert_eq!(checked_scaled_ratio(10, 3, 10), Ok(33)); // mean 3.3, in tenths
/// assert_eq!(checked_scaled_ratio(1, 4, 10_000), Ok(2_500)); // 25%, in basis points
/// assert_eq!(checked_scaled_ratio(u128::MAX, 10, 10), Ok(u128::MAX));
/// ```
pub const fn checked_scaled_ratio(
    numerator: u128,
    denominator: u64,
    scale: u64,
) -> Result<u128, MeasurementRatioError> {
    if denominator == 0 {
        return Err(MeasurementRatioError::ZeroDenominator);
    }
    let denominator = denominator as u128;
    let scale = scale as u128;
    let Some(whole) = (numerator / denominator).checked_mul(scale) else {
        return Err(MeasurementRatioError::Overflow);
    };
    // Remainder and scale are at most u64::MAX, so this product fits in u128.
    let fraction = (numerator % denominator) * scale / denominator;
    match whole.checked_add(fraction) {
        Some(value) => Ok(value),
        None => Err(MeasurementRatioError::Overflow),
    }
}

/// Compute the nearest scaled integer ratio, rounding exact halves upward.
///
/// Like [`checked_scaled_ratio`], the numerator is `u128` and denominator/scale
/// are `u64`. Inputs must be exact and comparable; units, input quality and empty
/// measurements remain caller-owned. Only the rounded answer must fit `u128`.
/// No floating point or allocation is used. The floor-only API is unchanged.
///
/// # Errors
///
/// Returns [`MeasurementRatioError::ZeroDenominator`] first, including at zero
/// scale; otherwise [`MeasurementRatioError::Overflow`] when the floor or its
/// rounded increment cannot fit `u128`.
///
/// ```
/// use ic_metrics::checked_scaled_ratio_nearest;
///
/// assert_eq!(checked_scaled_ratio_nearest(1, 6, 1000), Ok(167));
/// assert_eq!(checked_scaled_ratio_nearest(1, 2, 1), Ok(1));
/// assert_eq!(checked_scaled_ratio_nearest(u128::MAX, 10, 10), Ok(u128::MAX));
/// ```
pub const fn checked_scaled_ratio_nearest(
    numerator: u128,
    denominator: u64,
    scale: u64,
) -> Result<u128, MeasurementRatioError> {
    let floor = match checked_scaled_ratio(numerator, denominator, scale) {
        Ok(value) => value,
        Err(error) => return Err(error),
    };
    let denominator = denominator as u128;
    // Both factors are bounded by u64::MAX, so this product fits u128.
    let remainder = ((numerator % denominator) * scale as u128) % denominator;
    let half = denominator / 2 + denominator % 2;
    if remainder < half {
        return Ok(floor);
    }
    match floor.checked_add(1) {
        Some(value) => Ok(value),
        None => Err(MeasurementRatioError::Overflow),
    }
}
