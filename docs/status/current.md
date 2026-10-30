# Current handoff — 2026-10-30

Source base is `ce510c91037e9c4bb38b53091aacd18edeaf641e`, after merged
[PR #100 — Add consuming Logging checkpoint accessor](https://github.com/dragginzgame/ic-observability/pull/100).
Workspace metadata remains 0.17.4; pending compatible notes select 0.17.5.
Shared Tooling remains reviewed 0.27.4 at
`83f87cca71a420a61e69b6bdd018be27d4455daf`. Snapshot payloads are unchanged.
The incoming uncommitted Wire 0.7.23 lock update is preserved and belongs to the
maintainer; this batch changes no dependencies or release versions.

## Accepted publication, adoption and documentation batch

The maintainer authorized all three follow-ups from the status review:

- Make help and the README explain explicit `PACKAGE=ic-metrics` versus
  `PACKAGE=ic-logging` publication. The default remains Metrics. Workspace release
  metadata does not upload either crate. The actual Make fixture checks both
  explicit selections and the default, including upload/native/Wasm lint failures.
- Persistence's decoded temporary checkpoint uses the merged consuming accessor
  in [draft PR #140](https://github.com/dragginzgame/ic-persistence/pull/140), head
  `600b9600fe818f2846e6e8f335ab795ef1b26de5`. Its isolated contribution is at
  `/tmp/ic-persistence-consuming-checkpoint-20261030`. Integration awaits a
  registry Logging release containing the API and an admitted dependency/lock
  update; no production path override is selected.
- The README, host guide and Logging boundary describe current ownership and
  separate package publication. Superseded release/PR narratives are removed
  from this handoff; their full record remains at
  `ce510c9:docs/status/current.md` and its linked evidence owners.

No root staging, commit, version bump, release or registry upload is selected.
The checkout was fast-forwarded to the already-authorized PR #100 merge without
changing the incoming dirty lock. Root changes remain reviewable working files.

## Publication and qualification state

A registry-index observation on 2026-10-30 found Logging 0.17.1 and 0.17.2,
with 0.17.2 the latest published entry. The 0.17.3 fixes and merged consuming API
therefore still need explicit Logging publication. Finish the normal 0.17.5
workspace release and separately publish each desired package before consumer
registry adoption. Those actions retain maintainer authorization and full gates.

Root focused evidence is `target/audits/publication-adoption.aTJkdS/`:
standard-release dispatch, failure-retention fixtures, selected ShellCheck,
shell syntax and documentation links pass. Cargo/registry effects are substituted.
No broad local CI/MSRV or real publication ran for this batch.

Persistence candidate evidence is under its isolated checkout's
`target/qualification/consuming-checkpoint/`: nine adapter tests and two doctests
on Rust 1.91, strict native/Wasm Clippy and Rust 1.91 Wasm compilation pass using
the merged accessor source. The registry-only check explicitly fails with E0599
on Logging 0.17.2. The candidate config/lock are retained as evidence, excluded
from the PR; canonical manifests and both tracked locks remain unchanged. Update
the actual published minimum and lock before repeating checks and marking ready.

PR #100's unchanged Logging source passed its hosted Linux, Apple Silicon macOS,
Intel macOS and MSRV checks in
[CI run 40910884595](https://github.com/dragginzgame/ic-observability/actions/runs/40910884595).
The consuming accessor preserves limits, ordering, owned text and watermarks.
Earlier code evidence keeps its original source/graph identities: the fit audit
was `target/audits/logging-fit.3ciyEJ/`, fixes were
`target/audits/logging-fixes.obEV1R/`, and the six simplifications were
`target/audits/complexity-cleanup.U2Fhfb/`. These are historical receipt locations,
not new qualification or a guarantee that user-owned build cleanup retained them.

## Consumer boundaries and follow-up owners

Logging stays dependency-free `no_std` + `alloc`, independent of Metrics. The
[Logging boundary](../logging.md) and [crate guide](../../crates/ic-logging/README.md)
own the engine/checkpoint contract. Hosts retain clocks, identity, decoding
limits, authorization, lifecycle, retention scheduling and checkpoint cadence.

Persistence's [qualification PR #138](https://github.com/dragginzgame/ic-persistence/pull/138)
and [publication integration PR #139](https://github.com/dragginzgame/ic-persistence/pull/139)
are merged. Its default branch records release 0.56.0. Those facts alone do not
establish registry publication or qualify a later graph. Original installed
receipts and recovery inputs retain the locations and identities recorded in
`ce510c9:docs/status/current.md`; no installed runtime proof was repeated here.

Canic adoption remains separately owned and its dirty checkout is untouched.
Its observability read budgets are already tracked by
[#100 — Bound observability read work and encoded page sizes](https://github.com/dragginzgame/canic/issues/100),
with retention reconciliation at #101. The newly filed
[#712 — Remove redundant limits from the runtime logging adapter](https://github.com/dragginzgame/canic/issues/712)
covers the remaining duplicate limits. There is no new dependency-waiting issue;
publication is owned here. [Jobs PR #77](https://github.com/dragginzgame/ic-jobs/pull/77)
is merged and remains heap-only. Stable Metrics remains at Persistence; prior
transport and consolidation receipts retain their historical scopes and owners.
