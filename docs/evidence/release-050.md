# Published 0.5.0 verification

Public main, annotated tag `v0.5.0`, package/workspace versions and embedded
registry Git identity match `01549632c0c3fa6e1ff315ce4de803ddfae904ad`.
The official non-yanked registry row has no dependencies or features and declares
Rust 1.85.0. Downloaded package SHA-256 verifies as
`04d79403a81e4fa0bc2a7434c181995c57246b85aa647a84838e712183013b1d`.
Seven Rust files, the application guide, original manifest, root README and
license match released source. The packaged lock contains only Metrics 0.5.0.
Arithmetic source is unchanged from 0.4.0.

The release delivers the [complete Shared Tooling 0.3.0 adoption](adoption-050.md)
and separately [qualified private Host 0.12 graph](host-dependencies-0120.md).
Remove the retired `--with-ripgrep` and `--with-cloc` installer flags; run
`make install-tools`, then `make tools-check` for the ordered complete common set.
Arithmetic APIs, attribution, consumer identity/state, endpoints and report
output remain unchanged.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38046372803)
passes Linux and both package-floor checks; Intel and Apple Silicon jobs remain
queued at inspection. Downloaded Linux receipt `11668405206` verifies ZIP
SHA-256 `d17ef6d81dc086539ccd677fae7375ff73a65769fa2fb20ac72ced65a4b330bc`
and inner archive SHA-256
`d50bddeeba26c5528d6bd057c8077afaa2ee686b33a6568a7c8b9e13887cb632`.
All 14 payload and 70 released-source hashes, exact workflow source catalog,
run/attempt/host/pin identities and seven successful outcomes verify. Logs prove
the actual ordered aggregate, collector, release/admission, formatting and
inspector CLI checks ran; two nonempty formatting diagnostics are retained.
Effects substituted inside the fixtures remain substitutes, not live release
or IC runtime measurements.

Delivery is complete. [Metrics #47](https://github.com/dragginzgame/ic-metrics/issues/47)
retains exact-source macOS acceptance; 0.4.0's complete matrix does not qualify
this changed aggregate/workflow. [Shared #98](https://github.com/dragginzgame/shared-tooling/issues/98)
owns producer acceptance separately. Shared 0.3.0's exact-source Linux,
lint/security and Apple Silicon jobs pass, with Intel running at inspection.
No newer committed Shared or Host revision is available; dirty Shared sibling
installer/documentation edits are not adopted.

Registry/tag observations, downloaded package and receipts, source/payload
verification and issue review are retained under `target/evidence/review-050/`.
No sibling edits, tool installation, compilation, dependency resolution,
workflow dispatch, commit, push, release or publication occurs in this review.

## Apple Silicon acceptance

A subsequent review finds 0.5.0's exact-source Apple Silicon job passing, with
Intel still queued. Downloaded artifact `11669025753` verifies ZIP SHA-256
`4f21c224aba726b822a9fd421578c564f2097e5130e1cf1200d8d83cb4a17e3c`
and inner archive SHA-256
`98c84d22d4ffa3cb5f6db712ae4184303975bc4aadd5a41f92b7fcf45e50e0b5`.
All 14 payload and 70 released-source hashes, exact catalog, run/attempt/host/pins
and seven successful outcomes verify. Logs prove actual aggregate, collector,
release/admission and inspector CLI execution; two nonempty formatting diagnostics
are retained. Effects inside fixtures remain substitutes.

Records are under `target/evidence/issues-051/`. #47 now retains only Intel
acceptance. This released-source result does not qualify pending 0.5.1's owned
Cargo jobserver repair in #48; no rerun or release is performed.
