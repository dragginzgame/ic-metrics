//! Execute the locked Wire generator/runtime against independently declared JS values.

use super::*;
use ic_wire::{
    __private::serde_json::{self, json},
    typescript::{RUNTIME, generate_payload_registry, native_schema, payload_limits},
};
use std::{collections::BTreeMap, fs, path::Path, process::Command, string::String, vec::Vec};

const LIMITS: Limits = Limits {
    bytes: 4096,
    allocation: 65536,
    nodes: 2048,
    depth: 16,
};

#[derive(Debug, PartialEq, Serialize, Deserialize, ic_wire::Wire)]
struct Report {
    aggregate: MeasurementAggregate,
    counter: MeasurementCounter,
    summary: MeasurementSummary,
    histogram: MeasurementHistogram<37>,
}

fn reports() -> Vec<(&'static str, Report)> {
    [
        ("empty", 0, 0, None, false),
        ("zero", 1, 0, Some(0), false),
        ("wide", 2, 2 * u128::from(u64::MAX), Some(u64::MAX), false),
        (
            "cap",
            u64::MAX,
            u128::from(u64::MAX).pow(2),
            Some(u64::MAX),
            false,
        ),
        ("lost", u64::MAX, u128::MAX, Some(u64::MAX), true),
    ]
    .into_iter()
    .map(|(name, samples, total, maximum, lost)| {
        let aggregate =
            MeasurementAggregate::from_parts(samples, total, maximum, lost, lost).unwrap();
        let mut counts = [0; 37];
        let overflow = if name == "zero" {
            counts[0] = 1;
            0
        } else {
            samples
        };
        let report = Report {
            aggregate,
            counter: MeasurementCounter::from_parts(if samples > 1 { u128::MAX } else { 0 }, lost)
                .unwrap(),
            summary: MeasurementSummary::from_parts(aggregate, maximum).unwrap(),
            histogram: MeasurementHistogram::from_parts(
                core::array::from_fn(|index| index as u64),
                counts,
                overflow,
                [false; 37],
                lost,
                aggregate,
            )
            .unwrap(),
        };
        (name, report)
    })
    .collect()
}

#[test]
#[ignore = "requires the pinned Node runtime; run make typescript-check"]
fn generated_codecs_round_trip_between_rust_and_typescript() {
    let selected_node = std::env::var("IC_METRICS_NODE_VERSION")
        .expect("run make typescript-check to select ci/node-version.txt");
    let version = Command::new("node")
        .arg("--version")
        .output()
        .expect("prepare Node from ci/node-version.txt; see docs/hosts.md");
    assert!(version.status.success());
    assert_eq!(
        std::str::from_utf8(&version.stdout).unwrap().trim(),
        std::format!("v{}", selected_node.trim())
    );

    // Retain inputs, generated runtime and JS output on both success and failure.
    let directory =
        Path::new(env!("CARGO_MANIFEST_DIR")).join("../../target/typescript-conformance");
    fs::create_dir_all(&directory).unwrap();
    fs::write(directory.join("wire-runtime.ts"), RUNTIME).unwrap();
    let mut metadata = payload_limits(LIMITS).unwrap();
    metadata["name"] = json!("MetricsReport");
    metadata["schema"] = native_schema::<Report>().unwrap();
    let generated = generate_payload_registry(
        &BTreeMap::new(),
        &[metadata],
        "./wire-runtime.ts",
        &BTreeMap::new(),
        |_| {},
    )
    .unwrap();
    fs::write(directory.join("reports.ts"), generated).unwrap();
    fs::write(
        directory.join("check.mjs"),
        include_str!("browser/check.mjs"),
    )
    .unwrap();
    let reports = reports();
    let cases: Vec<_> = reports
        .iter()
        .map(|(name, report)| {
            json!({"name": name, "bytes": native::encode(report, LIMITS).unwrap()})
        })
        .collect();
    fs::write(
        directory.join("rust.json"),
        serde_json::to_vec(&cases).unwrap(),
    )
    .unwrap();
    // A failed/partial run must not reuse output from an earlier execution.
    let output = directory.join("typescript.json");
    if output.exists() {
        fs::remove_file(&output).unwrap();
    }
    let result = Command::new("node")
        .args(["--experimental-transform-types", "check.mjs"])
        .current_dir(&directory)
        .output()
        .unwrap();
    fs::write(directory.join("node.stdout"), &result.stdout).unwrap();
    fs::write(directory.join("node.stderr"), &result.stderr).unwrap();
    assert!(
        result.status.success(),
        "TypeScript conformance failed: {}\n{}",
        String::from_utf8_lossy(&result.stdout),
        String::from_utf8_lossy(&result.stderr)
    );
    let encoded: Vec<Vec<u8>> = serde_json::from_slice(&fs::read(output).unwrap()).unwrap();
    assert_eq!(encoded.len(), reports.len());
    for ((name, report), bytes) in reports.iter().zip(encoded) {
        assert_eq!(
            native::decode::<Report>(&bytes, LIMITS).unwrap(),
            *report,
            "{name}"
        );
        assert_eq!(bytes, native::encode(report, LIMITS).unwrap(), "{name}");
    }
}
