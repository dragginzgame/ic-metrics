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
[the tagged handoff](https://github.com/dragginzgame/ic-metrics/blob/v0.2.3/docs/status/current.md#released-019), without relabelling the
earlier Linux preparation or tagged host results.

## Prerequisites and focused checks

- The reviewed shared Make include provides `make install-tools` and offline
  `make tools-check`. Host tool pins live in the reviewed `ci/tool-versions.env`;
  IC executable pins live in `ci/ic-tools.tsv`. Make selects `.tools/host/bin`
  `.tools/ic/bin` and `.tools/rust/bin`. `make check-pins` and release validation never install tools.
  Explicit CI setup installs pinned jq, yq, ripgrep with PCRE2 and cloc before
  fixtures; separate IC setup verifies all six local executables. New hosted
  results must qualify this consumer wiring. `make cloc` reports this workspace;
  `make cloc-tooling` inventories sibling tooling without running their commands.
- rustup with pinned Rust 1.99.0, rustfmt, and Clippy; Rust 1.88.0 for MSRV checks.
- Install the `wasm32-unknown-unknown` target for each checked toolchain.
- Git, GNU Make (`make`), Bash 3.2 or newer, and standard Unix utilities.
- curl, Perl and tar/gzip/xz for explicit local setup; pinned ripgrep and cloc
  are supplied by `make install-host-tools` for tooling
  fixtures. Follow the [system bootstrap instructions](local-setup.md#bootstrap-prerequisites)
  for Linux Mint/Ubuntu or macOS; these packages are separate from pinned local tools.
- The pinned cargo-sort, cargo-sort-derives and candid-extractor set, installed
  explicitly with `make install-rust-tools` and verified offline with
  `make rust-tools-check`. Pins are owned by `ci/tool-versions.env`; interactive
  commands select `.tools/rust/bin` on PATH. Formatting, CI and release
  validation check all workspace manifests before Rust formatting.
- SHA-256 via `sha256sum` on Linux or `shasum -a 256` on macOS.
- Library builds and named arithmetic tests have no third-party dependencies,
  network services or external IC runtime requirements. There is no platform
  reader, IC feature, fixture or PocketIC harness in the current library graph.

Run `make shared-tooling-check`, `make fmt`, `make check`,
`make check-wasm`, `make clippy`, and `make docs-check` for the library.
`make msrv` checks the declared floor on host and Wasm. Select
named tests relevant to the change rather than running the full suite by default.
Published 0.2.0 source `8657c35e441a0f2e6add7f784892e85c9b5e1117` passed
MSRV and all three native jobs in
[CI run 37461297392](https://github.com/dragginzgame/ic-metrics/actions/runs/37461297392).
Earlier results above remain evidence for their original tags, including the
retired reader. Tagged 0.2.1 source `009592f93d4014b079f7c31de51c244bc7df6564`
passes Linux and MSRV in
[CI run 37488116668](https://github.com/dragginzgame/ic-metrics/actions/runs/37488116668),
but both macOS gates stop in the host-tool fixture and their evidence uploads
reject a colon in a retained fixture filename. The 0.2.2 fixes adopt the shared
archive-restoration fixture correction and pack native evidence before upload;
tagged source `057d98813300d741d5782a6cab7c51507f63c55a` passes all three native
hosts and MSRV in
[CI run 37493725240](https://github.com/dragginzgame/ic-metrics/actions/runs/37493725240).
Native retention and uploads pass, and the downloaded tarball/source receipts
and retained fixture outcomes were verified in the
[release record](evidence/release-022.md).

Published 0.2.3 source `89f8c6947fb3253991c65479f04bf14acb676328` has passed
all three native hosts and MSRV in
[CI run 37502954597](https://github.com/dragginzgame/ic-metrics/actions/runs/37502954597).
Its downloaded registry archive, embedded identity and maintained package files
match the tag. All three native tarball receipts, tagged source hashes, retained
fixture outcomes and hidden Git indexes verify, as recorded in the
[0.2.3 release record](evidence/release-023.md).

The prepared 0.2.4 snapshot adopted Shared Tooling `e378671` through its clean
committed export, including its workspace rule. Focused Bash 3.2 Linux release,
snapshot-integrity and installer checks plus locked metadata and formatting
pass in the [adoption record](evidence/adoption-024.md). The upstream native
pass does not establish new consumer native qualification for this dirty batch.

The same prepared 0.2.4 added a separate fixed-size histogram. Focused Linux
host/Wasm Clippy, named histogram and sample-count saturation tests, the public
histogram example, warning-denied documentation and Rust 1.88 host/Wasm checks
pass in [the histogram record](evidence/histogram-024.md). Existing summary-only
callers retain their current arithmetic. These local checks do not establish
macOS execution or IC instruction, cycle or Wasm-size improvements.

Published 0.2.4 at `21e980b3ed4f1a8d9b6203079ef1e457a3fea588` now passes
Linux, both native macOS hosts and MSRV in
[CI run 37587072330](https://github.com/dragginzgame/ic-metrics/actions/runs/37587072330).
Its registry checksum, embedded source, Rust files, original manifest, license,
README and lock match the release, as recorded in
[the 0.2.4 release record](evidence/release-024.md).

Prepared 0.2.5 adopted reviewed Shared Tooling `25e7ce8` (0.1.14), including
the Make execution guard and complete caller dependency set. Focused Linux
GNU Bash 3.2 release/logger/hook rejection, preservation and recovery checks pass
in [the adoption record](evidence/adoption-025.md). Native upstream CI passes all
three hosts; that preparation evidence does not qualify the later consumer release.

Published 0.2.5 at `d8b3a46f24518a033cd36e40bf1f1895099b809f` matches
the official registry archive. Its exact-source Linux, both native macOS hosts
and MSRV jobs now pass in
[CI run 37589261498](https://github.com/dragginzgame/ic-metrics/actions/runs/37589261498).
See [the release record](evidence/release-025.md) for source and qualification scope.

The recorded 0.2.6 inspection found a checkout-local LOC fixture failure before
native Rust gates; [its release record](evidence/release-026.md) preserves that
observation. The prepared repair is bound in [adoption-027.md](evidence/adoption-027.md).
Published 0.2.7 at `09c6786c3b68759ea0ead4d1b987b5a9b472bdbb` now passes
Linux, both native macOS hosts and MSRV in
[CI run 37602306391](https://github.com/dragginzgame/ic-metrics/actions/runs/37602306391),
as recorded in [release-027.md](evidence/release-027.md).

Prepared 0.2.8 adopted reviewed Shared Tooling 0.1.18, including target admission,
LOC fixture isolation and common checkout-local Rust setup. Its focused Linux
checks and original source boundary are recorded in
[adoption-028.md](evidence/adoption-028.md). Published 0.2.8 at
`0eac2b0baa9d03b8f2430a24dfe596d93f5bfc16` now passes Linux, both macOS
architectures and MSRV in
[CI run 37617053341](https://github.com/dragginzgame/ic-metrics/actions/runs/37617053341);
[release-028.md](evidence/release-028.md) binds that separate released observation.

Released 0.2.9 adopts committed Shared Tooling 0.1.19 to reject redirected Rust
installation paths, normalize temporary-directory aliases and preserve changelog
admission/history. Focused source-bound checks and the new IC pin-parser export
are recorded in [adoption-029.md](evidence/adoption-029.md). The subsequent
source-matching CI observation is recorded separately in
[release-029.md](evidence/release-029.md).

Released 0.2.10 adopts committed Shared Tooling 0.1.20 contribution authority.
[adoption-0210.md](evidence/adoption-0210.md) binds the documentation review and
focused checks for that initial adoption. The subsequent
[0.1.22 release-tooling adoption](evidence/adoption-0210-shared022.md) refreshes
the runner while retaining direct-only delivery. Its focused Linux/Bash checks
retain their preparation scope. The subsequent
[0.2.10 release record](evidence/release-0210.md) verifies the actual release's
complete native/MSRV matrix and all three native source/payload receipts.
Arithmetic and supported hosts remain unchanged.
The upstream's real Prettier and failure-upload qualification does not impose
Node/npm or another hosted failure-injection gate on this arithmetic library.

Released 0.2.11 adopts Shared Tooling 0.1.23's release-integrity corrections.
[Its adoption record](evidence/adoption-0211.md) binds passing focused Linux
Bash 5/3.2 release fixtures and static checks to the selected bytes. Upstream
0.1.23 passes all native hosts. The subsequent
[consumer release observation](evidence/release-0211.md) binds the complete
Linux, Intel, Apple Silicon and MSRV matrix and three verified native receipts,
finishing [#28](https://github.com/dragginzgame/ic-metrics/issues/28).

Prepare tools explicitly before local validation:

```sh
make install-tools
make tools-check
make check-pins
export PATH="$PWD/.tools/host/bin:$PWD/.tools/ic/bin:$PWD/.tools/rust/bin:$PATH"
```

`make local-tools-test`, `make pin-tools-check`, `make release-tools-check` and `make hook-check` run
focused tooling fixtures without creating commits, tags or pushes. Release
fixtures substitute Cargo-edit or cheap gates where declared, exercise actual
Git index/selected-commit checks and the actual Make/logger adapter, and preserve
normal nested release selections while isolating independent fixture inputs.
The hook adapter uses the reviewed shared checker with
`--no-dependency-tables`, preserving actual formatting and index/working-edit
checks without introducing test dependencies. `make check-pins` also selects
the shared Cargo inheritance checks for the actual workspace graph.
`bash scripts/release/test-fixture-retention.sh` checks successful scratch cleanup
and unexpected child/assertion failures in release, metadata and formatting-hook
fixtures. Failed inputs, outputs and reported scratch paths remain under
`target/evidence/native-ci/fixture-retention.*/`, included in native CI artifacts.
Native CI also puts ordinary fixture TMPDIR scratch under
`target/evidence/native-ci/scratch/` and includes hidden files so failed Git
index and configuration evidence survive the job. Success cleanup stays
invocation-owned. Bash 3.2 execution on Linux is shell-portability evidence;
supported native macOS qualification still requires the owning CI jobs.
`make ci-evidence-check` runs the shared evidence-archive fixture and the consumer
workflow's actual shell bodies using
substitute Make effects, proving source-first capture and setup failure/archive
IO under Linux Bash 5.2/3.2. It does not install tools, compile product Rust or
execute hosted CI. Native collection follows successful checkout even when setup
fails; raw setup logs, source receipts and every setup outcome remain in the
archive. Failed tool candidates are inside `tool-candidates.tar.gz` in that same
archive, replacing the separate direct candidate upload. Committed qualification
is recorded in [release-029.md](evidence/release-029.md) and tracked in
[#25](https://github.com/dragginzgame/ic-metrics/issues/25).
Released 0.2.12 uses the shared archiver for tool candidates, preserving literal
names, modes and links while excluding candidate Git metadata. The outer archive
retains failed release intent/index state. Partial writes and occupied candidate
archives preserve inputs and recorded setup failure outcomes. The
[preparation record](evidence/adoption-0212.md) binds passing focused Bash 5.2/3.2
checks; this changed collector still needs its own committed native/download
acceptance in [#30](https://github.com/dragginzgame/ic-metrics/issues/30).
Native uploads contain `native-ci.tar.gz` and its checksum; unpack the tarball
to inspect the complete evidence tree, including filenames rejected by direct
artifact uploads. `make format-tools-check` verifies the reviewed cargo-sort pin
and prepared rustfmt offline before either formatting target. Release metadata
uses the shared read-only TOML version reader and prepared local jq/yq.
`make check-doc-links` checks maintained Markdown references with the shared
local-link helper; public URL availability and historical source scope are
reviewed separately. Those tooling changes are included in released 0.2.2.

Actual instruction-counter execution belongs to each consumer's platform and
attribution checks. The old `make reader-check` and its CI artifacts qualify
only the tagged pre-0.2 reader; they are not arithmetic-only qualification.
Current native CI explicitly verifies the common pinned IC tool setup without
running a reader canister, retaining source hashes, outcomes and logs for 30 days.
The opt-in [frozen histogram replay](evidence/histogram-replay-029.md) has separate
Linux PocketIC execution and durable inputs. It is not a CI gate, product reader
or native macOS measurement claim; ordinary library qualification stays separate.

The configured CI runs `make ci` natively on every declared host and
`make msrv` on Linux. Full `make test`/`make ci` gates remain user-owned
outside configured CI unless explicitly requested. Release command stubs run in native CI. Maintainer release preparation requires
cargo-edit and does not implicitly publish or clean artifacts. Native release
command-substitute and metadata/admission/retention fixtures pass on both macOS
architectures at released 0.2.10. Actual interrupted-release execution remains
distinct; substitute fixtures do not demonstrate live GitHub effects.
The later formatter setup and packaging changes are covered by the tagged
0.1.3 native CI evidence above; the earlier 0.1.1 run remains scoped to its tag.
The released 0.2.3 snapshot records 46c0277; 0.2.2 used b32d303,
0.1.9 used a37771f, 0.1.8 used a7efade
and earlier tagged evidence used f52c0e2.
Native CI includes a scratch hook
fixture using this consumer's actual formatting and setup targets. It covers
logical path aliases, selected refresh, unrelated edits, partial staging and
formatter failure isolation. The shared installer normalizes physical paths,
including the correction tracked in
[Shared Tooling #1](https://github.com/dragginzgame/shared-tooling/issues/1).
Focused Linux fixtures and the tagged 0.1.3 native CI pass on their declared hosts.
`make hook-check` runs only these tooling fixtures, with no commits or product
compilation.
