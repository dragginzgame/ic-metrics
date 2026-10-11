# Shared Tooling 0.3.12 adoption

[#58](https://github.com/dragginzgame/ic-metrics/issues/58) owns adoption/native acceptance.
Metrics starts from released 0.6.0
`d156d647e88df137801989f2c7a010823c300d2f`. Shared Tooling's clean committed/public
0.3.12 `52e846369c39a1da371eac47ff97d94da925217e` is exported through its canonical
refresh helper from a clean detached checkout. Snapshot verification preserves
all 94 selected files and their executable modes; eight selected files change
from the previous 0.3.8 revision. The local AGENTS pointer advances with them.

The formatting checker exports its physical temporary parent before disposable
hooks change directories ([Shared #116](https://github.com/dragginzgame/shared-tooling/issues/116)).
The release checker anchors its temporary root and nested Make probes
([#112](https://github.com/dragginzgame/shared-tooling/issues/112)); the host-tool
fixture normalizes temporary aliases ([#111](https://github.com/dragginzgame/shared-tooling/issues/111)).
Rust setup runs preflight, installation and installed-tool checks from the selected
consumer while preserving caller-relative catalogs and consumer-relative locks
([#101](https://github.com/dragginzgame/shared-tooling/issues/101)). The validation
runner shares one diagnostic predicate between live output and retained selection,
including fatal, LLVM and missing-file errors
([#110](https://github.com/dragginzgame/shared-tooling/issues/110)).

The reviewed macro-protection guidance applies only to dollar-prefixed paths
inside rewritten derive attributes. Metrics' source has no affected definitions;
no formatter pin or protection marker changes are needed. Owning upstream
regressions are not copied into the consumer's source selection.

Read-only caller review covers IcyDB, Canic, IC Timers, IC Backup, IC Blob Storage
and Toko Miner's shared Make setup/check routing. Each passes its own CURDIR as
the selected consumer and keeps its own tool catalogs and product extensions.
This adoption changes no measurement contract, codec, persistence, endpoint or
consumer source; owning setup/native qualification remains separate.
`caller-inputs.json` binds each reviewed HEAD and the committed/current hashes
of its Makefile, shared Make include and Rust installer. Only Timers' selected
files match its HEAD completely; the other five reviews include separately
identified working edits and do not claim committed-source qualification.

Qualification logs and frozen input catalogs are retained under
`target/evidence/adoption-061/`. Selected ShellCheck passes. Rust-tool fixtures,
the host-tool fixture through a symlinked relative TMPDIR, and the actual Metrics
formatting-hook adapter through that same selection pass on current Bash/Make
and genuine Bash 3.2.57/Make 3.81 on Linux. The clean upstream hook regression
also qualifies absolute, relative and symlinked temporary roots, failed-prerequisite
diagnostic retention and source/index preservation on both profiles. The upstream
runner regression passes both profiles, exercising actual ripgrep and the grep
fallback, isolated diagnostic families and neutral Rust-name controls.
Fixture Cargo/download effects remain substitutes; the hook exercises real
formatting. No installation or external release effects occur.

The actual Metrics release-command checker passes through the same symlinked
relative TMPDIR on both profiles. Real prepared Rust preflight and offline
installed-tool admission also pass when invoked from `/tmp`, selecting Metrics
as consumer. These checks perform no installation.

Complete `ci` (210 seconds), `msrv` and `wasm-inspect-msrv` pass in `delivery.log`.
All 140 frozen code/graph/pin/snapshot inputs remain unchanged, as independently
verified in `delivery-preservation.txt`. The graph is the actual released 0.6.0
selection, including private Host 0.13.0; this adoption does not change that graph.
Earlier hard-cut preparation evidence retains its original 0.12.9 selection.

Local validation does not establish native macOS
acceptance; the new snapshot needs its own delivered-source CI and retained
receipts. The pending patch notes are 0.6.1, while package/workspace versions stay
0.6.0. No dependency selection, tool installation, commit, release or publication
is performed.
