# Memory 0.36 adoption for pending 0.8.3

This batch starts over released Metrics
`65d824d501d9f3d21bb9b01c298488dcdf3f7d23` with the pending decoder/docs cleanup
and incoming root selections for Memory 0.36.0 and Host artifacts/fs 0.16.0.
Starting working bytes and the index observation are retained separately; the
incoming Cargo requirement and lock bytes remain unchanged during qualification.
Package versions remain 0.8.2. Earlier receipts keep their original graphs.

Official Memory 0.36.0 is non-yanked. Its archive SHA-256 is
`cbaf6e99f3a3c58e2fc489f9e877d81dc04a3e9e601c2ef4555399fffa963985`.
Public main, peeled v0.36.0 and embedded archive Git identity agree on
`834fb71b09d84655dc64bd89b6bfb4c0c9b35c9d`; all 47 Rust sources match that commit.
Official Host 0.16.0 archives also verify against their index checksums and
`046751faafecf8fb9e924e7c813efcbb69d36d10`, including all 19 artifacts and 18 fs
Rust sources. Resolved Cargo source bytes match those released sources.
Unpublished sibling worktree changes are not selected.

Memory now takes an owned complete request list for sealing and removes global
registration. Metrics never registers or bootstraps in production; the host
supplies its map. The existing bootstrap/reopen fixture now passes owned requests,
retaining one application allocation for multiple metric namespaces. The stable
guide describes explicit host composition before opening memory.

The exact `ic-stable-structures` 0.7.2 lock row and re-export remain unchanged,
so the adapter's public map and memory-trait identities remain compatible.
Its V1 codec, permanent keys, size limits, numeric/identity admission and reset
semantics stay unchanged. Memory's published migration preserves ledger bytes
and retained IDs. No memory reset, stable format change or new bootstrap owner is
introduced. Core arithmetic still resolves no dependencies; `ctor` and its macro
helper are absent from the new graph. No measured Wasm/cycle reduction is claimed.

Read-only caller review finds existing host migrations in
[Canic #527](https://github.com/dragginzgame/canic/issues/527) and
[IcyDB #355](https://github.com/dragginzgame/icydb/issues/355). Blob Storage still
selects Memory 0.35 with the old declaration error/global and borrowed sealing
fixtures; [#64](https://github.com/dragginzgame/ic-blob-storage/issues/64) tracks
its coordinated migration. Hosts must retain one Memory package identity and
own their application qualification. No sibling edit/build or runtime acceptance
is performed here.

`make fmt`, focused stable/inspector checks and warning-denied Clippy pass.
Full `make ci` passes in 282 seconds; `msrv`, `stable-msrv` and
`wasm-inspect-msrv` pass in 1, 3 and 1 seconds. The core retains Rust 1.85
native/Wasm; the adapter retains 1.88 native/Wasm and the inspector 1.88 native.
All ten adapter tests, its compiled example, 50 core tests and eight core doctests
pass. Eight checkpoints agree on all 140 captured inputs. Native reopen tests
establish storage behavior rather than IC execution or later macOS acceptance.

The [frozen receipt](memory-083.public.tar.gz) and [checksum](memory-083.public.tar.gz.sha256)
retain source inputs, initial working bytes, exact registry packages/indexes,
resolved metadata, public identities, focused/full logs and owning issue reads.
Archive readback verifies retained bytes and checkpoints. Real Git index/ref,
snapshot/pins and incoming dependency selections remain unchanged; no release
or publication effect is performed.

The public distribution omits private-consumer checkout observations and their
file-inventory rows. Its `distribution-provenance.json` binds
unchanged retained bytes to the original archive. [The distribution record](archive-distribution-072.md)
identifies the privately retained original/checksum and the remaining published
history scope; this replacement does not establish the omitted consumer
acceptance or qualify a later source or dependency graph.
