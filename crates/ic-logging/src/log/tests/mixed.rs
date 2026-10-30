//! Independent event-history model for interactions across the public Log API.

use super::{input, log, request};
use crate::{
    AppendError, Entry, EntryInput, Filter, Label, Level, Log, LogSnapshot, RetentionBatch,
};
use Action::{
    Append, CopyRestore, MoveRestore, PruneAll, PruneNone, PruneOne, RegressedTime, SameTime,
    SourceTooLong, TopicTooLong,
};
use alloc::{string::String, vec::Vec};

#[derive(Clone, Copy)]
enum Action {
    Append,
    SameTime,
    SourceTooLong,
    TopicTooLong,
    RegressedTime,
    PruneOne,
    PruneNone,
    PruneAll,
    MoveRestore,
    CopyRestore,
}

// Keep every accepted event; retention only advances an index into this journal.
// This deliberately does not model the engine's deque or binary cursor search.
struct History {
    accepted: Vec<Entry>,
    removed: usize,
    next: Option<u64>,
    time: Option<u64>,
}

impl History {
    fn attempt(&mut self, actual: &mut Log, action: Action, step: usize) {
        let time = self.time.unwrap_or(10);
        let mut entry = input(
            time + u64::from(!matches!(action, Action::SameTime)),
            "é中🙂 diagnostic",
        );
        entry.level = if step.is_multiple_of(3) {
            Level::Warn
        } else {
            Level::Info
        };
        entry.source = if step.is_multiple_of(2) {
            "worker"
        } else {
            "other"
        };
        entry.topic = (!step.is_multiple_of(5)).then_some("delivery");
        let expected = match action {
            Action::SourceTooLong => {
                entry.source = "source-over-limit";
                entry.topic = Some("topic-is-over-limit");
                entry.created_at_secs = time - 1;
                Err(AppendError::LabelTooLong {
                    label: Label::Source,
                    actual_bytes: entry.source.len(),
                    max_bytes: 16,
                })
            }
            Action::TopicTooLong => {
                entry.topic = Some("topic-is-over-limit");
                entry.created_at_secs = time - 1;
                Err(AppendError::LabelTooLong {
                    label: Label::Topic,
                    actual_bytes: entry.topic.unwrap().len(),
                    max_bytes: 16,
                })
            }
            Action::RegressedTime => {
                entry.created_at_secs = time - 1;
                Err(AppendError::TimestampRegressed {
                    previous: time,
                    current: time - 1,
                })
            }
            _ => self.next.ok_or(AppendError::SequenceExhausted),
        };
        assert_eq!(actual.append(entry), expected);
        if expected.is_ok() {
            self.append(
                entry,
                actual.limits().max_entries.get(),
                actual.limits().max_message_bytes,
            );
        }
    }

    fn append(&mut self, input: EntryInput<'_>, capacity: usize, budget: usize) {
        let sequence = self.next.unwrap();
        let truncated = input.message.len() > budget;
        let marker = "...[truncated]";
        let suffix = if truncated && budget > marker.len() {
            marker
        } else {
            ""
        };
        let mut message = String::new();
        for character in input.message.chars() {
            if message.len() + character.len_utf8() > budget - suffix.len() {
                break;
            }
            message.push(character);
        }
        message.push_str(suffix);
        self.accepted.push(Entry {
            sequence,
            created_at_secs: input.created_at_secs,
            level: input.level,
            source: input.source.into(),
            topic: input.topic.map(String::from),
            message,
            truncated,
        });
        self.removed = self
            .removed
            .max(self.accepted.len().saturating_sub(capacity));
        self.next = sequence.checked_add(1);
        self.time = Some(input.created_at_secs);
    }

    fn retained(&self) -> &[Entry] {
        &self.accepted[self.removed..]
    }

    fn prune(&mut self, now: u64, age: u64, limit: usize) -> RetentionBatch {
        // Wide absolute deadlines avoid reusing the engine's saturating cutoff.
        let due = self
            .retained()
            .iter()
            .take_while(|entry| {
                u128::from(entry.created_at_secs) + u128::from(age) < u128::from(now)
            })
            .count();
        let removed = due.min(limit);
        self.removed += removed;
        RetentionBatch {
            removed,
            more_due: due > removed,
        }
    }

