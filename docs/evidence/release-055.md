# Published 0.5.5 verification

Annotated tag `v0.5.5`, public main, package/workspace versions and embedded registry
Git identity agree on `b995f787c8e08a6e2e8c18d99e223835f43f6e4e`. The official
non-yanked registry row declares Rust 1.85.0 with no dependencies or features.
Downloaded package SHA-256 is
`a0d23b0f329106abb2edd7c43891dde085bfc92c51ccdaf5ab3fffba05f53d0b`.
All seven Rust files, the application guide, original manifest, root README and
license match released source. The packaged lock contains only Metrics 0.5.5;
arithmetic is unchanged from 0.5.4.

The release delivers [Shared Tooling 0.3.7 and owned assertion repairs](adoption-055.md).
Its actual private inspector lock selects [IC Host 0.12.7](host-dependencies-0127.md),
although finalized notes name the earlier prepared 0.12.6 selection. This record
clarifies the released graph without rewriting the published ledger or relabelling
earlier local qualification.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38066433940)
passes Linux and both package-floor checks. Both macOS jobs remain queued at this
inspection. Downloaded Linux artifact `11675059487` verifies GitHub ZIP SHA-256
`9b92cffdfea998a30afbd27ae641cdc0a2f72c44ec0f5c78642421e3f8fd0962`
and inner archive SHA-256
`4dacf404cd8f1384dd9e3c94bb83bcb4d9e22b426a1e8ce71652ac478cdbc81b`.
All 70 released-source hashes, the exact workflow catalog and all 14 payload
hashes verify. Source, run, attempt, host and released IC pins agree; all seven
recorded outcomes succeed. Logs show actual aggregate/collector, release/admission,
formatting and inspector CLI checks, with two nonempty formatting diagnostics.
Fixture release, Cargo-edit and host effects remain substitutes; this establishes
no live release execution or IC instruction/cycle measurement.

[#54](https://github.com/dragginzgame/ic-metrics/issues/54) and
[#55](https://github.com/dragginzgame/ic-metrics/issues/55) retain complete native
acceptance. Official registry responses, downloads, extracted Linux receipts and
independent verification results remain under `target/evidence/review-055/`.
This release review changes no graph, sibling source, workflow run or release.

## Apple Silicon acceptance

The same released-source run now passes Apple Silicon as well as Linux and both
package-floor checks; Intel remains running at this supplemental inspection.
New Apple artifact `11675714124` verifies ZIP SHA-256
`0efa74a441bb10909c931d922046bf7ea0c05cc0d28964da09add62bb89853f8`
and inner archive SHA-256
`9c3acc2e4a47ccdf4958c9b11a1dec2a006c361250dfbc84e096d21c642c762d`.
All 70 released-source and 14 payload hashes, exact workflow catalog,
source/run/attempt/host/pins and seven successful outcomes verify. Logs establish
actual aggregate/collector, release/admission, formatting and inspector CLI
execution; two nonempty formatting diagnostics are retained. Linux's receipt is
independently reverified alongside it. Raw observations, artifacts and results
remain under `target/evidence/review-056/`.

#54/#55 remain open for Intel and complete native acceptance. This supplements
0.5.5's original queued observation without qualifying pending 0.5.6 or supplying
IC performance evidence.
