# Consumer lookup measurements

The compatible lookup changes were applied to the primary IcyDB and Canic
worktrees after the [reader audit](performance-audit.md). They change consumer
allocation and reporting work, not ic-metrics arithmetic or attribution policy.
They are uncommitted; package versions and existing dependency selections remain
unchanged. IC Timers was not modified for this batch.

## Inputs and method

Linux Rust 1.99 built Wasm with size optimization (`z`), fat LTO, one codegen
unit, symbol stripping and aborting panics. Each probe uses its owner's `target/`
and a separate initial, unpublished fixture manifest. Every selected dependency
version, source and checksum was checked against the owner's existing lockfile.
Canic selects ic-metrics 0.1.5; IcyDB's current lock selects 0.1.6. Neither root
lockfile was changed by this work.

PocketIC 16.0.0, SHA-256
`69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792`,
executes actual Wasm on one application subnet. Each scenario uses three fresh
canisters. Two zero-valued keys are seeded outside the instruction bracket.
Repeated scenarios record 10,000 samples; cold scenarios insert 1,000 distinct
labels; report scenarios collect 1,000 two-key reports. Count, total and table
cardinality are checked after each run. All three instruction and charge
observations agree within each artifact/scenario.

Instruction counts bracket the probe loop inside the IC call context. Cycle
charges are actual canister balance differences over the whole update, including
dispatch/encoding overhead but excluding installation. They are not estimates
derived from instructions, native timing results or mainnet observations.

Canic links the actual primary Core library. IcyDB mechanically extracts the
before/after entity-recorder bodies into an isolated map fixture retaining the
same counter fields. Its fixture omits the other ambient state, database runtime,
spans and journal; its report scenario clones only that map. Neither fixture
establishes complete consumer canister size or release qualification.

## Final results

| Canic scenario | Before instructions | After instructions | Before cycles | After cycles |
| --- | ---: | ---: | ---: | ---: |
| Repeated endpoint | 11,080,236 | 5,220,236 | 18,098,830 | 12,238,856 |
| Repeated checkpoint | 20,030,236 | 8,110,236 | 27,048,830 | 15,128,856 |
| New checkpoints | 17,182,532 | 31,710,300 | 26,657,645 | 40,507,669 |
| Two-key reports | 2,578,236 | 2,464,236 | 9,596,830 | 9,482,856 |

| IcyDB isolated scenario | Before instructions | After instructions | Before cycles | After cycles |
| --- | ---: | ---: | ---: | ---: |
| Repeated measured entity | 9,630,238 | 3,990,238 | 16,642,400 | 11,002,514 |
| Repeated scoped entity | 9,590,238 | 3,980,238 | 16,602,400 | 10,992,514 |
| New entities | 8,821,517 | 15,070,739 | 16,082,960 | 22,332,296 |
| Two-key map clones | 1,995,238 | 1,995,238 | 9,007,400 | 9,007,514 |

Repeated observations use roughly 53–60% fewer instructions in these fixtures.
New-key work costs roughly 85% more instructions in Canic and 71% more in IcyDB:
the borrowed miss is followed by an owned insertion lookup. This favors stable,
repeated labels and paths. It is not a universal performance improvement or
evidence for unbounded dynamic labels. Cycle savings also depend on whole-call
overhead and the actual workload.

Raw Canic fixture Wasm shrinks from 332,503 to 328,805 bytes (3,698 bytes).
IcyDB's isolated fixture grows from 296,447 to 296,654 bytes (207 bytes).
There is no demonstrated whole-IcyDB Wasm reduction.

## Source and artifact identity

Canic baseline is committed `e1a211a00f01568ccc99bedc494c62a7141444dd`;
the final dirty `perf.rs` SHA-256 is
`01d5d77aca2a2fbec1f0ee244310b0e349599fd4a2f2005875bb0615f1632a77`.
IcyDB baseline is committed `20a9aa7d9802cf73ad17ed9444fc06a2c37e2909`;
the final dirty metrics `state.rs` SHA-256 is
`32945e458d872c1f27110e7eaa156b9641aeadda4a290fa7d279ff7ac52fda1b`.
Concurrent unrelated IcyDB changes were preserved.

