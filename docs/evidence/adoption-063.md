# Shared Tooling 0.4.1 adoption for Metrics 0.6.3

This initial preparation stage is superseded by the
[0.5.0 adoption](adoption-063-store.md) in the same unreleased batch. The results
below retain their original source and qualification identity.

Metrics base is released 0.6.2
`4dcbe1955b4f90b42ccab8a82ae634291ef1797d`. The adopted Shared Tooling source is
committed/public 0.4.1 `5ab05317f8da10c6388dc9096780131459d9db71`. A clean detached
checkout supplies the canonical exporter; preview reports 16 updates, 78 unchanged
files and no missing companions in the existing 94-file selection. The resulting
snapshot verifies. Local inputs and logs are retained under
`target/evidence/adoption-063/`.

## Contributor setup contract

The common Rust tools use versioned installation slots, Cargo receipts, observed
byte identities and version admission. `.tools/rust/common/bin` projects a complete
set only after all three tools pass; failed partial upgrades retain the previous
complete set. Metrics-owned CI, native-evidence fixture and shell/documentation
callers use this PATH. The shared failure-evidence action retains the full physical
Rust tree without following its internal links. Old in-place tools, slots and
failed attempts remain available; no legacy fallback or automatic deletion is added.

Existing checkouts need explicit `make install-rust-tools`, then offline
`make rust-tools-check`. Standalone setup needs prepared shared host tools;
`make install-tools` already orders host, IC and Rust setup. Product-selected CLI
paths and IC Testkit's PocketIC ownership remain unchanged. There is no duplicate
consumer-owned Rust installation recipe to retire.

This is compatible 0.6.3 work at the released library's consumer boundary.
Arithmetic source, APIs, runtime behavior, dependency/executable pins, supported
consumer build requirements and both Rust floors remain unchanged. Metadata stays
0.6.2; no sibling source, staging, commits, versions, tags or releases are changed.

## Qualification

Real Linux installation passes for the pinned cargo-sort 2.1.4,
cargo-sort-derives 0.13.0 and candid-extractor 0.1.6. Offline admission passes.
Repeated explicit setup passes with Cargo replaced by a refusing recorder and
zero Cargo dispatch, proving reuse of the admitted slots. All 2,329 pre-existing
regular files under `.tools/rust` retain their original checksums, including the
old in-place tools, receipts and build evidence.

Local tool fixtures, CI evidence fixtures, release adapters, the real formatting
hook, formatting checks, selected ShellCheck and workflow actionlint pass.
The common-slot fixtures cover partial upgrades, byte/receipt corruption, locks,
redirected paths, selected binary/example admission and failure retention with
substitute Cargo. Genuine Bash 3.2.57/Make 3.81 on Linux also passes Rust installer,
CI evidence, formatting-hook and formatting checks. These are local checks;
substitute effects and Linux Bash 3.2 do not establish hosted or native macOS proof.

The explicitly approved full `make ci` passes in 182 seconds. Warning-denied
native/Wasm Clippy, Rust 1.85 native/Wasm arithmetic checks and Rust 1.88
all-target inspector checks pass. All 82 frozen code/graph/pin/Make/workflow/snapshot
inputs remain unchanged across delivery validation. Logs, input hashes, observed
installation receipts, prior-file preservation and the actual CI outcome remain
under `target/evidence/adoption-063/`.

Read-only caller review covers IcyDB, Canic, IC Timers, IC Backup, IC Blob Storage
and Toko Miner. Each setup route selects its own checkout and keeps product
extensions locally. `caller-inputs.json` binds reviewed HEADs and committed/current
hashes of each selected Make, installer and CI input. Several reviews include
separately identified working edits; they do not claim committed-source acceptance.
No measurement attribution, state, API, codec, persistence or endpoint changes
are required by this contributor tooling adoption.

## Native acceptance gaps

The exact-source [Shared CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/38130259856)
passes real Linux installation/offline checks and the portable suite, then fails
its native-retention qualifier. Its Cargo substitute still requires nine arguments;
the selected common installer passes thirteen. Its build-marker path and offline
refusal assertion also retain the old contract. The Rust portion was reproduced
locally with the unchanged upstream substitute and the adopted real Make/installer,
separately from the online Quill/artifact qualification. The failure log and focused
reproduction remain retained. The
[upstream report](https://github.com/dragginzgame/shared-tooling/issues/118#issuecomment-6107926837)
identifies the required qualifier update without changing sibling files.

The snapshot-owned host guide also retains old build-only collection and
executable-only offline-check descriptions; the
[documentation report](https://github.com/dragginzgame/shared-tooling/issues/118#issuecomment-6107900514)
leaves correction with its canonical owner. Upstream hosted native acceptance
and subsequent Metrics hosted acceptance remain separate from local checks.
[#60](https://github.com/dragginzgame/ic-metrics/issues/60) tracks adoption and native
acceptance; [Shared #118](https://github.com/dragginzgame/shared-tooling/issues/118)
owns the installation engine and upstream host qualification.
