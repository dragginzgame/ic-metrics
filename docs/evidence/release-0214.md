# Published 0.2.14 qualification

Release `v0.2.14` selects `dee5ecdef3d811dcda930ddcaae48abf08acc951`.
The previously observed official registry index reports a non-yanked package
with no dependencies/features, Rust 1.88 and checksum
`0352d28c75d11f7350184586716aa10b415b6a3da8427186e1768a621546a290`.
The registry archive already present in the local Cargo cache verifies against
that checksum. Its embedded Git identity, all five Rust files, packaged application
guide, original manifest, README, license and lock match the release commit.
This is checksum/payload verification of a cached registry artifact, not a new
download or compilation of the package.

[Exact-source CI 37788551242](https://github.com/dragginzgame/ic-metrics/actions/runs/37788551242)
now completes successfully on Linux, macOS 15 Intel, macOS 15 Apple Silicon and
Linux MSRV. All three newly downloaded native archives verify their outer digest,
top-level payload digests, source hashes against the selected release commit,
run/attempt/event/host identity and all nine successful setup/native outcomes.
Each native log records the collector fixture passing and all 19 isolated
real-Git tracking cases passing. These fixtures qualify tooling with substituted
release/Make effects; they do not execute an interrupted live GitHub release.
The initial local verifier incorrectly expected a summary log line instead of
the actual per-scenario lines; the corrected verifier checks all 19 recorded
successes. Both attempts are retained.

Receipts, downloaded archives, package payload comparisons and logs remain under
`target/evidence/release-0214/`. Their archive identities are:

| Native artifact | SHA-256 |
| --- | --- |
| Ubuntu 24.04 | `26b7d925c8e813a5a6af8026fbe2eabdbb4ae391debdf6362006e5233651c1b5` |
| macOS 15 Intel | `102ffd1475927f4437f47e254d770dc60e7b9f82ef84618dc159c93aa748f5b5` |
| macOS 15 Apple Silicon | `3ba6842bd664d28d96c8ed0ee3c15e1323d5b7ca3321f97e7afd16bed5bfe3c4` |

The released 75-file Shared Tooling snapshot selects
`b866d41041a1986eeec95bde9af4c6ba0853d2e3`; its preparation remains bound to
[adoption-0214.md](adoption-0214.md). This completes the exact consumer native and
downloaded-receipt obligation in [#33](https://github.com/dragginzgame/ic-metrics/issues/33).
It does not rebind these results to the newer local 0.2.15 preparation, its private
host inspector or subsequent Shared Tooling snapshot. Those batches retain
separate qualification issues. No source/graph change, full local gate, commit,
push, release, publication, workflow dispatch or sibling edit ran for this review.
