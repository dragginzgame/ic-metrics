# Current handoff — 2026-10-30

## Optional native metadata

PR #102 is refreshed onto release 0.21.0. Pending notes select 0.22.0 because
native schema callers disabling defaults must now select `native-wire`.
Default consumers retain native metadata. Arithmetic and canonical Serde
transport remain unconditional; Wasm excludes Wire even with all features.
Recording is independent and Logging stays dependency-free. No arithmetic,
rounding, errors, encoded fields or retained layouts change.

The existing PR's three native CI jobs passed, but its MSRV job failed because
the offline check lacked autocfg in its cache. Prepare application sources
explicitly before that check, matching the native CI lane.

Current validation is recorded in the PR. Historical Wire adoption evidence is
retained in release 0.21.0's handoff and linked receipts. The migration is in
[the 0.22 guide](../migration-022.md). Own versions, tool pins and Cargo.lock
remain unchanged from main; no publication, deployment or normal sibling edit
is included.

[Tooling #268](https://github.com/dragginzgame/ic-tooling/issues/268) owns adoption
after this supplier profile is integrated and released. Schema consumers with
defaults disabled must select native-wire when adopting.
