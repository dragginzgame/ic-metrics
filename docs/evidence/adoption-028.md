# Shared Tooling 0.1.18 adoption

## Source and ownership

The clean detached checkout `/tmp/ic-metrics-shared-018-reviewed` selects
`a3430b34b32a60f3b245a2b4f7e2f5321556fe56` (Shared Tooling 0.1.18), with
the existing canonical HTTPS remote. The committed diff from adopted
`88f1d70cdf671aefb9507d7a81411ed5daa358b3` was reviewed. The canonical
distribution helper refreshes the declared file set, adding the Rust installer
and its reusable fixture explicitly. The resulting 67-file snapshot verifies
with both the consumer verifier and the trusted source-checkout verifier.
No snapshot-owned file is hand-patched or attributed to dirty sibling source.

The scope is [#22](https://github.com/dragginzgame/ic-metrics/issues/22), with
active release/caller documentation corrected under
[#21](https://github.com/dragginzgame/ic-metrics/issues/21). Pending 0.2.8 is
compatible from finalized 0.2.7: arithmetic APIs, source, Cargo package/workspace
versions and locked dependencies stay unchanged. The finalized changelog and
historical evidence retain their original content and identities.

## Propagation

The shared logger admits the complete named-target list before creating
validation logs or running a gate, rejecting Make options, assignments and
control characters. LOC fixtures isolate ancestor Cargo configuration; the
reporter excludes existing physical build paths behind configured symlinks.
The tooling-inventory consumer fixture now checks adopted working-tree bytes;
committed exporter integration remains upstream-owned. Its removed procedural
export case deletes no function, method or type.

The shared Make include provides explicit checkout-local Rust installation and
offline checking. This Rust consumer attaches those to `install-tools` and
`tools-check`, checks the set in native CI, and removes the separate CI manifest
formatter installation recipe. CI uses the same setup/check targets, exports
`.tools/rust/bin`, records all three tool versions and helper/fixture hashes,
and retains failed Rust install/build output. Hook and release scratch exports
keep their complete actual formatting dependency set; neither implicitly installs
tools. The reviewed pin catalog is the sole version owner:

| Executable | Selected version |
| --- | --- |
| cargo-sort | 2.1.4, unchanged |
| cargo-sort-derives | 0.13.0 |
| candid-extractor | 0.1.6 |

Explicit real installation passes with locked Cargo tool dependencies on Linux.
The complete offline Rust, host and IC checks pass. These Rust checks verify
successful version output, not independent authentication of installed bytes.
Installation/build logs and source identities remain in
`target/evidence/adoption-028/`; build artifacts stay in `.tools/rust/build`.
No product lockfile is updated by preparation.

## Focused checks

Linux Bash 5.2.21 passes local installer/tool-command/LOC fixtures, formatter
prerequisites, release command/metadata/admission/recovery and formatting-hook
checks. The release adapter executes the actual Make/logger boundary with
declared Cargo/cheap-gate substitutes and real scratch Git admission checks;
no commits, tags, pushes or registry effects occur. The canonical upstream logger
fixture also passes against the exact adopted script bytes. Dependency pins,
snapshot integrity, manifest/Rust formatting, ShellCheck with followed sources
and workflow actionlint pass. No full local CI or product tests are repeated for
the unchanged arithmetic library.

Linux GNU Bash 3.2.57 also passes `local-tools-test`, `release-tools-check` and
`hook-check`, including nested shell invocations, checkout-local retained TMPDIR
and inherited consumer `CARGO_TARGET_DIR`. The canonical upstream logger fixture
passes under that shell as well. These are portability observations, not native
macOS qualification.

The original Bash 3.2 attempt stops before executing a fixture because its
previous temporary executable no longer exists; `tooling-bash32-missing-shell.log`
preserves that attempt. A replacement temporary GNU Bash source archive is
verified against GNU's signing keyring before compilation; its signature,
source hashes and preparation logs remain alongside the checks. The first build
attempt reports missing yacc; temporary distro-verified Bison/M4 packages supply
parser generation without modifying system packages. The resumed build succeeds.

[Upstream CI run 37604299590](https://github.com/dragginzgame/shared-tooling/actions/runs/37604299590)
passes Linux, macOS 15 Intel, macOS 15 Apple Silicon and lint/security at the
adopted revision. This consumer's new committed native CI still requires its
own source-bound result. [release-027.md](release-027.md) binds the complete
released consumer matrix and archive; it does not qualify this working tree.

The read-only downstream observation is bound in
[the current handoff](../status/current.md) and `downstream-inputs.txt` beside
the logs. It covers six concrete callers and distinguishes Toko's dirty lock
from committed selections. No consumer files are edited or native/runtime
qualification inferred from a lock update. Local Markdown links and scoped
diff preservation checks cover the active documentation correction.
