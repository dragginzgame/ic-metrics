# 0.19 native metadata selection

Metrics arithmetic and validated Serde transport remain available on every
target. The default-enabled `native-wire` feature selects native Wire TypeScript
metadata. It adds no Wire dependency on Wasm. Logging remains independent.

Default-feature consumers need no change. Native schema generators that set
`default-features = false` must add `features = ["native-wire"]` to retain the
Wire trait implementations. Arithmetic-only consumers can disable defaults to
exclude native Wire. The `recording` feature remains independently selectable.

No numeric API, rounding, error, Serde field or persisted representation changes.
This release changes the former no-default-features metadata contract; it does
not authorize consumer deployment or reinterpret stored bytes.
