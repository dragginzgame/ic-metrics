# Host support and qualification

| Native host | Required support | Configured CI |
| --- | --- | --- |
| Ubuntu 24.04 x86-64 | Library build and development tooling | `ubuntu-24.04` |
| macOS 15 Intel | Library build and development tooling | `macos-15-intel` |
| macOS 15 Apple Silicon | Library build and development tooling | `macos-15` |

The matrix declares required support, not passing evidence. CI has not run for
this new repository. Linux results do not qualify either macOS host.

The library core is `no_std` and targets `wasm32-unknown-unknown` in addition
to native host compilation. A Wasm check proves compilation only, not IC
instruction accounting; runtime measurement needs canister execution evidence.

## Prerequisites and focused checks

- rustup with pinned Rust 1.99.0, rustfmt, and Clippy; Rust 1.88.0 for MSRV checks.
- Install the `wasm32-unknown-unknown` target for each checked toolchain.
- Git, GNU Make (`make`), Bash 3.2 or newer, and standard Unix utilities.
- SHA-256 via `sha256sum` on Linux or `shasum -a 256` on macOS.
- No third-party Rust dependencies, network services, or external IC tools are
  needed by the scaffold. Provision toolchains explicitly before offline checks.

Run `make shared-tooling-check`, `make fmt`, `make check`,
`make check-wasm`, `make clippy`, and `make docs-check` for the scaffold.
`make msrv` checks the declared floor. Once behavior is implemented, select
named tests relevant to the change rather than running the full suite by default.

The configured CI runs `make ci` natively on every declared host and
`make msrv` on Linux. Full `make test`/`make ci` gates remain user-owned
outside configured CI unless explicitly requested. No release or deployment
workflow is implemented. Future external-tool and filesystem/process behavior
requires native qualification beyond these empty-library checks.
