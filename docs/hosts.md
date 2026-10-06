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
The maintainer's tagged `0.1.1` revision
`e3d4b0c3b3d19dbaa7b4e5763bea1144cb6570bc` passed
[CI run 37339148886](https://github.com/dragginzgame/ic-metrics/actions/runs/37339148886):
the complete native gate succeeded on Ubuntu 24.04, macOS 15 Intel and macOS 15
Apple Silicon, and the Linux MSRV job passed. This qualifies the arithmetic and
command-stub tooling at that exact revision; later worktrees and live maintainer
release-adapter execution need their own evidence. The initial failed run remains
historical evidence rather than the current qualification state.

The published `0.1.3` revision
`a45c6fb156139efda8cfdfe7fbea1372cc11e559` passed
[CI run 37351475035](https://github.com/dragginzgame/ic-metrics/actions/runs/37351475035):
Ubuntu 24.04, macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV all succeeded.
This qualifies the maintained library and tooling at that tag, including the
f52c0e2 snapshot, manifest formatting and hook fixtures. A separately downloaded
registry-dependent `no_std` fixture also passes locked offline Rust 1.88 host
and Wasm checks on Linux; its archive checksum, sources, license and embedded Git
revision match the tag. These checks supply compilation and tooling evidence,
not IC instruction measurements or native qualification of consumer releases.

The published `0.1.4` revision
`1a144139a2b84e7a389d721febe79aaac3775b0c` also passed
[CI run 37353066599](https://github.com/dragginzgame/ic-metrics/actions/runs/37353066599)
on Ubuntu 24.04, both declared macOS 15 architectures and Linux MSRV. Its registry
archive matches the tagged Rust sources, license and embedded Git identity, and
an isolated registry-dependent `no_std` fixture passes locked offline Rust 1.88
host and Wasm compilation. Consumer worktrees retain their own qualification.

The default library core is `no_std` and targets `wasm32-unknown-unknown` in addition
to native host compilation. A Wasm check proves compilation only, not IC
instruction accounting; runtime measurement needs canister execution evidence.

The 0.1.5 reader has focused Linux runtime qualification in PocketIC
16.0.0: shared reads lie between direct counter-1 reads, increase after measured
work, and retain call-context continuity across a replicated self-call callback.
The [execution record](evidence/ic-reader.md) binds readings to the exact source,
lockfile, server binary and Wasm artifact. This is IC instruction evidence from
PocketIC, not native timing, mainnet evidence or a performance comparison.
Composite-query execution and consumer lifecycle behavior were outside that fixture.
The source in that pre-release record matches the published 0.1.5 library.
The 0.1.5 archive, embedded Git revision, license and source match tag
`bb28e217c5b3069715c1a58322b7900bec7fbb84`; a registry-dependent IC-feature fixture
passes Rust 1.88 host/Wasm checks. The exact-release
[CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/37370018375)
passed the complete native gate on macOS 15 Intel and Apple Silicon, and the
Linux MSRV checks. Its first Linux native job never acquired a hosted runner;
GitHub reported cancellation without executing any repository steps. A targeted
job retry then passed the complete Ubuntu native gate. The successful second
attempt qualifies the 0.1.5 library and development tooling on all declared
native hosts, plus MSRV. The initial runner-admission failure is retained as
evidence; ordinary native CI does not execute the opt-in PocketIC fixture.

The 0.1.6 fixture extends the same focused target to ordinary and composite
queries. Linux PocketIC 16.0.0 execution passes direct-counter bracketing, query
callback continuity and downstream-work exclusion; the reader library source is
unchanged from published 0.1.5. Strict host/Wasm Clippy and Rust 1.88 Wasm example
compilation pass. See the separate [query execution record](evidence/ic-reader-query.md).
That pre-release evidence is Linux-only; the older tagged native CI above proves
library/tooling gates rather than opt-in server execution.

The 0.1.6 workflow explicitly provisions PocketIC 16.0.0 and invokes
`make reader-check` after the native gate on all three hosts. The consumer-owned
[earlier installer](https://github.com/dragginzgame/ic-metrics/blob/v0.1.6/scripts/ci/install-reader-pocketic.sh) selects the exact platform
asset and verifies its SHA-256 before extraction, then checks the version before
returning the binary path. Archive pins were checked against the official
[16.0.0 release metadata](https://api.github.com/repos/dfinity/pocketic/releases/tags/16.0.0).
The harness independently verifies the extracted binary's existing platform pin
before launching the server. Unsupported hosts fail without downloading.

CI prepares the selected lockfile cache explicitly, runs the reader offline and
uploads per-host evidence for 30 days on success or failure. Evidence includes
the checked-out revision, toolchain/host, source and lock hashes, provisioning and
execution logs, step outcomes, server/harness hashes and the built Wasm fixture.
Only the workflow's explicit provisioning step downloads PocketIC; `make ci` and
ordinary local tests continue to ignore the server-dependent reader test.
The [CI preparation record](evidence/reader-ci.md) retains the failed initial
installer attempt and corrected Linux execution. The published 0.1.6 tag at
`6cf2c3851019b1e989e42c5f79a4845ae911dc7f` has passed hosted Linux native CI,
MSRV, reader execution and artifact upload in
[run 37431032911](https://github.com/dragginzgame/ic-metrics/actions/runs/37431032911).
Both macOS native gates, reader execution and evidence uploads also passed.
All four jobs succeeded on attempt 1, completing the declared host/MSRV matrix
for exact 0.1.6, including actual ordinary/composite-query execution on each host.
Downloaded evidence ZIP, source, server and log/Wasm identities were independently
verified for all three hosts. The fixture artifacts and absolute readings differ
by host; each run establishes its own context intervals, without a cross-host
identity or performance claim. Later worktrees and consumer releases retain their
own qualification.
See the separate [release record](evidence/release-016.md)
for exact hosted and registry inputs rather than relabelling earlier evidence.

The exact 0.1.7 source `adf9c3f5676b8ce7983fe2f35724c800d1b00a59` also passed
[CI run 37441090866](https://github.com/dragginzgame/ic-metrics/actions/runs/37441090866)
on attempt 1: all three native jobs and Linux MSRV succeeded, including each
host's explicit reader execution and evidence upload. This review inspected job
and step outcomes without downloading the 0.1.7 artifacts. The runtime library
remains unchanged from 0.1.5; consumer releases and the subsequent uncommitted
Shared Tooling adoption require their own evidence.

The published 0.1.9 source `083254a6a7c24f1e07d1e952a867059746f6feb5` has
passed MSRV and all three declared native hosts in
[run 37452356472](https://github.com/dragginzgame/ic-metrics/actions/runs/37452356472).
Each native job includes the recovery/admission fixtures, explicit local parser/IC
setup, actual reader execution and evidence upload. All three downloaded artifact
ZIPs, bundled logs/Wasm, 21 tagged source hashes per host and IC pins were
independently verified; recorded
harness/server binary hashes remain distinct from downloaded binary proof.
This establishes the adoption's native Linux, Intel macOS and Apple Silicon
qualification. Recovery fixtures use explicit command substitutes and real Git;
they do not claim live interrupted releases. Publication/archive evidence is recorded in
[the current handoff](status/current.md#released-019), without relabelling the
earlier Linux preparation or tagged host results.

## Prerequisites and focused checks

- The a37771f Shared Tooling adoption provides `make install-tools` and offline
  `make tools-check`. Host parser pins live in the reviewed `ci/tool-versions.env`;
  IC executable pins live in `ci/ic-tools.tsv`. Make selects `.tools/host/bin`
  and `.tools/ic/bin`. `make check-pins` and release validation never install tools.
  Explicit CI setup installs the pinned parser pair and prepares ripgrep before
  fixtures; the separate IC setup step verifies all six local executables before
  reader execution. New hosted results must qualify this consumer wiring.
- rustup with pinned Rust 1.99.0, rustfmt, and Clippy; Rust 1.88.0 for MSRV checks.
- Install the `wasm32-unknown-unknown` target for each checked toolchain.
- Git, GNU Make (`make`), Bash 3.2 or newer, and standard Unix utilities.
- curl, Perl, tar/gzip/xz and ripgrep for explicit local setup and tooling
  fixtures. Follow the [system bootstrap instructions](local-setup.md#bootstrap-prerequisites)
  for Linux Mint/Ubuntu or macOS; these packages are separate from pinned local tools.
- cargo-sort 2.1.4, installed explicitly with
  `cargo install cargo-sort --version 2.1.4 --locked`. Formatting, CI and release
  validation check all workspace manifests before Rust formatting.
- SHA-256 via `sha256sum` on Linux or `shasum -a 256` on macOS.
- Library builds and named arithmetic tests have no third-party dependencies,
  network services or external IC runtime requirements. There is no platform
  reader, IC feature, fixture or PocketIC harness in the current library graph.

Run `make shared-tooling-check`, `make fmt`, `make check`,
`make check-wasm`, `make clippy`, and `make docs-check` for the library.
`make msrv` checks the declared floor on host and Wasm. Select
named tests relevant to the change rather than running the full suite by default.
The pending 0.2.0 cut needs its own hosted qualification; earlier results above
remain evidence for their original tags, including the retired reader.

Prepare tools explicitly before local validation:

```sh
make install-tools
make tools-check
make check-pins
```

`make local-tools-test`, `make pin-tools-check`, `make release-tools-check` and `make hook-check` run
focused tooling fixtures without creating commits, tags or pushes. Release
fixtures substitute Cargo-edit or cheap gates where declared, exercise actual
Git index/selected-commit checks and the actual Make/logger adapter, and preserve
normal nested release selections while isolating independent fixture inputs.

Actual instruction-counter execution belongs to each consumer's platform and
attribution checks. The old `make reader-check` and its CI artifacts qualify
only the tagged pre-0.2 reader; they are not arithmetic-only qualification.
Current native CI explicitly verifies the common pinned IC tool setup without
running a reader canister, retaining source hashes, outcomes and logs for 30 days.

The configured CI runs `make ci` natively on every declared host and
`make msrv` on Linux. Full `make test`/`make ci` gates remain user-owned
outside configured CI unless explicitly requested. Release command stubs run in native CI. Maintainer release preparation requires
cargo-edit and does not implicitly publish or clean artifacts. Native release
adapter execution remains unqualified on macOS; Linux stubs do not close that gap.
The later formatter setup and packaging changes are covered by the tagged
0.1.3 native CI evidence above; the earlier 0.1.1 run remains scoped to its tag.
The adoption snapshot now records a37771f; 0.1.8 used a7efade and earlier tagged
evidence used f52c0e2.
Native CI includes a scratch hook
fixture using this consumer's actual formatting and setup targets. It covers
logical path aliases, selected refresh, unrelated edits, partial staging and
formatter failure isolation. The shared installer normalizes physical paths,
including the correction tracked in
[Shared Tooling #1](https://github.com/dragginzgame/shared-tooling/issues/1).
Focused Linux fixtures and the tagged 0.1.3 native CI pass on their declared hosts.
`make hook-check` runs only these tooling fixtures, with no commits or product
compilation.
