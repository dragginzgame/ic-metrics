# Shared Tooling 0.10.2 and incoming Host 0.17.2 qualification

This preparation follows released Metrics 0.9.0
`fe4d14f2a24138794878a17a354885a1e7222487` and preserves the incoming Shared
0.10.0 adoption, sanitized evidence distribution and Host 0.17.2 lock selection.
The two upstream reviews retain independent source identities. Cargo versions,
arithmetic/stable implementation, V1 bytes, real index and refs stay unchanged.
Compatible pending notes remain 0.9.1; no release or publication is performed.

## Shared Tooling

The reviewed pushed revision is `626fc2bd3125195520fb870b92abfec11b01454d`,
version 0.10.2. The source sibling has newer dirty work; an isolated clean checkout
of this exact commit supplies the canonical exporter. Its original local-clone
remote needed the verified canonical source URL before exporter admission; the
first refusal changed no consumer files. Export updates four payloads, retaining
104 files and 91 roots without collision overrides or snapshot hand edits.
The two complete default catalogs are byte-identical to the incoming selections.

Only proven literal common catalogs normalize the three Cargo pins for cache keys.
Unrelated pins, comments and record order do not cause misses; compiler/native/
build policy, runner identity and Cargo selections remain bound. Executable,
ambiguous or duplicate assignments retain conservative byte identity without
execution. Focused shared fixtures verify these cases, including CR/glued comment
refusal and no side effect from executable catalog text. ShellCheck passes with
source following; its earlier incomplete-source invocation is retained separately.
Metrics enables no new CI cache, exception catalog, scheduler or fleet helper.
The upstream dashboard-only 0.10.2 changes are outside this selected closure.

## IC Host

The incoming lock already selects artifacts/fs 0.17.2; this task changes no lock
row. Both official registry index rows are non-yanked. Downloaded package hashes
match those rows and the existing lock; embedded source is release
`e3afa6ddf022309e7ba97f6cefb312c48738db4e`, matching upstream main at review.
All 21 artifacts and 22 fs packaged Rust files match that committed source.
The consumed artifacts/fs source has no delta from 0.17.1. New process/tools test
cleanup and IC-limits example retention are upstream scopes, not copied owners.
The crates.io API endpoint returned HTTP 403; official sparse index and package
archives independently establish the recorded checksums, yank state and source.

The inspector's focused build, warning-denied native Clippy and both named CLI
admission/publication tests pass on the selected graph. Arithmetic stays
dependency-free/no_std with native/Wasm Rust 1.85; stable and the private inspector
keep their explicit 1.88 floors. Host source/package verification is separate
from those consumer qualification gates and establishes no canister performance.

## Delivery qualification

Canonical common setup/offline checks, formatting, snapshot, pins and hook checks
pass. Full CI passes in 292 seconds; arithmetic, stable and inspector floor gates
pass in 1, 2 and 1 seconds. Eight checkpoints agree on all 151 frozen/current
inputs, including the private-evidence ignore boundary. The roster SHA-256 is
`cf76d223387cb2c14d1eba6c971b76b44c159da68e9b0f40c852427408a882ba`. Complete logs,
checkpoints and selected source bytes remain under `target/evidence/upstreams-091/`.
The qualified graph is Metrics 0.9.0, Host artifacts/fs 0.17.2, Memory 0.36.2 and
exact collections 0.7.2. No private sibling source or private issue reads are
admitted to this public distribution. The earlier source-bound
[0.10.0 receipt](shared-010-adoption.md) stays immutable.

Final standalone receipt/handoff prose is completed after those gates and receives
separate link, consistency and diff checks. No compiled source, snapshot payload,
manifest/lock, tool pin or fixture changes after gate completion; checkpoints keep
their original source hashes. The extraction table's displayed owning-issue labels
now agree with its verified IcyDB #356, Timers #51 and Blob #65 destinations.

Current open [#70](https://github.com/dragginzgame/ic-metrics/issues/70) retains
native acceptance for the prepared 0.10 adoption after commit/push. The complete
[released 0.9.0 run](https://github.com/dragginzgame/ic-metrics/actions/runs/38392319835)
qualifies that exact delivered source, whose snapshot remains Shared 0.9.10;
it does not qualify the dirty 0.10.2 preparation. Original downstream acceptance
stays with [#10](https://github.com/dragginzgame/ic-metrics/issues/10), and
[archive history disposition](archive-distribution-072.md) stays with
[#72](https://github.com/dragginzgame/ic-metrics/issues/72). No completed criterion
is reopened by unrelated new graphs, and no outstanding obligation is closed
merely from publication.

The public archive `docs/evidence/upstreams-091.tar.gz` and its
`.sha256` manifest retain selected own source, complete
gate logs/checkpoints, the independent public Host package/index verification,
exporter/setup/fixture outcomes and final documentation checks. Prior archives
are hashed, not nested into this receipt. Private evidence, private consumer
source/issue reads and executable tool payloads are excluded.
