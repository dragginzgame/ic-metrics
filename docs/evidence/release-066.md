# Published 0.6.6 verification

Local HEAD, public main and peeled annotated tag `v0.6.6` agree on
`c651c095d5554e929a9cb96f5089226eda66ee90`. Workspace/package versions and the
official archive's embedded Git identity agree. The non-yanked registry row
declares Rust 1.85.0, no dependencies and no features. Downloaded archive SHA-256
verifies as `65fdc32ce3d16e57750b9b8324a203ec3d7ead289b6ebbdf18cfd955d602229e`.
All 13 packaged arithmetic source/manifest/README/license files match released
source. Arithmetic is byte-identical to released 0.6.2.

The release delivers [#62](https://github.com/dragginzgame/ic-metrics/issues/62)'s
README repair: retained product examples and independent compiler floors, one
complete setup/check/PATH recipe, current registry adoption example and links to
the canonical setup/hook/release owners. Documentation links, referenced Make
commands and compiler identities remain consistent. This completes that
documentation-only issue; it does not supply unrelated native acceptance.

The snapshot remains Shared Tooling 0.6.3 with 97 verified selections. The
committed private lock now selects [Host 0.14.1](host-dependencies-0141.md),
separately from 0.6.5's Host 0.14.0 graph. The unchanged consumed source review
does not relabel earlier gates; current native evidence qualifies this new graph.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38152311356)
passes Linux and both Rust floors. Downloaded Linux artifact `11707092953`
verifies its API-declared ZIP SHA-256
`d9cd1249206e33549641d90a821ed0f03cdf9531b559c101f384093825ac492c`
and inner archive SHA-256
`a15bd6c672d23939462aaf976644a3ead12c117d1a494f64eac88e9a21eccb33`.
All 75 source hashes, the exact released workflow catalog, all 14 payload hashes,
source/run/attempt/host/IC pins and seven successful outcomes verify. Logs confirm
the committed-preparation restart cases, native collector and actual inspector
CLI case execute. Their fixture effects remain distinct from IC measurements.

At this observation Intel is running and Apple Silicon queued.
[#61](https://github.com/dragginzgame/ic-metrics/issues/61) retains macOS acceptance
for the delivered Shared 0.6 batch. The preceding 0.6.5 run is now cancelled;
its initial observations remain historical. Later complete relevant coverage may
supersede the cancelled attempt under the maintainer's accepted policy, without
claiming that earlier run passed. Canic's unchecked actual runtime/native
obligation remains in [#10](https://github.com/dragginzgame/ic-metrics/issues/10).

Upstream [Host 0.14.1 CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/38149531883)
now passes Linux, Intel, Apple Silicon and MSRV. This is observed upstream status,
not independent download of Host receipts or Metrics' remaining macOS proof.
Shared Tooling remains committed/public 0.6.3; its dirty snapshot-consumption
guidance is excluded from adoption.

Official registry inputs, raw Linux ZIP/archive, recovered receipt files and
independent verification remain under `target/evidence/review-066/`. Previously
ignored local evidence is absent following maintainer cleanup; these fresh
downloads do not reconstruct it. This verification performs no build, dependency
resolution, installation, workflow dispatch, release, staging or sibling mutation.
No behavior change requires a new pending changelog entry.
