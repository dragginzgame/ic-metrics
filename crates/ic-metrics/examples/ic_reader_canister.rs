//! Focused IC counter fixture; build with `make reader-check`.

#![cfg(all(target_arch = "wasm32", target_os = "unknown"))]

use ic_metrics::call_context_instructions;

fn measured_work() {
    let mut value = core::hint::black_box(17_u64);
    for _ in 0..10_000 {
        value = core::hint::black_box(value.wrapping_mul(3).wrapping_add(1));
    }
    core::hint::black_box(value);
}

#[ic_cdk::update]
fn probe() -> Vec<u64> {
    let direct_before = ic0::performance_counter(1);
    let shared_before = call_context_instructions();
    let direct_between = ic0::performance_counter(1);
    measured_work();
    let shared_after = call_context_instructions();
    let direct_after = ic0::performance_counter(1);
    vec![
        direct_before,
        shared_before,
        direct_between,
        shared_after,
        direct_after,
    ]
}

#[ic_cdk::update]
const fn callback_target() {}

#[ic_cdk::update]
async fn across_callback() -> Result<Vec<u64>, ()> {
    measured_work();
    let before = call_context_instructions();
    ic_cdk::call::Call::bounded_wait(ic_cdk::api::canister_self(), "callback_target")
        .await
        .map_err(|_| ())?;
    let direct_before = ic0::performance_counter(1);
    let shared = call_context_instructions();
    let direct_after = ic0::performance_counter(1);
    let message = ic0::performance_counter(0);
    Ok(vec![before, direct_before, shared, direct_after, message])
}
