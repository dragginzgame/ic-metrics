# Published 0.2.6 observation

On 2026-10-07, tag `v0.2.6`, local HEAD and remote main identify
`df8fd43b95673360bcc6740624c8c361745f58d1`. The official registry index
reports non-yanked ic-metrics 0.2.6, no dependencies or features and Rust 1.88.
The downloaded archive has SHA-256
`9ac61152c3645ba0cad34331301db14ca096ced6ace6fc7d2cbbd4f4fe511f63`.
Its embedded Git revision and `crates/ic-metrics` path match the release; all
five Rust source files, application guide, original manifest, README, license
and lock match the tagged source. This is publication evidence, not deployment.

The observation inputs, archive and extracted payload remain in
`target/evidence/release-026/`. Original focused arithmetic and actual IC
histogram evidence retain their own source bindings in
[arithmetic-026.md](arithmetic-026.md) and
[histogram-cost-026.md](histogram-cost-026.md).

## Exact-source CI

[Run 37598415861](https://github.com/dragginzgame/ic-metrics/actions/runs/37598415861)
selects the release commit. At inspection, MSRV passes; Linux native CI fails
in `scripts/ci/test-cloc.sh` before native Rust gates, while Intel and ARM
macOS jobs remain queued. Native input capture, complete pinned host setup,
IC setup and failure artifact upload succeed. Failure is not a Rust arithmetic
result. The Linux job is
[112716547139](https://github.com/dragginzgame/ic-metrics/actions/runs/37598415861/job/112716547139).

CI places fixture TMPDIR beneath the Git checkout for retained scratch evidence.
The LOC fixture invokes the reporter without a manifest, so Git root discovery
selects ic-metrics instead of its synthetic alpha/beta workspace. The alpha row
is absent and the fixture assertion fails. A focused trace reproduces it in
`target/evidence/release-026/cloc-in-checkout.log`; the failed scratch and outputs
remain under that directory. This is separate from inherited target-directory
selection ([Shared Tooling #47](https://github.com/dragginzgame/shared-tooling/issues/47)).

[Shared Tooling #48](https://github.com/dragginzgame/shared-tooling/issues/48)
owns the fixture-manifest correction. Publication and previous Linux focused
checks do not close the owning native qualification issues. The subsequent
[adoption record](adoption-027.md) binds the prepared repair and distribution boundary.
