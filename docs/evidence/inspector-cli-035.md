# Inspector CLI budget and output coverage

Pending compatible 0.3.5 extends the existing named CLI integration test through
the actual binary and filesystem. This repairs a qualification gap, not an observed
production arithmetic or inspector defect. Existing argument/report tests did not
prove all four budgets' propagation through the executable or its output-failure
exit behavior. No new dependencies, API, output schema or production Rust changes.

The minimal eight-byte input still succeeds with zero collection bounds. A second
41-byte module has five sections, two exports and one custom section, so accepted
nonzero budget values are distinct. Its exact-limit invocation publishes the
matching digest and structural row. Reducing each bound separately refuses with
status 1, diagnostics and empty stdout. Missing, negative, overflowing, malformed
and surplus arguments are tested against an existing valid input, preventing a
file-read failure from masquerading as successful argument admission coverage.

An anonymous pipe has its reader closed before the child launches. Writing the
report then returns failure with status 1 and diagnostics. No consumer process,
sleep or race is needed; this uses the standard library's
[pipe API](https://doc.rust-lang.org/std/io/fn.pipe.html), available below the
private package's Rust 1.88 floor. Accepted, malformed and structured input bytes
remain intact; a missing input is not created. Invocation-owned inputs remain
under `target/evidence/wasm-inspect-cli/` on success or failure.

Linux execution binds source HEAD
`5a5f1dab1f7ee3e1e5624c9d889148c39abf45f2` plus the pending test change, recorded
source/manifest/lock hashes and selected Host 0.9.7. The lock advanced independently
from the previously qualified 0.9.6 selection before these checks; it is preserved.
The cached 0.9.7 archives' official registry checksums and packaged-source identities
were already established in [the Host review](host-dependencies-096.md), and both
consumed libraries are unchanged from 0.9.5. This execution now qualifies the selected
0.9.7 graph, separately from that earlier unselected source review.

After `make fmt`, warning-denied all-target inspector Clippy passes. The expanded
named CLI test passes on the development toolchain and actual Rust 1.88; the two
argument tests, three report tests and Rust 1.88 all-target compilation also pass.
Manifest/lock and IC-pin hashes remain unchanged. Configured native CI already
runs the named CLI gate and captures its source; no workflow/catalog change is
needed. Documentation links and diff checks pass.

Two initial attempts are retained: Clippy rejected a constant declared after
statements; the first output fixture incorrectly expected a read-only stdout
descriptor to fail. Rust's
[standard stdout implementation](https://doc.rust-lang.org/src/std/io/stdio.rs.html)
treats a bad descriptor as successful output, so that fixture supplied no usable
failure proof. The corrected closed-pipe fixture passes; the unsuccessful test
log remains separate. This finding does not justify a custom stdout implementation.

Logs, hashes and toolchain/source identities are under
`target/evidence/inspector-cli-035/`. No function, method or type is removed.
The arithmetic library remains dependency-free and unchanged. No sibling edits,
native macOS qualification, IC performance result, full local CI/product suite,
dependency resolution, version bump, commit, push or release runs.
