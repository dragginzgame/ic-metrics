# Shared Tooling 0.6.5 adoption in pending 0.7.1

The consumer starts from clean released 0.7.0
`384046884365e3d73696e0813a43640d3b1f2cb4`. Shared Tooling's committed/public
initial 0.6.4 source is `6fc8eb9a94f83fb0b9d0a26377d4232508cdbe2d`; its
[own CI](https://github.com/dragginzgame/shared-tooling/actions/runs/38155574308)
passes. A clean detached copy of that exact source excludes subsequent dirty
hook/validation/installer work. Canonical preview and refresh preserve all 97
selections, update nine existing files, and explicitly add `make/consumer.mk`,
its interface documentation and the common Make fixture. All 100 selections
verify against the snapshot. The initial moving checkout's clean-source refusal
does not authorize adopting its uncommitted files. The final canonical refresh
uses a separate clean detached copy of committed/public 0.6.5
`42f2091768b5f71c98a684d3dab563f408ca2dd9`, updating eight selected files.
All 100 selections verify against that exact final revision.

The root Makefile pins `SHARED_TOOLING_ROOT` to the current checkout and delegates
common targets to `make/consumer.mk`. Equivalent local hook/snapshot-check recipes
are replaced by that owner. Product validation/publication adapters, release
metadata and direct-only delivery admission remain local. Target-specific
`IC_METRICS_RELEASE_CACHE_PREPARE` survives the route. All three compiler-floor
groups and both public package publication selections are retained.

The 0.6.5 hook supplies an exact physical export context for borrowing prepared
Rust-tool receipts during read-only checks; the actual consumer hook fixture
passes without installing in the export. Release validation declares `Cargo.toml`
and `Cargo.lock` to the canonical runner's input checkpoint. A consumer fixture
changes the lock during the first substituted gate and proves later floor gates
never run; initial/after input hashes and the target log remain retained. The
first assertion used the wrong checkpoint filename and failed; its scratch and
log are preserved alongside the corrected passing run. Logger scratch exports
now include the selected checksum helper required by the runner.

Release/hook scratch exports include the common entrypoint and its parsed modules;
native source collection records those inputs and the newly selected fixture.
Focused checks pass for snapshot integrity, actual workspace formatting, staged
hook preservation, common Make routing, substitute release/publication effects,
release admission and failure evidence. Shared's deliberate failure tests are
not actual releases or installations. Full Linux `make ci` passes in 298 seconds
through the canonical runner, followed by all three package-floor gates. This
includes warning-denied native/Wasm Clippy, 44 core tests/seven doctests, nine
stable-adapter tests/one doctest and the actual inspector CLI test. The declared
Cargo inputs retain their initial hashes through all four gates; manifest, lock,
snapshot and both executable pin catalogs also verify against pre-gate hashes.
The corrected release-admission and common Make fixtures separately pass genuine
Bash 3.2.57 with GNU Make 4.3 on Linux, including nested shell selection. These
checks do not establish native macOS acceptance of the new adoption.

Published Host 0.14.2 (`fed8724e79862d8273d01823619fe648c981c019`) changes
tooling/documentation, with byte-identical consumed artifacts/filesystem source
to 0.14.1. Released Metrics 0.7.0 already selects Host 0.14.2, and those rows stay
unchanged. During review IC Memory 0.35.13 becomes published at
`bd3aee0e5d8c86c70a4c5b92bd5652c053881359`; the working lock now selects it.
That incoming row is preserved and qualified separately from snapshot adoption.
Its non-yanked official archive verifies as
`f67fc6ab8d76c899d4de40be562a4c51589df3f8e9b7b2c4a52c9c6cb8b9115c`, embeds
the stated commit and retains Rust 1.88. Every library source is byte-identical
to released 0.35.12. All other lock rows remain unchanged; manifest requirements,
arithmetic dependencies, stored layout and exposed collection identity stay the same.

The README now describes the published 0.7 contract and its separate durable
adapter. Its dependency example selects 0.7 with valid TOML quoting. These are
compatible documentation/contributor-command changes, so pending notes select
0.7.1 while real workspace metadata remains 0.7.0. This work performs no staging,
commit, tag, push, release, package publication or sibling edit.

The current [#61](https://github.com/dragginzgame/ic-metrics/issues/61) follow-up
owns common-entrypoint adoption/acceptance. Its original Shared 0.6 macOS
obligations are now independently satisfied at released 0.6.6: API-digested ZIPs
`11708426343` (Intel) and `11708424068` (Apple Silicon) verify their inner archive
hashes, all 75 exact-source hashes, 14 payload hashes, host/run identity and seven
successful outcomes. The [0.6.6 supplemental record](release-066.md#complete-native-acceptance)
retains those bindings. They do not qualify the newer entrypoint or 0.7 API cut.

Canic's newly successful run at its unchanged public HEAD is the dependency-audit
workflow, not the missing runtime/native evidence in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10). No consumer acceptance
is inferred from it. Preview/refresh/focused logs, clean source and receipt review
are retained under `target/evidence/adoption-071` and
`target/evidence/release-066-native`.
