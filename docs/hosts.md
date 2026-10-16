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

## Prerequisites and focused checks

Prepare the pinned Rust 1.99.0 development toolchain with rustfmt, Clippy and
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

Both packages use that minimum:

| Package | Rust floor | Floor gate |
| --- | --- | --- |
| `ic-metrics` | 1.91, native and Wasm | `make msrv` |
| `ic-metrics-stable` | 1.91, native and Wasm | `make msrv` |

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
Prepare the locked application sources before offline release-fixture checks;
common tool setup prepares different Cargo graphs. Native CI fetches explicitly
before `make ci`. A snapshot retirement leaves tracked deletions until committed;
source hashing deliberately refuses missing tracked files. Qualify that prepared
source in an isolated committed checkout without changing the real index, or run
against the committed tree. The selected-commit metadata fixture reads committed HEAD,
so its graph must also be prepared when local manifest/lock edits differ from
HEAD; a prepared working-tree graph alone cannot qualify that offline check.

Optional structural Wasm inspection follows the
[IC Host inspector guide](https://github.com/dragginzgame/ic-host-tooling/tree/main/apps/ic-host-wasm-inspect).
Experiments select their qualified published version, managed installation and
budgets directly. Metrics has no inspector wrapper, pin or Make targets; common
setup/check, CI, release preflight and both libraries require no inspector.
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
`make fmt-check` is read-only. The common product gates cover both workspace
packages; select direct Cargo commands when only one package or test is affected:

| Scope | Commands |
| --- | --- |
| Both packages | `make check check-wasm clippy docs-check test` |
| One package | `cargo check -p PACKAGE --all-targets --locked`; library Wasm: `cargo check -p PACKAGE --locked --target wasm32-unknown-unknown`; `cargo clippy -p PACKAGE --all-targets --locked -- -D warnings` |
| Named tests | `cargo test -p ic-metrics --locked <test-name>` or `cargo test -p ic-metrics-stable --locked <test-name>`; package doctests: `cargo test -p PACKAGE --locked --doc` |
| Snapshot/pins | `make shared-tooling-check check-pins` |
| Local tools/hooks | `make tools-check hook-check` |
| Release/evidence adapters | `make release-tools-check ci-evidence-check` |
| Maintained docs | `make check-doc-links`, consistency review and `git diff --check` |

Keep compilation checks sequential when they share `target/`; check for active
builds before source mutation or compilation. Bare Cargo commands select the
arithmetic package. Builds use locked dependencies. The arithmetic graph has no
third-party dependency, platform reader, IC feature or server harness. Native
stable tests use `VectorMemory` for storage/codec reopening, not IC execution.
The inspector's CLI checks stay at IC Host; existing smoke artifacts under
`target/evidence/wasm-inspector/` remain retained historical evidence.

Formatting fixtures use Shared Tooling's current-source selector for maintained
Rust sources and Cargo manifests, including pending additions and deletions.
Metrics supplies the primary perturbation paths and explicit non-Rust overlays.
The shared locked release-preflight helper owns fetch/tool sequencing and pin
rechecks; Metrics admits source/recovery first and selects preparation authority,
tool targets and pin files. Checks remain offline and never install tools.

## Full release validation

Focused checks for changed behavior and directly affected callers are sufficient
for ordinary handoff under [the validation policy](../DRAGGINZGAME.md#validation-and-evidence).
Run full local suites only for an explicitly authorized release or an explicit
request for those checks. The full gate is `make ci`, then workspace-native/Wasm `make msrv`; reuse passing evidence only for unchanged inputs. Full CI
admits tools and pins before compilation, denies Clippy warnings, and checks
builds, docs and tests for both packages. Configured CI and required branch
checks remain unchanged. Inspection and documentation-only work use narrower
checks. [AGENTS.md](../AGENTS.md) retains product constraints and separate release
and publication authority.

Release/publication are separate maintainer actions under
[the release contract](releases.md). Standard release preflight prepares the
locked dependency cache and common Cargo tools before offline validation;
standalone preflight only fetches/checks offline. Preparation and late checks
bind the selected release commit rather than newer working-tree metadata.
Late metadata checks use Shared's `--manifest-order` option to check ordering
in that same selected source; literal version preparation never sorts it.
Neither validation nor release performs artifact cleanup.

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

Exhaustive installer, formatting, archive, Cargo metadata and release-engine
regressions run at Shared Tooling's producer. Metrics verifies its reviewed
snapshot, actual common tools and pins, then its own Make/hook/metadata/source
admission and evidence integration. Removed upstream test payloads are retired
through the distribution helper; directly used helpers remain explicit roots. The Metrics metadata fixture checks the real two-package adapter and stale stable
member refusal. Tool candidate selection/archive orchestration is shared; the
consumer keeps source/outcome selection, Git custody and uploads. Formatter
log discovery uses the shared selector. Local cleanup probes delegate actual
initialization/EXIT prefixes to the shared helper; Metrics retains its fixture
roster, consumer-log forwarding and intentional successful retention. Shared
Tooling owns assertions about its checkers' nested fixture payloads. Its validation
logger fixture owns unusable-destination fallback and preservation of earlier
failure logs. Metrics retains the actual release adapter's environment, gate
order, selected release identities and chosen evidence destination.

Per-target Make admission and parallel dispatch use shared probes against the
actual consumer Makefile. Each target refuses ignore-errors, dry-run, touch and
question modes before effects. Shared Tooling owns exhaustive flag aliases and
inherited/replaced/hidden-flag permutations; Metrics owns target lists and stubs.
The shared `prepare-make-fixture.sh` copies the common Make/include runner
skeleton; release fixtures add their local validation logger/checksum inputs.
The exhaustive release-root isolation matrix stays with Shared Tooling; Metrics
keeps one actual include-admission check. Workflow run bodies use the shared
unique-step extractor, while ordering, conditions and execution remain local.
The shared effectful-fixture driver requires exact status, a failure marker and
one retained directory, or successful cleanup; Metrics checks retained payloads.
Native diagnostic collection uses the explicit local filename roster, publishes
the small archive first and returns fatal admission/archive errors before outer
collection. Shared's complete-tree packager then inventories top-level files
and retains Git recovery state verbatim. Occupied destinations refuse; inventory,
archive or checksum failure retains inputs and partial output with its command
status. Metrics keeps incomplete-collection status and artifact upload policy.

The producer's [native diagnostic regression contribution](https://github.com/dragginzgame/shared-tooling/pull/222)
owns the six generic referenced-store and candidate-archive cases. Metrics keeps
the actual workflow's fatal/nonfatal collector handling: fatal status stops the
outer archive; partial collection retains it and remains nonzero. Its remaining
fixture also checks action outcomes, selected diagnostics, formatting logs,
and hidden Git recovery state. Producer tests remain upstream rather than being
added to this consumer's snapshot or CI.

Both native artifact uploads disable ZIP compression because their payloads are
already gzip-compressed archives; archive/checksum pairing and retention stay
unchanged.

Release, hook and evidence fixtures substitute only their declared effects;
actual Git index, Make dispatch, receipt admission and failure retention retain
independent checks. These fixtures perform no real Metrics release or registry
publication. The admission fixture isolates parent validation/failure/summary
paths. Successful cleanup affects only invocation-owned scratch, while failed
inputs stay under caller-selected `TMPDIR`, defaulting to native CI evidence for
the retention fixture. Its exit probes use shared setup/dispatch against the real
read-only source checkout; no per-case Git repository or helper tree is built.
The version predicate uses the shared selected-assertion probe, while actual
metadata bodies and retained-input checks remain independent. Substitute execution does not
prove live GitHub release recovery or canister measurement behavior.

`make release-tools-check` runs the retention suite as the single CI entry for
release and hook fixtures. Its success cases execute the complete standard,
metadata and hook bodies, and its admission case runs the complete admission
fixture with parent-owned evidence destinations. Failure/custody probes remain
additional checks. CI does not run these bodies again as separate gates;
`make hook-check` and the standalone scripts remain focused entrypoints.
Unexpected child failures replay their active log before reporting retained
evidence.

`scripts/release/metadata.sh files` owns the NUL-delimited release-file roster
projected by `make release-files`. The same roster feeds source admission,
regular-file checks and the final diff guard. Listing requires no Cargo/Git or
parser dispatch; the independent validation boundaries remain in place.

The hook wrapper relies on the shared checker's baseline `fmt-check` for
formatter prerequisites. Metrics injects a failure at that baseline to verify
retained/replayed logs; Shared Tooling owns formatter-version admission cases.
Unusual source filenames are qualified through the actual workflow hash body,
while the focused selector fixture owns inclusion, exclusions and missing
tracked-source selection.

The actual development/MSRV workflow setup bodies execute the shared Rust
installer against a substitute rustup in the native evidence fixture. Metrics
checks its TOML-selected compilers, components, Wasm targets and failed setup status; Shared
Tooling owns generic installer argument admission. Simulated cold/warm cache and
tool-availability matrices live with Shared's preflight fixture
([PR #228](https://github.com/dragginzgame/shared-tooling/pull/228)). Metrics retains
actual committed-graph Cargo metadata, internal preparation selection, runner
ordering, explicit catalog overrides and Git-state custody. Real Cargo offline
policy is qualified at Shared on a frozen minimal graph
([PR #235](https://github.com/dragginzgame/shared-tooling/pull/235)).
Shared's common-tool fixture executes the action body and shared Make aggregate,
covering installation/check order, logs, PATH publication and leaf failures.
Metrics supplies action outcomes and logs to its own collector, retaining failed
and skipped setup, formatting, candidate custody and complete recovery evidence.

Shared Tooling also owns generic selected-commit identity, missing-release-field
and failed-Git retention cases, plus the validation runner's Make-flag matrix
([PR #232](https://github.com/dragginzgame/shared-tooling/pull/232)). Metrics retains
the actual two-package committed source, one rejected-version receipt, index
admission and release-verify gate ordering, log retention and input-drift checks.

[Released 0.8.1 acceptance](evidence/release-081.md) verifies all three native
receipts and the complete Rust-floor run on its exact published source.
[The current handoff](status/current.md) binds pending work to separate local
qualification. Earlier host/reader/release observations remain in their evidence
owners and the verbatim guides retained by [the cleanup receipt](evidence/cleanup-082.md).
They are not current platform readers, validation commands or acceptance of a
later dependency graph. Actual IC execution and callback attribution belong to
the owning consumers under [the extraction contract](extraction.md#downstream-contract-checks).
