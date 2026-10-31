# Current handoff — 2026-10-31

Source base is `6c54e69` (maintainer commit “0.22.0”). Incoming dirty work was the
release-fixture gate-order fix, its changelog note and handoff. That fix remains
intact. The new requested batch adopts published Wire/Wire Derive 0.11.0 and
updates current migration guidance. All edits remain uncommitted; the index and
own release metadata are untouched. Workspace version stays 0.21.1 and the
existing pending 0.22.0 notes cover both optional metadata and Wire alignment.

## Wire adoption and boundary

Wire and Derive 0.11.0 are published, not yanked and declare Rust 1.91. Official
sparse registry checksums match the two selected lock entries. Package VCS
metadata and upstream main identify release commit
`568196014214a27b1a679b119ffde45284ed5eae`. Compared with 0.10, production Wire and
derive implementation source is unchanged; optional integrations select Platform
0.12. Only the Wire pair changes version/checksum in this workspace's lock.
The initial offline preparation lacked the Wire source; explicit locked fetch
prepared both packages, after which all checks used locked offline sources.

This workspace still selects only native `typescript`, disabled dependency
defaults and the default-enabled optional `native-wire` feature. It enables
neither `platform-types` nor `endpoint`; Platform remains absent. Minimal native,
recording without defaults and Wasm profiles exclude Wire. Logging stays
independent and dependency-free. Numeric APIs, Serde fields, metadata shapes,
arithmetic admission and durable representations are unchanged.

Native reports composing Metrics must align the Wire 0.11 trait identity and one
Metrics identity. Callers disabling defaults explicitly select native-wire when
requesting metadata. The [pending 0.22 migration guide](../migration-022.md), root
and package READMEs, and compiled application prose describe both requirements.
The [0.20–0.21 guide](../migration-020.md) retains the historical Wire 0.10 graph.
Endpoint/Platform consumers coordinate their own 0.12 integration. Downstream
selections were reviewed read-only for IcyDB, Canic, Scheduling/Timers, Backup,
Blob Storage, Toko Miner and Persistence; no sibling was edited or qualified.

## Focused Wire evidence

Evidence is `target/audits/wire-0110-20261031/`:

- Official registry publication/floor/checksums and upstream/package VCS identity
  agree. The lock diff changes only Wire and Wire Derive.
- Formatting and strict Metrics library/test/all-feature Clippy pass.
- Eight native numeric/schema transport tests and all 15 Metrics doctests pass
  at Rust 1.91 with metadata selected. The ignored Node test runs separately.
- Executed TypeScript conformance passes all five independent reports, including
  wide values, exact caps, overflow quality, fixed arrays and typed refusals.
- Four resolved dependency profiles and four minimal Serde tests pass. Pins and
  production declaration admission pass; docs links and diff checks pass.

No full local CI/MSRV suite, hosted run, native macOS, browser, installed IC
runtime, own-version bump, release or publication ran for this dependency change.
Shared Tooling remains reviewed 0.27.11 at
`62edfbd43087a718bf0283e9040676a49211976d`; tools and compiler policy are unchanged.

## Preserved release repair and recovery

The latest release attempt failed in release-tools-check because its standard
fixture omitted metrics-profiles-check from the expected CI sequence. The pending
one-line correction remains in scripts/release/test-standard-release.sh. Its full
release-tools-check, failure/custody cases, ShellCheck, Bash syntax and docs checks
passed before this Wire update; that receipt remains at
`target/audits/release-fixture-order-20261031/` with its original graph/scope.

Original failure evidence remains in
`.git/release-state/validation-failures/20261031T092018Z-286278-0-ci.log`, its
combined log, and `target/evidence/native-ci/fixture-retention.7wYTBk/`. Earlier
JSON/std leakage was fixed in 6c54e69 and the second attempt passed its Wasm link;
its receipts remain at `target/audits/wasm-json-boundary-20261031/`. Preserve all
release state, failed fixtures and artifacts. The maintainer owns the next
commit and complete release validation; these focused results are not that gate.

Canic sediment remains covered by
[#712 — Remove redundant limits from the runtime logging adapter](https://github.com/dragginzgame/canic/issues/712)
and [#100 — Bound observability read work and encoded page sizes](https://github.com/dragginzgame/canic/issues/100).
