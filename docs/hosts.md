# Host support and qualification

| Native host | Required support | Configured runner |
| --- | --- | --- |
| Linux x86_64 | Library build and development tooling | `ubuntu-24.04` |
| macOS Intel | Library build and development tooling | `macos-15-intel` |
| macOS Apple Silicon | Library build and development tooling | `macos-15` |

All three hosts run the complete native suite. Bash 3.2 checks on Linux and Wasm
cross-compilation do not establish native macOS acceptance. Routine CI retains
the latest workflow/ref run through cancellation; a cancelled run never qualifies
its source. Native jobs have a 60-minute budget for cold setup and validation.
The [shared host rules](supported-hosts.md) own the common support contract.

Native input hashing and workflow fixture copies use
`scripts/ci/native-source-files.sh`, which emits NUL-delimited maintained paths
including pending source. The workflow records common managed tool paths, hashes
and observed versions through Shared Tooling; compiler selection stays local. Failed observations retain partial diagnostics.

CI prepares pinned host parsers before reading Rust policy from TOML. The
separate `host-tools.log` and outcome survive setup failure; Rust and subsequent
common setup are skipped when parser preparation fails. The selected
`prepare-common-tools` action reuses those host tools and owns complete common installation,
offline checking and PATH publication after success. The always-run Metrics
collector projects its `RUNNER_TEMP/tools-install.log` and `tools-check.log` into
the retained `tools-setup.log` and `tools-check.log` names. Setup failures keep
their actual stdout/stderr; skipped setup does not select unrelated temp logs.
Shared Tooling tests the action's installation and PATH mechanics; Metrics tests
its action reference, outcome/log projection and complete recovery evidence.

Diagnostic collection failure still allows the independently admitted native
recovery archive to be packaged and uploaded. The artifact step retains the
collection failure status; a secondary packaging failure is reported without
replacing that first error. A recovery archive does not establish complete tool
collection or turn a failed check into a successful one.

## Prerequisites and focused checks

