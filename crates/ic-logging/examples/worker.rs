//! Native application-owned logging without Canic, timers or IC calls.

use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
use std::num::NonZeroUsize;

fn main() {
    let mut log = Log::new(Limits {
        max_entries: NonZeroUsize::new(8).expect("positive capacity"),
        max_message_bytes: 32,
        max_label_bytes: 16,
    });
    for (created_at_secs, level, message) in [
        (10, Level::Info, "delivery accepted"),
        (
            11,
            Level::Warn,
            "provider reply is still unknown; reconcile before retry",
        ),
        (12, Level::Ok, "original delivery reconciled"),
    ] {
        log.append(EntryInput {
            created_at_secs,
            level,
            source: "worker",
            topic: Some("delivery"),
            message,
        })
        .expect("valid bounded entry");
    }
    let page = log.page(
        Filter::default(),
        PageRequest {
            before: None,
            max_results: NonZeroUsize::new(8).expect("positive results"),
            max_scanned: NonZeroUsize::new(8).expect("positive scan"),
        },
    );
    for entry in page.entries {
        println!("{} {:?}: {}", entry.sequence, entry.level, entry.message);
    }
    let batch = log.prune_expired(16, 5, 1);
    assert_eq!(batch.removed, 1);
    assert_eq!(log.next_expiry_secs(5), Some(17));
}
