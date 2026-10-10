# Published 0.3.5 verification

Released source `6c09738c8183bd539e74859fe5433709a928c655` matches public main,
annotated tag `v0.3.5` (object `af6ddf2e9d089c364fd0ac5060855f394a3b75c2`)
and package/workspace versions. The official registry reports a non-yanked,
dependency-free package without features, declaring Rust 1.85.0. Its archive
verifies SHA-256
`cdab4d805341b0c566f6bf6dea70d35a9b05ccb14319224f8acc5f992905e586`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match the release. Its packaged lock contains only
Metrics 0.3.5. Arithmetic source is unchanged from 0.3.4. The private graph
selects [separately qualified Host 0.10.0](host-dependencies-0100.md).

[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37963502940)
passes Linux native and both package floors; both macOS jobs remain queued at
observation. Downloaded Linux artifact `11632473097` verifies API ZIP digest
`7e0e8af21428c7f4b855d9d0536d925f82fe3e9fba117dbb296210b36bf7b577`
and inner archive digest
`b0a40ce170a2a9ce7e89b442eb88c5f142114830f3bd5c17f89d291c25333641`.
All 14 payload hashes, 69 released-source hashes and nine successful outcomes
verify, with exact run/attempt 1/push/Linux/x86_64 identity and released IC pins.
The source-bound log confirms the expanded actual CLI test executes and passes;
the Make execution include and probe are covered by source hashes.

Inputs and verified receipts are under `target/evidence/release-035/`.
The known command-line-hidden Make-mode gap remains documented in
[the adoption record](adoption-035.md#subsequent-qualification-limit) and
[Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30).
Publication and Linux CI do not resolve it or supply complete native macOS
acceptance. No release rerun or publication occurs during this verification.

## Complete native acceptance

The subsequent 2026-10-10 review finds the same exact-source run completed
successfully on attempt 1: Linux, Intel macOS, Apple Silicon macOS and both
package-floor checks pass. Both newly downloaded macOS artifacts verify against
GitHub's ZIP digests, their inner archive checksums, all 14 payload hashes and
all 69 files from released source `6c09738c8183bd539e74859fe5433709a928c655`.
Each receipt identifies the exact run, push event, architecture and released IC
pin catalog, with nine successful setup/native outcomes and successful job steps.

| Host | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Intel macOS | `11638479760` | `184c029d0f95843a7528f60ed06517594ef252fa2ce623702d192d1e50010eb8` | `41f22d6fe214f4d0233588979c771ea363ec8f8c1ced737b749a83d43f226496` |
| Apple Silicon macOS | `11641555958` | `448d3a984ddf33cf36407cdbebdf0386169a48c78286ee675d84e03a71b348d5` | `249505f918ec3e7d2eb8cd123247d2889a8a2b386c7c951c7ccf0d844ec56404` |

Both source-bound native logs confirm the expanded actual inspector CLI case,
real formatting/hook checks and release/publication/admission fixtures pass.
Their substitutions remain explicit; no live release or registry effect is
inferred from adapter fixtures. This completes 0.3.5's native acceptance,
including its Make execution companion and Host 0.10.0 graph. It does not qualify
pending 0.3.6's Shared 0.2.9/Host 0.10.1 selection or repair the separately
reproduced command-line-hidden mode gap. Metrics #44 remains open for that gap.
Original queued observations above remain historical. Downloaded ZIPs, API
inputs, verified native logs and verification JSON are retained under
`target/evidence/continuation-036-recheck/`. No workflow rerun occurs.
