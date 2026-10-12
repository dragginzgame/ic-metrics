# Prepared 0.8.0 overflow-aware recording cut

The maintainer approved [#66](https://github.com/dragginzgame/ic-metrics/issues/66)
after reviewing that 0.7 widened totals while retaining raw-field helpers. The
current batch removes those recording/mean entrypoints and their raw-only mean
error variant. All recording uses tracked aggregates, ordered summaries or the
histogram's existing aggregate. Consumers retain units, sample admission,
attribution, identities, reset windows, endpoints and report formats.

Aggregate/summary `scaled_mean(scale)` admits actual count/total overflow before
reusing the exact scaled-ratio projector. It computes the fractional mean from
the full total, rather than scaling an already rounded integer mean. Empty is
`None`, measured zero is `Some(0)`, and scale zero does not conceal actual loss.
Exactly reached count caps remain exact. Projection failures carry their typed
ratio cause. The generic ratio helper remains for independently admitted inputs.

Package versions remain 0.7.3. The public removals select a 0.8.0 draft and carry
the prior pending tooling notes into that batch. No staged deprecation or
compatibility recording path is introduced. All four stable-package Rust source
files match the official 0.7.3 archive byte-for-byte; the V1 codec, arithmetic
state fields, map/key/epoch contract and collection lifecycle are unchanged.
This library cut requires no durable-data reset. Consumer DTO/storage changes
and disposition of raw counters that have lost provenance remain locally owned.

## Read-only consumer review

The frozen caller catalog distinguishes committed and working hashes. IcyDB's
instruction/entity and CLI callers, Canic's exclusive endpoint/checkpoint slots,
Blob's restoration probe and Toko's action cohorts still use raw helpers. They
need tracked internal state and report availability/overflow propagation.
Timers and Backup already use tracked summaries/histograms; their public type
identity, error matches and owning probes need qualification when adopting 0.8.

Owning issues: [IcyDB #354](https://github.com/dragginzgame/icydb/issues/354),
[Canic #523](https://github.com/dragginzgame/canic/issues/523),
[Blob #62](https://github.com/dragginzgame/ic-blob-storage/issues/62),
[Toko #48](https://github.com/dragginzgame/toko-miner/issues/48),
[Timers #50](https://github.com/dragginzgame/ic-timers/issues/50) and
[Backup #41](https://github.com/dragginzgame/ic-backup/issues/41).
Adoption awaits the published dependency; no sibling files or graphs change here.
Consumer acceptance is not supplied by the library's native/IC experiment.

## Matched IC comparison

The baseline is exact source from the official non-yanked 0.7.3 archive, checksum
`f0a18a8f40289188ded463aded05aec282ee1ea979092c4ec7b1a2ef0c6b3000`, released source
`e714085a972db88c348e4aabe57847f2124d2b97`. The candidate copies the prepared
arithmetic source. Both use the unchanged private graph from the earlier wide
experiment: Testkit 0.33.3, PocketIC client/server 16.1.0, Rust 1.99.0, CDK 0.20.3
and Candid 0.10.37. These are explicit frozen experiment identities, independent
of the product's Host 0.14.9/Memory 0.35.17 graph; no product update is performed.

Nine kernels per source yield 18 raw Wasms. Two independent executions each
validate 888 measured replies against an independent wide arithmetic oracle and
18 typed iteration-limit refusals. Raw result and size CSVs agree byte-for-byte.
A separate source copy rebuilds every Wasm byte-for-byte, executes a third matrix
and reproduces both CSVs exactly. Fresh archive extraction verifies all retained
input checksums and agreement with that replay.

Representative rows use 1,000 loops and three identical repeats. Recording uses
value 10,000; query kernels use the same fixed five-value seed. Instructions
bracket the arithmetic/black-box work; actual whole-update cycle decreases
include dispatch, Candid and reply work. Installation/startup costs are excluded.

| Kernel | 0.7.3 / prepared raw Wasm bytes | Instructions | Whole-update cycles |
| --- | ---: | ---: | ---: |
| Raw count/total to tracked recording | 360,484 / 360,446 | 76,354 / 78,386 | 7,208,100 / 7,210,228 |
| Ordered summary | 360,601 / 360,601 | 89,526 / 89,526 | 7,221,978 / 7,221,978 |
| Aggregate recording | 360,481 / 360,481 | 78,403 / 78,403 | 7,210,502 / 7,210,502 |
| Four-bound histogram recording | 360,821 / 360,821 | 152,371 / 152,371 | 7,285,599 / 7,285,599 |
| Aggregate mean/interval queries | 363,021 / 363,021 | 826,400 / 826,400 | 7,960,990 / 7,960,990 |
| Scaled mean, small total | 362,778 / 362,709 | 1,106,398 / 923,401 | 8,240,659 / 8,057,666 |
| Scaled mean, wide total | 362,778 / 362,709 | 1,340,398 / 976,401 | 8,480,859 / 8,116,866 |

The recording comparison exposes the same count/total result, with candidate
overflow flags; its private projection omits maximum. The scaled comparison
replaces the previous tracked `mean()` admission followed by a raw exact ratio
with one checked scaled mean, avoiding the discarded integer division. The wide
cohort uses four `u64::MAX` observations plus zero. These are bounded synthetic
workloads, not consumer registries, async qualification or universal prices.
No native timing, estimated cycles or mainnet spending is claimed.

## Retention and replay

The [frozen experiment](tracked-cost-080.tar.gz) and
[checksum](tracked-cost-080.tar.gz.sha256) retain source variants, private
manifests/unchanged lock, all 18 Wasms, three raw matrices, complete build/server
logs, caller/issue identities and the replay script. The prepared server SHA-256
is `b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
Replay requires Linux x86_64, exact Rust 1.99.0, prepared locked caches and that
separately admitted server. It never downloads or installs tools:

```bash
sha256sum -c docs/evidence/tracked-cost-080.tar.gz.sha256
mkdir target/replay-tracked-080
tar -xzf docs/evidence/tracked-cost-080.tar.gz -C target/replay-tracked-080
POCKET_IC_BIN=/path/to/prepared/pocket-ic \
  bash target/replay-tracked-080/experiment/replay.sh \
  "$PWD/target/replay-tracked-080-build" "$PWD/target/replay-tracked-080-results"
```

Focused arithmetic/const boundary tests, doctests and native/Wasm warning-denied
Clippy pass. The first test/lint failures remain retained: the overflow case
initially stopped at an exact cap, and its const item needed to precede statements.
Corrected coverage distinguishes exact caps, actual loss, empty/zero, wide
products, floor rounding and zero-scale refusal without source-name bans.
Full `make ci` passes in 258 seconds, followed by arithmetic Rust 1.85 native/Wasm,
stable Rust 1.88 native/Wasm and inspector Rust 1.88 native floors. Every canonical
gate checkpoint matches its baseline and current inputs; the final arithmetic
source equals the frozen IC candidate. The [delivery receipt](tracked-delivery-080.tar.gz)
and [checksum](tracked-delivery-080.tar.gz.sha256) retain that source, all complete
gate logs, focused failure/recovery attempts and verification records. The
[current handoff](../status/current.md) distinguishes this cut from prior tooling
receipts. No new hosted native result or consumer acceptance is claimed.
