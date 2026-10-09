# Published 0.3.2 verification

Released source `f903c664c395c47485dbedc0f1919c97b9ce72d0` matches public main,
annotated tag `v0.3.2` (object `9ed83c37bce73fc0fea832ba8542d03dc71528e3`)
and workspace/package versions. The official registry reports a non-yanked
package with no dependencies/features and Rust 1.85.0. Its archive verifies
SHA-256 `9c02088befd3a964640ed81463022876ed6c03ce8c29fd78a9115c77abf15941`.
Embedded Git identity, seven Rust files, application guide, original manifest,
root README and license match the release commit. The packaged lock contains
only Metrics 0.3.2; arithmetic source is unchanged from published 0.3.1.

[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37936205456)
passes Linux native and both package floors. Intel and Apple Silicon jobs remain
queued at review. Downloaded Linux artifact `11618791952` verifies GitHub ZIP
digest `4ed79e0888ee2e479f5e0890b5c68fd834420c1086fdc25f26129c63a9121b9e`
and inner archive digest
`32317d75e5e2e7070e2a7ac10579a5a05f53369110afbdb904f7edc85f0c3fda`.
All 14 payload and 66 selected-source hashes verify, with exact release source/
run/attempt 1/push/Linux/x86_64 identity, nine successful setup/native outcomes
and released IC pins. Every completed job step succeeds. The native log confirms
the new actual CLI admission/publication test executes and passes, alongside IC
installer and release-admission fixtures with their declared substitutions.
The private graph selects the independently qualified Host 0.9.2.

API inputs, registry archive and verified payloads remain under
`target/evidence/release-032/`. This records released-source Linux acceptance,
not native macOS completion or IC cost measurements. Historical preparation and
earlier release evidence retain their own source/graph identities. No new
implementation batch, dependency resolution, broad local gate, commit, release
rerun or publication occurs during verification.
