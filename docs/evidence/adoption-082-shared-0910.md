# Shared Tooling 0.9.10 adoption for pending 0.8.2

Canonical refresh adopts reviewed committed/public
`7e55adecf6f0b196c050f104b37f8c69b6bf434e` from a clean isolated detached
checkout. Initial review selected 0.9.9; the public-main read then discovered
committed 0.9.10 and its reporting rules. Both intermediate refresh records are
retained. Compared with the incoming 0.9.6 snapshot, 11 payloads change and two
are added: the derived Cargo cache-key fixture companion and an explicit root
for the new reporting guide. All 104 payloads and 91 roots verify; none retires.

The Cargo tool-build policy rejects non-boolean TOML `net.offline` before setup
or admission, preserving explicit environment overrides and Cargo configuration
precedence. Explicit `make install-rust-tools` selects the new policy generation;
the previous common set and builds remain retained. Complete offline
`make tools-check` passes. Checks do not install or repair tools. Versions and
pins stay fixed; setup can reuse already admitted matching shared generations.

The changed Rust-tool fixture passes substitute compiler/Cargo, cache identity,
configuration rejection, receipt, retained-generation reuse and actual staged
hook checks. It uses an isolated compiler context and existing read-only source
objects, with forbidden Git effects recorded even in expected-failure cases.
The isolated upstream PR fixture passes complete JSON repository-identity
admission and recovery, using synthetic Git histories and a GitHub command
substitute. Selected scripts pass ShellCheck. Neither fixture performs Metrics
Git or live GitHub release effects.

The new reporting guide distinguishes semantic symbol changes from physical
Rust/type/documentation line churn. It changes maintainer reports only. The
upstream native cache workflow and portable-suite timing wrapper remain at
their owner; Metrics keeps its existing complete setup/check/native workflow.
The cache-key helper here is a required companion of the selected fixture,
not a new consumer cache admission owner.

This compatible tooling slice extends pending 0.8.2. The incoming counter,
Host 0.15.1/Memory 0.35.19 graph, all product Rust and pin bytes retain their
pre-adoption hashes. Package metadata stays 0.8.1, core remains dependency-free
and `no_std` on Rust 1.85, and stable/inspector floors remain 1.88. No sibling
file, real Git index/ref, package version or release/publication effect occurs.
The earlier [counter receipt](counter-082.md) and
[released native acceptance](release-081.md) retain their own source scope.

Full `make ci` passes in 264 seconds, including all 52 arithmetic tests and eight
doctests. All three package-floor gates pass: arithmetic Rust 1.85 native/Wasm,
stable Rust 1.88 native/Wasm and private inspector Rust 1.88 native. Eight gate
checkpoints match the 140 frozen/current inputs. Original index and HEAD remain
exact. This is local Linux qualification; there is no current macOS acceptance,
new consumer qualification or IC performance claim.

The [frozen receipt](adoption-082-shared-0910.tar.gz) and
[checksum](adoption-082-shared-0910.tar.gz.sha256) retain both source selections,
refresh records, focused/full logs, tool receipts/identities, frozen validation
inputs and checkpoint verification. Fresh readback verifies source and retained
payload hashes. An inline input-collection assertion initially used the wrong
manifest field order; it was corrected before any delivery gate, with no product
source effect. The correction record remains retained; all delivery gates pass.
