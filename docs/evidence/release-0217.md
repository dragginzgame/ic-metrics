# Published 0.2.17 verification

Release `v0.2.17` selects `52be29e4bc2433b3d2912a0c09538be993dfb1b2`,
matching the inspected public main and workspace/package versions. The official
registry index reports a non-yanked package with no dependencies/features and
Rust 1.85.0. The downloaded archive verifies SHA-256
`546430c8842aa043a041e51a69b49ef6ab280353aff5a05caa1cbdacd5508676`.
Its embedded Git identity, seven Rust sources, application guide, original
manifest, README and license match the release commit byte-for-byte.

At this inspection, [exact-source CI 37900937307](https://github.com/dragginzgame/ic-metrics/actions/runs/37900937307)
passes Linux native and both package minimum-compiler checks. Apple Silicon is
running and Intel remains queued. This is publication and partial hosted
verification, not a complete native receipt review. The release selects private
IC Host dependencies 0.8.5; a later local 0.8.8 lock update is separate.

The [reporting preparation](reporting-0217.md),
[Host 0.8.5 review](host-dependencies-085.md) and
[sibling measurement-needs audit](../reports/audits/2026/10/09/measurement-needs/01/report.md)
retain their original source/graph identities. Publication does not establish
downstream adoption or IC cost qualification. Downloads and comparisons are
retained under `target/evidence/tooling-0218/`.
