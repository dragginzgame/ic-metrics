# IC reader execution evidence

This records focused Linux x86_64 qualification of the pending 0.1.5 addition,
based on published commit `1a144139a2b84e7a389d721febe79aaac3775b0c` plus the
uncommitted reader batch. Cargo package/workspace metadata remains 0.1.4; this
worktree and its package archive are not a published 0.1.5 release.

## Inputs and execution

`make fmt` ran before strict Clippy. The selected caches were prepared explicitly
with locked offline fetches for Linux and Wasm, followed by an all-target fetch.
The compiler is Rust 1.99.0, with successful library checks at Rust 1.88.0.
The backend is registry ic0 1.2.0; the fixture uses ic-cdk 0.20.3 and ic-testkit
0.17.3, locked without changing an existing dependency selection or package version.

| Input | SHA-256 |
| --- | --- |
| Root `Cargo.toml` | `99f7ce70a46ba562368078e3744b7d9d52037ca7d0ed05b0f792a6c6a2db5bfb` |
| `crates/ic-metrics/Cargo.toml` | `aed2e3083e3e84224ae157b1d6ad0e9dc79e314f5a8452cc81368b03678cb761` |
| `Makefile` | `c12a8e460e8785eefec96e8f45d0ab3ddb4e159443601198bf99e5189d4af6b8` |
| `Cargo.lock` | `619e6fc53962c1cbc6c2f2c05b4a4dec199fa7a92bb2a95fbadfc278f7b03e6c` |
| `crates/ic-metrics/src/lib.rs` | `fe19e7c9fb59fb30c841a882b8dbf86701dc67e83387ebce99440c8ae35b1f14` |
| `crates/ic-metrics/src/ic/mod.rs` | `e50acf468721ddd321b7bc2c0998d04df631c78e077ee5ddd2be1103cfdc5e91` |
| `crates/ic-metrics/examples/ic_reader_canister.rs` | `bfc9534ab6ed3320ab6ff7cd25772060a18285389d8592198737ba51281ce609` |
| `crates/ic-metrics/tests/ic_reader.rs` | `9cc3c869ea4b717156f81ef27ea76265e967a6612a45b86148d8f6ec9e581561` |
| PocketIC 16.0.0 Linux x86_64 binary | `69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792` |
| `target/wasm32-unknown-unknown/release/examples/ic_reader_canister.wasm` | `8b37f77734dfe365285726fa0c678c9933e2404a5527ad7c4ebe187559ad1dd7` |

The retained Wasm fixture is 296,291 raw bytes. This is the CDK-based test canister,
not the library's footprint or a before/after size comparison. PocketIC binary
pins for all supported hosts match the reviewed Canic tool pins; this Linux
binary's digest and `pocket-ic-server 16.0.0` output were verified before startup.
No binary was downloaded or installed by the fixture.

```sh
CARGO_TARGET_DIR="$PWD/target" CARGO_NET_OFFLINE=true CARGO_BUILD_JOBS=2 \
  make reader-check \
  POCKET_IC_BIN=/home/adam/.cache/canic/pocket-ic-server-16.0.0-pocket-ic-x86_64-linux/pocket-ic
```

Exactly one named test passed. Each observation below belongs to its own update
call; no identity or interval comparison is inferred between the two calls.

| Synchronous probe observation | Instructions |
| --- | ---: |
| Direct counter 1 before shared read | 481,674 |
| Shared reader before work | 481,874 |
| Direct counter 1 between shared read and work | 482,074 |
| Shared reader after work | 577,312 |
| Direct counter 1 after shared read | 577,512 |

The reads are ordered and the shared counter increases after the bounded work.

| Replicated callback probe observation | Instructions |
| --- | ---: |
| Shared counter before awaiting self-call | 577,986 |
| Direct counter 1 in the callback | 1,074,284 |
| Shared counter in the callback | 1,074,484 |
| Direct counter 1 after shared read | 1,074,684 |
| Per-message counter 0 later in the callback | 483,955 |

The shared read stays between the direct counter-1 reads and continues after
awaiting. It exceeds counter 0 in the callback, distinguishing call-context
continuity from the restarted per-message count. The fixture does not qualify
composite queries, traps or the consumers' attribution and lifecycle contracts.

## Compilation and package evidence

Strict native all-target and Wasm library/example Clippy pass, as do warning-denied
native/Wasm docs and locked default/IC host/Wasm library checks. Rust 1.88 checks
pass for the default host/Wasm library and the enabled Wasm reader. Normal-dependency
trees contain no dependencies for default host/Wasm or enabled native builds;
enabled Wasm builds contain only ic0. The native zero/empty and independent
saturation unit tests pass by exact named selection.

Offline Cargo packaging builds and verifies the archive under
`target/reader-package/`, preserving previous package artifacts. Its packaged
reader source and license match the repository, and the packaged reader passes
locked offline Rust 1.88 Wasm compilation. Snapshot integrity (20 files), manifest
formatting and Rust formatting pass. No full local test suite, full CI, release
command, version change or upload ran.

The first temporary canister compile lacked the CDK macro's Candid dependency;
adding it to the scratch catalog corrected the fixture. The initial Clippy
invocation encountered a build lock and was stopped; the later invocation used
the explicit owning target. Clippy then identified a documentation-backtick
warning and an empty callback's const eligibility; both were fixed before the
passing selected gate and later validation. The earlier scratch prototype's
different counts are not reused as the implemented reader's evidence.

The first direct MSRV check inside `target/reader-package/package/` was rejected
by Cargo's ancestor workspace discovery. The unchanged archive was extracted to
`/tmp/ic-metrics-reader-package-7c7a18b5` and checked there using the owning
repository's `target/reader-package` build directory. No manifest was patched to
bypass that error. The retained archive's SHA-256 is
`7c7a18b5d328f2b2909a1e3e5b883557734cf0780f222ca77cc94ea028c26988`.

Publication and named consumer adoption remain tracked in
[#3](https://github.com/dragginzgame/ic-metrics/issues/3). The current consumer
registry versions do not expose this new API. No consumer dependency is changed
to an unpublished requirement, and no local path fallback is introduced.