| Input/artifact | SHA-256 |
| --- | --- |
| Canic root lock | `f0d49d1b6fc8c370322cb0661fa88ec677351098fc24e7dc61c668660dc7a052` |
| Canic fixture lock | `402b4854693071d4288d25a071018e8569b9cdc56b437f378377bb15be8226a6` |
| Canic baseline Wasm | `c18f9001a9d6e3be251774cfc7cbe80bd2bc1ed8401aa389f0b05e5029c8bf19` |
| Canic final Wasm | `35768521217146fa6fe478ca6d6c2eaecf005faf6f1349929de8248bafcc20ee` |
| IcyDB root lock | `2b292946d6f3a2283dc10d05863a360b6fdaf2d271c82572f72edad02f022db9` |
| IcyDB fixture lock | `e41ffb4e46ec0cb47f718fb2d139918442d39cb5ca9a4fc6ca1f74b4cc15cb40` |
| IcyDB baseline Wasm | `82b72e13a9fa9f6afc6e27b8160ff7a0a9e81d52dfdd73248a8adf9b3c51d738` |
| IcyDB final Wasm | `034fb20bbec1cccd191dd318c0875474f210a103120832c60601bbb5bd01e7af` |
| Measurement host source | `9699aab5222cf0cfba2b393fe8dabff8f4f50109b919013d553ae69d6efce21e` |
| Canic final measurement log | `9651672861e35781c0662c7bace7bf77948c4969b10ab8a012b4bc04d10fb81e` |
| IcyDB measurement log | `faad79d996912b913f53b952618523ce12dcee15d771546e8891b66e17551f0e` |

The root's ignored `target/evidence/consumer-improvements/` retains the Rust
host harness, measurement logs, input identities and artifact hash manifests.
Each consumer retains its fixture manifest, lock, source, Wasm and build logs in
its own `target/evidence/metrics-improvements/`. Canic's first candidate and
measurements remain separate from the final candidate. An initially generated
alternate dependency graph was rejected before measurement; its build artifact
is retained as `alternate-graph.wasm`, not qualified as the baseline.
IcyDB's initially mismatched fixture metrics selection was also refused before
building. No owner dependency graph was upgraded.

## Async attribution verification

A separate Canic source-copy probe exposes only audit trampolines around the
actual private endpoint enter/exit functions. Their bodies, the counter reader
and the corresponding `_at` functions match committed source byte for byte.
Two real async IC updates are queued before either completes; both await a
self-call. This exercises overlapping call contexts without native counter
substitution. It does not exercise the full managed Canic lifecycle.

| Endpoint | Valid interval from surrounding IC reads | Recorded total |
| --- | ---: | ---: |
| a | 976,726–979,030 | 1,473,794 |
| b | 1,216,697–1,218,747 | 1,463,693 |

Both totals lie outside their own intervals, confirming the concern in
[Canic #99](https://github.com/dragginzgame/canic/issues/99#issuecomment-6012668977).
The lookup changes leave those attribution functions unchanged and do not fix
the defect. Checkpoint `PERF_LAST` interleaving was not separately qualified.
The scope probe Wasm SHA-256 is
`15af1bf5b1d3660182e4c425f1d165746300969a1dcf87ce476d19387532184a`;
its execution log SHA-256 is
`002876626256248c264e57288daf0b335327e15176bb382aad635ecdd3b1a192`.
Source, lock and artifact inputs remain in Canic's owned `scope-canister` fixture
directory and the root's `interleaving.rs`/execution log.

## Focused qualification

Both consumers ran `make fmt` before selected Rust checks. Warning-denied native
Core library/test Clippy and Wasm Core library Clippy pass. Ten IcyDB metrics
state tests and five Canic perf tests pass, covering distinct keys, zero,
saturation, reset and report ordering. Canic's focused Rust 1.91 Wasm library
check passes after explicitly installing that toolchain's missing target; the
initial missing-target failure log is retained. IcyDB's Rust 1.96 minimum was
not separately tested because that toolchain is not installed.

These are focused Linux checks and local IC execution. No broad test/CI gate,
macOS execution, release, commit, push or package-version change was performed.
The compatible drafts remain IcyDB 0.265.1 and Canic 0.110.53. Ownership and
follow-up remain in [IcyDB #300](https://github.com/dragginzgame/icydb/issues/300),
[Canic #456](https://github.com/dragginzgame/canic/issues/456),
[Canic #451](https://github.com/dragginzgame/canic/issues/451) and
[Canic #99](https://github.com/dragginzgame/canic/issues/99).
