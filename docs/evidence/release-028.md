# Published 0.2.8 observation

On 2026-10-07, released ic-metrics 0.2.8 source is
`0eac2b0baa9d03b8f2430a24dfe596d93f5bfc16`. The official registry index
reports the non-yanked package with no dependencies or features and Rust 1.88.
The downloaded archive has SHA-256
`2ff922721253a9e6d921203809d99e871128edfc5b0613661c64d094d58343d6`.
The checksum, embedded Git revision and `crates/ic-metrics` path verify; all five
Rust source files, application guide, original manifest, README, license and
lock match released source. Inputs and extracted payload remain under
`target/evidence/release-028/`. Publication is distinct from consumer deployment.

[CI run 37617053341](https://github.com/dragginzgame/ic-metrics/actions/runs/37617053341)
passes Ubuntu 24.04 native, macOS 15 Intel native, macOS 15 Apple Silicon native
and Linux MSRV at that exact source. This review verifies job outcomes, not
independent authenticity of every uploaded artifact. The released 67-file
snapshot selects Shared Tooling 0.1.18
`a3430b34b32a60f3b245a2b4f7e2f5321556fe56`; preparation remains bound in
[adoption-028.md](adoption-028.md), without relabelling its earlier pending state.

The complete native matrix closes the owning adoption requirement in
[#22](https://github.com/dragginzgame/ic-metrics/issues/22). Subsequently confirmed
Rust-path, temporary-path and changelog-admission boundary defects are separate
from those passing gates; their repair adoption belongs to
[#23](https://github.com/dragginzgame/ic-metrics/issues/23) and
[adoption-029.md](adoption-029.md). A successful matrix does not prove cases its
fixtures did not cover.

Arithmetic source and its consumer ownership contract are unchanged from 0.2.7.
The original IC histogram measurements retain their identities and domain limits
in [histogram-cost-026.md](histogram-cost-026.md). Consumer adoption/runtime evidence
remains in [#4](https://github.com/dragginzgame/ic-metrics/issues/4) and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10), with exact local
source/lock distinctions in [the handoff](../status/current.md). No sibling source,
package version, commit, release or hosted run was changed for this observation.
