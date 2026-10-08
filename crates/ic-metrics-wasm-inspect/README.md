# Wasm evidence inspector

This private host binary reports the SHA-256 and structural facts of one explicitly
supplied raw Wasm. It uses `ic-host-fs` for bounded regular-file reads and
`ic-host-artifacts` for hashing and Wasm inspection. The public `ic-metrics` library
has no dependency on it. The host package requires Rust 1.88; the arithmetic library
supports Rust 1.85. Bare Cargo commands still select the arithmetic package.

Prepare the selected locked dependencies explicitly with `cargo fetch --locked`,
then run using the development toolchain:

```sh
cargo run -p ic-metrics-wasm-inspect --locked --offline -- \
  module.wasm 20000000 1000 10000 1000 > inspection.tsv
```

Arguments are the input path followed by maximum raw bytes, sections, exports and
custom sections. All four bounds are required; zero permits only an empty counted
collection. `--help` prints the command shape. Inputs must be ordinary files in a
caller-controlled tree; the shared reader follows symlinks. Concurrent writers,
path admission, retained command/source/lock identities and output destinations
remain caller-owned. A report identifies exactly the bytes read into its buffer.

The TSV header and one data row report raw Wasm bytes, encoded code-section and
code-body bytes, encoded data-section bytes, defined/imported functions and globals,
data segments, exports and custom sections. The digest binds the row to its input.
Code-body bytes exclude the code vector count; they are not an instruction count.
Structural inspection is not full Wasm validation or IC install admission.
It executes no canister and reports no instruction, cycle or timing estimate.

Malformed or over-budget inputs fail before any report is written. Output failures
return a failure status and may leave a partial stream; callers must admit success
before treating a redirected file as completed evidence. The binary does not
overwrite artifacts, download tools, launch processes or select IC resource limits.

Use new result directories when inspecting the frozen replay Wasms. The original
bundle, source identities and raw measurements remain historical evidence; new
structural reports describe those exact artifact bytes under this tool's separately
recorded source and lock. See [the inspection record](../../docs/evidence/wasm-inspection-0215.md).

`make wasm-inspect-check` runs focused host checks and named argument/report tests.
`make wasm-inspect-msrv` checks this package's explicit Rust 1.88 dependency path.
Native CI includes these checks; the arithmetic host/Wasm targets remain separate.
