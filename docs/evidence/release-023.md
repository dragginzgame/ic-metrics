# Tagged 0.2.3 publication and qualification

Tag `v0.2.3` identifies source
`89f8c6947fb3253991c65479f04bf14acb676328`.
The official crates.io sparse index reports non-yanked version 0.2.3 with archive
SHA-256 `27bb8ca9caa9b67570031d26f2f35f9e113f69b73278cca59b08e9447e13b593`.
The archive downloaded from static.crates.io matches that digest. Its embedded
Git commit/path, Rust files, original Cargo manifest, license, README and Cargo
lock match the tag. Normalized package metadata has no runtime, development,
build or target dependencies and no features. The Rust source is byte-identical
to 0.2.2; workspace/package versions are the only Cargo graph changes.

Index and archive inputs, extracted files and comparison receipts remain under
`target/evidence/release-023/`. An initial identity probe assumed an explicit
`git.dirty` field and rejected its absence. That aborted attempt is retained;
the corrected identity check and independent source comparisons pass. It was
a probe assumption, not evidence of an archive mismatch. Archive paths were
checked before extraction. No downloaded tooling or library code was executed.

[Exact-source CI run 37502954597](https://github.com/dragginzgame/ic-metrics/actions/runs/37502954597)
passes native validation on Ubuntu 24.04, macOS 15 Intel and macOS 15 Apple
Silicon, plus Linux MSRV. The recorded source-bound pre-release checks are preserved in the
[tagged handoff](https://github.com/dragginzgame/ic-metrics/blob/v0.2.3/docs/status/current.md).
The upstream Shared Tooling all-host pass qualifies its own source, and the
[0.2.2 all-host record](release-022.md) qualifies the earlier consumer source.
The exact 0.2.3 run supplies its own native qualification.

All three native artifacts were downloaded. Each `native-ci.tar.gz` matches its
SHA-256 receipt; its paths were checked before extraction. Every recorded source
hash matches immutable tagged source, and each native outcome records success.
The retained fixture evidence records twelve expected success/failure outcomes
per host, including child, assertion, publication and formatter-version failures.
The archived hidden Git indexes are present. Archive contents, verification
script and logs remain under `target/evidence/release-023/artifacts/` and
`target/evidence/release-023/`.

The initial artifact probe used an incorrect publication-scenario directory
name and stopped; that attempt is retained. The corrected probe passes all
three archives. These checks independently verify bundled tarballs and source
receipts; they do not independently verify the artifact ZIP digest or establish
live release execution, consumer attribution or IC performance measurements.
