# Consumer issue review and qualification correction

Read-only review on 2026-10-07 uses released Metrics 0.2.9
`ec6c25018d859acfcdf1e400bc7bbb1e19d734f0`, plus the existing compatible 0.2.10
policy/documentation preparation. No arithmetic or consumer contract changes.
The local snapshot selects committed Shared Tooling 0.1.20; issue work follows
its owning-repository feedback and source-bound evidence rules.

## Blob's completed probe qualification

The previous root handoff described Blob's successful workflow as tooling-only.
That description was incorrect. At released Blob 0.17.1
`7c41e3a90996157312aa40985a9861f4c03ca35e`, the
[workflow](https://github.com/dragginzgame/ic-blob-storage/blob/7c41e3a90996157312aa40985a9861f4c03ca35e/.github/workflows/tooling.yml)
explicitly prepares the locked cache and invokes `make test-native-host`. The
[Make target](https://github.com/dragginzgame/ic-blob-storage/blob/7c41e3a90996157312aa40985a9861f4c03ca35e/Makefile)
builds the real storage probe and invokes the nonempty Cargo test runner for
`storage_resources::reads::restoration_reads_are_attributed_only_to_the_operator_reopen_window`.
The committed Metrics registry lock is 0.2.8.

[Run 37640042157](https://github.com/dragginzgame/ic-blob-storage/actions/runs/37640042157)
matches that source, succeeds on Linux/Intel macOS/Apple Silicon macOS, and its
downloaded raw logs show the named actual PocketIC case passes on each host.
The preceding 0.17.0 run and retained host logs independently show the same
case. [Blob #19](https://github.com/dragginzgame/ic-blob-storage/issues/19) is
already closed on completed adoption. This review confirms that disposition;
it does not execute a new test, qualify later dirty graphs, add production
instrumentation or claim instruction/cycle savings.

Retained latest-run inputs under `target/evidence/review-0210-issues/`:

| Input | SHA-256 |
| --- | --- |
| `blob-0171-ci.json` | `77cf5ef00cdf9c959bf2340ed2ed5fb850ce6828b667c0ca5fcd4ff81ade2779` |
| `blob-0171-ci.log` | `eca78a8270da401a045ae796590b910cc8b3d11f58288699a186cf669ffe07ad` |

## Other dispositions

Timers' arithmetic-only adoption at
`0c90c391dff5960a7502fc15a0718b03631f2515`, Metrics 0.2.3, passes
[main native/MSRV](https://github.com/dragginzgame/ic-timers/actions/runs/37584151377)
and [tag truth](https://github.com/dragginzgame/ic-timers/actions/runs/37584150869).
Its later 0.14.12 Intel runner-acquisition failure has no executed steps; it is
not a new passing lane and does not erase that delivered adoption. The completed
summary-only evaluation in [Timers #22](https://github.com/dragginzgame/ic-timers/issues/22)
remains closed without inventing a histogram workload.

Backup's selected prepared-byte/duration integration at released 0.5.2
`e1300abfbaba47d5776a71b5bc1fa005d9079e1c` passes
[main](https://github.com/dragginzgame/ic-backup/actions/runs/37607137734) and
[tag](https://github.com/dragginzgame/ic-backup/actions/runs/37607138196) on
all three native hosts; [Backup #15](https://github.com/dragginzgame/ic-backup/issues/15)
is complete. Later local Backup/Toko/IcyDB preparations have no matching hosted
runs at inspection. Active IcyDB maintainer validation is left undisturbed.

Root [#4](https://github.com/dragginzgame/ic-metrics/issues/4) is consolidated
into [#10](https://github.com/dragginzgame/ic-metrics/issues/10) as a duplicate,
not closed on a false claim of completed consumer qualification. #10 explicitly
retains IcyDB #298/#309 and Canic #447/#99 focused/native/current-graph obligations.
Toko's broader application acceptance remains in its own #6/#8, outside the
original reader-cut gate. Publication, path retirement and already-proven
adoptions do not need repeated implementation; missing obligations stay explicit.

IcyDB/Canic histogram investigations receive the published checked-mean API and
new durable replay inputs in their existing issues. The older missing Canic
replay stays historical; different source/workload identities prohibit treating
the new direct-arithmetic experiment as a performance comparison or application
qualification. Existing issue histories and frozen evidence are preserved.

Local documentation links, snapshot integrity, declaration pins, formatting
and diff checks cover this correction. No Rust edit, consumer build, dependency
update, broad local gate, sibling mutation, workflow dispatch, Git write or
release effect runs. Status-only review does not add another changelog entry.
