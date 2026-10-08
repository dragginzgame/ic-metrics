# Published 0.2.10 observation

On 2026-10-08, published ic-metrics 0.2.10 source is
`90262c3b086ee39016a6f36902a610a78a139301`. The annotated `v0.2.10` tag selects
that commit. The official registry index reports a non-yanked package with no
dependencies or features and Rust 1.88. The independently downloaded crate
matches SHA-256
`8e2eaa37874c60628dd5610305baafd278bb6479724cc22d7f2b556ca1f7d4ee`.
Its embedded Git identity and `crates/ic-metrics` path, all five Rust files,
packaged application guide, original package manifest, lock, README and license
match the released source.

[Exact CI run 37745384375](https://github.com/dragginzgame/ic-metrics/actions/runs/37745384375)
passes Linux native, macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV.
All three downloaded native archives verify outer and payload checksums, source
hashes against the release commit, run/attempt/host identities and successful
setup/native outcomes. Their logs explicitly pass the runner, Make adapter,
metadata restoration, selected-commit admission and failure-retention fixtures.
These include command substitutes and isolated Git boundaries; they do not
demonstrate a live interrupted release or real GitHub failure. Retained downloads
and verification logs are under `target/evidence/release-0210/`. The first outer
checksum attempt used the workflow's original relative archive path and could
not locate it in the download directory; explicit archive-path verification
then passed. The archive payload has a flat evidence root, independently verified.

The committed 70-file snapshot selects Shared Tooling 0.1.22
`2687f26317952c43c685f7f799ed09288dc10a67` and verifies. This completes owning
native qualification for [#27](https://github.com/dragginzgame/ic-metrics/issues/27).
The original preparation remains in [adoption-0210.md](adoption-0210.md) and
[adoption-0210-shared022.md](adoption-0210-shared022.md). Arithmetic is unchanged
from the earlier released graph. Consumer runtime/native qualification remains
separate in [#10](https://github.com/dragginzgame/ic-metrics/issues/10).

Subsequent uncommitted 0.2.11 adoption selects a different runner revision;
this release's host evidence does not qualify it. No package metadata, sibling
file, Git history, hosted run or release effect was changed for this observation.
