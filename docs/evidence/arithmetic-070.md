# Pending 0.7.0 wide totals

This batch starts at released 0.6.6
`c651c095d5554e929a9cb96f5089226eda66ee90` and is tracked in
[#63](https://github.com/dragginzgame/ic-metrics/issues/63). Pending notes select
0.7.0 because public totals and means change type. Cargo versions, the root lock,
compiler/tool pins and the Shared snapshot remain unchanged; no release runs.

## Arithmetic contract

Every observation remains `u64`. Samples, bounds, bucket counts, latest and
maximum remain `u64`; accumulated totals and integer means become `u128` across
raw helpers, aggregates, summaries and intervals. The maximum exact count times
the maximum sample is `(2^64 - 1)^2`, below `u128::MAX`. A tracked total therefore
cannot overflow while its sample count remains exact.

Continue recording diagnostic values after count overflow, with independent
sticky flags and checked/clipped totals. An exactly reached cap is distinct from
an overflow; adding zero cannot create loss. Means and intervals reject actual
loss of exactness. Raw count/total fields lack that provenance, so `checked_mean`
retains conservative cap rejection at each field's respective width. No input
admission, units or snapshot identity is inferred from numeric success.

One private mean projection uses exact `u64` division when the total fits and
`u128` division otherwise. Both paths preserve zero/empty distinction, floor
rounding and constant evaluation at Rust 1.85. The bounded narrowing cast is
explicitly guarded; wider caller output must likewise use checked conversion.
The crate remains allocation-free, dependency-free and `no_std`.

Consumers own reporting: expose unavailable exact projections and log or alert
once when an overflow flag first changes in their measurement window. The library
has no logger, trap, registry, platform reader, endpoint, codec or retained format.
Widening accumulated totals cannot recover clipped input samples.

## Read-only downstream boundaries

The frozen caller catalog binds committed and reviewed hashes independently.
No sibling build, resolver or file mutation is performed. Other sibling dirty
work is preserved and supplies no owning qualification.

| Consumer / committed HEAD | Adoption consequence |
| --- | --- |
| IcyDB `e17b0783a9c90fa394aa7729b357d37839f49d51` | `InstructionMetrics` and entity totals plus CLI raw means need wide fields/projections. The Candid DTO boundary requires an owning codec/report decision. Preserve inclusive overlapping spans, maxima/reset and journal-debt separation. Reviewed caller files match HEAD. |
| Canic `25b73cd403b20b4e148c6e340f8c760a26d97f6e` | Widen `PerfSlot::total_instructions` and coordinate `PerfEntry` and its report consumers. Preserve exclusive accounting, invocation/checkpoint identity, zero/reset and ordering. Reviewed `perf.rs` matches HEAD; existing held-HTTP/native obligations in #10 remain separate. |
| IC Timers `cb86d87ce67f7aac1b127bdfaa2c6f8a7f68c2a0` | Public summary re-exports and runtime/size-probe report totals require one released dependency identity. Update assertions that expected total overflow after exceeding `u64::MAX`. Preserve scheduler/work roles, registration epochs and trap admission. Two reviewed probe sources differ from HEAD; their working hashes are separate. |
| IC Backup `032066f2079cd2ac93b230c4a32bbcf27ffe0c59` | Public summaries/histogram aggregates expose wide totals/means; update old cap expectations without changing duration/byte units, success/rejection lanes or repeated-chunk semantics. Current admission excludes unrepresentable samples. Diagnostics are explicitly never persisted, serialized or reconstructed. Reviewed files match HEAD. |
| IC Blob Storage `642b2853695d0583687527c83cc7f090db4ebcbe` | Widen the restoration test probe's raw instruction total and coordinate its report schema. Keep calls/byte counters and operation/reset attribution separate. Reviewed resource caller matches HEAD. |
| Toko Miner `3e53fb5b8963c126edf9d236f86c71c0a2f335cc` | Widen `Bin::instructions_total`; adapt mixed count/total report tuples and the narrow projection closure. Existing public metric values already support `u128`. Preserve action cohorts, outcome/trap policy and window identity. Reviewed caller matches HEAD. |

Owners coordinate dependency adoption, public re-exports, codecs/generated
reports, and any retained consumer data disposition. Do not silently reinterpret
old retained bytes or add compatibility readers. No consumer reset is performed
here. The original consumer qualification issue and historical evidence retain
their original identities.

## Source-bound IC comparison

The new frozen experiment compares exact released 0.6.6 source with this candidate
under one matched harness. It reuses the explicitly selected external identities
from the retained 0.6.1 experiment: Testkit 0.33.3, PocketIC client/server 16.1.0,
CDK 0.20.3 and Candid 0.10.37. Its graph is isolated from the arithmetic and
private inspector graphs; no product dependency is added or upgraded.

All variants share wide Candid projection and checksum arithmetic. Recording,
16-sample batch merges, aggregate mean/interval queries and histogram queries
have separate instruction brackets. Setup, result projection and Candid encoding
are outside those brackets; actual whole-update cycle balances include them.
No native timings, estimated cycles, mainnet spending or consumer callback
qualification is claimed. Samples that overflow the released narrow total have
intentionally different results; the driver checks each against its independent
wide oracle and overflow contract.

The initial direct-wide-division candidate and failed sandbox loopback startup
are retained separately. Two completed initial runs agree byte-for-byte: 832
measured replies and 16 typed admission rejections each. Direct division added
1,422 raw Wasm bytes and 734,003 bracketed instructions to the 1,000-iteration
aggregate-query cohort. That evidence motivates the bounded native-width path;
final measurements retain that initial experiment separately.

## Local validation

Final boundary coverage includes the largest valid count/value product, an exact
wide cap followed by actual overflow, sticky merge propagation, independent
latest/max/bucket updates, wide raw fields, intervals across the former cap,
raw cap admission and both constant-evaluated division paths. Focused aggregate,
summary and histogram tests and warning-denied native/Wasm Clippy pass.
Rust 1.85 native/Wasm checks and the named summary tests (including both const
division paths) pass. The explicitly approved complete `make ci` gate passes:
37 product tests, seven doctests, native/Wasm checks and Clippy, inspector checks,
Rustdoc and the complete documented tooling gates. The root arithmetic and
owning-tooling inputs are unchanged afterward; later edits only add owning
qualification documents/artifacts. Historical frozen experiments remain unchanged.

## Final matched measurements and durable inputs

The [frozen bundle](wide-totals-cost-070.tar.gz) and
[checksum](wide-totals-cost-070.tar.gz.sha256) retain 136 payloads: complete source,
private manifests/lock, driver, 16 raw Wasms, every raw CSV, command/server logs,
caller/source catalogs, target-layout IR and the replay script. Its SHA-256 is
`dfa40c87b9c8b76f80161ea0172bc94cea533419298ba2eefd017b0eb1b1102c`.
It includes the complete initial direct-division artifact. It requires the exact
separately admitted server and prepared locked caches; it never installs tools.

Two final independent runs each check 841 measured replies, 16 iteration-limit
rejections and one typed narrow-total projection rejection. Results and size
CSVs agree byte-for-byte. The separate wide-query cohort records a total of
73,786,976,294,838,206,460 with no loss flag, verifies mean/interval projections
against the independent wide oracle, and measures 1,192,400 instructions and
8,333,190 whole-update cycles for 1,000 loops. The released total cannot supply
an exact mean for that input; no performance ratio is claimed for its rejection.

Representative matched rows below use 1,000 loops with value 10,000 for recording
and 16-observation prepared merges; query rows use the fixed small-value seed.
Instructions are bracketed; cycles are actual whole-update balance decreases.
These include harness/black-box work and are not universal per-operation prices.

| Kernel | Released / wide raw Wasm bytes | Released / wide instructions | Released / wide cycles |
| --- | ---: | ---: | ---: |
| Raw count/total | 360,443 / 360,484 | 55,353 / 76,354 | 7,186,659 / 7,208,100 |
| Ordered summary | 360,603 / 360,601 | 72,523 / 89,526 | 7,204,490 / 7,221,978 |
| Aggregate recording | 360,501 / 360,481 | 59,400 / 78,403 | 7,190,921 / 7,210,502 |
| Four-bound histogram recording | 360,822 / 360,821 | 133,368 / 152,371 | 7,266,143 / 7,285,599 |
| Aggregate merge | 360,681 / 360,677 | 96,400 / 258,403 | 7,227,921 / 7,390,502 |
| Four-bound histogram merge | 361,236 / 361,277 | 491,371 / 514,374 | 7,624,153 / 7,647,609 |
| Aggregate queries | 361,506 / 363,021 | 300,397 / 826,400 | 7,433,923 / 7,960,990 |
| Histogram queries | 363,569 / 363,549 | 1,326,365 / 1,326,368 | 8,460,600 / 8,461,387 |

The exact native-width path saves 208,000 bracketed instructions compared with
the retained initial direct-division candidate's same 1,000-loop query cohort.
It still retains wide division and larger projections; the final query probe is
1,515 raw bytes larger than its released counterpart. Aggregate merge passes a
larger copied value through the harness black box; the histogram merge uses a
borrowed batch. Those are distinct workloads, not an interchangeable cost claim.

Wasm-target storage is 32 to 48 bytes for an aggregate, 16 to 32 for an interval,
40 to 64 for an ordered summary, and 48/80/112 to 64/96/128 for histograms with
zero/two/four bounds. These include target alignment; no native layout is
substituted. The owner accepted correctness ahead of the additional footprint.

Owning adoption issues are [IcyDB #350](https://github.com/dragginzgame/icydb/issues/350),
[Canic #518](https://github.com/dragginzgame/canic/issues/518),
[Timers #47](https://github.com/dragginzgame/ic-timers/issues/47),
[Backup #40](https://github.com/dragginzgame/ic-backup/issues/40),
[Blob #60](https://github.com/dragginzgame/ic-blob-storage/issues/60) and
[Toko #45](https://github.com/dragginzgame/toko-miner/issues/45). They await the
released dependency and owning report/runtime/native qualification. Root
publication and delivered-source acceptance remain in Metrics #63.

## Fresh-extraction replay

The sealed bundle is freshly extracted and every retained payload checksum
verified. Its replay rebuilds all 16 probe Wasms and compares each byte-for-byte,
then executes a fresh independent IC matrix. Both raw CSVs match the finalized
841-reply / 17-rejection matrix exactly. Prepared external build caches are reused;
the arithmetic/probe/driver sources are rebuilt from the extracted paths.
The [delivery receipt](wide-totals-delivery-070.tar.gz) and
[checksum](wide-totals-delivery-070.tar.gz.sha256) retain the full replay log,
independent raw results and a structured source-bundle-bound receipt.

Final source comparison confirms the full tested arithmetic tree matches the
frozen current copy. Root metadata, lock, compiler/tool pins, Shared snapshot,
HEAD and index remain unchanged. Later owning documentation passes link and diff
checks; no release, publication or downstream file effect is performed.
