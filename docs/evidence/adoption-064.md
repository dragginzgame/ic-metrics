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

Explicit `make install-tools`, then `make tools-check`, prepares/admit the selected
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
package/workspace metadata stays 0.6.3. The pre-existing Host 0.13.2 working lock
selection and earlier release-evidence edits are preserved, not selected by the
adoption. No sibling source/build, real staging, commit, tag or release is performed.

## Qualification

The snapshot, selected ShellCheck/workflow lint and focused common tool/store
and custom native-evidence fixtures pass. Real setup, offline checking,
two-checkout reuse, older-shell compatibility and full delivery validation are
being qualified against the new source. Existing local tool file hashes are
retained before setup; failed attempts remain separately recorded.

[#61](https://github.com/dragginzgame/ic-metrics/issues/61) owns Metrics' adoption
and delivered-source native acceptance. Shared
[#120](https://github.com/dragginzgame/shared-tooling/issues/120) owns the common
storage/build contract, and [#121](https://github.com/dragginzgame/shared-tooling/issues/121)
owns safe incomplete collection. The separately delivered Shared 0.5.0 batch
retains its own acceptance in [#60](https://github.com/dragginzgame/ic-metrics/issues/60).
Local substitutes and Linux older-shell checks do not establish native macOS
acceptance; the exact-source upstream/consumer hosted results remain separate.
