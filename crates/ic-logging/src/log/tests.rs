use super::*;

fn positive(value: usize) -> NonZeroUsize {
    NonZeroUsize::new(value).expect("positive fixture value")
}

fn log(capacity: usize, message_bytes: usize) -> Log {
    Log::new(Limits {
        max_entries: positive(capacity),
        max_message_bytes: message_bytes,
        max_label_bytes: 16,
    })
}

fn input(created_at_secs: u64, message: &str) -> EntryInput<'_> {
    EntryInput {
        created_at_secs,
        level: Level::Info,
        source: "worker",
        topic: Some("delivery"),
        message,
    }
}

fn request(before: Option<u64>, results: usize, scanned: usize) -> PageRequest {
    PageRequest {
        before,
        max_results: positive(results),
        max_scanned: positive(scanned),
    }
}

fn sequences(log: &Log) -> Vec<u64> {
    log.page(Filter::default(), request(None, 100, 100))
        .entries
        .iter()
        .map(|entry| entry.sequence)
        .collect()
}

#[test]
fn count_eviction_keeps_newest_rows_and_never_reuses_sequence_ids() {
    let mut log = log(2, 32);
    for time in 0..5 {
        assert_eq!(log.append(input(time, "message")), Ok(time));
    }
    assert_eq!(log.len(), 2);
    assert_eq!(sequences(&log), [4, 3]);
    assert_eq!(log.prune_expired(10, 0, 2).removed, 2);
    assert!(log.is_empty());
    assert_eq!(log.append(input(10, "new")), Ok(5));
}

#[test]
fn oversized_source_and_topic_refuse_before_eviction_or_identity_consumption() {
    let mut log = log(1, 32);
    log.append(input(10, "retained")).unwrap();
    let oversized = "x".repeat(17);
    for label in [Label::Source, Label::Topic] {
        let mut rejected = input(11, "rejected");
        match label {
            Label::Source => rejected.source = &oversized,
            Label::Topic => rejected.topic = Some(&oversized),
        }
        assert_eq!(
            log.append(rejected),
            Err(AppendError::LabelTooLong {
                label,
                actual_bytes: 17,
                max_bytes: 16,
            })
        );
        assert_eq!(sequences(&log), [0]);
        assert_eq!(log.entries[0].message, "retained");
    }
    assert_eq!(log.append(input(11, "accepted")), Ok(1));
}

#[test]
fn timestamp_regression_is_rejected_after_history_is_fully_pruned() {
    let mut log = log(2, 32);
    log.append(input(20, "first")).unwrap();
    assert_eq!(
        log.append(input(19, "invalid")),
        Err(AppendError::TimestampRegressed {
            previous: 20,
            current: 19,
        })
    );
    assert_eq!(sequences(&log), [0]);
    log.prune_expired(21, 0, 2);
    assert!(log.is_empty());
    assert_eq!(
        log.append(input(19, "invalid")),
        Err(AppendError::TimestampRegressed {
            previous: 20,
            current: 19,
        })
    );
    assert_eq!(log.append(input(20, "equal timestamp")), Ok(1));
}

#[test]
fn sequence_exhaustion_does_not_evict_or_reissue_an_identity() {
    let mut log = log(1, 32);
    log.next_sequence = Some(u64::MAX);
    assert_eq!(log.append(input(1, "last identity")), Ok(u64::MAX));
    assert_eq!(
        log.append(input(2, "rejected")),
        Err(AppendError::SequenceExhausted)
    );
    assert_eq!(sequences(&log), [u64::MAX]);
    log.prune_expired(3, 0, 1);
    assert_eq!(
        log.append(input(3, "rejected")),
        Err(AppendError::SequenceExhausted)
    );
    assert!(log.is_empty());
}

#[test]
fn messages_obey_byte_limits_at_every_utf8_boundary() {
    let message = "é🦀界 some long diagnostic text with more 🦀";
    for max_bytes in 0..=message.len() + 1 {
        let mut log = log(1, max_bytes);
        log.append(input(1, message)).unwrap();
        let retained = &log.entries[0];
        assert!(retained.message.len() <= max_bytes);
        assert_eq!(retained.truncated, message.len() > max_bytes);
        if !retained.truncated {
            assert_eq!(retained.message, message);
        } else if max_bytes > TRUNCATION_SUFFIX.len() {
            let prefix = retained.message.strip_suffix(TRUNCATION_SUFFIX).unwrap();
            assert!(message.starts_with(prefix));
        } else {
            assert!(message.starts_with(&retained.message));
        }
    }
}

#[test]
fn label_limits_measure_bytes_and_accept_the_exact_boundary() {
    let mut log = Log::new(Limits {
        max_entries: positive(1),
        max_message_bytes: 0,
        max_label_bytes: 4,
    });
    let mut entry = input(1, "no message bytes");
    entry.source = "🦀";
    entry.topic = Some("éé");
    log.append(entry).unwrap();
    assert_eq!(log.entries[0].message, "");
    assert!(log.entries[0].truncated);
    entry.topic = Some("ééx");
    assert_eq!(
        log.append(entry),
        Err(AppendError::LabelTooLong {
            label: Label::Topic,
            actual_bytes: 5,
            max_bytes: 4,
        })
    );
}

