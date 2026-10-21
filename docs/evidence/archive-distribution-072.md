# Public evidence distribution repair

[Metrics #72](https://github.com/dragginzgame/ic-metrics/issues/72) owns this repair.
The reviewed checkout is released 0.9.0
`fe4d14f2a24138794878a17a354885a1e7222487` plus incoming Shared Tooling 0.10
adoption. That work is preserved. The repair changes evidence distribution and
its current links; it changes no arithmetic, stable bytes, dependencies or tools.

## Reviewed boundary

GitHub identifies Metrics and the five public extraction consumers as public,
and Toko Miner as private. Read-only access to the private owner does not establish
permission to redistribute its source or issue contents. No explicit source-export
intent is established by this review; private payloads are omitted by default.
The maintainer has approved public tracking of the finding, without private source
or issue-body disclosure.

All 36 current top-level evidence archives and their ten nested archives receive
member-path and payload inspection. Four receipts contain private consumer source;
one further receipt contains private checkout observations, and another contains
consumer feedback. The affected private payloads include source, manifests/lock,
search excerpts, issue reads and feedback. Mixed review records require inspection
even when their filenames contain no private repository name. No private source or
issue body is reproduced in this report or the public provenance ledger.

## Current distribution

| Original receipt stem | Public archive and checksum | Omitted files | Projected files | Byte-identical files |
| --- | --- | ---: | ---: | ---: |
| `consumer-review-082` | [Archive](consumer-review-082.public.tar.gz), [checksum](consumer-review-082.public.tar.gz.sha256) | 12 | 1 | 45 |
| `counter-082` | [Archive](counter-082.public.tar.gz), [checksum](counter-082.public.tar.gz.sha256) | 1 | 1 | 175 |
| `error-cut-090` | [Archive](error-cut-090.public.tar.gz), [checksum](error-cut-090.public.tar.gz.sha256) | 13 | 1 | 431 |
| `memory-083` | [Archive](memory-083.public.tar.gz), [checksum](memory-083.public.tar.gz.sha256) | 2 | 1 | 202 |
| `release-080` | [Archive](release-080.public.tar.gz), [checksum](release-080.public.tar.gz.sha256) | 1 | 1 | 31 |
| `summary-restoration-081` | [Archive](summary-restoration-081.public.tar.gz), [checksum](summary-restoration-081.public.tar.gz.sha256) | 3 | 2 | 196 |

The [identity ledger](archive-distribution-072.json) records original/replacement
SHA-256 values, original Git blobs, first-addition commits and containing tags.
Each public archive has a `distribution-provenance.json` with per-file hashes,
original identities, unchanged payloads and the separately named public JSON
projections. Private repository subtrees and private issue/search/feedback files
are omitted. Mixed consumer records retain the five public rows unchanged;
Memory's file inventory drops only the omitted private checkout rows.

The 1,080 unchanged files retain the earlier source, validation, compiler,
measurement and failed-experiment bytes. Seven projected JSON records and six new
provenance records have their own identities. Original inventories/checkpoints
retain their historical scope; intentional omissions do not make the public
archive a complete original payload. This repair performs no new compilation,
IC experiment, consumer execution or performance comparison. Earlier results
remain qualified only for their original sources and graphs.

All six exact original archives and their exact checksum manifests are retained
under ignored `.private-evidence/archive-review-072/originals/`, with owner-only
permissions, outside `target/`. Their hashes and readback agree before retirement
from `docs/evidence`. This retention survives Cargo clean; it is a local custody
copy, not an external backup. The private review also retains the incoming tree,
selected repair inputs and verification results. No original archive is silently
rewritten under its previous name.

## Published history and remaining authority

The GitHub recursive tree at the reviewed public main/peeled v0.9.0 commit contains
all six original archive blobs; their blob IDs agree with the local originals.
The public tagged source history containing them is:

- v0.8.1–v0.9.0: summary restoration and 0.8.0 publication feedback.
- v0.8.2–v0.9.0: consumer review and scalar counter.
- v0.8.3–v0.9.0: Memory adoption checkout observations.
- v0.9.0: error-cut source/search/issue observations.

The public Releases API lists no release objects/assets at review. The published
Cargo package roots are under `crates/`; these root-level evidence archives are
outside their payloads. This does not establish removal from existing clones,
downloaded tagged source archives, caches or independent copies.

The pending local changes remove originals from the current distribution only.
No commit, tag, push, release, history rewrite or remote deletion is performed.
#72 remains open for the source-owner export decision and exact remote/history
retention or removal disposition. Changing published history/tags requires its
own explicit authorization and must preserve privately held originals and their
source-bound evidence. Committing this repair cannot remove older Git blobs.

## Verification

All 36 current archive checksum manifests pass the existing read-only verifier.
Recursive readback checks 5,013 regular payloads across the 36 archives and ten
nested archives, including safe member paths, regular-file types and duplicate
refusal. The six replacements match all 1,080 retained original payloads and
the exact intended public JSON projections; their private original copies retain
the six archive/checksum identities. No private repository member path, any of
the 36 selected long private-source fragments, or the four known private-only
issue bodies remains in raw or decoded JSON payloads.

One identical generic publication comment was independently verified on
[its public Canic owner](https://github.com/dragginzgame/canic/issues/523#issuecomment-6127841852)
before classifying it as public feedback. Filename-only filtering would miss
private rows, while treating every common comment as private would misclassify
that already-public text. These checks inspect the recorded inputs; they do not
prove an arbitrary future archive safe. Documentation links, snapshot integrity
and diff checks pass. Maintained Rust, manifests/lock, tool selections, incoming
adoption files, real index and Git refs remain unchanged by this repair.

## Future public receipts

Select own/public payloads explicitly when freezing evidence. Keep private source,
search output, issue reads, checkout observations and mixed private rows in ignored
private evidence; do not archive a whole sibling-review directory by default.
Inspect names, nested archives and decoded text/JSON for private content before
public distribution. A repository link or digest is not source-export authority,
and a filename filter alone cannot qualify a mixed review record. Preserve each
original identity when producing a sanitized distribution; never relabel old
measurements or make new consumer/performance acceptance claims from omissions.

## Approved published-history cleanup — 2026-10-21

The sections above retain the original distribution review and its historical
observations. The maintainer has now approved the archive-only history removal.
The rewrite includes the subsequently released 0.15.2 and removes only the six
recorded original archive paths and their paired checksums. One scoped atomic
push replaced eight branch and 44 tag refs, using exact old-ID leases after a
fresh remote comparison. Current source, sanitized receipts, Cargo package
versions and separately published registry artifacts are unchanged.

A fresh remote clone verifies the complete 109-ref head/tag roster, absence of
the twelve withdrawn paths from those histories and unreachability of the six
original archive blobs. Current main's source tree is byte-identical to the
pre-rewrite 0.15.2 release. This local checkout's branch/tags have been synchronized
without changing its working files or index. Verified private original-history
backups and before/after mappings remain retained separately; the frozen identity
ledger and historical measurement identities are unchanged.

The rewrite does not complete remote erasure: seven closed PRs retain the original
blobs through GitHub's read-only PR refs. No forks were returned by the public
forks API at inspection. Neither observation accounts for cached views, downloaded
archives or independent clones. A GitHub Support request is prepared but has not
been submitted. Support must assess eligibility and the remaining server-side
disposition under its [sensitive-data removal policy](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository#fully-removing-the-data-from-github).
The maintainer subsequently closed #72 as not planned and elected not to pursue
the remaining GitHub-held ref/cache cleanup. The Support draft was not submitted;
no complete erasure is claimed.

Other existing clones must adopt the rewritten history. Prefer a fresh clone;
preserve unrelated work privately and reapply only reviewed changes. Do not merge
or push old ancestry, which would restore the withdrawn history. Retained release
plans and historical CI receipts keep their original identities and must not be
silently rewritten or reused as validation of changed inputs.

After verifying their work was delivered or intentionally retired, the maintainer
also approved deleting the seven obsolete contribution branches. One atomic push
with exact old-ID leases removed only those branches; main and all 101 release
tags are unchanged. Their tips are retained in a verified private bundle, and
stale local remote-tracking refs are pruned. Closed PR records and GitHub's
read-only PR refs remain; branch deletion does not complete the Support cleanup.
