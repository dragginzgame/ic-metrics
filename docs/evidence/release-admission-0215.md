# Multi-member release admission correction

The maintainer's CI gate stopped at `scripts/release/test-release-admission.sh`:
Cargo could not find `crates/ic-metrics/Cargo.toml` beneath its temporary root.
The retained gate log is
`.git/release-state/validation-failures/20261008T154520Z-395966-0-ci.log`; the
reported fixture is `/tmp/metrics-release-admission.GFWRdl`. A focused rerun on
local HEAD `30fa5dc9ebc5438ae1a58383d3eb642dcb27cdb5` reproduces the same failure.
That HEAD includes both arithmetic and the private host workspace package.

The fixture had copied only committed `Cargo.toml` before calling the canonical
workspace-version reader. That reader uses real offline Cargo manifest validation,
which needs member manifests and targets. The production late-check adapter also
exported only the three release metadata files and had the same incomplete-input
problem. Earlier passing fixture evidence selected a single-member HEAD; it did
not qualify this later two-member input.

Both current-repository paths now use Git's archive exporter for the selected
commit's `crates/` tree alongside their required root metadata. The version reader
and snapshot are unchanged. Late checks remain bound to `RELEASE_COMMIT`; they do
not borrow member files or resolve dependencies from a newer HEAD. There is no
production compilation, metadata mutation or release effect in the export.
Pipeline failure propagation is preserved: the existing producer-failure fixture
now has Git emit a valid archive and then return status 43, which is rejected while
retaining the selected inputs. A successful check cleans only its temporary copy.
No function, method or type is removed.

After the correction, actual focused Linux qualification passes:

- ShellCheck with source following for the consumer metadata/admission scripts.
- `make release-tools-check`: formatter prerequisites, release simulation, all
  19 isolated real-Git tracking cases, publication adapter, metadata, admission
  and fixture-retention checks. Release/Make effects remain substituted; Git
  writes are restricted to disposable fixture repositories.
- Genuine Bash 3.2.57 admission and metadata fixtures, including that interpreter
  on PATH for nested calls, selected-commit identity, failed producers and evidence
  retention. Bash 5.2 passes separately.
- Snapshot/pin verification, documentation links and whitespace checks.

The new reproduction and logs remain under
`target/evidence/release-admission-multi-member/`. This is a compatible extension
of pending 0.2.15 for [#36](https://github.com/dragginzgame/ic-metrics/issues/36),
whose exact committed native qualification remains separate. Existing prepared
snapshot work and the unrelated dirty IC Host 0.8.2 lock selection are preserved;
this fix changes no Cargo graph or package version. No full local CI/release gate,
commit, push, publication, artifact cleanup or sibling edit ran. The maintainer
can retry the normal release target after committing the pending source changes.
