# Published 0.2.12 observation

On 2026-10-08, published ic-metrics 0.2.12 source is
`d16aa0aeb0e0f4fcbbc6962ba3f86c7348ecff88`. The annotated `v0.2.12` tag selects
that commit. The official sparse registry index reports a non-yanked package
with no dependencies/features and Rust 1.88. The independently downloaded crate
matches SHA-256
`7bab1fc806066a00dfd5984bbe6dcb74e836a51e8e4fb2f29026739216c5fa56`.
Embedded Git identity, all five Rust files, application guide, original manifest,
lock, README and license match released source.

[Exact CI run 37773131075](https://github.com/dragginzgame/ic-metrics/actions/runs/37773131075)
passes MSRV and Linux native. Linux was running at the initial observation;
its subsequently downloaded archive verifies the outer/payload checksums, source
hashes against the release commit, run/attempt/host and successful setup/native
outcomes. Source receipts include both new shared archive files; the native log
records the actual collector fixture and corrected tracking cases passing.
Both macOS lanes were initially queued and later cancelled with the run after
the newer release was pushed. Their native outcomes/download verification remain
pending in [#31](https://github.com/dragginzgame/ic-metrics/issues/31) and
[#30](https://github.com/dragginzgame/ic-metrics/issues/30). Registry publication
and local focused preparation do not supply those missing gates. Downloads are
originally retained under `target/evidence/release-0212/`. The
[0.2.13 record](release-0213.md) binds the subsequent source and downloads
independently; it does not relabel this release's evidence.

The released 72-file snapshot selects Shared Tooling 0.1.25
`672ab4b8af50c75ed21a359ca5968682de83be94`. Its corrected runner, tooling LOC
and tool-candidate archiver preparation remains bound to
[adoption-0212.md](adoption-0212.md). The outer archive retains Git recovery
state rather than applying the tool-candidate helper's Git exclusion. Actual
consumer native execution and downloaded round trips remain distinct from
the helper's substitute/isolated Git fixtures and older release qualification.

Root arithmetic is unchanged. Owning consumer acceptance remains separate in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10). No package/dependency
version, Git history, sibling source or hosted workflow was changed by this
publication check.
