# Published 0.2.11 observation

On 2026-10-08, published ic-metrics 0.2.11 source is
`69b110b8fbefdac4773eac7631796f9dcb3f41a0`. The annotated `v0.2.11` tag selects
that commit. The official registry index reports a non-yanked package with no
dependencies or features and Rust 1.88. The independently downloaded crate
matches SHA-256
`dc75470aa6335a0b1f3dbefd30229e0ac10713f21193f21af3c03987afdfa0c9`.
Embedded Git identity, all five Rust files, the packaged application guide,
original manifest, lock, README and license match released source.

[Exact CI run 37748731541](https://github.com/dragginzgame/ic-metrics/actions/runs/37748731541)
now passes Linux native, macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV.
Intel was still running at the initial observation; its subsequent completed
archive is independently downloaded and verified. All three native archives
verify outer/payload hashes, source hashes against the release commit,
run/attempt/host identities and successful setup/native outcomes. Their logs
pass the actual consumer metadata/admission/retention fixtures and updated
runner command substitutes. This does not demonstrate live interrupted GitHub
release effects. Downloads and verification logs are retained under
`target/evidence/release-0211/`.

The committed 70-file snapshot selects Shared Tooling 0.1.23
`0ba0ad00ed94848e54ecc82629b6b7873b7284c0` and verifies. Preparation remains in
[adoption-0211.md](adoption-0211.md); the earlier complete native matrix is
separate in [release-0210.md](release-0210.md). The complete source-matching
result and verified receipts finish
[#28](https://github.com/dragginzgame/ic-metrics/issues/28). The package's arithmetic is unchanged; owning consumer
runtime/native obligations remain separate in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).

The read-only caller inventory still finds the same six consumers using registry
0.2 requirements. No new metrics primitive or dependency migration is needed for
this tooling-only release. The current handoff records their fresh committed
lock identities separately from dirty updates and completed historical adoption.
No dependency/package version, sibling file, Git history, hosted run or release
effect was changed for this observation.
