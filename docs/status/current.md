# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and endpoints.
See [the extraction contract](../extraction.md).

## Released source

Verified published 0.2.8 source is `0eac2b0baa9d03b8f2430a24dfe596d93f5bfc16`.
Its non-yanked registry archive has SHA-256
`2ff922721253a9e6d921203809d99e871128edfc5b0613661c64d094d58343d6`,
with no dependencies or features. The checksum, embedded Git identity, maintained
Rust source, packaged guide, original manifest, README, license and lock verify.
The [release record](../evidence/release-028.md) binds the complete passing Linux,
macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV matrix. Cargo workspace,
package and lock versions remain 0.2.8.

Histograms are available from 0.2.4; checked means are available from 0.2.6.
`checked_mean(samples, total)` and `MeasurementSummary::mean()` return `None`
for empty `(0, 0)`, `Some(0)` for measured zero and floor division for valid
nonempty aggregates. Inconsistent empty pairs and either counter at `u64::MAX`
return typed errors, including an exactly reached cap. Recording, storage and
ownership contracts are unchanged. The
[application guide](../../crates/ic-metrics/src/application.md) is packaged and
compiled; [arithmetic evidence](../evidence/arithmetic-026.md) retains its original
source, host/Wasm, MSRV and documentation scope.

The [histogram experiment](../evidence/histogram-cost-026.md) measures an isolated
Canic recording source-copy on Linux PocketIC 16.0.0, with 138 validated calls.
At 1,000 repeated-key records, two histogram bounds add 42,000–75,000
instructions, 42,035–75,035 observed whole-update cycles and 208 raw Wasm bytes
over count/total; slots use 72 versus 16 bytes. This does not qualify a full
consumer, other bound counts/cardinalities, timer admission, mainnet or macOS.
The original ignored replay inputs are unavailable and the maintainer has no
backup. The historical report and identities remain unchanged. A separate
[durable arithmetic replay](../evidence/histogram-replay-029.md) supplies new,
checksum-bound source/lock/result/Wasm inputs; it does not reproduce the old
Canic experiment or extend its qualification.

## Pending 0.2.9

This compatible repair batch adopts committed Shared Tooling 0.1.19 at
`a06e4719e3839b8eefcfb88ec8923aa88eb63ccc` through the canonical distribution
helper from a clean detached checkout. The snapshot records all 68 files,
including the new IC pin parser required by the updated installer. Pins, Cargo
versions, lockfiles and arithmetic source stay unchanged. The
[adoption record](../evidence/adoption-029.md) binds the scope and focused checks.

The Rust installer rejects redirected routes, executables and receipts before
probing or installation; the tooling fixture normalizes temporary-directory
aliases; the changelog finalizer preserves historical EOF bytes and rejects
already-dated targets with varied whitespace. The shared logger also retains a
combined failed-target view without changing its last-target log. No private
consumer engine or arithmetic API is added. Ordinary checks never install tools.

