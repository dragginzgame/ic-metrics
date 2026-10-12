# Published 0.7.3 verification

Local released HEAD, public main and the peeled 0.7.3 tag agree on
`e714085a972db88c348e4aabe57847f2124d2b97`. Both official archives match their
non-yanked registry checksums and embed that exact source:

| Package | SHA-256 | Rust floor |
| --- | --- | --- |
| ic-metrics 0.7.3 | `f0a18a8f40289188ded463aded05aec282ee1ea979092c4ec7b1a2ef0c6b3000` | 1.85 |
| ic-metrics-stable 0.7.3 | `82ddcd291eabcc4ba4603087dce1101e865cf9bfc238e8a2f838da58884fa0d5` | 1.88 |

All 11 packaged arithmetic and four stable-store Rust files match the released
tree. Arithmetic remains dependency-free with no features. The release delivers
Shared Tooling 0.9.0 and all four prepared Shared adoption receipts with their
original source/graph identities. The committed lock selects Host 0.14.9 and
Memory 0.35.17; the local 262-second preparation gate retains its earlier Host
0.14.8 graph and cannot be relabelled as that final locked selection.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38248805595)
passes package floors, with Linux running and both macOS jobs queued at the first
observation. This publication record does not claim complete new native acceptance.
[Completed 0.7.2 acceptance](release-072.md#complete-native-acceptance) closes its
original adoption obligations independently; current-source CI remains separate.

Raw official rows, downloaded package archives, source comparisons and the API
observation remain under `target/evidence/release-073`. This review performs no
staging, commit, metadata change, release/publication or sibling source mutation.

The subsequent API observation confirms Linux and Apple Silicon native jobs pass,
with the package-floor job also passing and Intel still running. The exact source
remains `e714085a972db88c348e4aabe57847f2124d2b97`. Source-bound receipt verification
and complete current-source native acceptance remain separate; the observation is
retained under `target/evidence/issues-current/metrics-ci-final.json`.

## Complete native acceptance

The completed run passes all three native hosts and the package-floor job at
the exact released source above. Each downloaded artifact matches its GitHub
SHA-256 digest and its inner archive checksum. Each receipt records seven
successful outcomes, all 86 source-file hashes match the released tree, and all
14 top-level payload hashes verify independently.

| Native host | Artifact ID | Original ZIP SHA-256 |
| --- | --- | --- |
| Linux x86_64 | `11747947292` | `5ac0767a5f2a238179e2d924a4308e8b97e653d5563408b74ab21b80718bc9fe` |
| macOS x86_64 | `11749728867` | `f5545f51392ea894098bccf161d0ee200a3f7078b124dc1dd22f49aced1e7682` |
| macOS arm64 | `11746914644` | `a2e1a826f75ff771723de86454d37104a5da61fe5d4cd0b1c2d52ef16d8f8a52` |

The [compact verified receipts](native-closeout-073.tar.gz) and
[checksum](native-closeout-073.tar.gz.sha256) retain API metadata, every verified
top-level payload, original archive checksums and verification results. Their
archive SHA-256 is
`e912c1d8363ea59cdbd5fd3cd9f36c173180edc7d88735c44b5d2011609ac68e`.
Nested fixture scratch trees are excluded; this compact archive cannot reproduce
the original ZIP/tar bytes. Complete downloads remain under
`target/evidence/native-closeout-073`. This acceptance covers the committed Host
0.14.9/Memory 0.35.17 graph; earlier local gates keep their original identities.
