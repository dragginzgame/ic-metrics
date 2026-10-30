//! Independent event-history model for interactions across the public Log API.

use super::{input, log, request};
use crate::{
    AppendError, AppendReceipt, Entry, EntryInput, Filter, Label, Level, Log, LogSnapshot,
    RetentionBatch, TopicMatch,
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
                self.time.map_or_else(
                    || self.next.ok_or(AppendError::SequenceExhausted),
                    |previous| {
                        Err(AppendError::TimestampRegressed {
                            previous,
                            current: time - 1,
                        })
                    },
                )
            }
            _ => self.next.ok_or(AppendError::SequenceExhausted),
        };
        let expected = match expected {
            Ok(_) => self.append(
                entry,
                actual.limits().max_entries.get(),
                actual.limits().max_message_bytes,
                actual.limits().max_text_bytes,
            ),
            Err(error) => Err(error),
        };
        assert_eq!(actual.append(entry), expected);
    }

    fn append(
        &mut self,
        input: EntryInput<'_>,
        capacity: usize,
        budget: usize,
        text_budget: usize,
    ) -> Result<AppendReceipt, AppendError> {
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
        let required_bytes = input.source.len() + input.topic.map_or(0, str::len) + message.len();
        if required_bytes > text_budget {
            return Err(AppendError::TextBudgetExceeded {
                required_bytes: required_bytes as u128,
                max_bytes: text_budget,
            });
        }
        let previous = self.retained().len();
        self.accepted.push(Entry {
            sequence,
            created_at_secs: input.created_at_secs,
            level: input.level,
            source: input.source.into(),
            topic: input.topic.map(String::from),
            message,
            truncated,
        });
        // Derive the longest fitting suffix of the event journal, rather than
        // updating the engine's cached total while popping a queue.
        let keep = self
            .retained()
            .iter()
            .rev()
            .take(capacity)
            .scan(0_usize, |bytes, entry| {
                *bytes += entry.source.len()
                    + entry.topic.as_ref().map_or(0, String::len)
                    + entry.message.len();
                (*bytes <= text_budget).then_some(())
            })
            .count();
        self.removed = self.accepted.len() - keep;
        self.next = sequence.checked_add(1);
        self.time = Some(input.created_at_secs);
        Ok(AppendReceipt {
            sequence,
            truncated,
            evicted: previous + 1 - keep,
        })
    }

    fn retained(&self) -> &[Entry] {
        &self.accepted[self.removed..]
    }

    fn check_state(&self, log: &Log) {
        let checkpoint = log.snapshot();
        assert_eq!(checkpoint.entries, self.retained());
        assert_eq!(checkpoint.next_sequence, self.next);
        assert_eq!(checkpoint.last_created_at_secs, self.time);
        assert_eq!(
            log.retained_text_bytes(),
            self.retained()
                .iter()
                .map(|entry| entry.source.len()
                    + entry.topic.as_ref().map_or(0, String::len)
                    + entry.message.len())
                .sum::<usize>()
        );
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
                    && match filter.topic {
                        TopicMatch::Any => true,
                        TopicMatch::Absent => entry.topic.is_none(),
                        TopicMatch::Exact(topic) => entry.topic.as_deref() == Some(topic),
                    }
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
            for (budget, text_budget) in [
                (0, 0),
                (0, 14),
                (1, 29),
                (13, 54),
                (14, 80),
                (15, 31),
                (32, 48),
                (32, usize::MAX),
            ] {
                let mut limits = log(capacity, budget).limits();
                limits.max_text_bytes = text_budget;
                let mut actual = Log::new(limits);
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
                    model.check_state(&actual);
                    for (index, filter) in [
                        Filter::default(),
                        Filter {
                            source: Some("worker"),
                            topic: TopicMatch::Exact("delivery"),
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
