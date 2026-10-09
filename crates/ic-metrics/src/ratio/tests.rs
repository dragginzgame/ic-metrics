use super::{MeasurementRatioError, checked_scaled_ratio};

#[test]
fn projects_fractional_means_proportions_and_measured_zero() {
    for (numerator, denominator, scale, expected) in [
        (10, 3, 10, 33),
        (1, 4, 10_000, 2_500),
        (2, 3, 100, 66),
        (0, 1, 100, 0),
        (u128::MAX, 1, 0, 0),
        (9_007_199_254_740_993, 1, 1, 9_007_199_254_740_993),
    ] {
        assert_eq!(
            checked_scaled_ratio(numerator, denominator, scale),
            Ok(expected)
        );
    }
    for numerator in [0, 1, u128::MAX] {
        for scale in [0, 1, u64::MAX] {
            assert_eq!(
                checked_scaled_ratio(numerator, 0, scale),
                Err(MeasurementRatioError::ZeroDenominator)
            );
        }
    }
}

#[test]
fn rejects_only_unrepresentable_answers_not_intermediate_products() {
    for scale in [1, 10, u64::MAX] {
        assert_eq!(checked_scaled_ratio(u128::MAX, scale, scale), Ok(u128::MAX));
    }
    assert_eq!(
        checked_scaled_ratio(u128::MAX, u64::MAX, 1),
        Ok(u128::from(u64::MAX) + 2)
    );
    assert_eq!(
        checked_scaled_ratio(u128::MAX, 1, 2),
        Err(MeasurementRatioError::Overflow)
    );
    // Whole part fits, but adding the scaled remainder overflows the result.
    assert_eq!(
        checked_scaled_ratio(u128::MAX / 2 + 1, 3, 6),
        Err(MeasurementRatioError::Overflow)
    );
}

#[test]
fn agrees_with_direct_exact_arithmetic_for_small_inputs() {
    const TENTHS: Result<u128, MeasurementRatioError> = checked_scaled_ratio(10, 3, 10);
    for numerator in 0..=100_u128 {
        for denominator in 1..=20_u64 {
            for scale in [0, 1, 10, 100] {
                assert_eq!(
                    checked_scaled_ratio(numerator, denominator, scale),
                    Ok(numerator * u128::from(scale) / u128::from(denominator))
                );
            }
        }
    }
    assert_eq!(TENTHS, Ok(33));
}
