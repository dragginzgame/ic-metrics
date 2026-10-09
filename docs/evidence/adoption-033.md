# Shared Tooling 0.2.5 adoption

Pending compatible Metrics 0.3.3 adopts reviewed published Shared Tooling
`04e07b4bf54e7aeb03eb7804a845cee27b7305df` from a clean detached clone through
its canonical distribution helper. The source remote matches the snapshot's
canonical HTTPS identity. All 89 selected files match the source bytes/modes;
the selection is unchanged and every declared companion is present.

The hook and installer preserve literal newline-ending Git paths and checkout
roots, remove only Git's record terminator and retain failed Git observation
statuses ([Shared #89](https://github.com/dragginzgame/shared-tooling/issues/89)).
Local/global hook selections remain protected; setup stays explicit. The included
0.2.4 companion declarations strengthen fixture export admission without adding
optional owner suites or changing product ownership. No function, method or type
is removed. Arithmetic APIs, consumer data and private inspector behavior remain
unchanged; Cargo metadata/lock and tool pins are preserved.

Linux checks pass with prepared tools:

- Canonical snapshot refresh/verification and declaration pin checks.
- Upstream `test-git-hooks.sh` from the clean source, with Bash 5 and genuine
  Bash 3.2.57 selected for nested calls. Its formatter substitutions retain their
  declared scope; newline selections/root execution and Git read failure cases
  are included.
- The existing consumer formatting adapter with real Cargo formatting, under
  Bash 5 and 3.2, including partial staging, formatter failure and unrelated-edit
  preservation.
- Separate disposable newline-root consumer checks with real setup/idempotence,
  Cargo formatting, selected-file refresh, unrelated README/lock preservation and
  literal conflicting hook-path refusal with unchanged config.
- Selected ShellCheck, documentation links and whitespace checks.

The last checks use Metrics release `f903c664c395c47485dbedc0f1919c97b9ce72d0`
with byte-identical new hook/installer overlays in disposable clones. They do not
activate hooks or stage files in the live checkout. Inputs, commands, source
hashes and logs remain under `target/evidence/adoption-033/`. Failed consumer
adapter scratch is retained at its logged `/tmp/metrics-format-hook.*` paths.

The production hook works in those newline-root fixtures, but the unchanged
shared `check-formatting-hooks.sh` strips the consumer root's trailing newline
at its initial physical-path capture and exits 2 during file admission. Both
Bash versions reproduce the distinct qualification limitation; the ordinary
consumer adapter passes. [Shared #90](https://github.com/dragginzgame/shared-tooling/issues/90)
owns that repair. The immutable helper is not patched here, and the failed runs
are not counted as passing qualification.

Read-only hook caller review covers IcyDB, Canic, IC Timers, IC Backup, Blob and
Toko at the local source identities recorded in `downstream-hook-review.jsonl`.
They retain their own setup/adapters and snapshot adoption; no arithmetic,
attribution, persistence or endpoint contract changes are propagated. This
inspection establishes neither their publication nor native qualification.

[Selected upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37937705371)
passes Linux portable regression and lint/security; both macOS jobs are queued
at observation. [Metrics #43](https://github.com/dragginzgame/ic-metrics/issues/43)
retains delivery and exact-source native acceptance. Bash 3.2 on Linux and
upstream CI do not replace supported native consumer evidence. No Rust source
edit, compilation, broad local CI, dependency resolution, package version change,
commit, push, release, publication or artifact cleanup occurs during adoption.

## Continuation: failure retention

The focused `scripts/release/test-fixture-retention.sh` also passes on Linux Bash
5 and genuine Bash 3.2.57 after adoption. It exercises successful scratch cleanup
and injected child/assertion/formatter-observation failures across the real
consumer release, metadata and formatting adapters, with the declared command
substitutions. Failure statuses and reported inputs/logs survive as required.
Evidence is retained under `target/evidence/native-ci/fixture-retention.4gZGwH`
and `fixture-retention.1WjPWU`; logs and checked input hashes are under this
adoption's `continuation/` directory. Production inputs are unchanged by these
checks. No additional implementation or release-note bullet is introduced for
routine validation.

The continuation also reviews published Host 0.9.3 source
`545e7236b91d84e190c80931b784f72cc4fafb11`. Both registry packages are non-yanked
with Rust 1.88. Library source is unchanged from 0.9.2; the upstream release
adopts the same hook fix. Metrics retains its selected 0.9.2 graph without a
dependency update or claim of 0.9.3 binary qualification.

## Continuation: shared Make includes

The prepared snapshot advances to published Shared Tooling 0.2.6
`ce13a5314916891fd239d9b199b4a91b04775054` through a clean detached clone and
the canonical exporter. It explicitly adds `make/release.mk` and
`make/rust-format.mk`; all 91 selected files verify. The dirty sibling checkout's
later edits are excluded. Optional owner fixture suites remain unselected.

The includes replace the local standard-release recipes, defaults and
conflicting-goal guard, plus `format-tools-check`, `fmt` and `fmt-check` recipes.
All target names remain available. Direct-only policy admission, metadata and
validation adapters, publication and explicit installation remain local.
All four standard release entrypoints export the existing cache-preparation
selection; release-verify still removes it and selects offline validation.
The formatter uses the reviewed pin and prepared tools offline without automatic
Rustup installation. Consumer scratch exports and CI source receipts include
the new files. No function, method or type is deleted.

Focused Linux Bash 5 and genuine Bash 3.2.57 checks pass:

- Standard entrypoints, exact arguments and destinations, resume selection,
  conflicting-goal/direct-policy rejection, cache propagation and failure
  propagation. Runner/publication effects are substituted.
- Release admission, real scratch Git/offline-fetch behavior, selected-commit
  metadata and validation-log retention with other Cargo/gate effects substituted.
- Actual non-mutating Cargo formatting and consumer hook qualification, including
  partial-stage refusal, index refresh, formatter failure and unrelated-edit
  preservation. Live hook configuration and staging are untouched.
- Actual production hook installation and formatting in disposable newline-ending
  checkout roots using the newly included Makefiles, under both Bash versions.
  Literal conflicting paths are refused without config changes. The separate
  qualification adapter still returns 2 for those roots, reproducing Shared #90.
- Shared formatting fixture with declared Cargo substitutions, including prepared
  local PATH lookup, missing/wrong formatter and sorter-failure isolation.
- Consumer failure-retention fixtures. Bash 5 evidence is under
  `target/evidence/native-ci/fixture-retention.qQmP5W`; Bash 3.2 uses
  `fixture-retention.kvYs8n`.
- Snapshot/pin verification, ShellCheck with source following and workflow lint.
  The initial ShellCheck invocation omitted `-x` and reported SC1091; its log is
  retained separately from the passing source-following invocation.

Inputs and logs are under `target/evidence/adoption-033/make-includes/`.
The independently incoming Host lock selection and its concurrent change have a
[separate review](host-dependencies-094.md); initial preserved hashes are not
misrepresented as proving an unchanged lock. Arithmetic source, manifests and
tool pins remain preserved. No broad CI, release or package version change runs.

[Shared 0.2.6 CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37944389294)
passes Linux portable regression and lint/security at inspection; both macOS
jobs are queued. This does not qualify the dirty consumer batch on native macOS.
[#44](https://github.com/dragginzgame/ic-metrics/issues/44) owns delivery and native
acceptance of the includes; #43 retains hook-fix acceptance. Shared #90 remains
open and its newline-root qualification limitation is not counted as a pass.
