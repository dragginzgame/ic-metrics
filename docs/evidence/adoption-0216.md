# Shared Tooling source admission adoption

The compatible pending 0.2.16 batch starts from released
`287251eb51412852a58cabd9de5b3c28e207e705`. Its canonical 91-file snapshot selects
reviewed committed Shared Tooling
`4e274a2219c0b0cc3af68ec65658b373253518fb`, exported from a clean detached clone
with the canonical HTTPS origin. The initial export selected 0.1.29
`1a54fb625d6e47efa64c4384808ecbc87be84e7e`. The subsequent committed assessment
batch changes only two selected documentation files; its new upstream workflow
and script are reviewed but not copied or run here. The selected commit still
records VERSION 0.1.29 and pending 0.1.30 notes; newer dirty version preparation
is excluded. The sole additional selected file is the shared release-source
checker.

The consumer removes `admit_files()` from `scripts/release/metadata.sh` and delegates
source admission to `scripts/ci/check-release-source.sh`. The consumer still owns
the exact Cargo.toml/Cargo.lock/CHANGELOG.md exceptions and release phase. All
staged, unstaged and untracked blockers are reported with literal path quoting;
failed Git observation refuses before validation or version preparation. Consumer
fixtures prove hidden staged content, multiple blockers, newline names, allowed
lock-only work and index/file preservation. Late selected-commit workspace checks
retain the 0.2.15 full-tree export and producer-failure contract. This adopts
[Shared Tooling #74](https://github.com/dragginzgame/shared-tooling/issues/74).

Native source receipts include the new source checker. No background agent,
maintenance coordinator or service is enabled.

The canonical snapshot also updates PocketIC executable pins to 16.1.0 with
reviewed official asset digests under
[Shared Tooling #76](https://github.com/dragginzgame/shared-tooling/issues/76).
Unlike Cargo metadata, `ci/ic-tools.tsv` is snapshot-owned and advances with the
selected source. Existing locally installed 16.0.0 executables are not evidence
for this new selection; adoption does not silently run installation. The future
configured native job explicitly provisions and checks the selected tools.
Optional upstream Node/npm checks remain opt-in; this Rust consumer adds no
frontend or Node requirement. Standing issue-action rules now explicitly scope
their automatic authority to `dragginzgame` repositories.

Focused Linux Bash 5.2 and genuine Bash 3.2.57 consumer admission/metadata
and upstream-owned source fixtures pass. Nested Bash calls use the
selected interpreter. Snapshot, dependency-pin fixtures/declarations, native
evidence/archive fixtures, ShellCheck and workflow lint pass. Downloads, Cargo-edit
and release gates in these fixtures are substituted; they are not IC runtime or
completed hosted native acceptance. Cargo.toml, Cargo.lock and host/Rust tool
selection bytes match pre-adoption hashes, and finalized changelog history stays
unchanged. Logs and source selection are retained under
`target/evidence/adoption-0216/`.

The complete focused `make release-tools-check` gate passes under Bash 5.2,
including updated simulation, all 19 disposable real-Git tracking cases and the
consumer admission/metadata/retention fixtures. The final 91-file selection is
refreshed through the canonical exporter and verified again,
with focused native-evidence and documentation checks covering the narrowed wiring.

The exact upstream
[0.1.29 run](https://github.com/dragginzgame/shared-tooling/actions/runs/37806453080)
passes Linux and lint/security; its queued macOS jobs were later cancelled when
the newer source was pushed. The latest selected-source
[workflow](https://github.com/dragginzgame/shared-tooling/actions/runs/37809818114)
is queued at inspection. The new assessment is manually triggered upstream,
leaving this consumer's existing installer and focused gates unchanged.
[#37](https://github.com/dragginzgame/ic-metrics/issues/37) owns this new batch's
committed native/downloaded-receipt acceptance separately from released 0.2.15
issues. Arithmetic APIs, no_std/dependency-free ownership, package versions and
the locked Cargo graph were unchanged by snapshot adoption. The later maintainer
IC Host 0.8.4 lock selection is separately qualified in
[the dependency review](host-dependencies-0216.md) and belongs to the same pending
consumer-native acceptance, rather than these original snapshot input hashes.
No sibling edits, package version changes,
commits, pushes, publication or release command ran.
