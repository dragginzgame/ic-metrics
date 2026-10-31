# Wire stable-identity qualification — 2026-10-31

The candidate adopts registry Wire/Derive 0.12.1 on source base
`402168f` (release 0.22.0). It selects the latest patch of the expected stable
identity core 0.12 line. Own package metadata stays 0.22.0; pending 0.23 notes
record the exposed native trait identity change. No release or publication ran.

## Published inputs and source alignment

| Input | Qualified selection | Status |
| --- | --- | --- |
| Wire core and derive | 0.12.1 | Published, non-yanked; Rust 1.91 |
| Canonical Platform Types | 0.1.0 | Published, non-yanked; Rust 1.91 |
| Platform façade | 0.14.0, principal only | Published, non-yanked; reexports Types 0.1 |
| Metrics | Current repository source, own version 0.22.0 | Unpublished dependency selection; copied verbatim into a temporary workspace |

Wire's registry package identifies upstream release commit
`ae9a3eda0449729008d849c6e078a8b7f849ab9e`; official registry checksums match the
selected root lock entries. The root lock changes only Wire/Derive. Principal and
Account compatibility uses `ic-platform-types 0.1.0`: no Types 0.14 package is
published. Platform 0.14's façade reexports those exact types.

The isolated workspace owns copied Metrics/Logging members and the consumer
[probe](probe.rs), with the [consumer manifest](Cargo.toml.snapshot). All external
dependencies come from the registry. There are no patches, external path
suppliers, altered sibling checkouts or rewritten Metrics Rust sources. Source
comparison confirms the copied Metrics source exactly matches the candidate.
The copied package version is not a claim that registry Metrics 0.22 implements
Wire 0.12. Native metadata consumers need a subsequently published Metrics release.

## Results and limits

Evidence is retained locally in `target/audits/wire-0121-20261031/`:

- Eight native metadata/transport tests and 15 Metrics doctests pass at Rust 1.91.
  Strict Metrics library/test/all-feature Clippy passes on Rust 1.99.1.
- The actual five-report Rust/TypeScript check passes on Node 24.21.0. A fresh
  Wire 0.11 baseline and the 0.12.1 candidate produce byte-identical Rust payload
  vectors and generated TypeScript codecs for these reports.
- Four native-minimal/recording/default/Wasm dependency profiles and four minimal
  Serde tests pass. The production graph excludes Platform, Types and Endpoint.
- All three identity tests pass on Rust 1.91. Real canonical Principal/Account
  schema implementations compose with all four Metrics shapes. Assignment and
  schema equality prove Platform 0.14 reexports use the same identities.
- Principal `01 04`, absent Account `01 04 00`, and explicit-zero Account
  `01 04 01` plus 32 zero bytes match the asserted goldens. The subaccount field
  is checked separately because Account equality normalizes absent/zero.
  Composed reports preserve fields and typed malformed/resource refusals.
- The identity consumer checks for Wasm at Rust 1.91. Its graph has exactly one
  Wire 0.12.1, Types 0.1.0 and façade 0.14.0, with no endpoint, CDK, IC0 or runtime
  guard. The separate arithmetic-only Wasm example links without an allocator at
  Rust 1.91, using the actual root package rather than the identity workspace.

The identity fixture intentionally selects Wire's platform-types and Platform's
principal feature. Those selections belong only to this qualification client;
Metrics itself selects neither. These are local source-adoption checks, not a
published Metrics 0.23 qualification, full release gate, macOS acceptance,
installed endpoint test or browser execution. The Node check executes generated
TypeScript through transform-types; it is not static TypeScript type checking.

## Reproduction

Use prepared Rust 1.99.1/1.91.0, the Wasm target, Node from ci/node-version.txt and
locked registry sources. The ordinary focused commands are:

```sh
cargo +1.91.0 test -p ic-metrics --lib --no-default-features --features native-wire --locked --offline wire::tests
cargo +1.91.0 test -p ic-metrics --doc --all-features --locked --offline
make typescript-check metrics-profiles-check
bash scripts/ci/check-allocation-free.sh 1.91.0
```

For identity composition, make a fresh workspace beneath target, copy the root
catalog/lock/toolchain and complete Metrics/Logging source and manifests, and add
an identity-probe member using Cargo.toml.snapshot and probe.rs as its library.
Both path dependencies are then workspace-owned; only the probe introduces the
published Types and façade dependencies. Extend the copied lock offline once,
then use the locked commands below. Never change registry sources or a sibling
checkout to satisfy a trait bound:

```sh
cargo +1.91.0 test --manifest-path "$probe_workspace/Cargo.toml" -p wire-identity-probe --lib --locked --offline
cargo +1.91.0 check --manifest-path "$probe_workspace/Cargo.toml" -p wire-identity-probe --lib --target wasm32-unknown-unknown --locked --offline
```

## Publication boundary

[Migration guidance](../../migration-023.md) describes the pending graph.
`ic-metrics` needs publication for consumers requesting its Wire 0.12 metadata;
`ic-logging` has no Wire dependency and no publication prerequisite for this work.
Tooling's published Metrics 0.22 arithmetic-only use disables defaults and uses no
native metadata, so it can retain that selection during its own Wire adoption.
Testkit's exposed Wire Limits/Error still require Tooling-owned alignment and
qualification. No source-only check establishes a published consumer pairing.
