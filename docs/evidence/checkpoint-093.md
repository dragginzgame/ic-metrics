# Checkpoint and CI qualification for 0.9.3

The task starts at finalized 0.9.2 source
`6bf43295275fc8c7b77d3e129fc1c8a18eb8fd70`. The compatible pending batch
fixes [#76](https://github.com/dragginzgame/ic-metrics/issues/76) and
[#77](https://github.com/dragginzgame/ic-metrics/issues/77), and qualifies
[#75](https://github.com/dragginzgame/ic-metrics/issues/75) and
[#74](https://github.com/dragginzgame/ic-metrics/issues/74).

## Offline preparation and diagnostics

An empty task-local Cargo cache reproduces the missing `ic-memory` failure.
Explicit `cargo fetch --locked` prepares the unchanged committed graph, after
which offline metadata and the actual selected-commit admission fixture pass.
The workflow fetch step is outside the read-only checker. Workflow fixtures
substitute fetch/Make effects and verify refusal order, available diagnostic
readback/checksums and retained complete Git/tool/formatter failure inputs.
The small archive remains available when complete tool archiving fails.
Shared snapshot files, product locks and checker offline admission stay intact.
Linux local execution does not establish new hosted macOS acceptance.

## Allocation and equality

V1 aggregate, summary and histogram sizes are respectively `47 + unit`,
`55 + unit` and `58 + unit + 17*N` bytes. The maximum admitted histogram
uses 4,474 bytes under the 4,608-byte record budget. Private histogram size
projection admits N before multiplication, including direct codec dispatch.
Native capacity, golden-byte and roundtrip assertions establish behavior,
not IC allocation costs. Units and numeric-state admission remain unchanged.

A frozen equality-only IC fixture compares the previous derived equality with
an overflow-first/aggregate-first rejection followed by full equality. Sizes
0, 1, 4, 8 and 256 each exercise empty, unchanged nonempty, changed first
bucket and changed overflow in three repeats, with 64 black-box comparisons
per bracket. Construction, storage load/validation/writes and reply encoding
are outside the instruction bracket. Whole-update cycles are actual balance
decreases, not estimates or conversions; they include construction and ingress.
This measures the isolated equality strategy, not complete checkpoint cost.

| Bounds / case | Baseline instructions | Selected instructions |
| --- | ---: | ---: |
| 0 and 1 / all four cases | unchanged | unchanged |
| 4 / changed first bucket | 61,085 | 4,445 |
| 8 / changed first bucket | 114,331 | 4,443 |
| 256 / changed first bucket | 3,415,965 | 4,445 |
| 256 / empty or unchanged | 7,253,597 | 7,253,853 |
| 256 / changed overflow | 2,845 | 2,845 |

Selected whole-fixture raw Wasm is 293,562 bytes versus 293,546, a 16-byte
increase. An initial unconditional aggregate-first candidate adds 26 bytes
and regresses tiny/overflow-only cases; it is rejected. The selected static
width branch preserves direct equality below four bounds. Unchanged larger
states add three or four instructions per comparison in this experiment.
Full equality still checks bounds, counts and every sticky flag. Native tests
include clipped aggregates whose buckets/flags change without aggregate changes.

The one-off harness reuses the frozen 0.7.2 experiment's locked CDK 0.20.3,
Candid 0.10.38, Testkit 0.34.2 and PocketIC 16.1.0 graph, with current arithmetic
source. Its Memory graph is historical and not exercised by the equality probe.
Rust 1.99 uses opt-level=z, LTO, one codegen unit, stripped symbols and abort
panics, with no Wasm postprocessing. The separately prepared server SHA-256 is
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The product graph remains locked to Memory 0.36.3 and is qualified separately.
No maintained endpoint, Testkit dependency or performance CI gate is added.

## Retained receipt

The scoped [archive](checkpoint-093.tar.gz) and
[checksum](checkpoint-093.tar.gz.sha256) retain exact before/after owner inputs,
local gate logs and the frozen IC source, lock, Wasms and raw results.
No sibling source or private consumer evidence is selected. Replay uses an
explicitly prepared matching server and cache; retained older evidence keeps
its own identities. Full local `make ci`, `make msrv` and `make stable-msrv` pass with all 98
recorded source/configuration inputs unchanged. Native/Wasm Clippy denies
warnings. The two selected IC runs agree byte-for-byte; a fresh archive
extraction independently rebuilds both Wasms byte-for-byte and reproduces the
raw result CSV on a fresh server. ShellCheck, actionlint, archive checksums,
documentation links and the final diff check pass. The initial sandbox-blocked
full-CI attempt and IC startup/tuple-decoding failures remain in retained logs.
Hosted acceptance of the updated workflow remains with #76.
No commit, package version change or release is performed.
