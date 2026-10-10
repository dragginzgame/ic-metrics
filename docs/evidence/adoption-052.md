# Compatible setup and fixture repairs

Pending 0.5.2 is a compatible tooling batch based on released 0.5.1
`a2f8e6e5e3d57f2d9eaff61791230ac1efbbafb8`. Package/workspace versions stay
0.5.1. Arithmetic, reports, consumer state/identity and endpoints are unchanged.

## Reviewed common owner

The clean detached checkout at Shared Tooling 0.3.2
`c16444bf006f17c5bb4dda5ad070a0f345da9623` supplies the canonical refresh.
All previous 93 selections remain; the explicitly selected advisory README
task brings the manifest to 94 files. Dirty sibling logger/documentation changes
are excluded. Snapshot verification passes. No vendored file is patched.

[#49](https://github.com/dragginzgame/ic-metrics/issues/49) adopts complete-set
read-only admission before installation, authenticated exact host diagnostics
([Shared #101](https://github.com/dragginzgame/shared-tooling/issues/101)),
Cargo descriptor handoff through shared formatting/setup/check/LOC commands
with standalone unsafe-Make-mode refusal
([Shared #99](https://github.com/dragginzgame/shared-tooling/issues/99)), and
completion-aware selected common fixtures
([Shared #103](https://github.com/dragginzgame/shared-tooling/issues/103)).
Pins, the complete 12-executable roster, installation ordering, retained bundles
and offline-check policy are unchanged. Native source/setup/archive fixtures
now distinguish both preflight calls from recursive installation effects, proving
early refusal and retained logs before later phases. Fixture effects remain
substitutes; actual setup reuses the prepared complete local set.

## Metrics-owned false success

[#50](https://github.com/dragginzgame/ic-metrics/issues/50) is independently
reproduced using the actual standard-release cleanup body under Bash 3.2:
injected nounset returns zero and removes evidence. All six owned fixtures now
require explicit completion before accepting a successful exit. Nonzero failures
keep their status; evidence remains with its existing owner.

The existing regression executes each actual cleanup body with nounset,
early-zero and completed-success cases, checking retained diagnostics and normal
cleanup policy. Complete fixture runs exercise child/assertion, publication and
formatting failures. Modern Bash 5/GNU Make 4.3 and genuine Bash 3.2/GNU Make 3.81
focused checks pass, including actual setup owner admission, authenticated host
diagnostics and native source/setup/archive behavior. Selected ShellCheck passes.
The earlier old-profile run overlapped an edit and is discarded; stable-source
reruns use the `focused-*-current.log` records.

## Scope and evidence

Records are under `target/evidence/adoption-052/`, including the canonical refresh,
two focused profiles, actual tool reuse and 81 frozen code/graph/pin/workflow
inputs. Complete current-graph validation passes: `ci` (197 seconds), arithmetic
`msrv` and inspector `wasm-inspect-msrv`, preserving all 81 frozen inputs.
Actual parallel setup reuse, offline checks, formatting and LOC reporting pass
without jobserver warnings. Full logs are in `full-validation.log` and
`actual-current.log`; the initial documentation-link refusal is retained
separately before retry. Documentation links and the final diff check pass.
The incoming private [Host 0.12.2 selection](host-dependencies-0122.md) has its
own archive/source evidence, without changing arithmetic dependencies.

Read-only review finds all six known consumers using released `ic-metrics = "0.5"`
and the common ordered tool include. IcyDB, Canic, Blob and Toko record Shared
0.3.0; Timers and Backup record 0.3.2 in their worktrees. Existing ordered product
extensions remain owning contracts; this review neither edits nor qualifies any
sibling. Canic's actual held HTTP and native qualification remains in its
[#447](https://github.com/dragginzgame/canic/issues/447) and
[#99](https://github.com/dragginzgame/canic/issues/99), linked from
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10).

New-source delivery/native acceptance stays in #49 and #50, separate from
[published 0.5.1 verification](release-051.md). No commit, push, release,
publication, workflow dispatch or sibling mutation is performed.
