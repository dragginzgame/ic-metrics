# Complete common toolset adoption for pending 0.5.0

Metrics starts from released 0.4.0 `97ec991776bb16efbab59faeb43bc72ce9ebcefa`,
preserving the preceding release-verification/governance edits. The user requested
adoption of Shared Tooling's complete common set. Reviewed source is committed
0.3.0 `88a73139a0f083344c41a6f6f4b5c3a8aca7dc1d`, matching public main at
inspection. The canonical exporter uses a clean detached clone with the exact
recorded origin and retains all 93 selected files. Dirty sibling dashboard edits
and fleet helpers are excluded.

The producer always installs/checks the complete jq/yq/ripgrep-with-PCRE2/cloc
set. Its `--with-ripgrep` and `--with-cloc` flags are retired without aliases;
direct callers must remove them. The shared aggregate sequences host, five IC
executables and three Cargo tools, then declared product-owned target lists.
Metrics removes duplicate Rust aggregate prerequisites and has no extra product
tool target. Existing tool pins, Cargo selection, prepared bundles and arithmetic
source are preserved during the tooling adoption. A subsequent incoming private
Host 0.12.0 selection is [qualified separately](host-dependencies-0120.md);
the original gate/preservation records stay bound to Host 0.11.0. The command
cut selects pending 0.5.0 under the pre-1.0
compatibility rule; package/workspace versions remain 0.4.0. The tooling adoption
requires no consumer data reset, dependency-graph update or platform reader.

Native CI now invokes `make install-tools` and then `make tools-check`, retaining
distinct setup/check logs and one common tool outcome. It prepares the declared
Rust toolchain and system prerequisites first. Full CI checks the complete set
offline before dependent gates; ordinary checks never install. Failed candidates,
raw diagnostics, source receipts, formatting logs and Git release intent/index
are still retained through the owning collector. Earlier nine-outcome receipts
keep their original source/format; the new workflow records seven actual outcomes.
No legacy receipt reader or production fallback is added.

The actual consumer native-evidence fixture runs the real aggregate under
parallel Make, substituting recursive leaf effects only. Its ordering assertion
covers every common setup/check boundary and prevents later checks/native work
after refusal. It preserves Make's aggregate failure status, leaf diagnostics,
failed archive bytes and cancellation-independent collection. Initial controlled
fixture attempts refused because the substitute Make shadowed the execution
probe and its scratch directory had not been created; the fixture now identifies
the real Make executable and creates its owned temporary directories first.
Those failed inspection attempts remain separate evidence.

Actual complete `make install-tools` and a separately invoked `make tools-check`
pass on Linux, reusing the existing prepared 12-tool set. This is real aggregate
routing, authentication and reuse/admission, not a fresh cold registry build.
Selected ShellCheck and workflow lint pass. Genuine GNU Make 3.81/Bash 3.2
checks pass for the complete host installer, canonical parallel tool routing,
actual native collector/aggregate and admitted release preparation. Host asset
mappings and installation failures in those fixtures remain substitutes.

Complete Linux validation passes through the actual shared logger: `ci`
(176 seconds), arithmetic Rust 1.85 host/Wasm and inspector Rust 1.88 all-target
checks. It includes warning-denied Clippy, unit/doctests, actual CLI, formatting/
hooks, release/admission/retention, pin and installer/evidence checks. Preservation
verifies 16 original graph/pin/arithmetic/release-adapter inputs and 88 frozen
delivery files. Later documentation-only updates use narrower link/consistency/
diff checks. A later final preservation check detects the incoming manifest/
lock change, retains its mismatch log, and qualifies the updated graph separately;
the original results are not relabelled. Other validated code remains unchanged.
The updated Host 0.12 graph subsequently passes complete `ci` (169 seconds) and
both package-floor gates, with preservation of its own frozen 88 delivery inputs.
The actual consumer collector and release-admission fixtures pass again under
GNU Make 3.81/Bash 3.2 with that graph. These current records are retained under
`target/evidence/host-0120/`.

The read-only IcyDB, Canic, Timers, Backup, Blob and Toko review records their
local source identities and dirty caller declarations separately from committed
or native acceptance. Common tool adoption stays in the owning Shared #98-linked
issues. No product arithmetic, counter read, attribution, reset, persistence or
endpoint adapter needs changing for this tooling cut.

Inputs, canonical refresh, source review, preserved hashes and check logs are
under `target/evidence/adoption-050/`; owning follow-up
is [Metrics #47](https://github.com/dragginzgame/ic-metrics/issues/47), separate
from [Shared #98](https://github.com/dragginzgame/shared-tooling/issues/98).
Exact upstream CI passes Linux and lint/security; its two macOS jobs remain
queued at final inspection. Delivery and exact-source consumer native acceptance
remain pending; local substitutes and previous releases do not establish them.
No sibling source edit, resolver, package-version change, commit, push, release,
publication or workflow dispatch is performed.
