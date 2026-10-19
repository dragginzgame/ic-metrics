# Current governed-store IC qualification

This separate receipt refreshes the durability and checkpoint-cost experiment for
Metrics 0.14.5 source `4968c61a0f8e292565874208ecc1b60163230321`, with the pending
histogram oracle test and the incoming Storage 0.5.6 lock selection. Product
arithmetic, stable V1 bytes, public APIs and package versions are unchanged.
The earlier [mixed-kind study](stable-cost-072.md) and
[scalar study](durable-counter-097.md) retain their original sources and graphs;
none is relabelled as qualification of this graph.

## Inputs and ownership

The frozen fixture copies both prepared product Rust trees byte-for-byte. Its
separate lock selects published Memory 0.48.2, Storage 0.5.6, Platform 0.1.18,
Wire 0.4.7 and Testkit 0.55.2, with PocketIC client/server 16.1.0. All 339 lock rows
are retained; only five workspace-owned packages lack registry sources. There
are no sibling path dependencies. Product manifest/lock receipts are separate
from the experiment's manifests and lock.

Memory, Storage and their substrate 0.7.2 match the selected product versions and
checksums. Testkit pins `thiserror` 2.0.18, so the experiment also selects its
matching implementation instead of the product lock's 2.0.21 pair. Every other
product registry row is present with the same version/checksum. This is a
separately locked IC experiment, not exact-full-product-graph qualification.
Four focused native V1/lease/cap/reset tests separately pass against the preserved
product lock, including its `thiserror` 2.0.21 selection.

Platform owns runtime calls and entry macros. Controlled request/reply frames use
Wire with explicit method/field identities and byte/allocation/node/depth limits;
the probe admits the request byte bound before argument copying. Platform's CDK
runtime still uses its own transitive Candid machinery. The fixture authors no
Candid protocol. Testkit owns admitted server assets, bounded startup, instance
and server teardown, and typed Wire calls. It checks an already prepared server;
replay never provisions or downloads one. The server SHA-256 is
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.

The experiment compiler is Rust 1.99.1 on Linux x86_64, recorded with its complete
identity. This does not qualify package floors, native macOS, mainnet or consumer
applications. Neither library acquires Platform, Wire or Testkit dependencies,
production endpoints, a probe package or a server installation workflow.

## Actual IC behavior

One permanent application allocation, `app.metrics.v1`, holds one public governed
Storage map. The host explicitly opens fresh backing at installation and retained
backing on upgrade; there is no fallback, automatic reset or migration engine.
Governance storage remains separate. Eight rows across three namespaces cover
all four metric families, empty aggregate state, scalar zero, a wide total,
an exact scalar cap and actual scalar overflow. The initial observation cohort
is `[0, u64::MAX, u64::MAX]`; boundary seeds are synthetic numeric states, not
measured platform counters. A missing namespaced row is checked separately.

The durable variant retains all projected values, scalar overflow flags and the
same memory ID across two upgrades with a changed build marker. Recording seven,
then zero, continues the same aggregate/summary/histogram cohort. Query mutations
execute but are discarded; an intentionally trapped update rolls back all its
writes. Identity, kind, bounds and regression failures are typed and preserve
state. Moving the map out retains its allocation lease; only dropping it permits
reopening. Explicit removal/reset advances the host epoch and refuses the old
identity. The matched volatile variant loses its heap metrics on upgrade.

Both variants bootstrap and open the same governed allocation, including the
volatile control. Initialization is outside cost brackets. This keeps allocation
setup comparable; the volatile fixture is not the arithmetic-only library.
Hosts still own attribution, synchronization, lifecycle, resets and write cadence.
No asynchronous callback or cross-call counter continuity is established.

## Matched checkpoint costs

Separate fresh canisters add seven 0/1/16/256 times with checkpoint cadences
1/16/256, three repeats and a fresh namespaced counter row per reply. There are
72 cost replies per complete run. Zero iterations write no row; more than 256
iterations and cadence zero receive typed input refusals.

Instructions bracket arithmetic plus checkpoint admission, load, encoding and
map writes, including measurement overhead. Bootstrap, key/identity creation and
Wire framing are outside that bracket. Whole-update cycles are actual balance
decreases, including request/execution/reply costs; no instruction conversion is
used. Map growth and fixed row order influence repeat ranges.

| 256 additions / cadence | Bracketed IC instructions | Whole-update cycles |
| --- | ---: | ---: |
| Volatile, every addition or every 16 | 13,058 | 6,999,874 |
| Volatile, once after 256 | 13,058 | 7,002,045 |
| Durable, every addition | 17,844,237–27,547,811 | 24,831,232–34,534,806 |
| Durable, every 16 additions | 1,406,108–2,009,053 | 8,393,018–8,995,963 |
| Durable, once after 256 | 260,346–371,666 | 7,249,427–7,360,747 |

Complete initial/upgrade Wasms are each 222,491 raw bytes for durable and 206,115
for volatile, with opt-level=z, LTO, one codegen unit, stripping and panic abort.
There is no postprocessing. The 16,376-byte difference belongs to these complete
fixtures, which both include governed storage paths, not an isolated library cost.
There is no matched comparison to an older experiment or universal write price.
Batching reduces checkpoint work here; hosts must choose the acceptable loss
window rather than infer it from this fixture.

## Retention and replay

The initial run failed before any IC assertion because sandboxing refused the
server's loopback bind. Its startup logs remain retained. Runs 2 and 3 each pass
all lifecycle checks and 72 cost replies on fresh servers. Run 3 first rebuilds
in a clean owning target directory; all four Wasms match the earlier build
byte-for-byte. Both runs' costs, sizes, qualification and state files also match
byte-for-byte. Strict driver/protocol and all four Wasm feature selections pass
Clippy. A fresh checksum-verified archive extraction also rebuilds and replays
successfully as run 4, reproducing all four Wasms and raw result files byte-for-byte.
These results do not substitute for full release CI or Rust-floor gates.

The [frozen archive](stable-current-0146.tar.gz) and
[checksum](stable-current-0146.tar.gz.sha256) explicitly select fixture-owned
sources, manifests/locks, tool identities, logs and raw observations. They exclude
sibling source, issue bodies, search output, tool payloads, caches and build trees.
Every archived payload has an independent checksum roster.

```sh
sha256sum -c docs/evidence/stable-current-0146.tar.gz.sha256
mkdir -p target/evidence/replay-stable-current-0146
tar -xzf docs/evidence/stable-current-0146.tar.gz -C target/evidence/replay-stable-current-0146
cd target/evidence/replay-stable-current-0146/stable-current-0146
sha256sum -c SHA256SUMS
bash fixture/replay.sh /absolute/path/to/ic-metrics/target/stable-current-rebuild \
  /absolute/path/to/ic-metrics/target/evidence/stable-current-new-run \
  /absolute/path/to/prepared/ic-testkit-server
```

Prepare locked registry sources and the exact server separately. Select a new
result directory and compare its four raw result files with retained run 3.
The experiment's new locked graph remains separate from the product lock.
