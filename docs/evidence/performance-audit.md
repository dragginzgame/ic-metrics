# Wasm and instrumentation cost audit

## Scope and conclusion

Linux x86-64 audit on 2026-10-06 against ic-metrics tag `v0.1.6`, commit
`6cf2c3851019b1e989e42c5f79a4845ae911dc7f`. Library, example, harness, manifests
and lockfile match that tag. Existing pending documentation edits were preserved.
No production Rust, dependency selection, build profile or package version changed.

The arithmetic core has no allocations, registries, formatting or serialization.
`MeasurementSummary` retains four `u64` observations; consumer labels and lifetime
identity remain outside it. Source review and compiler probes did not establish
a useful core optimization. Removing saturation, latest/maximum or empty/zero
distinctions would change maintained behavior rather than qualify a saving.

The measured size reductions below apply to the complete **reader test canister**,
including CDK, Candid, allocation, reply encoding and callback machinery. It does
not exercise the summary recorder, and its footprint is not ic-metrics' marginal
contribution to an application. Consumer costs were inspected separately, without
building or changing sibling repositories.

## Inputs and reproduction

- Rust/Cargo 1.99.0 on `x86_64-unknown-linux-gnu`; rustc
  `b940084d7eb6a299eb4bfeb8e34901bc051e7ac4`, LLVM 23.1.1.
- Default Cargo release profile, target `wasm32-unknown-unknown`, feature `ic`.
  No `RUSTFLAGS` or `CARGO_ENCODED_RUSTFLAGS` override was present.
- Root manifest SHA-256
  `f93a7a934828f58de0024700d5d56bdf6b5901649ecf3eb8351b58fff6ca469f`;
  lock SHA-256 `1b0809ede56837625c973244ed28d9e2657c1ea3a4f98ad73a18cfaa0df93ab8`.
- Example SHA-256
  `1a3afd9ec92931d7b21c2a090c50fe76f12e60110836fed94021ceac35085b7b`;
  maintained harness SHA-256
  `f1e362f2759776da2fbb9b2c1b458cbff5b9aaf034049f3f76145f0f98d84c98`.
- Binaryen `wasm-opt` 132 and Twiggy 0.8.0, already installed locally.
  Executable SHA-256 identities are respectively
  `1014958e6f20d412f1542320b43970214b0fb1ed780595e8f7c0d8761ed53725` and
  `4f3c1a2136f0c1ca7dbf02206f1c79f010e8545aec51b6e1a1281b25c2cbbbb1`.
- PocketIC 16.0.0 Linux executable SHA-256
  `69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792`.
  The harness verifies its digest/version before startup and uses one application
  subnet with bounded server/request lifetime, as in the maintained reader check.

Artifacts and experimental compiler/cycle probes are retained under
`target/evidence/size-audit/`. They are local evidence, not maintained production
APIs or an implicitly executed benchmark suite. All Cargo commands used this
repository's `target/`, the unchanged selected lockfile and offline dependencies.

Build and transform the same artifact, retaining the original:

```sh
CARGO_TARGET_DIR="$PWD/target" cargo build -p ic-metrics \
  --example ic_reader_canister --target wasm32-unknown-unknown \
  --features ic --release --locked --offline
mkdir -p target/evidence/size-audit
cp target/wasm32-unknown-unknown/release/examples/ic_reader_canister.wasm \
  target/evidence/size-audit/reader-baseline.wasm
wasm-opt target/evidence/size-audit/reader-baseline.wasm --strip-debug \
  -o target/evidence/size-audit/reader-stripped.wasm
wasm-opt target/evidence/size-audit/reader-baseline.wasm -Oz --strip-debug \
  -o target/evidence/size-audit/reader-oz.wasm
```

For each artifact, the maintained named test was run with an explicit
`POCKET_IC_BIN` and `IC_METRICS_READER_WASM`:

```sh
CARGO_TARGET_DIR="$PWD/target" cargo test -p ic-metrics --test ic_reader \
  --locked --offline call_context_reader_matches_ic_and_survives_callback \
  -- --exact --ignored --nocapture
```

All three runs passed update/query bracketing, replicated and composite callbacks,
and downstream-query exclusion. This qualifies those exercised contracts, not
arbitrary Binaryen transformations of every consumer canister.

## Raw Wasm bytes

