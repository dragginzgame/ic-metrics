# Pending 0.9 overflow API and stable dispatch boundary

This receipt binds the two further approved cuts over the incoming dirty 0.9
preparation at released HEAD `0baae3a49b0bb2c42b32dfe8005b33d07e7e11d7`.
It preserves the incoming Host 0.17.0 manifest/lock selection and the earlier
[#69 error cut](error-cut-090.md); the latter receipt retains its original graph.
Package versions remain 0.8.4. No real index/ref, release or publication is changed.

## Supported boundary

Core flags now use `samples_overflowed()` and `total_overflowed()`; histogram
flags are `bucket_overflowed()` and `overflow_count_overflowed()`. Histogram
`overflow()` still counts samples above the last bound. Remaining error cases
use `SampleCountOverflow`, `TotalOverflow`, `CountOverflow` and `InvalidOverflowFlag`.
Actual overflow stays sticky; an exactly reached cap, measured zero and absence
remain distinct. Numeric restoration and projection invariants are preserved.
Consumers update core getters/error matches; their DTO/wire field names and
owned overflow/admission policies need not follow the Rust names.

The sealed stable supertrait no longer supplies safely callable raw codec,
kind or continuity operations ([#71](https://github.com/dragginzgame/ic-metrics/issues/71)).
One privately constructible zero-sized capability fences those operations while
keeping static generic dispatch. There is no registry, unsafe dispatch, alias,
new dependency or runtime allocation for this capability. The supported generic
`DurableMetric` bound still permits checked store save/load operations.

V1 remains `ICM\x01`, with kinds 1/2/3, the same flag bits/field order/budgets,
unit/reset identity, validated restoration and append-only continuity. Seven
external generic store round trips match byte-for-byte before/after: aggregate,
summary, histogram, count overflow, total overflow, finite-bucket overflow and
overflow-bucket overflow. Existing corruption/regression refusal tests remain.
No scalar-counter kind is added and no retained-data reset is needed.

## Qualification and raw bytes

`make fmt`, warning-denied arithmetic/stable checks and focused tests pass.
Full `make ci` passes in 254 seconds, followed by `make msrv` (1 second),
`make stable-msrv` (2 seconds) and `make wasm-inspect-msrv` (1 second).
Eight checkpoints match all 144 inputs, roster SHA-256
`a90167a30a5261e6e03591cc20ff467eee88261945e3316fa6c2540bc1d66ca7`.
Arithmetic has 51 tests/eight doctests; stable has ten tests, two positive
doctests and five negative architectural-boundary doctests. Public generic
save/load also executes in the external V1 fixture. The initial sandbox socket
failure, focused lint failure and incomplete LTO preparation remain retained;
the complete passing run uses the unchanged source and lock.

Matched Wasm probes use Rust 1.99.0, wasm32-unknown-unknown, opt-level z, fat LTO,
one codegen unit, panic abort and stripped symbols. The stable probes share one
explicit locked Memory build with embedded bitcode and use VectorMemory-backed
maps; they do not execute IC stable memory or measure canister cycles.
All nine before/after modules are byte-identical:

| Probe | Before and after raw bytes |
| --- | ---: |
| Mean | 1,945 |
| Scaled mean | 2,081 |
| Interval | 1,958 |
| Generic ratio | 1,915 |
| Recording | 351 |
| Histogram restoration | 629 |
| Stable aggregate round trip | 51,384 |
| Stable summary round trip | 51,896 |
| Stable histogram round trip | 54,793 |

These are separate wrapper artifacts, not summed application savings, native
timings, IC instruction counts or cycle charges. Earlier #69 reductions retain
their original before/after identities; the current probes preserve that shape.

## Dependencies and consumers

Host artifacts/fs 0.17.0 registry checksums, archive VCS identities and release
peel match committed upstream `93a0ecc2afb7d4b8d8a252a21ed10d7e58b35901`.
All 41 authored source/manifest/README comparisons match that release, rather
than the sibling's dirty 0.17.1 draft. No inspector API/feature change is needed.
The resolved core has no external dependency; stable uses Memory 0.36.1 and
exact collections 0.7.2 on Rust 1.88; the private Host inspector stays separate
on Rust 1.88. No external path package enters the workspace graph.

All six sibling heads, dirty status, authored matches and owning issues are
captured read-only. Private consumer observations remain only in local evidence;
this public archive excludes their source, search excerpts and private issue
reads. Public owning feedback retains the required API adoption. IcyDB, Timers,
Backup and Blob probe old core getter calls
need adoption. Canic currently has no such calls; its independent Host errors
are not Metrics errors to rename. Toko still needs the earlier `record_sample`
cut. The copied IcyDB numeric projection adapts only core calls, preserving DTO
names, and passes a native boundary test and warning-denied Rust 1.85 Wasm
compilation. Transport/platform qualification remains excluded.
The [owning issues](../extraction.md#downstream-contract-checks) retain downstream
selection, exposed type identity and runtime/native acceptance. Linux execution
and Wasm compilation do not qualify hosted macOS or application contracts.

The archive retains captured starting bytes, qualified source inputs, lock,
metadata/features, published Host verification, probes/build scripts/Wasms,
checks/logs/checkpoints, consumer observations/feedback and final prose checks.
Standalone handoff/evidence prose is completed after the compiled gates and
checked for links/consistency/diffs; compiled inputs retain their gate identities.
Archive: `docs/evidence/api-cut-090.tar.gz`; checksum:
`docs/evidence/api-cut-090.tar.gz.sha256`.
