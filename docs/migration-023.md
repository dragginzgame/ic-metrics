# Stable Wire identities in the pending 0.23 contract

Metrics native metadata now implements Wire core 0.12's trait, selecting published
Wire/Derive 0.12.1. Wire 0.11 and earlier traits have a different dependency
identity. After a matching Metrics release is published, select one Metrics/Wire
identity across libraries composing these values:

```toml
[workspace.dependencies]
ic-metrics = { version = "0.23", default-features = false, features = ["native-wire"] }
ic-wire = { version = "0.12.1", default-features = false, features = ["typescript"] }
```

Defaults still enable native metadata. Arithmetic and validated Serde remain
available without Wire when defaults are disabled. Recording remains separately
selected; Wasm Metrics excludes Wire even with all features. Logging is independent.
Numeric behavior, typed errors, Serde fields, native schema shapes, encoded bytes
and retained formats are unchanged.

Applications composing Principal/Account schemas select Wire's `platform-types`
feature and canonical `ic-platform-types = "0.1"`. Platform 0.14 reexports these
same owned types; 0.14 is the façade version, not the types package version. Wire
owns their schema implementations. Do not add application-owned trait bridges or
metric mirrors. Metrics itself needs no identity or Platform dependency.

Wire 0.12 separates endpoint integration into `ic-wire-endpoint`. Endpoint owners
migrate their imports and select that package only when needed. This repository
has no endpoint consumer and adds no endpoint package or Platform runtime.

The [identity qualification receipt](evidence/wire-stable-identities-0121/README.md)
distinguishes published Wire/Types/Platform dependencies from the temporary source
copy used to qualify this unpublished Metrics selection. Own package metadata
remains 0.22.0; these notes do not establish publication of Metrics 0.23.

Native schema users need a published `ic-metrics` containing this integration.
`ic-logging` needs no publication for Wire compatibility. Tooling's existing
arithmetic-only Metrics 0.22 use can remain unchanged while its owning Wire
callers adopt core 0.12; native metadata consumers need the new Metrics release.
