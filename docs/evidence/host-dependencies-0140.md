# Incoming IC Host 0.14.0 selection review

The incoming maintainer manifests select private `ic-host-artifacts` and
`ic-host-fs` 0.14 instead of 0.13, with both lock rows selecting 0.14.0. Removing
only those two rows' version/checksum fields yields the unchanged preceding
lock graph. This review preserves the incoming selection; it does not resolve
dependencies or change Metrics' 0.6.4 workspace/package versions.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and already cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `04f90382ac3aaf0c4c395b481bcec850cdba7d3825cd75a6eb6e4f6e4a83dbb6` |
| ic-host-fs | `598a8fc71cac82e6f5f70ec32a5a0e9e76bdc11c9eae77acb8b3c741190630b6` |

Embedded Git identities, all 43 packaged Rust files and both original manifests
match published Host 0.14.0 `4723befe8d65c760c00e05c42652759d691fbd5e`.
Public main identifies that revision at the initial review. The sibling's then
pending 0.14.1 edits are excluded; verification uses committed source and official
packaged bytes.

Host 0.14.0 changes process completion to require an exit status and makes
output observers fallible. Those changes belong to `ic-host-process` and
`ic-host-tools`, neither of which Metrics consumes. The complete artifact and
filesystem source trees are unchanged from Host 0.13.5. Metrics continues using
bounded `read::read_file`, Wasm inspection and exact digest computation; no
process wrapper or new dependency is needed.

The published arithmetic library remains dependency-free, allocation-free and
`no_std` with Rust 1.85. The private inspector retains Rust 1.88 and unchanged
CLI/report/error contracts. The complete pending batch remains compatible
Metrics 0.6.5. There is no instruction, cycle or raw Wasm-size improvement claim.

Local inspector all-target checks, Clippy with warnings denied, named argument
and report tests and the actual CLI admission/publication test pass. Arithmetic
Rust 1.85 native/Wasm and private-inspector Rust 1.88 checks also pass against
the incoming graph. The earlier full CI gates in
[the Shared adoption record](adoption-065.md) retain their Host 0.13.3/0.13.5
identities; they do not qualify this selection.

With the maintainer's explicit full-CI approval, `make ci` passes in 230 seconds,
15:00:28–15:04:18 UTC on 2026-10-11, including both warnings-denied Clippy gates,
the inspector CLI test and release/preparation regression fixtures. All 89 frozen
technical inputs and the incoming manifests, lock and pins verify unchanged.
The real release plan also retains its preceding digest; no real release recovery,
staging, commit, publication or dependency resolution is performed.

The exact-source [Host run](https://github.com/dragginzgame/ic-host-tooling/actions/runs/38146341421)
reports Linux and MSRV success, with both macOS lanes queued at this review.
These observations do not establish independently downloaded upstream native
acceptance or owning delivered-source Metrics acceptance, which remains in
[#61](https://github.com/dragginzgame/ic-metrics/issues/61).

During validation, Host publishes 0.14.1
`f766121c7282a78753ca32bdb4d069ba8424b517`. Read-only review finds changes in its
Shared Tooling snapshot and Host-owned release evidence adapter; both consumed
source trees and original child manifests remain unchanged from 0.14.0.
Its [exact-source run](https://github.com/dragginzgame/ic-host-tooling/actions/runs/38149531883)
is queued at this observation. Metrics already adopts the same Shared 0.6.3 repair
through its own snapshot and metadata adapter. No dependency reselection or
additional inspector implementation is needed; this gate remains bound to the
selected 0.14.0 lock, not the newer archive.

Official index responses, incoming manifest/lock/pin hashes, the packaged-source
catalog and focused logs remain under
`target/evidence/adoption-065/host-0140/`. Earlier Host evidence is retained
under its original identities.
