use crate::{
    MeasurementAggregate as Aggregate, MeasurementHistogram as Histogram,
    MeasurementStateError as Error,
};

extern crate std;

use num_bigint::BigUint;

#[test]
fn overflow_bucket_flag_admission_preserves_typed_priority() {
    for overflow in [0, 1, u64::MAX - 1] {
        assert_eq!(
            Histogram::from_parts([], [], overflow, [], true, Aggregate::EMPTY),
            Err(Error::InvalidOverflowFlag)
        );
        for flags in [[false; 2], [true, false], [false, true]] {
            assert_eq!(
                Histogram::from_parts([0, 1], [0; 2], overflow, flags, true, Aggregate::EMPTY),
                Err(Error::InvalidOverflowFlag)
            );
        }
    }
}

#[test]
fn histogram_restoration_preserves_distribution_and_rejects_disagreement() {
    let mut original = Histogram::new([0, 10]).unwrap();
    for value in [0, 0, 5, 11] {
        original.record(value);
    }
    let restored = Histogram::from_parts(
        *original.upper_bounds(),
        *original.bucket_counts(),
        original.overflow(),
        *original.bucket_overflowed(),
        original.overflow_count_overflowed(),
        original.aggregate(),
    )
    .unwrap();
    assert_eq!(restored, original);
    assert_eq!(
        Histogram::from_parts([0, 10], [1, 1], 1, [false; 2], false, original.aggregate()),
        Err(Error::InvalidDistribution)
    );
    assert_eq!(
        Histogram::from_parts([0, 0], [2, 1], 1, [false; 2], false, original.aggregate()),
        Err(Error::InvalidBounds)
    );
    assert_eq!(
        Histogram::from_parts(
            [0, 10],
            [2, 1],
            1,
            [true, false],
            false,
            original.aggregate()
        ),
        Err(Error::InvalidOverflowFlag)
    );
    let zero = Aggregate::from_parts(1, 0, Some(0), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([0, 10], [0, 1], 0, [false; 2], false, zero),
        Err(Error::InvalidDistribution)
    );
}

#[test]
fn zero_bound_histogram_and_bucket_count_overflow_restore() {
    let mut original = Histogram::new([]).unwrap();
    original.record(0);
    assert_eq!(
        Histogram::from_parts([], [], 1, [], false, original.aggregate()),
        Ok(original)
    );
    let exact = Aggregate::from_parts(u64::MAX, 0, Some(0), false, false).unwrap();
    // A lost bucket cannot enter a histogram with an exact aggregate count.
    assert_eq!(
        Histogram::from_parts([0], [u64::MAX], 0, [true], false, exact),
        Err(Error::InvalidDistribution)
    );
    assert_eq!(
        Histogram::from_parts([], [], u64::MAX, [], true, exact),
        Err(Error::InvalidDistribution)
    );
    let aggregate = Aggregate::from_parts(u64::MAX, 0, Some(0), true, false).unwrap();
    let value = Histogram::from_parts([0], [u64::MAX], 0, [true], false, aggregate).unwrap();
    assert!(value.bucket_overflowed()[0]);
}

#[test]
fn histogram_admission_preserves_error_priority_and_closed_maximum_bound() {
    let aggregate = Aggregate::from_parts(1, 1, Some(1), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([1, 1], [0, 0], 0, [true; 2], true, aggregate),
        Err(Error::InvalidBounds)
    );
    assert_eq!(
        Histogram::from_parts([0, 1], [0, 0], 0, [true; 2], false, aggregate),
        Err(Error::InvalidOverflowFlag)
    );
    let maximum =
        Aggregate::from_parts(1, u128::from(u64::MAX), Some(u64::MAX), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([u64::MAX], [0], 1, [false], false, maximum),
        Err(Error::InvalidDistribution)
    );
}

#[test]
fn histogram_range_totals_reject_impossible_observations() {
    let high = Aggregate::from_parts(2, 20, Some(10), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([0, 10], [1, 1], 0, [false; 2], false, high),
        Err(Error::InvalidDistribution)
    );
    let low = Aggregate::from_parts(2, 10, Some(10), false, false).unwrap();
    assert_eq!(
        Histogram::from_parts([0, 10], [0, 2], 0, [false; 2], false, low),
        Err(Error::InvalidDistribution)
    );
    let impossible = Aggregate::from_parts(u64::MAX, u128::MAX, Some(2), true, true).unwrap();
    assert_eq!(
        Histogram::from_parts([1, 2], [1, u64::MAX], 0, [false; 2], false, impossible),
        Err(Error::InvalidDistribution)
    );
}

