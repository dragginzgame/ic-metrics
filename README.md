# ic-metrics

Allocation-free measurement arithmetic and an opt-in IC instruction reader.

The default dependency-free `no_std` library exports `record_sample` for consumer-owned
count/total fields and `MeasurementSummary` for samples, total, latest and maximum.
Zero is a valid observation; an empty summary has no latest or maximum value.
Count and total saturate independently. Consumers establish units, identity and
reset boundaries before comparing observations; saturated totals cannot supply
exact interval arithmetic.

```rust
use ic_metrics::MeasurementSummary;

let mut summary = MeasurementSummary::EMPTY;
assert_eq!(summary.latest(), None);
summary.record(0);
assert_eq!(summary.samples(), 1);
assert_eq!(summary.latest(), Some(0));
```

Known downstream consumers are IcyDB, Canic, ic-timers and ic-backup. Their
attribution, registries, callback roles, replication, persistence and reporting
remain local. ic-backup's prepared host integration uses arithmetic-only summaries
for local durations in nanoseconds and prepared chunk sizes in bytes; it enables
no IC reader and its diagnostics establish no IC instruction or cycle cost.
The crate has no global consumer registry, stable-memory allocation or endpoints.
Consumers own their summary instances, labels and persistence policy.
[The extraction contract](https://github.com/dragginzgame/ic-metrics/blob/main/docs/extraction.md)
records scope and evidence.

Published 0.1.5 exposes `ic_metrics::call_context_instructions()` with
feature `ic` on `wasm32-unknown-unknown`. It reads IC performance counter 1;
consumers establish call-context identity and own any subtraction or attribution.
The opt-in IC binding uses `std`. Default arithmetic builds have no runtime
dependencies on host or Wasm, and native builds expose no counter substitute.
Opt in from the root dependency catalog:

```toml
[workspace.dependencies]
ic-metrics = { version = "0.1.5", features = ["ic"] }
```

Gate the Rust import on the IC target as well:

```rust
#[cfg(all(target_arch = "wasm32", target_os = "unknown"))]
use ic_metrics::call_context_instructions;
```

Use the same condition for code that calls the reader. Enabling `ic` does not
expose it on native targets used for linting or Candid generation; consumers own
their native handling.

The reader is an instruction count, not cycles or elapsed time. Its replicated
call context can span callbacks; unrelated calls, timer deliveries and resets
do not establish comparable readings. The API documents the non-replicated
composite-query boundary separately.

`make reader-check` qualifies direct reads, replicated callbacks, ordinary queries
and composite-query callbacks in PocketIC. The
[query execution record](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/ic-reader-query.md)
includes a downstream-work exclusion check; it does not qualify consumer lifecycle
behavior or claim a performance improvement.
The CI workflow explicitly provisions pinned PocketIC 16.0.0 and runs this check
on Linux and both macOS architectures, retaining evidence for 30 days. Ordinary
local tests still require an explicit `make reader-check` invocation to run it.

## Measuring cost

Measure raw canister Wasm bytes, IC instructions and actual cycle charges
separately. The shared arithmetic allocates nothing; labels, map updates and
report encoding are consumer costs. Build profiles belong to the consumer
workspace. The [performance audit](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/performance-audit.md)
records compiler checks and size/instruction/cycle comparisons for the reader
test canister, with their workload limits. It does not establish consumer savings.

The separate [consumer lookup measurements](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/consumer-lookups.md)
cover IcyDB and Canic's borrowed-key changes. Their isolated IC fixtures show
lower instruction work and cycle charges for repeated keys, but higher costs
for first insertions. Use the recorded workload and artifact identities when
assessing those consumer changes; upgrading ic-metrics alone does not apply them.

## Development

Install rustup, Git, GNU Make, Bash 3.2 or newer and a SHA-256 utility. The pinned
toolchain is Rust 1.99.0 and the MSRV is 1.88.0. Install `wasm32-unknown-unknown`
for Wasm checks. `make help` lists focused commands; select named tests during
implementation. Full `make ci` requires an explicit request outside configured CI.

Install the pinned manifest formatter during developer setup:

```bash
cargo install cargo-sort --version 2.1.4 --locked
make install-hooks
```

`make fmt` sorts every workspace manifest before Rust formatting. `make fmt-check`
checks both without changing files; CI installs the same pinned formatter.
Run `make install-hooks` once per clone and after updating shared tooling. The
repository-local pre-commit hook formats the staged snapshot, refreshes selected
files, rejects partial staging and preserves unrelated working edits. It refuses
to replace existing hook installations. `make hook-check` exercises these
contracts in scratch repositories without creating commits.

See [agent rules](https://github.com/dragginzgame/ic-metrics/blob/main/AGENTS.md),
[host support](https://github.com/dragginzgame/ic-metrics/blob/main/docs/hosts.md) and
[the current handoff](https://github.com/dragginzgame/ic-metrics/blob/main/docs/status/current.md).
Reviewed shared tooling is vendored;
normal checks and release scripts need no Shared Tooling sibling checkout.

`make check-pins` checks dependency and workflow declarations offline using
Git, jq and Mike Farah yq. The reviewed parser version and platform digests live
in `ci/tool-versions.env`; CI installs it explicitly through the checksum-verified
shared installer. Local setup and focused commands are in
[host support](https://github.com/dragginzgame/ic-metrics/blob/main/docs/hosts.md#prerequisites-and-focused-checks).
Compatible registry requirements and tracked lockfiles preserve build selection;
the optional IC binding's exact constraint records its qualified runtime boundary.
Dependency changes must prepare every affected independent workspace graph before
release validation. Checks never upgrade dependencies or install tools implicitly.

## Releases and adoption

The public repository is [dragginzgame/ic-metrics](https://github.com/dragginzgame/ic-metrics).
The [changelog](https://github.com/dragginzgame/ic-metrics/blob/main/CHANGELOG.md)
preserves the initial `0.1.0` scaffold, the `0.1.1` arithmetic release and later
tooling releases. [`ic-metrics 0.1.7`](https://crates.io/crates/ic-metrics/0.1.7)
is published on crates.io with tag `v0.1.7`. The reader's minimum release
remains 0.1.5. Declare the current release in the consumer's
root dependency catalog:

```toml
[workspace.dependencies]
ic-metrics = "0.1.7"
```

Members inherit with `ic-metrics = { workspace = true }`. Published consumers
must resolve the registry package rather than require a sibling checkout.
[The adoption issue](https://github.com/dragginzgame/ic-metrics/issues/4)
links each consumer's integration evidence. Native qualification is recorded
against its actual revision in
[the host record](https://github.com/dragginzgame/ic-metrics/blob/main/docs/hosts.md).

Maintainer-owned `make release-patch`, `release-minor` and `release-major` use the
[same reviewed workflow](https://github.com/dragginzgame/ic-metrics/blob/main/docs/releases.md),
with `RELEASE_REMOTE=origin` and
`RELEASE_BRANCH=main`. They require cargo-edit (`cargo set-version`) and
cargo-sort 2.1.4, run the complete offline gate, prepare only Cargo metadata
and release notes, commit,
tag and atomically push. They do not publish the crate. Normal release targets
reconcile an interrupted release at its saved commit. Newer committed fixes or
a different requested increment then receive fresh preflight and full validation
before the next release is prepared. Failed validation logs remain under the
Git directory's `release-state/validation-failures/`; earlier attempts are retained.
`make release-resume VERSION=X.Y.Z` remains available for explicit selection;
identity, payload and destination conflicts stop recovery.

For a subsequent committed package release, the maintainer can run:

```bash
make publish-check
make publish
```

`publish-check` delegates to Cargo's dry run. `publish` uploads only ic-metrics to
crates.io, using the existing package version, locked dependencies and normal
Cargo credential setup (`cargo login --registry crates-io`). Both retain Cargo's
package verification and dirty-tree rejection. Publication creates no Git commit
or tag, does not bump versions and preserves build artifacts.
See [Cargo's publication documentation](https://doc.rust-lang.org/cargo/commands/cargo-publish.html).

`cargo package -p ic-metrics --locked --offline --allow-dirty` prepares and verifies
a local development archive without uploading it. The package includes the
canonical MIT license text, source and this README; documentation links resolve
to the public repository. The manifest restricts publication to crates.io.
