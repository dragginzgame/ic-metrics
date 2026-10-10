# Current handoff

ic-metrics owns allocation-free, dependency-free `no_std` arithmetic. Consumers
own platform reads, attribution, identities, registries, persistence and endpoints.
See [the extraction contract](../extraction.md).

## Pending 0.5.2 setup and fixture repairs

The compatible batch adopts committed Shared Tooling 0.3.2
`c16444bf006f17c5bb4dda5ad070a0f345da9623` through a clean canonical refresh.
The 94-file selection preserves all 93 earlier files and adds the advisory README
review task. Setup admits platform/pins and Rust/Cargo before installation;
authenticated host diagnostics identify the exact tool and repair command.
Shared formatting/setup/check/LOC commands preserve Cargo descriptors and reject
unsafe Make modes. Metrics' native workflow fixture distinguishes both read-only
preflight phases from installation and retains early-refusal logs.

The same Bash 3.2 false-success defect is reproduced in Metrics' own release
cleanup. All six owned fixtures now require explicit completion before accepting
success, preserving prior failure statuses and evidence policy. The existing
regression checks each actual cleanup body with nounset, early-zero and success
cases. Focused modern Bash/Make and genuine Bash 3.2/Make 3.81 checks and selected
ShellCheck pass; actual parallel complete toolset reuse, offline checking,
formatting and LOC reporting pass without jobserver warnings. Complete `ci`
(197 seconds), `msrv` and `wasm-inspect-msrv` pass, preserving all 81 frozen
code/graph/pin/workflow inputs. [The adoption record](../evidence/adoption-052.md) owns the
source/graph identities and retained failure records.

