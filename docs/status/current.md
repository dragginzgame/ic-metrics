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
`6ad8ea6667e657d7e81c273a8265697c1d3a168f` and adopts Shared Tooling 0.25.8.
CI runs the existing native/Wasm Clippy gate after tool/pin/format admission and
before test suites and documentation builds. Publication and its dry run also
run that gate before Cargo packaging; sequential recipes preserve refusal under
parallel Make. Numbered `- Unreleased` headings now finalize automatically during
release preparation. [The release guide](../releases.md) owns those contracts.

Qualification covers changelog/metadata finalization, Metrics' parallel Make
ordering and lint-failure refusal, snapshot integrity, tool admission, formatting,
pins and documentation links. This batch changes no Rust source, library API or
storage bytes. The incoming Memory 0.49.3 lock update is preserved separately;
this tooling adoption does not claim its complete qualification. Full CI/MSRV
and native macOS checks remain release gates; no new IC measurement is claimed.
Compiler and library selections stay local; the host guide owns setup and policy.

## Evidence scope

The [Memory 0.49 IC comparison](../evidence/memory-0147.md) retains its exact
Memory 0.49.0/Storage 0.5.7 graph. The preceding
[governed-store receipt](../evidence/stable-current-0146.md) and
[Memory patch qualification](../evidence/memory-0491.md) retain their own graphs.
Neither frozen experiment qualifies a new artifact's IC costs or a consumer's
persistence policy. Original archives remain unchanged.

The [0.14.11 handoff](https://github.com/dragginzgame/ic-metrics/blob/6ad8ea6667e657d7e81c273a8265697c1d3a168f/docs/status/current.md)
retains completed metadata diagnostics qualification. Its linked
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
