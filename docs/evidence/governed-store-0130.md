# Governed stable-store boundary for 0.13

The baseline Rust sources are finalized 0.12.0 commit
`1c56fdfdd331e1bd26cfdb14519b1296ad3e88f0`. The candidate includes the incoming
borrowed-bounds validation and the prepared governed-map/kind changes. Workspace
package versions remain 0.12.0. The product lock adds only IC Storage 0.3.1,
with checksum
`9f8f32bc383c0332e671dcb7caf319608988e59c21351de82db4009985a79404`.
Memory remains 0.45.0 and stable structures remains 0.7.2.

## Collection and record contracts

`MetricsMap<M>` now uses `ic_storage::adapter::StableBTreeMap`, where M is the
runtime's backing. Its constructors require an admitted RuntimeMemory handle.
The host still owns declarations, durable allocation commitment, bootstrap,
collection opening/reopening, concurrency and reset cadence. This is IC Storage's
wrapper around the original upstream map, not its independent tree format.
Memory 0.45 handles remain cloneable; checked provenance does not supply exclusive
collection ownership. No second manager, per-metric memory ID or format reset is
introduced. Memory's separate allocator-format disposition remains host-owned.

The private typed kind owner freezes Aggregate/Summary/Histogram/Counter at
1/2/3/4. Native tests exercise every byte discriminator, independent literal V1
empty records for all families, no-write rejections and old/new map reopening.
Compiled negative examples reject raw backing and raw upstream map admission;
the positive example bootstraps once and checkpoints/reopens all four families.

## Actual IC upgrade trajectory

One local canister bootstraps permanent `probe.metrics.v1` through Memory 0.45.
The 0.12 adapter seeds four mixed-kind rows with zero and maximum u64 observations
and an exact u128 counter cap. Upgrading to the governed adapter preserves every
key/value byte and the observed allocation ID (10, selected by Memory, not the
probe). It then checkpoints another observation in each family, including actual
scalar overflow. A reverse binary upgrade to the original adapter reads every
new row unchanged. This supplies source-bound format/upgrade evidence, not first
application acceptance, a migration mechanism or authority to reset a store.

The driver records 24 updates: four stages, zero/64 load-loop iterations and
three repeats. Each iteration loads all four kinds; key/identity construction,
bootstrap and reply encoding are outside the instruction bracket. Raw Candid
row replies and all instruction/cycle/sink/ID rows are frozen. Corresponding sinks
and allocation IDs agree before/after the forward upgrade and after checkpoint/
reverse upgrade. The identity/reset unit tests retain their separate scope.

| Stage | Instructions in 64 iterations (256 loads) |
| --- | ---: |
| Original adapter | 4,080,874–4,097,051 |
| Governed adapter, retained rows | 4,067,803–4,106,459 |
| Governed adapter, subsequent checkpoint | 4,085,723–4,124,379 |
| Original adapter, subsequent checkpoint | 4,085,403–4,124,059 |

Zero-iteration brackets are 219 instructions. Raw whole-update cycle-balance
decreases are recorded separately and include setup, cold upgrade reopening and
encoding outside the brackets. No cycles are inferred from instructions.
Cost ranges overlap; there is no general improvement claim. The complete probes
are 461,341 original and 461,262 governed raw Wasm bytes (79 fewer bytes), without
postprocessing. That comparison covers the complete pending arithmetic/store
source selection, not an isolated contribution from the kind enum or wrapper.

## Frozen source and replay

The [archive](governed-store-0130.tar.gz) and
[checksum](governed-store-0130.tar.gz.sha256) explicitly retain both source trees,
the public fixture and lock, two Wasms, build logs, raw replies and measurements.
The fixture lock selects Memory 0.45.0, Storage 0.3.1, CDK 0.20.3, Candid 0.10.38
and Testkit 0.34.2. Its local package labels are 0.0.0, not release versions.
Rust 1.99.0 (`b940084d7`, 2026-09-28) builds with opt-level z, LTO, one codegen
unit, stripped symbols and aborting panics. PocketIC 16.1.0's prepared executable
SHA-256 is `b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

The initial shared-target build retained a different experiment's host driver;
it was detected before execution. Its build observations remain identified.
A fresh target compiled the selected driver, and only that binary ran the IC
trajectory. Replay uses another fresh target and verifies artifacts before use.

After preparing the selected compiler, target, locked cache and server, extract
and run `POCKET_IC_BIN=/absolute/path/to/pocket-ic bash replay.sh /absolute/path/to/ic-metrics/target/governed-replay`.
Replay verifies SHA256SUMS, rebuilds both Wasms byte-for-byte, repeats the two
upgrades on a new canister and compares every raw CSV and Candid reply. Product
native/Wasm Rust 1.91 checks and native unit/docs checks are independent evidence;
this experiment does not qualify native macOS or any downstream deployment.
No private sibling source, search excerpts or issue bodies are selected.
