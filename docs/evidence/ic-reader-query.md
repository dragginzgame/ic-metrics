# Query instruction-reader execution

Focused Linux x86_64 qualification on 2026-10-06 extends the pending 0.1.6
fixture with ordinary queries, composite-query callbacks and downstream-work
exclusion. The source is the dirty worktree based on
`bb28e217c5b3069715c1a58322b7900bec7fbb84`, with the identities below. Cargo package
metadata still identifies as 0.1.5. Library Rust sources and the selected lockfile
match that published release; fixture and documentation changes are pending.
This is neither a 0.1.6 release nor new consumer lifecycle qualification.
The earlier [replicated execution record](ic-reader.md) remains unchanged.

## Inputs and artifacts

- Rust `1.99.0 (b940084d7 2026-09-28)` and Cargo
  `1.99.0 (5f94df478 2026-08-27)` on Linux x86_64.
- Locked, offline dependencies: ic0 1.2.0, ic-cdk 0.20.3, Candid 0.10.37,
  ic-testkit 0.17.3 and sha2 0.10.9. No dependency upgrade occurred.
- Explicit PocketIC server 16.0.0 at
  `/home/adam/.cache/canic/pocket-ic-server-16.0.0-pocket-ic-x86_64-linux/pocket-ic`.
  The harness verifies its pinned digest and exact version before startup.
- One application subnet and two distinct canisters installed with the same
  fixture Wasm, each funded with 1,000,000,000,000 cycles. Startup and request
  bounds are 30 seconds; server hard lifetime is 120 seconds.
- This repository's `target/` owns build and log artifacts. The Wasm example is
  704,306 raw bytes, including fixture/CDK code; this is not a core-library
  footprint or a before/after performance comparison.

All paths in this table are repository-relative, except the server path above.
Each digest is SHA-256.

| Input or artifact | Digest |
| --- | --- |
| `Cargo.toml` | `67af4353e7e79fa7ef88c97198299d35ad035b7233d212493565cffe72879912` |
| `crates/ic-metrics/Cargo.toml` | `aed2e3083e3e84224ae157b1d6ad0e9dc79e314f5a8452cc81368b03678cb761` |
| `Makefile` | `c12a8e460e8785eefec96e8f45d0ab3ddb4e159443601198bf99e5189d4af6b8` |
| `Cargo.lock` | `9c23edf34f84832858976627f7fd8fde1b33523d3595be50d6a42dd5a9ca8f5f` |
| `crates/ic-metrics/src/lib.rs` | `fe19e7c9fb59fb30c841a882b8dbf86701dc67e83387ebce99440c8ae35b1f14` |
| `crates/ic-metrics/src/summary/mod.rs` | `4d7edef98039c02d03658170a4dfaf489e8dcb1b86d841ce9520d9a325f81362` |
| `crates/ic-metrics/src/ic/mod.rs` | `e50acf468721ddd321b7bc2c0998d04df631c78e077ee5ddd2be1103cfdc5e91` |
| `crates/ic-metrics/examples/ic_reader_canister.rs` | `1a3afd9ec92931d7b21c2a090c50fe76f12e60110836fed94021ceac35085b7b` |
| `crates/ic-metrics/tests/ic_reader.rs` | `f1e362f2759776da2fbb9b2c1b458cbff5b9aaf034049f3f76145f0f98d84c98` |
| PocketIC server | `69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792` |
| `target/wasm32-unknown-unknown/release/examples/ic_reader_canister.wasm` | `985e919bd5203345c57739ecd71ffac93df569692b6eee41674f2f09da3b2610` |
| `target/debug/deps/ic_reader-005379a81ee26053` | `f6a265504eff6f3be4f8fb32c365c4ddfb67406eada8af382d699d0588a9333b` |
| `target/evidence/reader-query/qualification.log` | `5826941e1bcbbf5161821d006f121db7f104299921e7ffe24179d5e223457404` |

## Commands and qualification

After checking for active builds, `make fmt` ran before the selected strict
Clippy gates. Both passed with locked, offline dependencies:

```sh
cargo clippy -p ic-metrics --all-targets --locked --offline -- -D warnings
cargo clippy -p ic-metrics --lib --example ic_reader_canister --locked --offline --target wasm32-unknown-unknown --features ic -- -D warnings
```

The exact runtime command succeeded, running only the named ignored reader test:

```sh
set -eo pipefail
mkdir -p target/evidence/reader-query
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target CARGO_NET_OFFLINE=true CARGO_BUILD_JOBS=2 make reader-check POCKET_IC_BIN=/home/adam/.cache/canic/pocket-ic-server-16.0.0-pocket-ic-x86_64-linux/pocket-ic 2>&1 | tee target/evidence/reader-query/qualification.log
```

The expanded example also passes:

