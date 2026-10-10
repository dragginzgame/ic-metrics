# Shared Tooling 0.2.11 Make admission repair

Pending compatible Metrics 0.3.7 refreshes the unchanged 93-file selection from
the initial [0.2.10 formatting adoption](adoption-037.md) to committed Shared
0.2.11 `83efac446348dea024798a331d77933b24b429dc`. The canonical exporter ran
from a clean detached clone with the canonical HTTPS origin. The revision's
immutable VERSION is 0.2.11; its commit subject does not establish that identity.
No snapshot-owned file was hand-edited.

The shared owner fixes [#30](https://github.com/dragginzgame/shared-tooling/issues/30):
independently qualify Make's flag channels using GNU Make itself, and refuse
command-line/Makefile assignments that erase generated `MFLAGS`. This prevents
`make -i release-patch MAKEFLAGS=` from reporting success after ignored failure.
The earlier failed observations retain their source identities; this new result
does not relabel released 0.3.5/0.3.6 or their admission evidence.

The existing Metrics release-adapter fixture now exercises the actual consumer
Makefile and canonical guard with release, formatter and Cargo effects substituted.
It tests patch/minor/major/resume, fmt/fmt-check and publish/publish-check against
ignore-errors, dry-run aliases, touch, query aliases and combined flags, including
inherited flags, cleared/replaced `MAKEFLAGS`, both hidden channels and Makefile
`MFLAGS` assignments. Every unsafe case returns 2 without dispatch. Positive
parallel cases with safe replacement flags and a quoted ordinary selection reach
the substitute runner with the correct arguments. Existing failure propagation,
cache selection, root routing, policy and chained-publication refusal remain covered.

Focused checks pass on Linux GNU Make 4.3/Bash 5 and GNU Make 3.81/Bash 3.2.57:
the expanded consumer release fixture, canonical release/format/logger fixtures,
actual consumer hooks and release admission, native-evidence collection and fixture
retention. ShellCheck passes for the changed consumer fixture and canonical probe.
Actual prepared check-only formatting and canonical distribution checks pass.
The native collector still verifies failed reporter stdout/stderr recovery and
status 43 through the actual archive bodies with substituted effects.
Final snapshot, dependency-pin and offline host/Rust tool checks pass; the local
link checker verifies 411 references across 129 maintained documents and the
additional package documents. Diff checks and manifest/lock/tool-pin preservation
hashes pass. Actual final `make fmt-check` reports `Checking formatting... ok`.

[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/38034912323)
passes Linux, Intel macOS, Apple Silicon macOS and lint/security at this revision.
This is new upstream evidence, separate from initial 0.2.10's Intel download
failure. Local Bash 3.2/GNU Make 3.81 does not qualify Metrics' changed-source
native jobs. [Metrics #44](https://github.com/dragginzgame/ic-metrics/issues/44)
retains delivery and that acceptance, including the formatting reporter adaptation
for [Shared #92](https://github.com/dragginzgame/shared-tooling/issues/92).

Inputs/logs are under `target/evidence/adoption-037-make/`. Arithmetic and inspector
production sources, Cargo manifests/lock, tool pins and package versions remain
unchanged at 0.3.6. No functions, methods or types were removed. No dependency
resolution, product compilation, broad local CI/test gate, version change,
commit, push, workflow rerun, release or publication was performed.
