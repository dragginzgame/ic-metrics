# Released 0.8.1 native acceptance

Released/public 0.8.1 is `368f2dca9a46faa639c3074ee45fc76d89b443e7`.
[The publication review](consumer-review-082.md#publication-and-qualification-identities)
verifies both non-yanked official package archives and all packaged Rust files.
The later [release CI run](https://github.com/dragginzgame/ic-metrics/actions/runs/38284066419),
attempt 1, completes successfully on that exact source, including the Rust-floor
job and all three native jobs:

| Native host | Retained artifact | ZIP SHA-256 |
| --- | --- | --- |
| Linux x86_64 | `native-ubuntu-24.04-1`, ID `11763136864` | `005f345738eefffc20508b39b1877a45c6c8f4b04cfaf16eda44ef8a6a31d867` |
| Intel macOS | `native-macos-15-intel-1`, ID `11768579624` | `8c97454945b6e26f5484d62df028337ccf7fac6df704daccfe6a481fab29430d` |
| Apple Silicon macOS | `native-macos-15-1`, ID `11770124141` | `64f25eccc71cc8f6fdef4335a3ba6fdbc4439e459341aaff3ff098d6cc0ecb5f` |

Each downloaded ZIP matches its API digest and size. Each enclosed native tar
matches its own checksum; its receipt matches the source commit, run/attempt,
push event and host architecture. All seven recorded outcomes are successful.
All 14 top-level payload hashes verify, and each of the 87 source hashes matches
the released Git object. The source inventory covers every released crate file
and the selected Cargo, Make, workflow and snapshot inputs.

The [compact receipt](native-closeout-081.tar.gz) and
[checksum](native-closeout-081.tar.gz.sha256) retain API identities, verification
results and the original top-level logs/manifests from all three hosts. Fresh
archive readback verifies the payload and released-source hashes. Its SHA-256 is
`414de11a519f8821f7ffb38a9b664c9c2d00f1424918d90882f8fcf0be49d6ba`.
The compact receipt omits nested fixture trees and cannot reconstruct the
original ZIP/tar bytes; complete downloaded artifacts remain under
`target/evidence/native-closeout-081/` and in the run's retained artifacts.

This completes the released-source native acceptance for
[#66](https://github.com/dragginzgame/ic-metrics/issues/66). The earlier cancelled
0.8.0 Apple Silicon run remains cancelled; the later complete 0.8.1 source is
the replacement acceptance. The original
[hard-cut preparation and matched IC experiment](tracked-080.md) retain their
own earlier source, graph and performance scope. Consumer adoption and
[#10](https://github.com/dragginzgame/ic-metrics/issues/10)'s Canic qualification
remain separately owned. These released receipts do not qualify the pending
[0.8.2 counter and incoming graph](counter-082.md) on macOS.
