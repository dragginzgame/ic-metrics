//! Exact scaled projections of already admitted numeric measurements.

use core::fmt;

#[cfg(test)]
mod tests;

/// Why an exact scaled ratio cannot be represented.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MeasurementRatioError {
    /// Division by zero has no defined ratio, including for a zero numerator.
    ZeroDenominator,
    /// The floor-rounded scaled result exceeds `u128::MAX`.
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
/// units, sample/window identity, or saturation provenance. In particular, it
/// accepts `u128::MAX` as an exact input; never pass a saturated diagnostic total
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
