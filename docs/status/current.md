# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns setup, focused checks and delivery gates.

## Pending 0.9.1

Shared Tooling 0.11.1 `7a7430bd30902dc655a025be61696ce19417c54a` is adopted
through the reviewed exporter from a clean committed checkout. The snapshot
has 106 payloads and 92 roots; selected common tool versions/digests are unchanged.
Metrics delegates coordinated Cargo preparation/rollback and selected-commit
metadata checks to the corrected upstream helper. Source admission, locked cache
preparation, selected tool admission, direct delivery and publication remain local.

The published Host CLI 0.17.4 is admitted through the shared selected Cargo-tool
installer. Metrics no longer maintains its private inspector package, tests or
floor; IC Host owns those. The local tool extension explicitly installs/checks the
exact published selection, and offline dispatch smoke tests use its returned path.
The workspace now owns only arithmetic and stable packages; pruning removes the
inspector's unneeded registry graph without upgrading retained packages.

Stable size admission now occurs once before row lookup. Unsupported histograms
still fail before absent/corrupt rows; failed saves leave the map unchanged.
Stored V1 bytes and public error ordering are preserved.
[The owner-convergence receipt](../evidence/owner-convergence-091.md) separates
upstream qualification, actual consumer checks and retired historical sources.
Full Linux CI passes in 301 seconds; arithmetic/stable native and Wasm floors
pass in one/two seconds. The exact 100-input working source is qualified in a
disposable checkout, preserving the real staged tree/refs.
Earlier [upstream qualification](../evidence/upstreams-091.md) and
[Shared 0.10 adoption](../evidence/shared-010-adoption.md) retain their original
inputs; their three-package gates do not qualify the current two-package graph.

This contributor-tooling batch is compatible with the published libraries; notes
select 0.9.1 without changing Cargo versions. Native macOS acceptance remains
with [#70](https://github.com/dragginzgame/ic-metrics/issues/70); Linux execution
and cross-compilation do not establish hosted macOS acceptance. No release,
commit or publication is performed by this batch.

Six earlier evidence archives now have separately named sanitized distributions.
Their private-consumer payloads and mixed review rows are omitted; retained
measurement, source and validation bytes are unchanged. Exact originals and
checksums remain in ignored `.private-evidence/archive-review-072/`, outside Cargo
clean. [The distribution record](../evidence/archive-distribution-072.md) binds
original/replacement identities and the public Git blobs. This fixes the local
distribution; published main and v0.8.1–v0.9.0 history still contain originals.
[#72](https://github.com/dragginzgame/ic-metrics/issues/72) remains open for the
source-owner export decision and separately authorized history disposition.

## Delivered 0.9.0

Local finalized release source is `fe4d14f2a24138794878a17a354885a1e7222487`.
The current arithmetic API removes unreachable mean/interval cases under the
exact-count invariant ([#69](https://github.com/dragginzgame/ic-metrics/issues/69))
and names actual overflow explicitly. Flags use `*_overflowed`; histogram flags
are `bucket_overflowed()` and `overflow_count_overflowed()`, while `overflow()`
remains the count above the last bound. Remaining overflow errors use
`SampleCountOverflow`, `TotalOverflow`, `CountOverflow` and `InvalidOverflowFlag`.
Consumer-owned DTO/wire names and policies remain at their owner.

Stable kind/codec/continuity dispatch requires a privately constructible
zero-sized capability ([#71](https://github.com/dragginzgame/ic-metrics/issues/71)).
Generic `DurableMetric` store operations remain supported. Clipping, exact caps,
empty/zero observations, V1 bytes and host lifecycle stay unchanged; no data reset
or compatibility alias is introduced. The six read-only consumer reviews remain
bound to their original inputs and [owning issues](../extraction.md#downstream-contract-checks).

[The API-boundary receipt](../evidence/api-cut-090.md) retains its original
Host 0.17.0/Memory 0.36.1 graph, 254-second CI, byte-identical nine Wasm probes
and seven V1 records. [The earlier error-cut receipt](../evidence/error-cut-090.md)
retains its original Host 0.16 graph and measured mean/scaled/interval reductions.
Those records do not qualify later dependency graphs, IC costs or applications.
[Archive distribution review](https://github.com/dragginzgame/ic-metrics/issues/72)
stays separate from this tooling adoption; frozen originals remain privately
retained and unchanged.

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

The current library lock selects Memory 0.36.3 and Syn 3.0.9; Host is a separately
managed executable. Arithmetic stays on Rust 1.85 and stable stays on 1.88.
Current qualification is recorded above. [The earlier tooling receipt](../evidence/adoption-082-shared-0910.md)
retains its original revision and graph; later snapshots do not relabel its proof.
Metrics retains direct-only release delivery and all earlier evidence/tool generations.

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
error and stable-boundary cuts. The selected extractions also changed their authorized upstream owners; this batch
performs no release effects.
