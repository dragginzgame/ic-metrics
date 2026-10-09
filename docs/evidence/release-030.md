# Published 0.3.0 verification

Released source `070c768de881a6e966b93651e242e16e4f9f1111` matches public main,
annotated tag `v0.3.0` (object `746e6f1baa80ba151334fec370f848e22509f503`), and
workspace/package versions. The official registry reports a non-yanked package
with no dependencies/features and Rust 1.85.0. The archive verifies SHA-256
`11902ff2e68d6e87af9c64b105c2d9351629108ae2ba74f035fb36f44b452855`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match the release commit. The packaged lock contains
only Metrics 0.3.0. Arithmetic source is unchanged from published 0.2.20.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37920399264)
passes Linux native and both package floors. Intel and Apple Silicon native jobs
remain queued. The downloaded Linux ZIP verifies GitHub's digest; its inner
archive, 14 payload hashes, selected-source hashes, exact source/run/attempt/event/
host identity, nine successful outcomes and released IC catalog verify.
The inner archive SHA-256 is
`419d4edd940c3625d7a7d744f215c1d7237be9280311a99ffe7f781657843f08`.
The native log
records the five-tool setup/retention and repaired release-admission fixtures
passing with the private Host 0.9.1 graph. Publication does not complete
[#41](https://github.com/dragginzgame/ic-metrics/issues/41)'s native acceptance.

Inputs, archive comparisons, CI observations and verified Linux receipts remain
under `target/evidence/release-030/`. Historical measurement inputs are retained;
no runtime-cost improvement, sibling adoption, full local gate or release rerun
is claimed. The separate pending 0.3.1 snapshot keeps its own identities.
