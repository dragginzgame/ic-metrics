# Current handoff — 2026-10-29

IC Metrics 0.17.0 is released at `c45bb5a` and reported live by the maintainer.
Standard numeric transport lets consumers embed aggregates/counters directly in
reports. The release removes the former `wire` feature; consumers must remove
`wire` from feature lists. Heap recording still requires `recording`.

The existing documentation touch-up corrects release status and the transport
module description. It is preserved with the Observability consolidation below.

Serde Serialize/Deserialize for MeasurementAggregate and MeasurementCounter is
always available. Native IC Wire metadata is also standard. Private fixed-size
Serde records define the serialized layout; metadata follows those same records.
Decoding calls canonical from_parts admission. Empty/zero maxima, wide u128 totals
and actual overflow quality remain explicit; exact means are derived after decode.
There are no numeric representation, stored-byte or decoding-rule changes.

The crate remains no_std on every target; measurement operations remain allocation-free.
Serde is a required dependency on all targets. IC Wire with TypeScript metadata
is a required dependency only on native targets. Wasm numeric transport needs
Serde without the host metadata graph. The declaration checker admits this required
pair without dependency defaults, rejects optional/missing transport and unrelated
production/build dependencies, and retains the stable-substrate prohibition.

Only bounded heap recording requires a feature (`recording`). Applications retain
units, labels, report grouping, replication policy, limits, clocks, identity,
endpoints and controller reset. Table/window state remains heap-only. IC Persistence
owns stable formats, durable adapters and governed integration. Transport support
continues to cover aggregates and scalar counters; no storage framework is added.

Focused evidence is under `target/evidence/standard-transport/`: strict all-feature
library/test Clippy, default-feature transport round-trips, invalid-state and resource
refusals, browser metadata generation, Rust 1.91 default doctests and default Wasm
compilation, dependency-admission fixtures, documentation links and diff checks.
Evidence from released #99 remains in `target/evidence/transport-99/` under its
original opt-in feature identity. No browser runtime execution or IC cost delta is
claimed by those focused receipts. The documentation touch-up uses formatting,
link, consistency and diff checks; existing arithmetic evidence is reused.

Downstream owners can now select 0.17.0, remove the obsolete feature selection,
replace consumer numeric report mirrors and qualify their endpoint and browser
contracts. IcyDB integration and any remaining Canic adapter selection are owned
by those consumers; this repository does not establish their adoption status.

## Observability consolidation

The maintainer selected renaming this repository and local checkout to
`ic-observability`, adding the independent `crates/ic-logging` package alongside
`ic-metrics`. Both share the existing 0.17.0 workspace version and lockfile.
No package version bump, source commit, tag or publication is selected.
The existing two dirty documentation edits are preserved. Historical evidence
and reviewed Shared Tooling snapshot 0.27.4 remain unchanged.

Logging is dependency-free `no_std` + `alloc`, with fixed entry/label/message
bounds, UTF-8 truncation, monotonic sequence/time watermarks, explicit age
retention and scan-bounded cursor pages. It installs no endpoint, clock, timer
or lifecycle. `ic-metrics` retains its name and dependency graph; the two
libraries do not depend on one another. Stable adapters stay at IC Persistence.
Logging remains `publish = false`; Canic's current logger is unchanged.

The package guides are now beside each crate. The existing CI/Make aggregates
include both libraries. Dependency admission classifies each package and refuses
Logging dependencies, including inactive/build declarations and Metrics coupling.
The compiler-floor runner additionally includes Logging's doctest. Existing
release metadata already derives coordinated members; publication still selects
Metrics only. Open 0.17.1 notes describe this compatible workspace batch.

Focused checks pass in `/tmp/ic-observability-integration.wIEP78/ic-observability`:
12 Logging unit regressions, default and Rust 1.91 doctests, native worker,
strict library/test/example Clippy, Rust 1.91 native/Wasm compilation, the
production-declaration checker and its refusal fixtures, both package inventories,
real Make formatting, documentation links and snapshot integrity. The selected
release/Make adapter fixture passes using command stubs with no Git/registry effects.
No full workspace suite, native macOS or installed canister evidence is claimed.

The next product slice is the Logging storage/adoption boundary, not publication
of the initial heap engine. The prior standalone bootstrap remains preserved at
`/tmp/ic-logging-bootstrap.aOgJT4/ic-logging` as historical preparation evidence.
