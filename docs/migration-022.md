# Native metadata selection in the pending 0.22 contract

Metrics arithmetic and validated Serde transport remain available on every
target. The default-enabled `native-wire` feature selects native Wire TypeScript
metadata. It adds no Wire dependency on Wasm. Logging remains independent.

Default-feature consumers retain native metadata. Native schema generators that set
`default-features = false` must add `features = ["native-wire"]` to retain the
Wire trait implementations. Arithmetic-only consumers can disable defaults to
exclude native Wire. The `recording` feature remains independently selectable.

The native integration selects Wire 0.11. Consumers deriving Wire or generating
schemas for reports containing Metrics values must align that dependency identity;
Wire 0.10 and earlier traits are distinct. After a matching Metrics release is
published, select the coordinated graph, for example:

```toml
[workspace.dependencies]
ic-metrics = { version = "0.22", default-features = false, features = ["native-wire"] }
ic-wire = { version = "0.11", default-features = false, features = ["typescript"] }
```

Libraries exposing Metrics types must also agree on the Metrics package identity.
Qualify report derives, generated codecs and bounded encode/decode against that
graph. Serde-only consumers acquire no new Wire trait requirement.

Upstream Wire 0.11 selects Platform 0.12 for its optional `platform-types` and
`endpoint` integrations. Applications selecting those integrations coordinate
their own Platform dependency identities and qualification. This workspace
selects only native `typescript` metadata, without Platform or an endpoint runtime.

Numeric APIs, rounding, errors, Serde fields and persisted representations are
unchanged. The exposed Wire trait identity and former no-default-features metadata
contract require a minor release. Own package metadata remains 0.21.1; publication
and consumer adoption remain separate. The [0.20–0.21 guide](migration-020.md)
retains the previous Wire 0.10 contract.
