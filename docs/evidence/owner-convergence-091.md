# Owner convergence for pending 0.9.1

IC Host owns the published bounded Wasm inspection CLI; Shared Tooling owns
coordinated Cargo metadata preparation and selected-commit validation. Metrics
retains its source/cache/delivery policy and the stable adapter's size admission.
Public arithmetic/stable APIs and stored V1 bytes are unchanged.

## Retired source

[The frozen bundle](owner-convergence-091.tar.gz) and
[checksum](owner-convergence-091.tar.gz.sha256) retain the exact former inspector tree, metadata adapter,
workspace manifest and lock before their removal/replacement. The original
[inspection record](wasm-inspection-0215.md) keeps its original commands and source
identities; its former guide is preserved in this bundle. Those historical
measurements are not rerun or relabelled by adopting the published CLI.

## Qualification boundaries

Shared Tooling 0.11.1 `7a7430bd30902dc655a025be61696ce19417c54a` is the reviewed
clean source. Its corrected helper preserves failed Git producer statuses even
when output appears valid. Portable fixtures and ShellCheck pass on the exact
helper/test bytes. Metrics imports it only through the recorded snapshot.

Host CLI 0.17.4 source is `28f3a6d5771ecb941b86cd3c6ea2507de82b101e`.
The official registry entry is non-yanked, with checksum
`1a3af8688f1bf9500f298cec895646d95a81ed56e49c1db54cace1583e6d95dd`.
The frozen producer integration (base `a3a7d3a5524a1c98f9b0f014d08b32dabb8f52e5`
plus the retained integration overlay) passes full Linux CI and all five
native/Wasm workspace floors where applicable on Rust 1.88. Its four CLI source
files match the published implementation; this does not qualify later release
workflows or relabel them as passing native acceptance.
Metrics' managed installer admits the published package and its exact receipt,
compiler/native/build identity and binary bytes. Its actual offline dispatch
produces the empty module's exact digest and structural row.

Metrics' consumer preparation/admission fixtures exercise the imported helper,
real two-member Cargo metadata, rollback/retained evidence, selected older commit,
failed producers and local source/Make/logger policy. Effectful Cargo-edit, index
fixtures and validation gates are substituted only where explicitly declared.
These tests do not perform a real Metrics release or registry publication.

Final `make ci` passes in 301 seconds, arithmetic Rust 1.85 native/Wasm in one
second and stable Rust 1.88 native/Wasm in two seconds. All 100 source, workflow,
graph and tooling inputs remain byte-identical before/after the gates and between
the real working tree and disposable qualification checkout. The library lock
retains Memory 0.36.3 and all retained registry versions/checksums; no dependency
upgrade is performed. Workspace package versions remain 0.9.0.

The original checkout's pin check refuses the unstaged retired manifest still in
its Git index. Qualification uses the exact working files in an isolated checkout,
removing absent files only from its disposable index and reusing Metrics' existing
`target/`. Earlier refused pin/native-phase/retention attempts remain in the bundle;
the final corrected run is separate. The real staged tree and refs are preserved.
Final receipt/handoff prose receives separate link/consistency/diff checks.
Native macOS and committed adoption remain separately owned by
[#70](https://github.com/dragginzgame/ic-metrics/issues/70),
[Host #81](https://github.com/dragginzgame/ic-host-tooling/issues/81) and
[Shared #167](https://github.com/dragginzgame/shared-tooling/issues/167).
