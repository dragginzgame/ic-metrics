# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns integration boundaries;
[host qualification](../hosts.md) owns validation commands and delivery gates.

## Prepared 0.12.0

This is a breaking stable-package API cut. Package/workspace versions remain
0.11.8; the incoming manifest/lock selection of Memory 0.45.0 is preserved.
The public generic `DurableMetric` bound and `load`/`save` are replaced by concrete
counter, aggregate, summary and const-generic histogram operations. Histogram
loads take finite bounds directly, admitting size/order before reading a row.
The [stable guide](../../crates/ic-metrics-stable/README.md#store-operations)
owns the caller changes. Codec/configuration dispatch stays private without the
old capability token. V1 bytes, kind IDs, typed corruption/regression refusal,
unchanged-checkpoint write avoidance and one-map reopening remain intact.

Hosts retain permanent allocation keys, bootstrap and collection lifecycle.
Production callers supply checked `ic_memory::RuntimeMemory`; native tests use
isolated `VectorMemory` only for codec/storage behavior. Memory 0.45's separate
allocator-format retirement stays with the host's explicit disposition. This
batch neither resets retained memory nor introduces another memory-ID allocator.

Shared Tooling is selected at reviewed commit
`7f792c92f623a410c521ee3261dc9fb6b24d2f2f` from the isolated
[PR #254](https://github.com/dragginzgame/shared-tooling/pull/254), with its display
version 0.18.0 and pending optional-bundle contract. All 113 snapshot files were
refreshed through the distribution helper from a clean committed checkout.
Common setup, offline checking, version reports and PATH now require host/Cargo
tools. IC executables remain explicit product selections for optional experiments;
Metrics' workflow no longer projects unused IC receipts. No pins were upgraded.
An existing invalid Cargo-tool receipt first failed offline admission; explicit
pinned setup repaired the selection, and actual offline checks then passed.

The statistics partitioning candidate was rejected after matched IC execution.
It adds 1,267 raw Wasm bytes and regresses every measured five/eight-sample case;
larger inputs have mixed results. The arithmetic source is restored byte-for-byte.
The [frozen study](../evidence/sample-selection-0120.md) owns the rejected source,
720 raw observations and independently reproduced Wasms/instruction/cycle rows.
The sorted-slice, summation-order and typed-error contracts remain unchanged.

Focused Linux qualification passes: 17 stable unit tests, three compiled API
examples, native/Wasm Clippy, native/Wasm Rust 1.91 package checks, actual common
tool/pin/snapshot checks, workflow evidence and release/hook retention fixtures.
Before-images and logs remain under `/tmp/metrics-hard-cut.PHfsVi/`. Full local
CI/MSRV workspace gates and native macOS qualification were not run for this batch.
The first Shared hosted run exposed an old tool-command fixture expectation; it
was corrected and its normal/path-context cases pass locally. The updated PR
retains its required hosted matrix; local fixtures are not native-host acceptance.

Bounded source review found no stable-package callers in the selected public
IcyDB, Canic, Timers, Backup and Blob Storage crate/manifest paths. The published
contracts still require owning adoption review; excluded private repositories
were not inspected. First durable-consumer acceptance stays with
[#83 — Qualify the first opt-in durable scalar counter consumer](https://github.com/dragginzgame/ic-metrics/issues/83).
Observer publication/adoption stays with
[#82 — Adopt published Testkit memory observations and retire the local observer](https://github.com/dragginzgame/ic-metrics/issues/82).
The local observer remains until a supplying package is published.

The root index, Git refs, package versions and original incoming dependency
selection are unchanged. Metrics source changes remain uncommitted; only the
isolated Shared contribution has scoped commits and a topic-branch push.

## Finalized 0.11.8

Commit `05a83629ee8789926db5f3af4528fc5afe689472` identifies the finalized
baseline. Both registry packages are present and non-yanked at 0.11.8.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38929177858)
passes Linux, both native macOS runners and the native/Wasm MSRV job. This
qualifies the released Memory 0.44 graph, not the pending hard cut.

The [source-bound preparation handoff](https://github.com/dragginzgame/ic-metrics/blob/05a83629ee8789926db5f3af4528fc5afe689472/docs/status/current.md)
retains the earlier Memory integration, logger ownership and stable-test cleanup
identities, frozen artifacts and qualification limits.
