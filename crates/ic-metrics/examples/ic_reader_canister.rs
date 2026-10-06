//! Focused IC counter fixture; build with `make reader-check`.

#![cfg(all(target_arch = "wasm32", target_os = "unknown"))]

use ic_metrics::call_context_instructions;

fn measured_work(iterations: u32) {
    let mut value = core::hint::black_box(17_u64);
    for _ in 0..iterations {
        value = core::hint::black_box(value.wrapping_mul(3).wrapping_add(1));
    }
    core::hint::black_box(value);
}

#[ic_cdk::update]
fn probe() -> Vec<u64> {
    instruction_probe(10_000)
}

#[ic_cdk::query]
fn query_probe() -> Vec<u64> {
    instruction_probe(10_000)
}

fn instruction_probe(iterations: u32) -> Vec<u64> {
    let direct_before = ic0::performance_counter(1);
    let shared_before = call_context_instructions();
    let direct_between = ic0::performance_counter(1);
    measured_work(iterations);
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
    measured_work(10_000);
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

#[ic_cdk::query]
fn downstream_query_work(iterations: u32) -> Vec<u64> {
    instruction_probe(iterations)
}

#[ic_cdk::query(composite = true)]
async fn across_query_callback(target: candid::Principal, iterations: u32) -> Result<Vec<u64>, ()> {
    measured_work(10_000);
    let before = call_context_instructions();
    let reply = ic_cdk::call::Call::bounded_wait(target, "downstream_query_work")
        .with_arg(iterations)
        .await
        .map_err(|_| ())?;
    // Bracket the callback read before decoding the downstream response.
    let direct_before = ic0::performance_counter(1);
    let shared = call_context_instructions();
    let direct_after = ic0::performance_counter(1);
    let message = ic0::performance_counter(0);
    let downstream: Vec<u64> = reply.candid().map_err(|_| ())?;
    let mut readings = vec![before, direct_before, shared, direct_after, message];
    readings.extend(downstream);
    Ok(readings)
}
