# Durable histogram arithmetic replay

## Historical availability

[#26](https://github.com/dragginzgame/ic-metrics/issues/26) found that the original
ignored inputs for [the 0.2.6 Canic experiment](histogram-cost-026.md) are absent.
Read-only searches of this checkout's retained evidence, the relevant Canic
evidence and temporary files found report copies and Canic's older fixture, but
not that experiment's manifest, driver, raw CSV or three frozen Wasms. No GitHub
release assets were available; the maintainer confirmed no backup is available.
These searches do not establish that all possible external copies are lost.
The historical report and hashes remain unchanged. Its table is historical
evidence, with original replay inputs unavailable, not a reproducible current
baseline or qualification of later source.

## New source and scope

The [frozen replay bundle](histogram-replay-029.tar.gz) contains a new independent
arithmetic experiment, not reconstructed historical inputs. The copied Metrics
source and application guide match released 0.2.8 at
`0eac2b0baa9d03b8f2430a24dfe596d93f5bfc16`. Root arithmetic, Cargo versions,
lock and selected tools are unchanged; pending 0.2.9 remains compatible.
The bundle's README, sources, exact workspace lock, captured seed lock, package
identity comparison, host/server receipts, build logs, raw CSV/JSON, and measured
Wasms are bound by `inputs.sha256`. Keeping the bundle as a repository artifact
avoids relying on ignored scratch or expiring CI uploads for the replay inputs.
No production reader, consumer dependency or generic measurement framework is
added. Public availability requires committing/pushing this prepared artifact.

This experiment compares one fixed aggregate: consumer-owned count/total,
`MeasurementSummary`, or `MeasurementHistogram<2>` with inclusive
`[10_000, 100_000]`. It has no map/key lookup or Canic source-copy. The private
probe initializes/borrows state before reading counter 1, records runtime
black-boxed values, reads counter 1 again, then projects a common nine-u64 reply.
Every aggregate and bucket write remains observable and is validated by the host.
Actual instruction deltas bracket the recording loop; actual cycle balance
differences cover the entire update, including projection and encoding. The
admitted values are synthetic boundary inputs, not application measurements.

Linux x86-64 uses Rust 1.99.0, release opt-level=z, LTO, one codegen unit,
stripped symbols and panic abort; no Wasm postprocessing. CDK 0.20.3, Candid
0.10.37 and PocketIC 16.0.0 are selected in the lock. All 276 external package
identities match the captured IC Testkit seed; unused seed packages are pruned,
and only private path package identities change. Cache preparation/builds are
locked and offline. The pinned prepared server's SHA-256 is
`69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792`.
Each isolated application-subnet canister starts measured calls with 100 trillion
cycles. PocketIC balances are local observations, not production spending.

## Observations

Each variant starts with one cold zero sample. Warm calls use `0`, `10_000`,
`10_001`, `100_000` and `100_001`, at 0, 1 and 1,000 repetitions, each repeated
three times. All 138 measured replies validate. Six additional actual replies
verify typed rejection above the iteration limit and unchanged subsequent state.
All three repeats agree on instructions/cycles for each 1,000-record case:

| Selected bucket | Count instructions | Summary instructions | Histogram instructions | Count cycles | Summary cycles | Histogram cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| First (0 / 10,000) | 51,336 | 59,253 | 99,253 | 7,165,871 | 7,173,617 | 7,213,616 |
| Second (10,001 / 100,000) | 51,336 | 59,253 | 121,253 | 7,165,871 | 7,173,617 | 7,235,616 |
| Overflow (100,001) | 51,336 | 59,253 | 130,253 | 7,165,871 | 7,173,617 | 7,244,616 |

These paired observations add 47,917–78,917 instructions and 47,745–78,745
whole-update cycles over count/total for this exact 1,000-record workload.
They are observed workload differences, not an instruction-to-cycle conversion.
Cold, zero-iteration and single-record cases remain in the raw CSV separately.

| Variant | Raw Wasm bytes | SHA-256 |
| --- | ---: | --- |
| Count/total | 358,328 | `311d57ca56adc336643d109ea2847cc51fd8604a60950cc68d12e2fcfff68419` |
| Summary | 358,440 | `ee81d342687b78e96ea90164f373bac92162204ff54940a7d4b153c96247bec4` |
| Histogram | 358,611 | `e2c9c303d369db8e23b0afeff46cc1e882a48fad48c0daf0e41aa75b82bf99e5` |

Histogram adds 283 raw Wasm bytes over this baseline. This does not estimate
another N, multiple instantiations, state cardinality, a complete application,
saturation cost or storage layout. It is not comparable to the old Canic
experiment's source/lookup/response model merely because both use two bounds.
Native macOS, mainnet, callbacks, traps, timer admission, persistence, endpoint
authorization and application attribution are outside this experiment.

## Verification and replay

The frozen README records the former shared PocketIC bundle check and
`.tools/ic/bin/pocket-ic` path. Pending Metrics 0.3.0 removes that setup route;
current `make ic-tools-check` admits five tools and supplies no server. The
archive and its commands retain their historical identity. Exact replay still
requires the original admitted PocketIC 16.0.0 executable/hash stated below,
not the new Testkit owner's default server substituted into the frozen graph.
New runtime experiments use IC Testkit's selected setup/check contract and bind
their own source, lock, server and observations. The new tooling adoption neither
replays nor relabels these measurements.

The selected workspace lock has SHA-256
`005ec0b991d4f71c500ab0d0e3482c32e8748cc62ce96f1b79a28fa46484fdd3`;
the raw 138-row CSV has SHA-256
`37a77093cadcb43fe17bf196eef84e8643d292564243a73d7c501ab9f1fdd5c5`.
Final driver and all three Wasm variants pass warning-denied Clippy, formatting,
and locked offline builds. Initial driver doc-comment/error-adapter failures
remain separately identified in the bundle; final results never relabel them.
Replay uses the bundle's explicit server input and scoped localhost execution.
No full root CI/product-test gate, sibling edit/build, dependency upgrade, version
change, commit, push or publication was performed.

Verify the archive checksum, then extract into a fresh directory and check every
payload file before using it:

```sh
shasum -a 256 -c docs/evidence/histogram-replay-029.tar.gz.sha256
mkdir -p target/evidence
replay="$(mktemp -d "$PWD/target/evidence/histogram-extract.XXXXXX")"
tar -xzf docs/evidence/histogram-replay-029.tar.gz -C "$replay"
fixture="$replay/histogram-replay-029"
(cd "$fixture" && shasum -a 256 -c inputs.sha256)
```

The extracted README provides locked build/replay commands, required prepared
tools, and instructions to keep fresh observations separate from the reference
CSV and measured Wasms. That explicit artifact boundary supplies reviewable
inputs without changing ordinary CI or library ownership.

A fresh archive extraction passes every payload hash and locked offline
cache/build checks. All three source-rebuilt Wasms match the frozen bytes at the
new source path. A second actual PocketIC execution with the extracted sources'
rebuilt driver and frozen Wasms validates another 138 measured/six admission
replies; its raw CSV and size table are byte-identical to the reference. The
separate extraction/build/replay logs and duplicate raw results are included
under `inputs/` as verification evidence, without replacing the first run.
