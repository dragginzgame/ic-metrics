# Current handoff — 2026-10-31

The maintainer explicitly delegated GitHub delivery and crates.io publication.
Both independent groups are now released and published at 0.23.2. Source changes
were committed as ecb4ee2, followed by the standard direct release for each group:

| Group | Tag | Release commit | Registry |
| --- | --- | --- | --- |
| metrics | metrics-v0.23.2 | 06020376352355deb068f5d8978813ef5405cedd | [ic-metrics 0.23.2](https://crates.io/crates/ic-metrics/0.23.2) |
| logging | logging-v0.23.2 | 52b14d5cc422daf76a657d2477ca412029295ed3 | [ic-logging 0.23.2](https://crates.io/crates/ic-logging/0.23.2) |

Each branch/tag push was atomic. Both real journals are complete, and the two
Cargo publication receipts report success. Official registry index records
confirm non-yanked versions; downloaded registry archives match those checksums
and identify the exact clean release commits above. A final handoff-only commit
records these outcomes after the tagged releases; it changes no package payload.

## Release layout

Both versions are literal package.version values. Root Cargo.toml has shared
metadata/catalog/lints/compiler policy, with no aggregate version. The canonical
ledgers are under releases/metrics and releases/logging, with dated 0.23.2 entries.
Root CHANGELOG.md is an index; coordinated history through 0.23.0 lives once in
releases/history.md. Former crate-local ledgers are short navigation pointers.
The owning change is [#104 — Independent release groups](https://github.com/dragginzgame/ic-observability/issues/104).

Release, resume, publication and group metadata commands require explicit
RELEASE_GROUP=metrics or logging from the command line/environment. Missing,
empty and unknown selections refuse before setup, Cargo, validation or mutation;
PACKAGE never infers a group. [The guide](../independent-releases.md) records
commands and source-bound recovery. Publication eligibility resolves after
admission through the shared adapter; unrelated Make checks need no group.

Shared Tooling is committed revision 99d04d1b6b7cf4ed060e9b72a139196d32c35954,
snapshot version 0.27.17, adopted via its canonical exporter. The source commit
subject says 0.27.18; the sibling's uncommitted VERSION edit was not adopted.
Common catalogs/helpers and the managed Build 0.73.0 editor selection are unchanged.

## Validation and evidence

Current deployment evidence is under target/audits/deploy-0232-20261031/:

- Metrics full ci/msrv passed (117s/1s); Logging full ci/msrv passed (136s/3s).
  Both standard flows verified prepared package archives before commit/tag/push.
- Each publication passed its native/Wasm Clippy gate and real Cargo dry run,
  then completed its separately selected crates.io upload.
- Registry downloads/checksums/VCS identities and remote refs are recorded in
  registry-verification.txt and remote-after.txt. The authoritative payloads are
  the files ending .registry.crate. artifact-provenance.txt distinguishes an
  earlier local package-check candidate from the actual Metrics registry bytes.
- Successful upload records remain at target/publication/publish.selection.8pz58O
  (Metrics) and target/publication/publish.selection.O8hPBk (Logging).
- Actual journals, validated/prepared receipts and previous failures remain under
  .git/release-state. No evidence, old tags or previous attempts were cleaned.

Earlier focused adoption/peer-layout evidence retains its original scope under
shared-layout-20261031, peer-release-metadata-20261031 and independent-groups-104
in target/audits. History was preserved apart from rebased relative links and the
moved Metrics ledger's final empty separator. Library Rust sources, dependency
selections, encoded contracts and feature boundaries did not change. Only the
selected package versions and corresponding local lock identities advanced.

Hosted native CI is asynchronous; local gate success does not establish a hosted
macOS result or installed IC qualification. No sibling checkout or sibling
release was touched. Persistence adapters retain independent ownership, and
Canic follow-ups #712/#100 remain separate. Future implementation/release work
still needs its normal task authority; no further version bump is pending here.
