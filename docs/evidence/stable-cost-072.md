# One-map IC upgrade and storage-cost qualification

The compatible pending 0.7.2 batch addresses
[#64](https://github.com/dragginzgame/ic-metrics/issues/64) without changing the
arithmetic API or the V1 stored format. A private frozen fixture copies all 16
product Rust files from published 0.7.1
`569a388bb0066bb51ede6095d88b40a65f36e82a` exactly. It adds no maintained product
endpoint, server caller, CI gate or Testkit dependency. Package metadata stays
0.7.1; no sibling is edited or built.

## Actual IC behavior

The host uses IC Memory's `MemoryRuntime` bootstrap with one permanent
`app.metrics.v1` application binding and one B-tree map. Governance memory remains
separate. Eight rows in three namespaces contain mixed aggregates, summaries and
histograms, wide totals, actual-overflow flags, bucket/overflow flags, measured
zero and empty state. A missing namespace is checked separately. Wide/capped
restoration seeds are synthetic arithmetic states, not measured platform counters.

Two upgrades of the same canister preserve every field/flag and the application
memory ID. The first upgrade changes a build marker; recording then continues,
and the second upgrade retains that continuation. Identical checkpoints remain
idempotent. Incompatible epochs/bounds and regressing snapshots return typed
refusals without changing any row. A query successfully executes writes but its
changes are discarded; an explicit trapping update rolls back its writes.
An explicit reset advances the host-selected epoch in one message, retaining the
same memory ID and refusing the old identity. The matched volatile control loses
its heap state on upgrade.

Testkit 0.34.2 owns fallible server startup/admission. The locked experiment uses
PocketIC client/server 16.1.0, IC Memory 0.35.14, Host 0.14.4, CDK 0.20.3 and
Candid 0.10.38. All 309 lock rows are retained; only the five fixture-owned
workspace packages lack registry sources. No external path dependency exists.
The explicitly prepared Linux server has SHA-256
`b44e1eccd66e02328146b3e209e3403e3a3428a25d25555aca2f67500e5ae9db`.
The fixture never installs or downloads a server. Rust 1.99 is the experiment
compiler, separate from the arithmetic 1.85 and adapter/inspector 1.88 floors.

## Matched costs

Separate fresh canisters execute the same arithmetic/reply path with volatile
recording or durable checkpoints. Each call records zero, one, 16 or 256 values
of seven, with a fresh namespaced row and a checkpoint cadence of one, 16 or 256
observations. Each cohort repeats three times in a fixed order. The zero-loop
control writes no row. Work above 1,024 observations receives a typed refusal.

Instruction brackets include recording and the store's load, validation,
encoding and write path. Lifecycle/bootstrap, key construction, projection and
Candid encoding are outside the bracket. Whole-update cycles are actual balance
decreases including ingress/execution/reply costs, not instruction conversions.
Install/upgrade/bootstrap costs are excluded. Growing B-tree state and row order
affect repeat costs; these ranges are one complete trajectory, not a universal
price per write.

| 256 observations / checkpoint cadence | Bracketed instructions, three repeats | Whole-update cycles, three repeats |
| --- | ---: | ---: |
| Volatile, each cadence | 20,206 | 7,132,473 |
| Durable, every observation | 23,781,928–27,993,348 | 30,974,236–35,185,656 |
| Durable, every 16 observations | 1,757,957–2,162,523 | 8,950,323–9,354,831 |
| Durable, once after 256 observations | 275,042–290,842 | 7,467,408–7,483,208 |

The complete volatile Wasm is 314,131 bytes; the matched durable Wasm is 517,883
bytes, a 203,752-byte difference for this whole fixture. Both upgrade variants
have the same respective size. Compilation uses opt-level=z, LTO, one codegen
unit, symbol stripping and panic abort, with no postprocessing. These are raw
Wasm bytes, not an isolated library contribution or an optimized deployment.

The result supports batching observations before checkpointing at an owning
update-message boundary. It does not choose a consumer's permitted loss window,
attribution, labels, synchronization or authorization. Less frequent durable
checkpoints explicitly allow loss since the preceding checkpoint. Async callbacks
are separate message boundaries; no callback or counter-span continuity is proved
by this fixture. Native macOS, mainnet and real consumer workloads remain outside
the experiment's measured domain.

## Frozen inputs and replay

Two independent server runs each pass all lifecycle assertions and 72 measured
cost replies. Their raw costs, size rows, qualification outcomes and state
observations agree byte-for-byte. A fresh extraction verifies every payload,
passes all four Wasm and host-driver Clippy gates, rebuilds all four Wasms
byte-for-byte, and reproduces all four raw result files on a fresh server.

The first IC run expected implicit trap code 502 instead of the actual explicit
`CanisterCalledTrap` code 503. Its partial results and original driver remain
retained, without a full-pass claim. Initial probe/driver lint failures and their
source are also preserved; warnings are fixed before completed execution.

The [frozen experiment](stable-store-cost-072.tar.gz) and
[checksum](stable-store-cost-072.tar.gz.sha256) contain complete source, lock,
driver, replay script, four Wasms, successful/failed runs and raw results. Its
SHA-256 is `451b3f0acb5e1e457b11d609a1fe6dfdabdb3006a19111fb63e94c70dcb87de6`.
The separate [fresh-extraction receipt](stable-store-delivery-072.tar.gz) and
[checksum](stable-store-delivery-072.tar.gz.sha256) bind that exact archive to
the successful replay log, checked identities and independently reproduced
outputs. It also retains the separately approved product CI (313 seconds), all
three package-floor gates, preserved incoming graph and unchanged canonical
manifest/lock/snapshot/tool-pin checkpoints. Its original runtime-only receipt
is retained inside the final receipt at its original identity. The original
native-only and arithmetic cost archives retain their
original scope and are not relabelled as durable IC measurements.

```sh
sha256sum -c docs/evidence/stable-store-cost-072.tar.gz.sha256
mkdir -p target/evidence/replay-stable-072
tar -xzf docs/evidence/stable-store-cost-072.tar.gz -C target/evidence/replay-stable-072
export POCKET_IC_BIN=/absolute/path/to/the/exact/admitted/pocket-ic
unset IC_TESTKIT_POCKET_IC_URL
bash target/evidence/replay-stable-072/stable-store-cost-072/replay.sh \
  /absolute/metrics/target/stable-store-rebuild-072 \
  /absolute/metrics/target/evidence/stable-store-replay-072
```

The locked caches and exact server require explicit preparation outside replay.
Root product/native delivery qualification and consumer adoption remain separate
from this frozen runtime evidence; [the handoff](../status/current.md) records
the current batch's graph and delivered-source acceptance.
