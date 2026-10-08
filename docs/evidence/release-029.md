# Published 0.2.9 observation

On 2026-10-07, released ic-metrics 0.2.9 source is
`ec6c25018d859acfcdf1e400bc7bbb1e19d734f0`. The official registry index
reports the non-yanked package with no dependencies or features and Rust 1.88.
The downloaded archive has SHA-256
`cf016e1f1a34a25b8941522f9745dcc358f19787588efdbe53b97f509d2456e5`.
Its checksum, embedded Git revision and `crates/ic-metrics` path verify. All five
Rust files, packaged guide, original manifest, released README, license and lock
match released source. Registry inputs and the extracted package remain under
`target/evidence/review-030/`. The unavailable crates.io metadata API returned
403; publication was verified through the official sparse index and static
archive instead, without changing Cargo selection.

[CI run 37646831013](https://github.com/dragginzgame/ic-metrics/actions/runs/37646831013)
at that source passes Linux native, macOS 15 Intel native, macOS 15 Apple Silicon
native and Linux MSRV. All three downloaded native archives verify their outer
and payload checksums, exact source-file hashes,
run/host identity, successful setup outcomes and native gate logs. The native
gates execute the adopted setup/release fixtures and the controlled workflow
evidence fixture. Those substitutes qualify failure handling; successful hosted
jobs do not demonstrate actual hosted setup failures. This completes owning
native qualification for
[#23](https://github.com/dragginzgame/ic-metrics/issues/23) and
[#25](https://github.com/dragginzgame/ic-metrics/issues/25).

The released 68-file snapshot selects Shared Tooling 0.1.19
`a06e4719e3839b8eefcfb88ec8923aa88eb63ccc`; its earlier preparation remains
bound in [adoption-029.md](adoption-029.md). The subsequently reviewed policy
adoption is separate in [adoption-0210.md](adoption-0210.md).

The [new histogram replay](histogram-replay-029.md) is durably delivered at this
source. An independently downloaded public archive matches SHA-256
`bede3e2f63cbcf95b482323dc0135034220de0b7166fc48ad6f8ae8548bd4cfb`
and every extracted payload checksum. This completes
[#26](https://github.com/dragginzgame/ic-metrics/issues/26). Its frozen direct
arithmetic build/replay proof retains its original source and workload identity;
the older unavailable Canic experiment remains distinct historical evidence.

Arithmetic source and consumer ownership are unchanged from 0.2.8. Root
publication and tooling CI do not qualify consumer runtime/native adoption;
[the handoff](../status/current.md) and issues
[#4](https://github.com/dragginzgame/ic-metrics/issues/4) and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) retain that boundary.
No sibling files, Git history, package metadata or hosted runs were changed for
this observation.
