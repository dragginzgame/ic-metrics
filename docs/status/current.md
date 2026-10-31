# Current handoff — 2026-10-31

The maintainer requested adoption of the new Shared Tooling changelog/Cargo
convention, continuing [#104 — Independent release groups](https://github.com/dragginzgame/ic-observability/issues/104).
The base remains `017d267f959f1885941deabbb4abe571db088c3d` (Release logging
0.23.1), with the earlier peer-layout edits already in the working tree.
The maintainer has now explicitly delegated GitHub delivery and crates.io
publication for both groups at 0.23.2. Source preparation is followed by each
standard patch release and selected publication. Current deployment evidence is
retained under target/audits/deploy-0232-20261031/ and .git/release-state;
completion is established by the recorded results, remote tags and registry.
Sibling checkouts remain untouched.

## Adopted convention

Shared Tooling was refreshed through the canonical exporter from isolated clean
commit `99d04d1b6b7cf4ed060e9b72a139196d32c35954`, verified against remote main.
The snapshot records version 0.27.17; the commit subject says 0.27.18, and the
sibling has an uncommitted VERSION edit. Neither that edit nor a claimed published
0.27.18 is adopted. Only baseline/release documentation changed in the imported
payload; common tool catalogs and helper implementations are unchanged. Impact,
refresh and source receipts are under target/audits/shared-layout-20261031/.

Both packages retain literal version 0.23.1 in their own manifests. The root
Cargo.toml contains shared metadata/catalog/lints/compiler policy and no version.
Metrics' unchanged description remains in its own manifest. Every group owns
its canonical ledger under releases/metrics or releases/logging, matching
[the declared policy](../../ci/cargo-release-groups.json) and root comment map.

[Root CHANGELOG.md](../../CHANGELOG.md) is now an index only. Original coordinated
entries through 0.23.0 moved once to [shared history](../../releases/history.md),
with relative links rebased. Published group 0.23.1 entries retain their release
prose and dates. Former crate-local ledgers are short navigation pointers, with
no duplicated notes. Both canonical ledgers have pending 0.23.2 entries for their
compatible maintainer-flow changes; no numeric bump ran and no runtime API changed.

## Explicit selection and recovery

Release, resume, publication and group metadata commands require an explicit
RELEASE_GROUP=metrics or logging, from the command line or environment. Missing,
empty and unknown groups refuse before setup, Cargo, validation or mutation;
PACKAGE cannot infer a group. Workspace-wide checks and setup need no selection.
[The guide](../independent-releases.md), READMEs and host commands are updated.

The local selection check is reused by Make prerequisites and the metadata CLI.
The shared publication adapter is included directly, with eligibility resolved
only inside selected public targets after admission. This avoids eager Cargo
resolution while unrelated Make targets are parsed. All actual release rendering,
transactions, delivery, publication dispatch and resume stay with existing shared
machinery. No shared helper copy was patched.

The original metrics-0.23.1/logging-0.23.1 journals remain complete, with their
validated/prepared receipts retained under .git/release-state. Recovery remains
bound to the recorded source/policy/file plan, not the migrated worktree layout.
Neither historical journals nor previous failed release evidence were rewritten.

## Focused evidence and limits

Evidence is retained at target/audits/shared-layout-20261031/:

- Snapshot/pin admission, formatting, selected ShellCheck, links and both actual
  pending-ledger checks pass. Full locked/offline Cargo metadata equals the prior
  peer-layout result; dependencies, features and descriptions are unchanged.
- History bodies match their original bytes after reversing only relative-link
  rebasing. Published 0.23.1 entries retain their prose and dates; the final empty
  separator in the moved Metrics ledger is trimmed for Git whitespace admission.
- Cargo package input listing admits both packages, including their README and
  changelog pointers. Canonical ledgers remain repository release material.
- The full release/hook/retention fixture gate passes; final results are in
  release-tools-check-2.log. It exercises real disposable Git/renderer flows for
  both groups, invalid public Make/CLI selection, custody, rollback and resume.
  Setup, broad validation/archive gates and registry uploads remain substituted.
  Successful inputs and receipts remain under
  target/evidence/native-ci/fixture-retention.v65yfi/. The first failed run and
  all earlier receipts remain retained.

No library Rust sources or root lock entries changed. Prior runtime, native Wire,
TypeScript, arithmetic-only Wasm and MSRV evidence retains its original scope;
see [the identity receipt](../evidence/wire-stable-identities-0121/README.md).
The authorized releases run the complete local ci/msrv gates; hosted/macOS and
installed IC qualification remain separate evidence.
The managed editor remains published Build 0.73.0, with Wire 0.12.1 and the same
production graphs. Persistence ownership and Canic #712/#100 follow-ups remain
unchanged. The deployment delegation covers the selected commits, standard
release effects and package publication; no sibling release is included.