    fn check_page(
        &self,
        log: &Log,
        filter: Filter<'_>,
        before: Option<u64>,
        results: usize,
        scanned: usize,
    ) -> Option<u64> {
        let candidates: Vec<_> = self
            .retained()
            .iter()
            .rev()
            .filter(|entry| before.is_none_or(|before| entry.sequence < before))
            .collect();
        let window = &candidates[..scanned.min(candidates.len())];
        let matches: Vec<_> = window
            .iter()
            .enumerate()
            .filter(|(_, entry)| {
                filter.source.is_none_or(|source| entry.source == source)
                    && filter
                        .topic
                        .is_none_or(|topic| entry.topic.as_deref() == Some(topic))
                    && filter.min_level.is_none_or(|level| entry.level >= level)
            })
            .take(results)
            .collect();
        let consumed = if matches.len() == results {
            matches.last().unwrap().0 + 1
        } else {
            window.len()
        };
        let next = (consumed < candidates.len()).then(|| candidates[consumed - 1].sequence);
        let page = log.page(filter, request(before, results, scanned));
        assert_eq!(page.scanned, consumed);
        assert_eq!(page.next_before, next);
        assert_eq!(
            page.entries,
            matches.iter().map(|(_, entry)| **entry).collect::<Vec<_>>()
        );
        next
    }
}

#[test]
fn mixed_operations_match_independent_event_history() {
    // Include exhausted identities, UTF-8/suffix boundaries and one-row capacity.
    for start in [0, u64::MAX - 2] {
        for capacity in [1, 2, 5] {
            for budget in [0, 1, 13, 14, 15, 32] {
                let mut actual = log(capacity, budget);
                let mut model = History {
                    accepted: Vec::new(),
                    removed: 0,
                    next: Some(start),
                    time: (start != 0).then_some(10),
                };
                if start != 0 {
                    // An admitted empty history whose earlier rows have expired.
                    actual = Log::restore(LogSnapshot {
                        next_sequence: model.next,
                        last_created_at_secs: model.time,
                        ..actual.into_snapshot()
                    })
                    .unwrap();
                }
                let mut cursors = [None, None];
                // Repeated appends wrap storage; refusals also occur at capacity
                // and after complete pruning/restoration. Cursors survive edits.
                let operations = [
                    Append,
                    SameTime,
                    Append,
                    SourceTooLong,
                    TopicTooLong,
                    RegressedTime,
                    PruneNone,
                    MoveRestore,
                    Append,
                    Append,
                    PruneOne,
                    CopyRestore,
                    Append,
                    PruneAll,
                    RegressedTime,
                    SameTime,
                    MoveRestore,
                ];
                for (step, operation) in operations.into_iter().cycle().take(204).enumerate() {
                    let time = model.time.unwrap_or(10);
                    match operation {
                        Append | SameTime | SourceTooLong | TopicTooLong | RegressedTime => {
                            model.attempt(&mut actual, operation, step);
                        }
                        PruneOne | PruneNone | PruneAll => {
                            let (age, limit) = match operation {
                                PruneOne => (1, 1),
                                PruneNone => (0, 0),
                                _ => (0, capacity),
                            };
                            assert_eq!(
                                actual.prune_expired(time + 1, age, limit),
                                model.prune(time + 1, age, limit)
                            );
                        }
                        MoveRestore => actual = Log::restore(actual.into_snapshot()).unwrap(),
                        CopyRestore => actual = Log::restore(actual.snapshot()).unwrap(),
                    }
                    let checkpoint = actual.snapshot();
                    assert_eq!(checkpoint.entries, model.retained());
                    assert_eq!(checkpoint.next_sequence, model.next);
                    assert_eq!(checkpoint.last_created_at_secs, model.time);
                    for (index, filter) in [
                        Filter::default(),
                        Filter {
                            source: Some("worker"),
                            topic: Some("delivery"),
                            min_level: Some(Level::Warn),
                        },
                    ]
                    .into_iter()
                    .enumerate()
                    {
                        cursors[index] = model.check_page(
                            &actual,
                            filter,
                            cursors[index],
                            1 + step % 3,
                            1 + step % 4,
                        );
                    }
                }
            }
        }
    }
}
