# Shared Tooling selection cleanup

The local compatible 0.2.18 batch starts from released Metrics
`52be29e4bc2433b3d2912a0c09538be993dfb1b2`. A clean detached clone of reviewed
Shared Tooling `3d33cd250fcae7dbe5cabe44b2abd6b2c91a1822` supplies the canonical
refresh. Its selected changes were reviewed against the prior snapshot
`4e274a2219c0b0cc3af68ec65658b373253518fb`; no moving dirty sibling bytes are copied.

For [#38](https://github.com/dragginzgame/ic-metrics/issues/38), the consumer-owned
manifest omits the fleet tooling reporter and its dedicated regression fixture.
The exporter refreshes the remaining 89 files; the deselected files are then
deleted explicitly along with their local fixture scheduling, CI source inventory
and help/documentation references. Local workspace LOC, setup/check commands and
checksum helpers remain. The shared Make include's canonical refusal directs an
unselected fleet report to Shared Tooling; it never invokes a sibling implicitly.

The two removed files contain 405 code LOC according to prepared cloc 2.10
(279 reporter, 126 fixture; comments/blanks excluded). This is redundant snapshot
footprint removed, not independently implemented code or a Wasm/cycle saving.

| Deleted symbol | Former file | Reason and replacement |
| --- | --- | --- |
| `usage` | `scripts/dev/cloc-tooling.pl` | Fleet report and CLI remain maintained centrally in Shared Tooling. |
| `capture` | `scripts/dev/cloc-tooling.pl` | Fleet subprocess helper remains with the central report. |
| `read_file` | `scripts/dev/cloc-tooling.pl` | Fleet file reader remains with the central report. |
| `write_file` | `scripts/dev/cloc-tooling.pl` | Fleet capture writer remains with the central report. |
| `safe_path` | `scripts/dev/cloc-tooling.pl` | Fleet inventory path admission remains with the central report. |
| `is_linked` | `scripts/dev/cloc-tooling.pl` | Fleet symlink exclusion remains with the central report. |
| `in_scope` | `scripts/dev/cloc-tooling.pl` | Fleet inventory selection remains with the central report. |
| `load_snapshot` | `scripts/dev/cloc-tooling.pl` | Fleet snapshot classification remains with the central report. |

The deleted Bash fixture defines no functions or types. No symbols move or rename
within Metrics, and no arithmetic code changes.

The adopted IC installer compares validated complete pin records, allowing
comment/row-order changes without downloads or receipt rewriting. Actual selection
changes still require explicit setup. IC pins and tool versions are unchanged.
The owned CI concurrency groups now preserve every pushed source while allowing
superseded PR runs to cancel, following Shared Tooling's reviewed pattern.

Focused verification passes:

- `make local-tools-test` with Bash 5 and genuine Bash 3.2.57, including nested
  Bash calls: substitute setup/downloads, offline admission, retention, compaction,
  Make command wiring and workspace LOC. These are fixtures, not native IC tools.
- Actual `make cloc` using prepared cloc, and expected local `make cloc-tooling`
  refusal with the central-owner explanation.
- `make shared-tooling-check check-pins`, ShellCheck on the three changed shell
  scripts, workflow actionlint, documentation links and `git diff --check`.

Logs and the original snapshot/counts are retained under
`target/evidence/tooling-0218/`. This local batch is not committed native
qualification. At review, the selected Shared Tooling
[CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37900620129)
passes Linux and lint, with both macOS jobs still running. The changed consumer
callers need their own exact-source native CI after delivery; #38 retains that
acceptance. No full local CI, release or sibling mutation runs.

The pre-existing `Cargo.lock` update to IC Host 0.8.8 remains byte-for-byte intact;
it is an independent dependency qualification, not evidence established by these
tooling checks. Workspace and package versions remain 0.2.17.
