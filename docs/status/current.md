# Current handoff — 2026-10-30

Source base is release 0.18.0, `f8d5290`. The maintainer requested adoption of
current Shared Tooling and IC Wire. The incoming checkout already had a scoped
Cargo.lock update selecting Wire and Wire Derive 0.7.25. That exact lockfile was
preserved; the workspace declaration now selects Wire 0.7.25 as its lower bound.
Pending compatible notes select 0.18.1. Own package versions remain 0.18.0.

## Adopted identities and impact

Shared Tooling 0.27.11 is adopted at independently reviewed commit
`62edfbd43087a718bf0283e9040676a49211976d`, verified against GitHub main. Its clean
isolated source is `/tmp/ic-observability-shared-adoption.5eCGOW/`. The canonical
exporter refreshed all 127 selected payload hashes/modes. No snapshot-owned file
was hand-patched. The previous reviewed source was
`a245bb49312a5ccafbb71532cfa5346741e3ba28` (0.27.8 base plus publication adapter).

Five payloads change: the core baseline, Rust hygiene guide, code-hygiene audit,
Cargo graph observations documentation and publication adapter. Publication
validation targets now dispatch sequentially before the attempt, preserving gate
order under parallel Make. Current Rust source has no lint allowances or module
path overrides requiring conversion. Ordinary module discovery and scoped lint
expectations are adopted without a local exception or new audit schedule.
Tool catalogs, compiler policy and executable pins are unchanged.

IC Wire 0.7.25's registry entry is not yanked, declares Rust 1.91, and its package
checksum matches the selected lock. The prepared registry source records release
commit `e026eb4c8a7a71d4e74b459d774a83490c351762`, matching current upstream main.
The supplying endpoint/derive changes add pre-copy header admission and shared
cold error formatting; this consumer uses native schema/numeric transport, not
that endpoint adapter. Existing transport traits/layouts remain compatible.
Native-only selection, explicit `typescript` and disabled defaults are preserved.
Logging remains independent and dependency-free.

The 0.18 migration/product guides now describe the completed workspace contract
without calling it pending. They continue to distinguish workspace release from
registry availability; no Observability publication was performed or inferred.

## Validation and evidence

Evidence is `target/audits/upstream-adoption-20261030/`:

- Snapshot impact review, integrity verification and independent comparison to
  the exact committed source pass. Initial clone-origin mismatch was corrected
  in the isolated clone's metadata before the successful preview/export; the
  rejected preview changed no consumer payload.
- Formatting, selected publication ShellCheck, declaration/lock inheritance pins
  and real locked offline production dependency admission pass.
- The actual consumer release/publication Make fixture passes with substituted
  Git/registry effects. Generic producer fixtures were not replayed.
- Strict Metrics library/test Clippy passes on the pinned compiler with Wire
  0.7.25. Eight numeric/schema transport tests pass on Rust 1.91, including large
  const arrays, malformed-state refusal and composed browser metadata generation.
- All 15 Metrics doctests pass at Rust 1.91 with recording selected.
  Documentation links and diff checks pass. Byte comparison confirms the incoming
  lockfile is unchanged by this task.

The crates.io metadata API refused access; publication/checksum/floor were instead
verified through the official Cargo sparse registry index. No source qualification
was inferred from that failed request. Local evidence retains the registry record.
No full CI/MSRV gate, native macOS acceptance, installed IC execution, performance
experiment, tool installation, own-version change, commit, release or upload ran.
Root edits remain uncommitted; the index and normal sibling checkouts are untouched.

## Earlier work and owning follow-ups

`f8d5290:docs/status/current.md` preserves the 0.18 hard-cut implementation,
consumer review and runtime receipt locations. Those historical observations
retain their original source/graph identities. The [0.18 migration guide](../migration-018.md)
owns caller and durable-data adoption requirements.

Logging adoption remains separately tracked by
[Persistence #141](https://github.com/dragginzgame/ic-persistence/issues/141),
[Canic #715](https://github.com/dragginzgame/canic/issues/715) and
[Jobs #79](https://github.com/dragginzgame/ic-jobs/issues/79). Retained storage must
receive an explicit owning transition/retirement decision; this task changes no
adapter or data. Subsequent sibling Metrics audit findings were filed as
[Tooling #268](https://github.com/dragginzgame/ic-tooling/issues/268),
[Profiler #13](https://github.com/dragginzgame/ic-profiler/issues/13) and
[Miner #67](https://github.com/dragginzgame/toko-miner/issues/67).
Read current owning issue/release state before resuming any of that separate work.
