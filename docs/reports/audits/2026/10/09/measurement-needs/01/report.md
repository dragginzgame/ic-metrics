# Sibling measurement-needs audit

## Scope and verdict

**PASS WITH FINDINGS for source-level arithmetic ownership and extension opportunities.**
The review establishes two bounded reporting candidates, not a product correctness
or performance verdict. Neither is an implemented or accepted feature.

Trigger: maintainer request to audit sibling repositories for useful Metrics additions.
Method: [flow convergence and duplication](../../../../../../../../audits/flow-convergence-and-duplication.md),
reviewed Shared Tooling `4e274a2219c0b0cc3af68ec65658b373253518fb`, with the Metrics
AGENTS overlay. Root source is released 0.2.16
`d8276daa3ae8603a5b4e196d0bb5369de54c1216`, plus existing dirty documentation and
the maintainer's Host 0.8.5 lock selection. No arithmetic source is dirty.
The [source inventory](artifacts/source-inventory.txt) captures all inspected
checkout heads and dirty paths; [source hashes](artifacts/inspected-sources.sha256)
bind the particular owner implementations. Siblings were read-only.

The main scope is the six direct consumers, Canic's host comparison policy and
Testkit's benchmark aggregation. Discovery also covers Jobs, Query, Auth, Memory
and Host. This is source inspection and an explicitly labeled IEEE-754 illustration,
not new consumer builds, native CI qualification or IC execution. Existing public
issues were read to distinguish unmet requirements from already tracked adoption.
There is no comparable previous run with this widened scope.

## Owner and flow evidence

| Producer / owner | Retained arithmetic and result |
| --- | --- |
| IcyDB | Admitted inclusive owner/entity instruction spans use `record_sample` and a local maximum; CLI uses canonical `checked_mean`. Candid shapes and exact journal debt stay local. |
| Canic Core | Exclusive invocation-owned endpoint/checkpoint values feed `record_sample`; history separately checks kind, window, adjacency, time, saturation and monotonicity before exposing deltas. |
| Canic Host | Source-bound cost policy checks restart/window identity and explicit saturation; u128 cycle movements and grant reconciliation remain exact owner-specific reports. |
| Timers | Admitted scheduler/work instructions use `MeasurementSummary`; memory-page start/end and growth maxima intentionally do not total page extents. |
| Backup | One `MeasurementHistogram<4>` records successful prepared bytes; its summary is the canonical count/total/latest/maximum source. Six duration summaries are local host diagnostics, not IC cost evidence. |
| Blob probe | Wrapped restoration reads use `record_sample`; bytes have a separate unit. This is test-probe instrumentation, not production library metrics. |
| Toko Miner | Five action-count cohorts use `record_sample` for instruction totals; application outcomes stay local. Its database UI formats one-decimal means from admitted bigint fields. |
| Testkit | Marker pairing derives four u128 deltas; checked aggregation retains totals/min/max/peak end per suite and across suites, then projects f64 averages and percentage changes. |

[Lock observations](artifacts/metrics-locks.txt) separate committed and working
selection. All six working locks select registry Metrics 0.2.16. IcyDB's committed
lock is 0.2.15 and Canic's is 0.2.12; this inventory does not substitute dirty
selection for published/native acceptance.

## Findings and candidates

1. **LOW — checked histogram reporting is the strongest additive API candidate.**
   Backup's existing prepared-byte distribution can support a cumulative count at
   a configured bound, or a nearest-rank quantile bucket. Current accessor callers
   are tests; no production reporting requirement is established. A shared query
   can avoid repeated rank/saturation logic without new state or recording policy.
   Arbitrary within-bucket thresholds and exact percentiles cannot be recovered.
   Empty, count saturation, rational rank and unbounded overflow need explicit
   results; saturated value totals alone must not invalidate usable bucket counts.
   Owner/disposition: Metrics investigation in
   [#39](https://github.com/dragginzgame/ic-metrics/issues/39), activated by one
   selected downstream reporting use and its boundary tests.

2. **LOW — exact fractional report arithmetic needs an owner precision decision.**
   Testkit checks u128 aggregation but casts totals and run counts to f64 in
   `averages()`, then compares those means. Values 9007199254740992 and
   9007199254740993 map to the same IEEE-754 value, hiding their difference in that
   projection. JavaScript Number illustrates this conversion; Testkit was not run.
   Approximate reporting is allowed by the present implementation and raw totals
   remain exact, so this is not an aggregation defect. If exact fixed precision is
   desired, a narrow checked scaled-ratio/mean projection could serve reporting
   without allocation or floating point. Owner/disposition: Testkit
   [#40](https://github.com/dragginzgame/ic-testkit/issues/40) decides precision first.
   Metrics' current u64 saturating summary cannot replace Testkit's checked u128
   aggregation or its fractional output contract.

3. **LOW — distribution adoption offers more immediate value than another accumulator.**
   IcyDB and Canic still retain count/total/max or count/total, rather than per-value
   instruction distributions. Their existing issues
   [IcyDB #312](https://github.com/dragginzgame/icydb/issues/312) and
   [Canic #475](https://github.com/dragginzgame/canic/issues/475) already own workload,
   bounds and instrumentation-budget decisions. Toko's action-size cohorts are
   categories, not instruction-value buckets. A chosen cohort could use the
   existing histogram if a distribution question is accepted; there is no evidence
   for instrumenting every entry by default. No new Metrics recording API is needed.

## Intentional retention and limits

Keep Canic's window/registration/time policy downstream. Extracting only
`checked_sub` would remove almost none of its decision logic. Keep Timers' memory
observations local: replacing them with summed summaries changes meaning or adds
unneeded state. No inspected caller establishes a summary-merge requirement or an
ordering rule for merged `latest`; do not add a merge framework speculatively.

Jobs owns scheduling attempts and durable correlation, not diagnostic recording.
Query projects provider-owned network time series; Auth and Memory arithmetic
primarily validates tokens, storage and allocation authority. These are not new
Metrics ownership candidates. Host's Wasm facts already supply structural evidence.
Asset/web siblings and host wall-clock profiling are outside arithmetic extraction.
No persistent registries, platform readers, endpoints or fleet dashboards are proposed.

No new Wasm-byte, instruction or cycle improvement is measured. Hot-path histogram
adoption requires owning source/lock/workload measurements, not historical synthetic
cost extrapolation. Future native/runtime acceptance stays with consumers. This
audit changes no source, dependency selection, package version or changelog and
does not select a release; compatible new APIs could remain on the 0.2 patch line.
