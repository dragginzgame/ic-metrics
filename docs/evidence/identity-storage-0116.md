# Immutable identity storage for 0.11.6

The retained candidate stores the private admitted unit as `Box<str>` instead of
`String`. The constructor, derived clone/equality behavior and V1 wire bytes keep
the same public contract. No arithmetic or stable-memory dependency is added.

The source anchor is released 0.11.5 at
`0efa8d8d7aadb2bcebbd929364a50d3c317924ca`, plus the prepared bounded-cursor
cleanup and incoming Memory 0.44 selection. Both frozen variants share those
inputs; their stable sources differ only in the private unit field and its
constructor allocation. This is a working-tree comparison, not released-source
qualification. The archive retains exact source trees and separate product inputs.

## Matched IC observations

| Raw Wasm probe | String baseline | Box candidate | Change |
| --- | ---: | ---: | ---: |
| Identity construction/clone/checkpoint | 325,742 | 325,724 | −18 bytes |
| Four-type decoder | 333,983 | 333,867 | −116 bytes |

The identity probe tests unit lengths 1, 8, 32 and 64 across construction,
cloning, construction followed by cloning, and construction followed by loading
and saving an identical counter checkpoint. Setup precedes the instruction
bracket. Each case runs zero and 128 iterations, repeated three times in separate
baseline/candidate canisters. Equality and loaded values are checked.

| Instruction change | Per 128 iterations | Per iteration |
| --- | ---: | ---: |
| Construction and drop | −29,824 | −233 |
| Clone and drop | −9,216 | −72 |
| Construction, clone and drops | −36,992 | −289 |
| Construction with load/unchanged save | −29,824 | −233 |
| Each decoder case | 0 | 0 |

All tested unit lengths have the same matched deltas. The decoder probe covers
counters, aggregates, summaries and four-bound histograms under valid,
truncated, trailing-byte, invalid-unit and differing-identity conditions. Its
32 cases retain the workload in the [decoder study](decoder-cleanup-0116.md).
All 576 update projections match. Deltas repeat exactly across three repetitions.
Independent replay reproduces all four Wasms byte-for-byte and every instruction
and projection observation.

Instruction changes subtract each variant's zero-iteration control before
comparing the 128-iteration bracket. Identity controls match; decoder controls
differ by −5 instructions, which is excluded from the per-iteration result.
The CSV retains actual whole-update cycle charges, including setup, stable writes
and reply encoding outside the bracket. No isolated identity/decoder cycle saving
or universal library size/performance improvement is inferred.

## Reproduction and scope

The [frozen payload](identity-storage-0116.tar.gz) and its
[checksum](identity-storage-0116.tar.gz.sha256) include selected Metrics source,
manifests, lock, probe/driver, raw Wasms, original/replayed observations and build
commands. Internal fixture package labels are 0.11.5; they are not a publication
or release selection. The graph selects Memory 0.44.0, stable structures 0.7.2,
CDK 0.20.3, Candid 0.10.38 and Testkit 0.34.2. Other registry rows retain the
supplying decoder experiment's lock; this is not the complete product graph.

Rust 1.99.0 (`b940084d7`, 2026-09-28), Linux x86_64, compiles raw
`wasm32-unknown-unknown` with `opt-level=z`, LTO, one codegen unit, stripped
symbols and aborting panics. No Wasm postprocessing is used. PocketIC 16.1.0
Linux x86_64 has SHA-256
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

After extracting and checking the internal `SHA256SUMS`, set `METRICS_TARGET_DIR`
to an absolute build directory under the owning Metrics `target/` and
`POCKET_IC_BIN` to that prepared server. Run `bash replay.sh`. Dependencies must
already be cached: builds are locked/offline and no installer is dispatched.
The fixture's assertions apply only to its controlled inputs, not production.

The helper explicitly selects `cargo +1.99.0`, creates an invocation-owned build
directory and retires only its local-package release outputs between variants.
Earlier archive readbacks exposed cached-output reuse and standard-library path
differences from the default toolchain alias. Those attempts and the earlier
archive remain under `/tmp/metrics-policy-unit.VGvbsA/`. The corrected helper
rebuilds all four identical Wasms from the extracted payload in a fresh target;
unrelated caches and the frozen artifacts are retained.

Product validation separately passes the 16 stable library tests, native/Wasm
Clippy and native/Wasm Rust 1.91 stable-package checks on the selected Memory 0.44
workspace. Full CI/MSRV release gates and new native macOS qualification were not
run. The payload excludes private sibling source and issue bodies.