| Reader artifact | Bytes | Reduction from baseline | SHA-256 |
| --- | ---: | ---: | --- |
| Baseline | 704,146 | — | `157910260034347201f0b8619c3937e844337ee333be20baa76097ea3f19f565` |
| Strip/re-encode | 524,154 | 179,992 (25.56%) | `09a0a6e8038d3df6ba9d7b0c7a3aeed9d1797f739de0441ee6651ba55ee7e036` |
| `-Oz`, strip/re-encode | 469,706 | 234,440 (33.29%) | `1a63f49bd520d598cfb9c534382f809e9722c889fc3d3099583352f22200f44d` |

Twiggy attributes 146,338 baseline bytes to function names and 68,218 to `.rodata`.
Large reachable functions include Candid decoding, data encoding, float formatting
and allocator code. There is no separately retained ic-metrics reader function
in that report; the imported `ic0.performance_counter` entry occupies 26 bytes.
Inlining means absence of a named symbol is not a standalone marginal-size proof.

`--strip-debug` also rewrites the module: the raw code-section payload falls from
485,762 to 452,196 bytes, while `-Oz` yields 400,318 bytes. Therefore the entire
25.56% reduction must not be labelled debug metadata alone. Raw non-custom section
hashes differ, and printed modules retain different names; those comparisons
do not establish byte identity. The measured instruction/cycle behavior below is
the runtime evidence for these workloads.

## IC instructions and actual cycle charges

Within each established update context, the measured interval from the shared
pre-work read to the direct post-work read is 100,655 instructions for baseline
and stripped artifacts, and 95,645 with `-Oz`. This includes the bracketing reader
overhead and fixture loop. Downstream query work still leaves the caller's
composite callback interval unchanged: 584,958 instructions in baseline/stripped,
and 584,272 with `-Oz`. These are completed local intervals, not subtraction of
absolute counters from unrelated contexts.

A local copy of the maintained harness performs three sequential `probe` updates
immediately after installation, reading `pic.cycle_balance(canister)` before
and after each completed call. It uses checked subtraction and prints both raw
balances. No explicit tick, call attachment, inter-canister call or cycle top-up
occurs inside these intervals. Installation is excluded. It then runs the same
maintained reader cases. All three artifact runs pass.

| Artifact | First update charge | Second update charge | Third update charge |
| --- | ---: | ---: | ---: |
| Baseline | 7,144,150 cycles | 7,143,146 cycles | 7,144,135 cycles |
| Strip/re-encode | 7,144,150 cycles | 7,143,146 cycles | 7,144,135 cycles |
| `-Oz`, strip/re-encode | 7,138,433 cycles | 7,137,481 cycles | 7,138,454 cycles |

