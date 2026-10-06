# Published 0.1.6 qualification

The maintainer's `v0.1.6` tag resolves to
`6cf2c3851019b1e989e42c5f79a4845ae911dc7f`, matching canonical Cargo metadata
and finalized changelog identity. This record distinguishes the published package,
exact tagged hosted execution and later documentation work. The earlier
[query](ic-reader-query.md) and [CI preparation](reader-ci.md) evidence retain
their own pre-release source, package and failed-attempt identities.

## Registry artifact

The [official sparse index](https://index.crates.io/ic/-m/ic-metrics) records
non-yanked 0.1.6 with Rust 1.88 minimum and optional target-specific ic0 1.2.0.
The [published archive](https://static.crates.io/crates/ic-metrics/ic-metrics-0.1.6.crate)
has SHA-256 `30fa04fd11a6f844355ed8016f3df7d923d057325db9c3089f11246cacb1ff82`.
Its embedded Git identity matches the tag; every packaged Rust library, example
and integration-test source, README and license match the corresponding tagged
files. Library runtime source is also identical to tagged 0.1.5. Publication does
not itself prove consumer adoption or runtime qualification.

Archive and index inputs are retained under `target/evidence/release-016/`.
A separate registry consumer there requires `ic-metrics = "=0.1.6"`; its optional
fixture feature enables the published `ic` feature. The only selected dependency
packages are ic-metrics 0.1.6 and its existing optional ic0 1.2.0. Explicit cache
preparation created the fixture's independent lockfile without changing the
repository lockfile. Linux x86_64 passes all four locked offline Rust 1.88 checks:

```sh
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target cargo +1.88.0 check --manifest-path target/evidence/release-016/registry-fixture/Cargo.toml --locked --offline
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target cargo +1.88.0 check --manifest-path target/evidence/release-016/registry-fixture/Cargo.toml --target wasm32-unknown-unknown --locked --offline
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target cargo +1.88.0 check --manifest-path target/evidence/release-016/registry-fixture/Cargo.toml --features ic --locked --offline
CARGO_TARGET_DIR=/home/adam/projects/ic-metrics/target cargo +1.88.0 check --manifest-path target/evidence/release-016/registry-fixture/Cargo.toml --target wasm32-unknown-unknown --features ic --locked --offline
```

The fixture is `no_std` and records a zero sample through the published summary.
Its reader import/caller exist only under the IC target and enabled fixture
feature, preserving native compilation without a substitute. The README import
snippet is identical to that checked boundary. These are compilation checks,
not new IC instruction measurements or actual Candid generation.

| Registry fixture input under `target/evidence/release-016/registry-fixture/` | SHA-256 |
| --- | --- |
| `Cargo.toml` | `c9dfaab5e79fe723b08bbd1b8550d627d536c79aa5e7d995d6a3406b701d98d1` |
| `Cargo.lock` | `1295b450023c7eda4f2560c2d821a31d0b5f4e284fade48a312e0f95e3e8ce88` |
| `src/lib.rs` | `aaee70e710534d5160691953f69563fdd8ed59f4bf7c254e00c0d7c524e8b890` |

## Exact-release hosted execution

[CI run 37431032911](https://github.com/dragginzgame/ic-metrics/actions/runs/37431032911)
is the push run for the exact release commit, attempt 1.

| Job | ID | Observed qualification |
| --- | --- | --- |
| Ubuntu 24.04 x86_64 | `112161685004` | Native gate, pinned reader execution and evidence upload succeeded |
| Linux MSRV | `112161684777` | Succeeded |
| macOS 15 Intel | `112161685092` | Native gate, pinned reader execution and evidence upload succeeded |
| macOS 15 Apple Silicon | `112161685098` | Native gate, pinned reader execution and evidence upload succeeded |

The downloaded Linux evidence ZIP has SHA-256
`cb944d3f93236bd805f198df50b638701df5acea6275aecbdfe252e9c4f29a2d`, matching
GitHub's artifact digest for artifact `11397370949`. It is retained as
`target/evidence/release-016/ic-reader-ubuntu-016.zip`; decoded job logs are also
retained locally. The artifact names the exact commit, run, attempt, Linux x86_64,
Rust 1.99.0 and Cargo 1.99.0. All recorded source hashes match the tagged files,
including the release manifests/lock and reader fixture. Outcomes for inputs,
integrity checks, provisioning and execution are all `success`. Each uploaded
log and the Wasm artifact match the recorded artifact hashes.

PocketIC binary digest is
`69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792`.
The Linux fixture Wasm is 703,269 raw bytes with SHA-256
`ef24e4b8d35a97403d178b50a0275a0f8807bfa2db05a4999f23d324f1d80eea`.
This is fixture/CDK artifact identity, not a core footprint or claimed reduction.
The native gate includes strict Clippy before later validation, and the explicit
reader step passes its single named PocketIC test. The artifact retains:

- Update readings `[561717, 561917, 562117, 662372, 662572]`.
- Replicated callback readings `[658209, 1234505, 1234705, 1234905, 563953]`.
- Ordinary-query readings `[320481, 320681, 320881, 421136, 421336]`.
- Composite caller readings `[676811, 1261569, 1261769, 1261969, 563917]`
  for both downstream workloads.
- Downstream readings `[572122, 572322, 572522, 572760, 572960]` at zero
  iterations and `[572122, 572322, 572522, 10572777, 10572977]` at one million.

The layout is the same as the query record. Each subtraction uses one established
local counter context. The caller's completed interval is 584,958 instructions
in both queries; downstream intervals increase from 438 to 10,000,455. This
demonstrates downstream-work exclusion for this fixture without comparing absolute
snapshots across canisters or claiming a performance improvement.

## macOS execution

Apple Silicon artifact `11397645977`, retained as
`target/evidence/release-016/ic-reader-macos-arm-016.zip`, has verified ZIP digest
`ae5add910432ccae8846c688ae6f2354d7b70c38efa778c1e8c7f47195d06310`.
Its captured host is Darwin arm64, with the same release commit/run/attempt and
Rust/Cargo versions. All source hashes match the tag, all four outcomes are
successful, and uploaded log/Wasm hashes match its manifest. Server digest matches
the ARM pin `781f643d4b16105e7544ca810a972f99c0ef1919016c680faa93f10909a14496`.
Its fixture Wasm is 703,525 raw bytes with SHA-256
`1bc70fe99247cddd16c27acb4b40ae30bcb5f0b709008ffc351a79ff6dd59c9e`.

The ARM execution also passes direct bracketing, replicated callback continuity,
ordinary queries and composite callbacks. Its caller interval is 164,958
instructions for both workloads; downstream intervals remain 438 and 10,000,455.
Its absolute readings and Wasm identity differ from the Linux record. Each host
is qualified against its own inputs and local context intervals; these results
do not assert identical absolute readings across hosts or establish a performance
comparison.

Intel artifact `11397871875`, retained as
`target/evidence/release-016/ic-reader-macos-intel-016.zip`, has verified ZIP digest
`ff8b83dad762668ce05a99d52bbb7567ae4719c1928984ba5bdebd7ffe00c656`.
It records Darwin x86_64 with the same release/run/attempt and toolchain versions.
All source hashes match the tag, all four outcomes are successful, and uploaded
log/Wasm hashes match its manifest. Server digest matches the Intel macOS pin
`b8233ebee53452db7465b43e7b2ff80f2e1445dc148eb2b4b237493d8d15ec66`.
Its fixture Wasm is 703,587 raw bytes with SHA-256
`b9e6337bb46b6f55440f749b73354c511c755e29f171886d7ddde05c6174a03d`.
Its readings match the Linux values above: caller intervals remain 584,958 while
downstream intervals increase from 438 to 10,000,455 instructions. This comparison
describes the observed results; the maintained test qualifies each local context
independently and does not assert cross-host counter identity.

## Scope

The successful native runs on all three hosts qualify explicit provisioning,
reader execution and Actions artifact upload, beyond the earlier local shell
checks. Linux MSRV also passed, completing the declared hosted matrix at this
exact release. Every job succeeded on attempt 1; no failed hosted qualification
attempt was observed. This evidence does not qualify later documentation worktrees
or entire consumer releases. No full local test/CI gate, mainnet
execution, timing benchmark, new consumer lifecycle measurement or agent release
effect was performed. Owning qualification remains coordinated in
[reader issue #3](https://github.com/dragginzgame/ic-metrics/issues/3).
