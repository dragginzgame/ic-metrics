# Published 0.8.0 verification

Local released HEAD, public main and peeled v0.8.0 agree on
`71a29d8a4d7ecf6774d9715895ce9abd13b9e5d7`. Both official non-yanked archives
match registry checksums and embed that exact Git source:

| Package | SHA-256 | Rust floor |
| --- | --- | --- |
| ic-metrics 0.8.0 | `8ea44e32777b165cd60bdc0316d11891088ec87592648ba2bb7ca6949dfbfc37` | 1.85 |
| ic-metrics-stable 0.8.0 | `1ea2fbcb4440bf6de01a0c884bab6b1316b3ac2d1d2ac41216815b8691c4057b` | 1.88 |

All 11 packaged arithmetic and four stable Rust sources match the released
tree. Arithmetic has no dependencies or features; the optional store depends on
registry Metrics 0.8 and Memory 0.35.12 or compatible. The committed lock retains
Host 0.14.9 and Memory 0.35.17, with all workspace rows at 0.8.0.

The [tracked recording cut](tracked-080.md) is published: no raw recording/mean
helpers or compatibility aliases remain. Tracked scaled means retain exact-cap,
empty/zero and overflow semantics. Stable Rust source and V1 bytes are unchanged.
Its two frozen source/IC delivery archives match the prepared identities:

- Cost/replay archive: `c7c324e96208493650a3b26bef37a0712b03f8e00a5c418ace0f98a7b20697e7`.
- Delivery archive: `c2a5547734ec78d0b72ccbc4ad4865438e99c9794d7816c5cb9e4c2680841fac`.

Those receipts retain their pre-release 0.7.3 metadata and explicit graph; this
verification does not relabel them as released-source CI. The exact-source
[release run](https://github.com/dragginzgame/ic-metrics/actions/runs/38272775932)
is queued at the first observation. A later inspection records successful Linux
native and package-floor jobs; both Intel and Apple Silicon macOS remain queued.
These API outcomes are distinct from downloaded native-receipt acceptance. Root
[#66](https://github.com/dragginzgame/ic-metrics/issues/66) remains open for
native acceptance. Owning consumer adoption remains separate from publication.

The [frozen publication receipt](release-080.public.tar.gz) and
[checksum](release-080.public.tar.gz.sha256) retain registry rows, official package
archives, all 15 frozen Rust sources and their hashes, API observations and the
six consumer publication notifications. Fresh archive readback verifies the
package checksums and all frozen Rust source hashes. No release,
publication, staging, Git effect or sibling edit is performed by this review.

The public distribution omits private-consumer material and projects mixed review
records onto the five public consumers. Its `distribution-provenance.json` binds
unchanged retained bytes to the original archive. [The distribution record](archive-distribution-072.md)
identifies the privately retained original/checksum and the remaining published
history scope; this replacement does not establish the omitted consumer
acceptance or qualify a later source or dependency graph.
