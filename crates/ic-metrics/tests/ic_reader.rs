//! Opt-in `PocketIC` qualification of the actual Wasm instruction reader.

#![cfg(not(target_arch = "wasm32"))]

use ic_testkit::pic::{
    CandidCallExt, CanisterInstallExt, InstallSpec, PocketIcBuilder, PocketIcBuilderExt,
    PocketIcStartupConfig,
};
use sha2::{Digest as _, Sha256};
use std::{error::Error, io, process::Command, time::Duration};

#[test]
#[ignore = "requires explicit PocketIC binary and built Wasm; run make reader-check"]
fn call_context_reader_matches_ic_and_survives_callback() -> Result<(), Box<dyn Error>> {
    let binary = std::env::var("POCKET_IC_BIN")?;
    let expected_digest = match (std::env::consts::OS, std::env::consts::ARCH) {
        ("linux", "x86_64") => "69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792",
        ("macos", "x86_64") => "b8233ebee53452db7465b43e7b2ff80f2e1445dc148eb2b4b237493d8d15ec66",
        ("macos", "aarch64") => "781f643d4b16105e7544ca810a972f99c0ef1919016c680faa93f10909a14496",
        _ => return Err(io::Error::from(io::ErrorKind::Unsupported).into()),
    };
    let digest = format!("{:x}", Sha256::digest(std::fs::read(&binary)?));
    if digest != expected_digest {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            "PocketIC binary checksum mismatch",
        )
        .into());
    }
    let version = Command::new(&binary).arg("--version").output()?;
    if !version.status.success() || version.stdout != b"pocket-ic-server 16.0.0\n" {
        return Err(io::Error::new(io::ErrorKind::InvalidData, "PocketIC version mismatch").into());
    }

    let config = PocketIcStartupConfig::spawn(binary, Duration::from_secs(30))
        .with_server_hard_ttl(Duration::from_secs(120));
    let pic = PocketIcBuilder::new()
        .with_application_subnet()
        .with_max_request_time_ms(Some(30_000))
        .try_build(config)?;
    let wasm = std::fs::read(std::env::var("IC_METRICS_READER_WASM")?)?;
    let canister = pic.try_create_and_install(InstallSpec::new(wasm, vec![], 1_000_000_000_000))?;

    let readings: Vec<u64> = pic.update_candid(canister, "probe", ())?;
    println!("counter_1_readings={readings:?}");
    assert_eq!(readings.len(), 5);
    assert!(readings.windows(2).all(|pair| pair[0] <= pair[1]));
    assert!(readings[3] > readings[1]);

    let callback: Result<Vec<u64>, ()> = pic.update_candid(canister, "across_callback", ())?;
    let callback = callback.expect("self call succeeds");
    println!("callback_readings={callback:?}");
    assert_eq!(callback.len(), 5);
    assert!(callback[..4].windows(2).all(|pair| pair[0] <= pair[1]));
    assert!(callback[2] > callback[4]);

    let query: Vec<u64> = pic.query_candid(canister, "query_probe", ())?;
    println!("query_counter_1_readings={query:?}");
    assert_eq!(query.len(), 5);
    assert!(query.windows(2).all(|pair| pair[0] <= pair[1]));
    assert!(query[3] > query[1]);

    // Use a distinct canister to establish separate downstream execution;
    // never compare absolute counters across their different identities.
    let downstream_wasm = std::fs::read(std::env::var("IC_METRICS_READER_WASM")?)?;
    let downstream =
        pic.try_create_and_install(InstallSpec::new(downstream_wasm, vec![], 1_000_000_000_000))?;
    let mut caller_intervals = Vec::new();
    let mut downstream_intervals = Vec::new();
    for iterations in [0_u32, 1_000_000] {
        let composite: Result<Vec<u64>, ()> =
            pic.query_candid(canister, "across_query_callback", (downstream, iterations))?;
        let composite = composite.expect("downstream query succeeds");
        println!("composite_query_iterations={iterations} readings={composite:?}");
        assert_eq!(composite.len(), 10);
        assert!(composite[..4].windows(2).all(|pair| pair[0] <= pair[1]));
        assert!(composite[2] > composite[4]);
        assert!(composite[5..].windows(2).all(|pair| pair[0] <= pair[1]));
        caller_intervals.push(composite[2] - composite[0]);
        downstream_intervals.push(composite[8] - composite[6]);
    }
    // Each delta uses one established local call context. Compare completed
    // intervals, not absolute snapshots from separate canisters or queries.
    assert!(downstream_intervals[1] > downstream_intervals[0]);
    assert_eq!(caller_intervals[0], caller_intervals[1]);
    Ok(())
}
