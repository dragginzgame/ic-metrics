# Checked snapshot split for pending 0.8.3

The issue/cleanup review starts from clean released
`65d824d501d9f3d21bb9b01c298488dcdf3f7d23`, with the adopted Shared Tooling
0.9.10 code-hygiene/cleanup method and Metrics ownership overlay. It finds a
redundant boundary check in the stable decoder: after admitting a prefix, the
second slice operation checks a remainder that is already known to exist.

The decoder now delegates prefix/remainder admission to Rust's checked split.
Missing bytes return `StoreError::MalformedRecord` before cursor advancement;
complete fields advance once. No new parser, allocation, production panic,
method/type removal or stored layout is introduced. Aggregate, summary and
histogram restoration, identity/bounds checks, byte limits and explicit reset
semantics keep their canonical owners.

Focused native/Wasm builds, warning-denied Clippy, documentation, all adapter
corruption/reopening tests and Rust 1.88 native/Wasm floor checks pass. Existing
truncation checks exercise each cut in aggregate and histogram records; typed
failure and refusal-to-overwrite remain meaningful boundary proofs. No new
implementation-mirroring test is added and no IC performance claim is made.

[Published 0.8.2](release-082.md) is independently verified, so maintained guides
now describe its counter as available rather than pending. The current handoff
separates that release's queued native run from local preparation. Registry API
refusals retain their observation; official index/archive proof succeeds.
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) stays open for
Canic's owning held-HTTP/native acceptance; latest issue feedback supplies no
replacement pass. [#69](https://github.com/dragginzgame/ic-metrics/issues/69)
remains the separately scoped public API cut.

Compatible pending notes are 0.8.3. Package versions stay 0.8.2; dependency/pin
inputs, arithmetic source, V1 bytes and real Git index/ref remain unchanged.
No sibling edit/build, workflow dispatch or release/publication is performed.

Full `make ci` passes in 270 seconds; all three package-floor gates pass. Eight
checkpoints match the 140 frozen/current inputs, including the checked decoder.
There are no failed delivery gates. The ignored prior raw selection was absent
after release; preparation recovered its roster from the verified committed
cleanup archive and hashed current inputs afresh before starting any gate.

The [frozen receipt](decoder-083.tar.gz) and [checksum](decoder-083.tar.gz.sha256)
retain current sources, focused/full logs, compiler/floor identities, source
checkpoints, official package/index proof and before/after issue observations.
Fresh archive readback verifies retained bytes and completed checkpoints.
Final release CI observations have Linux/floors passing and both macOS jobs
queued; those hosted results belong to released 0.8.2, while these local gates
qualify the pending decoder change. Historical artifacts keep their identities.
