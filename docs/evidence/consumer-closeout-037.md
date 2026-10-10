# Scoped IcyDB adoption acceptance

Read-only review binds IcyDB 0.269.1 to committed public source
`76dc93ead6b66c8db9cb5c402355867dbdf188e3` and
[exact CI 37974259856](https://github.com/dragginzgame/icydb/actions/runs/37974259856).
The workspace declares registry `ic-metrics = "0.3"`; Core inherits it. Its lock
selects Metrics 0.3.5, checksum
`cdab4d805341b0c566f6bf6dea70d35a9b05ccb14319224f8acc5f992905e586`.
Hosted checkout builds therefore do not require a Metrics sibling path.

Source review retains consumer-owned inclusive overlapping spans, maxima,
replication admission and reset identity. Both entity and lifecycle count/total
updates use `ic_metrics::record_sample`. Canonical journal debt remains separate
from the heap diagnostic window and fallible report projection.
[Workspace job 113968402819](https://github.com/dragginzgame/icydb/actions/runs/37974259856/job/113968402819)
passes all ten `metrics::state::tests`, including distinct paths/reset, report
ordering/Candid shape, bounded source selection, failed attempts, lifecycle
saturation/reset and convergence/debt separation. The containing group reports
3281 passed, zero failed and three ignored. The no-default-feature Core lane
also passes, but is not substituted for the metrics-enabled workspace tests.

The original [#298](https://github.com/dragginzgame/icydb/issues/298) registry/
measurement adoption and [#309](https://github.com/dragginzgame/icydb/issues/309)
four-helper native acceptance are complete at this source. Linux
[static job 113968402777](https://github.com/dragginzgame/icydb/actions/runs/37974259856/job/113968402777),
[Apple Silicon job 113968402711](https://github.com/dragginzgame/icydb/actions/runs/37974259856/job/113968402711)
and [Intel job 113968402801](https://github.com/dragginzgame/icydb/actions/runs/37974259856/job/113968402801)
all pass. Downloaded logs show actual consumer adapter, standard-release,
receipt, publication, documentation and Wasm-capture fixture completion.
Publication's network/server-failure cases return 2 with only a lookup event,
without publication. Release/publication effects in these fixtures are substituted;
actual native library/CLI builds also pass. These are source-bound job logs,
not a newly downloaded checksum-qualified consumer receipt archive.

All 85 selected consumer snapshot files independently match recorded digests and
canonical Shared `ce13a5314916891fd239d9b199b4a91b04775054` (0.2.6).
Committed callers delegate release-command admission, generic documentation
links, tri-state registry observations and file digests to the selected owners,
retaining consumer-specific schemas/checks and receipt/publication policy.

The aggregate CI gate and SQL tier-b fail; matching SQL Tier C also fails.
Earlier downloaded tier-b evidence observes PocketIC's clean exit during
compilation before tests. This is not a full product/release pass or IC runtime
measurement evidence. The original helper issue explicitly permits scoped native
qualification without a broad product gate. Newer Make-mode adoption remains in
[IcyDB #311](https://github.com/dragginzgame/icydb/issues/311); unrelated SQL and
later source/graph acceptance retain their owning obligations. Root
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) still requires Canic's
registry/native and held-HTTP interleaving acceptance.

Exact-source exports, CI metadata, downloaded logs and snapshot verification are
under `target/evidence/adoption-037-make/`. A mistaken source-export path was
retained separately and corrected to the actual `scripts/ci/publish-workspace.sh`;
it is not an IcyDB defect. No sibling files were edited, tests/builds executed,
dependencies resolved or release/publication/workflow effects performed here.
