# Shared Tooling 0.1.27 preparation

The compatible pending 0.2.14 batch starts from released 0.2.13
`4091366bcd97ddf4f31d5993c954f6f4a269bc63`. Reviewed Shared Tooling is committed
0.1.27 `b866d41041a1986eeec95bde9af4c6ba0853d2e3`. A clean detached checkout
with canonical HTTPS origin supplied the canonical refresh. Earlier dirty
publication documents were preserved; no sibling working files were copied.

The existing 72-file selection expands explicitly to 75 by adding the tool
evidence selector, installer evidence fixture and composite action read by that
fixture. Existing host/IC fixtures now invoke it unconditionally. Missing direct
upstream companion declarations are tracked in
[Shared Tooling #73](https://github.com/dragginzgame/shared-tooling/issues/73);
the complete local selection supplies all required files. The action remains a
fixture input, while the consumer's native collector retains its source/outcome,
candidate and outer Git-recovery-state policy. Its source list includes the three
new inputs. Repeat canonical refresh verifies every selected digest and mode.

The entry-point changes anchor a script operand before physical directory
resolution, appending a non-newline suffix so command substitution preserves
literal pathname bytes. Before correction, inherited CDPATH caused the actual
consumer adapter's read-only version request to return 127 with a two-line
helper path. The correction returns the exact current 0.2.13 version. The same
bounded root change applies to the consumer-owned release, hook and native
evidence fixtures. The metadata fixture now invokes the actual adapter by
relative and absolute paths from a newline-ending checkout and verifies manifest
bytes remain unchanged. No function, method or type is removed.

Focused checks pass under Linux Bash 5.2 with inherited CDPATH: release runner,
metadata/admission/retention, formatting hook, native evidence and local-tool
fixtures, including the newly selected collector body. Bash 3.2.57 also passes
selected standard-release/metadata, native-evidence and host/IC fixture checks.
Both shells pass the reviewed upstream relative/absolute/newline bootstrap and
inherited Make/logger isolation fixtures. Installer/download/Cargo-edit and
registry effects in these tests are substituted; Git work stays in disposable
fixtures. This is neither native macOS nor live release qualification.

ShellCheck with source following, actionlint, pins, formatting and snapshot
verification pass. The initial broad ShellCheck invocation omitted source
following and stopped at SC1091 for the declared pin-file source; correcting the
invocation passes without a source suppression. Logs and failed-before evidence
are retained under `target/evidence/adoption-0214/`. Finalized release history,
Cargo/package/lock identities, Rust arithmetic and tool/dependency pins remain
unchanged. No product compilation, broad local CI, commit, push, release or
package publication is part of preparation.

[Exact upstream CI 37778118837](https://github.com/dragginzgame/shared-tooling/actions/runs/37778118837)
passes lint but fails Linux's final compact-evidence oracle: it compares a stale
portable-regression log rather than the selected installation/check logs.
The owning dirty correction is already recorded in
[Shared Tooling #66](https://github.com/dragginzgame/shared-tooling/issues/66).
The source's actual earlier upload/download and portable tests remain distinct
from that failed oracle and from queued native macOS. No dirty correction is
adopted. [#33](https://github.com/dragginzgame/ic-metrics/issues/33) retains this
new batch's committed native/downloading acceptance. The complete 0.2.13 matrix
and receipts retain their original identities.
