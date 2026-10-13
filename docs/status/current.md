# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns setup, focused checks and delivery gates.

## Pending 0.8.4

Native/wide mean projection now lives with its aggregate and interval callers;
the implementation and public contract stay unchanged. Existing empty/zero,
exact-cap, overflow, interval and constant-evaluation checks retain their owners.
Standalone aggregate/interval mean Wasms are byte-identical before and after the
move; this is raw byte evidence, not an IC instruction or cycle measurement.
The incoming lock selects Memory 0.36.1; its published sources and unchanged
exact collection types verify. Package metadata stays 0.8.3 and the real Git
index/ref is unchanged. Qualification belongs to this source and graph.

Full `make ci` passes in 377 seconds and all three package-floor gates pass.
Eight checkpoints agree on the 140 frozen/current inputs. The
[frozen qualification](../evidence/cleanup-084.tar.gz) and
[checksum](../evidence/cleanup-084.tar.gz.sha256) retain before/after sources,
registry/graph verification, mean probes, compiler identities and validation logs.
Final documentation edits pass link, consistency and diff checks separately.

## Delivered 0.8.3

Public main, peeled v0.8.3 and local release commit agree on
`39d7e0dd579231b61cca71bb713f3ba5afef4227`. The release contains the checked
stable decoder and explicit Memory 0.36.0 request fixture with Host 0.16.0.
[The decoder receipt](../evidence/decoder-083.md) retains its earlier graph;
[the Memory adoption receipt](../evidence/memory-083.md) retains the final
282-second local CI/floor qualification. Those preparation receipts do not
qualify the pending Memory 0.36.1 graph or establish hosted release acceptance.
Exact `ic-stable-structures` 0.7.2 types, V1 bytes and retained allocation IDs
remain unchanged; arithmetic stays dependency-free.

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

The selected lock retains Host 0.16.0, Memory 0.36.1 and Syn 3.0.9. Arithmetic
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
