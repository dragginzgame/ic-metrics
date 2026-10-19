use super::{MeasurementRatioError, checked_scaled_ratio, checked_scaled_ratio_nearest};

use num_bigint::BigUint;

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

#[test]
fn nearest_agrees_with_independent_small_integer_reference() {
    const HALF: Result<u128, MeasurementRatioError> = checked_scaled_ratio_nearest(1, 2, 1);
    assert_eq!(HALF, Ok(1));
    for numerator in 0..=100_u128 {
        for denominator in 1..=20_u64 {
            for scale in [0, 1, 10, 100] {
                assert_eq!(
                    checked_scaled_ratio_nearest(numerator, denominator, scale),
                    Ok(
                        (numerator * u128::from(scale) + u128::from(denominator) / 2)
                            / u128::from(denominator)
                    ),
                );
            }
        }
    }
}

#[test]
fn nearest_preserves_zero_precedence_and_exact_caps() {
    for numerator in [0, 1, u128::MAX] {
        for scale in [0, 1, u64::MAX] {
            assert_eq!(
                checked_scaled_ratio_nearest(numerator, 0, scale),
                Err(MeasurementRatioError::ZeroDenominator)
            );
        }
    }
    assert_eq!(checked_scaled_ratio_nearest(u128::MAX, 1, 0), Ok(0));
    for divisor in [1, 10, u64::MAX] {
        assert_eq!(
            checked_scaled_ratio_nearest(u128::MAX, divisor, divisor),
            Ok(u128::MAX)
        );
    }
    assert_eq!(
        checked_scaled_ratio_nearest(u128::MAX, 1, 2),
        Err(MeasurementRatioError::Overflow)
    );
    let rounded_overflow = (u128::MAX / 7) * 6 + 3;
    assert_eq!(checked_scaled_ratio(rounded_overflow, 6, 7), Ok(u128::MAX));
    assert_eq!(
        checked_scaled_ratio_nearest(rounded_overflow, 6, 7),
        Err(MeasurementRatioError::Overflow)
    );
}

fn check_wide_ratio_reference(numerator: u128, denominator: u64, scale: u64) {
    let results = [
        checked_scaled_ratio(numerator, denominator, scale),
        checked_scaled_ratio_nearest(numerator, denominator, scale),
    ];
    if denominator == 0 {
        assert_eq!(results, [Err(MeasurementRatioError::ZeroDenominator); 2]);
        return;
    }
    // Multiply first in an independent arbitrary-precision implementation.
    // The product may need 192 bits; no production quotient decomposition is used.
    let product = BigUint::from(numerator) * BigUint::from(scale);
    let divisor = BigUint::from(denominator);
    let expected = [
        &product / &divisor,
        (&product + BigUint::from(denominator / 2)) / &divisor,
    ];
    for (actual, exact) in results.into_iter().zip(expected) {
        assert_eq!(
            actual,
            u128::try_from(exact).map_err(|_| MeasurementRatioError::Overflow),
            "numerator={numerator}, denominator={denominator}, scale={scale}"
        );
    }
}

#[test]
fn ratios_match_independent_full_width_integer_reference() {
    let factors = [0, 1, 2, 3, 6, 7, 10, 1 << 32, u64::MAX - 1, u64::MAX];
    for bit in 0..128 {
        let pivot = 1_u128 << bit;
        for numerator in [pivot - 1, pivot, pivot + 1, u128::MAX] {
            for denominator in factors {
                for scale in factors {
                    check_wide_ratio_reference(numerator, denominator, scale);
                }
            }
        }
    }
    // A fixed deterministic sequence supplements the power-of-two boundaries
    // with mixed full-width bit patterns. It is not a sampling/performance API.
    let mut state = 0x243f_6a88_85a3_08d3_1319_8a2e_0370_7344_u128;
    let mut next = || {
        state ^= state << 23;
        state ^= state >> 17;
        state ^= state << 26;
        state
    };
    for _ in 0..4096 {
        let numerator = next();
        let denominator = u64::try_from(next() & u128::from(u64::MAX)).unwrap();
        let scale = u64::try_from(next() & u128::from(u64::MAX)).unwrap();
        check_wide_ratio_reference(numerator, denominator, scale);
    }
    // Rounding alone overflows after a representable floor; exact caps, ties
    // and zero-denominator precedence are also present in the boundary matrix.
    check_wide_ratio_reference((u128::MAX / 7) * 6 + 3, 6, 7);
}
