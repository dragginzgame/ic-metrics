//! Heap log admission, immutable rows, bounded retention and cursor paging.
//!
//! Callers own authorization, scheduling, time and any durable storage.

use alloc::{collections::VecDeque, string::String, vec::Vec};
use core::num::NonZeroUsize;

const TRUNCATION_SUFFIX: &str = "...[truncated]";

/// Severity ordering used by minimum-level filters.
#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
pub enum Level {
    /// Development detail.
    Debug,
    /// Ordinary informational observation.
    Info,
    /// Successful outcome, ordered above informational observations.
    Ok,
    /// Recoverable or suspicious condition.
    Warn,
    /// Failed operation or invariant observation.
    Error,
}

/// Fixed limits chosen by the host before constructing a log.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Limits {
    /// Maximum retained rows; count eviction removes the oldest row.
    pub max_entries: NonZeroUsize,
    /// Maximum retained message bytes, including any truncation suffix.
    pub max_message_bytes: usize,
    /// Maximum UTF-8 bytes in each source or topic label.
    pub max_label_bytes: usize,
}

/// Borrowed append input; bounded retained strings are copied only after admission.
#[derive(Clone, Copy, Debug)]
pub struct EntryInput<'a> {
    /// Caller-supplied whole seconds; may not regress within this log.
    pub created_at_secs: u64,
    /// Observation severity.
    pub level: Level,
    /// Application or component label.
    pub source: &'a str,
    /// Optional application-defined topic.
    pub topic: Option<&'a str>,
    /// Message to retain, truncated to the configured byte ceiling.
    pub message: &'a str,
}

/// Immutable retained row; sequence identities belong to one log instance.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Entry {
    /// Monotonic identity, starting at zero and never reused within one log.
    pub sequence: u64,
    /// Admitted caller-supplied timestamp.
    pub created_at_secs: u64,
    /// Observation severity.
    pub level: Level,
    /// Bounded application or component label.
    pub source: String,
    /// Optional bounded topic label.
    pub topic: Option<String>,
    /// Bounded message text.
    pub message: String,
    /// Whether the original message exceeded its byte limit.
    pub truncated: bool,
}

/// Label rejected by append admission.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Label {
    /// Application or component source.
    Source,
    /// Optional topic.
    Topic,
}

/// Append refusal; every variant leaves entries and watermarks unchanged.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum AppendError {
    /// A label exceeded its configured byte ceiling.
    LabelTooLong {
        /// Rejected field.
        label: Label,
        /// Supplied UTF-8 byte length.
        actual_bytes: usize,
        /// Configured ceiling.
        max_bytes: usize,
    },
    /// The timestamp is older than the last admitted append, even after pruning.
    TimestampRegressed {
        /// Last admitted timestamp.
        previous: u64,
        /// Rejected timestamp.
        current: u64,
    },
    /// All sequence identities have been issued for this log instance.
    SequenceExhausted,
}

/// Optional exact label filters and a minimum severity; all supplied filters apply.
#[derive(Clone, Copy, Debug, Default)]
pub struct Filter<'a> {
    /// Match this exact source when present.
    pub source: Option<&'a str>,
    /// Match this exact topic when present.
    pub topic: Option<&'a str>,
    /// Include this severity and higher when present.
    pub min_level: Option<Level>,
}

impl Filter<'_> {
    fn matches(self, entry: &Entry) -> bool {
        let source_matches = self.source.is_none_or(|source| source == entry.source);
        let topic_matches = self
            .topic
            .is_none_or(|topic| Some(topic) == entry.topic.as_deref());
        let level_matches = self.min_level.is_none_or(|level| entry.level >= level);
        source_matches && topic_matches && level_matches
    }
}

/// One newest-first scan using an exclusive sequence cursor.
#[derive(Clone, Copy, Debug)]
pub struct PageRequest {
    /// Scan entries older than this sequence, or begin at the newest entry.
    pub before: Option<u64>,
    /// Maximum matching rows to return.
    pub max_results: NonZeroUsize,
    /// Maximum candidate rows to examine after binary-search positioning.
    pub max_scanned: NonZeroUsize,
}

/// Borrowed page; a continuation can be present even when no row matched.
#[derive(Debug)]
pub struct Page<'a> {
    /// Matching rows, newest first.
    pub entries: Vec<&'a Entry>,
    /// Number of candidate rows examined, not the total number of matches.
    pub scanned: usize,
    /// Exclusive cursor for the next older scan, if retained candidates remain.
    pub next_before: Option<u64>,
}

/// Result of a bounded age-retention call.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct RetentionBatch {
    /// Number of rows removed by this call.
    pub removed: usize,
    /// Whether the oldest remaining row is also expired.
    pub more_due: bool,
}

/// Caller-owned heap history with fixed limits and monotonic append watermarks.
#[derive(Debug)]
pub struct Log {
    limits: Limits,
    entries: VecDeque<Entry>,
    next_sequence: Option<u64>,
    last_created_at_secs: Option<u64>,
}

