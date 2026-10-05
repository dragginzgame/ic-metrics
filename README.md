# ic-metrics

Repository scaffold for shared Internet Computer measurement primitives.

The workspace contains one unpublished, dependency-free `no_std` library.
It currently exports no public API and is not used by IcyDB or Canic.

The intended boundary is small: saturating measurement summaries and a
well-defined IC instruction-counter interface. Product metric names, inclusive
or exclusive attribution, global registries, persistence, and public reporting
remain owned by consumers. [The extraction contract](docs/extraction.md)
records the source evidence and adoption requirements.

## Development

Install Rust through rustup, Git, GNU Make, Bash 3.2 or newer, and a SHA-256
utility. The pinned toolchain is Rust 1.99.0; the initial MSRV is 1.88.0.
For Wasm compilation, install `wasm32-unknown-unknown` with rustup.

`make help` lists commands. Use `make fmt`, `make check`, `make check-wasm`,
`make clippy`, and `make docs-check` for focused scaffold validation.
Run a named test once maintained behavior exists. `make ci` is the full gate,
requiring an explicit request outside configured CI.

See [agent rules](AGENTS.md), [host support](docs/hosts.md), and
[the current handoff](docs/status/current.md). Shared tooling is vendored at an
exact reviewed revision; normal checks need no sibling checkout.

## Adoption and publication

Creating this repository does not change any consumer dependency. Adoption
requires a concrete API, a reviewed dependency update in each consumer, removal
of superseded implementations, and focused behavioral evidence.

Cargo's initial `0.1.0` metadata is not a release commitment. Publication is
disabled while this is a scaffold. No GitHub remote or published crate exists
as a result of this setup.

When hosted, use an accurate repository description:
"Repository scaffold for shared Internet Computer measurement primitives."
