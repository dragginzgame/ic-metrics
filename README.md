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
[The extraction contract](docs/extraction.md) records scope and evidence.

## Development

Install rustup, Git, GNU Make, Bash 3.2 or newer and a SHA-256 utility. The pinned
toolchain is Rust 1.99.0 and the MSRV is 1.88.0. Install `wasm32-unknown-unknown`
for Wasm checks. `make help` lists focused commands; select named tests during
implementation. Full `make ci` requires an explicit request outside configured CI.

See [agent rules](AGENTS.md), [host support](docs/hosts.md) and
[the current handoff](docs/status/current.md). Reviewed shared tooling is vendored;
normal checks and release scripts need no Shared Tooling sibling checkout.

## Releases and adoption

The public repository is [dragginzgame/ic-metrics](https://github.com/dragginzgame/ic-metrics).
The [changelog](CHANGELOG.md) preserves the initial `0.1.0` scaffold and one undated
Draft toward `0.1.1`. Cargo metadata remains `0.1.0`; publication is disabled.
Temporary consumer paths must become released dependencies before publication.

Maintainer-owned `make release-patch`, `release-minor` and `release-major` use the
[same reviewed workflow](docs/releases.md), with `RELEASE_REMOTE=origin` and
`RELEASE_BRANCH=main`. They require cargo-edit (`cargo set-version`), run the
complete offline gate, prepare only Cargo metadata and release notes, commit,
tag and atomically push. They do not publish the crate. Inspect retained release
state before `make release-resume VERSION=X.Y.Z` resumes an interrupted candidate.
