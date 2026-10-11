# Released 0.6 arithmetic on the IC

## Source and scope

This new [frozen experiment](arithmetic-cost-061.tar.gz) compares exact released
0.5.6 `392d1e2cbffb434dea591df8cb3165e8c625ab01` and 0.6.1
`39b357eb4e53051b5ad9afcfcd0a8c147c68a524` arithmetic sources. Both complete
`src/` trees, including the application guide, match Git byte-for-byte. The
private copied packages have renamed fixture manifests; their source is unchanged.
This is an independent historical evidence artifact with its own virtual root,
inherited catalog and captured lock, not a maintained Metrics package, product
counter reader, runtime dependency, generic benchmark framework or new CI gate.
Public availability requires committing/pushing the prepared archive and report.
Existing older performance evidence retains its original source/domain identity.

The bundle retains the complete probe/driver source, exact lock and seed,
source/graph/host/server admission receipts, all 11 measured Wasms, build and
warning-denied Clippy logs, raw counters, actual balances, projected state and
raw server streams. `inputs.sha256` binds every payload; the separate
[archive checksum](arithmetic-cost-061.tar.gz.sha256) binds the compressed artifact.
Main arithmetic sources, manifests, lock, pins, Makefile and Shared snapshot are
unchanged. Package versions remain 0.6.1; the compatible testing entry is 0.6.2.
No sibling code was edited or built, and no commit, release or publication ran.

Linux x86-64 uses frozen Rust 1.99.0, edition 2024, opt-level=z, LTO, one codegen
unit, stripped symbols and panic abort, with no Wasm postprocessing. Candid
0.10.37, CDK 0.20.3, IC Testkit 0.33.3 and PocketIC client/server 16.1.0 are
selected in the lock. All 293 external package name/version/source/checksum
identities match the captured Backup seed lock; unused rows are pruned and only
private workspace rows change. Backup is a graph seed, not a dependency or
consumer qualification target. Builds and replay are locked and offline against
prepared caches. This experiment does not claim a package support floor.

IC Testkit owns fallible startup, version admission, bounded startup and raw
server-output retention. Its prepared CLI's read-only server check passes; the
receipt binds that executable's hash without claiming it matches dirty sibling
source. The official gzip hash is
`131219d90dcf9bf6f3ed8ee02d8f55504ea24a6db382f5680675b7bd6b7ed3bf`;
the selected server executable hash is
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
Each isolated application-subnet canister receives an additional 100 trillion
cycles before installation; raw measured balances are retained separately.

## What is measured

Each update starts with fresh local state. The instruction-counter bracket
covers one selected arithmetic loop, runtime black boxes, typed result handling
and query-checksum work. Construction, batch preparation and query seeding occur
before the bracket; projection and Candid encoding occur after it. Every count,
total, maximum, latest, overflow flag and histogram bucket write is observable
in a common reply and checked against independent host `u128` oracle arithmetic.
The host also checks instruction monotonicity and actual cycle-balance decreases.
Whole-update cycles include setup, projection, encoding and execution fees;
they are observed separately, never inferred from instruction counts.

Four finite inclusive bounds are `[0, 10_000, 100_000, 1_000_000]`. Record/merge
inputs cover zero, each finite bucket, overflow and `u64::MAX`, at 0, 1 and 1,000
iterations, with three warm repeats and a separate cold observation. A single
maximum value reaches the total cap exactly; repeated maximum values overflow.
Merge source batches contain 16 identical observations prepared before the
bracket. Matched aggregate/histogram recording cases execute 16,000 records,
three times each, for `10_000` and `1_000_001`. The bounded workloads do not
reach sample-count or bucket-count overflow.

Query seeds are `[0, 10_000, 100_000, 1_000_000, 1_000_001]`. Each aggregate
query cohort projects aggregate mean, the interval since its first two
observations, and interval mean. Each histogram cohort projects cumulative
count at index 2 and p50/p95 bucket ranges, with runtime-black-boxed fractions
and references. Checksums make all results observable. Mismatch workloads merge
a histogram whose last bound differs, require the typed first mismatch at index
3 and independently verify the destination remains unchanged.

## Observations

Three warm repeats agree on bracketed instructions and actual cycle deltas for
all nonzero cases. The following values are **1,000 loop iterations**, including
the loop/control overhead, rather than isolated per-call API costs:

| Recording input | 0.5.6 summary instructions | 0.6.1 summary instructions | 0.6.1 aggregate instructions | 0.5.6 histogram instructions | 0.6.1 histogram instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| 0 | 61,368 | 72,502 | 59,379 | 101,279 | 112,250 |
| 10,000 | 61,371 | 72,505 | 59,382 | 121,282 | 133,253 |
| 10,001 / 100,000 | 61,371 | 72,505 | 59,382 | 141,282 | 154,253 |
| 1,000,000 | 61,371 | 72,505 | 59,382 | 161,282 | 175,253 |
| 1,000,001 | 61,371 | 72,505 | 59,382 | 170,282 | 189,253 |
| `u64::MAX` | 61,371 | 77,500 | 64,377 | 170,282 | 194,248 |

