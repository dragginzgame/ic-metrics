# Metrics changelog

This is the canonical ledger for the independent `metrics` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Metrics and Logging each own their package version and release notes.

## [0.23.2]

### 🔧 Changed

- Adopt the shared peer-group release layout: Metrics owns its literal version
  and this ledger; the workspace root holds common metadata and navigation.
  Release, resume and publication require explicit `RELEASE_GROUP=metrics`.
  Coordinated history is preserved separately. Package versions and runtime
  contracts are unchanged. See [group commands](../../docs/independent-releases.md).

## [0.23.1] - 2026-10-31

### 🔧 Changed

- Release Metrics and Logging independently in one workspace. Select
  `RELEASE_GROUP=metrics` (default) or `logging` for release, resume and
  publication. Existing numeric versions remain 0.23.0; arithmetic, log behavior
  and dependency boundaries are unchanged. See [group ownership and commands](../../docs/independent-releases.md)
  and [#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
- Adopt the committed Shared Tooling group machinery and published IC Build
  0.73.0 metadata editor through managed setup; prepare the new editor before
  using the group commands.
