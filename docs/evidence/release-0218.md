# Published 0.2.18 verification

Release `v0.2.18` selects `3b1f461ed9aacce6c3d04d391178fecb9ce283dd`, matching
public main, workspace/package metadata and local lock versions. The official
index reports a non-yanked package with no dependencies/features and Rust 1.85.0.
The newly downloaded archive verifies SHA-256
`2ff2e0e09dd7a1ee832582062825f03b46e9fb1f3c7272f0a86ffecfd54fa513`.
Embedded Git identity, seven Rust sources, application guide, original manifest,
README and license match the release commit. The packaged lock contains only
`ic-metrics` 0.2.18. Arithmetic source is unchanged from released 0.2.17.

At this review, [exact-source CI 37903242506](https://github.com/dragginzgame/ic-metrics/actions/runs/37903242506)
passes Linux native and both package minimum-compiler checks. Intel and Apple
Silicon native jobs are queued. The downloaded Linux archive verifies SHA-256
`f160ab28e9e74878ac1f7bc4b830a46cdad389887483fd140d5bbdd98c69d7fc`,
its payload and selected-source hashes, exact commit/run/attempt/event/host
identity, and all nine successful setup/native outcomes. Its IC catalog matches
the release selection byte-for-byte. The native log records the updated local
tool fixtures and inspector tests passing with Host 0.8.8, plus all arithmetic
tests and documentation examples. These Linux receipts do not complete
[#38](https://github.com/dragginzgame/ic-metrics/issues/38)'s changed-caller native
acceptance or establish verified outcomes for the complete native matrix.

The released 89-file snapshot selects Shared Tooling
`3d33cd250fcae7dbe5cabe44b2abd6b2c91a1822`; its
[exact CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37900620129)
now passes Linux, both native macOS hosts and lint/security. The separate
[selection preparation](adoption-0218.md) retains its original local identities
and removed-symbol inventory. The released lock also selects IC Host 0.8.8;
[its independent review](host-dependencies-088.md) establishes focused Linux
compatibility and unchanged frozen-Wasm reports, not consumer native completion.

Downloads and comparisons remain under `target/evidence/release-0218/`. No source
or dependency upgrade, package version change, commit, push or release runs during
verification. Documentation maintenance creates no new pending release batch.
