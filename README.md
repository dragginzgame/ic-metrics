# ic-metrics

Allocation-free saturating measurement arithmetic for Internet Computer crates.

The dependency-free `no_std` library exports `record_sample` for consumer-owned
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

IcyDB, Canic and ic-timers currently use explicit local integration dependencies.
Their inclusive or exclusive attribution, registries, callback roles, replication,
persistence and reporting remain local. IC counter reads also remain consumer-owned.
[The extraction contract](https://github.com/dragginzgame/ic-metrics/blob/main/docs/extraction.md)
records scope and evidence.

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

## Releases and adoption

The public repository is [dragginzgame/ic-metrics](https://github.com/dragginzgame/ic-metrics).
The [changelog](https://github.com/dragginzgame/ic-metrics/blob/main/CHANGELOG.md)
preserves the initial `0.1.0` scaffold, the maintainer's tagged `0.1.1` arithmetic
release and `0.1.2` tooling release. Cargo metadata is `0.1.2` and the crate is
eligible for crates.io publication. The tagged `0.1.1` revision passed native CI
on Linux and both supported macOS architectures. Temporary consumer paths must
become registry dependencies before the consuming packages can be published;
[the publication issue](https://github.com/dragginzgame/ic-metrics/issues/4)
links each consumer's adoption work.

Maintainer-owned `make release-patch`, `release-minor` and `release-major` use the
[same reviewed workflow](https://github.com/dragginzgame/ic-metrics/blob/main/docs/releases.md),
with `RELEASE_REMOTE=origin` and
`RELEASE_BRANCH=main`. They require cargo-edit (`cargo set-version`) and
cargo-sort 2.1.4, run the complete offline gate, prepare only Cargo metadata
and release notes, commit,
tag and atomically push. They do not publish the crate. Rerun the same release
target after interruption to reconcile the saved candidate without another bump.
`make release-resume VERSION=X.Y.Z` remains available for explicit selection;
identity, payload and destination conflicts stop recovery.

After committing publication-related changes, the maintainer can run:

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
