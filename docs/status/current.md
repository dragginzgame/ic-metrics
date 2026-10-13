# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns setup, focused checks and delivery gates.

## Pending 0.9.0

The prepared arithmetic API removes unreachable mean/interval cases under the
exact-count invariant ([#69](https://github.com/dragginzgame/ic-metrics/issues/69))
and names actual loss of precision explicitly. Flags use `*_overflowed`; histogram
flags are `bucket_overflowed()` and `overflow_count_overflowed()`, while
`overflow()` remains the count above the last bound. Remaining overflow errors
use `SampleCountOverflow`, `TotalOverflow`, `CountOverflow` and `InvalidOverflowFlag`.
Update core calls and matches when selecting 0.9. Consumer-owned DTO/wire names
and policies remain at their owner.

Raw stable kind/codec/continuity dispatch now requires a privately constructible
zero-sized capability ([#71](https://github.com/dragginzgame/ic-metrics/issues/71)).
Supported generic `DurableMetric` store operations remain available. Numeric
quality, clipping, exact caps, empty/zero observations, V1 bytes and host lifecycle
stay unchanged; no compatibility aliases or data reset are introduced.

The incoming Host 0.17.0 manifest/lock selection is qualified against published
checksums and committed release `93a0ecc2afb7d4b8d8a252a21ed10d7e58b35901`;
41 authored source/manifest/README files match. The private inspector needs no
API or feature change. Memory remains 0.36.1; arithmetic stays on Rust 1.85 and
stable/inspector stay on 1.88. Full CI passes in 254 seconds and all three floor
gates pass; eight checkpoints match all 144 frozen inputs. This is local
Linux qualification, not hosted macOS or application acceptance.

Nine matched raw Wasm probes are byte-identical through these two further cuts,
including all three generic stable round trips; seven representative stored
records match before/after, including overflow flags. The copied IcyDB numeric
projection preserves consumer DTO names and passes native/Rust 1.85 Wasm checks.
[The API-boundary receipt](../evidence/api-cut-090.md) binds these sources,
commands, refusal checks and limits. [The earlier error-cut receipt](../evidence/error-cut-090.md)
retains its original Host 0.16 graph and measured mean/scaled/interval reductions;
its inputs are not relabelled as the latest graph.

All six consumers were reviewed read-only. IcyDB, Timers, Backup and the Blob
probe need old core flag calls updated. Canic currently has no such calls;
its quality/attribution obligations remain. Toko still imports `record_sample`
and needs its earlier tracked-state adoption. Dependency selection, exposed
shared type identity and runtime/native acceptance stay with the
[owning issues](../extraction.md#downstream-contract-checks).
Package versions remain 0.8.4. The incoming dependency selection is preserved;
no real Git index/ref, release or publication effect is performed.

## Delivered 0.8.4

Local finalized release source is `0baae3a49b0bb2c42b32dfe8005b33d07e7e11d7`.
The release contains private mean ownership cleanup and Memory 0.36.1 selection.
[Its frozen preparation](../evidence/cleanup-084.tar.gz) retains the 377-second
CI/floor qualification and byte-identical mean probes on its original inputs.
Earlier [decoder](../evidence/decoder-083.md) and
[Memory adoption](../evidence/memory-083.md) receipts retain their earlier graphs.
None qualifies pending 0.9 or establishes later hosted release acceptance.

Hosts coordinate their Memory 0.36 adoption through
[Canic #527](https://github.com/dragginzgame/canic/issues/527),
[IcyDB #355](https://github.com/dragginzgame/icydb/issues/355) and
[Blob Storage #64](https://github.com/dragginzgame/ic-blob-storage/issues/64).
Local adapter qualification does not establish those applications' acceptance.

Earlier [0.8.2 publication verification](../evidence/release-082.md) retains its
exact archives, source and initial CI observations. Publication does not complete
native acceptance.
[Released 0.8.1 acceptance](../evidence/release-081.md)
retains its own complete Linux, Intel, Apple Silicon and Rust-floor receipts.

`MeasurementCounter` is available for scalar wide totals, merging, restoration
and exact totals/deltas. It keeps no observation statistics or stored kind.
The stable adapter still admits aggregate, summary and histogram only; no kind
is repurposed or data reset. [The counter record](../evidence/counter-082.md)
and [cleanup record](../evidence/cleanup-082.md) retain their pre-release sources,
including the 261-second final CI/floor proof and separate raw Wasm comparison.
Historical measurements do not establish later application costs.

The current lock selects Host 0.17.0, Memory 0.36.1 and Syn 3.0.9. Arithmetic
stays on Rust 1.85; stable and private inspector stay on 1.88. Shared Tooling
0.9.10 `7e55adecf6f0b196c050f104b37f8c69b6bf434e` retains all 104 payloads and
91 roots. [Its adoption receipt](../evidence/adoption-082-shared-0910.md) keeps the
earlier graph/slice scope. Metrics retains complete native validation and
direct-only release delivery; older tool generations and evidence remain retained.

## Consumer and API follow-up

The [six-consumer review](../evidence/consumer-review-082.md) binds its read-only
caller observations. Current adoption/reporting work stays with the
[owning issues](../extraction.md#downstream-contract-checks), including Toko's
[database quality bridge](https://github.com/dragginzgame/toko-miner/issues/49).
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) retains Canic's
original held-HTTP/native qualification. [Canic #450](https://github.com/dragginzgame/canic/issues/450#issuecomment-6126296388)
and [#491](https://github.com/dragginzgame/canic/issues/491#issuecomment-6126296804)
retain the scoped repair and Auth blocker; no new passing runtime/macOS proof
is claimed. Logs remain in Canic's `.tmp/metrics-qualification-20261012/`.
[#69](https://github.com/dragginzgame/ic-metrics/issues/69) and
[#71](https://github.com/dragginzgame/ic-metrics/issues/71) own the selected
error and stable-boundary cuts. This batch edits Metrics only and performs no release effects.
