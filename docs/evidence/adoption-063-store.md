# Shared Tooling 0.5.0 adoption for Metrics 0.6.3

Metrics base remains released 0.6.2
`4dcbe1955b4f90b42ccab8a82ae634291ef1797d`. The selected committed/public Shared
source is 0.5.0 `a306180ce534227fcb98b882fba9a526d5d747e0`, superseding the
[initial 0.4.1 preparation](adoption-063.md) in the same compatible pending batch.
The clean detached canonical exporter previews 12 updates and requires the
store helper and its fixture companion. Explicitly adding both produces a
verified 96-file snapshot, with 82 existing selected files unchanged.
Logs and inputs are retained under `target/evidence/adoption-063-store/`.

## Storage and evidence contract

Host and IC tools share authenticated bundles through the per-user store, while
each checkout retains its own pins and references to exact generations.
`.tools/host/bin` and `.tools/ic/bin` remain the command paths. Matching setups
reuse physical payloads without downloading; updates cannot retarget another
checkout. Offline checks refuse missing/corrupt selections and never repair them.
Previous physical local bundles and failed attempts are preserved. Cargo-built
tools and their build evidence remain under `.tools/rust`; this change does not
introduce cross-checkout Cargo reuse or change IC Testkit's PocketIC ownership.

Explicit `make install-tools`, then `make tools-check`, prepares the new storage
admission and the common Rust slots. Interactive shells still select
`.tools/rust/common/bin`. Use the same optional `SHARED_TOOLING_STORE` setting for
setup, checks and collection; the canonical owner documents the default under
[shared storage configuration](../local-setup.md#shared-executable-storage).
No consumer-owned cache, installer or link-management mechanism is added.

The custom Metrics native CI collector now calls the canonical full evidence
selector. It archives this checkout's local references and the corresponding
physical shared bundles, plus the physical local Rust tree. Its maintained
fixture verifies host and IC shared-reference failures, independently recovered
payload bytes/modes/links, retained local evidence and exclusion of an unrelated
store generation. Native source catalogs include both new helper files.

This is compatible 0.6.3 contributor tooling work. Arithmetic APIs/state/behavior,
library sources, consumer build requirements, dependency/executable pins and
Rust floors remain unchanged. Package/workspace metadata stays 0.6.2. No sibling
source or build, real staging, commit, version edit, tag, push or release is performed.

## Qualification

Snapshot integrity, selected ShellCheck and workflow lint pass. Explicit real
host/IC setup and the complete offline `make tools-check` pass. A second isolated
consumer checkout selects the identical physical host/IC generations with curl
replaced by a refusing recorder and zero download dispatch. All 4,723 regular
files in the previous physical host, IC and Rust installations retain their
original checksums. The first offline host-check refusal and the subsequent
successful diagnostic and aggregate retries are retained separately. Its cause
was not established; no repair or artifact deletion was performed for those retries.

Local tool/store fixtures, CI evidence fixtures, release adapters, the real
formatting hook, formatting checks and warning-denied native/Wasm Clippy pass.
Genuine Bash 3.2.57/Make 3.81 on Linux passes host/IC store fixtures, the custom
CI evidence collector, formatting hook and formatting checks. Those isolated
store fixtures cover reuse, differing selections, corruption, locks and offline
refusal. The host/IC legacy log also retains a later, incorrectly invoked
standalone evidence helper's usage refusal; that helper is exercised with its
required arguments by the passing host/IC fixtures. Remaining consumer checks
pass separately in `legacy-consumer-evidence.log`. These are local/substitute
checks, not hosted or native macOS acceptance.

The explicitly approved full `make ci` passes in 241 seconds. Rust 1.85 native
and Wasm arithmetic checks and Rust 1.88 all-target inspector checks pass. All
104 frozen non-Markdown code/graph/pin/Make/workflow/snapshot inputs remain
unchanged across delivery validation, including both new companion files.
The final physical-installation preservation check also passes. Evidence is
retained in `ci.log`, `rust-floors.log`, `delivery-inputs.sha256`,
`delivery-inputs-check.log` and `final-tools-preservation.log` under the path above.

Read-only setup/evidence review covers IcyDB, Canic, IC Timers, IC Backup,
IC Blob Storage and Toko Miner. Their common Make routes keep checkout selection
and product extensions locally; no arithmetic attribution, state, persistence
or endpoint change is required. `downstream-inputs.tsv` binds reviewed HEADs and
committed/current input hashes; untracked inputs and working edits are identified
separately. This review performs no owning builds or sibling mutations and does
not claim their adoption or qualification.

Upstream 0.5.0 aligns the native failure qualifier with the Rust slot contract;
the earlier failed 0.4.1 run remains historical. The exact-source
[Shared CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/38132790945)
reports passing Linux regression and lint jobs, including reuse and failure
retention; both macOS lanes are queued at inspection. These observed statuses
are not independently downloaded receipt acceptance. Matching upstream native
and subsequent Metrics hosted acceptance remain separate from local checks.
[#60](https://github.com/dragginzgame/ic-metrics/issues/60) tracks consumer adoption;
[Shared #120](https://github.com/dragginzgame/shared-tooling/issues/120) owns shared
storage and its remaining Cargo identity/native qualification obligations.
