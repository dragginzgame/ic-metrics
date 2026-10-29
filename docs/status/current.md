# Current handoff — 2026-10-29

IC Metrics 0.16.5 is released and published from `b997a00`. The release included
full local `ci` and `msrv` validation. [Hosted CI](https://github.com/dragginzgame/ic-metrics/actions/runs/40749223320)
passed MSRV, Linux x86-64, macOS Intel and macOS ARM jobs. The downloaded registry
archive's checksum and clean source provenance were verified; local receipts are
retained under `target/evidence/release-0165/`.

The compatible pending 0.16.6 batch implements both accepted audit rounds:
private histogram bucket-limit extraction, shared ratio decomposition, bounded-table
edge coverage, owner-local restoration tests and this handoff correction. Public
APIs, error precedence, numeric admission, dependencies and package versions remain
unchanged. The follow-up reuses tracked total addition for histogram admission,
stores immutable table identities as `Box<str>`, enables all features for docs.rs,
and documents and tests omission precedence. This cleanup remains uncommitted;
no version bump or release was run.

Final documentation fixes add explicit recording feature selection to focused
validation instructions and Make help. README recording links use qualified
repository URLs so they also work from the packaged README. Default arithmetic
validation commands remain documented separately.

Histogram restoration keeps one admission pass and independently checks maximum
placement, including the unreachable overflow bucket above a `u64::MAX` bound.
Ratio floor and nearest projections share checked decomposition; zero-denominator
precedence and final-result overflow remain explicit. Native-width mean and
quantile specializations retain their existing evidence and are unchanged.

Shape-specific restoration tests now live beneath aggregate, summary and histogram
test modules. Cross-shape restoration cases remain in `state/tests.rs`. Existing
independent sequence and weighted BigUint oracles are preserved. Recording tests
now cover empty identities under zero byte budgets and reuse after clearing a
populated table. All 46 selected tests, strict library/test Clippy, Rust 1.91
Wasm compilation with recording, formatting, documentation links and diff checks
passed for the first round. All 15 relocated restoration test/helper bodies were
verified unchanged. Follow-up validation passed all 27 histogram and 8 recording
tests, strict Clippy, Rust 1.91 Wasm compilation, and 14 doctests each with default
features and recording. The bounded recording example now lives in the compiled
guide, and README links to it. Strict generated documentation includes recording
types; formatting, documentation links and diff checks pass. Earlier ratio and
unchanged cross-shape evidence is reused. Evidence is under
`target/evidence/cleanup-0166/audit-followup/` and its parent; no full release gates
were run.

Measurement arithmetic remains allocation-free and storage-neutral. Optional
`recording` alone enables `alloc` and a heap-only bounded table. Consumers own
units, attribution, limits, clocks, instance identity, lifecycle and endpoints.
IC Persistence owns durable adapters and governed Memory/Storage integration.
The table's key budgets bound UTF-8 content, not exact allocator overhead.
No new IC instruction, cycle, raw Wasm delta or heap-footprint result is claimed.

The prepared IcyDB checkout at `/tmp/icydb-metrics-recording-20261028` selects
published Metrics 0.16.5. Its recorded qualification passed strict Core/CLI lint,
17 focused tests and default-library Wasm compilation on Rust 1.91. Its endpoint
test failed because the pinned Canic revision did not export `canic_icydb::mount!`.
That is the last verified integration result; the Canic adapter selection and
fresh endpoint qualification remain consumer-owned. The checkout's existing work
and evidence were preserved, and no IcyDB release was performed here.

Historical handoffs and published baseline evidence remain in Git history.
Archive #72 retains its reviewed residual disposition in
`docs/evidence/archive-distribution-072.md`.
