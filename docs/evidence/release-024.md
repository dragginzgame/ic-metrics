# Published 0.2.4 source and qualification

The pushed `v0.2.4` tag and remote main resolve to
`21e980b3ed4f1a8d9b6203079ef1e457a3fea588`. The finalized changelog and
Cargo package/workspace metadata select 0.2.4. The release contains the
separate fixed-size histogram and the 56-file Shared Tooling snapshot at
`e378671d90afa237ff63a4b0e3b9551eb2c222b6`.

## Registry observation

The official sparse index reports non-yanked 0.2.4 with no dependencies or
features and SHA-256
`7bec2da218f678f1e91693bb890a30e185daf0ac1b97475bf42e280dade2d9b6`.
The downloaded public archive matches that checksum. Its embedded Git identity
matches the release commit and `crates/ic-metrics` package path.

All five Rust files, the original member manifest and MIT license compare
byte-for-byte with the release. The packaged README matches the tagged README,
and Cargo.lock matches the release lock. Normalized metadata retains edition
2024, MSRV 1.88.0, the library target and crates.io publication selection, with
no dependency or feature tables. The archive's README contains preparation-era
wording; current repository docs now distinguish the published API explicitly.

Index input is retained under `target/evidence/adoption-025/registry-index.jsonl`.
Archive, extracted payload, tagged README, source receipts and CI result are
under `target/evidence/release-024/`. This observation uploaded nothing and
changed no version, lock, commit or tag.

## Native CI

[Exact-source CI run 37587072330](https://github.com/dragginzgame/ic-metrics/actions/runs/37587072330)
completed successfully for the release commit: Linux x86-64, native macOS
Intel, native macOS Apple Silicon and MSRV. Native evidence retention/upload
steps succeed on all three hosts. The full CI gate ran in its configured
pipeline; no full local gate was invoked by this continuation.

The earlier [histogram preparation](histogram-024.md) and
[Shared Tooling adoption](adoption-024.md) retain their original source/input
scope. Publication and native arithmetic/tooling CI do not establish histogram
cost, consumer adoption or actual IC instruction/cycle performance.
