//! Text budgets, borrowed checkpoint boundaries and visitor continuation.

use super::{input, log, request, sequences};
use crate::{
    AppendError, AppendReceipt, EntryInput, Filter, Level, Limits, Log, PageScan, RestoreError,
    TopicMatch,
};
use core::ops::ControlFlow;

fn bounded(capacity: usize, text_bytes: usize) -> Log {
    Log::new(Limits {
        max_text_bytes: text_bytes,
        ..log(capacity, 32).limits()
    })
}

fn text(time: u64, message: &str) -> EntryInput<'_> {
    EntryInput {
        source: "",
        topic: None,
        ..input(time, message)
    }
}

#[test]
fn byte_eviction_reports_every_removed_row_and_restores_accounting() {
    let mut log = bounded(10, 20);
    for time in 0..3 {
        log.append(text(time, "abc")).unwrap();
    }
    assert_eq!(log.retained_text_bytes(), 9);
    assert_eq!(
        log.append(text(3, "abcdefghijklmnopqr")),
        Ok(AppendReceipt {
            sequence: 3,
            truncated: false,
            evicted: 3,
        })
    );
    assert_eq!(log.retained_text_bytes(), 18);
    assert_eq!(sequences(&log), [3]);
    let mut log = Log::restore(log.into_snapshot()).unwrap();
    assert_eq!(log.retained_text_bytes(), 18);
    assert_eq!(log.append(text(4, "xy")).unwrap().evicted, 0);
    assert_eq!(log.retained_text_bytes(), 20);
    assert_eq!(log.prune_expired(5, 1, 1).removed, 1);
    assert_eq!(log.retained_text_bytes(), 2);
    log.prune_expired(6, 0, 1);
    assert_eq!(log.retained_text_bytes(), 0);
    assert_eq!(log.append(text(6, "last")).unwrap().sequence, 5);
}

#[test]
fn oversized_rows_refuse_atomically_and_utf8_uses_actual_retained_bytes() {
    let mut log = bounded(1, 28);
    log.append(text(10, "keep")).unwrap();
    let before = log.snapshot();
    assert_eq!(
        log.append(input(11, "123456789012345")),
        Err(AppendError::TextBudgetExceeded {
            required_bytes: 29,
            max_bytes: 28,
        })
    );
    assert_eq!(log.snapshot(), before);
    assert_eq!(log.retained_text_bytes(), 4);
    // Error priority still reports time/identity refusal before byte admission.
    assert!(matches!(
        log.append(input(9, "cannot fit either")),
        Err(AppendError::TimestampRegressed { .. })
    ));
    let mut limits = log.limits();
    limits.max_message_bytes = 15;
    let mut log = Log::new(limits);
    assert_eq!(
        log.append(input(11, "🦀🦀🦀🦀🦀")),
        Ok(AppendReceipt {
            sequence: 0,
            truncated: true,
            evicted: 0
        })
    );
    assert_eq!(log.retained_text_bytes(), 28);
    assert_eq!(log.snapshot().entries[0].message, "...[truncated]");
    let mut state = log.into_snapshot();
    state.limits.max_text_bytes = 27;
    assert_eq!(
        Log::restore(state).unwrap_err(),
        RestoreError::TextBudgetExceeded
    );
}

#[test]
fn zero_text_budget_keeps_metadata_and_count_evictions() {
    let mut log = Log::new(Limits {
        max_message_bytes: 0,
        ..bounded(1, 0).limits()
    });
    let first = log.append(text(1, "discarded message")).unwrap();
    assert!(first.truncated);
    assert_eq!(log.retained_text_bytes(), 0);
    assert_eq!(
        log.append(text(2, "")).unwrap(),
        AppendReceipt {
            sequence: 1,
            truncated: false,
            evicted: 1
        }
    );
    let log = Log::restore(log.into_snapshot()).unwrap();
    assert_eq!(log.retained_text_bytes(), 0);
}

