# Memory 0.49 governed-store comparison

This qualification binds Metrics source based on finalized 0.14.6
`69e086af4aaa7f07a4b6664b500a5a9c53eceb12`, the pending V1 mutation test, and the
maintainer-selected Memory 0.49.0 / Storage 0.5.7 product graph. The matched baseline
selects Memory 0.48.2 / Storage 0.5.6. Both canisters use the same copied product
Rust source, probe, protocol, compiler, profile and workload. Package versions stay
0.14.6; no product API, stored Metrics V1 byte layout or release effect changes.

The previous [governed-store receipt](stable-current-0146.md) remains unchanged.
Its recorded numbers are not the matched baseline here: this probe adds a bounded
bootstrap measurement and response field, and uses independently locked graphs.

## Dependency and execution identities

Canister workspaces are independently locked from the native host driver. Every
registry package in the candidate product lock has the same version/checksum in
the candidate canister lock, including `thiserror` 2.0.21 and its implementation.
Testkit's native `thiserror` 2.0.18 pin does not alter either canister graph.
There are 96 baseline, 91 candidate and 317 host lock rows. Source-less rows are
only each workspace's owned packages; no sibling path dependency is admitted.
The archive retains all three locks and their registry checksum rosters.

The before/after canisters select published Platform 0.1.18 and Wire 0.4.7.
Platform owns runtime calls and entry macros; controlled messages use bounded
Wire frames and explicit method/field identities. Platform's CDK runtime retains
its own transitive Candid machinery; the probe authors no Candid protocol.
The host selects published Testkit 0.55.2, which owns Wire calls, server-asset
admission, bounded startup and instance/server teardown. It checks the already
prepared PocketIC 16.1.0 server; replay never downloads or installs it.
The admitted Linux server SHA-256 is
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

Rust 1.99.1 compiles the experiment on Linux x86_64, with opt-level=z, LTO, one
codegen unit, symbol stripping and panic abort. There is no postprocessing.
The compiler's full identity and product input receipts are retained. This is
focused IC qualification, not native macOS, Rust-floor, full release CI, mainnet
or application acceptance. Neither product library gains experiment dependencies
or endpoints; these workspaces exist only in the separately frozen experiment.

## Retained state and lifecycle

Each canister declares one permanent application allocation, `app.metrics.v1`,
through Memory and opens Storage's public governed upstream map. Installation
chooses fresh backing; upgrades explicitly load retained backing without a
fallback or automatic reset. Governance storage remains separate from that map.

Eight rows across three namespaces cover counter, aggregate, ordered summary and
histogram state, scalar zero, wide totals, exact scalar cap, actual scalar overflow
and empty aggregate state. A missing row is independently checked. The initial
observation sequence is `[0, u64::MAX, u64::MAX]`; boundary seeds are synthetic
numeric states rather than platform measurements. Expected projections are
computed independently in the driver.

Both version pairs pass two same-graph upgrades, continued recording of seven
then zero, query-write discard, trapping-update rollback, identity/kind/bounds/
regression refusals, map lease transfer and an explicit reset to a new epoch.
Scalar overflow quality, all projected values and the allocated memory ID remain
correct. The matched volatile control loses heap metrics on upgrade.

A separate canister installs the baseline, records state, upgrades to the candidate,
records zero through the new implementation, then upgrades back to the baseline.
All expected values, flags and the allocated ID survive those tested transitions;
lease, rollback and reset checks also pass. This bounded reverse transition is
an observation of these exact inputs, not a general downgrade guarantee or
compatibility with allocation formats retired before Memory 0.48.

## Measured tradeoffs

Both variants bootstrap and open the same governed allocation. The volatile
control does not checkpoint metrics but still contains reachable storage paths;
its size is not the dependency-free arithmetic library's size.

| Complete raw Wasm | Before | After | Change |
| --- | ---: | ---: | ---: |
| Durable initial or upgrade | 222,598 | 308,505 | +85,907 |
| Volatile initial or upgrade | 206,222 | 292,163 | +85,941 |

The codec replacement increases these complete artifacts. A consumer that already
reaches serde_cbor may share different code; these figures do not predict its
composed size. No old-versus-new library-only size saving is claimed.

