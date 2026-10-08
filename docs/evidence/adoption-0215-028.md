# Shared Tooling 0.1.28 adoption

The compatible pending 0.2.15 batch advances from the earlier
[db039 preparation](adoption-0215.md) to reviewed committed Shared Tooling 0.1.28
`1872ed2c20f6c70689bb2249050b1d673c60bfa0`. Preparation starts from local
`30fa5dc9ebc5438ae1a58383d3eb642dcb27cdb5`; the public remote still selects
released 0.2.14. Workspace/package versions remain 0.2.14. The exporter runs from
a clean detached clone with the canonical HTTPS origin, excluding all subsequent
uncommitted sibling work.

The canonical snapshot selection grows from 75 to 90 files. Fifteen explicit
additions are the independent release-tracking fixture, thirteen maintenance
catalog/task/service-template files and their coordinator script. No schedule,
background agent or service is enabled. Shared rule links require the complete
catalog; the optional coordinator remains host-owned and inactive here.

The installer now retains literal active-link bytes rather than authenticating
a newline-trimmed sibling. The affected host and IC fixtures prove one/two trailing
newlines are refused by setup and check, with no executable invocation, download
or installer lock and with the exact link left unchanged. This adopts the owning
fix for [Shared Tooling #75](https://github.com/dragginzgame/shared-tooling/issues/75).
Real-Git tracking qualification is moved out of the simulation fixture under
[Shared Tooling #70](https://github.com/dragginzgame/shared-tooling/issues/70).
The consumer's configured gate explicitly selects both fixtures, retaining all
19 real-Git scenarios. Native source receipts now include the new fixture.
No function, method or type is removed; the extracted tracking body moves to its
own script. The snapshot also documents package-specific MSRVs, preserving the
arithmetic Rust 1.85 and private host Rust 1.88 paths already qualified separately.

Actual focused Linux Bash 5.2 and genuine Bash 3.2.57 checks pass for host/IC
installer rejection and retention, release simulation, all 19 isolated real-Git
tracking cases and the consumer's native evidence/archive fixtures. The Bash 3.2
PATH selects that interpreter for nested calls. Installer downloads and Make
effects are substituted; tracking commits/tags/pushes affect only disposable
repositories. No live GitHub release effect or full local CI gate runs.

Offline host/Rust/IC executable verification, snapshot/pins, formatting,
documentation links, ShellCheck and workflow lint pass. Repeat canonical refresh
verifies all 90 recorded digests and modes. Cargo manifests/lock, executable pins
and arithmetic source bytes compare unchanged with the pre-adoption inputs.
Logs, original snapshot, selected-source review and input hashes remain in
`target/evidence/adoption-0215-028/`.

The reviewed upstream
[0.1.28 workflow](https://github.com/dragginzgame/shared-tooling/actions/runs/37799837183)
passes Linux and lint/security at the initial source review; Apple Silicon later
starts and Intel remains queued. Neither that observation nor these local checks
is completed committed consumer native acceptance. The earlier release's completed
[0.2.14 matrix](release-0214.md) retains its own source/snapshot identity.
[#34](https://github.com/dragginzgame/ic-metrics/issues/34) retains the new coherent
batch's exact-source native and downloaded-receipt obligation;
[#36](https://github.com/dragginzgame/ic-metrics/issues/36) separately covers the
private inspector. No sibling file edit, dependency upgrade, package version
change, commit, push, publication or release command is part of adoption.
