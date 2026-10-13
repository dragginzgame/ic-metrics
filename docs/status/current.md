# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own sampling, attribution, units, identities, registries, lifecycle and endpoints.
[The extraction contract](../extraction.md) owns the integration boundaries;
[host qualification](../hosts.md) owns setup, focused checks and delivery gates.

## Pending 0.8.2

Package metadata remains 0.8.1. The compatible pending batch adds
`MeasurementCounter` for scalar `u128` totals with sticky actual-overflow quality,
validated restoration, batch merging, exact totals and identity-qualified deltas.
It retains no observation statistics; the compiled application guide uses it for
diagnostic event counts. Existing observation APIs and the optional stable
adapter's three-kind V1 encoding/map/key/epoch contract stay unchanged. Scalar
persistence needs its own stored contract; no kind is repurposed or data reset.
[The counter receipt](../evidence/counter-082.md) retains the original caller and
implementation qualification, including its earlier seven-test scope.

The incoming lock at cleanup start selects Host 0.15.2, Memory 0.35.19 and Syn
3.0.9. The
arithmetic floor stays Rust 1.85; stable and private inspector stay 1.88.
[Shared Tooling 0.9.10 adoption](../evidence/adoption-082-shared-0910.md) selects
`7e55adecf6f0b196c050f104b37f8c69b6bf434e`: all 104 payloads and 91 roots verify.
Explicit Cargo-tool setup and offline checks pass; older generations remain
retained. Its source-bound full CI passed in 264 seconds and all package-floor
gates passed against 140 inputs. That receipt precedes the cleanup below.
Metrics keeps its complete native workflow and direct-only release delivery.

[The cleanup](../evidence/cleanup-082.md) consolidates current integration/host
instructions, preserves earlier guide text and evidence, removes duplicate test
obligations and uses admitted public state in boundary fixtures. Quantile reporting
no longer rescans overflow flags already carried by its admitted aggregate.
Public APIs, ranges, V1 bytes, dependency selections and compiler floors remain unchanged.
Final cleanup CI passes in 261 seconds, including 50 arithmetic tests and eight
doctests. All package-floor gates pass; eight checkpoints match the 140 frozen
inputs. The four-bound raw Wasm comparison reproduces: recording is unchanged,
and the standalone query module is 57 bytes smaller, without an IC cost claim.
The source-bound archive retains both the initial slice and final qualification.
Public error-surface follow-up stays in [#69](https://github.com/dragginzgame/ic-metrics/issues/69);
it requires a separately selected API cut.

## Released source and consumer acceptance

Released/public 0.8.1 is `368f2dca9a46faa639c3074ee45fc76d89b443e7`.
[Publication verification](../evidence/consumer-review-082.md#publication-and-qualification-identities)
checks both non-yanked archives and every packaged Rust file.
[Complete native acceptance](../evidence/release-081.md) verifies Linux, Intel
macOS, Apple Silicon and Rust-floor CI on that released source. The older 0.8.0
Apple Silicon cancellation retains its status; the complete 0.8.1 run supplies
replacement acceptance. These receipts do not qualify pending 0.8.2 on macOS.

The original [tracked cut and IC comparison](../evidence/tracked-080.md),
[summary restoration fix](../evidence/summary-restoration-081.md),
[Shared 0.9.6 adoption](../evidence/adoption-081-shared-096.md) and all earlier
records retain their original sources, graphs and scope. No cleanup rewrites
performance readings or turns native substitutes into IC evidence.

The [six-consumer review](../evidence/consumer-review-082.md) binds the last
read-only caller observations. Current adoption/reporting work stays in the
[owning issues](../extraction.md#downstream-contract-checks), including Toko's
[database quality bridge](https://github.com/dragginzgame/toko-miner/issues/49).
[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) retains the
original consumer-qualification obligation. Canic's last scoped attempt is
recorded in [#491](https://github.com/dragginzgame/canic/issues/491#issuecomment-6126296804)
and [#450](https://github.com/dragginzgame/canic/issues/450#issuecomment-6126296388);
its complete logs remain in Canic's `.tmp/metrics-qualification-20261012/`.
Consumer publication, source updates and complete owning runtime/native acceptance
remain separate. This batch edits Metrics only and performs no release effects.
