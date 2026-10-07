# Shared Tooling 0.1.19 repair adoption

## Source and scope

The clean detached checkout `/tmp/ic-metrics-shared-019-reviewed` selects
committed Shared Tooling 0.1.19
`a06e4719e3839b8eefcfb88ec8923aa88eb63ccc`, with the recorded canonical
HTTPS origin. The complete diff from adopted 0.1.18 was reviewed. Canonical
distribution refreshes all 68 declared files, explicitly adding
`scripts/ci/ic-tool-pins.awk` for the updated IC installer. CI's source receipts
include the new dependency. No snapshot file is hand-patched or attributed to
uncommitted source; earlier proposed patches remain preparation evidence only.

[#23](https://github.com/dragginzgame/ic-metrics/issues/23) owns this coherent
repair batch. Pending 0.2.9 is compatible from finalized 0.2.8: package/workspace
versions, lockfiles, dependency/tool selections and arithmetic source remain
unchanged. No sibling repository is modified. Optional PocketIC alignment and
disk-capacity helpers are not activated without a local requirement.

## Maintained boundaries

The shared Rust installer checks the whole fixed installation route, executable
leaves and Cargo receipts before probing tools or dispatching Cargo, and checks
again after installation. Redirected symlinks and wrong file types fail; ordinary
managed host/IC links remain supported. This is path admission, not a sandbox or
protection against concurrent malicious replacement. Ordinary checks remain
offline and do not install tools.

The tool-command fixture physically normalizes its temporary root, so trailing
slashes and directory aliases agree with Make's `CURDIR`. The canonical finalizer
normalizes heading whitespace only for classification, refuses already-dated
targets and preserves retained historical bytes, including absent terminal LF.
Recovery can still admit one matching finalized top section explicitly; metadata
preparation/rollback remains consumer-owned.

The IC installer reuses the shared matrix parser with the same pins and admission
contract. The updated logger additionally retains combined failed-target output
without changing the existing last-target log or original failure status. This
consumer has no private concatenation engine to remove and keeps its existing
storage/target choices.

## Focused qualification

Selected consumer setup/LOC, release command/metadata/admission/recovery and hook
checks pass under Linux Bash 5.2.21 and nested GNU Bash 3.2.57, with checkout-local TMPDIR
ending in a slash and inherited consumer target selection. Separate directory
alias cases cover the actual adopted tool-command fixture. Canonical extended
Rust-path and changelog-history fixtures execute the adopted bytes; actual
consumer metadata and Make/logger adapters retain their separate integration
checks. Cargo/download/Git effect substitutes are declared by those fixtures;
no real release effects occur. The real prepared tool sets are checked offline.

The consumer metadata fixture additionally proves its actual preflight/write
boundary: same-date and conflicting-date targets with varied horizontal
whitespace refuse, preparation failure restores the original manifest, lock and
notes, and successful preparation retains historical bytes without terminal LF.
The complete output is compared as bytes, separately from line-oriented history
checks. These extended cases and controlled child/assertion failure-retention
checks pass under both shells; no product source or real package metadata changes.

Commands recorded in this batch include `make local-tools-test
release-tools-check hook-check`, `make tools-check check-pins
shared-tooling-check fmt-check`, the adopted tool-command fixture under an aliased
TMPDIR, the extended consumer metadata/fixture-retention scripts, ShellCheck,
actionlint and `make check-doc-links`. The clean source's independent snapshot
verifier confirms all 68 declared files. Published changelog history and the
product source/manifests/lock/tool pins compare unchanged against released HEAD.

Source, logs, alias fixtures and exact upstream/consumer CI observations remain
under `target/evidence/adoption-029/`. Earlier failing probes and disposable
candidate results stay under `target/evidence/maintenance-028/` and
`target/evidence/repair-029/`; they are not relabelled as adoption proof.
Snapshot/pins, formatting, local links, followed-source ShellCheck and actionlint
cover the tooling and documentation propagation. Full local CI/product tests
are not repeated for an unchanged arithmetic library.

The released 0.2.8 archive and completed native matrix are recorded separately in
[release-028.md](release-028.md). This new consumer working tree requires its own
committed native qualification. The read-only consumer inspection in
[the handoff](../status/current.md) separates committed/dirty registry locks,
queued/absent native qualification and test-probe versus production scopes;
it does not close downstream attribution or runtime issues from a lock update.
No exact-revision upstream hosted run was returned for `a06e4719` at inspection;
local committed source adoption and focused checks do not assert upstream native
qualification either.
