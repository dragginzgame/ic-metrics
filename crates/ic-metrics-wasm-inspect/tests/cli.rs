//! Exercise input admission and report publication through the actual executable.

use std::{
    fs,
    path::Path,
    process::{self, Command},
    time::{SystemTime, UNIX_EPOCH},
};

use ic_host_artifacts::artifact::Sha256Digest;

#[test]
fn input_admission_controls_exit_and_report_publication() {
    const MODULE: &[u8] = b"\0asm\x01\0\0\0";
    let identity = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();
    let root = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../target/evidence/wasm-inspect-cli")
        .join(format!("{}-{}", process::id(), identity.as_nanos()));
    fs::create_dir_all(root.parent().unwrap()).unwrap();
    fs::create_dir(&root).unwrap();
    let input = root.join("input with spaces.wasm");
    fs::write(&input, MODULE).unwrap();
    let inspect = |path: &Path, max_bytes: &str| {
        Command::new(env!("CARGO_BIN_EXE_ic-metrics-wasm-inspect"))
            .arg(path)
            .args([max_bytes, "0", "0", "0"])
            .output()
            .unwrap()
    };

    let accepted = inspect(&input, "8");
    assert!(accepted.status.success());
    assert_eq!(accepted.stderr.as_slice(), b"");
    let text = String::from_utf8(accepted.stdout).unwrap();
    let rows: Vec<_> = text.lines().collect();
    assert_eq!(rows.len(), 2);
    assert_eq!(
        rows[1],
        format!(
            "{}\t8\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0",
            Sha256Digest::compute(MODULE)
        )
    );

    let malformed = root.join("malformed.wasm");
    fs::write(&malformed, b"not Wasm").unwrap();
    let missing = root.join("missing.wasm");
    for (path, max_bytes) in [
        (&input, "7"),
        (&malformed, "8"),
        (&missing, "8"),
        (&root, "8"),
    ] {
        let rejected = inspect(path, max_bytes);
        assert_eq!(rejected.status.code(), Some(1));
        assert_eq!(rejected.stdout.as_slice(), b"");
        assert_ne!(rejected.stderr.as_slice(), b"");
    }
    // Admission and reporting must leave both accepted and refused inputs intact.
    assert_eq!(fs::read(&input).unwrap(), MODULE);
    assert_eq!(fs::read(&malformed).unwrap(), b"not Wasm");
    assert!(!missing.exists());
    // Retain invocation-owned inputs under target/evidence on success or failure.
}
