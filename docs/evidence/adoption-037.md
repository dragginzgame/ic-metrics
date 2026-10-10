# Shared Tooling 0.2.10 formatting adoption

This records the initial 0.2.10 adoption. The later committed 0.2.11 refresh and
hidden-mode repair have [separate supplemental evidence](adoption-037-make.md).
Initial source identities and failed upstream observations below remain unchanged.

Pending compatible Metrics 0.3.7 adopts committed Shared Tooling
`43a0dc46cdc3c77e70a68e192561642ed50a3e0f` from a clean detached clone with the
canonical HTTPS remote. The canonical exporter adds the required
`scripts/ci/run-formatting.sh` companion, taking the selection from 92 to 93
files. The upstream working tree's Make admission repair is excluded.

The shared Rust include retains prepared tools, offline operation, sorter-before-
rustfmt ordering and check-only flags. Its reporter runs that existing sequence
once with exact arguments. Success prints `Formatting... ok` or
`Checking formatting... ok`; failure prints its status and the complete retained
log path. Successful invocation-owned logs are removed. Failure stdout/stderr
remain under `RUNNER_TEMP`, otherwise `TMPDIR` or `/tmp`.

Actual hook and isolated release/admission fixture inputs now carry the new
companion. Native source receipts include it. Metrics' native collector uses the
existing shared archiver to put remaining reporter logs in
`formatting-logs.tar.gz`, then hashes that payload before creating the outer native
archive. This covers the workflow's runner temporary directory outside its
fixture scratch tree. The shared failure action also receives the canonical
formatting-log selection; no vendored file is patched.

Focused Linux qualification passes under Bash 5 and genuine Bash 3.2.57:

- The exact owner's Make formatting fixture verifies command order, concise
  success, complete retained stdout/stderr, exact arguments/status, and refusal
  after missing/wrong prerequisites or a failed sorter, within its declared
  Make-mode cases.
- The actual consumer hook fixture retains selected index refresh, partial-stage
  refusal, unrelated edits, lock preservation and actual formatter failure.
- Consumer release/admission and fixture-retention checks preserve local policy,
  selected-commit metadata, logger/cache routing and failures with their declared
  Git/Cargo/command substitutions.
- The native-evidence fixture executes actual workflow bodies and the actual
  reporter with substituted Make/formatter effects. A command returning 43
  retains stdout/stderr outside scratch; both are recovered byte-for-byte from
  the checksum-verified outer and inner archives, with failed native outcome.
  Existing setup/candidate/archive-refusal cases remain covered.
- Canonical distribution checks, selected ShellCheck, workflow lint, actual
  prepared check-only formatting, snapshot/pin/tool checks, local links, diff
  checks and preservation hashes pass. Actual check output is one success line.

[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/38033580922)
passes portable regression and real formatter/hook steps on all three native
hosts, plus lint/security. Its overall Intel job fails later at quill installation:
curl reports a DNS resolution timeout after 15 seconds. Later native IC/failure-
retention qualification is skipped there; this review does not relabel that gate
as successful or rerun it. Local Bash 3.2 is not Metrics native macOS acceptance.

The optional new registry metadata observer is unselected: Metrics has no owning
production caller for that helper. Inspection/publication policy remains local.
Fleet reports and unrelated helpers remain upstream. Arithmetic, inspector
production source/report contract, Cargo manifest/lock and pins are unchanged.
Package/workspace versions remain 0.3.6; no consumer reset/reinstall is required.

The committed execution include/probe remain unchanged from Shared 0.2.9.
[Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30)'s previously
reproduced command-line-hidden mode gap is not repaired by this adoption.
[Metrics #44](https://github.com/dragginzgame/ic-metrics/issues/44) retains that
boundary and the changed consumer source's delivered/native acceptance for
[Shared #92](https://github.com/dragginzgame/shared-tooling/issues/92).
No consumer parser or private reporter is introduced.

Inputs and focused logs are under `target/evidence/adoption-037/`; native
fixture archives remain at the paths reported by their logs under
`target/evidence/native-ci/`. Released 0.3.6's
[complete acceptance](release-036.md) applies to its prior source/graph.
No Rust edit, product compilation, full local CI/product suite, dependency
resolution, version bump, commit, push, workflow rerun, release or publication
occurs during this preparation.
