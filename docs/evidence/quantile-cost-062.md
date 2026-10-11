# Checked narrow-rank IC qualification

## Change and source

[#59](https://github.com/dragginzgame/ic-metrics/issues/59) investigated the cost
of histogram quantiles. Pending 0.6.2 uses checked `u64` multiplication and
ceiling division when the sample-count/fraction product fits; products that
exceed `u64::MAX` retain the exact `u128` path. Fraction admission still precedes
emptiness, and overflow checks and bucket-range semantics are unchanged. There
is no new API, state, cache, dependency, allocation or consumer migration.
Maintained package/workspace versions remain 0.6.1.

The [frozen comparison](quantile-cost-062.tar.gz) retains exact released 0.6.1
`39b357eb4e53051b5ad9afcfcd0a8c147c68a524` baseline sources and the complete
working candidate sources. `inputs/source.patch` identifies the checked-product
change and independent boundary-oracle tests. Private manifests rename the source
copies and inherit the evidence artifact's catalog. This is a frozen independent
experimental artifact, not another maintained package or server framework.
Its [checksum](quantile-cost-062.tar.gz.sha256), complete payload hashes, selected
and seed locks, source/graph/server receipts, sources, logs, eight Wasms, raw CSVs
and server streams support exact replay. Public availability requires committing
and pushing the prepared inputs. The [previous released-source experiment](arithmetic-cost-061.md)
and its archive remain unchanged; the new source has its own identity.

## Method

Linux x86-64 uses frozen Rust 1.99.0, edition 2024, opt-level=z, LTO, one codegen
unit, stripped symbols and panic abort, without Wasm postprocessing. All 293
external lock identities exactly reuse the earlier admitted graph: Candid
0.10.37, CDK 0.20.3, IC Testkit 0.33.3 and PocketIC client/server 16.1.0. No
root graph, version or executable pin changes. IC Testkit owns fallible bounded
startup and raw server-output retention; the exact server executable hash is
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The previously checked CLI/archive/server receipts are retained; fresh startup
admits the selected executable each run. No sibling is modified or built.

For each source, separate canisters measure recording, cumulative count, a
single quantile and the cumulative-count/p50/p95 reporting cohort. Each update
starts with fresh local histogram state and four inclusive bounds
`[0, 10_000, 100_000, 1_000_000]`. Queries use five observations:
`[0, 10_000, 100_000, 1_000_000, 1_000_001]`. Setup is outside the instruction
bracket, as are projection and Candid encoding. The bracket includes the loop,
black-boxed references/fractions, typed result handling and range checksum.
Every aggregate, bucket and overflow field/flag is also projected and checked.
The host uses independent wide quotient/remainder arithmetic and an explicit
bucket table to validate range checksums, alongside counter monotonicity and
actual cycle-balance decreases. Whole-update cycles include setup, decoding,
projection, encoding and fees; they are separately observed, not derived from
instruction counts. Each canister receives an additional 100 trillion cycles
before installation; raw measured balances remain in the CSV.

Fractions cover p50, p95, `1/MAX`, `(MAX/5)/MAX`, `(MAX/5+1)/MAX`,
`(MAX-1)/MAX` and `MAX/MAX`. With five samples, `MAX/5` reaches the product cap
exactly; the next numerator requires the wide fallback, without forged counters.
Recording inputs cover every finite bucket, overflow, exactly reached total caps
and actual total overflow. All valid cases use 0, 1 and 1,000 iterations, with
three warm repeats and a separate cold call. Each Wasm rejects 100,001 iterations
with the typed error. Invalid fractions, empty/zero and saturation behavior have
separate maintained tests; invalid calls are not timed by this experiment.

## Observations

These are **1,000 iterations** of each selected workload, including control,
black-box and checksum work. Three nonzero warm repeats agree on both deltas.
`MAX` below means `u64::MAX`.

| Query fraction/workload | Baseline instructions | Candidate instructions | Baseline whole-update cycles | Candidate whole-update cycles |
| --- | ---: | ---: | ---: | ---: |
| p50 (`1/2`) | 718,250 | 518,250 | 7,863,748 | 7,663,748 |
| p95 (`95/100`) | 758,250 | 558,250 | 7,903,748 | 7,703,748 |
| `1/MAX` | 624,250 | 435,250 | 7,769,748 | 7,580,748 |
| `(MAX/5)/MAX`, exact product cap | 633,250 | 435,250 | 7,778,748 | 7,580,748 |
| `(MAX/5+1)/MAX`, wide fallback | 970,250 | 1,049,250 | 8,115,748 | 8,194,748 |
| `(MAX-1)/MAX`, wide fallback | 1,064,250 | 1,143,250 | 8,209,748 | 8,288,748 |
| `MAX/MAX`, wide fallback | 1,050,250 | 1,129,250 | 8,195,748 | 8,274,748 |
| Cumulative count + p50 + p95 cohort | 1,707,250 | 1,307,250 | 8,852,742 | 8,452,742 |
| Cumulative count alone | 177,250 | 177,250 | 7,322,742 | 7,322,742 |

The isolated p50 and p95 workloads save 200,000 instructions per 1,000 queries
(approximately 27.8% and 26.4%). The reporting cohort saves 400,000 instructions
(23.4%) and 400,000 actual whole-update cycles (4.5%). Wide products add 79
instructions per query in the measured fallback cases. The fast path is retained
for the common small-product workload with this explicit fallback trade-off;
it is not a universal reduction for every count/fraction.

Recording instruction/cycle/projection deltas match across sources in every
case, including total overflow; recording and cumulative-count Wasms are also
byte-identical across sources. The new rank path adds no recording state/work.

| Complete selected probe | Baseline raw Wasm bytes | Candidate raw Wasm bytes |
| --- | ---: | ---: |
| Recording | 359,683 | 359,683 |
| Cumulative count | 359,990 | 359,990 |
| Single quantile | 361,930 | 362,019 |
| Reporting cohort | 362,340 | 362,429 |

The checked path adds 89 raw bytes to the two quantile-bearing artifacts.
These are complete stripped canisters under this fixture/profile, not predicted
consumer application footprints or library storage sizes. Earlier cohort costs
keep their separate probe/source identity; minor fixture/control differences do
not relabel old measurements as this new comparison. This experiment qualifies
neither native macOS nor mainnet, consumer attribution, endpoints, persistence,
callbacks, lifecycle/reset identity, other bound counts or workload cardinalities.

## Verification and replay

Both full runs validate 296 measured replies and eight typed admission rejections.
A fresh extraction passes warning-denied Clippy and locked offline builds,
rebuilds all eight Wasms byte-for-byte and reproduces the entire raw result and
size CSVs byte-for-byte, including counters, balances, projections, cold calls
and zero-loop controls. Some zero-loop whole-update cycle readings vary between
repeats, while instruction deltas agree; the complete raw trajectory repeats
exactly. Controls are retained rather than subtracted into universal costs.
Final result CSV SHA-256 is
`49c216149139ce5906ef39988cbdbf79161699a236f3c2f383e80300f518c034`.

Maintained native/Wasm warning-denied Clippy, all 18 histogram tests and Rust
1.85 native/Wasm package checks pass. The new rank test compares quotient/remainder
wide-oracle results across sample-count and product boundaries, exact caps,
rounded ranks, empty input and invalid-fraction precedence. Existing tests cover
read-only ranges, zero samples, no finite bounds, saturation and constant
execution. The initial Clippy failure on two lossless test casts and preliminary
checks remain distinct from corrected final-source qualification.
The maintainer-authorized full `make ci` gate passes, including all 36 library
tests, seven doctests, inspector checks and complete tooling fixtures. Actual
Rust 1.85 arithmetic native/Wasm and Rust 1.88 inspector all-target checks pass
separately. All 119 frozen code/graph/pin/Make/snapshot and measurement-artifact
inputs remain unchanged after CI; maintained candidate sources still match the
measured tree byte-for-byte. The separate [delivery receipt](quantile-delivery-062.tar.gz)
and [checksum](quantile-delivery-062.tar.gz.sha256) retain exact logs, source patch,
input hashes and command outcomes. These are local dirty-source delivery checks;
this qualification paragraph was added after CI and passes focused documentation
link/diff checks. The other 118 admitted hashes, including code and both measured
archives, remain unchanged; the receipt records that documentation-only update.
Hosted native and consumer acceptance of the released 0.6 contract remains owned by
[#57](https://github.com/dragginzgame/ic-metrics/issues/57).

```sh
sha256sum -c docs/evidence/quantile-cost-062.tar.gz.sha256
mkdir -p target/evidence/quantile-replay-062
tar -xzf docs/evidence/quantile-cost-062.tar.gz -C target/evidence/quantile-replay-062
cd target/evidence/quantile-replay-062/quantile-cost-062
sha256sum -c inputs.sha256
export POCKET_IC_BIN=/absolute/path/to/the/exact/owner-admitted/pocket-ic
unset IC_TESTKIT_POCKET_IC_URL
bash replay.sh /absolute/metrics/target/evidence/quantile-rebuild-062 \
  /absolute/metrics/target/evidence/quantile-results-062
```

The script requires the exact compiler/server and prepared caches, builds under
the owning repository's `target/`, refuses occupied result directories, and
never installs tools, downloads a server or selects another graph. Missing or
mismatched hashes, source, projections, builds or results fail without fallback.
No version change, commit, push, release or publication has run.
