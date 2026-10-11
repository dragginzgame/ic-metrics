# Published 0.6.3 verification

Local HEAD, public main, the peeled annotated tag `v0.6.3`, workspace/package
versions and the official archive's embedded Git identity agree on
`b51e30743ad23a74ef02fef0edcf2b3acca6d4e3`. The non-yanked registry row declares
Rust 1.85.0, no dependencies and no features. Downloaded archive SHA-256 verifies
as `d0319a977ffa783597a869da473d9766fe37ca1d90b614edbf9f81d2e8dde42a`.
The complete arithmetic source tree, original manifest, root README and license
match released source. Arithmetic is byte-identical to released 0.6.2.

The release delivers [Shared Tooling 0.5.0 adoption](adoption-063-store.md), with
the verified 96-file snapshot and shared-reference failure collection. The
released private lock selects Host 0.13.1. The separate uncommitted Host 0.13.2
lock selection is preserved and is not covered by these released-source checks.
Host 0.13.2's committed source changes contributor tooling; source review finds
no change in the consumed `ic-host-artifacts` or `ic-host-fs` package trees.
That review does not qualify the uncommitted dependency selection.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38134831567)
passes Linux and the job checking both Rust floors. Downloaded Linux artifact
`11700467879` verifies its API-declared ZIP SHA-256
`626659e5f27c96b76038af3422cb061e103fd90de969986a4fe4b730f3ee21c0`
and inner archive SHA-256
`367b20f07fe521d1695725e8008c3f3b456331ff2ae0c9f88a13afaefbe12eb0`.
All 74 source hashes, the exact released workflow catalog, all 14 payload hashes,
source/run/attempt/host/IC pins and seven successful outcomes verify. Actual
host/IC shared-store and consumer failure-collector fixtures, release
metadata/admission/retention, formatting-hook and inspector CLI checks execute.
Their substituted effects do not establish IC runtime measurements.

Both Metrics macOS jobs are queued at inspection.
[#60](https://github.com/dragginzgame/ic-metrics/issues/60) retains full native
acceptance for this delivered batch. The exact-source
[Shared Tooling run](https://github.com/dragginzgame/shared-tooling/actions/runs/38132790945)
reports Linux and Apple Silicon regression success, with Intel queued. This is
observed upstream CI status, not downloaded upstream receipt acceptance or
qualification of Metrics on macOS. No newer committed Shared revision is
available; ongoing dirty upstream work is not an adopted input.

Registry inputs, raw artifacts, recovered receipts and independent results remain
under `target/evidence/review-063/`. Previous ignored preparation evidence was
absent when this verification started; fresh hosted downloads do not restore
deleted local evidence or change historical source identities. This verification
performs no build, dependency resolution, installation, workflow dispatch,
release, staging or sibling mutation. No behavior change requires a pending
changelog entry.

## Supplemental Apple Silicon acceptance

A subsequent exact-source observation reports Linux, Apple Silicon and both Rust
floors passing; Intel remains queued. Independently downloaded Apple Silicon
artifact `11702141046` verifies its API-declared ZIP SHA-256
`a4ca50f768ec00d55b7fc08a53807e31aa7317de324bd41998433a9401a0162a`
and inner archive SHA-256
`c69d2477e253e751c183add7d6494a3d013c05a13079557627d7566b1aaa9195`.
All 74 released-source hashes, the exact workflow catalog, all 14 payload hashes,
source/run/attempt/native host/IC pins and seven successful outcomes verify.
The actual aggregate/collector, release metadata/admission/retention,
formatting-hook and inspector checks execute on Apple Silicon. Fixture effects
remain substitutes and establish no IC runtime costs.

The API metadata, original ZIP/archive, recovered receipt and independent checks
are retained under `target/evidence/release-064/prior-apple-*`. This evidence
qualifies released 0.6.3, not the separately prepared 0.6.4 metadata or its
Shared 0.6.0 contract. [#60](https://github.com/dragginzgame/ic-metrics/issues/60)
remains open for Intel acceptance; the initial queued observation above is
retained as history.

## Supplemental Intel acceptance and closeout

The same exact-source CI run now passes Intel alongside Linux, Apple Silicon
and both Rust floors. Independently downloaded Intel artifact `11703016246`
verifies its API-declared ZIP SHA-256
`a96abf39b300caa738983948aa2006ca0db0189c763e98442b3d5d4b703c3c78`
and inner archive SHA-256
`4f31639b0b3439b7ed55e6d6b792fc1d6d519516d11423424f1dc83c0e1b275b`.
All 74 released-source hashes, the exact workflow catalog, all 14 payload hashes,
source/run/attempt/native host/IC pins and seven successful outcomes verify.
The actual common Cargo, native collector, release-admission/retention,
formatting-hook and inspector CLI checks execute. Their substituted effects
remain distinct from IC runtime measurements.

This completes the three-host acceptance for released 0.6.3 and
[#60](https://github.com/dragginzgame/ic-metrics/issues/60). API metadata, raw
ZIP/archive, recovered receipt and independent checks remain under
`target/evidence/adoption-065/prior-intel-*`. This does not qualify the later
Shared 0.6 batch, Host 0.13.3 graph or older cancelled sources. Earlier queued
observations retain their historical identities.

## Superseding older cancelled-run acceptance

The maintainer accepts later recorded native coverage for fixes carried forward
into the maintained source. Under that policy, the complete 0.6.3 matrix in
[run 38134831567](https://github.com/dragginzgame/ic-metrics/actions/runs/38134831567)
closes [#49](https://github.com/dragginzgame/ic-metrics/issues/49),
[#50](https://github.com/dragginzgame/ic-metrics/issues/50) and
[#51](https://github.com/dragginzgame/ic-metrics/issues/51). Both original release
commits are ancestors of the qualified 0.6.3 source. All three retained receipts'
74 source hashes and 14 payload hashes are reverified during this closeout.

The recorded native gates execute the carried-forward setup preflight, Cargo
jobserver and unsafe-Make admission fixtures for #49; actual cleanup-body
nounset/early-zero/success retention checks for #50; and rejected/admitted
validation-depth and completed-dispatch fixtures for #51. Current code coverage
and owning native results supersede those older acceptance obligations.
The original 0.5.2 Intel cancellation and 0.5.3 macOS cancellations remain
historical observations; this closeout does not claim those runs passed.

Independent rechecks are retained under `target/evidence/issue-supersession-063/`.
The newer Shared 0.6 setup/collector batch in
[#61](https://github.com/dragginzgame/ic-metrics/issues/61) still requires its
own delivered-source coverage because its changes follow this qualified release.
