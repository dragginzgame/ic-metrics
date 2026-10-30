# Current handoff — 2026-10-30

Source base is release 0.19.0, `dc757b5`. The incoming checkout contained the
previous uncommitted Wire 0.9 adoption. The maintainer requested Wire 0.10;
workspace declaration and lock now select Wire and Wire Derive 0.10.0, replacing
that pending selection. No other locked package changes. Own workspace
versions remain 0.19.0. Pending notes select 0.20.0 because native metadata exposes
the changed Wire trait identity, not merely because the supplier used a minor bump.

## Adoption and compatibility

Wire 0.10.0 is published, not yanked and declares Rust 1.91. Its registry checksum
matches the selected lock. Prepared package VCS metadata records release commit
`c9d4e7b45b9ba6d841d7e2a664877e3bea035a5b`, independently confirmed as upstream main.
Compared with 0.9, the supplier adds optional Platform Principal/Account metadata
under `platform-types` and selects Platform 0.11.0 for optional integrations.
Core codecs, existing native metadata and derive implementation are unchanged.

This consumer retains native-only Wire, explicit `typescript` and disabled
features by default. Actual resolved metadata confirms exactly the selected Wire
pair, `typescript` only, no Platform package, and no Logging dependencies. No
endpoint runtime is enabled here. Arithmetic, Serde layouts, metadata shapes and
Logging behavior are unchanged.

Metrics' public native implementations now implement Wire 0.10's metadata trait.
Earlier Wire traits have different Rust dependency identities. Consumers deriving
Wire or requesting native schemas for reports embedding Metrics types must align
the same Wire line and shared Metrics identity. Serde-only callers acquire no new
Wire trait requirement. This is a native consumer source break despite unchanged
bytes and method signatures.

The [0.20 migration guide](../migration-020.md), package README, compiled transport
guide and root notes describe that graph alignment. Consumers select an actually
published matching Metrics release before adopting; own package metadata has not
been advanced or published by this task. Existing durable layouts are unchanged.
Applications using Wire endpoints coordinate Platform/runtime adoption themselves.
The [0.19 guide](../migration-019.md) retains the previous release's graph selection.

## Validation and evidence

Evidence is `target/audits/wire-0100-20261030/`:

- Official Cargo sparse-index publication/checksum/floor and upstream Git identity
  were observed. The selected registry package records the same release commit.
- A targeted offline graph update changed only Wire and Wire Derive. Resolved graph
  assertions, declaration/lock pin checks and real offline production dependency
  admission pass; endpoint/Platform remains absent.
- Formatting and strict Metrics library/test Clippy pass on the pinned compiler.
- Eight canonical numeric/schema transport tests pass at Rust 1.91, including
  malformed-state refusal, 0/3/37 const bounds and composed native browser metadata.
- All 15 Metrics doctests pass at Rust 1.91 with recording selected, including the
  report derive. Documentation links and diff checks pass.

Shared Tooling stays at reviewed 0.27.11, commit
`62edfbd43087a718bf0283e9040676a49211976d`; no snapshot-owned payload, tool catalog,
compiler floor, library runtime source or unrelated dependency was edited. The
only Rust source-file edit is explanatory prose in the included application guide.
No full CI/MSRV matrix, native macOS acceptance, installed endpoint/IC runtime,
performance experiment, own-version bump, release or publication ran. Root edits
are uncommitted; its index and sibling working checkouts remain untouched.

## Consumer and historical scope

Downstream dependency selections were reviewed for IcyDB, Canic, Timers (now in
IC Scheduling), Backup, Blob Storage, Toko Miner and Persistence. Their native
report graphs must align Wire 0.10 when selecting the future Metrics release.
This task does not change arithmetic/report layouts, runtime attribution or
retained-data contracts. No sibling was edited, upgraded or compiled; owning
API/codec/lifecycle qualification is not inferred from this dependency update.

`dc757b5:docs/status/current.md` preserves the prior Wire 0.8 adoption receipts.
The separate `target/audits/wire-090-20261030/` retains the superseded, uncommitted
Wire 0.9 preparation's original graph and checks; these are not Wire 0.10 evidence.
The earlier 0.18 contract and owning adoption issues remain in
[the 0.18 migration guide](../migration-018.md). Existing Persistence #141,
Canic #715, Jobs #79 and the subsequent Tooling #268, Profiler #13 and Miner #67
issues are separate work; read their current state before resuming. Historical
receipts retain their original source, dependency graph and acceptance scope.