Setup brackets use IC performance counter 0 within one init/post-upgrade
execution. They include declaration/pool setup, runtime creation/bootstrap,
allocation resolution and fresh creation/retained loading of the governed map,
including measurement overhead. Later metric projection/restoration is outside
the setup bracket. Install/upgrade whole-message cycles are not measured.

| Durable setup | Before IC instructions | After IC instructions | Change |
| --- | ---: | ---: | ---: |
| Fresh installation | 663,052 | 658,411 | −4,641 |
| Same-graph retained upgrade | 2,295,351 | 2,275,273 | −20,078 |

Checkpoint workloads use separate fresh canisters for each graph/mode. Each call
adds seven 0/1/16/256 times, with cadences 1/16/256 and a fresh namespaced row;
three repeats give 72 replies per graph and 144 per complete comparison.
Zero iterations write no row; more than 256 iterations and cadence zero receive
typed refusals. Performance counter 0 brackets arithmetic plus checkpoint load,
admission, encoding and map writes, including measurement overhead. Bootstrap,
key/identity construction and Wire framing are outside that bracket.

| 256 additions / cadence | Before IC instructions | After IC instructions | Before whole-update cycles | After whole-update cycles |
| --- | ---: | ---: | ---: | ---: |
| Volatile, every addition or every 16 | 13,058 | 13,058 | 6,999,882 | 6,999,921 |
| Volatile, once after 256 | 13,058 | 13,058 | 7,002,053 | 7,002,092 |
| Durable, every addition | 17,844,237–27,547,811 | 17,851,493–27,566,551 | 24,831,240–34,534,814 | 24,838,535–34,553,593 |
| Durable, every 16 additions | 1,406,108–2,009,053 | 1,406,644–2,010,273 | 8,393,026–8,995,971 | 8,393,601–8,997,230 |
| Durable, once after 256 | 260,346–371,666 | 260,462–371,916 | 7,249,435–7,360,755 | 7,249,590–7,361,044 |

Cycles are actual balance decreases for the whole update, never instruction
conversions. Map growth and fixed row order influence repeat ranges. These are
bounded trajectories, not a universal per-write price, a native timing benchmark
or a chosen application loss window. Async callbacks and unfinished counter spans
remain outside this experiment; hosts own their cadence and lifecycle contracts.

## Distribution and replay

The initial attempt stopped before assertions because sandboxing blocked the
server's loopback bind. Its source/logs remain retained. Before successful runs,
review also standardized both endpoints of instruction brackets on counter 0.
Successful runs use the already admitted server with loopback access.
Runs 2 and 3 each pass the complete lifecycle comparison and 144 cost replies.
Run 3 rebuilds all three workspaces in clean owning target directories first.
All eight Wasms and all ten raw result files agree byte-for-byte between runs.
Strict native driver/protocol and all four Wasm feature selections in both
canister graphs pass Clippy.
Run 4 replays a fresh checksum-verified archive extraction and reproduces all
eight Wasms and ten raw result files byte-for-byte.

The [frozen inputs and raw results](memory-0147.tar.gz) and
[checksum](memory-0147.tar.gz.sha256) explicitly select Metrics-owned fixture
sources, locks, identities, logs and observations. No sibling source, search
output, issue body, tool payload, cache or build directory is exported. Each
payload has a checksum in the archive's roster. Historical archives are unchanged.

```sh
sha256sum -c docs/evidence/memory-0147.tar.gz.sha256
mkdir -p target/evidence/replay-memory-0147
tar -xzf docs/evidence/memory-0147.tar.gz -C target/evidence/replay-memory-0147
cd target/evidence/replay-memory-0147/memory-0147
sha256sum -c SHA256SUMS
bash fixture/replay.sh /absolute/path/to/ic-metrics/target/memory-0147-rebuild \
  /absolute/path/to/ic-metrics/target/evidence/memory-0147-new-run \
  /absolute/path/to/prepared/ic-testkit-server
```

Provision the locked registry sources and exact server separately. Use a new
result directory; compare each graph's four raw files and the two cross-graph
files with the retained successful run. Server logs retain their own process
identities and need not be byte-identical.
