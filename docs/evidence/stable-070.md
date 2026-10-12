# Optional durable snapshots in pending 0.7.0

The maintainer accepted one optional stable B-tree map holding namespaced metric
records. The working adapter is `ic-metrics-stable`; using `ic-metrics` alone keeps
the dependency-free, allocation-free `no_std` arithmetic path. Workspace metadata
remains 0.6.6. This is an additive adapter within the pending 0.7.0 batch selected
for its independent wide-total API cut, not a release or publication.

## Ownership and stored contract

The host declares one permanent `ic-memory` key, such as `app.metrics.v1`, admits
it through its one pool/bootstrap, and opens one metrics-only B-tree map. The
adapter takes that collection rather than initializing arbitrary memory. Numeric
ID choice, geometry, collection corruption, capacity/traps, synchronization,
authorization, label cardinality, lifecycle and write cadence retain their
upstream or consumer owners. Never initialize an unknown retained region as a
recovery fallback. IC Memory's governance allocations are separate.

V1 values encode a discriminator, kind, bounded unit, reset epoch and explicit
little-endian arithmetic fields. Aggregates preserve samples, `u128` total,
maximum and sticky actual-overflow flags. Summaries add latest; histograms add
up to 256 finite bounds, disjoint counts and bucket overflow flags. One record
is limited to 4,608 bytes at the codec boundary. The byte-valued map permits typed
value decoding outside the infallible `Storable` decode hook; collection reads
still allocate under the upstream map's own structural contract.

The arithmetic core's `from_parts` APIs admit empty/zero distinctions, count/total
feasibility, maxima/latest, clipped flags, bucket counts and range-constrained
totals without inferring provenance. Unknown formats, malformed records,
identity/configuration differences and regressing checkpoints are refused before
mutation. Identical checkpoints are replacement and idempotent. Explicit row
removal verifies its envelope/identity and discards its payload, including a
corrupt payload; it never retires the allocation. The host resets into a new
epoch in the same update message without an intervening await.

## Dependency and source review

The graph selects registry IC Memory 0.35.12 and its stable-structures 0.7.2
re-export. Its packaged source matches committed sibling revision
`3cad38a8a93b3755eb0056c8a72963e56cb61aec`. There is no external path dependency.
All 24 pre-existing lock rows retain their complete identity/content; 23 new rows
include the adapter and its required graph. The arithmetic package's selected
dependency tree remains one node. The adapter's qualified floor is Rust 1.88 on
native and Wasm; the arithmetic floor stays Rust 1.85.

The read-only consumer review checks IcyDB `c084b9a5a8167aa1f61631e57197f29d7a14ef2c`,
Canic `25b73cd403b20b4e148c6e340f8c760a26d97f6e`, Timers
`52bc4bad399122be040cf155d9b4563b5509e009`, Backup
`032066f2079cd2ac93b230c4a32bbcf27ffe0c59`, Blob
`9398b06bfd2f451ca9e883f18d06a1589f1e3a47` and Toko Miner
`3e53fb5b8963c126edf9d236f86c71c0a2f335cc`. None declares the adapter. Existing
volatile measurement policy, endpoints and report/attribution contracts remain
unchanged. Backup explicitly starts host diagnostics empty on create/open and
never persists/serializes them; this adapter does not change that contract.

## Focused qualification and delivery

Seven new core restoration tests include exhaustive small sequences with wide
observations and rejection of impossible histogram totals/overflow claims.
Nine adapter tests cover native map reopening, mixed kinds/namespaces, actual
IC Memory bootstrap/rebootstrap retaining the application ID, caps/overflow,
malformed records, configuration/identity refusal, checkpoint continuity and
deliberate reset. This is native storage/codec evidence, not IC upgrade execution.

The consumer release fixtures now cover all three local lock identities and all
four validation gates, including fail-fast retention for the adapter's Rust floor.
The command-stub publication fixture selects both public packages. A real
Cargo multi-package publication dry run in a disposable 0.7.0 copy confirms
core-before-adapter ordering and both packaged builds. Cargo-edit advances the
adapter's core requirement to 0.7 during normal workspace preparation. Real
metadata/index/refs remain untouched. Early restricted-network/offline packaging
refusals and the initial missing fixture gate are retained separately from the
successful checks under `target/evidence/stable-070`.

The arithmetic hook's disposable export also includes the new package when it
overlays the current workspace manifest. Its focused hook/failure-retention
checks pass; the initial missing-package export failure is retained. The final
`make ci` passes with 44 core tests/seven doctests and nine adapter tests/one
doctest, warnings-denied native/Wasm Clippy, docs, all maintained tooling fixtures
and the private inspector checks. All three package-floor gates pass; core and
adapter floors cover native/Wasm. A final dry run rebuilds both package payloads.

[The frozen native bundle](stable-store-070.tar.gz) and
[its checksum](stable-store-070.tar.gz.sha256) retain exact product source, lock,
successful/failed logs and both 0.7.0 dry-run .crate files. Its SHA-256 is
`a11733333ee9368c148827e644c0286a81f2cda0e43e7e3e6fe6c98fe7a14628`.
A fresh extraction checks its complete file manifest and reruns all seven core
restoration and nine adapter tests against the frozen locked source. Shared
tooling/full CI context remains with the owning checkout and recorded snapshot;
the bundle's replay guide makes that scope explicit.

[The current handoff](../status/current.md) records completed delivery checks.
Real IC upgrade/message qualification and instruction/cycle/Wasm storage costs
remain with [#64](https://github.com/dragginzgame/ic-metrics/issues/64). Existing
wide-total arithmetic performance archives retain their original source scope;
they do not qualify stable map reads/writes or the adapter.
