# Durable scalar counter qualification

Released Metrics 0.9.6 `664b1a799fba8d7827725f7ed584e0e623c3efc3` is the
base for this compatible pending 0.9.7 addition. `MeasurementCounter` now uses
the same optional stable store as aggregates, summaries and histograms. One
permanent host allocation and one namespaced B-tree map still serve all rows.
The arithmetic crate and its dependencies are unchanged.

## Stored contract

V1 kind 4 stores a 16-byte little-endian total and one actual-overflow byte.
Only flags 0/1 are admitted; a true flag requires `u128::MAX`. Kinds 1/2/3 retain
their existing layouts, independently checked against expected aggregate,
summary and histogram bytes. No old row is interpreted as a counter or reset.
An older adapter refuses kind 4, so a host using it must retain counter-aware
code when reopening those rows. This is an additive format extension, not a
replacement reader, migration engine or change to existing encodings.

Stored zero remains distinct from absence; exactly reaching the cap remains
distinct from actual overflow. Saves reject decreasing totals, cleared overflow
flags and differing units/epochs. Identical checkpoints validate prior bytes and
perform no stable writes. Truncation, trailing data, unknown format/kind, invalid
flags and impossible numeric state return typed errors without overwriting rows.
Explicit removal admits the envelope/identity, allowing deliberate disposition
of invalid payloads; resetting still requires a new host-selected epoch.

Full Linux `make ci`, `make msrv` and `make stable-msrv` pass on the complete
pending batch, including 16 stable units and eight doctests. The arithmetic Rust
1.85 and stable Rust 1.88 floors pass native/Wasm with the unchanged product
Memory 0.38.0 lock. This does not establish native macOS or consumer acceptance.

## Actual IC execution

The isolated fixture copies the prepared arithmetic and stable source; the
archive includes the product patch, source/checksum rosters and original product
manifest/lock. It introduces no product server caller, runtime endpoint, CI gate
or new library dependency. Its five workspace-owned packages have no external
path dependencies. Its isolated lock selects Memory 0.38.0, Testkit 0.34.2,
PocketIC 16.1.0, CDK 0.20.3 and Candid 0.10.38. Rust 1.99 compiles the experiment,
separately from the product's Rust 1.85/1.88 floors. The owner-prepared Linux
server digest is `b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The experiment never installs or downloads a server.

One canister bootstraps permanent `app.metrics.v1` through IC Memory. Seven rows
mix all four metric kinds, measured-zero sample state, scalar zero, wide totals,
an exact cap and actual overflow. Synthetic boundary seeds are numeric states,
not observed platform counters. A missing counter is checked separately.
Two upgrades retain every row and the application memory ID; recording continues
between upgrades. Query writes execute successfully but are discarded, and an
explicitly trapping update rolls back its counter write. Typed identity/kind/
regression refusals preserve all rows. Explicit reset advances the host epoch
and rejects the old identity while retaining the same allocation.

## Raw checkpoint costs

A separate fresh canister adds seven 0/1/16/256 times, with checkpoint cadences
1/16/256 and three repeats in a fixed order. Each reply uses a fresh row. Zero
iterations write no row. The instruction bracket includes arithmetic recording
and checkpoint load, validation, encoding and map writes; bootstrap, key/identity
construction, projection and Candid encoding are outside it. Whole-update cycles
are actual balance decreases including ingress/execution/reply costs, never
instruction conversions. Lifecycle costs are excluded.

| 256 additions / checkpoint cadence | Bracketed instructions | Whole-update cycles |
| --- | ---: | ---: |
| Every addition | 22,498,046–26,656,344 | 29,698,651–33,856,949 |
| Every 16 additions | 1,660,775–2,068,482 | 8,861,380–9,269,087 |
| Once after 256 additions | 262,051–277,364 | 7,462,656–7,477,969 |

Each complete initial/upgrade Wasm is 522,886 raw bytes, compiled with opt-level=z,
LTO, one codegen unit, symbol stripping and panic abort, without postprocessing.
This is the complete mixed-kind fixture, not an isolated counter contribution.
The evolving map and row order affect these ranges. There is no matched volatile
control or claim about improvement over an earlier fixture, universal write cost,
native timing, mainnet or real consumer workloads. Batching reduces checkpoint
work in this trajectory; hosts still own the acceptable loss window and cadence.

## Retention and replay

Successful runs 2/3 and a fresh-build run 4 reproduce costs, sizes, state and
qualification files byte-for-byte, each on a fresh server. Run 3 binds the final
copied source. Run 4 verifies both Wasms rebuild byte-for-byte with a fresh owning
Metrics target directory, and passes all probe/driver Clippy gates before execution.
All successful runs pass the lifecycle cases and 36 raw cost replies.

Initial probe compilation incorrectly called histogram aggregate getters on the
histogram itself. The first IC run passed lifecycle checks but failed entering
cost collection because the driver encoded its nonce as int32 instead of nat64.
Their original source/logs and partial state remain retained; neither is labelled
a full pass. Final source fixes both fixture errors.

The [frozen inputs and results](durable-counter-097.tar.gz) and
[checksum](durable-counter-097.tar.gz.sha256) select only this Metrics fixture,
product identities, logs and raw results. No sibling source, private issue body,
tool payload or build directory is exported.

```sh
sha256sum -c docs/evidence/durable-counter-097.tar.gz.sha256
mkdir -p target/evidence/replay-durable-counter-097
tar -xzf docs/evidence/durable-counter-097.tar.gz -C target/evidence/replay-durable-counter-097
export POCKET_IC_BIN=/absolute/path/to/the/exact/prepared/pocket-ic
bash target/evidence/replay-durable-counter-097/durable-counter-097/fixture/replay.sh \
  "$PWD/target/durable-counter-rebuild-097" \
  "$PWD/target/evidence/durable-counter-replay-097"
```

Prepare locked sources and the exact server outside replay. Compare the four raw
result files against retained run 3 after execution. Native storage tests and
this IC fixture qualify the adapter; an owning consumer must independently choose
admission/reset/write policy and qualify its application. Existing heap/window
consumers are not opted into persistence by this addition.
