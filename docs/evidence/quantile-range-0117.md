# Quantile range construction for 0.11.7

Baseline: released 0.11.6, commit
`604276df62e898568a1f388851340dd6525a2d9f`. The
[frozen comparison](quantile-range-0117.tar.gz) and its
[checksum](quantile-range-0117.tar.gz.sha256) retain the exact sources, isolated
registry lock, driver, raw Wasms and observations. The candidate is **rejected**;
`MeasurementHistogram::quantile_bucket` retains the baseline implementation.

## Decision

Constructing one shared range after finding the bucket removes repeated source
but increases the cost of common queries. The linked probe shrinks by only
5 raw Wasm bytes (298,288 → 298,283). The instruction regressions grow with the
number of scanned bounds, reaching 65,408 instructions per 128 overflow queries
at 256 bounds. This trade-off does not justify replacing the existing loop's
immediate finite-bucket return and separate overflow construction.

Each cell below is candidate minus baseline **IC instructions in 128 calls**;
three repeats agree. Zero-call controls have zero matched instruction difference.
All 396 updates preserve the exact result sinks, including optional endpoints.

| Query case | No bounds | Four bounds | 256 bounds |
| --- | ---: | ---: | ---: |
| Median | 0 | +384 | +32,640 |
| 95th percentile | 0 | +896 | +65,408 |
| Smallest positive fraction, `1 / u64::MAX` | 0 | −128 | −128 |
| Exact endpoint, `u64::MAX / u64::MAX` | 0 | +896 | +65,408 |
| Just below endpoint, `(u64::MAX - 1) / u64::MAX` | 0 | +896 | +65,408 |
| Wide product below the next rank | 0 | −128 | −128 |
| Wide product above the next rank | 0 | +128 | +128 |
| Empty, valid fraction | 0 | 0 | 0 |
| Count overflow, valid fraction | 0 | 0 | 0 |
| Invalid fraction with count overflow | 0 | 0 | 0 |
| Invalid fraction with no samples | 0 | 0 | 0 |

Actual whole-update cycle charges are recorded separately in `results/costs.csv`.
Their matched differences happen to equal the instruction differences in this
experiment; they were observed independently, never converted or estimated.
Cycles include complete update/setup work outside the instruction bracket and
are not isolated arithmetic cost.

## Inputs and reproduction

The independent fixture uses Rust 1.99.0 (`b940084d7`, 2026-09-28), Linux x86_64,
Wasm `opt-level=z`, LTO, one codegen unit, stripped symbols and aborting panics.
There is no Wasm postprocessing. It reuses the registry-only frozen graph from
the earlier identity study: CDK 0.20.3, Candid 0.10.38 and IC Testkit 0.34.2.
Its unused optional stable member selects Memory 0.44.0. The fixture's local
0.11.5 package labels describe that harness, not the product baseline. The current
product manifest/lock and full baseline/candidate arithmetic sources are retained
separately; the product graph is unchanged.

The prepared PocketIC 16.1.0 Linux x86_64 executable has SHA-256
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The driver installs separate canisters for the two variants, selects 0/4/256
bounds, 11 query cases, 0/128 calls and three repeats. Input construction and
Candid replies sit outside the instruction bracket. This is matched fixture
evidence, not complete downstream or native-host qualification.

The frozen `replay.sh` requires the exact Rust/server identities and prepared
locked registry sources. It builds into a fresh cache under the owning Metrics
`target/`, retires only that invocation's local-package outputs between variants,
and requires byte-identical Wasms. Independent replay reproduced both raw Wasms
and all 396 instruction, cycle and result observations. Focused native Clippy and
23 histogram/admission tests, including constant evaluation, passed for the trial.
The maintained Rust source was then restored byte-for-byte to the released
baseline; no API, error ordering, storage format or caller contract changes.

The archive contains explicitly selected Metrics-owned sources, registry
manifests/locks, probe/driver, build/replay helpers and raw results. Private sibling
source and historical evidence payloads are excluded. `SHA256SUMS` covers every
selected file except itself. The rejected source and its measurements remain
available so the simplification is not repeated without new evidence.
