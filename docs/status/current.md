# Current handoff

IC Metrics owns allocation-free, dependency-free `no_std` integer arithmetic.
The optional stable package owns validated V1 snapshots in one governed Storage
map. Consumers own sampling, attribution, units, identities, registries, lifecycle
and endpoints. [The extraction contract](../extraction.md),
[stable guide](../../crates/ic-metrics-stable/README.md) and
[host guide](../hosts.md) own those boundaries and local qualification commands.

## Selection and qualification

[Cargo.toml](../../Cargo.toml) owns workspace versions and dependency requirements;
[Cargo.lock](../../Cargo.lock) owns resolved dependency identities. The
[changelog](../../CHANGELOG.md) records released changes and the pending batch.
Those files do not prove registry publication, hosted CI or consumer acceptance.

Shared Tooling's reviewed source and payload digests belong to
[the snapshot](../../.shared-tooling.snapshot). The local batch starts at
`07c25710490c04fccebde7cfb8cf183a3754ea19`, preserving the incoming Memory 0.50.0
and Storage 0.50.0 manifest/lock selections. Both published packages bind
IC Persistence source `f452b5cf9b26a25ee2fb69f4941c079e9c85f4e7`. Their library
source trees match Memory 0.49.3 and Storage 0.5.8 respectively. Storage aligns
its Memory requirement and pins the already selected substrate at 0.7.2; no
other resolved dependency changes. Rust floors, features, Metrics V1 rows and
upstream stored formats remain unchanged.

The pending 0.15.0 notes reflect exposed Rust dependency identities, rather than
a stored-format change: stable hosts must align their Memory and Storage 0.50
dependencies before passing governed maps. The arithmetic package stays
dependency-free. Package versions and release execution remain maintainer-owned.

Qualification covers stable native/Wasm Clippy, package tests and doctests,
native all-target/Wasm library Rust 1.91 checks, production dependency admission,
pins, formatting and documentation links. Full CI/MSRV and native macOS checks
remain release gates; no new IC measurement or downstream acceptance is claimed.
Compiler and library selections stay local; the host guide owns setup and policy.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) and
[Memory patch qualification](../evidence/memory-0491.md) retain their own graphs.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [0.14.12 handoff](https://github.com/dragginzgame/ic-metrics/blob/07c25710490c04fccebde7cfb8cf183a3754ea19/docs/status/current.md)
retains completed tooling adoption and qualification. Its linked
historical handoffs preserve earlier identities and evidence paths. Historical
observations are not current issue/PR status. Follow the
[archive distribution record](../evidence/archive-distribution-072.md) for public payloads.

## Owning follow-up links

Read the owning issues for their current disposition; this handoff is not a
second issue-status ledger:

- [Published Testkit memory observations](https://github.com/dragginzgame/ic-metrics/issues/82).
- [Durable scalar consumer acceptance](https://github.com/dragginzgame/ic-metrics/issues/83).
- [Storage discard-value mutations](https://github.com/dragginzgame/ic-storage/issues/12).
- [Evidence archive distribution review](https://github.com/dragginzgame/ic-metrics/issues/72).
