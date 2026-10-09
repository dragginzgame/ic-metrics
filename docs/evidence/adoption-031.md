# Shared Tooling installer fixes

Pending compatible 0.3.1 adopts committed Shared Tooling
`ee48bb37c98c771e77b92fd891f0757d8c1c8b99` through the canonical exporter from a
clean detached checkout, retaining all 89 selected files. Every selected byte
matches that reviewed source. Package versions remain 0.3.0; Cargo requirements,
lock selection, IC tool pins and frozen histogram archive are unchanged.

The IC installer consumes the final validated row without a trailing newline
([Shared #87](https://github.com/dragginzgame/shared-tooling/issues/87)). The common
CI installer uses exact-path atomic publication, preserving a late destination
directory and failed candidate, and replacing a late symlink without modifying
its target ([Shared #88](https://github.com/dragginzgame/shared-tooling/issues/88)).
The existing CI yq caller uses this helper; its version, checksum and dispatch
remain unchanged. Perl is now admitted before setup begins.

Focused Linux checks pass on Bash 5 and genuine Bash 3.2.57: consumer IC installer
fixtures, and the reviewed upstream CI installer fixture against the identical
helper/checksum/yq-entrypoint bytes. The latter also exercises upstream-only
entrypoints; it does not add those entrypoints or tests to this snapshot.
Snapshot/pin verification, actual offline IC admission, ShellCheck and maintained
documentation links pass. Downloads/native-host selection in the installer
fixtures are substituted; these checks are not native macOS execution.

Logs, source comparisons and preserved-input hashes remain under
`target/evidence/adoption-031/`. Selected upstream
[CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37918955655)
passes Linux and lint/security; both macOS lanes remain queued at inspection.
[#42](https://github.com/dragginzgame/ic-metrics/issues/42) tracks delivery and
changed-caller native acceptance. No functions, methods or types are removed.
No Rust source, arithmetic API, dependency selection or package version changes;
no broad local gate, commit or release occurs in this batch.
