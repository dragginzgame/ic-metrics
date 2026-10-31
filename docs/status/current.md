# Current handoff — 2026-10-31

Source base is merged PR #102, `691fb85ace5125e0f941def3acb95a21d3ec1a1d`.
The incoming checkout was clean. Workspace metadata stays 0.21.1; pending notes
remain 0.22.0 for the optional native metadata contract. This batch adds its
continuous profile coverage and simplifies log message construction. Changes are
local and uncommitted; the index and release metadata remain untouched.

## Accepted work and implementation

The maintainer accepted minimal-profile Serde execution, resolved dependency
checks, one logging cleanup and issue acceptance reconciliation. Canic sediment
already has owning issues; no sibling repair or release execution was selected.

`wire::serde_tests` runs independently of `native-wire`. Four tests cover empty,
zero, wide totals, exact caps and actual loss; 0/3/37 fixed bounds; invalid numeric
state; and missing/unknown fields. They reuse the Rust report fixtures from the
executed TypeScript test while retaining independently declared JS expectations.
Serde-only checks formerly nested under native Wire were moved to this owner.

`serde_json` is now an explicit development dependency, using its already locked
1.0.154 version. The lock changes only Metrics' dependency list; no package
versions were upgraded. Production dependency declarations remain unchanged.

`make metrics-profiles-check` is part of CI after declaration admission. It walks
resolved normal/build edges from locked, offline Cargo metadata for native
minimal, recording without defaults, native default and all-feature Wasm.
Minimal/recording/Wasm closures exclude Wire and derive; default native includes
one pair. Every profile excludes Platform and keeps Logging dependency-free.
Development codec dependencies are excluded from these production closures.
The same target then executes the four Serde tests with defaults disabled.

Logging append now constructs its message from the prefix/suffix already admitted
for retained-text accounting. UTF-8 truncation, budgets, refusals, eviction and
watermarks retain their prior behavior; no public API or retained layout changes.

## Validation and evidence

Local evidence is `target/audits/profile-and-logging-20261031/`:

- Formatting and warning-denying Metrics/Logging library/test Clippy pass with
  all features. The first attempt's unused import was removed; its log remains.
- Four minimal Serde tests pass on Rust 1.99.1 and separately Rust 1.91.0.
- All four resolved profile checks pass. An isolated manifest fixture passes
  before mutation and refuses recording accidentally selecting native Wire.
- All 29 Logging tests pass, including the fixed and seeded event-history models.
- Eight native transport/metadata tests and the separately selected five-report
  Rust/TypeScript conformance test pass. Node remains 24.21.0, with no npm inputs.
- Dependency pins, production declaration admission, docs links and diff checks
  pass. No full local CI/MSRV suite or hosted run covers these dirty edits.

The unchanged source base's complete
[CI run 41185478330](https://github.com/dragginzgame/ic-observability/actions/runs/41185478330)
passed Linux, both macOS native hosts, MSRV and TypeScript. That evidence belongs
to 691fb85, not this new working tree. Earlier receipts remain under
`target/audits/repo-improvements-021-20261030/` and
`target/audits/wire-0100-20261030/`, with their original graphs and scopes.
Shared Tooling stays reviewed 0.27.11 at
`62edfbd43087a718bf0283e9040676a49211976d`.

## Issues and delivery boundary

[#103 — Align Metrics schema traits with published Wire 0.8](https://github.com/dragginzgame/ic-observability/issues/103)
was closed with the existing Metrics 0.19 registry-consumer receipt and current
producer CI evidence. Its original body is preserved. Later Wire identities and
complete downstream application adoption retain their own qualification.
[#101 — Allow native arithmetic consumers to exclude Wire metadata dependencies](https://github.com/dragginzgame/ic-observability/issues/101)
closed with PR #102; [Tooling #268](https://github.com/dragginzgame/ic-tooling/issues/268)
owns subsequent consumer adoption after an appropriate supplier release.

Canic's current adapter cleanup remains covered by
[#712 — Remove redundant limits from the runtime logging adapter](https://github.com/dragginzgame/canic/issues/712)
and [#100 — Bound observability read work and encoded page sizes](https://github.com/dragginzgame/canic/issues/100).
No duplicate issue was created, no Canic source was exported here, and no sibling
checkout was edited by this task. Own staging, commits, version bump, release and
publication remain with the maintainer's release flow.
