# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns setup, focused checks and delivery gates.

## Pending 0.8.3

The stable decoder uses one checked slice split instead of checking the same
boundary twice. Truncated input retains the existing typed failure before cursor
advancement. Public signatures, V1 bytes, size limits and restoration/identity
checks stay unchanged. [The decoder record](../evidence/decoder-083.md) retains
its source and qualification. Current guides now identify the scalar counter as
released. This compatible batch selects 0.8.3 notes; package metadata stays
0.8.2 and the real Git index/ref is unchanged. The decoder receipt retains its
earlier Memory 0.35.19/Host 0.15.2 graph qualification.

The incoming selections now use Memory 0.36.0 and private inspector Host 0.16.0.
The stable bootstrap fixture supplies owned explicit requests; hosts still compose
and bootstrap once. Exact `ic-stable-structures` 0.7.2 types, V1 records, retained
allocation IDs and Rust floors remain unchanged. Constructor dependencies leave
the stable graph, while arithmetic stays dependency-free.
[The Memory adoption receipt](../evidence/memory-083.md) verifies the published
sources and the selected graph. Full CI passes in 282 seconds and all package-floor
gates pass; eight checkpoints match the 140 frozen/current inputs. Corruption,
checkpoint refusal and one-binding reopening coverage stays intact.

Hosts coordinate their Memory 0.36 adoption through
[Canic #527](https://github.com/dragginzgame/canic/issues/527),
[IcyDB #355](https://github.com/dragginzgame/icydb/issues/355) and
[Blob Storage #64](https://github.com/dragginzgame/ic-blob-storage/issues/64).
Local adapter qualification does not establish those applications' acceptance.

## Released 0.8.2

Public main, peeled v0.8.2 and local released HEAD agree on
`65d824d501d9f3d21bb9b01c298488dcdf3f7d23`. Both official non-yanked archives,
embedded Git identities and all 13 core/four stable Rust sources verify.
[Publication verification](../evidence/release-082.md) retains exact checksums and
CI observations. Linux and the floor job now pass; both macOS jobs remain queued
at the final read. Publication does not complete native acceptance.
[Released 0.8.1 acceptance](../evidence/release-081.md)
retains its own complete Linux, Intel, Apple Silicon and Rust-floor receipts.

`MeasurementCounter` is available for scalar wide totals, merging, restoration
and exact totals/deltas. It keeps no observation statistics or stored kind.
The stable adapter still admits aggregate, summary and histogram only; no kind
is repurposed or data reset. [The counter record](../evidence/counter-082.md)
and [cleanup record](../evidence/cleanup-082.md) retain their pre-release sources,
including the 261-second final CI/floor proof and separate raw Wasm comparison.
Historical measurements do not establish later application costs.

The released lock selected Host 0.15.2, Memory 0.35.19 and Syn 3.0.9. Arithmetic
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
Public error-surface removal remains in [#69](https://github.com/dragginzgame/ic-metrics/issues/69)
and needs a separately selected API cut. This batch edits Metrics only and
performs no release effects.
