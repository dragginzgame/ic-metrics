# Current handoff — 2026-10-30

Source base is release 0.18.1, `79fa3db`. The incoming checkout was clean. The
maintainer requested the new IC Wire release. Workspace declaration and lock now
select Wire and Wire Derive 0.8.0; no other locked package changes. Own workspace
versions remain 0.18.1. Pending notes select 0.19.0 because native metadata exposes
the changed Wire trait identity, not merely because the supplier used a minor bump.

## Adoption and compatibility

Wire 0.8.0 is published, not yanked and declares Rust 1.91. Its registry checksum
matches the selected lock. Prepared package VCS metadata records release commit
`25a7212269ca4fe1257cf4d3d22efbbe040cb84b`, independently confirmed as upstream main.
The supplier's production Wire/derive source is unchanged from 0.7.25; its minor
release changes the optional endpoint integration's Platform selection to 0.9.1.

This consumer retains native-only Wire, explicit `typescript` and disabled
features by default. Actual resolved metadata confirms exactly the selected Wire
pair, `typescript` only, no Platform package, and no Logging dependencies. No
endpoint runtime is enabled here. Arithmetic, Serde layouts, metadata shapes and
Logging behavior are unchanged.

Metrics' public native implementations now implement Wire 0.8's metadata trait.
Wire 0.7's trait is a different Rust dependency identity. Consumers deriving Wire
or requesting native schemas for reports embedding Metrics types must align the
same Wire line and shared Metrics identity. Serde-only callers acquire no new
Wire trait requirement. This is a real native consumer source break despite the
unchanged bytes and method signatures.

The [0.19 migration guide](../migration-019.md), package README, compiled transport
guide and root notes describe that graph alignment. Consumers select an actually
published matching Metrics release before adopting; own package metadata has not
been advanced or published by this task. Existing durable layouts are unchanged.
Applications using Wire endpoints coordinate Platform/runtime adoption themselves.

## Validation and evidence

Evidence is `target/audits/wire-080-20261030/`:

- Official Cargo sparse-index publication/checksum/floor and upstream Git identity
  were observed. The selected registry package records the same release commit.
- A targeted locked-graph update changed only Wire and Wire Derive. Resolved graph
  assertions, declaration/lock pin checks and real offline production dependency
  admission pass; endpoint/Platform remains absent.
- Formatting and strict Metrics library/test Clippy pass on the pinned compiler.
- Eight canonical numeric/schema transport tests pass at Rust 1.91, including
  malformed-state refusal, 0/3/37 const bounds and composed native browser metadata.
- All 15 Metrics doctests pass at Rust 1.91 with recording selected, including the
  updated report derive. Documentation links and diff checks pass.

Shared Tooling stays at reviewed 0.27.11, commit
`62edfbd43087a718bf0283e9040676a49211976d`; no snapshot-owned payload, tool catalog,
compiler floor, library runtime source or unrelated dependency was edited. The
only Rust source-file edit is explanatory prose in the included application guide.
No full CI/MSRV matrix, native macOS acceptance, installed endpoint/IC runtime,
performance experiment, own-version bump, release or publication ran. Root edits
are uncommitted; its index and sibling working checkouts remain untouched.

## Consumer and historical scope

Required downstream source review covered IcyDB, Canic, Timers, Backup, Blob
Storage and Toko Miner. Current native report consumers include Wire 0.7 graphs;
these require owning graph alignment when selecting the future Metrics release.
No consumer was upgraded or compiled by this task. Backup has no current direct
Metrics dependency in the reviewed workspace. Persistence already selects Wire
0.8 but retains its own Metrics/durable-codec adoption responsibility. Existing
API/codec/lifecycle qualification is not inferred from a lock update.

`79fa3db:docs/status/current.md` preserves the prior Shared 0.27.11/Wire 0.7.25
adoption receipts. The earlier 0.18 contract and owning adoption issues remain
in [the 0.18 migration guide](../migration-018.md). Existing Persistence #141,
Canic #715, Jobs #79 and the subsequent Tooling #268, Profiler #13 and Miner #67
issues are separate work; read their current state before resuming. Historical
receipts retain their original source, dependency graph and acceptance scope.
