# Inspector CLI admission coverage

Pending compatible 0.3.2 adds an actual executable test at the file-read/report
boundary. Source review under the shared code-hygiene method found that existing
argument/report unit tests did not execute this composition. No production defect
was established. The test uses the real binary, filesystem and locked Host 0.9.2
libraries, without command substitutions or additional dependencies.

A minimal raw Wasm at a path containing spaces succeeds at its exact byte limit
and zero section/export/custom-section budgets, publishing the matching SHA-256
and structural row with empty stderr. A too-small byte limit, malformed content,
missing file and directory each return status 1, diagnostics and empty stdout.
The accepted/malformed input bytes remain intact and the missing path stays absent.
Invocation-owned fixture directories stay under `target/evidence/wasm-inspect-cli/`
on success or failure. Their clock-derived names supply uniqueness, not timing or
IC performance evidence.

`make wasm-inspect-check` selects the existing argument/report unit tests on the
binary target and the named CLI integration test explicitly. Configured native CI
already calls that gate, and its existing source capture includes the new test
through the package directory. Release fixtures export the committed `crates/`
tree, so no separate source catalog or workflow is introduced. Arithmetic APIs,
inspector output/admission contracts and production Rust source are unchanged;
no consumer attribution or sibling changes are needed.

Linux execution uses source HEAD `2383dc0d684800b1610e3eb727449b0a87d562bb` plus
the pending worktree, reviewed Shared Tooling
`ac4549c5ebde497f7db0da5d05d32835112e51de` and the existing 0.9.2 lock.
After `make fmt`, all-target checks and warning-denied Clippy pass on Rust 1.99.0.
The two argument tests, three report tests and named CLI test execute and pass.
`make wasm-inspect-msrv` checks actual Rust/Cargo 1.88.0, and the same named CLI
test also executes successfully with that compiler. The first Clippy attempt
rejected empty-vector assertions; its log remains retained, and the assertions
were corrected before subsequent checks. Documentation links and whitespace
checks pass. Logs and preserved/checked input hashes are under
`target/evidence/inspector-cli-032/`.

The core, manifests and incoming lock selection remain byte-identical during
this coverage change. Package/workspace versions stay 0.3.1. No symbols are
removed, and no runtime-cost improvement, completed native macOS result, full
local CI, dependency resolution, commit, push, release or publication is claimed.
