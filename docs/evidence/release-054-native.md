# Released 0.5.4 native acceptance progress

Released source `1622e98a73f7bf7a42bae48a4266840e0f6726e0` matches tag `v0.5.4`
and [exact-source run 38060740790](https://github.com/dragginzgame/ic-metrics/actions/runs/38060740790).
Linux, Apple Silicon and both package-floor checks pass. Intel is still running
at this inspection. The 60-minute job budget and isolated parent-evidence fixtures
belong to this source; pending 0.5.6 is qualified separately.

Both available downloaded artifacts independently verify GitHub ZIP digests,
inner archive receipts, the exact released workflow catalog, all 70 released-source
and 14 payload hashes, run/attempt/host/pins and seven successful outcomes.

| Host | Artifact | ZIP SHA-256 |
| --- | --- | --- |
| Linux | `11673361422` | `4af31b7c451afed77ceb7be70585654c164ba204d0a3c06ef85a30f6327ab8af` |
| Apple Silicon | `11675917851` | `2d823dcdc1f98fecd11be2105b72f047139d6a428d760d893143658fb67cfe15` |

Actual aggregate/collector, release/admission, formatting and inspector CLI checks
run on each host, with two nonempty formatting diagnostics per artifact and no
jobserver descriptor warnings. Release/Make fixture effects remain substitutes;
no IC runtime measurement or live release execution is claimed.
[#52](https://github.com/dragginzgame/ic-metrics/issues/52) and
[#53](https://github.com/dragginzgame/ic-metrics/issues/53) remain open for complete
native acceptance. Downloads, extracted receipts and verification results remain
under `target/evidence/review-055/`, with separately named 0.5.4 observation files.

## Complete native acceptance

The same exact-source run is now complete: Linux, Intel macOS, Apple Silicon and
both package-floor checks pass. All three receipts are independently reverified
against the released workflow catalog, source and graph. The new Intel artifact
is `11675709192`, with ZIP SHA-256
`5ff2ad776e70041fe800f4ed10db9d5fc95b4f180a4bc5bc4157bbcf96667347`
and inner archive SHA-256
`7684f00699446457a6acfa014dd660d4271598e163c8124f437a550f602b2d92`.
It verifies all 70 source and 14 payload hashes, source/run/attempt/host/pins and
seven successful outcomes, with actual aggregate/collector, release/admission,
formatting and inspector CLI execution and two nonempty formatting diagnostics.

This completes [#52](https://github.com/dragginzgame/ic-metrics/issues/52) and
[#53](https://github.com/dragginzgame/ic-metrics/issues/53) at released 0.5.4.
The earlier 0.5.0 Intel timeout remains failed; later pending source and earlier
cancelled releases are not relabelled as qualified. New downloads, observations,
extracted receipts and independent verification results are retained under
`target/evidence/review-056/`.