The observed `-Oz` update-charge reduction is 5,665–5,717 cycles, approximately
0.08%, in this fixture. These are actual PocketIC balance deltas, including the
complete measured update's charging, not estimates derived from instructions.
They are three observations per artifact in a local application-subnet model;
they do not establish mainnet savings or a general workload distribution.
The smaller byte count alone does not prove lower execution cost. The
[IC cost reference](https://docs.internetcomputer.org/references/cycle-costs/)
separates execution, storage and message costs.

## Compiler boundary checks

Local `no_std` probes compare shared functions with direct arithmetic/IC binding
calls, retaining function pointers through safe `#[used]` statics so LLVM emits
the bodies. They use the locked-built Wasm rlibs and Rust 2024, with `rustc
--crate-type lib --target wasm32-unknown-unknown --emit=llvm-ir` at optimization
levels `3` and `z`.
The linked dependencies use the default release build; `3`/`z` here selects the
probe caller's optimization, not a complete consumer profile comparison. The
five linked metrics/ic0/testkit/sha2 rlib identities are retained in
`link-inputs-sha256.txt`, SHA-256
`40fe3fb0e1ffae07805269867f869ab4dae0df4d0f35991302abf4b2485c16b1`.

At level `3`, shared `record_sample` and direct saturating arithmetic point to
the same optimized function body. At `z`, both bodies contain the same two loads,
saturating additions and stores, without an ic-metrics call. Two-record summary
probes reduce to count 2, a saturating total, the second value and the maximum,
with no summary copy or getter call; LLVM ordering/metadata differ. At both levels,
the shared reader aliases the direct reader body, which calls only the imported
IC counter with argument 1. These selected probes provide code-generation evidence,
not instruction/cycle measurements of arbitrary consumer call sites.

Retained probe SHA-256 identities:

| Evidence | SHA-256 |
| --- | --- |
| `arithmetic_codegen.rs` | `f4cf675e428123d0002d1392d22ad35ea9767984ef7df76bc327a66ca8498b9e` |
| Arithmetic LLVM, level `3` | `1994b81d44de7bd6f8186a2af0978427f5a0083d7946565c2d802398166d382f` |
| Arithmetic LLVM, level `z` | `e1a4758c074cb8384febf16b7488dac80ccf7ed936fcbdeffa47aebb26059874` |
| `reader_codegen.rs` | `7d4eb49ca8d9eb8fe33972bbc077231d9ebc06aca6b2a3c843a6baa475d495b9` |
| Reader LLVM, level `3` | `055877fbd06816b4e089a1e9e3543c789321ad9349621a2170b35618c9ddbff0` |
| Reader LLVM, level `z` | `f3922482833f59541332f0e7adbec18cdab76fcec9ebb2b3d115a85e93bad755` |
| `cycle_probe.rs` | `e647c1202a1ab8b31ccf2fc5897c666d4448f0161ee5db145e9fb6233d88a92a` |
| Compiled cycle harness | `a5730848aa330e0b3c25a5627b03a6831e9d23c291cde3cc5b31d911e0a82133` |
| Baseline reader execution log | `3e3475e3fab073ed0d1dd7a28eb5f1be19463652a007ae3603211d08f43f0534` |
| Stripped reader execution log | `35e61c3de65d087f87f94875b8acff7b405aae7c7bf7fb83fe0b7ef16be8f878` |
| Optimized reader execution log | `c131e2d0acf07cf2c7d1854f122ede1b9d228ef7bac7d3730d1e4cc706867b72` |
| Baseline cycle log | `4181c6d98db808f1c82388a40d8e7400fb46c9590f9fc1c863ff45dde45ca888` |
| Stripped cycle log | `65116b81ddb55f8d62970a0ff6fed6453d26d28d04d680288caab718dbc959cc` |
| Optimized cycle log | `859a48cc9fcd8e6444abfb1c47028a437f7eb4084a787796a20daee62922bbfe` |

Exploratory attempts: library LLVM emission initially had no emitted functions;
retaining probe pointers supplied the observable boundary. The first local cycle
harness failed compilation because `io::ErrorKind` does not implement `Error`;
the corrected typed `io::Error` compiled before execution. Initial Twiggy
inspection found no existing local Wasm artifact, so the baseline was rebuilt.
These attempts supply no performance result and did not alter maintained code.

## Consumer source findings and ownership

IcyDB source at `20a9aa7d9802cf73ad17ed9444fc06a2c37e2909` allocates an entity-path
String before every map entry lookup, including repeated observations. The
inspected metrics state file matches the commit despite unrelated working edits.
[IcyDB #300](https://github.com/dragginzgame/icydb/issues/300) owns the proposed
borrowed-hit lookup and cold-insertion tradeoff. Its report sorting is intentional:
it selects a bounded path prefix and then sorts by instruction total/hits/path.

Clean Canic `e1a211a00f01568ccc99bedc494c62a7141444dd` allocates endpoint names and
checkpoint scope/labels for every record; the core `perf!` macro formats a label
which the recorder copies again. [Canic #456](https://github.com/dragginzgame/canic/issues/456)
owns that allocation finding. The redundant map-order report sort remains
[Canic #451](https://github.com/dragginzgame/canic/issues/451); label/cardinality
policy stays in [Canic #321](https://github.com/dragginzgame/canic/issues/321).

Canic's async generated wrapper still enters a global performance stack, awaits
the handler and exits that same stack without a local identity token. The source
premise of [Canic #99](https://github.com/dragginzgame/canic/issues/99#issuecomment-6012086897)
was rechecked, without reproducing live interleaving. The shared counter reader
does not repair consumer attribution. That issue owns independent-context
execution evidence; synchronous nesting tests do not qualify async interleaving.

IC Timers at `aa0e933eb56ff0e3e6832ad822f77c95a1392199` records its instruction
summaries directly into fixed role fields. This review found no equivalent
repeated-label allocation in that arithmetic path. It did not audit the complete
timer delivery/scheduling cost or measure a timer canister.

IcyDB's `wasm-release` and Canic's release profiles already select size optimization,
LTO, one codegen unit and symbol stripping. Repeating those settings in this
library would not tune its dependents: [Cargo profiles belong to the consumer
workspace](https://doc.rust-lang.org/cargo/reference/profiles.html).
Size-oriented profiles and post-link optimization need comparisons on each
consumer's actual canister workloads, with attribution symbols retained in a
separate analysis artifact. This audit changed no consumer build settings.

Focused root formatting/snapshot verification and warning-denied host/Wasm Clippy
pass. Only the named reader execution and local audit probes ran; no full local
test/CI gate, native timing benchmark, release, commit or publication occurred.
