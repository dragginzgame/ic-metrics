# Shared Tooling 0.1.15 adoption for pending 0.2.6

Prepared on published root `d8b3a46f24518a033cd36e40bf1f1895099b809f`
(0.2.5), preserving prior release/consumer documentation edits. The owning issue
is [#16](https://github.com/dragginzgame/ic-metrics/issues/16).

## Source and propagation

Reviewed local/remote upstream main is
`bfb50bd0884b5e6c5ee9592056531c6108f96d73` (0.1.15). A separate clean
detached checkout supplied the canonical distribution helper. Explicit additions
are `make/tools.mk`, the workspace/tooling reporters and their three focused
fixtures. All 63 snapshot files match that commit and declared modes; AGENTS
records the same identity. No snapshot-owned implementation was patched.

The shared include owns existing setup/offline-check targets and new `cloc` and
`cloc-tooling` commands. The consumer removes its copied setup recipes and PATH
selection, retains its default help goal and pin inputs, and exports the include
in release/formatting fixtures. Local tooling qualification includes the three
new fixtures. Native CI provisions the same host set, removes system ripgrep
selection, and records the include/report/fixture source plus tool versions.

Only the reviewed cloc 2.10 payload pin is added. Existing parser, ripgrep,
formatter and IC pins remain unchanged. Cargo versions/lock and all Rust files
remain unchanged. The refreshed rules explicitly preserve IcyDB's approved
layout; no consumer package moves or sibling file edits are needed here.

## Focused evidence

Actual Linux installation through `make install-host-tools` succeeds with the
complete jq/yq/ripgrep-with-PCRE2/cloc set in this checkout's `.tools/host`.
Offline `make host-tools-check` authenticates and verifies it. Actual `make cloc`
uses local prepared tools and locked offline metadata for this workspace, with
no Rust compilation. Its counts are source inventory, not performance evidence.

The first focused pass uses system GNU Bash 5.2.21 and passes
`make host-tools-check local-tools-test release-tools-check hook-check`:
installer failure/retention cases, common Make dispatch/default/failure contracts,
workspace target exclusion, tooling source/data/snapshot classification,
release destination/recovery, consumer publication adapters, metadata rollback,
selected-commit admission, twelve retention scenarios and actual hook/index
preservation. Effects are substituted where needed; no real release runs.

A second identical selected pass under verified GNU Bash 3.2.57 also succeeds,
with its own log and retained failure fixtures. The former
relative Bash shim was absent, so the first pass is not assigned Bash 3.2
portability. The existing executable `/tmp/ic-testkit-bash3257/bash` is verified
and exposed through a new evidence-local shim; identity/checksum is retained.

Selected ShellCheck passes with source following enabled, actionlint passes and
the tooling Perl reporter parses. The initial ShellCheck command omitted source
following and reported SC1091 for the existing pin-file source; its output is
retained alongside the corrected command's passing output. No code warning was
suppressed or vendored file changed to obtain the pass. Initial path inspection
failures and the default-Bash result retain their own scope.

Bare `make` still displays the same help output without installing tools. Actual
`make cloc-tooling` reports the sibling checkout inventory without executing
their tooling or Cargo. Snapshot integrity, direct source/mode equality,
documentation links, dependency declarations and formatting pass. These focused
checks do not constitute a full local CI/test gate.

Logs, original snapshot, clean checkout identity, installation/report output,
Bash identity and selected lint results remain under `target/evidence/adoption-026/`.
Controlled failed retention inputs remain under the owning native evidence tree.

## Native and release boundaries

[Upstream CI 37593142226](https://github.com/dragginzgame/shared-tooling/actions/runs/37593142226)
passes Linux, native Intel macOS, native Apple Silicon macOS and lint/security at
the exact adopted source. This uncommitted consumer batch has no matching hosted
result; #16 remains open for committed consumer/native qualification. Earlier
root 0.2.5 native CI binds its existing wiring, not these new host commands.

The complete compatible tooling batch selects one pending 0.2.6 changelog without
changing Cargo versions or finalized release history. No full local CI/test gate,
Rust edit, dependency upgrade, commit, tag, push, publication, hook activation or
sibling file mutation occurred. No instruction/cycle/Wasm-size improvement is
claimed. The unchanged finalizer still has the whitespace defect tracked in
[#18](https://github.com/dragginzgame/ic-metrics/issues/18); that owner correction
is outside the committed 0.1.15 payload.