After adopting Shared Tooling 0.26.8, rerun `make install-tools`, then
`make tools-check`: the changed build-helper policy participates in tool identity.
Explicit Cargo setup waits up to 60 seconds per occupied admitted slot, while
offline checks remain immediate. The shared [setup guide](local-setup.md#standard-cargo-tool-build-environment)
owns the wait-budget override and lock admission. Previous generations remain
retained. Metrics' release editor selects the required `cli` feature through the
managed installer, without adding a library dependency.

Prepare the pinned Rust 1.99.1 development toolchain with rustfmt, Clippy and
`wasm32-unknown-unknown`. Prepare Rust 1.91.0, including its Wasm
target, for the advertised package floors.

Local setup and both CI lanes use the selected shared installer. Prepare the
host tools first so the installer uses the pinned TOML/JSON parsers:

```sh
make install-host-tools
export PATH="$PWD/.tools/host/bin:$PATH"
bash scripts/dev/prepare-rust-toolchain.sh --toolchain-file rust-toolchain.toml
bash scripts/dev/prepare-rust-toolchain.sh --workspace-manifest Cargo.toml \
    --target wasm32-unknown-unknown
```

The TOML files own compiler selections; CI does not repeat their version pins or
development component/target roster. Setup preserves the default toolchain. Checks still require prepared compilers;
they never call this installer implicitly.

The `msrv` validation adapter reads `workspace.package.rust-version` at execution
time through the shared read-only workspace-floor reader, using prepared host
parsers without requiring setup. `MSRV` can explicitly override it with one
already prepared toolchain; Rustup auto-install is disabled. Help and unrelated
Make targets do not parse Cargo just to select the floor. Full `make msrv` retains
its release/explicit-check authority; focused package commands remain below.

The arithmetic package uses that minimum:

| Package | Rust floor | Floor gate |
| --- | --- | --- |
| `ic-metrics` | 1.91, native and Wasm | `make msrv` |

Use Git, GNU Make, Bash 3.2 or newer and standard Unix utilities. The
[local setup guide](local-setup.md#bootstrap-prerequisites) owns system bootstrap,
installer dependencies and the pinned common host/Cargo-tool inventory. IC
executables remain explicit product selections for optional experiments.
The reviewed [Make interface](make-interface.md) routes common setup, formatting,
hooks and releases; product gates remain local.

```sh
make install-tools
make tools-check
cargo fetch --locked
export PATH="$PWD/.tools/host/bin:$PWD/.tools/rust/common/bin:$PATH"
make install-hooks
```

Setup is explicit; checks never install tools or unlock the selected graph.
Normal setup selects host and Cargo tools plus the release editor, with no IC
executables. For optional IC tooling, pass the same explicit `IC_TOOLS` selection
to `make install-ic-tools` and `make ic-tools-check`, such as `IC_TOOLS=wasm-opt`.
The full reviewed catalog remains intact, and previous IC bundles are retained.
The native version report uses its host/Cargo-only interface; failed setup still
retains full tool evidence, including existing unselected IC bundles.
Prepare the locked application sources before offline release-fixture checks;
common tool setup prepares different Cargo graphs. Native CI fetches explicitly
before `make ci`. A snapshot retirement leaves tracked deletions until committed;
source hashing deliberately refuses missing tracked files. Qualify that prepared
source in an isolated committed checkout without changing the real index, or run
against the committed tree. The selected-commit metadata fixture reads committed HEAD,
so its graph must also be prepared when local manifest/lock edits differ from
HEAD; a prepared working-tree graph alone cannot qualify that offline check.

Optional structural Wasm inspection follows the
[IC Host inspector guide](https://github.com/dragginzgame/ic-tooling/tree/main/apps/ic-host-wasm-inspect).
Experiments select their qualified published version, managed installation and
budgets directly. Metrics has no inspector wrapper, pin or Make targets; common
setup/check, CI, release preflight and the arithmetic library require no inspector.
Existing experiment sources, executable identities and artifacts remain frozen.
The reviewed snapshot owns default pins in `ci/tool-versions.env` and
`ci/ic-tools.tsv`; host, Rust and IC exceptions are independently selected
under the shared catalog contract. Use the same optional
`SHARED_TOOLING_STORE` setting for setup, checking and evidence collection.
Host/IC/Cargo paths select admitted shared generations; earlier sets and failed
candidates remain retained. Build-policy/compiler/native identity changes require
explicit Cargo-tool setup. Application flags and wrappers remain separate from
[the standard tool-build environment](local-setup.md#standard-cargo-tool-build-environment).

After Rust edits, run `make fmt`. It sorts workspace manifests and formats Rust;
`make fmt-check` is read-only. The common product gates cover the arithmetic workspace
package; select direct Cargo commands when only one package or test is affected:

| Scope | Commands |
| --- | --- |
| Arithmetic workspace | `make check check-wasm clippy docs-check test` |
| Focused library checks | `cargo check -p PACKAGE --all-targets --locked`; library Wasm: `cargo check -p PACKAGE --locked --target wasm32-unknown-unknown`; `cargo clippy -p PACKAGE --all-targets --locked -- -D warnings` |
| Named tests | `cargo test -p ic-metrics --locked <test-name>`; package doctests: `cargo test -p PACKAGE --locked --doc` |
| Standard numeric transport | `cargo test -p ic-metrics --lib --no-default-features --locked wire::tests`; transport and metadata require no Metrics feature selection |
| Recording library checks | `cargo check -p ic-metrics --lib --features recording --locked`; Wasm: `cargo check -p ic-metrics --lib --features recording --locked --target wasm32-unknown-unknown`; lint: `cargo clippy -p ic-metrics --lib --tests --features recording --locked -- -D warnings` |
| Recording tests and examples | `cargo test -p ic-metrics --lib --features recording --locked <test-name>`; doctests: `cargo test -p ic-metrics --doc --features recording --locked` |
| Snapshot/pins | `make shared-tooling-check check-pins` |
| Local tools/hooks | `make tools-check hook-check` |
| Release/evidence adapters | `make release-tools-check ci-evidence-check` |
| Frozen evidence integrity | `make evidence-check` (checksums only; no replay or payload-privacy qualification) |
| Maintained docs | `make check-doc-links`, consistency review and `git diff --check` |

Default-feature commands above cover allocation-free arithmetic. Recording is
opt-in: include `--features recording` when selecting its tests, checks or examples.
A recording test-name filter without that feature can succeed with zero selected
tests; confirm that the intended cases actually ran.

The release MSRV gate checks all native targets, including tests and development
dependencies, at Rust 1.91; its Wasm check covers libraries. Public doctests
also execute on the selected minimum compiler. The development
compiler remains separate. `make evidence-check` is also included in CI and
release validation. Five historical checksum manifests use archive-directory
paths; the Makefile records those working directories without rewriting receipts.
The gate checks distributed archives and retained inspection reports. Historical
source-hash receipts describe their original checkout, not today's source tree,
and are not compared with current files.

### Dependency roles and production graphs

The sole workspace member is the arithmetic library with standard numeric transport. The root
catalog's `Tests and tooling only` group selects `num-bigint` for the ratio
oracle, with default features disabled. It is inherited only by development
dependencies. IC Persistence owns stable-adapter graph admission and tests.

The root catalog uses Shared Tooling's grouped sort order.
`make fmt`, `make fmt-check` and hooks use that shared default; every release
adapter ordering check uses `--manifest-order-grouped` against its current or
selected committed source. No paired formatter override is needed here.

`make production-dependencies-check` admits the sole arithmetic workspace member
through successful locked, offline Cargo metadata. Only required Serde and IC Wire
transport declarations without dependency defaults are admitted; default features
must remain empty. Other
normal/build dependencies are rejected, including inactive target-specific entries.
This constrains the production graph without
compiler-host discovery or repeated graph traversal. Development dependencies
remain separate; the existing direct stable-substrate prohibition applies there
too. Fixtures cover declaration axes, renamed dependencies, allowed development
use, failed Cargo children and malformed/incomplete metadata. CI and release
verification use the same check.

IC Persistence owns stable-adapter dependency policy and qualification. Follow
[its guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable)
for governed handles, collection identity and retained-data requirements.
This repository has no deployment entrypoint or final canister artifact;
applications qualify their own target, features and resolved dependency graph.
Role labels, formatting and `make check-pins` remain separate checks.

Keep compilation checks sequential when they share `target/`; check for active
builds before source mutation or compilation. Bare Cargo commands select the
arithmetic package. Builds use locked dependencies. The arithmetic graph has no
third-party dependency, platform reader, IC feature or server harness. Stable storage qualification now belongs to IC Persistence.
The inspector's CLI checks stay at IC Host; existing smoke artifacts under
`target/evidence/wasm-inspector/` remain retained historical evidence.

Formatting fixtures use Shared Tooling's current-source selector for maintained
Rust sources and Cargo manifests, including pending additions and deletions.
Metrics selects its arithmetic Rust entrypoint. Its single development dependency
has no pair to reorder, so the hook fixture uses Shared's explicit mode without
dependency-table perturbation. Generic manifest sorting remains qualified at
Shared Tooling; the local fixture retains Rust formatting, preservation, failure
diagnostics and installation checks. Failed nested checker evidence stays retained;
explicit non-Rust overlays remain local.
The shared locked release-preflight helper owns fetch/tool sequencing and pin
rechecks; Metrics admits source/recovery first and selects preparation authority,
tool targets and pin files. Checks remain offline and never install tools.

`ci/release-tools.env` selects published IC Build 0.64.0's
`ic-build-release-metadata` executable with its required `cli` feature and a
1 MiB allowance for each input document. This selects the current Host artifact,
filesystem and process implementations through Build's tool graph, without
adding library dependencies. Current manifests, lock and context are below
64 KiB. The shared managed installer owns its package/compiler identity and executable admission;
Metrics' small `release-editor.sh` adapter supplies only that selection.
`make install-tools` runs `install-release-editor` after common setup, and
`make tools-check` runs `release-editor-check`. Standalone targets are available
after host parsers are prepared. Standard release preflight prepares/checks the
editor before offline validation; standalone preflight only checks it. Metadata
preparation resolves its absolute admitted path without installation, then Shared
Tooling owns candidate preparation, validation and failure restoration. Missing
selections refuse before metadata mutation. The arithmetic library requires no IC Build.

The arithmetic library declares or imports no external IC-specific package and
needs no Platform dependency. There is no maintained Rust CLI, endpoint or messaging
codec to migrate to Clap or Wire. Tracked sources and actual package file lists
are reviewed for the no-symlink rule; managed tool-selection pointers and isolated
rejection fixtures retain their narrow exceptions. Frozen evidence keeps its
original source and dependency identities.

## Full release validation

Focused checks for changed behavior and directly affected callers are sufficient
for ordinary handoff under [the validation policy](../DRAGGINZGAME.md#validation-and-evidence).
Run full local suites only for an explicitly authorized release or an explicit
request for those checks. The full gate is `make ci`, then workspace-native/Wasm `make msrv`; reuse passing evidence only for unchanged inputs. Full CI
admits tools, pins and formatting before the native/Wasm Clippy gate. Clippy
denies warnings and runs before test suites, documentation builds and dependency
qualification fixtures. The complete gate checks the arithmetic package's builds,
docs and tests. Configured CI and required branch
checks remain unchanged. Strict native all-target and Wasm library Clippy supply
CI type checking; `make check` and `make check-wasm` remain focused entrypoints.
The workspace currently contains only a library. If other Wasm targets
are added, extend the Clippy target selection to preserve their CI coverage.
Inspection and documentation-only work use narrower
checks. [AGENTS.md](../AGENTS.md) retains product constraints and separate release
and publication authority.

Release/publication are separate maintainer actions under
[the release contract](releases.md). Normal release commands start fresh from
clean committed metadata without scanning or replaying historical plans.
Use `make release-resume VERSION=X.Y.Z` for recovery of a specific saved attempt.
Standard release preflight prepares the
locked dependency cache, common Cargo tools and the selected release editor before offline validation;
standalone preflight only fetches/checks offline. Preparation and late checks
bind the selected release commit rather than newer working-tree metadata.
Late metadata checks use Shared's `--manifest-order-grouped` option to check ordering
in that same selected source; literal version preparation never sorts it.
Neither validation nor release performs artifact cleanup.
Both `make publish` and `make publish-check` run the same native/Wasm Clippy
gate before Cargo packaging or registry effects. Sequential recipes stop on lint
failure even under parallel Make; publication remains separately authorized.

## Native evidence

Native host admission uses Shared's read-only validator with the local matrix's
OS, architecture and explicit macOS major. Failed observations refuse before
local PATH changes; the portable fixture does not establish native macOS support.

The workflow captures exact source inputs and host/compiler identities before
setup, records setup/check/native outcomes and keeps stdout/stderr on failures.
Tool candidate selection preserves admitted failed inputs and diagnostics;
collection failure remains nonzero. Formatter logs outside the fixture scratch
root are included. Uploads retain `native-ci.tar.gz` and its checksum for 30 days,
including hidden release/index/configuration evidence inside the outer tar.
A separately uploaded `native-diagnostics.tar.gz` and checksum contain only
explicit available top-level logs and source/tool/outcome identities. No tool
payload, source tree, scratch directory or nested archive is selected. It is
collected before the complete archive so full collection failures still leave
readable diagnostics; neither archive silently truncates selected logs.

Shared Tooling owns generic installer, formatting, metadata, release-engine and
fixture mechanics. Its [producer/consumer boundaries](verification-helpers.md#producer-and-consumer-fixture-boundaries),
[flow qualification](verification-helpers.md#consumer-flow-qualification),
[retention probes](verification-helpers.md#consumer-fixture-retention-probes) and
[hook checker](verification-helpers.md#consumer-formatting-hook-adoption) describe
those contracts and producer tests. Metrics verifies its reviewed snapshot and
actual callers; it does not replay those generic matrices in its own gates.

| Local entrypoint | Metrics-owned qualification |
| --- | --- |
| `make release-tools-check` | Complete standard-release, arithmetic metadata, hook and source-admission fixtures, followed by injected failure/custody cases. Actual Make dispatch, parallel jobserver access, catalog overrides, selected commits, index admission, gate ordering and retained logs stay checked. |
| `make hook-check` | Standalone hook adoption; the actual baseline formatter failure must retain and replay its diagnostic log. |
| `make ci-evidence-check` | Source selection/hash inputs, actual workflow setup/archive bodies and the complete native recovery packager with substituted external effects. |

Retention is the single CI entry for release and hook bodies; they are not run
again as separate gates. The admission fixture isolates inherited parent
validation/failure logs and summaries. Successful cleanup affects only owned
scratch; failed inputs remain under caller-selected `TMPDIR`, defaulting to
native CI evidence in the retention fixture. These substitutes perform no real
Metrics release or registry publication and do not qualify hosted execution.

The metadata fixture uses the arithmetic package name and rejects a stale
local lock identity without repairing it. `scripts/release/metadata.sh files` owns the NUL-delimited release-file
roster projected by `make release-files`; listing works without Cargo, Git or
prepared parsers. Its bootstrap fixture is deliberately minimal. Other release
fixtures select the declared closure of `make/consumer.mk` or the metadata
adapter, adding only their local inputs. Consumer checks retain unsafe Make-mode
refusal before effects, explicit tool-catalog routing and selected-source checks.

Native input selection includes pending maintained files, excludes generated and
private evidence, and keeps missing tracked source selected so hashing refuses
an incomplete checkout. The workflow-body fixture covers unusual filenames,
OS/architecture/macOS admission, TOML-selected compiler/components/targets,
failed setup and action-outcome/log projection. Substitute rustup/Make actions
establish routing and failure propagation, not native macOS or live release proof.

Metrics owns `scripts/ci/package-native-recovery-evidence.sh`, including the full
scratch tree, hidden Git recovery state and top-level checksum inventory. Its
round-trip fixture checks payloads, containment, occupied destinations and retained
inputs/partial output after inventory, tar or checksum failure. The workflow
publishes sanitized diagnostics first; fatal collector status stops the outer
archive, while partial collection keeps that archive and remains nonzero.
Readable diagnostics must survive an outer-archive failure. Formatter logs outside
scratch and failed/skipped tool setup remain covered. Both uploads disable ZIP
compression for their gzip payloads; archive/checksum pairing and 30-day retention
remain unchanged.

[Released 0.8.1 acceptance](evidence/release-081.md) verifies all three native
receipts and the complete Rust-floor run on its exact published source.
[The current handoff](status/current.md) binds pending work to separate local
qualification. Earlier host/reader/release observations remain in their evidence
owners and the verbatim guides retained by [the cleanup receipt](evidence/cleanup-082.md).
They are not current platform readers, validation commands or acceptance of a
later dependency graph. Actual IC execution and callback attribution belong to
the owning consumers under [the extraction contract](extraction.md#downstream-contract-checks).

`make package-check` builds and verifies the arithmetic archive offline.
IC Persistence owns stable-adapter compilation, tests and archive qualification.
It allows pending source changes for review, never uploads, and runs after
Clippy in CI and again after release metadata preparation before staging.
Prepared dependency sources are required; it does not install or update them.
