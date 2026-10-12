# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and endpoints.
See [the extraction contract](../extraction.md) and [host qualification](../hosts.md).

## Pending 0.8.1

The [summary restoration fix](../evidence/summary-restoration-081.md) rejects
exact totals incompatible with the latest observation using the existing typed
error. Durable load/save refuses the inconsistent record without overwriting
its bytes. Valid states, recording, public signatures and V1 encoding stay
unchanged. Focused restoration/corruption tests and native/Wasm Clippy pass.
The restoration batch's full CI passes in 258 seconds and all package-floor checks
pass, with every checkpoint matching its 136 source inputs at that gate.
The archived receipt preserves failed reproductions and distinguishes the
final Rust changes from the earlier tooling slice. Cargo graph and pins stay fixed.

The snapshot selects clean committed/public Shared Tooling 0.9.6
`7e9f062f53baad2059a8585e2fffe2b98f03bafd` from an isolated detached checkout.
All 102 payloads and 90 roots stay selected, including the canonical real-download
retry fixture. Transient asset downloads retry
within bounded limits; permanent HTTP and checksum failures remain terminal.
Snapshot and release identities require complete 40/64-character Git hashes;
PR JSON identities reject trailing newlines before extraction or state writes.
The artifact readback discovery change stays in Shared's owning workflow;
Metrics adds no upload replay, downloader or token requirement. Release delivery
remains direct-only. The tooling slice changes no product Rust, Cargo graph or
pins; compatible 0.8.1 notes cover the restoration fix and adopted tooling/coverage.

[The 0.9.6 review](../evidence/adoption-081-shared-096.md) records the two-payload
canonical refresh, passing isolated upstream PR recovery fixture and ShellCheck.
The final 0.9.6 batch's full CI passes in 263 seconds and all package-floor gates
pass, with eight checkpoints matching 136 frozen/current inputs. It preserves
the existing product Rust, Cargo graph, pins and release policy; all receipts
retain their original source/snapshot scope.

[The earlier 0.9.5 adoption receipt](../evidence/adoption-081-shared-095.md) records passing
real-curl recovery/refusal, snapshot distribution, ShellCheck and workflow lint.
Its full CI passes in 286 seconds; all three package-floor gates pass. Every gate
checkpoint matched its 136 source inputs at that gate. This is local Linux
qualification of the pre-restoration-fix tooling slice; its receipt survives Cargo clean.

## Published 0.8.0

Local HEAD, public main and peeled v0.8.0 agree on
`71a29d8a4d7ecf6774d9715895ce9abd13b9e5d7`. Both official non-yanked packages
verify, including all 11 arithmetic and four stable Rust sources. Core stays
feature/dependency-free on Rust 1.85; stable/inspector floors stay 1.88.
[Publication verification](../evidence/release-080.md) binds exact package and
source identities. Release CI was queued at the first observation; Linux native
and package-floor jobs subsequently pass, while both macOS jobs remain queued.
Publication does not complete [#66](https://github.com/dragginzgame/ic-metrics/issues/66)'s
released-source native acceptance.

The [prepared cut and matched IC experiment](../evidence/tracked-080.md) retain
0.7.3 metadata and their explicit frozen experiment graph. The preparation's
258-second full CI/floor receipt remains separate from the released metadata;
all stable Rust sources and V1 encoding stayed unchanged. Earlier
[0.7.3 native acceptance](../evidence/release-073.md) retains its own source.
Historical handoff text remains in [the frozen archive](history-through-073.md).

## Consumer qualification

All six [0.8 adoption owners](../evidence/tracked-080.md#read-only-consumer-review)
now have a published registry dependency available. Four raw-field callers need
tracked recording/report propagation; Timers and Backup already use tracked
state and need graph/public-type qualification. Owning issues remain open;
publication or a dependency update alone is not consumer acceptance.

[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) separately
retains Canic's original native/interleaving obligation. The last authorized
scoped repair passed Host Clippy, Linux resolver tests and explicit peer refresh.
Its held-HTTP attempt reached PocketIC but failed the required canister_test
Wasm on Auth dead-code errors; no current-graph pass is claimed. Canic
[#491](https://github.com/dragginzgame/canic/issues/491#issuecomment-6126296804)
owns that integration blocker and
[#450](https://github.com/dragginzgame/canic/issues/450#issuecomment-6126296388)
retains native repair qualification. Full logs and input/fixture identities remain
outside Cargo clean in Canic's `.tmp/metrics-qualification-20261012/`.
This follow-up mutates Metrics only; no versions, index/refs or release effects.
