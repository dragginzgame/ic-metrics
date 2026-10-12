# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and endpoints.
See [the extraction contract](../extraction.md) and [host qualification](../hosts.md).

## Pending 0.8.0 tracked recording cut

The maintainer approved [#66](https://github.com/dragginzgame/ic-metrics/issues/66):
remove raw recording/mean helpers, retain one tracked recording contract and add
checked scaled means. The public removals select 0.8.0 and carry the earlier
unreleased 0.7.4 tooling notes into that draft. Product metadata stays 0.7.3.
The stable V1 encoding remains unchanged; consumer report/schema adoption is
separately owned. Native/Wasm Clippy, focused aggregate/summary boundaries and
doctests pass. The [matched IC comparison](../evidence/tracked-080.md) verifies
888 measured replies and 18 admission refusals in each of three identical
matrices; separate-source replay rebuilds all 18 Wasms byte-for-byte. All six
consumer owners have scoped adoption issues. Fresh full CI passes in 258 seconds,
followed by all three package-floor gates, with unchanged canonical checkpoints.
The [frozen delivery receipt](../evidence/tracked-delivery-080.tar.gz) and
[checksum](../evidence/tracked-delivery-080.tar.gz.sha256) bind that final source
to the IC candidate. Earlier receipts retain their own inputs. Use the minor
release flow for 0.8.0 after reviewing/committing this batch; no package version,
Git release effect or publication was performed here.

## Included tooling cleanup

The snapshot adopts clean committed/public Shared Tooling 0.9.2
`c118062a070a2e238f1eb3989b6fd700f369ce1e` through its canonical exporter.
Nine payloads update; all 101 remain, with 89 explicit roots. Installer lock,
verified-cache reuse and cleanup now share their upstream owner. Checksum
manifests reject NUL before hashing, and installers reject supplied/resolved
CR/LF consumer paths before configuration or setup. Pins and active executable
selections are unchanged; ordinary commands remain supported.

[Adoption qualification](../evidence/adoption-074-shared-092.md) retains the
source-bound receipt. Full CI, all three package-floor gates, exact-source
distribution/path fixtures and selected ShellCheck pass. Canonical inputs remain
unchanged through validation; current-scope links and diff checks pass separately.

The earlier [root-selection receipt](../evidence/snapshot-roots-074.tar.gz) and
[checksum](../evidence/snapshot-roots-074.tar.gz.sha256) retain their original
Shared 0.9.0 scope: 12 internal helpers became derived companions with all 101
payload hashes/modes unchanged. They are not evidence for the later 0.9.2 bytes.
The tooling changes remain compatible within the combined 0.8.0 draft. Package
metadata stays 0.7.3; Cargo graph, pins, index and refs are preserved. Earlier
0.7.4 qualification receipts bind the pre-cut Rust and do not qualify 0.8 changes.

Historical handoff text now lives in [the frozen archive](history-through-073.md),
with all original observations and relative links retained. Current authority
no longer requires reading the accumulated release chronology.

## Released foundation

Both official non-yanked 0.7.3 archives match released/public
`e714085a972db88c348e4aabe57847f2124d2b97` and all packaged Rust sources.
[Release verification and complete native acceptance](../evidence/release-073.md)
bind Linux, Intel macOS, Apple Silicon and package floors to that exact source,
Host 0.14.9 and Memory 0.35.17. Earlier adoption/IC receipts retain their own
source and graph identities. Core's Rust floor is 1.85; the optional stable
adapter and private inspector require 1.88.

## Consumer qualification

[Metrics #10](https://github.com/dragginzgame/ic-metrics/issues/10) retains Canic's
owning native/interleaving acceptance. The authorized scoped Canic repair passes
Host Clippy, four Linux resolver tests, explicit peer refresh and ordinary
verification on registry Metrics 0.7.3/Host 0.14.9/Memory 0.35.17. The last named
held-HTTP attempt passed preflight and started Testkit 0.34.5/PocketIC 16.1.0,
then failed the required `canister_test` Wasm build on two Auth dead-code errors.
[Canic #491](https://github.com/dragginzgame/canic/issues/491#issuecomment-6126296804)
owns that integration blocker; [#450](https://github.com/dragginzgame/canic/issues/450#issuecomment-6126296388)
records the scoped repair. [#99](https://github.com/dragginzgame/canic/issues/99)/
[#447](https://github.com/dragginzgame/canic/issues/447) retain acceptance.
Full logs, selected input bytes and failed private scratch survive Cargo clean in
Canic's `.tmp/metrics-qualification-20261012/`. No new macOS or held-HTTP pass is
claimed by this local evidence. Current adoption work mutates Metrics only.
