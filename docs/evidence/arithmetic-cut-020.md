# Arithmetic-only 0.2 preparation

This records the uncommitted hard cut based on released ic-metrics 0.1.9
`083254a6a7c24f1e07d1e952a867059746f6feb5`. The pending changelog is 0.2.0 because
`call_context_instructions`, feature `ic` and `make reader-check` are removed.
Cargo package/workspace versions remain 0.1.9. No commit, push, tag or publication
ran. [The contract](../extraction.md) owns the current boundary;
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) owns adoption.

## Maintained behavior and retirement

`record_sample` and `MeasurementSummary` source/tests are byte-identical to the
released tag. Their empty/zero, count/total saturation, latest/maximum and const
contracts are unchanged. The reader module, canister fixture and host harness
are deleted, together with all runtime/dev dependencies and the reader CI lane.
No new package, feature matrix, reader substitute or product coupling is added.
The optional IC counter was a thin upstream wrapper; removing it supplies no
measured instruction, cycle or raw Wasm-size improvement. The locked graph falls from 292 package records to one. This
reduces developer qualification coupling, not demonstrated deployed cost.

Native CI retains the common explicitly pinned local tool setup and native
source/outcome/log evidence. It no longer builds or executes a reader canister.
Historical reader evidence remains bound to earlier tags; the
[frozen extraction record](extraction-through-019.md) preserves pre-cut source
and adoption observations, with relative links relocated for its archive path.

## Focused Linux proof

- Strict host all-target and Wasm library Clippy pass, warnings denied.
- All six unchanged named arithmetic tests pass without IC harness compilation.
- Host/Wasm API docs and Rust 1.88 checks pass; Cargo metadata has one package,
  no features and no runtime/build/dev dependencies.
- Locked offline development packaging verifies. Its package version remains
  0.1.9 and its dirty VCS record identifies preparation, not another registry
  release. The archive contains only manifests/lock, VCS metadata, license,
  README, library source and arithmetic tests.
- Formatting, the unchanged 44-file snapshot, dependency declarations and
  actionlint pass. The selected metadata fixture passes with Cargo-edit/Git
  substitutes. Executing the actual revised CI gate/retention shell blocks with
  a controlled Make substitute preserves failure exit 37, the log and outcome.
  This is rejection/retention evidence, not actual hosted CI or IC execution.

No full local tests, CI or release gate ran. Native macOS and configured CI
qualification for this cut remain unobserved; older tag passes are not relabelled.
Inputs, logs, before manifests/lock, controlled failure evidence and development
archive are retained under `target/evidence/arithmetic-cut-020/`.

## Consumer propagation

| Owner | Preparation | Focused proof |
| --- | --- | --- |
| IcyDB | Existing CDK counter-1 API in Core and all direct audit/test readers; remove reader-only fixture deps and direct feature request | Strict Core metrics lint, ten state tests, strict lint on thirteen Wasm packages/twelve native fixture/canister packages |
| Canic | Existing CDK counter-1 API in the performance adapter; remove direct feature request | Strict host/Wasm Core lint, eight native accounting tests and exact governed actual-PocketIC interleaving case in both completion orders |
| IC Timers | Existing ic0 counter-1 binding in production platform adapter; remove direct feature request | Strict host library/tests and Wasm library lint, two named role/projection tests, locked offline metadata for both independent workspaces |
| IC Backup | Already arithmetic-only; no reader change | Source review from the earlier 0.1.9 adoption record; no new consumer commands or edits |

IcyDB's first Wasm lint attempt exposed incomplete reader renames in child
modules; the corrected host/Wasm caller passes are separate from its retained
failed log. An initial offline preparation attempt lacked concurrently selected
ic-host-tools 0.1.12; the selected verified archive/index was copied from an
existing local cache, without network or upgrades. IcyDB and Canic's concurrent
ic-memory 0.28.0/ic-testkit 0.19.0 selections were preserved. No consumer package
selection changed during preparation; IC Timers' testing lock loses only the
metrics-to-ic0 edge. Core/adapter/manifest/lock hashes match after qualification;
fixture hashes bind the corrected caller checks. Native fakes and compiler-only
proof do not establish live IC behavior. Canic's governed case uses actual IC
counters and its runner-owned local PocketIC lifecycle; no live deployment ran.

After the initial Canic pass, a concurrent fixture/PocketIC lock edit introduced
ic-management-canister-types 0.11.0. Its new lock SHA-256 is
`59400aadcb8fbbe3d478b3a5b49c4d7b7c4df99e162eebda21dac5610d30d7f5`;
the prior proof remains bound to
`e874292b9366fe9aa7ff87f237edcf3aa805c68afed804d98fd5d8f5a7a606b5`.
Focused runtime-probe native strict lint and the exact governed IC regression
pass again on the new inputs, with all five recorded input hashes unchanged.
The runner reuses its admitted cached Wasm artifacts rather than reporting a
fresh build. A direct fixture Wasm lint attempt was rejected by the existing
canonical role-build guard before linting; that failed log is preserved and the
guard was not bypassed. Actual Wasm admission/execution stays with the governed
runner. Recheck inputs and logs are retained separately from the first pass.

Consumers retain published registry 0.1 arithmetic requirements until 0.2 is
published. IcyDB/Canic still receive the old `ic` feature transitively from
published IC Timers 0.13.5; the prepared timer adapter release removes that edge.
Later 0.2 adoption must coordinate any publicly re-exported summary's crate/type
identity rather than silently mixing 0.1 and 0.2 values. This preparation changes
no attribution, endpoint, report, reset or persisted format. IcyDB remains
inclusive; Canic remains exclusive; IC Timers owns role attribution and identity.
Canic's independent pending instrumentation/memory changes still conflict with
its selected patch target; this compatible adapter edit does not resolve that
human-owned minor boundary or complete consumer release/hosted qualification.

[#8](https://github.com/dragginzgame/ic-metrics/issues/8) is resolved by deleting
the retired harness graph rather than introducing a private harness crate.
Publication and owning consumer release/CI remain coordinated in #10 and
[#4](https://github.com/dragginzgame/ic-metrics/issues/4).
