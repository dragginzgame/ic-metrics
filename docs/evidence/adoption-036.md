# Shared Tooling 0.2.9 adoption

Pending compatible Metrics 0.3.6 adopts committed Shared Tooling
`f8a70ba348e9975a6eb5b337860b00bc8a0b36d1` through its canonical exporter from
a clean detached clone with the canonical HTTPS remote. The existing 92-file
selection is unchanged. Four selected files change: the exporter, verifier,
snapshot guide and supported-host guide. No fleet report, dashboard or upstream
workflow is imported.

The exporter records source version `0.2.9` from the immutable committed `VERSION`
as an optional v1 manifest annotation, alongside the exact revision and file
digests. The verifier rejects malformed or duplicate annotations and reports the
recorded identity. This is descriptive tooling metadata, not a Metrics version
selection or evidence of a source release/publication. Older snapshots without
the annotation remain explicit. Canonical source revision remains authoritative.

The supported-host guide documents authenticated current-run artifact readback
in Shared's own workflow ([Shared #93](https://github.com/dragginzgame/shared-tooling/issues/93)).
Metrics' separate native collector and receipt contract are unchanged; no consumer
workflow mutation or additional tooling suite is needed. Public repository purpose
remains reusable IC measurement primitives.

Focused Linux checks pass under Bash 5 and genuine Bash 3.2.57:

- Exact-owner distribution regression, including committed version versus mutable
  source bytes, malformed/duplicate metadata, source/configuration preservation
  and refusal cases.
- Actual consumer release/publication adapter and release-admission checks with
  their declared substitutions; the latter retains real scratch Git/offline-fetch
  behavior and selected-commit metadata/logger checks.
- Final snapshot/pin/prepared-tool verification, selected ShellCheck,
  documentation links, diff checks and preservation hashes.

The execution include and probe are byte-identical to Shared 0.2.8.
[Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30)'s
command-line-hidden Make-mode failure remains unresolved; earlier passing mode
checks do not establish full admission. The existing
[consumer reproduction](adoption-035.md#subsequent-qualification-limit) is not
relabeled as corrected. No vendored guard or consumer flag parser is added.
Metrics [#44](https://github.com/dragginzgame/ic-metrics/issues/44) retains that gap.

Product source, Cargo manifest/incoming lock and pins remain unchanged during
adoption. The independently selected Host 0.10.1 graph has
[its own qualification](host-dependencies-0101.md). Logs and preservation hashes
are under `target/evidence/adoption-036/`.
[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37967008620)
passes Linux portable regression and lint/security; both macOS jobs remain queued
at observation. Local Bash 3.2 is not native macOS acceptance.
Package/workspace versions stay 0.3.5. No full local CI/product suite, dependency
resolution, commit, push, release or publication runs.
