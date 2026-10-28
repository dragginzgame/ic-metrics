//! Heap-local reset bookkeeping for consumer-defined measurement state.

/// A reset window containing any consumer-defined combination of metric shapes.
///
/// The reset sequence is local to this instance and becomes unavailable rather
/// than wrapping. It is not a globally unique identity or a persistence epoch.
/// Consumers must establish the same host/heap lifetime, units and append-only
/// continuity before using it to qualify numeric deltas. Platform clocks,
/// replication decisions and reset authorization remain consumer-owned.
#[derive(Clone, Debug)]
pub struct MeasurementWindow<T> {
    state: T,
    sequence: Option<u64>,
}

impl<T> MeasurementWindow<T> {
    /// Create a fresh instance with consumer-supplied empty state.
    pub const fn new(state: T) -> Self {
        Self {
            state,
            sequence: Some(0),
        }
    }

    /// Borrow the current measurement state without cloning a report.
    pub const fn state(&self) -> &T {
        &self.state
    }

    /// Access state for recording. Use `reset` when replacing a measurement window.
    pub const fn state_mut(&mut self) -> &mut T {
        &mut self.state
    }

    /// Heap-local reset sequence, or unavailable after sequence exhaustion.
    pub const fn sequence(&self) -> Option<u64> {
        self.sequence
    }

    /// Replace all state and advance the reset sequence, without a platform clock.
    /// Replacement state, policy and authorization are supplied by the consumer.
    pub fn reset(&mut self, state: T) {
        self.state = state;
        self.sequence = self.sequence.and_then(|value| value.checked_add(1));
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{MeasurementAggregate, MeasurementCounter};

    #[test]
    fn window_resets_all_shapes_without_manufacturing_instance_identity() {
        let mut window =
            MeasurementWindow::new((MeasurementAggregate::EMPTY, MeasurementCounter::ZERO));
        window.state_mut().0.record(0);
        window.state_mut().1.add(9);
        assert_eq!(window.state().0.samples(), 1);
        assert_eq!(window.state().1.total(), 9);
        assert_eq!(window.sequence(), Some(0));
        window.reset((MeasurementAggregate::EMPTY, MeasurementCounter::ZERO));
        assert_eq!(window.sequence(), Some(1));
        assert_eq!(window.state().0.samples(), 0);
        assert_eq!(window.state().1.total(), 0);
    }

    #[test]
    fn window_sequence_exhaustion_never_wraps_or_recovers_on_reset() {
        let mut window = MeasurementWindow {
            state: (),
            sequence: Some(u64::MAX),
        };
        window.reset(());
        assert_eq!(window.sequence(), None);
        window.reset(());
        assert_eq!(window.sequence(), None);
    }
}
