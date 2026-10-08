# Corrected Shared Tooling 0.1.27 adoption

The compatible pending 0.2.15 batch starts from released 0.2.14
`dee5ecdef3d811dcda930ddcaae48abf08acc951`. Reviewed committed Shared Tooling is
`db039347d2372b877c1c46dcdd2b5c3aa9412009`, still version 0.1.27. A clean detached
checkout with canonical HTTPS origin supplies the canonical exporter. The existing
75-file selection refreshes without additions/removals. Source worktree changes
for the next upstream batch are excluded.

The selected update anchors relative consumer operands before physical path
resolution and preserves trailing directory newlines. IC pin paths receive the
same treatment. Host/IC installer fixtures declare their evidence-test companion;
that test declares the selector, archiver and action it reads. IC Metrics already
explicitly selected all these inputs in 0.2.14. The baseline, release runner,
consumer workflow and collector policy remain unchanged. No function, method or
type is removed.

Focused Linux Bash 5.2 and genuine Bash 3.2.57 host/IC/Rust installer fixtures and
`make ci-evidence-check` pass against the refreshed consumer. The Bash 3.2 PATH
also selects that interpreter for nested fixture calls. Offline host/Rust checks,
snapshot/pin verification, formatting, documentation links, ShellCheck and
actionlint pass. Repeat canonical refresh verifies all 75 digests and modes.
Explicit incomplete initial exports for each host/IC/evidence fixture refuse
their missing declared companion before creating files or a consumer manifest.
Finalized changelog history compares byte-for-byte with the released history;
Cargo metadata, lock, tool pins and arithmetic sources remain unchanged.
Logs and the original snapshot, changelog
and input hashes are retained under `target/evidence/adoption-0215/`. Installer
downloads, Cargo installation and collector effects are substituted in the
fixtures; no production installation or hosted transport occurs. Native macOS
and exact committed consumer acceptance remain separate in
[#34](https://github.com/dragginzgame/ic-metrics/issues/34).

The preceding exact-source review also passed these installer fixtures and the
upstream retention fixture under Linux Bash 5.2 and genuine Bash 3.2.57, plus
ShellCheck/actionlint. Its private source and logs remain under
`/tmp/ic-metrics-shared-review.fy9EYw/`; this is not consumer native qualification.
The corrected upstream
[CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/37787910279)
passes Linux, including actual compact-evidence upload/download verification;
Intel is in progress and Apple Silicon queued at adoption inspection. The
upstream workflow correction is not a selected consumer workflow change.

The independent active-link defect in
[Shared Tooling #75](https://github.com/dragginzgame/shared-tooling/issues/75)
remains present: a private copy of the pinned host bundle passes offline checking
after its active symlink target gains a trailing newline, even though the active
bin path is absent. Original reproduction logs remain in the private review
directory and were reported upstream. No immutable installer is patched locally.
The release-fixture split and increased CI budgets in
[Shared Tooling #70](https://github.com/dragginzgame/shared-tooling/issues/70) and
[#71](https://github.com/dragginzgame/shared-tooling/issues/71) remain dirty upstream
and are not adopted. No broad local CI/product-test gate, commit, push, release
or publication runs during preparation.

Tag `v0.2.14` resolves to the starting commit. A fresh sparse registry observation
reports non-yanked 0.2.14, no dependencies/features, Rust 1.88 and checksum
`0352d28c75d11f7350184586716aa10b415b6a3da8427186e1768a621546a290`.
The index is retained with this batch's logs; its archive payload was not checked.
The exact 0.2.14 workflow passes Linux/MSRV with macOS queued at inspection;
[#33](https://github.com/dragginzgame/ic-metrics/issues/33) retains that source's
remaining acceptance. Earlier complete 0.2.13 receipts keep their own identity.
