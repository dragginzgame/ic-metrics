# Shared Tooling 0.6.0 adoption for Metrics 0.6.4

Released Metrics base is 0.6.3
`b51e30743ad23a74ef02fef0edcf2b3acca6d4e3`. Reviewed committed/public Shared
source is 0.6.0 `75180980a0c4e4252d8a915aaecfaefd92bf9a4e`, exported canonically
from a clean detached checkout. Preview preserves all 96 existing selections,
identifies 16 updates and one required companion. Explicitly adding
`scripts/dev/cargo-tool-build.sh` yields a verified 97-file snapshot, with 80
existing files unchanged. The first preview refused the clone's local source
remote; only that detached clone's remote was corrected before export. No shared
snapshot file is patched independently. Logs are under `target/evidence/adoption-064/`.

## Current contract

Host, IC and Cargo payloads share the canonical per-user store, keeping each
checkout's pins and exact selections. `.tools/rust/common/bin` remains the common
PATH. Cargo builds use the shared standard environment with exact compiler,
native inventory, source archive, packaged lock, target and profile identities;
consumer application flags and wrappers do not configure tool compilation.
The managed source cache is required for offline admission. Existing physical
local installations, successful/failed generations and build evidence remain
retained; checks never install, repair or fall back to those old slots.

Explicit `make install-tools`, then `make tools-check`, prepares and admits the selected
tools. Use the same optional shared-store setting for setup, checks and collection.
Selected CLI callers must consume the installer's returned path; Metrics has no
production selected-Cargo adapter or version-only path reconstruction to replace.
The common Make/formatting/hook callers keep their documented local PATH.

The Metrics native collector consumes canonical local Rust and referenced shared
selections once. Failed shared-store admission retains safe local inputs,
selection diagnostics/status and the complete native upload, then fails the
collection step. The unchanged subsequent upload condition admits that archive.
Consumer fixtures exercise recovered shared Rust bytes/modes/links, independent
local failed compilation, unrelated-generation exclusion and invalid-store
retention without dereferencing its links. These use isolated temporary stores.

This is compatible pending 0.6.4 at Metrics' published consumer boundary. Public
arithmetic sources/API/state/behavior, tool pins and Rust floors remain unchanged;
the adoption was prepared and locally validated with 0.6.3 package/workspace
metadata. The pre-existing Host 0.13.2 working lock selection and earlier
release-evidence edits were preserved during adoption, rather than selected by
it. The subsequent maintainer-selected Host 0.13.3 graph is checked separately
below. The agent performs no sibling source/build, real staging, commit, tag
or release.

## Qualification

The 97-file snapshot, selected ShellCheck, actionlint, focused common tool/store
and custom native-evidence fixtures pass. Real canonical `make install-tools`
and complete offline `make tools-check` pass. A fresh temporary checkout with
the same prepared Rust 1.99.0 compiler selects the same three physical Cargo
binaries; an actual `execve` trace records zero Cargo `info` or `install`
dispatches. The first temporary checkout selected the default `stable` toolchain
instead, producing distinct build identities and failing the physical-selection
comparison. Its trace, logs and generated sets remain retained; it is not reuse
evidence. The successful retry uses separate `reuse-retry-*` evidence.

Genuine Bash 3.2.57 and Make 3.81 pass the canonical Cargo installer fixtures,
native collector fixtures, hooks and formatting checks on this Linux host.
Both selected Clippy gates pass without warnings. Arithmetic Rust 1.85 native
and Wasm checks and the private inspector's Rust 1.88 check pass against the
preserved Host 0.13.2 working lock graph. These do not relabel the released
Host 0.13.1 graph or earlier native evidence.

Full `make ci` passes in 251 seconds (12:00:24–12:04:35 UTC on 2026-10-11),
recorded in `ci-retry-2.log` and its status/timestamps. All 105 frozen
code/graph/pin/Make/workflow/snapshot inputs, all 2,394 earlier physical tool
files and the pre-existing working lock retain their recorded hashes immediately
afterward in the `*-retry-2-*` preservation checks.
The initial CI attempt and first retry refused a concurrent shared IC-tool
installation lock before compilation; both logs remain retained. No lock was
removed or bypassed. Final link, snapshot and diff checks pass for the agent's
subsequent documentation changes.

During qualification, the maintainer commits the adoption as
`ddcd7665ac44f3f903b3c4d0faf2eb0963033a29`, then prepares 0.6.4 package/workspace
metadata and dates its changelog after the successful local gate. The later
`final-delivery-inputs-check.log` and `final-working-lock-check.log` correctly
report changed Cargo metadata; the two changed frozen inputs are `Cargo.toml`
and `Cargo.lock`; at that observation, their diff advances only the two workspace
package versions.
Those maintainer changes are preserved. The 251-second result remains evidence
for the 0.6.3-metadata adoption inputs, not a successful gate for the separately
prepared 0.6.4 release. No released 0.6.4 identity or publication is claimed here.

Read-only review of IcyDB, Canic, IC Timers, IC Backup, IC Blob Storage and Toko
Miner records committed and working inputs separately in `downstream-inputs.tsv`
and `downstream-setup-review.log`. Existing selected CLI adapters consume the
canonical returned path; their setup and owning qualification remain independent.
This review runs no sibling build and makes no sibling edits.

The exact-source [Shared CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/38136593268)
reports successful Linux regression and lint/security jobs; Intel and Apple
Silicon lanes remain in progress at that adoption observation. That upstream run
does not establish delivered Metrics native acceptance.

## Subsequent working-graph review

The next review preserves the maintainer's separate Host 0.13.3 lock selection
and prepared 0.6.4 metadata. Inspector Clippy with warnings denied, all-target
checks and Rust 1.88 pass against that exact working graph. Cargo metadata,
lock and changelog hashes remain unchanged during these checks; logs are under
`target/evidence/release-064/host-0133-*`. Committed Host 0.13.3 changes contributor
tooling; the consumed artifacts/filesystem Rust trees are unchanged from 0.13.2.
This focused result does not replace the earlier full gate or establish
delivered-source native acceptance for the changed graph.

Public main still points to 0.6.3, and no public 0.6.4 tag or sparse registry row
is visible at this later review. The adopted Shared 0.6.0 Apple Silicon regression
has now failed in its Rust fixture. The owning
[padded-count issue](https://github.com/dragginzgame/shared-tooling/issues/124)
and Cargo setup failure propagation corrections are present only in dirty
pending Shared 0.6.1. Wait for clean committed canonical distribution; no
snapshot file is patched locally. Earlier observations above retain their
source identities and statuses at the time of inspection.

[#61](https://github.com/dragginzgame/ic-metrics/issues/61) owns Metrics' adoption
and delivered-source native acceptance. Shared
[#120](https://github.com/dragginzgame/shared-tooling/issues/120) owns the common
storage/build contract, and [#121](https://github.com/dragginzgame/shared-tooling/issues/121)
owns safe incomplete collection. The separately delivered Shared 0.5.0 batch
retains its own acceptance in [#60](https://github.com/dragginzgame/ic-metrics/issues/60).
Local substitutes and Linux older-shell checks do not establish native macOS
acceptance; the exact-source upstream/consumer hosted results remain separate.
