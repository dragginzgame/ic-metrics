# Logging changelog

This is the canonical ledger for the independent `logging` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[root historical ledger](../../CHANGELOG.md#0230---2026-10-31).
The version remains 0.23.0 when adopting groups; no new Logging release is
created by this change. Future Logging notes belong here.

## [0.23.1] - 2026-10-31

### 🔧 Changed

- Give Logging its independent release and publication selection through
  `RELEASE_GROUP=logging`, preserving its current 0.23.0 identity and runtime
  contract. Metrics versions and pending notes remain untouched by Logging
  releases. See [group commands](../../docs/independent-releases.md) and
  [#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
