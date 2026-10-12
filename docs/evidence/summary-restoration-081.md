# Summary restoration consistency for pending 0.8.1

[Metrics #67](https://github.com/dragginzgame/ic-metrics/issues/67) reproduces
an impossible restored summary: two observations, total 20, maximum 10 and
latest zero. Aggregate admission alone cannot reject that combination; the
other observation would need to exceed the maximum. Both the core constructor
and the reopened V1 map regression fail before the correction, admitting that
state. Raw failing logs remain separate from passing checks.

The canonical `MeasurementSummary::from_parts` now checks the upper total bound
for an exact count: `(samples - 1) * maximum + latest`. This fits `u128` for
admitted `u64` observations. Overflowed counts remain clipped, so they cannot
impose that bound. Existing `InvalidLatest` and the stable adapter's
`InvalidState(InvalidLatest)` carry the failure. A reopened map rejects load
and save without overwriting the inconsistent record. Valid states, recording,
public signatures and V1 bytes stay unchanged; no stored-data reset is needed.

Focused state tests include exact wide/count-cap boundaries, the valid boundary
immediately below the rejected total, and restoration after actual count
overflow. An independent oracle enumerates real observation sequences of one
through four values in `0..=3`, checking admission of candidate aggregate/latest
combinations. Existing restoration replay and wide-value cases pass. Native/Wasm
Clippy passes for arithmetic and the stable adapter.

The six read-only consumer reviews record exact checkout commits and hashes of
the selected summary/store files. No direct summary restoration or Metrics store
caller is found in IcyDB, Canic, Timers, Backup, Blob's test probe or Toko Miner.
Timers and Backup continue to record tracked summaries; Canic and Toko also
retain their own summary usage. No sibling edit or consumer qualification is
performed. The first search wrapper omitted an explicit directory and searched
stdin; its incomplete result is retained separately from the corrected file scan.

The earlier [Shared 0.9.5 adoption receipt](adoption-081-shared-095.md) keeps its
pre-fix source identity and qualification. It does not qualify these Rust edits.

Full `make ci` passes in 258 seconds. All package-floor gates pass: arithmetic
Rust 1.85 native/Wasm, stable Rust 1.88 native/Wasm and private inspector Rust
1.88 native. All eight gate checkpoints match the 136 frozen/current source
inputs. Only the intended summary source, core state tests and stable tests
differ from the earlier tooling qualification. Cargo metadata, lock and tool
pins remain unchanged. This is local Linux delivery qualification, without
hosted macOS or IC performance claims.

The first delivery launch selected snapshot digests instead of paths and stopped
before any gates. Its input errors and launch log are retained; the corrected
selection passes all four gates. The [frozen receipt](summary-restoration-081.tar.gz)
and [checksum](summary-restoration-081.tar.gz.sha256) retain failed reproductions,
focused/full logs, both delivery attempts, source/checkpoint hashes, frozen
validation and consumer source bytes, exact upstream review identities and
verification records. Fresh archive readback verifies all 136 source inputs,
selected consumer files and eight completed checkpoints. The initial readback
used canonical member names against rg paths retaining `./`; normalizing lookup
paths verifies the original archive without changing its bytes.

Shared Tooling remains at reviewed 0.9.5. Host 0.15.0 changes no production code
in the consumed artifacts/FS source scope; its FS delta isolates a private test.
Memory 0.35.18 changes no production Rust source from 0.35.17. Neither read-only
review changes Metrics' graph or qualifies those upstream releases here.
Package metadata remains 0.8.0; compatible pending notes remain 0.8.1. No Git
index/ref, release, publication or sibling-edit effect occurs.
