# Shared Tooling adoption and LOC fixture repair

## Reviewed source and consumer scope

The clean detached checkout `/tmp/ic-metrics-shared-016-reviewed` selects
`b69507367d45e3db9543359e689e1fcba0467ff4` (0.1.16), with the canonical
HTTPS source remote. The committed diff from adopted 0.1.15 was reviewed:
changelog heading whitespace; logger retention, interrupt handling and Make
status; explicit independent-workspace LOC selection; custom snapshot ownership;
optional frontend hook selection; pinning and canister audit guidance.
Historical saved audits and reports are evidence rather than exported tooling.
The pure Rust consumer does not activate the optional frontend formatter.

The initial canonical refresh added `audits/ic-canister-applications.md` and
verified all 64 declared files. The maintainer then committed the reviewed
fixture correction at `88f1d70cdf671aefb9507d7a81411ed5daa358b3`. A second
clean detached checkout `/tmp/ic-metrics-shared-017-reviewed` supplies the final
65-file refresh, adding `scripts/distribution/refresh-consumer.sh` for the new
tooling-inventory fixture. The resulting snapshot and local links verify. Existing consumer tool pins,
package versions, dependencies and arithmetic source are unchanged. Pending
0.2.7 collects this compatible tooling batch from finalized 0.2.6.

## Prepared canonical fixture correction

[Shared Tooling #48](https://github.com/dragginzgame/shared-tooling/issues/48)
records the actual release CI failure. The authorized correction (validated before its maintainer commit)
to `scripts/ci/test-cloc.sh` selects each fixture Cargo manifest explicitly,
including the relocated checkout, and unsets inherited `CARGO_TARGET_DIR` at
fixture entry for [#47](https://github.com/dragginzgame/shared-tooling/issues/47).
Individual custom-target cases retain their explicit selections. Production Git
root discovery, CI scratch retention and generated-output exclusion remain intact.
No helper, fallback or consumer duplicate is added.

The corrected source passes four focused outside/inside-checkout probes with
an inherited consumer target: Bash 5.2.21 and real Bash 3.2.57 entrypoints, with
nested Bash 3.2. A further checkout-local probe uses Bash 5.2 throughout.
The required upstream portable suite and ShellCheck over CI/developer/distribution
scripts pass. These are Linux/script observations, not native macOS qualification.
The historical 0.1.16 fixture retains the bug. The corrected committed source
is now distributed into this consumer. No snapshot file was hand-patched or
attributed to the wrong commit.

## Consumer checks and preserved evidence

Focused dependency declarations, release command/metadata/admission/recovery and
formatting-hook checks pass under Linux Bash 5.2 and 3.2. The corrected
`make local-tools-test` passes with checkout-local retained TMPDIR and inherited
CARGO_TARGET_DIR, exercising both workspace and tooling-inventory fixtures. The release
fixtures include trailing-whitespace cases and the actual Make/logger failure
boundary, with command substitutes where declared; no real commits, tags,
pushes or publication run. Snapshot and local links pass. No full local CI or
Rust tests are repeated for an unchanged arithmetic library.

Logs, the reviewed executable diff, hosted CI job observations and retained
scratch are under `target/evidence/adoption-027/`. The upstream portable log and
ShellCheck log retain the actual pre-commit source results; consumer logs bind
to the committed corrected snapshot plus the consumer overlay. Owning native CI is still required after the
corrected upstream snapshot reaches committed consumer source.

At inspection, upstream 0.1.16
[CI run 37598153506](https://github.com/dragginzgame/shared-tooling/actions/runs/37598153506)
passes Linux portable regression and lint/security; both macOS jobs are queued.
This does not qualify the subsequent dirty fixture correction. The published
consumer release observation remains separate in [release-026.md](release-026.md).

## Rejection and interrupted attempts

The first refreshed tooling-inventory fixture failed because its newly required
canonical distribution helper was absent from the original consumer file set.
`consumer-inventory-bash32.log` and `/tmp/cloc-tooling-test.TsxDwE` retain that
attempt. Adding the helper through the declared canonical snapshot fixes the
failure; production inventory behavior is unchanged. Native input receipts now
include the helper, logger and changelog finalizer explicitly.

IcyDB's accepted downstream renderer uses the published registry package and
passes focused warning-denied CLI Clippy and three named renderer tests. The
first test attempt was terminated with status 143 after host inspection found
another IcyDB build; its log is preserved. The resumed attempt ran after the
owning build directory was free. Workspace-wide formatting was rejected by
automatic approval review because of unrelated dirty edits; only the renderer
was formatted and its formatting check passes. No performance delta is claimed.
The catalog/lock change selects only ic-metrics 0.2.6 and adds the CLI dependency;
other locked dependencies and Cargo package versions are unchanged. Finalized
root/detail notes are byte-identical to their pre-change contents. The complete
unpublished notes move to 0.267.0 for the CLI output change, with required parser
action and no data/endpoint/reset change. Owning release/native CI remains separate.