fn check_histogram_restoration<const N: usize>(bounds: [u64; N]) {
    // Build a reachable-state oracle from raw sequences, without using record()
    // or reproducing the admission formulas for count/total ranges.
    for samples in 0..=4_u32 {
        let mut reachable = std::collections::BTreeSet::new();
        for mut sequence in 0..4_u64.pow(samples) {
            let mut counts = [0_u64; N];
            let mut overflow = 0_u64;
            let mut total = 0_u128;
            let mut maximum = None;
            for _ in 0..samples {
                let value = sequence % 4;
                sequence /= 4;
                total += u128::from(value);
                maximum = Some(maximum.map_or(value, |previous: u64| previous.max(value)));
                if let Some(index) = bounds.iter().position(|bound| value <= *bound) {
                    counts[index] += 1;
                } else {
                    overflow += 1;
                }
            }
            reachable.insert((counts, overflow, total, maximum));
        }
        // Also enumerate unreachable distributions, including incorrect count
        // sums, impossible totals and a maximum in an unoccupied bucket.
        for mut distribution in 0..5_usize.pow(u32::try_from(N + 1).unwrap()) {
            let counts = core::array::from_fn(|_| {
                let count = u64::try_from(distribution % 5).unwrap();
                distribution /= 5;
                count
            });
            let overflow = u64::try_from(distribution).unwrap();
            for total in 0..=u128::from(samples) * 3 {
                for maximum in core::iter::once(None).chain((0..=3).map(Some)) {
                    let Ok(aggregate) =
                        Aggregate::from_parts(u64::from(samples), total, maximum, false, false)
                    else {
                        continue;
                    };
                    let restored = Histogram::from_parts(
                        bounds, counts, overflow, [false; N], false, aggregate,
                    );
                    assert_eq!(
                        restored.is_ok(),
                        reachable.contains(&(counts, overflow, total, maximum)),
                        "bounds={bounds:?}, counts={counts:?}, overflow={overflow}, \
                         samples={samples}, total={total}, maximum={maximum:?}"
                    );
                }
            }
        }
    }
}

#[test]
fn histogram_restoration_matches_independent_bounded_sequences() {
    check_histogram_restoration([]);
    check_histogram_restoration([0]);
    check_histogram_restoration([u64::MAX]);
    check_histogram_restoration([0, 1]);
    check_histogram_restoration([1, 2]);
    check_histogram_restoration([0, 3]);
    check_histogram_restoration([0, u64::MAX]);
}

fn check_weighted_histogram_merges<const N: usize>(bounds: [u64; N]) {
    let values = [0, 1, 2, u64::MAX - 1, u64::MAX];
    let count_cap = BigUint::from(u64::MAX);
    let total_cap = BigUint::from(u128::MAX);
    let check = |histogram: &Histogram<N>, weights: &[BigUint; 5]| {
        // The model retains exact multiplicities of actual observations. It
        // neither saturates during accumulation nor repeats admission ranges.
        let mut samples = BigUint::default();
        let mut total = BigUint::default();
        let mut buckets: [BigUint; N] = core::array::from_fn(|_| BigUint::default());
        let mut overflow = BigUint::default();
        let mut maximum = None;
        for (value, weight) in values.into_iter().zip(weights) {
            if weight.bits() == 0 {
                continue;
            }
            samples += weight;
            total += BigUint::from(value) * weight;
            maximum = Some(maximum.map_or(value, |previous: u64| previous.max(value)));
            if let Some(index) = bounds.iter().position(|bound| value <= *bound) {
                buckets[index] += weight;
            } else {
                overflow += weight;
            }
        }
        let aggregate = Aggregate::from_parts(
            u64::try_from(&samples).unwrap_or(u64::MAX),
            u128::try_from(&total).unwrap_or(u128::MAX),
            maximum,
            samples > count_cap,
            total > total_cap,
        )
        .unwrap();
        let counts = buckets
            .each_ref()
            .map(|count| u64::try_from(count).unwrap_or(u64::MAX));
        let flags = buckets.each_ref().map(|count| count > &count_cap);
        let restored = Histogram::from_parts(
            bounds,
            counts,
            u64::try_from(&overflow).unwrap_or(u64::MAX),
            flags,
            overflow > count_cap,
            aggregate,
        )
        .unwrap();
        assert_eq!(
            histogram, &restored,
            "bounds={bounds:?}, weights={weights:?}"
        );
    };

    let mut combined = Histogram::new(bounds).unwrap();
    let mut combined_weights = core::array::from_fn(|_| BigUint::default());
    check(&combined, &combined_weights);
    for (index, value) in values.into_iter().enumerate() {
        let mut batch = Histogram::new(bounds).unwrap();
        batch.record(value);
        let mut weight = BigUint::from(1_u8);
        for bit in 0..=129 {
            let mut weights = core::array::from_fn(|_| BigUint::default());
            weights[index] = weight.clone();
            check(&batch, &weights);
            combined.merge(&batch).unwrap();
            combined_weights[index] += &weight;
            check(&combined, &combined_weights);

            // A maximum-valued batch of 2^64 observations plus one reaches
            // u128::MAX exactly; the next addition must mark actual loss.
            if bit == 64 {
                let mut continued = batch;
                for _ in 0..2 {
                    continued.record(value);
                    weights[index] += 1_u8;
                    check(&continued, &weights);
                }
            }
            let previous = batch;
            batch.merge(&previous).unwrap();
            weight <<= 1_usize;
        }
        // Recording must still update a distribution after count/total loss.
        combined.record(value);
        combined_weights[index] += 1_u8;
        check(&combined, &combined_weights);
    }
}

#[test]
fn histogram_merges_and_restoration_match_exact_weighted_observations() {
    check_weighted_histogram_merges([]);
    check_weighted_histogram_merges([0]);
    check_weighted_histogram_merges([u64::MAX]);
    check_weighted_histogram_merges([0, 1]);
    check_weighted_histogram_merges([0, 2, u64::MAX - 1]);
    check_weighted_histogram_merges([0, 1, 2, u64::MAX - 1, u64::MAX]);
}
