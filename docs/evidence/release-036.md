# Published 0.3.6 verification

Released source `93c350a1179c83a3cfc8f7f713c50bc1c6be6a8f` matches public main,
annotated tag `v0.3.6` and package/workspace versions. The non-yanked official
registry package has no dependencies or features and declares Rust 1.85.0.
Archive SHA-256 verifies as
`84cfc0047aea1166444ad3f900fc1d78715dbb2a212db25f0032519492d084a7`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match released source. The packaged lock contains only
Metrics 0.3.6. Arithmetic source is unchanged from 0.3.5; the private graph
selects [separately qualified Host 0.10.1](host-dependencies-0101.md).

[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38033927297)
initially passes Linux, Apple Silicon and both package-floor checks while Intel
is running. The subsequent observation finds all four jobs completed successfully
on attempt 1. Independently downloaded receipts verify on all three hosts:

| Host | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Linux | `11662304142` | `ead92995270d832c009baf9f9edc761e72e3530a35bfdc00551248590aa7a639` | `3d0f58be154f6f9126c7fb6ecd168d8a38f50e7bb0ff391d538e193df5eaabff` |
| Intel macOS | `11663274790` | `5359cdd1acf01456174ab84eef39fb32e30cdab8db902ddc1b7f0f7676fdded2` | `66ef2313eed775acc5dd59b064518046d491881e24ef2ac613c77d6d2b196677` |
| Apple Silicon macOS | `11663353967` | `8bde2921343c626351e76c8ea9a7097092d6776d10a135d0635261d0219cf309` | `5491e3dfd1e43f129a6f28a2c0841e0d5a953ca5e894d07a093355901ad8428c` |

Each receipt verifies GitHub's ZIP digest, the inner checksum, 14 payload hashes,
69 released-source hashes, source-file ordering and the exact run/attempt/push/
host identity. All nine setup/native outcomes and job steps succeed. IC pin
catalogs and tool host identities match the release. Source-bound logs confirm
the actual expanded inspector CLI test, formatting/hook checks and release/
admission fixtures pass with their documented substitutions.

This completes released 0.3.6's native/MSRV acceptance. It does not qualify
pending 0.3.7's formatting reporter/collector adoption or repair the known
[Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30) hidden-mode
gap. That independently reproduced boundary remains in Metrics #44.
Native substitutes establish no IC measurement or performance improvement.

Initial and completed CI inputs, tag/registry data, downloaded archives, verified
logs and verification JSON are retained under `target/evidence/release-036/`.
No workflow rerun, release or publication occurs during this verification.
