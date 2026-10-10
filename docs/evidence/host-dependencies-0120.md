# Incoming IC Host 0.12.0 selection review

After pending 0.5.0's complete Shared Tooling gate passed on Host 0.11, an incoming
manifest/lock edit selected private `ic-host-artifacts` and `ic-host-fs` 0.12.0.
The edit is preserved; this review performs no resolver or dependency selection.
Metrics package/workspace versions remain 0.4.0. The earlier gate and preservation
checks keep their original 0.11 graph identity; the final checksum mismatch is
retained under `target/evidence/adoption-050/`.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock/cached archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `d27c6b9ecc60250e8e5330a4fe1b4e96e7b3c0ff2c90b1c39b1605aa0b73cf14` |
| ic-host-fs | `11a502fe465dce26671a981c58caa11df1d5d6aae4ff4ccf443a0ce73c76cde7` |

Embedded Git identities and all packaged Rust/original manifest files match
released Host `1ba4591868a83b367d56bae9e3c213418c66a192`, also matching public
main at inspection: 20 files for artifacts and 19 for fs. All artifact/fs Rust
source is unchanged from 0.11.0. Host's 0.12 hard cut adopts the same complete
Shared toolset; it removes no consumed read/inspection API and requires no
inspector wrapper, report, arithmetic or consumer-state change. The private
graph selects no process/runtime dependency.

Focused locked Linux qualification passes all-target inspector check,
warning-denied Clippy, both named argument tests, all three named report tests,
the actual CLI admission/budget/publication case and Rust 1.88 all-target
compilation. Complete updated-graph validation passes through the shared logger:
`ci` (169 seconds), arithmetic Rust 1.85 host/Wasm and inspector Rust 1.88
all-target checks. All 88 frozen delivery inputs remain unchanged through that
gate. The actual consumer native collector and release-admission fixtures also
pass on GNU Make 3.81/Bash 3.2 with this graph; installation/release effects remain
substituted in those fixtures. Inputs, official rows, package/source verification,
frozen delivery inputs and check logs are
under `target/evidence/host-0120/`. Native macOS acceptance remains separate;
no IC instruction, cycle or Wasm-size gain is claimed. No sibling edits, resolver,
package-version change, commit, push, release, publication or workflow dispatch
is performed.
