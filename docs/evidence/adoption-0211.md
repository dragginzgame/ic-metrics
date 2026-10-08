# Shared Tooling 0.1.23 release-integrity adoption

The clean detached `/tmp/ic-metrics-shared-023-reviewed` selects committed
Shared Tooling `0ba0ad00ed94848e54ecc82629b6b7873b7284c0` with canonical HTTPS
origin. Review covers the seven-file upstream diff from 0.1.22, including the
release runner, required helper, regression fixtures and release contract.
The canonical exporter refreshes the existing 70-file selection. No private
snapshot patch, implicit file-set expansion or sibling mutation is used.

Direct releases now inspect the Git index separately from working files and
recheck the committed payload and exact annotated tag after `release-push-check`.
Completed recovery confirms the local annotated tag, exact remote tag object
and release ancestry in the observed branch. A known descendant remains valid;
missing/conflicting identities or unavailable observations stop completion
without recreating a tag or replaying a push. Earlier intent/evidence is retained.
These fixes adopt [Shared Tooling #58](https://github.com/dragginzgame/shared-tooling/issues/58).

The required PR helper also receives upstream's portable paginated GitHub lookup
correction. This consumer still refuses PR release delivery before dispatch.
No PR adapter, merged-checkout qualification or live PR release is claimed.
Existing consumer metadata/receipt guards retain their canonical owner; the
runner supplies the corrected pre-push and completed-state boundaries.

`make release-tools-check RELEASE_DELIVERY=pr` passes under Linux Bash 5 and
with genuine Bash 3.2.57 selected on PATH. Independent fixtures explicitly own
direct delivery. Updated upstream regressions exercise post-hook tag target,
annotation, index and working-tree conflicts; completed local/remote identity
refusals; no-effect retries; and valid descendant history. Actual consumer
metadata preparation/restoration, selected-commit admission, Make publication
separation and failure retention fixtures pass on the selected bytes.
ShellCheck and workflow lint pass. Logs, the refresh receipt and selected source
hashes are retained under `target/evidence/adoption-0211/`.
`make check-doc-links check-pins shared-tooling-check fmt-check` and
`git diff --check` pass. The published changelog history remains byte-identical
after removing the sole pending 0.2.11 entry; Cargo manifests, lock, Rust source
and consumer pin files remain unchanged from released HEAD.

[Exact upstream run 37746567888](https://github.com/dragginzgame/shared-tooling/actions/runs/37746567888)
passes Linux, macOS Intel, macOS Apple Silicon and lint/security. It does not
qualify this uncommitted consumer source; [#28](https://github.com/dragginzgame/ic-metrics/issues/28)
retains its committed native acceptance. Released 0.2.10's separate
[record](release-0210.md) retains its own runner and host identities.

Pending 0.2.11 is compatible from released 0.2.10: it repairs release-integrity
checks without changing arithmetic APIs, units, attribution or consumer storage.
The package/workspace/lock remain 0.2.10, with no pin or dependency change.
No Rust edit, product build, broad local gate, real release, publication, commit,
push, sibling edit, cleanup or history rewrite is executed for adoption.