impl Log {
    /// Construct an empty log without preallocating the configured maximum.
    #[must_use]
    pub const fn new(limits: Limits) -> Self {
        Self {
            limits,
            entries: VecDeque::new(),
            next_sequence: Some(0),
            last_created_at_secs: None,
        }
    }

    /// Return the retained row count.
    #[must_use]
    pub fn len(&self) -> usize {
        self.entries.len()
    }

    /// Whether this log currently has no retained rows.
    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }

    /// Admit one row and evict the oldest if the count ceiling is reached.
    ///
    /// # Errors
    /// Returns a typed refusal for oversized labels, regressed time or exhausted
    /// sequence identities. Validation completes before any eviction or mutation.
    pub fn append(&mut self, input: EntryInput<'_>) -> Result<u64, AppendError> {
        self.validate_label(Label::Source, input.source)?;
        if let Some(topic) = input.topic {
            self.validate_label(Label::Topic, topic)?;
        }
        if let Some(previous) = self.last_created_at_secs
            && input.created_at_secs < previous
        {
            return Err(AppendError::TimestampRegressed {
                previous,
                current: input.created_at_secs,
            });
        }
        let sequence = self.next_sequence.ok_or(AppendError::SequenceExhausted)?;
        let entry = Entry {
            sequence,
            created_at_secs: input.created_at_secs,
            level: input.level,
            source: String::from(input.source),
            topic: input.topic.map(String::from),
            message: bounded_message(input.message, self.limits.max_message_bytes),
            truncated: input.message.len() > self.limits.max_message_bytes,
        };
        if self.entries.len() == self.limits.max_entries.get() {
            self.entries.pop_front();
        }
        self.entries.push_back(entry);
        self.next_sequence = sequence.checked_add(1);
        self.last_created_at_secs = Some(input.created_at_secs);
        Ok(sequence)
    }

    /// Remove at most `max_remove` entries strictly older than the age cutoff.
    /// An entry remains available through its full configured age second.
    pub fn prune_expired(
        &mut self,
        now_secs: u64,
        max_age_secs: u64,
        max_remove: usize,
    ) -> RetentionBatch {
        let cutoff = now_secs.saturating_sub(max_age_secs);
        let mut removed = 0;
        while removed < max_remove && self.expired_before(cutoff) {
            self.entries.pop_front();
            removed += 1;
        }
        RetentionBatch {
            removed,
            more_due: self.expired_before(cutoff),
        }
    }

    /// First second at which the oldest row expires; `None` for empty history or overflow.
    #[must_use]
    pub fn next_expiry_secs(&self, max_age_secs: u64) -> Option<u64> {
        self.entries
            .front()?
            .created_at_secs
            .checked_add(max_age_secs)?
            .checked_add(1)
    }

    /// Scan newest-first without cloning retained messages or counting every match.
    /// Follow `next_before` with the same filters, including after an empty page.
    #[must_use]
    pub fn page(&self, filter: Filter<'_>, request: PageRequest) -> Page<'_> {
        let mut cursor = request.before.map_or(self.entries.len(), |sequence| {
            self.entries
                .binary_search_by_key(&sequence, |entry| entry.sequence)
                .unwrap_or_else(|index| index)
        });
        let mut entries = Vec::new();
        let mut scanned = 0;
        let mut last_scanned = None;
        while cursor > 0
            && scanned < request.max_scanned.get()
            && entries.len() < request.max_results.get()
        {
            cursor -= 1;
            let entry = &self.entries[cursor];
            scanned += 1;
            last_scanned = Some(entry.sequence);
            if filter.matches(entry) {
                entries.push(entry);
            }
        }
        Page {
            entries,
            scanned,
            next_before: if cursor > 0 { last_scanned } else { None },
        }
    }

    const fn validate_label(&self, label: Label, text: &str) -> Result<(), AppendError> {
        if text.len() > self.limits.max_label_bytes {
            return Err(AppendError::LabelTooLong {
                label,
                actual_bytes: text.len(),
                max_bytes: self.limits.max_label_bytes,
            });
        }
        Ok(())
    }

    fn expired_before(&self, cutoff: u64) -> bool {
        self.entries
            .front()
            .is_some_and(|entry| entry.created_at_secs < cutoff)
    }
}

fn bounded_message(message: &str, max_bytes: usize) -> String {
    if message.len() <= max_bytes {
        return String::from(message);
    }
    let suffix = if max_bytes > TRUNCATION_SUFFIX.len() {
        TRUNCATION_SUFFIX
    } else {
        ""
    };
    let mut end = max_bytes - suffix.len();
    while !message.is_char_boundary(end) {
        end -= 1;
    }
    let mut retained = String::from(&message[..end]);
    retained.push_str(suffix);
    retained
}

#[cfg(test)]
mod tests;
