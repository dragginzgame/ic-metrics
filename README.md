# IC Observability

Portable measurement and diagnostic logging in one Rust workspace, with separate
application-selected crates.

| Crate | Responsibility | Status |
| --- | --- | --- |
| [ic-metrics](crates/ic-metrics/README.md) | Validated measurement arithmetic, numeric transport and optional bounded heap recording | Published package; existing crate identity retained |
| [ic-logging](crates/ic-logging/README.md) | Bounded heap logs, UTF-8-safe truncation, explicit age retention and scan-bounded cursor pages | Heap engine with validated checkpoint restoration |

The workspace is the renamed IC Metrics repository. It shares one catalog,
lockfile, compiler policy and coordinated release version. Neither library
depends on the other. Consumers can keep selecting `ic-metrics` by its existing
package name; logging is a separate opt-in dependency.

Both libraries are `no_std`. Measurement arithmetic is allocation-free;
Metrics' optional `recording` feature and the Logging library use `alloc`.
Applications own attribution, labels, clocks, authorization, lifecycle and
endpoints. Logging supplies no global recorder, timer or IC exports. The
[independent worker example](crates/ic-logging/examples/worker.rs) demonstrates
logging without Canic.
The pending [0.19 native metadata contract](docs/migration-019.md) selects Wire
0.8 and requires matching native report dependencies. Release availability and
consumer qualification remain separate from these source changes.
The [0.18 migration guide](docs/migration-018.md) covers combined Logging
text budgets, append receipts, explicit topic matching, borrowed checkpoints,
visitor paging and validated summary/histogram transport. Resolve a published
package containing those APIs before adopting them in consumer dependencies.

[IC Persistence](https://github.com/dragginzgame/ic-persistence) continues to own
governed Memory/Storage integration, `ic-metrics-stable` and the separately selected
`ic-logging-stable` adapter. Logging's passive checkpoints carry validated state;
its heap engine acquires no storage dependency. See [the boundary](docs/logging.md)
for checkpoint, persistence and consumer qualification responsibilities.

## Release and package publication

Workspace releases coordinate both package versions. Registry publication is a
separate maintainer action; the default selects both packages:

```sh
make publish-check
# After reviewing the dry runs and authorizing the uploads:
make publish
```

Use `PACKAGE=ic-metrics` or `PACKAGE=ic-logging` to select only that package,
including when completing a partial publication after checking registry state.
Each command runs the native/Wasm Clippy gate before Cargo publication. Neither
package depends on the other, so there is no publication-order dependency.
Shared Tooling owns package-selection mechanics and dispatch. This repository
declares only its two eligible packages, registry and validation target in the
Makefile. Exact versions come from locked offline workspace metadata; undeclared
packages are refused. Selection and attempt evidence is retained under
`target/publication`, including failed commands. Reconcile that evidence and the
registry before selecting another upload after a failure.
Consumers needing a new Logging API must select a version actually available in
the registry; a merged PR or workspace release tag alone does not supply it.

## Development

Use the pinned Rust 1.99.1 toolchain with rustfmt and Clippy. Both library floors
are Rust 1.91 on native and Wasm. [Local setup](docs/local-setup.md) owns explicit
common-tool preparation through `make install-tools` and offline admission with
`make tools-check`. Checks do not install tools or change dependency selections.

Select the affected package during development:

```sh
cargo test --locked --offline -p ic-logging --lib
cargo test --locked --offline -p ic-logging --doc
cargo run --locked --offline -p ic-logging --example worker
```

Use `-p ic-metrics` for Metrics checks and select `--features recording` for its
optional recorder. The [host guide](docs/hosts.md) owns focused commands and
evidence limits. Aggregate Make checks and full release gates cover both members
and retain their explicit validation authority. Registry publication remains a
separately selected maintainer action per package; this batch performs none.

[Ownership](docs/extraction.md) · [Logging boundary](docs/logging.md) ·
[Changelog](CHANGELOG.md) · [Current handoff](docs/status/current.md) ·
[Contribution rules](rules/contributions.md)
