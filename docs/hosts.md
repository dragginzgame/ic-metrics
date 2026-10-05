# Host support and qualification

| Native host | Required support | Configured CI |
| --- | --- | --- |
| Ubuntu 24.04 x86-64 | Library build and development tooling | `ubuntu-24.04` |
| macOS 15 Intel | Library build and development tooling | `macos-15-intel` |
| macOS 15 Apple Silicon | Library build and development tooling | `macos-15` |

The [initial CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37329280018)
at commit `975dabc` passed the native Linux gate and Linux MSRV checks. Both
macOS jobs failed at snapshot verification because Bash 3.2 treated an empty
array expansion as unset; neither reached the Rust checks.

The refreshed Shared Tooling snapshot at
`b8537873ac124ad17b30e32aa23e9006a3e6ec21` includes the upstream verifier fix.
Local snapshot verification passed on Linux. The updated worktree has not yet
run in this repository's native CI, so macOS qualification remains outstanding.
Linux results do not qualify either macOS host.

The library core is `no_std` and targets `wasm32-unknown-unknown` in addition
to native host compilation. A Wasm check proves compilation only, not IC
instruction accounting; runtime measurement needs canister execution evidence.

## Prerequisites and focused checks

- rustup with pinned Rust 1.99.0, rustfmt, and Clippy; Rust 1.88.0 for MSRV checks.
- Install the `wasm32-unknown-unknown` target for each checked toolchain.
- Git, GNU Make (`make`), Bash 3.2 or newer, and standard Unix utilities.
- SHA-256 via `sha256sum` on Linux or `shasum -a 256` on macOS.
- No third-party Rust dependencies, network services, or external IC tools are
  needed by the arithmetic library. Provision toolchains explicitly before offline checks.

Run `make shared-tooling-check`, `make fmt`, `make check`,
`make check-wasm`, `make clippy`, and `make docs-check` for the library.
`make msrv` checks the declared floor. Select
named tests relevant to the change rather than running the full suite by default.

The configured CI runs `make ci` natively on every declared host and
`make msrv` on Linux. Full `make test`/`make ci` gates remain user-owned
outside configured CI unless explicitly requested. Release command stubs run in native CI. Maintainer release preparation requires
cargo-edit and does not implicitly publish or clean artifacts. Native release
adapter execution remains unqualified on macOS; Linux stubs do not close that gap.
