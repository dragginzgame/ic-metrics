# ic-metrics

Allocation-free, dependency-free measurement arithmetic.

The `no_std` library exports `record_sample` for consumer-owned
count/total fields and `MeasurementSummary` for samples, total, latest and maximum.
`MeasurementHistogram` adds a fixed-size distribution with caller-selected bounds.
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

Published 0.2.6 adds `checked_mean(samples, total)` and
`MeasurementSummary::mean()`. Both return `Result<Option<u64>, MeasurementMeanError>`:
empty data is `None`, measured zero is `Some(0)`, and nonempty unsaturated means
use floor division. A nonzero total without samples or either counter at
`u64::MAX` returns a typed error, including an exactly reached cap. The raw-field
function supports consumer-owned report shapes without constructing an accumulator.

The [application guide](https://github.com/dragginzgame/ic-metrics/blob/main/crates/ic-metrics/src/application.md) is included in
packaged crate documentation, with a compiled example of fixed named histograms,
separate units and event counts. It covers sample admission, async attribution,
resets, reporting and cost qualification; applications own those policies.

For a distribution, construct `MeasurementHistogram::new([10, 100])`. Its
disjoint buckets cover `0..=10` and `11..=100`; `overflow()` counts larger
observations. `bucket_counts()` returns those two counts, and `summary()`
includes every observation. Duplicate or descending bounds return a typed
`HistogramBoundsError` identifying the invalid bound. Construction and recording
support constant evaluation. Storage is fixed, recording searches at most the
configured number of bounds, and every bucket saturates independently. Buckets
describe ranges; they do not provide exact percentiles. Units, thresholds and
cumulative export remain consumer-owned. The histogram API is published in 0.2.4.

Published 0.2.17 adds `cumulative_count(index)` for exact counts through a configured
bound and `quantile_bucket(numerator, denominator)` for nearest-rank ranges, such
as p95 with `(95, 100)`. Empty quantiles are `None`; required count saturation
returns `HistogramQueryError`. Overflow has no configured ceiling. The new
`checked_scaled_ratio(numerator, denominator, scale)` floors an exact scaled
integer ratio from a `u128` numerator, without floating point or overflowing
intermediate multiplication. Callers establish exact inputs and handle empty or
saturated diagnostics before using it. Consumer adoption remains separately qualified.

Known callers are IcyDB, Canic, ic-timers, ic-backup, IC Blob Storage's
restoration test probe and Toko Miner's production game-shard action metrics. Their
attribution, registries, callback roles, replication, persistence and reporting
remain local. ic-backup's host integration measures local durations in nanoseconds
and prepared chunk sizes in bytes, with a four-bound byte histogram in the
inspected implementation. Its diagnostics establish no IC instruction or cycle cost.
The crate has no global consumer registry, stable-memory allocation or endpoints.
Consumers own their summary and histogram instances, labels and persistence policy.
[The extraction contract](https://github.com/dragginzgame/ic-metrics/blob/main/docs/extraction.md)
records scope and evidence.

The published 0.2.0 hard cut removes the `ic` feature and
`call_context_instructions`. Platform reads belong in consumer adapters:
IcyDB and Canic use `ic_cdk::api::call_context_instruction_counter()`; IC Timers
uses its existing `ic0::performance_counter(1)` binding. Both read counter 1.
Consumers own target gating, native handling, call-context identity and attribution.
IcyDB's inclusive overlapping spans and Canic's exclusive endpoint accounting
remain different consumer contracts.

Verified 0.2.16 publication and complete native qualification are bound in the
[release record](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/release-0216.md).
The [current handoff](https://github.com/dragginzgame/ic-metrics/blob/main/docs/status/current.md)
distinguishes local source, remote/publication state, locks and owning CI.
Consumers exposing `MeasurementSummary` in
public APIs must coordinate their 0.2 dependency identity. Stored data, reports
and endpoints are unchanged.
Historical reader execution remains in the source-bound
[evidence](https://github.com/dragginzgame/ic-metrics/blob/v0.2.3/docs/status/current.md#released-019)
and tagged releases; current CI qualifies arithmetic and repository tooling.

## Measuring cost

Measure raw canister Wasm bytes, IC instructions and actual cycle charges
separately. The shared arithmetic allocates nothing; labels, map updates and
report encoding are consumer costs. Build profiles belong to the consumer
workspace. The [performance audit](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/performance-audit.md)
records historical compiler checks and size/instruction/cycle comparisons for
the retired reader test canister, with their workload limits. It does not establish consumer savings.

The separate [consumer lookup measurements](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/consumer-lookups.md)
cover IcyDB and Canic's borrowed-key changes. Their isolated IC fixtures show
lower instruction work and cycle charges for repeated keys, but higher costs
for first insertions. Use the recorded workload and artifact identities when
assessing those consumer changes; upgrading ic-metrics alone does not apply them.

The [two-bound histogram cost experiment](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/histogram-cost-026.md)
compares Canic's source-copied recording path with count/total, summary and
histogram storage. It measures IC instructions and actual cycle charges in
Linux PocketIC, plus raw Wasm bytes and target-specific slot sizes. Its repeated-key,
two-bound workload does not establish whole-application cost or histogram adoption.
Its original replay inputs are unavailable. The separate
[durable arithmetic replay](https://github.com/dragginzgame/ic-metrics/blob/main/docs/evidence/histogram-replay-029.md)
provides a checksum-bound bundle of new fixture sources, locks, raw results and
measured Wasms. It measures direct arithmetic without Canic lookup or attribution;
its observations have their own source and workload identity.

## Development

Install rustup, Git, GNU Make, Bash 3.2 or newer and a SHA-256 utility. The pinned
toolchain is Rust 1.99.0 and the arithmetic MSRV is 1.85.0. Install `wasm32-unknown-unknown`
for Wasm checks. `make help` lists focused commands; select named tests during
implementation. Full `make ci` requires an explicit request outside configured CI.

The private [Wasm evidence inspector](https://github.com/dragginzgame/ic-metrics/blob/main/crates/ic-metrics-wasm-inspect/README.md)
uses the IC Host libraries to inspect explicitly supplied Wasms with caller-selected
bounds. It needs Rust 1.88 and reports raw/encoded bytes and structural counts,
without executing a canister. Bare Cargo commands select the arithmetic package;
its dependency-free `no_std` graph and consumer contracts remain unchanged.

Prepare the pinned checkout-local Cargo tools during developer setup:

```bash
make install-rust-tools
make rust-tools-check
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
The reviewed [maintenance task catalog](https://github.com/dragginzgame/ic-metrics/blob/main/tasks/README.md) supplies repeatable
inspection procedures. Its optional coordinator is inactive until explicitly
enabled; snapshot adoption starts no schedule or background agent.
Reviewed shared tooling is vendored;
normal checks and release scripts need no Shared Tooling sibling checkout.

Prepare the reviewed local executables explicitly:

```sh
make install-tools
make tools-check
export PATH="$PWD/.tools/host/bin:$PWD/.tools/ic/bin:$PWD/.tools/rust/bin:$PATH"
```

The setup installs jq, Mike Farah yq, ripgrep with PCRE2 and cloc plus
Quill, ICP CLI, didc, ic-wasm and Binaryen, plus
cargo-sort, cargo-sort-derives and candid-extractor,
under this checkout's `.tools/`. Rust tools use exact pins and locked Cargo
installation; interrupted setup can leave earlier tools installed and retains
build output for inspection. Archive installers retain previous and failed
candidates. `tools-check` is offline; ordinary validation never installs
tools. System bootstrap packages and installation behavior are documented in
[local setup](https://github.com/dragginzgame/ic-metrics/blob/main/docs/local-setup.md).

Release 0.3.0 changes the setup contract to five IC tools. Replace an older
six-tool selection explicitly with `make install-ic-tools`, then run
`make ic-tools-check`; previous bundles and evidence remain retained. PocketIC
setup and admission belong to IC Testkit under the
[ownership handoff](https://github.com/dragginzgame/ic-metrics/blob/main/docs/ic-tools.md#pocketic-ownership-handoff).
Metrics has no active server caller and adds no Testkit dependency. Arithmetic
APIs and consumer data are unchanged; this tooling cut requires no data reset.

The reviewed shared Make include supplies `make cloc` for this workspace's
Rust runtime/test report using the prepared local tools. Fleet tooling inventory
runs from Shared Tooling; this repository does not vendor that reporter or its
dedicated regression suite. Counts guide review and do not establish equivalent
behavior or performance.

`make check-pins` checks dependency and workflow declarations offline using
Git and the prepared local parsers. Their single reviewed pin owner is
`ci/tool-versions.env`; IC executable pins live in `ci/ic-tools.tsv`.
Local setup and focused commands are in
[host support](https://github.com/dragginzgame/ic-metrics/blob/main/docs/hosts.md#prerequisites-and-focused-checks).
The library has no Cargo dependencies. Tracked lockfiles preserve workspace
identity.
Dependency changes must prepare every affected independent workspace graph before
release validation. Checks never upgrade dependencies or install tools implicitly.

## Releases and adoption

The public repository is [dragginzgame/ic-metrics](https://github.com/dragginzgame/ic-metrics).
The [changelog](https://github.com/dragginzgame/ic-metrics/blob/main/CHANGELOG.md)
preserves the initial `0.1.0` scaffold, the `0.1.1` arithmetic release and later
tooling releases. [`ic-metrics 0.3.1`](https://crates.io/crates/ic-metrics/0.3.1)
is published on crates.io with tag `v0.3.1`. Declare the published release
in the consumer's
root dependency catalog:

```toml
[workspace.dependencies]
ic-metrics = "0.3.1"
```

Members inherit with `ic-metrics = { workspace = true }`. Consumers using
`MeasurementHistogram` require `ic-metrics = "0.2.4"` or a later compatible
published minimum in the root catalog. Either mean projection requires at least
published 0.2.6. Checked histogram queries and scaled ratios require published
0.2.17 or later. Published consumers
must resolve the registry package rather than require a sibling checkout.
[The qualification issue](https://github.com/dragginzgame/ic-metrics/issues/10)
links each consumer's integration evidence. Native qualification is recorded
against its actual revision in
[the host record](https://github.com/dragginzgame/ic-metrics/blob/main/docs/hosts.md).

People and agents contribute through topic branches and pull requests under the
[contribution rules](https://github.com/dragginzgame/ic-metrics/blob/main/rules/contributions.md).
An explicit PR request includes the agent's scoped commits, branch push and PR
creation. Ordinary fixes and continuation authorize local work. Merging and
direct integration-branch pushes require separate authority and required checks.

Explicitly requested `make release-patch`, `release-minor` and `release-major` use the
[same reviewed workflow](https://github.com/dragginzgame/ic-metrics/blob/main/docs/releases.md),
with `RELEASE_REMOTE=origin` and
`RELEASE_BRANCH=main` and `RELEASE_DELIVERY=direct`. This repo rejects PR release
delivery before dispatch; adopting it requires merged-checkout adapters and their
own qualification. They require cargo-edit (`cargo set-version`) and
the prepared pinned Cargo tools and rustfmt. After source/candidate admission and
recovery selection, they run `cargo fetch --locked` for the complete workspace
before the offline gate. This prepares missing dependencies without updating
the lock; caller-selected Cargo offline environment/configuration stays effective.
A fetch failure stops this attempt before validation or metadata changes.
Standalone `make release-preflight` stays offline. The standard entrypoints pass
an internal cache-preparation selection, consumed before helper/Cargo dispatch and
removed from validation children. Validation remains `CARGO_NET_OFFLINE=true`.
They then prepare only Cargo metadata
and release notes, commit,
tag and atomically push. They do not publish the crate. Normal release targets
reconcile an interrupted release at its saved commit. Newer committed fixes or
a different requested increment then receive fresh preflight and full validation
before the next release is prepared. Failed validation logs remain under the
Git directory's `release-state/validation-failures/`; earlier attempts are retained.
Source refusals list every staged, unstaged and untracked path outside
`Cargo.toml`, `Cargo.lock` and `CHANGELOG.md`, before this attempt starts validation
or version preparation. Resolve those paths through the ordinary contribution
workflow; the checker preserves files and index bytes.
`make release-resume VERSION=X.Y.Z` remains available for explicit selection;
identity, payload and destination conflicts stop recovery.
The 0.2.11 runner also rechecks the index, working payload and exact tag
after the final consumer check. Completed direct recovery confirms local and
remote tag identity and branch ancestry before reporting success; unavailable
observations or conflicts stop without another push.
The released Shared Tooling 0.1.25 snapshot also refreshes the matching local
tracking ref from confirmed delivery, checking its type under Git's update lock.
Unrelated, newer or symbolic refs are preserved; an optional refresh failure
reports a fetch remedy without repeating delivery. Native qualification of this
consumer batch remains pending in the release record.

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
