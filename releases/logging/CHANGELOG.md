# Logging changelog

This is the canonical ledger for the independent `logging` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Logging's independent release series begins at 0.23.1. Future Logging notes
belong here.

## [0.23.2] - 2026-10-31

### 🔧 Changed

- Require explicit `RELEASE_GROUP=logging` for release, resume and publication.
  Logging's canonical notes now live in this group ledger under releases/logging;
  the former crate-local path links here. Runtime contracts and the current
  package version are unchanged. See [group commands](../../docs/independent-releases.md).

## [0.23.1] - 2026-10-31

### 🔧 Changed

- Give Logging its independent release and publication selection through
  `RELEASE_GROUP=logging`, preserving its current 0.23.0 identity and runtime
  contract. Metrics versions and pending notes remain untouched by Logging
  releases. See [group commands](../../docs/independent-releases.md) and
  [#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
