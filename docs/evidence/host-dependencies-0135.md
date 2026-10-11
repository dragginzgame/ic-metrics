# Incoming IC Host 0.13.5 selection review

The incoming maintainer lock selects private `ic-host-artifacts` and `ic-host-fs`
0.13.5 instead of 0.13.3. Their dependency lists and every other lock row are
unchanged. This review preserves that selection without dependency resolution
or package/workspace version changes.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and already cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `81bf7fe89a7eb2de8a32f06ea42a5dc7675554c5de4e03c11c81e804ae73e0fa` |
| ic-host-fs | `3cc0762977bfb40ae481c401d9af1fa818aa835ca0485dbb55a8305d46132e65` |

Embedded Git identities, every packaged Rust file and original manifests match
published Host 0.13.5 `b32021c67515f0a0dcf35f1dd0b2029b9599ac75`. Public main
identifies that revision. The sibling's documentation edit is not an inspected
package input; verification uses committed source and official packaged bytes.

Host 0.13.4 adds `durable::open_private_regular_lock_file` for owner-only sidecar
creation in an existing parent, preserving existing bytes, inode and permissions.
Callers still own acquisition and lifetime. Host 0.13.5 adopts the Shared 0.6.1
setup fixes. Artifact Rust source and filesystem read modules remain unchanged
from 0.13.3; filesystem changes are confined to durable locking and its tests.
Metrics consumes bounded `read::read_file`, Wasm inspection and exact digest
computation. It has no writer or sidecar-lock caller, so the new lock API needs
no inspector wrapper or arithmetic change here.

The public library remains dependency-free with Rust 1.85. This private graph
retains Rust 1.88. There is no instruction, cycle or raw Wasm-size improvement
claim. The [exact-source Host run](https://github.com/dragginzgame/ic-host-tooling/actions/runs/38142886238)
is queued at the initial observation; source/archive verification does not
establish upstream native acceptance. A subsequent exact-source observation
reports Linux and MSRV success, with Apple Silicon running and Intel queued.
These job statuses do not claim independently downloaded Host native acceptance.

Local inspector all-target checks, Clippy with warnings denied, named argument
and report tests, the actual CLI admission/publication test and Rust 1.88 pass.
The arithmetic Rust 1.85 native/Wasm checks also pass with the preserved graph.
Full owning `make ci` passes in 296 seconds; all frozen technical and graph/pin
inputs remain unchanged, as recorded in
[the supplemental adoption](adoption-065.md#supplemental-shared-tooling-062-adoption).
Official index responses, archive/source comparisons and lock review remain
under `target/evidence/adoption-065/host-0135/`.
