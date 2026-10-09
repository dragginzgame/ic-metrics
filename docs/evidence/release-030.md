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

## Native acceptance complete

The same exact-source run now succeeds on all three native hosts and MSRV.
Authenticated REST downloads verify both macOS artifacts, preserving the original
Linux observation above rather than relabeling its earlier queued state.

| Host | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Intel macOS | `11627935028` | `a2aa3699eb75dd9544a5ed450ae2b5938d513433884a4397646c0718882980a8` | `11305d7ae523cf4d63271d76a1c5043595f2f8f47becb4cc04e1981ecf858e2b` |
| Apple Silicon | `11624079394` | `7ea8b407a28aa8811e5b38ac8f16a62bd0e8e850903d449f3cd268bbb6b4c892` | `b38b4d840ece2343f55e2d98aa2ffa7a399b80d83f1606a6c6d005fa0a06cd67` |

Each verifies all 14 payload and 65 source hashes, exact source/run/attempt 1/
push/Darwin/architecture identity and nine successful setup/native outcomes.
Pins match the released catalog and contain exactly the five selected tools.
Provision logs record actual installation; native logs confirm installer
activation/refusal/retention and release-admission fixtures pass with their
declared substitutions. The released Make/CI/product source has no active server
caller. The earlier preparation record retains old bundle/replay identities;
this review performs no cleanup or runtime replay.

Inputs, downloaded archives, extracted logs and verified summaries remain under
`target/evidence/release-030/native-closeout/`. This completes
[#41](https://github.com/dragginzgame/ic-metrics/issues/41)'s source-bound tooling
acceptance. Later installer/hook batches and the incoming Host 0.9.5 graph retain
separate qualification. No builds, tests, CI reruns, release or publication ran.
