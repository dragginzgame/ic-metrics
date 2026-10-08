# Shared Tooling 0.1.20 contribution adoption

The clean detached `/tmp/ic-metrics-shared-020-reviewed` selects committed
Shared Tooling `3ecc48e579f6cf6e6ab01a6645d8a250fc8c6934`, with canonical
HTTPS origin. Review covers the adopted diff from 0.1.19. The upstream's matching
[CI run 37641211708](https://github.com/dragginzgame/shared-tooling/actions/runs/37641211708)
passes Linux, macOS Intel, macOS Apple Silicon and lint/security. Its frontend
and hosted failure-retention checks remain upstream-owned qualification.
Uncommitted upstream PR-gated release work is excluded.

Canonical distribution refreshes 69 files, explicitly adding
`rules/contributions.md`. The baseline and linked maintenance, changelog,
release, reviewable-change and hook guidance refresh together. All previously
adopted executable tools and consumer pins retain their bytes. The local
AGENTS.md removes its blanket commit/push prohibition and follows the common
authorization boundary; README exposes that rule to human contributors.
No CLAUDE.md or other active local overlay needs reconciliation.

Instruction review for [#24](https://github.com/dragginzgame/ic-metrics/issues/24):

| Request | Effective interpretation |
| --- | --- |
| Fix or continue | Scoped local edits and focused checks; no unsolicited Git writes. |
| Open/update a PR | Topic branch, scoped commits, intended branch push and PR delivery; preserve unrelated work, protections and required checks. |
| Merge or direct integration-branch push | Requires that specifically requested effect; a PR request alone does not supply it. |
| Run a selected standard release | Its explicitly authorized repository/destination includes documented gate, metadata, commit, tag and atomic push; publication/deployment remain separate. |

Human contributors use normal repository/fork permissions and reviews. This
adoption is an instruction review, not actual PR, merge or release execution.
Pending 0.2.10 is compatible from finalized 0.2.9: contribution workflow changes
without an arithmetic API, numeric, storage, endpoint or dependency change.
Package/workspace versions and locks remain 0.2.9.

`make check-doc-links check-pins shared-tooling-check fmt-check` and
`git diff --check` pass. Logs, refresh receipts, release observations and public
artifact verification remain under `target/evidence/review-030/`. No Rust edit,
native build, broad local gate, dependency upgrade, sibling mutation, commit,
push or release command runs for this documentation adoption. Historical
adoption/measurement records remain unchanged.
