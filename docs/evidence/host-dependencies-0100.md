# IC Host 0.10.0 consumer review

The pending compatible Metrics 0.3.5 batch preserves independently incoming
manifest and lock edits selecting `ic-host-artifacts` and `ic-host-fs` 0.10.0.
No resolver or dependency upgrade runs during this review. Metrics workspace/package
versions stay 0.3.4; its default arithmetic package remains dependency-free.

Public Host release source is
`98562bea26a98993d93b80ed908bea4876c32a91`. Both cached registry archives verify
their selected lock checksums and official non-yanked registry rows, Rust 1.88.0
floor and embedded Git identity. Every packaged source and original member manifest
matches that source: 20 files for artifacts and 19 for fs.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts 0.10.0 | `70b267f50da5fa4d87729f40cc00072d224af62bf8b5446aa87b9798513901c2` |
| ic-host-fs 0.10.0 | `4543a92fec91a208bbf0b7baaf4c8bd360f907c05e0509eb4bd2e75d630a64f2` |

Host's breaking change consolidates pathname publication on
`durable::write_with(path, options, producer)` and retains publication/cleanup
state in writer and lock-file errors. Metrics has no durable writer or lock caller:
the inspector consumes `read::read_file`, artifact hashing and Wasm inspection.
Source comparison with Host 0.9.7 confirms `ic-host-artifacts` and the fs read
modules are unchanged. No Metrics caller rewrite, output/schema change, data
migration or new file-publication mechanism is needed. The private dependency
update therefore does not break a Metrics API or require a new minor line.

Focused locked offline Linux checks pass: warning-denied all-target inspector
Clippy, two argument tests, three report tests, expanded actual CLI admission,
budget and closed-pipe coverage, Rust 1.88 all-target compilation and execution
of the same CLI case with that minimum compiler. Manifest/lock and tool-pin
hashes remain unchanged throughout. These results bind 0.10.0 separately from
the earlier [0.9.7 CLI record](inspector-cli-035.md).

[Exact upstream CI](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37961457616)
passes Linux native and MSRV; both macOS jobs remain queued at observation.
Local execution does not supply native macOS or IC runtime/cost qualification.
Package/source/check logs are under `target/evidence/host-0100/`; public source,
official registry rows and CI reads are under `target/evidence/host-latest-035/`.
Production Rust, arithmetic and inspector output remain unchanged. No sibling
edits, full local CI/product suite, commit, push, release or publication runs.
