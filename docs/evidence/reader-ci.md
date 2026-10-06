# Reader CI preparation

Focused preparation on Linux x86_64, 2026-10-06, configures explicit PocketIC
execution in the existing native CI matrix: Ubuntu 24.04, macOS 15 Intel and
macOS 15 Apple Silicon. The worktree is based on
`bb28e217c5b3069715c1a58322b7900bec7fbb84` and remains dirty with pending 0.1.6
work. Package metadata is still 0.1.5. No commit, push, release or hosted run was
performed. This records local provisioning and workflow shell execution, not
macOS qualification or successful Actions artifact upload.

## Provisioning and source identities

The installer selects exact PocketIC 16.0.0 assets from the official
[release metadata](https://api.github.com/repos/dfinity/pocketic/releases/tags/16.0.0).
Its three archive digests match that metadata. It restricts the download and
redirect protocols to HTTPS, verifies the archive with the unchanged shared
checksum helper before extraction, checks the version and returns an absolute
path. Each invocation uses a fresh directory under this repository's target,
preserving prior downloads and failures. The existing Rust harness independently
checks the extracted binary digest and version before server startup.

The upload action is pinned to the official `actions/upload-artifact` v7 commit
`043fb46d1a93c77aae656e7c1c64a875d1fc6a0a`, verified against its GitHub tag reference.
Evidence artifacts are named by runner and run attempt, retained for 30 days,
and contain inputs, source hashes, provisioning/execution logs, step outcomes,
artifact hashes and the Wasm fixture. The reader step uses locked offline
dependencies after explicit cache preparation. Existing local tests remain opt-in.

| Repository-relative input or artifact | SHA-256 |
| --- | --- |
| `.github/workflows/ci.yml` | `15f53a0632e98455edd27d497668fd37b933ec60bbf8d2c78317631ec9fe80d0` |
| `scripts/ci/install-reader-pocketic.sh` | `bf97d743ae168e0531570457c03599218794aec79ae3cb8d59ffbd2dfbfdd636` |
| `scripts/ci/test-reader-provisioning.sh` | `6fd3d21c353766dfb60a9c09ac5f7fed315106d47f2133843fc1ad782e1e2cd5` |
| `target/evidence/reader-query/ci-install.log` | `440a8cca32dcd41f7b7185da54f0ca049489ce7d940fb7d90e060ed77d5c14d1` |
| `target/evidence/reader-query/ci-install-retry.log` | `6c26317452ca04cea25d9d44e46160f2c2f9727dcdc11f2d8bb159481bc847dc` |
| `target/tools/reader-pocketic.2UyjEN/pocket-ic-x86_64-linux.gz` | `268ba79ec7fe9a563a575adf4983c69627093cce2711d142e476cdc7ad04249e` |
| `target/tools/reader-pocketic.2UyjEN/pocket-ic` | `69e324bdb68d32d878b7a9504b1379f08f8d1921272bacb065b0fabb3d0f3792` |
| `target/evidence/reader/qualification.log` | `384b7e613751bbc5d4663ada2bd8bec9ec48aad23ce0ffb00168c3a25a45b50a` |
| `target/evidence/reader/outcome.txt` | `4805506cb4f4922f87cbff1e8afe62c116f47c5bf14ae0337432bafc64b45e9c` |

Rust, selected dependencies, library/fixture/lock inputs and Wasm identities are
unchanged from the [query execution record](ic-reader-query.md). This preparation
did not rebuild a different source or replace that earlier log.

## Attempts and checks

The initial helper invocation downloaded and verified the Linux archive, then
exited 101 when invoking `--version`: PocketIC requires the executable basename
`pocket-ic` or `pocket-ic-server`; the initial helper used `pocket-ic.candidate`.
The log above and archive/candidate under
`target/tools/reader-pocketic.5WrAuz/` are retained. That initial source differs
from the corrected helper identified above; it is not a successful installation
or instruction-reader execution.

The corrected helper uses `pocket-ic` inside its fresh directory and succeeds:

```sh
bash scripts/ci/install-reader-pocketic.sh > target/evidence/reader-query/ci-install-retry-path.txt 2> target/evidence/reader-query/ci-install-retry.log
```

The exact `reader_execution` and `Retain reader artifacts and outcome` run bodies
were loaded from the workflow and executed locally with Bash's `-e -o pipefail`,
using that verified binary and two Cargo build jobs. The single named PocketIC
test passes its update, replicated callback, ordinary query and composite-query
checks. Instruction readings match the earlier query record, including the
584,958-instruction caller interval while downstream work grows from 438 to
10,000,455 instructions. The outcome, execution log, hashes and copied Wasm are
retained under `target/evidence/reader/`. CI input/provision outcome variables were
supplied locally after separate checks; this was not execution of the entire job.

Focused static and rejection checks pass:

```sh
actionlint .github/workflows/ci.yml
shellcheck scripts/ci/install-reader-pocketic.sh scripts/ci/test-reader-provisioning.sh
bash scripts/ci/test-reader-provisioning.sh
bash scripts/ci/verify-shared-tooling-snapshot.sh
```

The maintained rejection fixture substitutes host detection and download responses,
but uses the real checksum helper: untrusted bytes on all three selected hosts
are rejected before extraction; an unsupported host never downloads. Its retained
scratch evidence is `target/reader-provision-fixture.AgdDfR/`.
A separate controlled failing `make` substitute exercises the actual workflow
execution and retention bodies in `target/reader-ci-failure.sih_syr6/`: exit 7 is
preserved through `tee`, and the failed log, outcome and hash survive. These
substitutes qualify rejection/control flow, not IC measurements or macOS execution.

## Remaining qualification

Full local CI and maintainer release gates were not invoked. Hosted cache
preparation, native macOS PocketIC execution and artifact upload await configured
CI after maintainer commit/push. Automatic execution is configured in source,
but those hosted behaviors have not yet been observed. Follow-up remains in
[reader extraction #3](https://github.com/dragginzgame/ic-metrics/issues/3).
