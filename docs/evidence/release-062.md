# Published 0.6.2 and complete native acceptance

Public annotated tag `v0.6.2`, the official archive's embedded Git identity and
the source of the completed CI run agree on
`4dcbe1955b4f90b42ccab8a82ae634291ef1797d`. The non-yanked registry row declares
Rust 1.85.0, no dependencies and no features. Archive SHA-256 verifies as
`0189d4569ebf5ffac826e6dac889571b0c3b920cfaf94fb215649866659e3f78`.
The complete packaged arithmetic source, original manifest, README and license
match this released source. The current 0.6.3 arithmetic source is byte-identical.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38129755118)
has completed successfully: Linux, macOS 15 Apple Silicon, macOS 15 Intel and
the job checking both Rust floors all pass. Each independently downloaded
native artifact verifies its API-declared ZIP digest, inner archive digest,
all 72 released-source hashes, exact workflow catalog, all 14 payload hashes,
source/run/attempt/native host/IC pins and seven successful outcomes.

| Host | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Linux x86-64 | `11698523707` | `c29051066de0439bc12ba210dacf14d15b8b5a96b67e45ff233f528df8df5c8a` | `6f78749d65eefaf02f343c1a4cc5546329c9df75407eb82988ceeabbb8cf9f67` |
| macOS 15 ARM64 | `11699365722` | `e373f6308dec8f953a22212d1f835147630034d28946a1d71e3ac1144d1adfea` | `46dc001df059003d37f928693f9818779588c6360e38bed0b136b83278722116` |
| macOS 15 Intel | `11700457037` | `ff67145b060ce9d00bf3be139ade44f8b1cb787de9264259b8e6f194e07f0c94` | `fa41580191a3cf31299483e13d9c342fe29ab0f565d38df70a5704be96f392c1` |

Actual aggregate/collector, release metadata/admission/retention, formatting-hook,
inspector CLI and arithmetic checks execute on every host. Each receipt retains
two nonempty formatting diagnostics; no warning or missing-jobserver diagnostic
appears in the native gate logs. Fixture effects remain substitutes, and native
tests do not establish IC instruction or cycle costs. Those observations remain
with the separately frozen [quantile experiment](quantile-cost-062.md).

The released source uses Shared Tooling 0.3.12 and private Host 0.13.1. Snapshot,
workflow, Make/hook/script and inspector sources are unchanged from 0.6.1;
the actual qualified graph and arithmetic are this 0.6.2 release. This completes
the current root arithmetic contract's native acceptance in
[#57](https://github.com/dragginzgame/ic-metrics/issues/57) and the delivered
0.3.12 tooling adoption in [#58](https://github.com/dragginzgame/ic-metrics/issues/58).
It does not relabel cancelled 0.6.0/0.6.1 sources as qualified. Consumer adoption
remains at its owning issues. In particular, Backup's
[0.6 adoption](https://github.com/dragginzgame/ic-backup/issues/38) remains open;
Timers' [owning acceptance](https://github.com/dragginzgame/ic-timers/issues/43)
is closed. The newer 0.6.3 Shared 0.5.0 installation/collector contract needs
its own native acceptance under [#60](https://github.com/dragginzgame/ic-metrics/issues/60).

Registry inputs, API observations, all three raw ZIPs/archives, independently
recovered receipts, execution excerpts and verification results remain under
`target/evidence/review-062-native/`. This is fresh hosted recovery; it does not
restore previously deleted local evidence. The separate current Host 0.13.2
working lock is preserved byte-for-byte and is outside this qualification.
This review performs no build, dependency selection, installation, dispatch,
staging, release or sibling mutation. No new behavior needs pending release notes.
