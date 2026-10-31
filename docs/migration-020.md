# Native Wire metadata in the 0.20–0.21 contract

This source selects IC Wire 0.10.0. Metrics' native metadata implementations now
belong to Wire 0.10's Rust dependency identity. Native reports deriving `Wire` or
requesting schemas for embedded Metrics values must use that same Wire line;
Wire 0.9 and earlier traits are different traits.

Select an available Metrics release and the coordinated Wire graph:

```toml
[workspace.dependencies]
ic-metrics = "0.21"
ic-wire = { version = "0.10", default-features = false, features = ["typescript"] }
```

Keep native-only Wire inheritance where appropriate. Libraries exposing Metrics
types must agree on the Metrics package identity throughout the graph. Qualify
report derives, schema generation and bounded encode/decode against that graph.
Arithmetic, Serde fields, metadata shapes and Logging behavior remain unchanged;
Serde-only callers acquire no new Wire trait requirement. Durable record layouts
and retained state are not replaced by this dependency adoption.

Upstream Wire 0.10 selects Platform 0.11 for its optional integrations. Applications
using Platform Principal/Account metadata replace Platform's retired `wire-schema`
feature with Wire's `platform-types`; endpoint applications coordinate their runtime
dependencies and qualification separately. This workspace needs neither integration:
it enables only native `typescript` metadata with defaults disabled, and adds no
Platform runtime dependency.

Release 0.20.0 introduced this native metadata trait identity. Release 0.21.0 repeats
that contract after an accidental second minor release, with no further API,
behavior or dependency changes. Workspace metadata is now 0.21.0; release records
alone do not establish registry availability or consumer qualification.
