# Admission cleanup for 0.11.5

Baseline: released 0.11.4, commit
`9665613f05f6477fe97ad60562e54185ed875aac`. Candidate identities are the frozen
sources and hashes in the [archive](admission-cleanup-0115.tar.gz), verified by
its [checksum](admission-cleanup-0115.tar.gz.sha256). This is an isolated matched
experiment, not qualification of every consumer or a later release.

## Decisions

| Candidate | Decision | Observed trade-off |
| --- | --- | --- |
| Admit quantile inputs once, then calculate the rank | Retain | Fewer instructions in all 11 tested cases; raw probe Wasm falls by 99 bytes. |
| Validate ASCII durable units directly as bytes | Retain | Valid 1/64-byte units cost less; invalid UTF-8 costs more. Raw probe Wasm falls by 36 bytes. |
| Remove the early overflow-bucket flag check | Reject | Saves 44 raw Wasm bytes, but rejecting malformed 256-bound input costs over 3 million extra instructions per 128 calls. |

Public APIs, fraction/error priority, empty versus zero observations, constant
evaluation, identifier alphabet/limits and the stable V1 format are preserved.
The overflow guard deliberately remains despite overlapping the later scan.
No shared rank module, dependency change, persisted-data reset or host migration
is introduced. The core remains allocation-free, dependency-free and `no_std`.

## Measurements

Each entry below is candidate minus baseline **IC instructions inside a bracket
of 128 calls**. Three repeats have the same matched delta. Zero-call controls,
raw observations, observable result sinks and actual whole-update cycle charges
are retained in `results-attempt2/costs.csv`.

| Quantile input | Instruction delta |
| --- | ---: |
| Seven exact nonempty narrow/wide product cases | −4,736 to −5,120 |
| Empty, valid fraction | −512 |
| Overflowed count, valid fraction | −14,592 |
| Invalid fraction, empty or overflowed count | −1,280 |

The first rank attempt checked count overflow before emptiness. It increased
empty-case cost by 384 instructions per 128 calls. Its source, Wasm and raw rows
remain separately identified as attempt 1. The retained attempt checks emptiness
first, preserving error priority and improving that case too.

| Stored unit input | Instruction delta |
| --- | ---: |
| Valid 1-byte / 64-byte unit | −10,624 / −50,432 |
| Different valid identity | −10,624 |
| Invalid UTF-8, 1-byte / 2-byte unit | +12,800 / +12,800 |
| Valid UTF-8 containing a forbidden non-ASCII character | −13,056 |
| Forbidden ASCII space / empty / oversized unit | −10,624 / −4,352 / −52,480 |

The byte validator avoids a redundant UTF-8 scan on valid records. It is not a
universal speed-up: invalid UTF-8 takes 100 extra instructions per load in this
fixture. Unit admission remains bounded at 64 bytes. An exhaustive single-byte
test preserves typed malformed/identity errors, retained bytes and zero writes.

For the rejected overflow-guard removal, valid restoration saves 514–1,792
instructions per 128 calls across 0/4/256 bounds. Malformed overflow flags instead
add 16,126 instructions at zero bounds and 3,022,976 at 256 bounds. Combining an
invalid finite flag with the invalid overflow flag still adds 3,015,296 at 256
bounds. Equal typed outcomes do not justify this refusal-cost regression.

Raw baseline/candidate Wasm bytes are 295,031/294,932 for rank,
294,875/294,831 for rejected restoration, and 324,433/324,397 for unit loads.
These are three separately linked probes, not additive library-size savings.

## Inputs and scope

The frozen independent fixture uses Rust 1.99.0 (`b940084d7`, 2026-09-28), Wasm
`opt-level=z`, LTO, one codegen unit, stripped symbols and aborting panics; there
is no Wasm postprocessing. It locks IC Memory 0.43.0, CDK 0.20.3, Candid 0.10.38
and IC Testkit 0.34.2. Its experimental transitive graph is distinct from the
product lock; both manifests/locks are retained. An initial inconsistent fixture
lock failed admission; its log and pre-preparation lock remain alongside the
explicit offline fixture preparation. Product dependency selection is unchanged.

The prepared Linux x86_64 PocketIC 16.1.0 server has SHA-256
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The fixture installs independent canisters and compares all result sinks. Stable
unit probes use the real stable B-tree map. Construction, deliberate byte
corruption and reply encoding sit outside the instruction bracket. Actual cycle
charges include complete update/setup work and are not isolated arithmetic cost.
No native timing or estimated cycles are reported.

## Frozen replay

Extract the archive, prepare its locked dependencies and compiler/target, then
run from the extracted directory:

```sh
METRICS_TARGET_DIR=/path/to/ic-metrics/target/admission-probes \
POCKET_IC_BIN=/path/to/prepared/pocket-ic bash replay.sh
```

Replay uses fresh scratch copies under the selected target, checks compiler and
server identity, builds offline/locked, compares all six raw Wasms byte-for-byte
and reruns the IC comparison. Original attempts remain intact on success/failure.
PocketIC execution needs local sockets. The payload explicitly selects Metrics
source, the one-off probe/driver, locks, raw artifacts and observations; it contains
no private sibling source, search excerpts or issue bodies. This experiment does
not qualify native macOS workflows or downstream deployment behavior.
