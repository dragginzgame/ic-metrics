# Published 0.2.15 qualification

Release `v0.2.15` selects `287251eb51412852a58cabd9de5b3c28e207e705`.
The official registry index reports non-yanked 0.2.15, published
2026-10-08T16:22:35Z, with no dependencies/features and Rust 1.85.0. The newly
downloaded official archive verifies SHA-256
`15dd6475ed0173a63cb35215032d499e239596d6f23163602688399e41002a54`.
Embedded Git identity, all five Rust files, application guide, original manifest,
README and license match the selected commit byte-for-byte. Normalized package
metadata selects the same version and Rust floor; the packaged lock contains
only `ic-metrics` 0.2.15, excluding the private inspector's host dependencies.

[Exact-source CI 37808287051](https://github.com/dragginzgame/ic-metrics/actions/runs/37808287051)
passes Linux, Intel and Apple Silicon native and the job checking both Rust floors:
core 1.85 on host/Wasm and private inspector 1.88 on host.
Downloaded Linux evidence verifies outer SHA-256
`62d83d56292a45691aef7217e01d41fbf5ce2596b7207958d643080eb89b00f7`,
payload hashes, source hashes against the selected commit, run/attempt/event/host
identity and all nine successful setup/native outcomes. Its log records inspector
check, warning-denied Clippy and the selected argument/report tests passing with
locked IC Host 0.8.2. This is the released graph, separate from the original
local IC Host 0.8.1 inspection record.

The downloaded Apple Silicon archive verifies outer SHA-256
`274e5c2ea4efd9a16b0adcf65e57f571d545024bf4e20a74fe11c9c9175d338e`,
payload/source hashes, the same selected commit and run/attempt/event, Darwin
arm64 identity and all nine successful outcomes. Its log also records the locked
IC Host 0.8.2 inspector check, Clippy and selected tests passing.

The downloaded Intel archive verifies outer SHA-256
`d806249daec1b828bdd1c6edeb0b35f930ac829abc35aede06eea5e95c114fd7`,
payload/source hashes, source/run/attempt/event, Darwin x86-64 identity and all
nine successful outcomes. All three native logs record the 19 real-Git tracking
cases, consumer admission/metadata fixtures and inspector argument/report tests
passing. Tracking effects occur only in disposable repositories.

Initial MSRV log retrieval was refused while the run was active; the later `gh`
job-log request returned an empty stream. Direct retrieval through GitHub's job-log
API succeeds and records both exact compiler versions and passing host/Wasm core
and host inspector checks. Failed/inconclusive retrievals remain separate from
the verified log. Package downloads, all three native receipts and comparisons are retained under
`target/evidence/release-0215/`. Earlier preparation logs may have been removed by
the maintainer's `cargo clean`; their committed records retain their original
scope and are not rebound to this release.

[#34](https://github.com/dragginzgame/ic-metrics/issues/34) and
[#36](https://github.com/dragginzgame/ic-metrics/issues/36) now have complete
released-source native acceptance and downloaded receipts. This does not qualify
the pending IC Host 0.8.4 lock or downstream consumers.
No release, publication, workflow dispatch or full local
CI gate ran during this review.
