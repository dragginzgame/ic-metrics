# Checked mean and application guide preparation for pending 0.2.6

This record covers the compatible additions for
[#17](https://github.com/dragginzgame/ic-metrics/issues/17) and
[#20](https://github.com/dragginzgame/ic-metrics/issues/20), on published base
`d8b3a46f24518a033cd36e40bf1f1895099b809f`. Existing uncommitted tooling and
documentation work is preserved, including the reviewed 63-file Shared Tooling
0.1.15 snapshot `bfb50bd0884b5e6c5ee9592056531c6108f96d73`.
One undated pending 0.2.6 entry covers the complete compatible batch from 0.2.5;
Cargo package/workspace versions, root lock and dependency graph remain unchanged.

## Contract and ownership

`checked_mean(samples, total)` supplies one canonical constant-capable
`Result<Option<u64>, MeasurementMeanError>` projection. `(0, 0)` is `None`,
nonempty zero is `Some(0)`, and other nonempty unsaturated means use floor
division in the total's unit. Nonzero total without samples is inconsistent;
otherwise a count or total at `u64::MAX` is unavailable, including exactly
reached caps. The documented error precedence is inconsistent empty pair,
saturated sample count, saturated total. No extra state or saturation flags
are introduced. `MeasurementSummary::mean()` delegates to that function;
histogram users obtain it through the histogram's existing canonical summary.

`MeasurementMeanError` has typed `TotalWithoutSamples`, `SaturatedSamples` and
`SaturatedTotal` variants, with core `Display`/`Error` implementations. Existing
sample recording, saturation, latest and maximum contracts remain unchanged.
The library remains allocation-free, dependency-free and `no_std`. Units,
input provenance, attribution, continuity and reset identity stay consumer-owned.

The packaged `src/application.md` is included in crate documentation. Its
compiled example receives already admitted values and uses a fixed consumer
enum/array, two histograms, a separate row summary and a simple saturating event
count. It documents admission/async/trap boundaries, projection without double
recording, reset/report identity, exact enforcement and measurement limits.
It adds no platform reader, timer integration, persistence or endpoints.
README and extraction/handoff docs distinguish the pending API from published
0.2.5. The consumer doc-link target includes the guide; package selection retains it.

The IcyDB CLI renderer remains the concrete raw-field caller: its existing
`instructions_total() / hits()` does not preserve saturation. Its correction
stays in [IcyDB #313](https://github.com/dragginzgame/icydb/issues/313). Read-only
caller review identifies IcyDB `049e561a843a8d3f4526460fd15876a4a238df10`,
Canic `d9b10b07d610b513aa90d221040a8d27a7fc9ed7`, IC Timers
`a30bfe01d9ce82ba691f5ddd1980f9a4b7c0454a` and IC Backup
`ca19d453e14ca916cc7285f1e3f30d048ec6879c`. All four retain registry 0.2
requirements; no other mean caller was found in the inspected measurement paths.
Working source identities are retained separately from those commits. No sibling
dependency, source, report, build or lifecycle change is claimed.

## Focused qualification

No active build was present before source mutation or selected compilation.
The root uses its own `target/` and locked offline graph. Explicit
`cargo fetch --locked --offline` prepares that graph without downloads.
Linux checks use pinned Rust 1.99.0 and installed MSRV 1.88.0:

- `make fmt`, then warning-denied host all-targets and Wasm library
  `make clippy`. The initial guide had one Clippy documentation-markup warning;
  the corrected guide passes, with the failed log retained separately.
- Named `mean` tests on both toolchains exercise empty/zero, floor division,
  sub-unit means, inconsistent raw pairs, exact caps, both-cap precedence,
  continued observations after saturation and constant evaluation. Four tests
  execute on each toolchain; filtering is recorded rather than a full-suite claim.
- Existing named `histogram::tests` qualifies preserved bounds, recording,
  saturation and constant evaluation at the reused summary boundary.
- Focused crate guide (`--doc 'src/lib.rs'`) and raw projection
  (`--doc checked_mean`) doctests each execute one example. The application
  example is also checked on MSRV. Doctest discovery records the actual selections.
- Host/Wasm MSRV and warning-denied documentation, formatting, independent
  snapshot verification, pins and local links pass.
- Locked offline development package-file selection includes `src/application.md`.
  No package archive was uploaded or package version selected.

Logs, final source/toolchain/caller receipts and commands are retained under
`target/evidence/arithmetic-026/`. The separate
[histogram cost experiment](histogram-cost-026.md) binds actual IC execution
to its own fixture, locks and artifacts; arithmetic unit tests and native
substitutes are not IC performance evidence.

These focused Linux checks do not establish new native macOS or hosted CI for
the dirty batch. No full local tests/CI, commits, tags, pushes, publication,
package version changes or release commands ran. Committed public availability,
owning native CI and consumer use remain separate from working-tree preparation.
