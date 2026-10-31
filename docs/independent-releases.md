# Independent Metrics and Logging releases

The two libraries remain in one development workspace and share the catalog,
lockfile, compiler policy and complete release validation. They have no dependency
on one another. [The declared policy](../ci/cargo-release-groups.json) and root
Cargo.toml comments identify every member:

| Group | Members | Version owner | Canonical ledger |
| --- | --- | --- | --- |
| metrics (default) | ic-metrics | workspace.package.version | [root changelog](../CHANGELOG.md) |
| logging | ic-logging | literal package.version | [Logging changelog](../crates/ic-logging/CHANGELOG.md) |

Both groups start at the existing 0.23.0 numeric version. Converting Logging's
inheritance to that literal value is not a version bump or a new publication.
Earlier coordinated releases remain once in the root ledger, through 0.23.0;
the Logging ledger links to that history. Existing tags and receipts are retained.
There are no private workspace members or internal dependency requirements today.
The policy's empty dependency lists explicitly reflect that fact.

## Maintainer commands

Prepare tools explicitly with `make install-tools` after adopting this snapshot.
The managed release editor is published IC Build 0.73.0 with its cli feature.
Validation never installs tools except the standard release preflight's selected
preparation lane; checks admit the already prepared selection.

```sh
make release-version                         # Metrics current version
make release-version RELEASE_GROUP=logging   # Logging current version
make release-files RELEASE_GROUP=logging     # NUL-delimited exact file plan
make release-patch                           # Metrics release
make release-patch RELEASE_GROUP=logging
make release-resume RELEASE_GROUP=logging VERSION=X.Y.Z
make publish-check RELEASE_GROUP=logging
make publish RELEASE_GROUP=logging
```

Release and publication remain separate maintainer actions. Publication defaults
to the selected group's public package. A PACKAGE override must belong to that
group; cross-group selections refuse before lint or Cargo publication. No group
change republishes an existing package version. Select a new numbered candidate
through the maintainer release flow when publishing changed package metadata.

Every group still runs the complete `ci` and `msrv` release gates. Metrics remains
arithmetic-only without defaults, optionally adds native-wire and recording, and
excludes native metadata on Wasm. Logging remains dependency-free. Group selection
does not narrow these obligations or establish native/IC runtime acceptance.

## Plans, transactions and recovery

The existing shared runner and group-capable editor own metadata rendering,
selected-package lock updates, staging, commits, tags, push and resume. The local
adapter supplies group policy, existing tool preparation, full validation and
source/receipt admission. There is no second release implementation.

Plans always include Cargo.toml and Cargo.lock. Metrics additionally selects its
root ledger; Logging selects its literal-version manifest and ledger. An unchanged
root manifest is still admitted for Logging but need not appear in the committed
diff. Other groups' versions, manifests, requirements and pending notes must be
preserved. Future shared consumer metadata needs an explicit shared_metadata_files
declaration plus selective rendering/qualification; none is needed for this split.

New tags are metrics-vX.Y.Z and logging-vX.Y.Z; subjects are Release metrics X.Y.Z
and Release logging X.Y.Z. The shared runner journals GROUP-X.Y.Z.plan under Git's
release-state directory, with selected files alongside it. The adapter keeps its
validated/prepared receipts in GROUP-X.Y.Z/ and binds source, destination, group,
policy blob and prepared bytes. One repository-wide lock protects the shared lock.
Renderer failure restores original selected files; wrong-group or altered
receipts cannot resume. Older receipts remain archived rather than overwritten.

Pre-group vX.Y.Z tags and old journals keep their original meaning. They are not
silently converted into group plans. Exact old-attempt recovery belongs to its
recorded source/adapter, rather than importing it into a different group.

Independent releases do not make incompatible integration stacks compatible.
Public Wire identity changes still require matching native consumers; persistence
adapters retain their own integration/release owners. Arithmetic, Serde fields,
encoded bytes and Logging's retained-data contract do not change in this split.

## Focused qualification

`make release-tools-check` exercises the actual adapter, shared runner/editor and
local Git remotes in disposable repositories. It checks both group directions,
unrelated versions/requirements/ledgers, exact changed files, rollback, receipts,
resume and publication selection. Setup, broad gates, archive compilation and
registry effects are substituted. Unchanged-group consumers use workspace-owned
source copies pinned to their prior compatible identities; this is source-level
consumer evidence, not publication of the simulated releases. Successful group
receipts and all failures remain retained at the printed evidence directory.
Other standard Make, hook and retention fixtures keep their distinct scopes.
