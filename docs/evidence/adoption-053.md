# Completed validation dispatch adoption

Compatible pending 0.5.3 is based on released 0.5.2
`2400e918e5a1c89a769768621c0cfe1006067f35`. Package/workspace versions remain
0.5.2. Arithmetic, inspector reports, executable pins and the selected private
Host graph are unchanged.

## Reviewed owner and consumer boundary

Shared Tooling 0.3.3 `d63f0cfaba8ab2961d6012064adbf051c1898bc1` is committed,
matches public main and is refreshed from a clean detached checkout. The existing
94-file selection is preserved; no vendored file is patched. The repair for
[Shared #104](https://github.com/dragginzgame/shared-tooling/issues/104) requires
completed wrapper/body execution before success and admits canonical bounded
decimal nesting depth before arithmetic, log creation or target dispatch.
Incomplete exits retain available source/logs; completed target failures keep
their original nonzero statuses. Release authority and target ordering are unchanged.

[Metrics #51](https://github.com/dragginzgame/ic-metrics/issues/51) reproduces
the old actual-entrypoint bug using the released runner, a harmless scratch
Make target and Bash 3.2 selected throughout the wrapper: symbolic depth returns
zero without invoking the target. An earlier mixed-shell attempt returns one;
it remains separate evidence rather than the Bash 3.2 reproduction.

The existing Metrics release-admission fixture now checks invalid symbolic,
noncanonical, negative, expression and oversized depth values before dispatch or
log creation, plus empty, ordinary nested and maximum valid depth. Its existing
actual release-verify/Make/logger success, first-failure and retention cases
remain intact. The canonical runner fixture passes from its clean owning
checkout on Bash 5/Make 4.3 and genuine Bash 3.2/Make 3.81, including fault-injected
incomplete wrapper/body/summary exits and retained evidence. Both Metrics fixture
profiles pass too. Selected ShellCheck, workflow lint and snapshot verification
pass. These fixtures use harmless or substituted targets; no live release occurs.

The initially selected upstream fixture calls Shared Tooling's own release
metadata fixture and cannot run directly in this consumer. Its failed runs are
retained. Attempting to narrow an existing snapshot with `--file` was refused;
the initial gate then correctly refused the stale optional-file record. The
committed 94-file selection was restored and canonically refreshed and verified.
That provisional selection is removed;
the producer fixture stays with its owner, and consumer regression stays in the
existing release-admission fixture. No new CI target or source-catalog change
is required.

## Scope and records

Read-only review covers all six consumer logger callers. IcyDB, Canic, Backup,
Blob and Toko have the earlier runner; Timers records 0.3.3 in its worktree.
Wrappers retain their local targets and release selections. No caller supplies
a different legitimate depth representation requiring migration. Each consumer
owns adoption and native qualification; none is edited or compiled here.

Records are under `target/evidence/adoption-053/`: source-bound reproduction,
canonical refresh, rejected provisional selection, both producer and consumer
focused profiles and frozen code/graph/pin/workflow inputs. Complete local
validation passes: `ci` (212 seconds), arithmetic `msrv` and inspector
`wasm-inspect-msrv`, preserving all 81 frozen code/graph/pin/workflow inputs.
Final documentation links, snapshot integrity and diff checks pass. The full
gate is recorded in `full-validation.log`; initial selection refusal is
retained separately. New-source delivery/native
acceptance remains in #51. [Released 0.5.2 verification](release-052.md) retains
its own source/graph/CI identity and the earlier #49/#50 obligations.

No dependency resolution, executable installation, package-version change,
commit, push, release, publication, workflow dispatch or sibling mutation occurs.
