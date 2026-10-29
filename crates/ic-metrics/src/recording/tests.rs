use super::*;

fn table() -> BoundedMeasurementTable {
    BoundedMeasurementTable::new(MeasurementTableLimits {
        entries: 2,
        key_bytes: 4,
        total_key_bytes: 5,
    })
}

#[test]
fn bounded_recording_preserves_zero_repeats_and_wide_totals() {
    let mut table = table();
    assert_eq!(table.entries().len(), 0);
    assert_eq!(table.omitted().maximum(), None);
    assert_eq!(table.record("a", 0), MeasurementAttribution::Retained);
    table.record("a", u64::MAX);
    table.record("a", 1);
    let (key, value) = table.entries().next().unwrap();
    assert_eq!(key, "a");
    assert_eq!(value.samples(), 3);
    assert_eq!(value.total(), u128::from(u64::MAX) + 1);
    assert!(!value.total_overflowed());
    assert_eq!(table.retained_key_bytes(), 1);
}

#[test]
fn bounded_recording_refusals_account_once_without_retaining_keys() {
    let mut table = table();
    table.record("zz", 1);
    table.record("bbb", 2);
    assert_eq!(
        table.record("a", 3),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    assert_eq!(
        table.record("a", 4),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    assert_eq!(
        table.record("oversized", 0),
        MeasurementAttribution::Omitted(MeasurementOmission::KeyBytes)
    );
    assert_eq!(table.record("zz", 5), MeasurementAttribution::Retained);
    assert_eq!(
        table
            .entries()
            .map(|(key, _)| key)
            .collect::<alloc::vec::Vec<_>>(),
        ["bbb", "zz"]
    );
    assert_eq!(table.retained_key_bytes(), 5);
    assert_eq!(table.omitted().samples(), 3);
    assert_eq!(table.omitted().total(), 7);
    let retained: u128 = table.entries().map(|(_, value)| value.total()).sum();
    assert_eq!(retained + table.omitted().total(), 15);
}

#[test]
fn bounded_recording_checks_utf8_bytes_and_total_budget() {
    let mut table = table();
    table.record("éé", 1);
    assert_eq!(
        table.record("é", 2),
        MeasurementAttribution::Omitted(MeasurementOmission::TotalKeyBytes)
    );
    assert_eq!(
        table.record("ééé", 3),
        MeasurementAttribution::Omitted(MeasurementOmission::KeyBytes)
    );
    assert_eq!(table.record("x", 0), MeasurementAttribution::Retained);
    assert_eq!(table.retained_key_bytes(), 5);
    assert_eq!(table.entries().len(), 2);
    assert_eq!(table.omitted().total(), 5);
}

#[test]
fn bounded_recording_reset_preserves_policy_and_omitted_quality() {
    let mut table = table();
    table.record("zz", 4);
    table.record("bbb", 5);
    table.omitted =
        MeasurementAggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    table.record("oversized", 0);
    assert!(table.omitted().samples_overflowed());
    assert!(table.omitted().total_overflowed());
    let limits = table.limits();
    table.clear();
    assert_eq!(table.limits(), limits);
    assert_eq!(table.entries().len(), 0);
    assert_eq!(table.retained_key_bytes(), 0);
    assert_eq!(table.omitted(), MeasurementAggregate::EMPTY);
    assert_eq!(table.record("new", 0), MeasurementAttribution::Retained);
    assert_eq!(table.record("zz", 1), MeasurementAttribution::Retained);
    assert_eq!(table.retained_key_bytes(), 5);
    let retained: alloc::vec::Vec<_> = table.entries().collect();
    assert_eq!(retained[0].0, "new");
    assert_eq!(retained[0].1.samples(), 1);
    assert_eq!(retained[0].1.maximum(), Some(0));
    assert_eq!(retained[1].0, "zz");
    assert_eq!(retained[1].1.samples(), 1);
    assert_eq!(retained[1].1.total(), 1);
}

#[test]
fn bounded_recording_zero_byte_budgets_admit_only_the_empty_identity() {
    for (key_bytes, total_key_bytes, omission) in [
        (0, 0, MeasurementOmission::KeyBytes),
        (0, 4, MeasurementOmission::KeyBytes),
        (4, 0, MeasurementOmission::TotalKeyBytes),
    ] {
        let mut table = BoundedMeasurementTable::new(MeasurementTableLimits {
            entries: 2,
            key_bytes,
            total_key_bytes,
        });
        assert_eq!(table.record("", 0), MeasurementAttribution::Retained);
        assert_eq!(table.record("", 3), MeasurementAttribution::Retained);
        assert_eq!(
            table.record("a", 7),
            MeasurementAttribution::Omitted(omission)
        );
        assert_eq!(table.entries().len(), 1);
        let (key, aggregate) = table.entries().next().unwrap();
        assert_eq!(key, "");
        assert_eq!(aggregate.samples(), 2);
        assert_eq!(aggregate.total(), 3);
        assert_eq!(table.retained_key_bytes(), 0);
        assert_eq!(table.omitted().samples(), 1);
        assert_eq!(table.omitted().total(), 7);
    }
}

#[test]
fn bounded_recording_zero_capacity_is_explicit_omission() {
    let mut table = BoundedMeasurementTable::new(MeasurementTableLimits {
        entries: 0,
        key_bytes: usize::MAX,
        total_key_bytes: usize::MAX,
    });
    assert_eq!(
        table.record("", 0),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    assert_eq!(table.entries().len(), 0);
    assert_eq!(table.omitted().samples(), 1);
    assert_eq!(table.omitted().maximum(), Some(0));
}

#[test]
fn bounded_recording_overlapping_limits_preserve_reason_precedence() {
    for entries in [1, 2] {
        let mut table = BoundedMeasurementTable::new(MeasurementTableLimits {
            entries,
            key_bytes: 3,
            total_key_bytes: 1,
        });
        assert_eq!(table.record("a", 1), MeasurementAttribution::Retained);
        // This key fails the per-key and total-byte limits, and may also fail entries.
        assert_eq!(
            table.record("long", 2),
            MeasurementAttribution::Omitted(MeasurementOmission::KeyBytes)
        );
        let reason = if entries == 1 {
            MeasurementOmission::Entries
        } else {
            MeasurementOmission::TotalKeyBytes
        };
        assert_eq!(
            table.record("bb", 3),
            MeasurementAttribution::Omitted(reason)
        );
        assert_eq!(table.record("a", 4), MeasurementAttribution::Retained);
        assert_eq!(table.entries().len(), 1);
        assert_eq!(table.entries().next().unwrap().1.total(), 5);
        assert_eq!(table.retained_key_bytes(), 1);
        assert_eq!(table.omitted().samples(), 2);
        assert_eq!(table.omitted().total(), 5);
    }
}

#[test]
fn bounded_recording_borrowed_snapshot_matches_an_unbounded_reference() {
    let mut table = table();
    let mut expected = MeasurementAggregate::EMPTY;
    for i in 0..2000_u64 {
        let key = ["a", "bb", "new", "too-long", "é"][usize::try_from(i % 5).unwrap()];
        table.record(key, i);
        expected.record(i);
        assert!(table.entries().len() <= table.limits().entries);
        assert!(table.retained_key_bytes() <= table.limits().total_key_bytes);
    }
    let mut combined = table.omitted();
    for (_, value) in table.entries() {
        combined.merge(value);
    }
    assert_eq!(combined, expected);
}
