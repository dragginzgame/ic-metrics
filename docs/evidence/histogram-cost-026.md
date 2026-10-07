# Two-bound histogram recording experiment for pending 0.2.6

This is Linux PocketIC execution of an isolated Canic source-copy fixture,
not Canic adoption, full-canister qualification or a Toko integration. It answers
the bounded recording-cost question in
[#19](https://github.com/dragginzgame/ic-metrics/issues/19).
Root base is published 0.2.5 at `d8b3a46f24518a033cd36e40bf1f1895099b809f`;
the mean API, packaged application guide and existing Shared Tooling 0.1.15
adoption are uncommitted pending 0.2.6. Cargo metadata remains 0.2.5.

## Source and configuration

Read-only Canic input is local committed
`d9b10b07d610b513aa90d221040a8d27a7fc9ed7`. Its
`crates/canic-core/src/perf.rs` matches HEAD. The copied production module
supplies actual endpoint keys, borrowed lookup, BTreeMap storage and recording;
the endpoint identity definitions are copied from `ids/endpoint.rs`.
The original fixture recipe is retained in Canic's
`target/evidence/metrics-improvements/canister/`. No sibling files changed and
no sibling builds or full local gates ran.

Three isolated canisters expose the same `probe(iterations: u32, value: u64)`
update and return the same nine-u64 response shape:

| Variant | Slot recording and projection |
| --- | --- |
| Count/total baseline | Original `PerfSlot` and both original `record_sample` calls. |
| Summary | Replace count/total storage with `MeasurementSummary`; record once and project its count/total. |
| Two-bound histogram | Replace slot storage with `MeasurementHistogram<2>` using inclusive `[10_000, 100_000]`; record once and project its summary. |

The fixture copies the complete performance module. Unexecuted bounded-report
dependencies have explicit constant/error substitutes; this does not validate
Canic's bounded-report or error contract. It adds read-only trampolines for slot
size and bucket observability. Histogram initialization uses compile-time
validated constant bounds. Recording/key lookup bodies otherwise retain the
original flow. The endpoint is the fixed update key `measured`; arbitrary
checkpoint labels, authorization and async attribution are not exercised.

Every call brackets the recording loop with actual IC counter-1 reads. Values
pass through `black_box`; report projection and Candid encoding occur after the
second read. Histogram bucket/overflow results are returned, so their writes
remain observable. The host verifies sample count, total and all buckets after
every call. It observes cycle balance immediately before and after the entire
update, including report/encoding costs. Instruction deltas and cycle charges
are separate observations, not a conversion between units.
The recorded values are selected boundary inputs, not measurements of a real
application operation; the measured instructions describe the recording work.

Toolchain: Rust 1.99.0, `wasm32-unknown-unknown`; release profile `opt-level=z`,
LTO, one codegen unit, stripped symbols, panic abort. No Wasm postprocessing.
Fixture-only pinned dependencies are IC CDK 0.20.3, Candid 0.10.37 and PocketIC
16.0.0. The isolated fixture graph was prepared offline from the inspected
IC Testkit lock; all 276 retained external package identities match that seed
lock, with only new fixture/path package identities. Locked offline cache
preparation succeeds. The runtime library's dependency graph remains empty.

The prepared local PocketIC 16.0.0 executable passed the owning offline IC tool
check. The host uses its explicit path; no implicit server download is selected.
Linux host and exact source/tool/lock/artifact receipts are retained alongside
the raw results. The configured PocketIC application subnet and initial
5-trillion-cycle canister balances are identical across variants.

Frozen measurement identities:

| Input/artifact | SHA-256 |
| --- | --- |
| Original Canic performance module | `986b0fe9ba78bba7c02dbb3497c4bd1d75f3db32704ee4578a27d7dc2546511b` |
| Original endpoint identities | `103c37945d725c1c24c1e783dd6dab10fb179ac1eb54731b65b910cb70261a4c` |
| Selected fixture lock | `86cba68dab56def4aa39f696a4e56c0ddbf53054840d655d68f1ce68e8f6d836` |
| Baseline Wasm | `4812d384a9c00c95691a4b507b6ee450e684cfa93c841ab14af53ccad3f257ab` |
| Summary Wasm | `72ef1c2cd735b067eec7140d68ddbc85686bbef11d424d8007a824316fbf04af` |
| Histogram Wasm | `801f7e4ad4bebee9cfbf2a61871a2ab0b0828b73ee2d75311a141708d3b7965c` |
| Raw successful execution CSV | `06509f7dc42ace93ee24e0766b9351af69ba016ac33a42890d5a19eda2a87c48` |
| PocketIC executable | `69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792` |

## Observed results

Each canister first records one cold zero sample. Warm calls use values `0`,
`10_000`, `10_001`, `100_000` and `100_001`, with 0, 1 and 1,000 iterations,
each repeated three times. All 138 observations pass aggregate validation.
The table shows 1,000-iteration warm calls; all three repeats agree exactly
within every listed case.

| Admitted value / selected bucket | Baseline instructions | Summary instructions | Histogram instructions | Baseline cycles | Summary cycles | Histogram cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 and 10,000 / first | 371,269 | 380,269 | 413,269 | 7,387,178 | 7,396,202 | 7,429,213 |
| 10,001 and 100,000 / second | 371,269 | 380,269 | 434,269 | 7,387,178 | 7,396,202 | 7,450,213 |
| 100,001 / overflow | 371,269 | 380,269 | 446,269 | 7,387,178 | 7,396,202 | 7,462,213 |

At the same 1,000-record workload, histogram recording adds 42,000, 63,000 or
75,000 instructions over count/total, and 33,000, 54,000 or 66,000 over summary.
Observed whole-update histogram cycle differences from baseline are 42,035,
63,035 and 75,035 respectively. These are workload differences, not a general
per-instruction cycle rate. Zero-iteration and cold/single-record observations
remain in the raw result set; short calls can have different setup/heap costs.

| Variant | IC-reported slot size | Raw canister Wasm bytes |
| --- | ---: | ---: |
| Count/total | 16 | 294,727 |
| Summary | 32 | 295,044 |
| Two-bound histogram | 72 | 294,935 |

The histogram adds 56 slot bytes and 208 raw Wasm bytes over this baseline.
The slot size excludes map nodes, labels, allocator overhead, DTOs and endpoint
storage. These compiler artifacts do not establish a portable Rust layout or
linear code-size relationship: the summary fixture is larger than the histogram
fixture under this exact profile. Do not generalize to another `N`, multiple
instantiations, per-entity cardinality or a complete application.

## Artifacts, commands and limitations

The owning ignored `target/evidence/histogram-cost-026/` retains the original
source copies, seed and selected lock, full fixture sources, metadata, build
logs, three frozen Wasms, driver, raw CSV and parsed JSON. `inputs.sha256`
binds source, toolchain, server, locks, artifacts and results. `host.txt` records
the Linux/tool versions; `lock-selection.log` records the no-upgrade comparison.

Preparation used the explicit fixture manifest under `probe/Cargo.toml`, then:

```sh
cargo fetch --locked --offline --manifest-path target/evidence/histogram-cost-026/probe/Cargo.toml
CARGO_TARGET_DIR="$PWD/target" cargo build --locked --offline --release \
  --manifest-path target/evidence/histogram-cost-026/probe/Cargo.toml \
  --target wasm32-unknown-unknown -p count-probe -p summary-probe -p histogram-probe
CARGO_TARGET_DIR="$PWD/target" cargo build --locked --offline \
  --manifest-path target/evidence/histogram-cost-026/probe/Cargo.toml -p histogram-cost-driver
make ic-tools-check
target/debug/histogram-cost-driver "$PWD/.tools/ic/bin/pocket-ic" \
  "$PWD/target/evidence/histogram-cost-026"
```

The initial host build exposed an i32/u32 inference error in the scratch driver;
its failed log remains, and the explicitly typed final build passes. Copied
unused consumer surfaces produce dead-code warnings in these isolated canisters;
this fixture is not a claim that Canic's complete Clippy gate passed. The root
library's selected host/Wasm warning-denied gate passes separately.
The sandboxed server failed to bind localhost, produced no measurements and
was interrupted. That execution log is retained. The successful scoped local
socket execution is separate (`execution-local.log`, `results-local.csv`);
its initial server message is excluded only from the derived JSON, not the raw log.

The final source build is compared byte-for-byte with the frozen measured Wasms.
Documentation-only guide changes do not change those artifacts. No production
platform reader, runtime dependency, measurement framework or maintained
canister endpoint was added to ic-metrics.

This experiment does not cover saturation cost, cold-key cardinality growth,
callbacks, timer admission, traps, report authorization, mainnet pricing,
native macOS or full application deployment. Real consumer bounds, workload,
storage budget and owning qualification remain in
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
IC Timers deliberately retains its summary-only runtime. The saved Toko audit's
unmeasured per-role size estimate is not validated by this small fixture.