#[test]
fn topic_absence_is_distinct_from_any_and_an_empty_present_label() {
    let mut log = bounded(3, 100);
    for (time, topic) in [None, Some(""), Some("delivery")].into_iter().enumerate() {
        let mut entry = text(time as u64, "message");
        entry.topic = topic;
        log.append(entry).unwrap();
    }
    for (topic, expected) in [
        (TopicMatch::Absent, &[0][..]),
        (TopicMatch::Exact(""), &[1][..]),
        (TopicMatch::Exact("delivery"), &[2][..]),
        (TopicMatch::Any, &[2, 1, 0][..]),
    ] {
        let page = log.page(
            Filter {
                topic,
                ..Filter::default()
            },
            request(None, 3, 3),
        );
        assert_eq!(
            page.entries
                .iter()
                .map(|entry| entry.sequence)
                .collect::<alloc::vec::Vec<_>>(),
            expected
        );
    }
}

#[test]
fn borrowed_checkpoint_keeps_order_text_buffers_and_empty_watermarks() {
    let mut log = bounded(3, 100);
    for time in 0..4 {
        log.append(text(time, "retained")).unwrap();
    }
    let view = log.checkpoint();
    assert_eq!(view.limits(), log.limits());
    assert_eq!(view.next_sequence(), Some(4));
    assert_eq!(view.last_created_at_secs(), Some(3));
    assert_eq!(view.entries().len(), 3);
    assert_eq!(
        view.entries()
            .map(|entry| entry.sequence)
            .collect::<alloc::vec::Vec<_>>(),
        [1, 2, 3]
    );
    for (borrowed, retained) in view.entries().zip(&log.entries) {
        assert!(core::ptr::eq(borrowed, retained));
        assert_eq!(borrowed.message.as_ptr(), retained.message.as_ptr());
    }
    let mut state = log.into_snapshot();
    state.entries.clear();
    state.next_sequence = None;
    let log = Log::restore(state).unwrap();
    assert_eq!(log.checkpoint().entries().len(), 0);
    assert_eq!(log.checkpoint().next_sequence(), None);
    assert_eq!(log.checkpoint().last_created_at_secs(), Some(3));
}

#[test]
fn visitor_stops_after_delivery_and_resumes_before_the_consumed_row() {
    let mut log = bounded(6, 100);
    for time in 0..6 {
        let mut entry = text(time, "entry");
        entry.level = if time % 2 == 0 {
            Level::Warn
        } else {
            Level::Debug
        };
        log.append(entry).unwrap();
    }
    let filter = Filter {
        min_level: Some(Level::Warn),
        ..Filter::default()
    };
    let first = log.visit_page(filter, request(None, 3, 6), |entry| {
        assert_eq!(entry.sequence, 4);
        ControlFlow::Break(())
    });
    assert_eq!(
        first,
        PageScan {
            matched: 1,
            scanned: 2,
            next_before: Some(4)
        }
    );
    let mut sequences = [u64::MAX; 2];
    let mut index = 0;
    let second = log.visit_page(filter, request(first.next_before, 2, 4), |entry| {
        sequences[index] = entry.sequence;
        index += 1;
        ControlFlow::Continue(())
    });
    assert_eq!(sequences, [2, 0]);
    assert_eq!(
        second,
        PageScan {
            matched: 2,
            scanned: 4,
            next_before: None
        }
    );
    let empty = log.visit_page(filter, request(None, 1, 1), |_| unreachable!());
    assert_eq!(
        empty,
        PageScan {
            matched: 0,
            scanned: 1,
            next_before: Some(5)
        }
    );
    let none = log.visit_page(
        Filter::default(),
        request(Some(0), 1, 1),
        |_| unreachable!(),
    );
    assert_eq!(
        none,
        PageScan {
            matched: 0,
            scanned: 0,
            next_before: None
        }
    );
}
