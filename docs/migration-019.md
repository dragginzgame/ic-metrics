# Native Wire metadata in the pending 0.19 contract

This source selects IC Wire 0.8.0. Metrics' native `Wire` implementations now
belong to that Rust dependency identity. Wire 0.7's trait is a different trait,
so native reports deriving Wire or requesting schemas for embedded Metrics
values must align their direct Wire dependency to 0.8.

After a corresponding Metrics release is available, select the coordinated graph:

```toml
[workspace.dependencies]
ic-metrics = "0.19"
ic-wire = { version = "0.8", default-features = false, features = ["typescript"] }
```

Keep native-only Wire inheritance where appropriate. Libraries exposing Metrics
types must also agree on the same Metrics package identity throughout the graph.
Do not use two Wire versions as an implicit metadata compatibility bridge.
Qualify existing report derives, schema generation and bounded encode/decode
paths against the selected dependencies. No report fields, Serde layouts,
arithmetic semantics or Logging operations change in this adoption; Serde-only
callers acquire no new Wire trait requirement.

The upstream Wire minor release changes its optional endpoint integration to
Platform 0.9.1. This workspace enables only native metadata, not `endpoint`, and
adds no Platform runtime dependency. Applications using endpoints coordinate
their own Platform 0.9 graph and runtime qualification separately.

Pending notes select 0.19.0 because the native metadata trait identity is exposed
to consumers. Package metadata remains at 0.18.1 until a separately authorized
minor release; this guide does not establish registry availability or authorize
publication. Existing durable record layouts and retained state are unchanged.
