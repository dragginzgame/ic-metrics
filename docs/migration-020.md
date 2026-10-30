# Native Wire metadata in the pending 0.20 contract

This source selects IC Wire 0.10.0. Metrics' native metadata implementations now
belong to Wire 0.10's Rust dependency identity. Native reports deriving `Wire` or
requesting schemas for embedded Metrics values must use that same Wire line;
Wire 0.9 and earlier traits are different traits.

After a corresponding Metrics release is available, select the coordinated graph:

```toml
[workspace.dependencies]
ic-metrics = "0.20"
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

Pending notes select 0.20.0 because the native metadata trait identity is exposed
to consumers. Own package metadata remains at 0.19.0 until a separately authorized
minor release. A workspace release alone does not establish registry availability.
