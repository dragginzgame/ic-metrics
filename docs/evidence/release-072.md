# Published 0.7.2 verification

Local release HEAD, public main and the peeled 0.7.2 tag agree on
`711fbfa198fb16a3747441c0c1b0512a48047d77`. Both official archives match their
non-yanked registry checksums and embed that exact source commit:

| Package | SHA-256 | Rust floor |
| --- | --- | --- |
| ic-metrics 0.7.2 | `0c050c95dd910cc884a67ffae47394ab2f8ce8cf5968bcb1e6485eba220f6c7c` | 1.85 |
| ic-metrics-stable 0.7.2 | `e0e55809f067ba474b0ac11970d59a359cdd14ea5015f04d22e062d612f4daa9` | 1.88 |

All packaged Rust sources match the released tree: 11 arithmetic files and four
stable-store files. The arithmetic archive remains dependency-free with no
features. The separate stable adapter retains its optional one-map contract.
The release delivers Shared Tooling 0.8.1, the macro-safe formatter selection,
and a committed Host 0.14.5/IC Memory 0.35.15 lock. The frozen local preparation
receipts retain their earlier Host 0.14.4/Memory 0.35.14 graph; released-source CI
qualifies the actual committed selection separately.

The committed [durable IC experiment](stable-cost-072.md) retains SHA-256
`451b3f0acb5e1e457b11d609a1fe6dfdabdb3006a19111fb63e94c70dcb87de6`;
its [delivery receipt](stable-store-delivery-072.tar.gz) retains
`ea9c60f64f6cf113991cf3f295ea606a0e29c1ecfcdd4ee0b026c92cee094e26`.
Both archives are verified byte-for-byte against the released commit. This
completes [#64](https://github.com/dragginzgame/ic-metrics/issues/64)'s delivery
criterion without expanding the experiment's measured domain. Both Shared
adoption archives also retain their original committed hashes and source scopes.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38235066759)
passes Linux native and all package-floor checks. Both macOS lanes remain queued
at this observation; [#65](https://github.com/dragginzgame/ic-metrics/issues/65)
retains native acceptance. The cancelled 0.7.1 run keeps its original observation
and does not count as a passing matrix. No dependency update or new release is
required merely to close a superseded run once equivalent later coverage exists.

Downloaded Linux artifact `11740730867` verifies its API ZIP SHA-256
`c0cb13d3a635023ef45889b9e1df8e17322ff2389d4c0ee6abab6e313fa96440`, inner archive
checksum, all 86 exact-source file hashes and all 14 payload hashes. Its source,
run/attempt, Linux/x86_64 identity and all seven outcomes agree with the successful
owning job. Native macOS receipts remain separate.

Raw official rows, downloaded archives, CI observation and verification results
remain under `target/evidence/release-072`. This review changes no package
metadata, lock selection, index or refs and executes no release/publication.
