# Decoder cleanup for 0.11.6

Baseline: released 0.11.5, commit
`0efa8d8d7aadb2bcebbd929364a50d3c317924ca`. The retained candidate makes fixed-size
reads consume bytes through the existing bounded cursor operation. V1 bytes,
public APIs, typed refusals and the product dependency graph remain unchanged.

## Matched IC results

The [frozen archive](decoder-cleanup-0116.tar.gz) and its
[checksum](decoder-cleanup-0116.tar.gz.sha256) retain exact source inputs, locks,
probe/driver, raw Wasms, observations and replay commands. These results qualify
this isolated comparison, not later releases or every downstream workload.

| Probe | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| Combined four-type raw Wasm bytes | 333,933 | 333,887 | −46 |

The driver installs separate baseline/candidate canisters. Each exercises all
four stored metric kinds under eight conditions: valid, partial epoch, partial
first payload integer, truncated tail, partial histogram length, trailing byte,
invalid UTF-8 unit and differing identity. Each condition has a zero-call control
and 128-call bracket, with three repeats: 384 updates in total. Result projections
match between variants for every update.

| Instruction bracket, candidate minus baseline | Change per 128 calls |
| --- | ---: |
| Valid four-bound histogram load | −2,432 |
| Histogram truncated-tail or trailing-byte refusal | −2,432 |
| Partial histogram-length refusal | −3,072 |
| Every other tested case | 0 |

The matched deltas repeat exactly across all three repetitions. Zero-call
instruction deltas are zero. Valid histogram loads save 19 instructions per call;
partial histogram-length refusal saves 24. No tested instruction case regresses.
This is not a universal performance guarantee or a library-wide size measurement.
Independent frozen-payload replay reproduced both raw Wasms byte-for-byte, all
384 projection values and every matched instruction delta.

Setup uses the production encoder and real IC stable B-tree map. Seeding all four
rows, deliberate byte mutation and reply encoding occur outside the instruction
bracket. The CSV also retains actual whole-update cycle balance charges; these
include setup and stable writes, so no isolated decoder cycle saving is claimed.
Native substitutes and timing estimates are not used as IC performance evidence.

## Reproduction and identity

Compiler: Rust 1.99.0 (`b940084d7`, 2026-09-28), Linux x86_64 host, raw
`wasm32-unknown-unknown` output with `opt-level=z`, LTO, one codegen unit, stripped
symbols and aborting panics. No Wasm postprocessing is used. PocketIC 16.1.0 has
SHA-256 `b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

The independent harness reuses the locked experiment workspace from the
[0.11.5 admission study](admission-cleanup-0115.md), replacing the library sources
and workload explicitly. Its inherited package labels remain 0.11.4; its newly
measured library sources are the above 0.11.5 baseline and this candidate. The
harness selects Memory 0.43.0, CDK 0.20.3, Candid 0.10.38 and Testkit 0.34.2.
Its transitive graph differs from the product graph; both input manifests/locks
are retained. Product validation separately uses the actual 0.11.5 workspace.
Earlier measurements are not relabeled as this evidence.

After extracting, prepare the recorded compiler/target, locked source cache and
server explicitly, then run:

```sh
METRICS_TARGET_DIR=/path/to/ic-metrics/target/decoder-probes \
POCKET_IC_BIN=/path/to/prepared/pocket-ic bash replay.sh
```

Replay builds offline/locked in fresh scratch, compares both raw Wasms
byte-for-byte and reruns the IC workloads. Inputs and failed/successful attempts
remain intact. Local sockets are required. Only Metrics source, the frozen
experimental fixture and its outputs are selected for distribution; no private
sibling source, issue bodies or search excerpts are included. This comparison
does not establish native macOS or downstream deployment acceptance.