```sh
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target cargo +1.88.0 check -p ic-metrics --example ic_reader_canister --target wasm32-unknown-unknown --features ic --locked --offline
CARGO_NET_OFFLINE=true make fmt-check shared-tooling-check docs-check
cargo package -p ic-metrics --locked --offline --allow-dirty
```

These are focused checks, not the complete local test/CI gate. Package verification
uses the existing 0.1.5 metadata and does not upload anything. No runtime
qualification attempt failed in this batch.

## Observations

Synchronous update and ordinary-query arrays have this order: direct counter 1,
shared counter 1, direct counter 1, shared counter 1 after work, direct counter 1.
Shared reads lie within direct reads and increase after work:

| Execution | Readings |
| --- | --- |
| Update | `[561717, 561917, 562117, 662372, 662572]` |
| Ordinary query | `[320481, 320681, 320881, 421136, 421336]` |

The replicated callback readings are
`[658209, 1234505, 1234705, 1234905, 563953]`: shared counter 1 before await,
direct/shared/direct counter 1 in the callback, then callback message counter 0.
The shared callback reading retains prior execution work and lies within its
direct bracketing reads.

Composite queries use that same five-element caller layout followed by the
downstream query's five synchronous readings. Caller callback counters are read
before decoding the downstream response:

| Downstream iterations | Caller readings | Downstream readings |
| --- | --- | --- |
| 0 | `[676811, 1261569, 1261769, 1261969, 563917]` | `[572122, 572322, 572522, 572760, 572960]` |
| 1,000,000 | `[676811, 1261569, 1261769, 1261969, 563917]` | `[572122, 572322, 572522, 10572777, 10572977]` |

For each query, the caller's shared callback reading minus its shared pre-await
reading is **584,958 instructions**. Downstream shared-after minus shared-before
is **438 instructions** for zero iterations and **10,000,455 instructions** for
one million. Increasing downstream work leaves the caller interval unchanged.
Each subtraction uses one established local context. The assertion compares
completed interval costs rather than absolute snapshots across different calls
or canisters. This demonstrates downstream-work exclusion in this fixture,
consistent with the [System API contract](https://docs.internetcomputer.org/references/ic-interface-spec/canister-interface/#performance-counter).

## Scope

These are IC instruction observations from actual PocketIC canister execution,
not native substitutes, elapsed-time benchmarks, estimated cycles, mainnet
observations or evidence of a performance improvement. The fixture does not
qualify arbitrary query graphs, traps, concurrent callback attribution or complete
consumer lifecycle behavior. Library policy and production endpoints are unchanged;
the added methods belong only to this qualification canister.

At the time of this execution, ordinary CI compiled but ignored the explicit
server-dependent test. Subsequent [CI preparation](reader-ci.md) configures its
explicit execution; hosted runs and both macOS runtime checks remain unqualified.
Owning follow-up remains in
[reader extraction #3](https://github.com/dragginzgame/ic-metrics/issues/3).

## Subsequent ic-testkit 0.18 qualification

Later on 2026-10-06, the existing worktree's development dependency requirement
changed to `ic-testkit = "0.18"`, selecting ic-testkit 0.18.2 and want 0.3.2 in
Cargo.lock. These maintainer-side edits were preserved. Package metadata remains
0.1.5; library, fixture, server and Wasm identities remain those recorded above.
The original 0.17.3 input table and execution log remain historical evidence.

The new selected graph passes locked offline host Clippy with warnings denied
and compilation of the named reader harness with Rust 1.88:

```sh
cargo clippy -p ic-metrics --all-targets --locked --offline -- -D warnings
cargo +1.88.0 check -p ic-metrics --test ic_reader --locked --offline
```

Actual Linux PocketIC execution also passes with the same instruction readings:

```sh
mkdir -p target/evidence/reader-testkit-018
set -eo pipefail
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target CARGO_NET_OFFLINE=true CARGO_BUILD_JOBS=2 make reader-check POCKET_IC_BIN=/home/adam/projects/ic-metrics/target/tools/reader-pocketic.2UyjEN/pocket-ic 2>&1 | tee target/evidence/reader-testkit-018/qualification.log
```

| Subsequent repository-relative input or artifact | SHA-256 |
| --- | --- |
| `Cargo.toml` | `5cf0d8736d42a083844f78596eb66c836a906b23731c613e1cdc9e2944ecc777` |
| `Cargo.lock` | `e205bbcc69347558dd54bc292a7c24997a65dfaec0dd8433a78eb58951a3dbfa` |
| `target/debug/deps/ic_reader-38ae3a6a68bc6059` | `eb3d88481d4d633d54ef2a7a054d44f0c96a5e9520e5492df91f5a23e50137c1` |
| `target/evidence/reader-testkit-018/qualification.log` | `296f212f1123711fdcd58b92ad3bdae82da655443bf70f2c96f43043e6dba414` |

No runtime attempt failed on the new graph. These focused checks do not establish
hosted CI, macOS execution or complete consumer lifecycle qualification.