The incoming private Host 0.12.2 lock is preserved and
[qualified separately](../evidence/host-dependencies-0122.md): official registry,
archives and source verify; consumed Rust is unchanged and focused inspector/floor
checks pass. Arithmetic, reports, executable pins and all six consumer policies
remain unchanged. Package/workspace versions stay 0.5.1; sole pending 0.5.2 is
compatible and selects no release. Delivery/native acceptance remains in
[#49](https://github.com/dragginzgame/ic-metrics/issues/49) and
[#50](https://github.com/dragginzgame/ic-metrics/issues/50). Dirty newer Shared
sibling work is excluded; no sibling edit, commit, push or release is performed.

## Released 0.5.1 Cargo jobserver repair

Published 0.5.1 is `a2f8e6e5e3d57f2d9eaff61791230ac1efbbafb8`, matching the
annotated tag, package/workspace versions and official non-yanked dependency-free
registry archive. [Publication and Linux receipt verification](../evidence/release-051.md)
bind the released source, payload/catalog/run/host/pins and successful outcomes.
Linux and both package floors pass; macOS Intel and Apple Silicon remain queued.
[#48](https://github.com/dragginzgame/ic-metrics/issues/48) retains those native
acceptance obligations. The release delivers the
[owned descriptor repair](../evidence/adoption-051-make.md) and separately
[qualified private Host 0.12.1 graph](../evidence/host-dependencies-0121.md).
Earlier preparation records keep their original package versions and graph
identities. Shared #99's canonical correction is adopted in the pending batch
above. #47 still waits for 0.5.0's Intel receipt; #10 waits for Canic's owning
qualification. Neither is closed by a newer local or Linux-only result.

## Released 0.5.0 common toolset

Published 0.5.0 is `01549632c0c3fa6e1ff315ce4de803ddfae904ad`, matching public
main, annotated tag, package/workspace versions and the official non-yanked
registry archive. [Publication verification](../evidence/release-050.md) binds
these identities and unchanged dependency-free arithmetic. The release delivers
Shared Tooling 0.3.0 `88a73139a0f083344c41a6f6f4b5c3a8aca7dc1d` through the clean
93-file canonical refresh. Dirty sibling dashboard/installer edits are excluded.

Remove retired host installer flags `--with-ripgrep` and `--with-cloc`; run
`make install-tools`, then `make tools-check`. Setup/check run all four host,
five IC and three Cargo tools in order, including under parallel Make. Native
CI uses that same aggregate with distinct setup/check logs and a common outcome.
Product extensions use the canonical ordered lists; Metrics has no extra target.
Admitted Rust-only release preparation remains intact. Arithmetic, reports,
platform reads, consumer state/identity and executable pins are unchanged.

[The adoption record](../evidence/adoption-050.md) retains actual complete setup/
reuse and offline admission, full Linux validation, both package-floor checks,
GNU Make 3.81/Bash 3.2 and source preservation. The incoming private Host 0.12
selection is [qualified separately](../evidence/host-dependencies-0120.md), with
unchanged consumed Rust source. The original 176-second full gate remains bound
to Host 0.11; the current Host 0.12 graph passes its own 169-second gate and both
floors. Those preparation records retain package versions 0.4.0; the maintainer's
subsequent release advances them to 0.5.0.

[Exact-source release CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38046372803)
passes Linux and both package floors. The downloaded Linux receipt verifies
ZIP/inner/payload/source/catalog, run/host/pins and seven successful outcomes,
including actual aggregate/collector/release/admission/CLI execution. A later
[Apple Silicon receipt review](../evidence/release-050.md#apple-silicon-acceptance)
verifies that passing host too; Intel remains queued. Delivery is complete;
[#47](https://github.com/dragginzgame/ic-metrics/issues/47) retains only this
source's Intel acceptance, separate from [Shared #98](https://github.com/dragginzgame/shared-tooling/issues/98)
and completed 0.4.0 acceptance. Records: `target/evidence/review-050/` and
`target/evidence/issues-051/`.
No sibling edit, setup, build, graph update, commit, push or release is performed
in that publication review. Subsequent compatible work is collected under the
pending 0.5.2 heading above; finalized 0.5.0 remains unchanged.

## Released 0.4.0 tooling cut

Published 0.4.0 is `97ec991776bb16efbab59faeb43bc72ce9ebcefa`, matching public
main, annotated tag and the official non-yanked dependency-free registry archive.
[Publication verification](../evidence/release-040.md) binds these identities and
unchanged arithmetic. Adopting Shared Tooling 0.2.13
`5864f468d39f8f9d1bd26fca1afe0e20f25f1b5e` removes previously supported
newline-containing operational checkout paths. The maintainer selected this
minor adoption; the provisional compatible 0.3.8 Host entry moves into this same
batch. Supplied/resolved LF/CR snapshot directory paths refuse before a neighbor
is selected. Affected operational directories need explicit renaming; existing
evidence is retained. Arithmetic APIs, consumer state and report output are unchanged.

The clean canonical refresh preserves all 93 selected files. Standard release
preflight prepares pinned Rust tools after source/candidate and locked-cache
admission, then checks offline before validation; standalone preflight never
installs. Preparation refuses changed tool pins. Local validation guidance now
requires the documented complete suite before delivery, with narrower inspection/
documentation checks and separate release authority. Qualification is recorded in
[the adoption evidence](../evidence/adoption-040.md).
The complete Linux suite passes (`ci`, arithmetic MSRV and inspector MSRV), as
do both local Make/Bash profiles, snapshot-path checks and preservation. Source-bound consumer native acceptance is now complete:
[exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38042698441)
passes Linux, Intel macOS, Apple Silicon and both package floors. All three
independently downloaded receipts verify ZIP/inner/payload/source/catalog,
run/host/pins and actual fixture execution in
[the release record](../evidence/release-040.md#complete-native-acceptance).
This completes [#45](https://github.com/dragginzgame/ic-metrics/issues/45) and
[#46](https://github.com/dragginzgame/ic-metrics/issues/46), retaining the earlier
partial observations separately. Upstream 0.2.13 passes its own full native matrix.
This review dispatches no workflow or release.

The batch also preserves the incoming private inspector Host 0.11.0 selection.
[Its review](../evidence/host-dependencies-0110.md) binds non-yanked official index
rows, cached archives, released source and passing locked inspector Clippy,
argument/report/actual CLI tests and Rust 1.88 compilation. Consumed artifact/read
source is unchanged; the Host process hard cut has no caller here. No arithmetic
API, report or consumer contract changes, reset or reinstall are required by
that private dependency update.
Package/workspace versions are now 0.4.0; preparation preserved the incoming
Cargo selection before the maintainer's release.

## Upstream review

Public Shared Tooling main is now committed 0.3.0 `88a7313`; its
[exact-source CI](https://github.com/dragginzgame/shared-tooling/actions/runs/38044218125)
passes Linux, lint/security and Apple Silicon; Intel is running at inspection.
The actual Metrics `make -j4 format-tools-check` probe succeeds but emits two
closed-jobserver-descriptor warnings from Cargo, confirming
[Shared #99](https://github.com/dragginzgame/shared-tooling/issues/99)'s canonical
Make boundary here. Its selected snapshot remains intact. The complete-setup
preflight and exact host diagnostics in
[Shared #101](https://github.com/dragginzgame/shared-tooling/issues/101) are locally
implemented upstream but uncommitted; no consumer adoption is performed.
The released adoption above replaces the earlier
documentation-only 0.2.14 refresh; that source-bound review remains under
`target/evidence/shared-0214/`. The fleet CI inspector/dashboard implementation
stays upstream. Host source advances to released 0.12.1
`e5ecfa06c14d144cfeb85ea89d65906b1bf81636`, with the incoming private selection
reviewed separately above. Shared's latest committed source remains 0.3.0;
Shared's newer installer/documentation work remains dirty and is not adopted. Canic public main remains
`c4c046f947b2b28f4342cbf6efe9221ba1ed5f70`, with
[#447](https://github.com/dragginzgame/canic/issues/447) and
[#99](https://github.com/dragginzgame/canic/issues/99) open. Root
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) retains that consumer
qualification. No sibling edit, setup or test is run.

## Released 0.3.7

Release source is `7c9402eb8e0bc38fffa0db62be77ab314a88a0e2`; publication is
maintainer-reported. [Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38037875150)
now passes Linux, Intel macOS, Apple Silicon macOS and both package floors.
[All three downloaded receipts](../evidence/release-037.md) verify ZIP, inner,
payload/source/catalog, run/host/pin identities and actual fixture execution,
completing [#44](https://github.com/dragginzgame/ic-metrics/issues/44).
No workflow rerun was dispatched. This acceptance does not qualify 0.4.0.

### Preparation evidence

The prepared 0.3.7 batch adopted committed Shared Tooling 0.2.11
`83efac446348dea024798a331d77933b24b429dc` through its clean canonical exporter.
The 93-file selection adds the formatting reporter. Success output is concise;
failed commands retain full stdout/stderr and their failing status. Hook and
isolated release fixtures include the companion; native source receipts include
it, and the native collector archives reporter logs outside its scratch tree.
[The adoption record](../evidence/adoption-037.md) binds focused Bash 5/3.2 checks,
actual formatting/hooks, substituted release/collector effects and preservation.

This is compatible developer presentation and evidence retention, with unchanged
formatter selection/order, exit semantics, product APIs and report output.
No consumer reset or reinstall was required. Preparation retained versions 0.3.6; production Rust,
Cargo selection and pins are unchanged. The canonical repair for
[Shared #30](https://github.com/dragginzgame/shared-tooling/issues/30) now rejects
unsafe modes even when `MAKEFLAGS` hides them; Make must generate `MFLAGS`.
[Supplemental qualification](../evidence/adoption-037-make.md) covers the actual
consumer's release, formatting and publication routes on GNU Make 4.3/Bash 5 and
GNU Make 3.81/Bash 3.2, preserving safe replacement flags and parallel dispatch.
Delivery and changed-source native acceptance are now complete in #44.
No full local CI, resolver, commit or release ran during that preparation.

[The scoped downstream closeout](../evidence/consumer-closeout-037.md) binds
IcyDB 0.269.1's ten passing metrics-state tests and Linux/Intel/Apple Silicon
helper qualification to exact committed source and lock. It completes the original
IcyDB #298/#309 scope without claiming passing SQL tier-b or a release gate.
IcyDB #311 retains adoption of the newer Make guard; root
[#10](https://github.com/dragginzgame/ic-metrics/issues/10) retains Canic's
held-HTTP/native obligation. No sibling execution or file mutation occurs.

## Released 0.3.6

Published 0.3.6 matches source/tag `93c350a1179c83a3cfc8f7f713c50bc1c6be6a8f`.
[Its verification](../evidence/release-036.md) binds the dependency-free registry
archive, unchanged arithmetic, complete native/MSRV and all three downloaded
source-bound receipts. The earlier Linux/Apple Silicon success with Intel running
remains an initial observation, separate from the subsequent completion.

The prepared batch adopted Shared Tooling 0.2.9
`f8a70ba348e9975a6eb5b337860b00bc8a0b36d1` through the clean exporter. Its unchanged
92-file selection records immutable source-version metadata and validates
malformed/duplicate annotations. [The preparation record](../evidence/adoption-036.md)
retains Linux Bash 5/3.2 distribution, release/admission and focused checks;
fleet reports remain upstream. Released private Host 0.10.1 has
[its own review](../evidence/host-dependencies-0101.md), binding official archives,
unchanged consumed read/artifact source, Clippy, named/CLI tests and Rust 1.88
compilation. The durable parent-sync repair has no Metrics caller.

The read-only downstream recheck retains public IcyDB 0.269.0
`63ac8cbf9337306187e8bf74309ed9c576aca2af`, selecting registry Metrics 0.3.2.
[Its completed CI](https://github.com/dragginzgame/icydb/actions/runs/37940288483)
now passes both native macOS jobs, static, core, workspace, tier-a, MSRV and
Wasm-size. Downloaded native logs confirm actual library/CLI builds and portable
automation. Tier-b still fails: its downloaded log observes PocketIC's clean
exit after 60.532 seconds during compilation, before test execution. This does
not establish an arithmetic failure or a passing overall gate; IcyDB #298 and
root #10 retain their remaining owning acceptance. Canic public main remains
0.110.54 `c4c046f947b2b28f4342cbf6efe9221ba1ed5f70`, with held-HTTP/native
qualification still in #99/#447. Inputs/logs are retained under
`target/evidence/continuation-036/`; no sibling execution or mutation runs.

The subsequent public-main recheck advances IcyDB to 0.269.1
`76dc93ead6b66c8db9cb5c402355867dbdf188e3`, selecting registry Metrics 0.3.5
and Testkit 0.28.0. [Exact CI](https://github.com/dragginzgame/icydb/actions/runs/37974259856)
passes both native macOS jobs, static, core, workspace, tier-a, MSRV and Wasm-size,
while tier-b and the aggregate gate fail. The matching SQL Tier C workflow also
fails; it is not substituted for acceptance. The downloaded tier-b log observes
PocketIC exiting cleanly after 60.665 seconds while compilation is still active,
before test execution; this is not a measurement assertion failure. Inputs are retained under
`target/evidence/continuation-036-recheck/`; the earlier 0.269.0 observations above
remain bound to their original source/graph.

## Released 0.3.5

Published 0.3.5 matches source/tag `6c09738c8183bd539e74859fe5433709a928c655`.
[Its verification](../evidence/release-035.md) binds the dependency-free registry
archive, unchanged arithmetic, passing Linux/MSRV and downloaded Linux receipts,
including the expanded actual CLI test. The later
[complete native acceptance](../evidence/release-035.md#complete-native-acceptance)
verifies both macOS archives, exact-source logs and all three passing native
jobs plus MSRV. Earlier queued observations retain their original scope.
It adopts Shared 0.2.8 and Host 0.10.0; the original
[adoption](../evidence/adoption-035.md),
[Host](../evidence/host-dependencies-0100.md) and
[CLI](../evidence/inspector-cli-035.md) records retain their own inputs and limits.

Earlier 0.3.3 now has complete native/MSRV and downloaded three-host receipts in
[its acceptance record](../evidence/release-033.md#complete-native-acceptance),
completing the original installer and literal-hook obligations in #42/#43.
Cancelled 0.3.1 jobs remain non-execution observations. Later source/graphs and
the Make execution companion retain separate qualification.

## Released 0.3.4 Make and qualification fixes

Published 0.3.4 matches source/tag `5a5f1dab1f7ee3e1e5624c9d889148c39abf45f2`.
[Its verification](../evidence/release-034.md) binds the dependency-free registry
archive, unchanged arithmetic, passing Linux/MSRV and downloaded Linux receipts,
including the execution companion and real CLI/hook coverage. Both macOS jobs
remain queued; #44 retains its Make companion/failure-boundary acceptance criteria.

The release adopts Shared 0.2.7 and fixes unsafe Make execution, inherited smoke
roots and newline-root formatting qualification. Its
[preparation record](../evidence/adoption-034.md) retains the original Host 0.9.4
preservation scope. The released graph instead selects Host 0.9.5; its now-complete
[separate review](../evidence/host-dependencies-095.md) binds unchanged upstream
library source, package/source hashes, inspector Clippy, named/CLI tests and
Rust 1.88 compilation. No arithmetic or consumer contract changes.

The earlier 0.3.0 five-tool hard cut now has complete native/MSRV and downloaded
macOS receipt acceptance in [its supplemental record](../evidence/release-030.md#native-acceptance-complete),
closing #41. #42/#43 are completed by the later 0.3.3 acceptance above; #44 remains open.

## Released 0.3.3 tooling maintenance

Published 0.3.3 matches source/tag `b3ddfdf0406b54ef9a98ce48cbf5a9afe5fe406b`.
[Its verification](../evidence/release-033.md) binds the registry archive,
unchanged arithmetic, passing Linux/MSRV and downloaded Linux receipts, including
both shared Make includes, real formatting hooks and actual CLI coverage. All
three native hosts now pass with independently verified source-bound receipts in
[the completion record](../evidence/release-033.md#complete-native-acceptance).
The preparation evidence below retains its original scope.

The 0.3.3 batch adopted Shared Tooling 0.2.6
`ce13a5314916891fd239d9b199b4a91b04775054` with 91 selected files. Standard
release and formatting recipes moved to their shared owners, preserving local
release policy and adapters. Its [preparation record](../evidence/adoption-033.md)
retains focused hook/release checks and the earlier newline-root qualifier failure.
That helper limitation is corrected in released 0.3.4 above.

The released private graph selects Host 0.9.4. Its
[separate review](../evidence/host-dependencies-094.md) binds unchanged upstream
library source, package hashes, inspector Clippy, named/CLI tests and Rust 1.88.
No arithmetic API, attribution or endpoint contract changes. The original
installer/hook acceptance is complete above; later Make companion and failure
boundaries remain in [#44](https://github.com/dragginzgame/ic-metrics/issues/44).

## Released 0.3.2 maintenance

Published 0.3.2 matches source/tag `f903c664c395c47485dbedc0f1919c97b9ce72d0`.
[Its verification](../evidence/release-032.md) binds the dependency-free registry
archive, unchanged arithmetic, passing Linux/MSRV jobs and downloaded Linux
receipts, including actual CLI admission coverage. Both macOS jobs remain queued.

The compatible 0.3.2 batch's unchanged 89-file selection adopts
reviewed Shared Tooling `ac4549c5ebde497f7db0da5d05d32835112e51de`, clarifying
optional installer-fixture companions and CI queue/duplicate-run diagnosis.
The optional all-installer suite remains unselected; this snapshot refresh leaves
production helper bytes, installer Make/CI callers and tool pins unchanged.
[The adoption record](../evidence/adoption-032.md)
binds the canonical refresh and focused snapshot/pin/offline checks.

The batch also includes the independently prepared Host 0.9.2 lock selection.
[Its review](../evidence/host-dependencies-092.md) verifies package/source hashes,
unchanged library source, inspector Clippy and named tests, actual Rust 1.88 and
byte-identical frozen reports. The core remains dependency-free. No arithmetic
API or data contract changes; package/workspace versions remained 0.3.1 during
preparation. No commit, release, publication or cleanup ran during preparation.

The inspector's focused gate now executes an actual CLI admission/publication
test alongside its existing argument/report tests. Accepted bytes produce the
matching digest and report; oversized, malformed, missing and directory inputs
fail with empty stdout and leave inputs intact. Linux formatting, warning-denied
all-target Clippy, the named tests and actual Rust 1.88 check/execution pass.
[The CLI record](../evidence/inspector-cli-032.md) retains commands, initial lint
failure and source/lock identities. Configured native CI inherits the test through
the existing gate; this local result does not establish macOS acceptance.
Production arithmetic/inspector source and CLI contracts are unchanged.

## Released 0.3.1 installer fixes

Released 0.3.1's unchanged 89-file selection adopts
reviewed Shared Tooling `ee48bb37c98c771e77b92fd891f0757d8c1c8b99`: IC setup/check
consumes a final pin row without a newline, and CI tools publish to the exact
destination without redirecting through a late directory or symlink. The
existing yq caller keeps its version/checksum; Perl admission precedes setup.
[The focused record](../evidence/adoption-031.md) binds passing Bash 5/3.2 fixtures,
snapshot/pin checks and actual offline IC admission. Arithmetic source, Cargo
selection and IC pins were unchanged during that preparation. Published 0.3.1
now verifies with Linux/native and both package floors passing;
[the release record](../evidence/release-031.md) retains the exact source and limits.
The later downloaded Linux artifact verifies its GitHub ZIP digest, inner archive,
14 payload hashes, 65 release-source hashes and nine successful setup/native
outcomes. Both macOS jobs remain queued.
[#42](https://github.com/dragginzgame/ic-metrics/issues/42) owns
exact-source native acceptance of the changed installer callers.

## Released 0.3.0 tooling hard cut

Released 0.3.0's 89-file snapshot adopts committed Shared
Tooling `8140e3dd1b44409d682c721889ab702f438c6a17`, transferring PocketIC ownership
to IC Testkit and requiring exactly five common IC tools. Existing six-tool
bundles fail the new offline check; explicit `make install-ic-tools` activates
the reviewed replacement. The real Linux setup/check and reuse pass, with all
old receipt-covered bytes, pins and receipts unchanged. Bash 5/3.2 installer,
common Make and evidence-collector fixtures pass.

Metrics has no active server path, equality check, setup or runtime harness.
The retired PocketIC checkers/fixture were never selected here; no Testkit
dependency or new installer is needed. Arithmetic APIs and persisted consumer
data are unchanged. No functions, methods or types are removed; the canonical
installer loses only its PocketIC-specific branches and matrix rows.
[The preparation record](../evidence/adoption-030.md) preserves proof scope and
historical replay constraints. [#41](https://github.com/dragginzgame/ic-metrics/issues/41)
tracks delivered-source native acceptance. Published source and Linux/MSRV
receipts now verify; both consumer macOS lanes remain queued. Package/workspace
versions are 0.3.0.
The initial tooling checks preserved the independent Host 0.8.10 lock edit.
Subsequent concurrent edits now select Host 0.9 in both requirements and lock;
the focused inspector checks below use that selection without changing it.
The original tooling evidence retains its initial dependency identity. No
commit or release runs here.

## Release admission fixture repair

The maintainer's CI failure at source
`e1363524f5be6b4c47b9a49e21230d969aef5e1f` came from the real offline-cache
fixture copying pending 0.3.0 notes while requesting a 0.2.21 patch candidate.
The release guard correctly rejected the mismatch before Cargo dispatch. The
fixture now owns its notes while retaining the exact committed manifests,
workspace sources and lock graph. Both real offline-policy cases verify Cargo's
failure status and unchanged manifest, lock, notes and index. Production
candidate admission remains unchanged; the fix ships in 0.3.0.

`make release-tools-check`, the admission fixture under genuine Bash 3.2.57,
ShellCheck and maintained documentation links pass on Linux. Logs and checked
source hashes remain under `target/evidence/release-admission-030/`; the original
CI log and `/tmp/metrics-release-admission.qEG6SX` failure are retained. These are
focused fixtures with the declared Git/Cargo/Make substitutions, not a rerun of
full CI or release execution. No package version or dependency changes.

## Private inspector ownership cleanup

The argument and report modules now share the executable-owned `Error`, removing
their dependency cycle. `report::Error`, its `fmt::Display::fmt` implementation
and its `std::error::Error::source` implementation move from
`crates/ic-metrics-wasm-inspect/src/report/mod.rs` to the binary root in
`crates/ic-metrics-wasm-inspect/src/main.rs`. No function, method or type is deleted;
no arithmetic API, CLI diagnostic, failure status or report format changes.

After `make fmt`, selected warning-denied host Clippy, the two argument tests,
three report tests and actual Rust 1.88 all-target checks pass on Linux with the
existing locked Host 0.9 graph. Actual binary help and missing-argument checks
preserve their output/status, and fresh reports for all three checksum-verified
frozen replay Wasms match the original TSVs byte-for-byte. Logs and checked
source/binary hashes remain under `target/evidence/inspector-cleanup-030/`.
This is focused worktree qualification, not a full CI gate or native release
acceptance. The arithmetic and release recovery code were reviewed without
finding another justified deletion.

## Released 0.2.20 checker fix

Released 0.2.20's unchanged 89-file selection adopts
committed Shared Tooling `926a20606591214ab29faa236b0b584e4857439e` through its
canonical distribution helper. Its dependency checker rejects exception catalogs
containing multiple JSON documents, so admission and suppression use one validated
array. Valid catalogs retain their contract. No dependency or public arithmetic
API changes. [The focused record](../evidence/adoption-0220.md) binds passing
Bash 5/3.2 fixtures, snapshot/pin checks and ShellCheck. Package/workspace versions
are 0.2.20. No newer committed Shared Tooling or Host revision is available at
inspection. This verification adds no implementation batch or pending changelog.

## Released 0.2.19 tooling fixes

Released 0.2.19 standard release entrypoints prepare the
selected locked workspace cache before offline validation, preserving explicit
Cargo offline settings, source/candidate admission and exact-version recovery.
Standalone preflight remains offline. The internal preparation selection is
consumed before helper/Cargo dispatch and removed from validation children.

Its released 89-file snapshot adopts reviewed Shared Tooling
`dc4fdf0f78928d75b69bbf43b37c690c53a04d1e` (0.1.37). It supplies explicit selected
Cargo binary/example setup with single-document receipts and original failure
statuses, plus checkout-local tool lookup for isolated staged formatting. No
additional tool package or profile is selected by this repository.
[The focused record](../evidence/adoption-0219.md) separates the initial 0.1.35
cache/refusal checks from the later 0.1.37 installer/hook qualification, including
actual formatting without a checkout-local caller PATH export.
[#40](https://github.com/dragginzgame/ic-metrics/issues/40) is delivered and retains
completed changed-caller native acceptance. All three native hosts and MSRV now
pass on the exact released source, with downloaded source/payload hashes, run/host
identity and changed release fixtures verified in the release record. The final
Intel receipt completes #40; no local gate or older source replaces that result.
The pre-existing Host 0.8.9 lock selection is preserved and now has its own
[focused qualification](../evidence/host-dependencies-089.md): package/source
identity, warning-denied inspector checks, actual Rust 1.88 and unchanged frozen
Wasm reports pass on Linux. Host library source is unchanged from 0.8.8. Neither
these checks nor upstream CI replace exact committed consumer native acceptance.

## Released 0.2.18 tooling cleanup

Released 0.2.18 retires optional fleet copies from this
consumer, while the arithmetic, setup/check and local workspace LOC contracts
remain intact. The 89-file snapshot adopts reviewed Shared Tooling
`3d33cd250fcae7dbe5cabe44b2abd6b2c91a1822` from a clean committed clone. Its IC
installer reuses equivalent pin catalogs without downloads or receipt rewriting.
The owned CI groups preserve every pushed source's running/queued qualification
and cancel only superseded PR runs.

Focused local tool fixtures pass under Bash 5 and genuine Bash 3.2, along with
snapshot/pin checks, local LOC, ShellCheck, actionlint and documentation links.
[The selection record](../evidence/adoption-0218.md) retains the removed-symbol
inventory and scoped evidence. [#38](https://github.com/dragginzgame/ic-metrics/issues/38)
awaits exact committed native qualification of these changed consumer callers.
Shared Tooling's selected upstream CI now passes all three native hosts and
lint/security; upstream CI does not replace consumer qualification.

Workspace/package versions are 0.2.18. Its committed private Host 0.8.8 graph
passes an [independent focused review](../evidence/host-dependencies-088.md):
warning-denied Linux host checks, named tests, actual Rust 1.88 and byte-identical
reports for the three frozen Wasms. New Host streaming hashing does not replace
the bytes required for Wasm inspection; existing read/report behavior is retained.
No new code batch or pending changelog is needed for this verification.

## Released source

Latest finalized and published source is 0.3.2
`f903c664c395c47485dbedc0f1919c97b9ce72d0`, matching tag `v0.3.2` and
workspace/package versions. The release record above verifies Linux/MSRV and
Linux native receipts; both macOS jobs remain queued. No further implementation
batch or pending changelog is created by release verification.

Earlier finalized and published source is 0.3.1
`2383dc0d684800b1610e3eb727449b0a87d562bb`, matching tag `v0.3.1` and
workspace/package versions. [Its verification](../evidence/release-031.md) binds
the dependency-free archive, unchanged arithmetic source and passing Linux/native
and both package floors. Both macOS jobs remain queued, so #42 stays open.
The independently qualified Host 0.9.2 lock selection ships in 0.3.2.

Earlier finalized and published source is 0.3.0
`070c768de881a6e966b93651e242e16e4f9f1111`, matching tag `v0.3.0` and
workspace/package versions. [Its verification](../evidence/release-030.md) binds
the dependency-free registry archive, unchanged arithmetic source and passing
Linux/native and both package floors. The Linux artifact verifies payload,
selected source, run/host and all nine outcomes. Both macOS lanes remain queued,
so #41 stays open. The independent released private graph selects Host 0.9.1.
The earlier fleet cleanup now has complete three-host receipts at released
0.2.18, closing [#38](https://github.com/dragginzgame/ic-metrics/issues/38); see
[its supplemental verification](../evidence/release-0218.md#subsequent-native-completion).
#40 now has complete released-source native/MSRV acceptance at 0.2.19.

Earlier finalized and published source is 0.2.20
`97064b0806699b60b475879ea7530135f1b540c8`, matching tag `v0.2.20` and
workspace/package versions. [The release verification](../evidence/release-0220.md)
binds the official archive and unchanged arithmetic source. Both package floors
pass on [exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37913368131);
Linux native passes with verified source/payload/outcome receipts; both macOS
native jobs remain queued at inspection. Earlier 0.2.19 Linux
receipts retain their [original identity](../evidence/release-0219.md).
Complete source-matching native receipts are still required for #40. No broad
local gate, dependency selection, package version change or release runs here.

The preceding published source is 0.2.17
`52be29e4bc2433b3d2912a0c09538be993dfb1b2`, matching tag `v0.2.17` and
workspace/package versions. [The release verification](../evidence/release-0217.md)
binds the official archive and source. Linux native and both package floors pass
on [exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37900937307);
Apple Silicon now passes and Intel is running at reinspection. Complete native receipt
review remains separate from publication.

The released reporting APIs add checked finite-bound cumulative counts,
nearest-rank quantile ranges and exact scaled ratios without changing recording
state or attribution. [Their preparation](../evidence/reporting-0217.md) preserves
the focused Linux/MSRV evidence, and the
[sibling audit](../reports/audits/2026/10/09/measurement-needs/01/report.md) retains
the read-only caller review. Consumers still own instrumentation and formats.
[Testkit #40](https://github.com/dragginzgame/ic-testkit/issues/40#issuecomment-6076486649)
records its maintainer's choice of explicitly approximate f64 means, preserving
exact totals and sample counts as authoritative. Its local docs/integration
checks do not adopt Metrics or change formats; maintainer delivery is pending.

Previously fully verified source is 0.2.16
`d8276daa3ae8603a5b4e196d0bb5369de54c1216`, matching tag `v0.2.16`.
That release's workspace, packages and local lock versions are 0.2.16. The official index
reports a non-yanked, dependency-free package with Rust 1.85.0 and checksum
`44b447757f583aa5e5145e34bbd6d8b75004614d90ef33544252c9e496178155`.
The newly downloaded archive verifies that digest, embedded identity and maintained
package bytes. Its packaged lock excludes the private host graph.
[Exact CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37822463635)
passes Linux, Intel and Apple Silicon native and both package MSRV checks.
Downloaded evidence from all three native hosts verifies source, payload, archive
and all nine successful outcomes, with IC Host 0.8.4 and PocketIC 16.1.0.
[The release record](../evidence/release-0216.md) completes
[#37](https://github.com/dragginzgame/ic-metrics/issues/37).
Its Shared Tooling and Host selected upstream matrices also pass all native
hosts. These receipts retain their original scope and do not qualify 0.2.17 or
the current tooling cleanup. The separate
[Host 0.8.5 review](../evidence/host-dependencies-085.md) preserves that graph's
focused checks and byte-identical frozen-Wasm reports before its 0.2.17 delivery.

Previously verified 0.2.15 source is
`287251eb51412852a58cabd9de5b3c28e207e705`.
[Its release record](../evidence/release-0215.md) completes
[#34](https://github.com/dragginzgame/ic-metrics/issues/34) and
[#36](https://github.com/dragginzgame/ic-metrics/issues/36).

Previously fully verified 0.2.14 source is
`dee5ecdef3d811dcda930ddcaae48abf08acc951`.
[Its release record](../evidence/release-0214.md) binds the complete native matrix
and downloaded receipts, completing
[#33](https://github.com/dragginzgame/ic-metrics/issues/33). Those results do not
qualify the newer host graph or pending Shared Tooling adoption.

Previously fully verified published 0.2.13 source is `4091366bcd97ddf4f31d5993c954f6f4a269bc63`.
Its non-yanked registry archive has SHA-256
`cf9bf6109539e8b956857f444a1d365b0205250405980c10bfdd905831f66fe3`,
with no dependencies or features. The checksum, embedded Git identity, maintained
Rust source, packaged guide, original manifest, README, license and lock verify.
The [release record](../evidence/release-0213.md) binds passing Linux, Apple Silicon,
Intel and MSRV. All three downloaded native archives verify source, payload and
outcome receipts, completing consumer collector/distribution acceptance in
[#30](https://github.com/dragginzgame/ic-metrics/issues/30) and
[#32](https://github.com/dragginzgame/ic-metrics/issues/32).
[#31](https://github.com/dragginzgame/ic-metrics/issues/31) is now complete:
corrected upstream `db039347` passes its entire native matrix, with all 19
tracking cases and both evidence verifiers executed on each host. This consumer's
original matrix remains bound to 0.2.13. The
[0.2.12 record](../evidence/release-0212.md) retains its Linux/MSRV pass and
cancelled macOS lanes without rebinding those results to the newer source.
The [0.2.11 record](../evidence/release-0211.md) retains its complete three-host
matrix and verified receipts, finishing [#28](https://github.com/dragginzgame/ic-metrics/issues/28).
Earlier complete matrices retain their own scope in
[the 0.2.10 record](../evidence/release-0210.md) and historical records.

Histograms are available from 0.2.4; checked means are available from 0.2.6.
`checked_mean(samples, total)` and `MeasurementSummary::mean()` return `None`
for empty `(0, 0)`, `Some(0)` for measured zero and floor division for valid
nonempty aggregates. Inconsistent empty pairs and either counter at `u64::MAX`
return typed errors, including an exactly reached cap. Recording, storage and
ownership contracts are unchanged. The
[application guide](../../crates/ic-metrics/src/application.md) is packaged and
compiled; [arithmetic evidence](../evidence/arithmetic-026.md) retains its original
source, host/Wasm, MSRV and documentation scope.

The [histogram experiment](../evidence/histogram-cost-026.md) measures an isolated
Canic recording source-copy on Linux PocketIC 16.0.0, with 138 validated calls.
At 1,000 repeated-key records, two histogram bounds add 42,000–75,000
instructions, 42,035–75,035 observed whole-update cycles and 208 raw Wasm bytes
over count/total; slots use 72 versus 16 bytes. This does not qualify a full
consumer, other bound counts/cardinalities, timer admission, mainnet or macOS.
The original ignored replay inputs are unavailable and the maintainer has no
backup. The historical report and identities remain unchanged. A separate
[durable arithmetic replay](../evidence/histogram-replay-029.md) supplies new,
checksum-bound source/lock/result/Wasm inputs; it does not reproduce the old
Canic experiment or extend its qualification.

Released 0.2.9 includes the canonical path/date repairs and source-first native
CI evidence collection. Their preparation and controlled failure checks remain
in [the adoption record](../evidence/adoption-029.md), with committed native
qualification in [the release record](../evidence/release-029.md).
The public frozen histogram bundle matches its checksum and all payload hashes;
[#26](https://github.com/dragginzgame/ic-metrics/issues/26) is complete. Its
138 measured/six admission replies, rebuilt identical Wasms and repeat replay
remain bound to the separate direct-arithmetic experiment. Missing historical
Canic inputs are not recovered or relabelled.

## Released 0.2.10 tooling

The released contribution/release-tooling batch adopts committed Shared Tooling
0.1.22 at `2687f26317952c43c685f7f799ed09288dc10a67` through the canonical
helper from a clean detached checkout. The 70-file snapshot explicitly adds
the contribution rules and PR release helper and refreshes linked guidance. Local AGENTS.md and
README now allow an explicitly requested PR to include scoped commits and a
topic-branch push. Ordinary continuation remains local work; merges, direct
integration-branch pushes and releases retain separate explicit authority.
Required protections/checks are preserved. The
[adoption review](../evidence/adoption-0210.md) binds interpretation and focused
checks. The [release-tooling review](../evidence/adoption-0210-shared022.md)
binds the subsequent runner refresh and direct-only delivery guard. Unsupported
PR delivery fails before release dispatch or metadata effects. Ordinary PR
contributions remain supported. Arithmetic, pins, package versions and locks are
unchanged by adoption. Its source-matching native matrix and downloaded receipts
now qualify the owning fixtures at 0.2.10; live interrupted GitHub release effects
remain distinct from command substitutes.

## Released 0.2.11 tooling

This compatible batch adopts committed Shared Tooling 0.1.23
`0ba0ad00ed94848e54ecc82629b6b7873b7284c0` through the canonical helper from a
clean detached checkout. The 70-file selection stays explicit and direct-only
delivery remains supported. After final consumer hooks, the runner rechecks the
index, committed payload and exact annotated tag. Completed direct recovery
confirms local/remote tag identity and branch ancestry before reporting success;
conflicts or unavailable observations stop without repeating effects.
[The adoption record](../evidence/adoption-0211.md) binds passing focused
Linux Bash 5/3.2 fixtures and static checks. Upstream 0.1.23 has passed all native
hosts; the release record above binds this consumer's complete source-matching
native matrix. Arithmetic, consumer ownership and dependency selection
are unchanged by the release-tooling adoption.

## Released 0.2.12 tooling

The compatible released 0.2.12 batch adopts committed Shared Tooling 0.1.25
`672ab4b8af50c75ed21a359ca5968682de83be94` through the canonical exporter
from a clean detached checkout. The verified snapshot explicitly adds the
archiver and its fixture for 72 selected files. The runner prepares a Git ref
transaction and checks its type under the update lock before refreshing a
matching tracking ref. Symbolic replacements, including unchanged resolved OIDs,
and inspection failures preserve the observation without replaying delivery.
Direct-only release selection remains unchanged. Tooling LOC now includes `bin/`
and distinguishes unborn repositories from corrupt Git state; snapshot expansion
checks declared companions before replacing files.

The native collector reuses the helper for failed tool candidates. Its outer tar
archive deliberately retains Git intent/index evidence from release fixtures;
the shared helper excludes that metadata. Source receipts include the two new
files. Focused fixtures cover literal names, modes, links, candidate Git exclusion,
outer recovery-state retention, partial writes and occupied archive refusal.
[#31](https://github.com/dragginzgame/ic-metrics/issues/31) and
[#30](https://github.com/dragginzgame/ic-metrics/issues/30) retain committed
consumer native/download acceptance. Preparation evidence is in
[the adoption record](../evidence/adoption-0212.md).

The earlier same-OID race remains bound to uncorrected `eeb72e7` and retained
under `target/evidence/shared025-review/`; successful dirty-patch previews stay
under `target/evidence/shared025-tracking-preview/`. The earlier archive-only
native pass does not qualify the corrected runner. Matching upstream
[run 37767868576](https://github.com/dragginzgame/shared-tooling/actions/runs/37767868576)
was queued at initial preparation. This local batch does not establish native
consumer qualification or live interrupted release execution. Arithmetic,
package/workspace/lock version 0.2.12 and dependency pins remain unchanged by
post-publication inspection.
Focused release-tooling, native archive/setup and LOC fixtures pass under Linux
Bash 5.2 and 3.2.57. ShellCheck, actionlint, documentation, pins, snapshot and
formatting checks pass; finalized changelog history is preserved byte-for-byte.
The original corrected-upstream run was later cancelled as a newer snapshot
landed; its Linux pass does not supply missing macOS evidence. The subsequent
0.1.26 source preserves identical runner bytes and now passes Linux, Apple Silicon
and lint, with Intel queued at inspection. Consumer qualification remains bound
to the exact 0.2.12 source in the release record.

## Released 0.2.13 tooling

The released 0.2.13 72-file snapshot selects committed Shared Tooling 0.1.26
`75a8a60f49cec11d3f6aecab5c977029c42cc549`, refreshed canonically from a clean
detached checkout. Its exporter can advance a verified unchanged uncommitted
snapshot using the previous manifest and exact committed source. It refuses
consumer edits, unavailable prior provenance, staged conflicts and changed
file/manifest identities. There is no force flag or implicit fetch; multi-file
publication still requires selected-path editing/validation to stop.
[The preparation record](../evidence/adoption-0213.md) binds source review and
focused checks. The runner, archiver and baseline are unchanged. The maintainer
finalized the compatible 0.2.13 release; Cargo/package/lock are now 0.2.13.
Upstream native CI and exact consumer qualification remain separate from this
local refresh; the sibling's dirty release-fixture follow-up is not adopted.
[#32](https://github.com/dragginzgame/ic-metrics/issues/32) owns this new
distribution qualification separately from the released runner/collector batch.
Focused distribution fixtures pass under Bash 5.2 and 3.2.57, and repeat refresh
verifies all 72 files. Static, documentation, pins and formatting checks pass.
The upstream Intel job subsequently passed snapshot distribution and the full
portable suite, then hit its 15-minute step deadline. Later native gates were
skipped. [Shared Tooling #71](https://github.com/dragginzgame/shared-tooling/issues/71)
owns that workflow-budget repair; no dirty upstream source is adopted.

## Released 0.2.14 tooling

The released 75-file snapshot selects committed Shared Tooling 0.1.27
`b866d41041a1986eeec95bde9af4c6ba0853d2e3`, refreshed from a clean reviewed
checkout through the canonical exporter. The three explicit additions are the
tool-evidence selector, installer evidence fixture and composite action that
fixture reads. The action is used by installer tests; the native workflow keeps
its own collector and Git recovery-state policy. Its source receipts now include
these new fixture inputs. Upstream's missing companion declarations remain in
[Shared Tooling #73](https://github.com/dragginzgame/shared-tooling/issues/73).

The local release adapter and fixture entry points now anchor physical paths
without consuming CDPATH output or trimming trailing newlines. A read-only
version request reproduced exit 127 before the correction; metadata fixtures
exercise both relative and absolute entry points in a newline-ending checkout.
The reviewed LOC reporter recognizes dotted snapshot names. The maintainer
finalized 0.2.14; package/lock versions are 0.2.14. Arithmetic,
dependency/tool pins and consumer attribution/storage contracts are unchanged.
[The adoption record](../evidence/adoption-0214.md) binds focused evidence;
[#33](https://github.com/dragginzgame/ic-metrics/issues/33) owns committed native
acceptance. Upstream's exact 0.1.27 Linux workflow fails its compact-evidence
verifier's stale log comparison; the prepared sibling correction in
[#66](https://github.com/dragginzgame/shared-tooling/issues/66) is not adopted.

## Released 0.2.15 tooling preparation history

The following preparation observations retain their original source identities.
The maintainer subsequently released 0.2.15 with Shared Tooling 0.1.28 and locked
IC Host 0.8.2. Current publication and qualification are recorded above; earlier
statements about pending versions, the public remote and dirty upstream work
describe preparation at that time.

The earlier 75-file preparation selected reviewed committed Shared Tooling
`db039347d2372b877c1c46dcdd2b5c3aa9412009`, still version 0.1.27, through the
canonical exporter from a clean detached checkout. Relative consumer and IC pin
operands now resolve physically without CDPATH output or trimmed directory bytes.
The installer fixtures declare their evidence companions; the existing explicit
selection is complete, so no selected path is added or removed. The baseline,
release runner, pin selections and consumer native collector remain unchanged.

The compatible pending changelog is 0.2.15; package/lock versions stay 0.2.14.
[The adoption record](../evidence/adoption-0215.md) binds focused checks;
installer and native-evidence fixtures pass on Linux Bash 5.2 and 3.2.57, as do
offline tool, snapshot/pin, formatting, shell/workflow and documentation checks.
Incomplete fixture exports refuse before creating consumer files; repeat refresh
verifies all 75 digests and modes.
[#34](https://github.com/dragginzgame/ic-metrics/issues/34) owns this batch's
future committed native acceptance separately from #33. The corrected upstream
[workflow](https://github.com/dragginzgame/shared-tooling/actions/runs/37787910279)
now passes Linux, Intel and Apple Silicon, including full/compact evidence
verification. This newer outcome completes #31's remaining upstream requirement.
Its workflow is not imported into the consumer.

The same compatible draft lowers the library MSRV from Rust 1.88 to 1.85.
Workspace inheritance, the Make default and CI minimum compiler agree; edition
2024 and the Rust 1.99 development toolchain remain unchanged. Actual Linux
Rust 1.85 native/Wasm checks, six selected unit tests, three public doctests and
warning-denied Wasm documentation pass. Development host/Wasm Clippy passes.
[The qualification record](../evidence/msrv-0215.md) binds compiler identity,
commands and unchanged arithmetic/lock bytes for
[#35](https://github.com/dragginzgame/ic-metrics/issues/35). This is local minimum
compiler qualification; committed hosted qualification of the complete pending
batch remains separate. Published 0.2.14 still declares Rust 1.88.

The same compatible draft adds the private `ic-metrics-wasm-inspect` host binary,
using registry IC Host 0.8.1 packages with explicit input budgets and digest-bound
TSV facts. Arithmetic remains dependency-free and `no_std`, with default Cargo
commands selecting that package. The host floor is Rust 1.88; the release adapter
advances both inherited local lock versions while retaining registry selections.
[The inspection record](../evidence/wasm-inspection-0215.md) binds local focused
checks and new structural facts about the unchanged historical replay Wasms.
[#36](https://github.com/dragginzgame/ic-metrics/issues/36) retains future committed
native acceptance. No downstream arithmetic contract changes require caller edits.

The maintainer's later release validation exposed an incomplete admission fixture:
its initial version probe copied only the root manifest after HEAD acquired a
second workspace member. The same root-only export could break late selected-commit
checks. Both paths now export the selected commit's crate tree with its metadata
before Cargo validates the workspace; they do not resolve a newer HEAD graph.
[The regression record](../evidence/release-admission-0215.md) binds the reproduced
failure and passing focused release-tool checks, including Bash 3.2 producer-failure
and retention coverage. The original release failure logs remain intact. Full
release validation, package versions and unrelated dirty lock changes are preserved.

The issue-repair continuation now adopts committed Shared Tooling 0.1.28
`1872ed2c20f6c70689bb2249050b1d673c60bfa0` through the canonical exporter from a
clean detached source. Its 90-file selection fixes the active-link byte defect in
[Shared Tooling #75](https://github.com/dragginzgame/shared-tooling/issues/75),
splits release simulation/tracking fixtures while keeping both in the consumer
gate, documents separate package MSRVs and includes the maintenance catalog and
inactive coordinator. The preceding db039 preparation and its original evidence
remain historical; [the new adoption record](../evidence/adoption-0215-028.md)
binds this source and focused checks separately. #34 retains future exact committed
consumer acceptance; #36 still owns the inspector's native qualification. The
public remote remains released 0.2.14, so local commits have no matching CI yet.
Newer uncommitted upstream policy/dashboard/release-source work is excluded.
No sibling files, schedules, commits or release effects are changed by preparation.

## Released 0.2.16 tooling preparation history

The following observations describe preparation before the maintainer's release.
Current publication and complete native acceptance are recorded above; the
preparation records preserve the original local commands and pending observations.

The canonical 91-file snapshot now selects reviewed committed Shared Tooling
`4e274a2219c0b0cc3af68ec65658b373253518fb`: 0.1.29 rules and the subsequent
committed Cargo-assessment documentation. The consumer release adapter
uses its canonical source checker with the same three metadata allowances,
reporting all blockers before preparation. Native source receipts include the new
source checker.
Snapshot-owned PocketIC pins advance to 16.1.0. Cargo manifests and arithmetic
source remain unchanged; existing IC executable installations are not requalified
or silently replaced.

The maintainer's current lock also selects published IC Host 0.8.4 for the private
inspector, advancing only its two direct host packages from released 0.8.2.
[The dependency review](../evidence/host-dependencies-0216.md) binds checksum/source
verification, Linux checks, Rust 1.88 host and Rust 1.85 core host/Wasm qualification,
and actual reports matching the original frozen Wasm TSVs byte-for-byte. The
new lock bytes are preserved. No new lock/process API is needed by this inspector.
The upstream 0.8.4 Linux/MSRV jobs pass; both native macOS lanes remain queued at
review. #37's future exact consumer matrix must qualify this newer graph together
with the tooling batch; released 0.2.15 receipts retain IC Host 0.8.2.

The pending changelog is 0.2.16 because this complete batch adds compatible
maintained tooling without changing the arithmetic or consumer contracts.
[The adoption record](../evidence/adoption-0216.md) binds focused Linux Bash 5.2
and genuine Bash 3.2 checks, source/index preservation, snapshots/pins and lint.
[#37](https://github.com/dragginzgame/ic-metrics/issues/37) retains future exact
committed native acceptance. The new upstream assessment workflow/script are
not selected; uncommitted upstream version preparation is excluded.
No package version change, release, commit, sibling edit or schedule
is part of this continuation.

## Downstream boundaries

The 2026-10-08 read-only inspection binds these local sources and selected locks.
Newer dirty work and remote publication require independent inspection; all
selected Metrics locks below refer to the registry package.

| Caller | Inspected local HEAD | Committed Metrics lock and inspected working-tree selection |
| --- | --- | --- |
| IcyDB | `4d137f6078146574ad76ae28fbef1250608ffc61` | Public 0.267.2 commits Metrics 0.2.12. Inclusive spans and CLI checked means; current native acceptance remains incomplete. |
| Canic | `4c51a87c6a32397196bb3f65d064641194df10a5` | Public 0.110.53 commits Metrics 0.2.9; subsequent dirty work remains separate. Exclusive endpoint accounting and invocation-owned async checkpoints. |
| IC Timers | `7d3ef40c50e49b79a8e9e10fb7cb68cee244eb7b` | Committed Metrics lock 0.2.10. Scheduler/work summaries and local sample admission. The local commit advanced during inspection; earlier reads selected 0.2.9. |
| IC Backup | `8a1152d0a510f34f8daed59f06632306f7cf134e` | Committed 0.2.9; dirty selection 0.2.10. Nanosecond summaries and four-bound prepared-byte histogram. |
| IC Blob Storage | `704b8ebf6bea85a715e465e32e34758b601852ec` | Committed/clean Metrics lock 0.2.9. Restoration test probe, not production library instrumentation. |
| Toko Miner | `aeed004b03b9b5d848de3750d77a42c5160c5fdf` | Committed/working Metrics lock 0.2.9; other lock edits remain separate. Production action-count cohorts use `record_sample`. |

The earlier 2026-10-08 recheck found IcyDB public 0.267.1 source
`cb8cefca1d68c20025398eae6dfab18a2eb45883`, selecting Metrics 0.2.8. Its
[CI](https://github.com/dragginzgame/icydb/actions/runs/37653174383) passes
Rust/MSRV/static but both native macOS jobs fail the retained release-lock lookup.
The later public 0.267.2 source `4d137f6078146574ad76ae28fbef1250608ffc61`
now commits Metrics 0.2.12 and the explicit TMPDIR-rooted snapshot template.
Its [exact CI](https://github.com/dragginzgame/icydb/actions/runs/37779266779)
passes static/MSRV/Wasm-size; its completed native macOS jobs now fail tool setup.
All four Rust lanes stop during tool setup: the offline PocketIC policy check
needs the locked workspace cache, but the explicit fetch runs afterward.
The actual Apple Silicon setup log likewise rejects uncached `candid` before
Metrics checks, through `install-dev`'s offline PocketIC alignment policy.
The owning setup-order correction is reported in
[IcyDB #302](https://github.com/dragginzgame/icydb/issues/302); matching native
helper acceptance remains in [#309](https://github.com/dragginzgame/icydb/issues/309).
The latest owning #302 comment records a local retirement of the extra product
PocketIC equality gate in favor of IC Testkit admission. Its focused checks pass,
but the owner explicitly retains the same failed public CI and a separate Testkit
startup restriction; that dirty correction does not complete #298's native proof.
The successful
scheduled SQL evidence workflow is a separate gate, not Metrics native closure.
Canic's newer source is now public as 0.110.53
`4c51a87c6a32397196bb3f65d064641194df10a5`. Its
[exact CI](https://github.com/dragginzgame/canic/actions/runs/37752054026) passes
all eight Core perf host cases and facade/report projections. Both macOS gates
stop at worker fixtures calling `rg` before pinned host-tool installation.
PocketIC refuses a stale embedded allocation peer before test startup, so the
actual held-HTTP metrics interleaving case does not execute. The ordinary lane
also rejects a finalized changelog without a pending draft. Owning corrections
remain in [Canic #450](https://github.com/dragginzgame/canic/issues/450);
passing host cases do not close the missing native/IC acceptance.
The later Canic Dependabot PR [CI 37784481281](https://github.com/dragginzgame/canic/actions/runs/37784481281)
selects source `b90cd3fc501aff682e32bbc685c4a91c932ff821` and registry Metrics
0.2.12. Its preflight rejects duplicate `ic-certification` in the deployed
`delegation_root_stub` and `canister_user_shard` closures; the retained lock has
3.2.0 and 4.0.0. All later native/MSRV/ordinary/PocketIC lanes are skipped.
[Canic #448](https://github.com/dragginzgame/canic/issues/448) owns that gate;
this PR graph is not public main, and the older passing perf cases are not
qualification of this proposed graph.
Backup 0.6.0 and Blob
0.18.0 public main match the inspected commits; their later graph's native/runtime
outcomes were not requalified in this inventory. Toko has no matching hosted
run at inspection. Timers public main was `0b12c8a6dbe5f359f5499df67313ffa5c02af446`
at the remote read, before the newer local 0.14.14 commit was observed. Local
commits and active release validation are not completed native qualification.

Timers' arithmetic-only adoption is already qualified at 0.14.6 on all three
native hosts and MSRV. Its later 0.14.12 main CI passes Linux/MSRV/Apple Silicon
but lacks Intel execution because GitHub could not acquire a runner; tag truth
passes separately. Backup's selected metrics integration is qualified at 0.5.2.
These completed source-bound adoptions do not automatically qualify later graphs
or reopen merely because another release has unrelated outstanding work.

Blob 0.17.1's workflow also executes the actual restoration-metrics PocketIC
case, despite its tooling-oriented name. All three native logs confirm the
named case passes. The earlier tooling-only description was incorrect;
[the consumer review](../evidence/consumer-closeout-0210.md) binds the correction
to actual commands, source and downloaded logs. Its scope remains a test probe,
not production instrumentation. No sibling source, graph or validation is changed.

IcyDB's CLI output compatibility belongs to
[IcyDB #313](https://github.com/dragginzgame/icydb/issues/313); Canic's async
attribution remains in [Canic #99](https://github.com/dragginzgame/canic/issues/99).
Histogram workload, bounds and storage decisions belong to
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475) and
[IC Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).
[IC Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) records the
summary-only decision without a demonstrated distribution workload. Toko's
cohorts count actions, not instruction-value ranges; Blob probe and Toko
application qualification belong to completed source-bound
[Blob #19](https://github.com/dragginzgame/ic-blob-storage/issues/19) and open
[Toko #6](https://github.com/dragginzgame/toko-miner/issues/6).

Remaining original extraction qualification is consolidated in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10): IcyDB's adopting-source
focused/native acceptance and Canic's adopting-source actual interleaving/native
acceptance. [#4](https://github.com/dragginzgame/ic-metrics/issues/4) closes as a
duplicate tracker; its outstanding obligations remain in #10. Timers, Backup
and Blob retain their completed adoption scopes. Toko application follow-up
is separate from the original reader-cut closure criteria. Histogram
investigators now have the published mean API and checksum-bound public replay
feedback in their existing issues; no new instrumentation is requested.

The 2026-10-09 public-main recheck advances IcyDB to 0.267.3
`145250b8ca7ce36cda240d4ff8fa47f254527877`, selecting Metrics 0.2.15.
[Exact CI](https://github.com/dragginzgame/icydb/actions/runs/37820158590) now passes
core, workspace, tier-a, MSRV, Wasm-size and Apple Silicon host jobs. Static fails
SC2015 in the shared checker under apt-installed ShellCheck 0.9.0-1; the same
selected helper passes reviewed 0.11.0 here. Intel native is cancelled, and tier-b
observes a clean PocketIC exit after 60.609 seconds during pre-client compilation.
These findings are reported to existing IcyDB #309 and
[Testkit #37](https://github.com/dragginzgame/ic-testkit/issues/37), retaining
IcyDB's full acceptance in #298. That public lock selects Testkit 0.25.2; newer
local graph preparation is not substituted.

Canic's actual public main is release 0.110.54
`c4c046f947b2b28f4342cbf6efe9221ba1ed5f70`, selecting registry Metrics 0.2.12.
[Its push CI](https://github.com/dragginzgame/canic/actions/runs/37784109345)
passes security, preflight, checks, MSRV and release build. Downloaded ordinary
test logs confirm all eight Core perf host cases pass, but the lane fails because
the changelog guard demands a pending release on finalized source. Both macOS
jobs fail the test-worker failure/cancellation cleanup step; the serial PocketIC
step also fails. Individual downloads for those three jobs return empty logs at
review, so their precise causes and actual held-HTTP execution are not established
by this observation. Existing Canic #450, #447 and #99 retain the owning repair
and acceptance obligations. The previous description of the Dependabot PR as
latest main was incorrect; its duplicate-package refusal is separate evidence.

The subsequent public-main recheck advances IcyDB to 0.267.4
`15174ec06c5a97c61317c9e205db4c0e86636dd8`, selecting Metrics 0.2.18.
[Exact CI](https://github.com/dragginzgame/icydb/actions/runs/37910356751) passes
static, core, workspace, tier-a, MSRV and Wasm-size jobs. The static ShellCheck
repair is delivered. Both macOS lanes remain queued and tier-b fails; this review
does not establish that failure's precise cause. IcyDB #298/#309 retain their
remaining native/focused obligations, and Canic's public source is unchanged.

The subsequent public-main review advances IcyDB to released 0.268.0
`059564d9af22558ffb80ee384bd698357f65154b`, selecting registry Metrics 0.2.20.
[Exact CI](https://github.com/dragginzgame/icydb/actions/runs/37923831876) passes
static, core, workspace, tier-a, MSRV and Wasm-size jobs. Intel remains queued,
Apple Silicon is running and tier-b fails. Both run-level and completed-job log
requests are unavailable while the run remains unfinished, so the tier-b cause
is unverified. IcyDB #298/#309 and root #10 retain their owning qualification;
Canic's public source and missing held-HTTP/native obligations are unchanged.
Read-only inputs and observations are retained under
`target/evidence/adoption-033/continuation/icydb-02680/`. No sibling execution or
dependency update is performed.

PocketIC-specific provisioning ownership is coordinated in
[Shared #76](https://github.com/dragginzgame/shared-tooling/issues/76) and
[Testkit #38](https://github.com/dragginzgame/ic-testkit/issues/38). Published
Testkit 0.25.4 setup/check and managed launch pass all three native hosts in
[owner CI](https://github.com/dragginzgame/ic-testkit/actions/runs/37901828971).
Metrics' released 0.3.0 adoption selects the committed five-tool Shared revision
above. It has no active server/runtime harness and adds no simulator dependency
or private setup policy. Frozen replay inputs retain their historical server
identity; current Testkit defaults are not substituted into that experiment.

No sibling files were edited. Historical evidence stays under `docs/evidence/`;
[the host record](../hosts.md) separates focused Linux checks from native CI.
No full local CI/product-test gate, dependency upgrade, package version change,
commit, push, tag or release command ran.
