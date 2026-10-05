//! The IC instruction-counter boundary, without attribution or native substitutes.

/// Read the IC call-context instruction counter (`ic0.performance_counter(1)`).
///
/// The unit is WebAssembly instructions, not cycles or elapsed time. In replicated
/// execution the counter includes this canister's message executions within the
/// current call context, including callbacks. In non-replicated execution it
/// covers the corresponding composite-query helper and its callbacks, excluding
/// downstream helpers. See the [System API specification].
///
/// Establish the same counter identity before comparing readings. Unrelated
/// calls, timer deliveries, resets and upgrades do not supply that identity;
/// increasing values alone do not prove continuity. Consumers own attribution,
/// replication filtering, regression handling and any delta arithmetic.
/// Zero is a valid reading, not an absent measurement.
///
/// Available only with feature `ic` on `wasm32-unknown-unknown`, executing inside
/// an IC canister. There is no native substitute. The optional `ic0` binding uses
/// `std`; the default arithmetic core remains dependency-free and `no_std`.
///
/// [System API specification]: https://docs.internetcomputer.org/references/ic-interface-spec/canister-interface/#performance-counter
#[inline]
#[must_use]
pub fn call_context_instructions() -> u64 {
    ic0::performance_counter(1)
}
