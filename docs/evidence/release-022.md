# Tagged 0.2.2 qualification

Tag `v0.2.2` identifies source
`057d98813300d741d5782a6cab7c51507f63c55a`.
[CI run 37493725240](https://github.com/dragginzgame/ic-metrics/actions/runs/37493725240)
passes Ubuntu 24.04, macOS 15 Intel, macOS 15 Apple Silicon and Linux MSRV.
Each native job passes its configured validation, retention and evidence-upload
steps. This qualifies the maintained arithmetic and tooling at that exact source;
it does not establish consumer attribution or live release/publication effects.

The three downloaded native artifacts contain checksummed `native-ci.tar.gz`
archives. For each host, archive paths were checked before extraction, the
tarball checksum matches its receipt, and the recorded source commit and every
source hash match the tagged Git bytes. Hidden Git indexes survive extraction.
The twelve retained fixture outcomes match the expected success and injected
child/assertion failure statuses across standard release, publication, metadata
and hook checks, including the formatter-version rejection.
Downloaded archives, extracted inputs and verification rosters remain under
`target/evidence/release-022/artifacts/`. ZIP digests were not independently
verified; the uploaded tarball and its source receipts were verified.

This supplies the outstanding native and artifact qualification for
[#7](https://github.com/dragginzgame/ic-metrics/issues/7),
[#11](https://github.com/dragginzgame/ic-metrics/issues/11) and
[#12](https://github.com/dragginzgame/ic-metrics/issues/12).
The earlier 0.2.1 macOS failures and the pre-release local observations retain
their original scope; the later successful run does not relabel them.

The official crates.io sparse index reports non-yanked version 0.2.2 with
checksum `0fa3982ca31b157ba4d0aeda9d9c578c0b4e6b8e5755c39d593160551ad61285`.
The index response is retained under `target/evidence/adoption-023/`.
The first read through the crates.io version API returned HTTP 403; it supplied
no publication evidence. This index observation verifies version availability,
not the archive's embedded Git/source identity.
