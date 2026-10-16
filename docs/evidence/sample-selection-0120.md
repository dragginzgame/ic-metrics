# Sample selection trial for 0.12

Baseline: finalized 0.11.8, source
`05a83629ee8789926db5f3af4528fc5afe689472`. The
[frozen comparison](sample-selection-0120.tar.gz) and
[checksum](sample-selection-0120.tar.gz.sha256) retain the exact baseline and
candidate arithmetic sources, fixture, lock, raw Wasms and observations. The
candidate is rejected; the maintained statistics implementation is restored
byte-for-byte. Its sorted-slice and floating-point summation contracts remain.

## Decision

The candidate uses two order-statistic partitions instead of full sorting,
computes min/max with scans and sums divided observations in input order. It
would remove the sorted-output guarantee and change floating-point rounding
order. The tested integer datasets make those divided values exactly
representable, isolating the ordering-work comparison rather than treating
changed approximate means as equivalent exact outputs.

It adds 1,267 raw Wasm bytes (296,715 to 297,982) and increases every measured
five/eight-sample case. Larger inputs have mixed costs, including substantial
regressions. That does not justify a more complex implementation and an API cut.

Each range is candidate minus baseline **IC instructions in eight statistics
calls**, across four patterns, three fractions and three repeats:

| Sample count | Instruction delta |
| --- | ---: |
| 5 | +3,920 to +6,232 |
| 8 | +9,112 to +9,600 |
| 32 | -14,936 to +62,872 |
| 256 | -660,520 to +530,688 |
| 1,024 | -2,875,832 to +2,078,856 |

Patterns include a deterministic permutation, ascending/descending data and
repeated values with signed zero. Fractions are 1/2, 95/100 and
`u64::MAX/u64::MAX`. Each case also has zero-call controls. All result sinks
agree between variants. Sinks consume every projected field; separate native
candidate tests compared order statistics with an independent sorted reference,
preserved sample contents, and checked input/error boundaries. Those trial-only
tests remain in the candidate source snapshot, not the restored product.

Actual whole-update cycle-balance decreases are retained separately in
`results/costs.csv`; they include allocation, copying and message/reply work
outside the instruction brackets. They are not isolated arithmetic cycle costs
and are never inferred from instruction counts. Neither native timing nor
estimated cycles are used.

## Inputs and replay

The Linux x86_64 fixture uses Rust 1.99.0 (`b940084d7`, 2026-09-28), Wasm
`opt-level=z`, LTO, one codegen unit, stripped symbols and aborting panics, with
no Wasm postprocessing. Its independent frozen registry graph uses CDK 0.20.3,
Candid 0.10.38 and Testkit 0.34.2. The unused optional stable member retains the
earlier fixture's Memory 0.41 graph; it is not compiled for these probes and
does not replace the product's incoming Memory 0.45 selection. Local fixture
package labels identify the harness, not a Metrics release.

The prepared PocketIC 16.1.0 executable has SHA-256
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The driver installs two independent canisters and records 720 updates: 60 cases,
zero/eight calls and three repeats per variant. Copies of the caller's samples
sit outside the instruction brackets. A sandboxed replay first refused local
server binding; that failure remains identified separately. Authorized replay
then rebuilt both Wasms byte-for-byte and reproduced every instruction, actual
cycle and result-sink row.

After preparing the exact compiler, target, registry cache and server, extract
and run:

```sh
POCKET_IC_BIN=/absolute/path/to/prepared/pocket-ic \
  bash replay.sh /absolute/path/to/ic-metrics/target/sample-selection-replay
```

Replay verifies the frozen payload, uses fresh scratch beneath the caller's
Metrics target, builds offline/locked, checks both raw Wasms and compares all raw
rows. Existing successes/failures are retained. `SHA256SUMS` covers every selected
file except itself. The archive explicitly selects Metrics-owned sources,
public fixture code and measurement artifacts; it contains no private sibling
source, search excerpts or issue bodies. It qualifies this rejected experiment,
not a downstream workload, native macOS workflow or production deployment.
