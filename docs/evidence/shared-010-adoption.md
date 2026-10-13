# Shared Tooling 0.10.0 adoption for 0.9.1

The reviewed committed source is `ed9c26f015691859f67b50b512a94709dcdc0c6c`,
matching upstream main when selected. It was clean during review and export.
Later dirty upstream work is excluded; no sibling files are edited. The consumer
source capture is finalized Metrics 0.9.0 `fe4d14f2a24138794878a17a354885a1e7222487`.
Its Cargo metadata, incoming lock, Rust source, original archives, index and refs
remain unchanged. This batch selects compatible 0.9.1 notes, not Cargo versions,
a commit, release or publication. Finalized changelog history stays byte-identical.

## Catalog and routing contract

The canonical exporter refreshes the existing 104 payloads and 91 roots.
Both catalogs were already explicit snapshot roots; 0.10 now requires them as
installer companions and owns default selection. All 26 host/Cargo/workflow-tool
variables and 15 IC version/host/digest rows match the previous complete selections.
No local copy, exception catalog, tool-version upgrade or collision override is
needed. Snapshot payloads are exported from Git and verified, never patched.

Make inherits snapshot defaults directly. Host selection no longer implicitly
selects Rust. Root-layout direct reads, formatting/hooks, native source/evidence
inputs and the failure action all select the same reviewed catalogs. The failure
action defaults relative to its own snapshot. There is no consumer CI cache key
or freshness-helper call needing a catalog override; optional fleet helpers remain
upstream. Compiler/MSRV, application dependency and release-delivery policy stay
local. No maintenance schedule or fleet scan is activated by adoption.

Release preflight receives the independently selected `RUST_TOOL_VERSIONS` and
binds its digest across setup/check. A real Make child-routing fixture covers an
explicit catalog with spaces and an independent host selection. The admission
fixture rejects mutation of the selected explicit Rust catalog while preserving
the default catalog, prior tool, Cargo inputs and fixture index. Effectful setup
is substituted in those fixtures; no real release occurs.

The imported baseline permits separate locked dependency-source preparation,
retains native tool/release lock errors and statuses, and rejects CR/LF directory
paths before normalization in the affected tooling. CI-inspection procedures are
updated; no optional CI/fleet helper is silently introduced into this snapshot.

## Qualification

Actual `make install-tools`, `make tools-check` and `make fmt-check` pass through
the canonical per-user store. Previous generations and references stay retained;
no consumer-owned payload copy/cache management is added. Snapshot, pin, hook,
ShellCheck and workflow lint checks pass. The release-routing/admission fixtures
pass, including after the pending notes are corrected to 0.9.1.

Full CI passes in 293 seconds; `make msrv`, `make stable-msrv` and
`make wasm-inspect-msrv` pass in 1, 13 and 2 seconds respectively. Eight gate
checkpoints match all 150 selected inputs, roster SHA-256
`b865959815aebf61c58988f759874be212d0d9002167009992400614643c14aa`.
The qualified graph is Metrics 0.9.0, Host artifacts/fs 0.17.1 and Memory 0.36.2,
with exact collections 0.7.2. Arithmetic stays dependency-free/no_std on native
and Wasm Rust 1.85; stable stays on native/Wasm 1.88 and the private inspector on
native 1.88. No dependency update is performed by this tooling adoption.

The original handoff had stale pending-0.9 wording. Final standalone prose and
0.9.1 notes are corrected after the compiled gates, then checked separately for
links, diffs, consistency and release admission. Those edits do not alter
compiled inputs or relabel gate checkpoints. The missing loose prior roster was
recovered from its checksum-bound archive before validation; no compiled gate
ran without the new frozen roster.

These are local Linux receipts; Wasm compilation and simulated host fixtures do
not establish native macOS acceptance. [Metrics #70](https://github.com/dragginzgame/ic-metrics/issues/70)
retains supported-host acceptance under [Shared #153](https://github.com/dragginzgame/shared-tooling/issues/153).
Earlier performance and adoption archives retain their original inputs; this
batch makes no new IC instruction/cycle or raw Wasm-size measurement claim.

The public receipt includes captured own source, the qualified snapshot/inputs,
complete catalog comparison, exporter preview/result, setup/check/format logs,
focused checks and all four gate logs/checkpoints. Previous archives are hashed,
not copied into this receipt; no private sibling source or issue reads are added.
Archive: `docs/evidence/shared-010-adoption.tar.gz`; checksum:
`docs/evidence/shared-010-adoption.tar.gz.sha256`.