Raw count/total uses 53,451 instructions in all these 1,000-record cases.
The summary/histogram contract changed: 0.6 tracks actual overflow, while old
histograms additionally retain latest. This is evidence of the cost of those
selected behaviors, not a same-contract optimization or universal regression.
Actual whole-update cycles and raw before/after readings for every case remain
in the CSV; for input 10,000, old/current summaries use 7,186,872/7,198,185
cycles and old/current histograms use 7,246,967/7,259,088 cycles.

| Equal 16,000 observations | Direct-record instructions | Prepared-batch merge instructions | Direct-record cycles | Prepared-batch merge cycles |
| --- | ---: | ---: | ---: | ---: |
| Aggregate, 10,000 | 944,382 | 96,382 | 8,069,875 | 7,221,875 |
| Aggregate, 1,000,001 | 944,382 | 96,382 | 8,070,771 | 7,222,771 |
| Histogram, 10,000 | 2,128,253 | 491,256 | 9,254,088 | 7,617,093 |
| Histogram, 1,000,001 | 3,024,253 | 491,256 | 10,150,984 | 7,617,989 |

Merging already available 16-observation batches uses approximately 9.8 times
fewer bracketed instructions for these aggregates and 4.3–6.2 times fewer for
these histograms. Creating those batches is excluded. This does not justify
recording into temporary batches solely to save recording work; it quantifies
combining partial accumulators that a consumer already owns. Units, bounds,
window/reset identity and partition attribution still require consumer admission.

| 1,000 query/rejection cohorts | Instructions | Whole-update cycles |
| --- | ---: | ---: |
| Aggregate mean + checked interval + interval mean | 276,379 | 7,402,824 |
| Histogram cumulative count + p50 range + p95 range | 1,708,250 | 8,834,769 |
| Histogram merge mismatch at final bound | 148,253 | 7,275,011 |

These costs include checksums and error/result handling; they do not isolate
individual query costs. Keep means/intervals/quantiles in reporting work when
possible. Histogram quantile results remain ranges, not exact observed values.
[The quantile-cost investigation](https://github.com/dragginzgame/ic-metrics/issues/59)
will isolate queries and consider checked narrow-rank arithmetic with the exact
wide fallback. This cohort does not establish which operation dominates, or that
a new combined-query API or cached state is needed.

| Selected complete probe | Raw Wasm bytes |
| --- | ---: |
| Count/total | 359,897 |
| 0.5.6 summary | 359,960 |
| 0.6.1 summary | 360,002 |
| 0.6.1 aggregate | 359,904 |
| 0.5.6 histogram | 360,228 |
| 0.6.1 histogram | 360,061 |
| Aggregate merge | 360,086 |
| Histogram merge | 360,472 |
| Aggregate query cohort | 360,831 |
| Histogram query cohort | 362,771 |
| Histogram mismatch | 360,723 |

The current summary adds 42 raw bytes to its old probe; the current histogram
removes 167. These are complete stripped canister artifacts under this selected
fixture/profile, not arithmetic-library contributions, in-memory storage costs,
or predicted savings for other applications, bound counts or instantiations.
Native macOS, mainnet, consumer endpoints, maps, authorization, persistence,
callbacks/traps, attribution and lifecycle/reset qualification are outside scope.

## Reproducibility and qualification

The finalized matrix validates 554 measured replies and 11 typed admission
rejections. A fresh extraction verifies all payload hashes, passes all 11 Wasm
and host-driver warning-denied Clippy gates, rebuilds all 11 Wasms byte-for-byte,
then reproduces both raw CSVs byte-for-byte on a fresh server instance. This
includes raw counters, balances, projections, cold calls and zero-loop controls.
Some zero-loop whole-update cycle deltas vary between repeats, while their
bracketed instruction deltas agree; both full runs reproduce the exact trajectory.
The archive retains those controls rather than subtracting them into a universal
cost. Earlier 542-reply exploratory matrices retain their separately frozen
initial driver; the final matrix adds matched recording cases.

The finalized raw result CSV SHA-256 is
`87839af2007afbb4c153f0f5008c6fb35ad3cb4895358a95a5d8154f5c3d0d9b`.
The archive README and `replay.sh` document explicit admitted server selection,
prepared caches and the Metrics repository's `target/` build/result locations.
Replay never downloads a server, changes dependency selections or substitutes
a newer 16.x executable. Missing or mismatched inputs fail without fallback.

```sh
sha256sum -c docs/evidence/arithmetic-cost-061.tar.gz.sha256
mkdir -p target/evidence/replay-061
tar -xzf docs/evidence/arithmetic-cost-061.tar.gz -C target/evidence/replay-061
cd target/evidence/replay-061/arithmetic-cost-061
sha256sum -c inputs.sha256
# Select the exact owner-prepared server hash documented above.
export POCKET_IC_BIN=/absolute/path/to/admitted/pocket-ic
unset IC_TESTKIT_POCKET_IC_URL
bash replay.sh /absolute/metrics/target/evidence/cost-rebuild-061 \
  /absolute/metrics/target/evidence/cost-results-061
```

Root `make fmt` and focused evidence/documentation checks remain separate from
this frozen experiment's build/runtime checks. No root Rust edit or broad
product test/full CI gate is needed for this retained measurement artifact.
Native acceptance of the maintained 0.6 arithmetic and consumer adoption remain
with [#57](https://github.com/dragginzgame/ic-metrics/issues/57) and the owning
consumer issues; these synthetic cost measurements do not close those gates.
