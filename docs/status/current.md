# Current handoff — 2026-10-31

Source base is `8283eb5` (maintainer commit “0.22.0”). Workspace metadata remains
0.21.1 and pending release notes remain 0.22.0. The maintainer's release validation
failed before the allocator-free Wasm example linked. This repair is uncommitted;
no staging, version change, release retry or publication was performed.

## Release failure and repair

The added unconditional development dependency on serde_json selected serde/std
for Wasm example builds through Cargo feature unification. The no_std fixture's
panic handler then conflicted with std's panic_impl. This was a dependency-boundary
regression, not a reason to weaken the fixture or remove its panic handler.

JSON is now a native-only development dependency. Its Serde test module has the
same native test boundary; all transport implementations remain available on
Wasm and native targets. No dependency version or lockfile changed. Numeric APIs,
message bytes, arithmetic admission and retained layouts are unchanged.

The original failure remains in
`.git/release-state/validation-failures/20261031T091431Z-132330-0-ci.log` and the
release runner's latest-combined log. Preserve these release records and artifacts.
The repair evidence is `target/audits/wasm-json-boundary-20261031/`:

- Formatting and strict Metrics library/test/all-feature Clippy pass.
- The exact allocation-free Wasm link gate passes on Rust 1.99.1; the same fixture
  separately links on Rust 1.91.0. Successful Wasm artifacts are retained under
  development/ and minimum/ in that evidence directory.
- Actual Wasm normal/build/dev feature output contains no serde_json or Serde std.
- All four resolved dependency profiles and four minimal native Serde tests pass.
- Pins, production dependency admission, documentation links and diff checks pass.

No complete local CI/MSRV release suite was rerun. Commit the scoped repair before
resuming the maintainer-directed release flow; the earlier failure is not a pass.

## Previously accepted batch

Commit 8283eb5 contains the prior source changes: minimal-profile Serde tests,
resolved normal/build dependency checks, shared Rust report fixtures and the
logging cleanup that reuses admitted truncation parts. The native-only JSON fix
preserves those tests and the existing TypeScript conformance fixture.

`make metrics-profiles-check` checks native minimal, recording without defaults,
native default and all-feature Wasm. Minimal/recording/Wasm production closures
exclude Wire/derive, native default includes one pair, all exclude Platform and
Logging remains independent. The target also runs native Serde round trips and
admission checks with defaults disabled. The separate allocator-free link gate
covers Wasm examples, including development-dependency feature unification.

Prior focused evidence remains at `target/audits/profile-and-logging-20261031/`:
29 Logging tests, eight native transport tests, five executed Rust/TypeScript
reports, four Serde tests on development/minimum Rust and four dependency profiles
passed on their recorded inputs. Its graph refusal fixture detects recording
accidentally enabling Wire. These checks did not prove the failed Wasm example.

## Issues, hosted evidence and boundaries

Merged PR #102 at 691fb85 passed the complete
[CI run 41185478330](https://github.com/dragginzgame/ic-observability/actions/runs/41185478330)
on Linux, both macOS native hosts, MSRV and TypeScript. That hosted evidence is
for 691fb85, not 8283eb5 or this repair.
[#101 — Allow native arithmetic consumers to exclude Wire metadata dependencies](https://github.com/dragginzgame/ic-observability/issues/101) closed on merge;
[#103 — Align Metrics schema traits with published Wire 0.8](https://github.com/dragginzgame/ic-observability/issues/103) closed using its
original published Metrics 0.19 consumer receipt and current producer acceptance.
[Tooling #268](https://github.com/dragginzgame/ic-tooling/issues/268) retains its
own adoption after an appropriate supplier release.

Canic sediment remains covered by
[#712 — Remove redundant limits from the runtime logging adapter](https://github.com/dragginzgame/canic/issues/712)
and [#100 — Bound observability read work and encoded page sizes](https://github.com/dragginzgame/canic/issues/100).
No sibling checkout or issue was changed by this repair. Shared Tooling stays at
reviewed 0.27.11, revision `62edfbd43087a718bf0283e9040676a49211976d`.
