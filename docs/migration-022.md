# Native metadata selection in 0.22

Metrics arithmetic and validated Serde transport remain available on every
target. The default-enabled `native-wire` feature selects native Wire TypeScript
metadata. It adds no Wire dependency on Wasm. Logging remains independent.

Default-feature consumers need no change. Native schema generators that set
`default-features = false` must add `features = ["native-wire"]` to retain the
Wire trait implementations. Arithmetic-only consumers can disable defaults to
exclude native Wire. The `recording` feature remains independently selectable.

The native integration still selects Wire 0.10. Numeric APIs, rounding, errors,
Serde fields and persisted representations are unchanged. This changes the former
no-default-features metadata contract and requires a minor release. Publication
and consumer adoption remain separate.