#[test]
fn strict_age_retention_obeys_batch_limits_and_reports_remaining_work() {
    let mut log = log(4, 32);
    for time in [10, 11, 12] {
        log.append(input(time, "entry")).unwrap();
    }
    assert_eq!(log.next_expiry_secs(5), Some(16));
    assert_eq!(
        log.prune_expired(15, 5, 10),
        RetentionBatch {
            removed: 0,
            more_due: false
        }
    );
    assert_eq!(
        log.prune_expired(18, 5, 0),
        RetentionBatch {
            removed: 0,
            more_due: true
        }
    );
    assert_eq!(
        log.prune_expired(18, 5, 2),
        RetentionBatch {
            removed: 2,
            more_due: true
        }
    );
    assert_eq!(log.next_expiry_secs(5), Some(18));
    assert_eq!(
        log.prune_expired(18, 5, 2),
        RetentionBatch {
            removed: 1,
            more_due: false
        }
    );
    assert_eq!(log.next_expiry_secs(5), None);
}

#[test]
fn overflowing_deadlines_never_expire_early() {
    let mut log = log(2, 32);
    assert_eq!(log.next_expiry_secs(1), None);
    log.append(input(u64::MAX - 1, "entry")).unwrap();
    assert_eq!(log.next_expiry_secs(0), Some(u64::MAX));
    assert_eq!(log.next_expiry_secs(1), None);
    assert_eq!(log.prune_expired(u64::MAX, 1, 2).removed, 0);
    assert_eq!(log.prune_expired(u64::MAX, 0, 2).removed, 1);
    log.append(input(u64::MAX, "last second")).unwrap();
    assert_eq!(log.next_expiry_secs(0), None);
    assert_eq!(log.prune_expired(u64::MAX, 0, 2).removed, 0);
}

#[test]
fn empty_filtered_pages_still_advance_the_scan_cursor() {
    let mut log = log(5, 32);
    for time in 0..5 {
        let mut entry = input(time, "entry");
        entry.level = if time == 0 { Level::Error } else { Level::Info };
        log.append(entry).unwrap();
    }
    let filter = Filter {
        min_level: Some(Level::Warn),
        ..Filter::default()
    };
    let first = log.page(filter, request(None, 1, 2));
    assert_eq!(first.entries.len(), 0);
    assert_eq!(first.scanned, 2);
    assert_eq!(first.next_before, Some(3));
    let second = log.page(filter, request(first.next_before, 1, 2));
    assert_eq!(second.entries.len(), 0);
    assert_eq!(second.next_before, Some(1));
    let third = log.page(filter, request(second.next_before, 1, 2));
    assert_eq!(third.entries[0].sequence, 0);
    assert_eq!(third.scanned, 1);
    assert_eq!(third.next_before, None);
}

#[test]
fn result_limits_stop_scanning_without_skipping_older_matches() {
    let mut log = log(4, 32);
    for time in 0..4 {
        log.append(input(time, "entry")).unwrap();
    }
    let first = log.page(Filter::default(), request(None, 2, 4));
    assert_eq!(
        first
            .entries
            .iter()
            .map(|row| row.sequence)
            .collect::<Vec<_>>(),
        [3, 2]
    );
    assert_eq!(first.scanned, 2);
    let next = log.page(Filter::default(), request(first.next_before, 2, 4));
    assert_eq!(
        next.entries
            .iter()
            .map(|row| row.sequence)
            .collect::<Vec<_>>(),
        [1, 0]
    );
    assert_eq!(next.next_before, None);
}

#[test]
fn cursor_positioning_handles_evicted_rows_and_all_range_edges() {
    let mut log = log(2, 32);
    for time in 0..4 {
        log.append(input(time, "entry")).unwrap();
    }
    for before in [0, 1, 2] {
        let page = log.page(Filter::default(), request(Some(before), 3, 3));
        assert_eq!(page.entries.len(), 0);
        assert_eq!(page.scanned, 0);
        assert_eq!(page.next_before, None);
    }
    let page = log.page(Filter::default(), request(Some(3), 3, 3));
    assert_eq!(page.entries[0].sequence, 2);
    assert_eq!(
        log.page(Filter::default(), request(Some(u64::MAX), 3, 3))
            .entries
            .len(),
        2
    );
}

#[test]
fn paged_filtering_matches_reference_after_count_eviction_and_deque_wraparound() {
    for capacity in 1..=8 {
        let mut log = log(capacity, 32);
        for time in 0..24 {
            let mut entry = input(time, "entry");
            if time % 2 == 0 {
                entry.source = "other";
            }
            if time % 3 == 0 {
                entry.level = Level::Warn;
            }
            if time % 5 == 0 {
                entry.topic = None;
            }
            log.append(entry).unwrap();
        }
        let expected: Vec<_> = ((24 - capacity as u64)..24)
            .rev()
            .filter(|time| time % 2 != 0 && time % 3 == 0 && time % 5 != 0)
            .collect();
        for scan_limit in 1..=4 {
            let filter = Filter {
                source: Some("worker"),
                topic: Some("delivery"),
                min_level: Some(Level::Warn),
            };
            let mut observed = Vec::new();
            let mut before = None;
            loop {
                let page = log.page(filter, request(before, 2, scan_limit));
                assert!(page.scanned <= scan_limit);
                assert!(page.entries.len() <= 2);
                observed.extend(page.entries.iter().map(|entry| entry.sequence));
                if page.next_before.is_none() {
                    break;
                }
                assert!(before.is_none_or(|cursor| page.next_before.unwrap() < cursor));
                before = page.next_before;
            }
            assert_eq!(observed, expected);
        }
    }
}
