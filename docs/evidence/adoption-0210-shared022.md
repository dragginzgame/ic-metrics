# Shared Tooling 0.1.22 release adoption

The clean detached `/tmp/ic-metrics-shared-022-reviewed` selects committed
Shared Tooling `2687f26317952c43c685f7f799ed09288dc10a67` with canonical HTTPS
origin. Review covers the diff from the previously adopted 0.1.20 revision
`3ecc48e579f6cf6e6ab01a6645d8a250fc8c6934`. Later uncommitted upstream changes
are excluded. The [initial contribution adoption](adoption-0210.md) retains
its original source and evidence scope.

The canonical exporter refreshes 70 files, explicitly declaring
`scripts/ci/release-pr.sh` alongside the release runner. The prior 69-file
snapshot verifies before reconciliation; its manifest and complete file archive
are preserved in `target/evidence/adoption-0210-shared022/`. Only verified,
snapshot-owned bytes are reconciled with HEAD for the exporter's dirty-file
admission. Unrelated local edits and the Git index are preserved. The resulting
manifest verifies every selected file's committed source bytes and mode.

This consumer explicitly supports `RELEASE_DELIVERY=direct` only. Make rejects
unsupported inherited or command-line policies before any release dispatch;
the standalone metadata adapter also refuses them before reading or changing
metadata. No merged-checkout adapter or PR release support is claimed. Ordinary
contribution PRs follow the contribution rules. Direct releases retain their
complete gate, recovery, atomic branch/tag push and separate publication.

The consumer fixtures check default and explicit direct dispatch for patch,
minor, major and resume; failure propagation; conflicting selections; unsupported
PR/invalid policy refusal without tool effects; and blocked chained publication.
The native workflow's source receipts now include the updated runner, direct
runner fixture and required PR helper. The upstream sibling LOC path fix is
outside the selected file set; no unused fixture is added.

Qualification is tracked in [#27](https://github.com/dragginzgame/ic-metrics/issues/27).
Focused consumer checks retain logs and selected source hashes under
`target/evidence/adoption-0210-shared022/`. The release-tooling gate passes on
Linux with an enclosing `RELEASE_DELIVERY=pr` selection: its independent
fixtures explicitly select direct delivery, while actual release targets refuse
PR delivery. The same full focused gate also passes with Bash 3.2.57 selected
for its scripts and nested calls. Metadata/admission/failure-retention fixtures run without a product
build or real repository release. ShellCheck and workflow lint pass, as do
`make check-doc-links check-pins shared-tooling-check fmt-check` and
`git diff --check`. Finalized changelog history and Cargo/source/pin files match
HEAD. The source/setup/archive fixture passes with substituted Make effects.
The upstream's [exact-source run 37659875012](https://github.com/dragginzgame/shared-tooling/actions/runs/37659875012)
has passing Linux, Apple Silicon and lint/security jobs; Intel remains running
at inspection. This is separate from consumer qualification. A Linux fixture pass or cancelled older
upstream run does not establish native macOS acceptance of this pending source.

Pending 0.2.10 remains compatible from released 0.2.9. Cargo versions, lock,
arithmetic APIs, allocation behavior, attribution contracts and dependency pins
are unchanged. No release, publication, commit, push, sibling edit or broad
local gate is executed.
