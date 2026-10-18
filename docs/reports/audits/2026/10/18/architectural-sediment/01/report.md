# Architectural sediment review

## Scope and identities

Verdict: **PASS WITH FINDINGS**. Local remnants are corrected; the intended
Testkit write observer is not yet available as a published dependency.

Method: [flow convergence and duplication](../../../../../../../../audits/flow-convergence-and-duplication.md),
Shared Tooling `88d398f01c9be74bd71d1ad67c27bf0ede87cc9b`, with the current
[Metrics overlay](../../../../../../../../AGENTS.md). Trigger: maintainer-requested
repository audit and cleanup. Source: release commit
`76cca76c8e591d91c9dbed6b276ac2ef57533335` plus the incoming prepared 0.14.0
working tree. That incoming batch already removes sample-report statistics,
the map alias and direct stable-structures use; those are not new audit removals.
Task-only before-images and execution receipts are retained locally under
`target/architectural-sediment-0140/`. The real index and Cargo versions/lock stay
unchanged. Sibling checkouts are read-only evidence, not build inputs.

Scope covers both libraries and their tests/docs, workspace manifests, local
Make/release/hook/evidence adapters, CI and snapshot entrypoints. Shared payloads
are checked against their manifest rather than edited. Historical evidence and
frozen experiment sources remain unchanged; no generated product code exists.
This is a structural/source and native-build review, not deployed IC acceptance.

## Boundary and traces

| Capability | Owner and entry-to-result trace |
| --- | --- |
| Integer measurement arithmetic | `ic-metrics`: public root exports -> aggregate/counter/summary/histogram/ratio modules -> checked numeric projections. The package has no dependencies, allocation, platform reads or endpoints. |
| Snapshot identity, encoding and continuity | `ic-metrics-stable`: concrete load/save/remove operations -> private bounded V1 codec/metric adapters -> core restored-state admission and governed map operations. This translation belongs here. |
| Collections and allocation | Published Storage 0.5.2 supplies `adapter::StableBTreeMap`; Memory 0.48.1 supplies admitted handles, leases and bootstrap. Hosts supply the opened map and retain lifecycle/IDs. The normal dependency graph shares one Memory identity. |
| Sampling and reporting | Application consumers own attribution, registries, resets, units, synchronization and endpoints. Read-only IcyDB, Canic, Timers, Backup, Blob test-probe and Toko integration evidence is consistent with this boundary; no runtime qualification was run there. |
| Native reporting and IC tooling | Testkit owns its reporter, PocketIC lifecycle and intended native memory observer. Host owns the published Wasm-inspection CLI. Neither is a Metrics workspace dependency. |
| Contributor mechanics | Reviewed Shared snapshot -> common Make, installer, formatter, release and fixture helpers. Metrics supplies its package roster, direct-release policy, compiler/host selection and workflow effects. |

Available sibling Memory/Storage APIs and the selected registry sources agree
with the governed-map boundary. The Testkit reporter extraction remains a
[separate contribution](https://github.com/dragginzgame/ic-testkit/pull/125), not
assumed merged or published. Historical reader/inspector/server references in
frozen evidence are provenance, not active implementations or current commands.

## Findings and disposition

1. **LOW — retired reader exception placeholder.**
   `ci/dependency-pinning-exceptions.json` was introduced for the exact `ic0`
   reader pin in `1375d10`, emptied when that reader retired in `019c2b7`, and
   still existed as `[]`. Removed it. Shared's pin checker explicitly defaults
   an absent optional exception file to an empty array. Pin checking and native
   source selection remain the affected workflows; no dependency is exempted.

2. **LOW — single-package hook qualification survived the stable split.**
   `scripts/dev/test-format-hook.sh` selected the arithmetic manifest with
   `--no-dependency-tables`, although workspace dependencies now include the
   stable integration. It now selects the stable Rust entrypoint and real root
   manifest. The canonical Shared fixture generator swaps the adjacent
   Metrics/Storage declarations; the shared checker verifies exact sorted
   restoration and staging behavior. The helper was imported through distribution
   from the same clean reviewed source, adding one snapshot payload, with no pin
   or baseline-version change. Retention checks now cover generated input custody
   and nested checker failure logs. No synthetic dependency or local TOML editor
   was introduced.

3. **LOW — current guides repeated superseded API migrations.**
   The extraction contract and stable guide repeated pre-0.10/0.11/0.12 upgrade
   narratives beside current interfaces. Replaced them with current ownership,
   projections and compiler requirements. Published changelog entries retain
   upgrade history; pending 0.14 caller actions and Memory's retained-data
   disposition remain explicit. Documentation links and compiled examples verify
   the remaining current guide.

## Deliberate retention and unresolved availability

- Keep private V1 encoding, typed corruption admission, frozen byte vectors and
  checkpoint-continuity checks. Storage owns collection geometry, not Metrics
  record meaning; core restoration does not establish durable identity/continuity.
- Keep concrete store methods and public Storage-map transfer. They translate
  measurement operations without copying collection or allocation implementations.
- Keep native-width arithmetic and histogram equality specialization: existing
  source-bound IC studies justify their separate paths. This audit measures no
  new Wasm/instruction/cycle improvement.
- Keep local native recovery packaging and workflow/release fixtures. They qualify
  Metrics' effect routing, hidden Git-state custody and archive selection;
  canonical generic mechanisms remain in Shared Tooling.
- Keep the test-only write observer until
  [#82 — Adopt published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82)
  can be completed. The official sparse index for `ic-testkit-native` returned
  HTTP 404 on 2026-10-18; no replacement dependency is available to verify.
  Do not move this to Memory or use a sibling path override. First durable-consumer
  acceptance remains with
  [#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83).

## Verification

- Native all-target and Wasm library workspace Clippy pass with warnings denied.
- Workspace tests pass: 55 arithmetic and 21 stable units, plus 13 doctests.
- Real hook qualification passes, including dependency sorting; the actual
  release/metadata/hook retention fixture passes success, injected child/assertion
  failures and initialization/cleanup probes.
- CI evidence checks pass in an isolated current-source checkout: source hashing,
  actual workflow setup/archive bodies with substituted actions/Make, and recovery
  archive round trips/failure custody. This represents pending source deletions
  without changing the real index; its scratch tree identity and selected paths
  are retained with the receipts. This is not hosted CI acceptance.
- Bash syntax and ShellCheck with sourced helpers pass for the changed scripts.
- Snapshot, dependency-pin, formatting, documentation-link and diff checks pass.
- The first dependency-pair probe moved a dependency-attached comment when sorted;
  that fixture-input mistake was corrected by selecting the uncommented adjacent
  pair. The retained failed scratch is not acceptance evidence.
- No full local CI/MSRV gate, hosted macOS run, sibling build, registry publication
  or new IC performance experiment was run. Prior Rust-floor evidence applies only
  to its unchanged product inputs. Public reports include no private sibling
  excerpts or source payloads.
