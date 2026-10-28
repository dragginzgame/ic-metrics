# Current handoff — 2026-10-28

The bounded-recording contribution starts at release 0.16.4, `5a0ac5b`, and
targets compatible release 0.16.5. The maintainer authorized integration, the
standard patch release and package publication after review. The selected scope
is reusable bounded recording and reset
bookkeeping, while consumers retain platform reads, semantic attribution, units,
capacity policy, instance identity, lifecycle and endpoint authorization.

`MeasurementWindow<T>` coordinates replacement of consumer-defined measurement
state and a nonwrapping heap-local reset sequence. Optional `recording` enables
`alloc` and `BoundedMeasurementTable`: first-admitted same-unit identities bounded
by entry count, per-key bytes and total key bytes. Rejected identities are not
allocated; their observations go to an omitted aggregate, not a distinct-name
counter. Repeated identities allocate no new key. Default arithmetic remains
allocation-free and all features remain free of production dependencies.
Measurement values and their restoration APIs remain usable with heap or stable
storage. The bounded table is heap-only; IC Persistence owns durable adapters.

Focused evidence under `target/evidence/recording/` covers six table regressions,
two reset-window regressions, strict library/test lint, and Rust 1.91 Wasm
compilation. No IC instruction, cycle, raw Wasm delta or allocator-overhead result
is claimed. Entry/key budgets bound content, not a measured exact heap footprint.
IcyDB integration is prepared separately in `/tmp/icydb-metrics-recording-20261028`;
its release dependency must select published 0.16.5 and pass focused consumer
checks before adoption. Preserve its unrelated feature work.

Native/Wasm and MSRV Make owners now include the optional recording feature.
Default-feature compilation remains a separate focused check. The review used
focused checks; the authorized standard release runs full `ci` then `msrv` and
retains its own validation evidence under Git's `release-state` directory.
Local Linux checks do not establish fresh macOS qualification.

Review follow-up corrected the release fixture's package/native/Wasm lint
expectations to include `--all-features`. Its focused success and failure paths
now pass with Cargo effects stubbed. Zero-byte limit documentation explicitly
permits an empty key when entry capacity is available. Formatting, all six table
tests, documentation links and diff checks pass; follow-up commands and source
hashes are retained beside the original evidence. Pending 0.16.5 remains a
compatible additive release; no existing measurement API changed.

Historical handoffs and published baseline evidence remain in Git history.
IC Persistence owns the stable adapter, and archive #72 retains its reviewed
residual disposition in `docs/evidence/archive-distribution-072.md`.
