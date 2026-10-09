# Published 0.2.16 qualification

Release `v0.2.16` selects `d8276daa3ae8603a5b4e196d0bb5369de54c1216`,
matching public main, workspace/package metadata and local lock versions.
The official registry index reports a non-yanked package published
2026-10-08T18:12:19Z, with no dependencies/features and Rust 1.85.0. The newly
downloaded official archive verifies SHA-256
`44b447757f583aa5e5145e34bbd6d8b75004614d90ef33544252c9e496178155`.
Embedded Git identity, all five Rust sources, application guide, original manifest,
README and license match the release commit. Normalized metadata agrees with the
version/Rust floor; the packaged lock contains only `ic-metrics` 0.2.16.

[Exact-source CI 37822463635](https://github.com/dragginzgame/ic-metrics/actions/runs/37822463635)
passes Linux x86-64, macOS 15 Intel, macOS 15 Apple Silicon and both package
minimum-compiler checks. All three downloaded native archives verify outer,
payload and selected-source hashes, run/attempt/event/host identities and all nine
successful setup/native outcomes. Their retained IC pin catalogs match the
release's canonical PocketIC 16.1.0 selection byte-for-byte.

| Native artifact | SHA-256 |
| --- | --- |
| Ubuntu 24.04 | `edbe24b51fc2d14fae8fb1bda4a89160dccaef1279ebbe29208cf81ac32b6ac4` |
| macOS 15 Intel | `859185d714fdb06f65412302969882605dec0170a62f269402c2991be72df365` |
| macOS 15 Apple Silicon | `7ed56c04feb7e8904fe7e42e8e2034eaeaa159dd8316b27407fa25a0e40212a3` |

Each native log records all 19 disposable real-Git tracking cases, consumer
release metadata/admission fixtures and the private inspector's argument/report
tests passing. Compilation and tests select locked IC Host 0.8.4. The separately
downloaded minimum-compiler log records actual Rust/Cargo 1.85.0 core host/Wasm
checks and Rust/Cargo 1.88.0 inspector all-target checks passing. Command-substitute
and disposable-repository tests do not qualify an interrupted live GitHub release.
IC tool installation checks are not canister execution or cost measurements.

The 91-file snapshot selects Shared Tooling
`4e274a2219c0b0cc3af68ec65658b373253518fb`. That upstream's
[exact matrix](https://github.com/dragginzgame/shared-tooling/actions/runs/37809818114)
now passes all three native hosts and lint/security. The selected Host 0.8.4
[matrix](https://github.com/dragginzgame/ic-host-tooling/actions/runs/37818647474)
also passes all native hosts and MSRV. These upstream outcomes retain their own
scope; the downloaded Metrics receipts qualify this consumer.

This completes [#37](https://github.com/dragginzgame/ic-metrics/issues/37)'s
released-source native/receipt acceptance. The original
[snapshot preparation](adoption-0216.md), [Host dependency review](host-dependencies-0216.md)
and [0.2.15 release](release-0215.md) keep their original identities. Downloads,
comparisons and logs are under `target/evidence/release-0216/`. No full local gate,
dependency update, package version change, commit, push, release, publication or
sibling edit runs during this verification. Downstream acceptance remains in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).