This implements the source repair in
[#23](https://github.com/dragginzgame/ic-metrics/issues/23). New committed consumer
native CI remains separate from focused Linux/Bash 3.2 qualification and the
released 0.2.8 matrix. The earlier source adoption/native obligation in
[#22](https://github.com/dragginzgame/ic-metrics/issues/22) is complete; its green
matrix does not prove the subsequently added path/date-boundary cases.

The consumer-owned workflow now records source/run/host identity before fallible
setup, retains raw Rust/host/prerequisite setup logs, and records every setup
outcome. Final collection is tied to successful checkout rather than successful
setup. Failed tool candidates use an inner tarball in the one native evidence
archive, preserving valid filenames that direct uploads reject. The separate
candidate uploader is replaced by that archive owner. `make ci-evidence-check`
executes the actual workflow source/setup/archive bodies with substitute Make
effects and verifies success, install/check/admission failures, raw bytes, exit
status, outcomes and extracted checksums. Linux Bash 5.2/3.2 pass; new committed
native workflow qualification remains in
[#25](https://github.com/dragginzgame/ic-metrics/issues/25).

The new frozen histogram bundle addresses
[#26](https://github.com/dragginzgame/ic-metrics/issues/26) independently of the
missing old inputs: 138 actual measured replies and six refusal/state checks
pass in Linux PocketIC 16.0.0. All 276 external package identities match the
captured seed, with locked offline preparation/builds and no dependency upgrade.
Fresh extraction verifies every payload hash; all three source-built Wasms and
a second actual IC replay's CSV/sizes match the reference bytes. Sources, locks,
raw results and measured Wasms are supplied under `docs/evidence/`, with commands
in the extracted README. This is direct two-bound arithmetic, without Canic
lookup, application attribution, generic-N or native macOS qualification.
The original historical report remains intact; bundle public delivery requires
the maintainer's commit/push.

## Downstream boundaries

The 2026-10-07 read-only inspection binds these local sources and selected locks.
Newer dirty work and remote publication require independent inspection; all
selected Metrics locks below refer to the registry package.

| Caller | Inspected local HEAD | Committed Metrics lock and inspected working-tree selection |
| --- | --- | --- |
| IcyDB | `b72e0b3226671f32b471e0755be0deff1c998543` | 0.2.8 in both; other lock edits remain dirty. Inclusive spans and CLI checked means. |
| Canic | `b420704efd60835583871e1b98d072c5f5e45c92` | 0.2.8 in both. Exclusive endpoint accounting and invocation-owned async checkpoints. |
| IC Timers | `479c4b8c8b6412babf7c98ea17c948eacdaeadc3` | Committed 0.2.7; dirty selection 0.2.8. Scheduler/work summaries and local sample admission. |
| IC Backup | `7660b56c196d2af3d084524bc74bb9dd4982d1ad` | Committed 0.2.7; dirty selection 0.2.8. Nanosecond summaries and four-bound prepared-byte histogram. |
| IC Blob Storage | `790649b36ce1da95cb2d41f99facb3afe8280b4d` | 0.2.8 in both; other graph edits remain dirty. Restoration test probe, not production library instrumentation. |
| Toko Miner | `9071b4cc9c1cf0d6d905f73592154b5108ab2147` | Committed 0.2.2; dirty selection 0.2.7. Production action-count cohorts use `record_sample`. |

At inspection, IcyDB's latest owning source CI is queued. Canic's newer local
source has no matching hosted run in the inspected inventory; remote CI remains
bound to older source. IC Timers and IC Backup have successful source-matching
runs; their actual native versus tag-check lanes retain their own scope. Blob's
successful workflow qualifies release/formatting tooling, not restoration probe
execution. Toko's old hosted graph failure is not repaired by its dirty lock
selection. Queued, absent, tooling-only or older-source results do not establish
complete consumer runtime qualification.

IcyDB's CLI output compatibility belongs to
[IcyDB #313](https://github.com/dragginzgame/icydb/issues/313); Canic's async
attribution remains in [Canic #99](https://github.com/dragginzgame/canic/issues/99).
Histogram workload, bounds and storage decisions belong to
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) records the
summary-only decision without a demonstrated distribution workload. Toko's
cohorts count actions, not instruction-value ranges; Blob probe and Toko
application qualification belong to
[Blob #19](https://github.com/dragginzgame/ic-blob-storage/issues/19) and
[Toko #6](https://github.com/dragginzgame/toko-miner/issues/6).

Consumer integration and complete owning runtime/native qualification remain
separate from root publication and lock updates, tracked in
[#4](https://github.com/dragginzgame/ic-metrics/issues/4) and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).
No sibling files were edited. Historical evidence stays under `docs/evidence/`;
[the host record](../hosts.md) separates focused Linux checks from native CI.
No full local CI/product-test gate, dependency upgrade, package version change,
commit, push, tag or release command ran.
