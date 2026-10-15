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

## Prerequisites and focused checks

Prepare the pinned Rust 1.99.0 development toolchain with rustfmt, Clippy and
`wasm32-unknown-unknown`. Prepare Rust 1.91.0, including its Wasm
target, for the advertised package floors:

| Package | Rust floor | Floor gate |
| --- | --- | --- |
| `ic-metrics` | 1.91, native and Wasm | `make msrv` |
| `ic-metrics-stable` | 1.91, native and Wasm | `make msrv` |

Use Git, GNU Make, Bash 3.2 or newer and standard Unix utilities. The
[local setup guide](local-setup.md#bootstrap-prerequisites) owns system bootstrap,
installer dependencies and the pinned common host, IC and Cargo-tool inventory.
The reviewed [Make interface](make-interface.md) routes common setup, formatting,
hooks and releases; product gates remain local.

```sh
make install-tools
make tools-check
cargo fetch --locked
export PATH="$PWD/.tools/host/bin:$PWD/.tools/ic/bin:$PWD/.tools/rust/common/bin:$PATH"
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

The optional evidence tool is published `ic-host-wasm-inspect` 0.17.10, selected through
the shared Cargo-tool installer. `make install-wasm-inspector` prepares that
selection explicitly; `make wasm-inspector-tools-check` verifies it offline.
`bash scripts/dev/wasm-inspector.sh run PATH MAX_BYTES MAX_SECTIONS MAX_EXPORTS MAX_CUSTOM_SECTIONS`
consumes only the admitted executable path. IC Host owns its compiler floor,
implementation and complete CLI test suite; it is not a Metrics workspace package.
Common setup/check, CI and release preflight do not install or require this CLI.
Neither library requires IC Host to build or run. Explicit `make wasm-inspect-check`
checks evidence-tool wiring and dispatch; it establishes no canister behavior.
Existing experiment identities remain frozen.
The reviewed snapshot owns default pins in `ci/tool-versions.env` and
`ci/ic-tools.tsv`; host, Rust and IC exceptions are independently selected
under the shared catalog contract. Use the same optional
`SHARED_TOOLING_STORE` setting for setup, checking and evidence collection.
Host/IC/Cargo paths select admitted shared generations; earlier sets and failed
candidates remain retained. Build-policy/compiler/native identity changes require
explicit Cargo-tool setup. Application flags and wrappers remain separate from
[the standard tool-build environment](local-setup.md#standard-cargo-tool-build-environment).

After Rust edits, run `make fmt`. It sorts workspace manifests and formats Rust;
`make fmt-check` is read-only. Select the affected package's focused checks:

| Scope | Commands |
| --- | --- |
| Arithmetic | `make check check-wasm clippy docs-check`; named `cargo test -p ic-metrics --locked <test-name>` |
| Durable adapter | `make stable-check`; named `cargo test -p ic-metrics-stable --locked <test-name>` |
| Host inspector | `make wasm-inspect-check` |
| Snapshot/pins | `make shared-tooling-check check-pins` |
| Local tools/hooks | `make tools-check hook-check` |
| Release/evidence adapters | `make release-tools-check ci-evidence-check` |
| Maintained docs | `make check-doc-links`, consistency review and `git diff --check` |

Keep compilation checks sequential when they share `target/`; check for active
builds before source mutation or compilation. Bare Cargo commands select the
arithmetic package. Builds use locked dependencies. The arithmetic graph has no
third-party dependency, platform reader, IC feature or server harness. Native
stable tests use `VectorMemory` for storage/codec reopening, not IC execution.
The upstream inspector tests argument/file/budget admission, report publication and typed
output failure at its IC Host owner. Metrics checks offline tool admission and
actual dispatch to the published CLI; smoke inputs remain under
`target/evidence/wasm-inspector/`.

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
Tooling owns assertions about its checkers' nested fixture payloads.

Generic Make execution-mode matrices and parallel dispatch also use shared probes
against the actual consumer Makefile. Metrics owns the target lists and stubs.
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

Release, hook and evidence fixtures substitute only their declared effects;
actual Git index, Make dispatch, receipt admission and failure retention retain
independent checks. These fixtures perform no real Metrics release or registry
publication. The admission fixture isolates parent validation/failure/summary
paths. Successful cleanup affects only invocation-owned scratch, while failed
inputs stay under `target/evidence/native-ci/`. Substitute execution does not
prove live GitHub release recovery or canister measurement behavior.

[Released 0.8.1 acceptance](evidence/release-081.md) verifies all three native
receipts and the complete Rust-floor run on its exact published source.
[The current handoff](status/current.md) binds pending work to separate local
qualification. Earlier host/reader/release observations remain in their evidence
owners and the verbatim guides retained by [the cleanup receipt](evidence/cleanup-082.md).
They are not current platform readers, validation commands or acceptance of a
later dependency graph. Actual IC execution and callback attribution belong to
the owning consumers under [the extraction contract](extraction.md#downstream-contract-checks).
