# Published 0.2.7 observation

On 2026-10-07, tag `v0.2.7`, local HEAD and remote main identify
`09c6786c3b68759ea0ead4d1b987b5a9b472bdbb`. The official registry index
reports non-yanked ic-metrics 0.2.7, no dependencies or features and Rust 1.88.
The downloaded archive has SHA-256
`9b54584cd8658046ca874ec9d67ba7fb7a5028e11467da1cce1a0bf62e6495cd`.
Its embedded Git revision and `crates/ic-metrics` path match the release; all
five Rust source files, application guide, original manifest, README, license
and lock match tagged source. This establishes publication, not deployment.

The registry inputs, archive and extracted payload remain under
`target/evidence/release-027/`; exact-source CI observations remain under
`target/evidence/closeout-027/`. Earlier arithmetic and actual IC histogram
measurements retain their original bindings in [arithmetic-026.md](arithmetic-026.md)
and [histogram-cost-026.md](histogram-cost-026.md).

## Exact-source CI

[Run 37602306391](https://github.com/dragginzgame/ic-metrics/actions/runs/37602306391)
selects the release commit and passes the complete native gate on Ubuntu 24.04,
macOS 15 Intel and macOS 15 Apple Silicon, plus Linux MSRV. Job/step observations
establish gate outcomes; this observation does not independently authenticate
every uploaded 0.2.7 artifact. The released 65-file snapshot records Shared
Tooling `88f1d70cdf671aefb9507d7a81411ed5daa358b3`, whose complete native
matrix also passes in
[run 37601115116](https://github.com/dragginzgame/shared-tooling/actions/runs/37601115116).

This completes owning native qualification for the recorded 0.2.6 arithmetic
additions and 0.2.7 tooling correction, without rewriting their earlier failed
or pending observations. [adoption-027.md](adoption-027.md) preserves preparation
and rejection evidence; [release-026.md](release-026.md) preserves the earlier
LOC fixture failure. The library still owns only arithmetic and has no IC reader,
consumer attribution, persistence or endpoints.

## Consumer boundary

Root publication and CI do not qualify consumers. The fresh read-only source
inspection in [the current handoff](../status/current.md) covers six actual
callers, separating committed and dirty locks. IC Blob Storage's caller is a
restoration test probe; Toko Miner's production action-count cohorts are not
instruction-value histogram bins. IC Backup's byte histogram and IcyDB's CLI
mean projection remain consumer-owned. Adoption and attribution evidence stay
in [#4](https://github.com/dragginzgame/ic-metrics/issues/4) and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10), with the owning
consumer issues linked from the handoff. No sibling files or release identities
were changed to produce this record.
