# Metrics-owned Cargo jobserver repair for pending 0.5.1

Reviewed released base is Metrics 0.5.0
`01549632c0c3fa6e1ff315ce4de803ddfae904ad`, with the previous release-verification
documentation preserved. Actual Linux GNU Make 4.3 `make -j4 check` returns 0 but
Cargo warns that advertised jobserver descriptor 3 is closed. The root recipe
does not preserve Make's inherited pipe descriptors. The new actual-Make
descriptor regression also fails before the fix, retaining its failed fixture.
Owner: [Metrics #48](https://github.com/dragginzgame/ic-metrics/issues/48).

Recursive recipe marking now preserves those descriptors in every Metrics-owned
direct Cargo recipe and the metadata Bash entries that dispatch Cargo. This
includes build/test/lint/docs, both floors, publication and release preparation/
checks. The existing selected parse-time Make admission still refuses ignore-
errors, dry-run, touch and question modes before dispatch, including hidden flag
assignments. Command arguments, toolchain/package selection, failure propagation,
version ownership and release/publication authority are unchanged.

The expanded standard-release fixture invokes the real consumer Makefile with
substituted Cargo, rustc and metadata effects. A portable Perl descriptor probe
checks both inherited pipe descriptors, accepting the GNU Make 4.3 and 3.81 flag
spellings. It covers every owned direct Cargo/metadata boundary, refusal before
effect under unsafe modes, serial publication routing and first-command failure
before the next lint command. The current and genuine GNU Make 3.81/Bash 3.2
profiles pass, as does selected ShellCheck. The fixture does not publish, prepare
release metadata, compile product code or establish native macOS execution.

Actual parallel locked `check`, arithmetic Rust 1.85 host/Wasm and inspector
Rust 1.88 all-target checks pass without jobserver warnings. Complete validation
passes through the shared logger: `ci` (196 seconds), `msrv` and
`wasm-inspect-msrv`. It includes warning-denied Clippy, unit/doctests, actual
CLI, tool setup/admission, formatting/hooks, evidence and release fixtures.
All 81 frozen code/graph/pin/workflow inputs remain unchanged through that gate.
Results are recorded under `target/evidence/issues-051/`.
After that gate, an incoming Host 0.12.1 lock selection is preserved and
[qualified separately](host-dependencies-0121.md). The original gate remains
bound to Host 0.12.0; its successful initial input check and later mismatch are
retained separately. All other frozen inputs remain unchanged.
The updated Host 0.12.1 graph passes its own full `ci` (193 seconds) and both
floors, preserving its separate 81-file input record. Actual parallel inspector
floor compilation passes without jobserver warnings on that graph too.
Delivery/native acceptance remains in #48;
earlier 0.5.0 results do not qualify this changed Makefile/fixture. The source
receipt catalog already includes both changed owners and requires no new entry.
The separate canonical formatting/installer repair stays in
[Shared #99](https://github.com/dragginzgame/shared-tooling/issues/99); snapshot-
owned files remain intact. No sibling changes or measurement/consumer arithmetic
changes are needed.

This compatible developer-tooling repair selects sole pending changelog 0.5.1.
Package/workspace versions stay 0.5.0. The jobserver repair itself preserves Cargo
selection, pins, arithmetic source, reports and prior receipt identities. No API
removal, data reset, dependency resolution, tool installation, commit, push, release, publication or
workflow dispatch is performed.
