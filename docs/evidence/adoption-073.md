# Shared Tooling and Host qualification for 0.7.3

## Final Shared Tooling 0.9.0 and incoming graph

The requested continuation adopts clean committed/public Shared 0.9.0
`aec7a149f581a42b9531fc747b46024fc0314fcf` from an isolated detached copy.
Canonical refresh updates three payloads and preserves all 101 files/entrypoints,
with no additions or retirements. Existing V1 snapshots need no conversion.

Refresh and verification reuse one syntax reader; NUL bytes are rejected before
splitting the same captured input. `--read-manifest FILE` emits admitted records
in order only after complete syntax, duplicate and entrypoint-membership admission.
It preserves literal field bytes and does not require payloads or a checksum
backend. Normal verification retains hash/mode/integrity checks, while refresh
retains independent committed-source ownership checks
([Shared #133](https://github.com/dragginzgame/shared-tooling/issues/133)). Fleet
reporting remains upstream. This changes contributor tooling; package APIs,
stored layout and floors remain unchanged, so the pending version stays 0.7.3.

After the 0.8.4 gate completed, the working lock advanced to Host 0.14.8 and
Memory 0.35.17. This selection is preserved and qualified separately. Official
non-yanked archives/checksums and embedded upstream releases verify; all 37
consumed Host and 46 Memory Rust files match their earlier 0.14.7/0.35.15 sources
byte-for-byte. No other lock rows or manifest requirements change. Incoming
graph's full CI passes in 262 seconds under the existing 0.7.3 approval, followed
by fresh core 1.85 native/Wasm, stable 1.88 native/Wasm and inspector 1.88 gates.
Canonical Cargo/snapshot/pin checkpoints remain unchanged throughout all four
gates. Warning-denied Clippy, named adapter/inspector tests and actual inspector
CLI admission/publication pass as part of this exact-source suite.

Exact-source distribution and fleet-reader integration pass record-order/byte
preservation, checksum-free syntax admission, malformed/NUL no-output refusal,
unreadable-input capture refusal, exporter ownership and integrity boundaries.
The integration's first invocation lacked prepared cloc on PATH; its failure
log remains retained. The rerun selects this checkout's prepared host tools and
passes without installation. Inventory stays upstream.

| Incoming crate | Verified SHA-256 | Released source |
| --- | --- | --- |
| ic-host-artifacts 0.14.8 | `7aabce8574b21f5ed3d55281d5ce0525345af83544f6b29d4ebe5e0d278091e4` | `c7b884f8bce7907c2c2670c1a8a6bc7bfad30628` |
| ic-host-fs 0.14.8 | `5ab54e93087e5e7c6b3d85e3a8542a3a518bfa095a13e7769e5d5d24fb9fe28e` | `c7b884f8bce7907c2c2670c1a8a6bc7bfad30628` |
| ic-memory 0.35.17 | `6f5fcdbafe9bda277dd03eb23a9b04c9ddc923f78a76dc4a128c19a150d5e8e2` | `392f1e76cad63aff11d3d09e947ce5ed206a8d92` |

The [0.9.0 receipt](adoption-073-shared-090.tar.gz) and
[checksum](adoption-073-shared-090.tar.gz.sha256) retain this exact graph, the
new source scope, all gate checkpoints, source comparisons and successful/failed
fixture logs. Fresh readback verifies every payload. Product Rust, selected
graph, pins, prior archives, HEAD and real index selection retain their pre-gate
identities; frozen IC measurements retain their original graph and workload.

The initial 0.8.4 receipt attempt refused the changed post-gate lock. Its final
receipt retains the exact old lock from the earlier preserved receipt, checked
against every gate checkpoint; it does not qualify this later graph. Raw new
evidence remains under `target/evidence/shared-090-adoption-073`. Metadata stays
0.7.2, and real index/refs, earlier measurements and sibling files are preserved.

## Previous Shared Tooling 0.8.4 adoption

The requested continuation selects clean committed/public Shared 0.8.4
`dca2bdd018afa6be598f03bb3cce1bab79c66973` from an isolated detached copy.
Newer dirty 0.9 manifest-reader work in the sibling is excluded. Canonical refresh
preserves the existing 101 entrypoints/payloads, updating only the snapshot guide,
workspace LOC reporter and its fixture. No file is added or retired.

`bash scripts/dev/cloc.sh --json` adds a complete structured workspace report with
numeric crate counts and totals. It uses the existing count path and percentage
rounding, emits no partial document on failure and retains the human table.
Sibling aggregation stays upstream. The refreshed guide distinguishes derived
script companions from explicitly selected governance roots. Metrics keeps its
historical changelog; Shared's own archival is not a consumer archival instruction.

Actual workspace JSON names all three packages and its numeric totals equal the
sum of the crate rows. The default table is byte-identical to the 0.8.3 reporter
on the same workspace. The adopted fixture passes JSON/table consistency,
independent manifest selection and later-count failure with no partial JSON.
Full CI passes in 246 seconds under the existing 0.7.3 approval on unchanged
canonical inputs. Existing tools pass offline without reinstall. Library source,
graph, pins and earlier receipts retain their pre-refresh hashes; unchanged
compiler-floor evidence is reused. The 259-second 0.8.3 and 263-second 0.8.2
gates below keep their original scopes.

The later post-gate lock change is qualified separately above. This receipt
retains Host 0.14.7/Memory 0.35.15 and the matching initial/after gate hashes.

The [0.8.4 receipt](adoption-073-shared-084.tar.gz) and
[checksum](adoption-073-shared-084.tar.gz.sha256) retain the actual reports, gate
logs, checkpoints and identities. Fresh readback verifies every payload.
Raw new logs remain under `target/evidence/shared-084-adoption-073`. Metadata stays
0.7.2; no index/ref, release/publication or sibling mutation occurs.

## Previous Shared Tooling 0.8.3 adoption

The maintainer's requested continuation advances this same compatible batch to
clean committed/public Shared 0.8.3
`8cca7e67b03ce6e701b6e7dcec2e9753eb98337e`. Canonical refresh uses an isolated
detached copy and the unchanged entrypoint roster: ten updates, 91 kept, no
additions or retirements. All 101 snapshot files verify. No tool pin, Cargo graph,
product Rust source, package floor or previous frozen artifact changes.

Formatting admission uses the selected Rust catalog even with separate host pins
([Shared #135](https://github.com/dragginzgame/shared-tooling/issues/135)). Cargo
setup refuses redirected observed-identity files before writing diagnostics,
preserving outside files, failed evidence and the previous active selection
([Shared #136](https://github.com/dragginzgame/shared-tooling/issues/136)). Minimal
Make exports derive installers/LOC helpers; individual snapshot copies are replaced
atomically beside their destinations, with local-edit/index rechecks and retry
after interruption ([Shared #131](https://github.com/dragginzgame/shared-tooling/issues/131)).
Abandoned payload temporaries are ignored alongside earlier refresh temporaries.
Successful PCRE2 admission is quiet; failure diagnostics remain intact.

Exact-source distribution fixtures pass interrupted-copy retry, payload/index
conflict preservation and minimal Make exports. Full CI passes in 259 seconds
under the existing 0.7.3 approval, including redirected-observation retention,
separate Rust-catalog admission and quiet-success/failure host probes. Existing
real tools pass offline admission without reinstall. Canonical gate inputs stay
unchanged; product inputs, earlier archives, HEAD and real index selection retain
their pre-refresh identities.

The [0.8.3 receipt](adoption-073-shared-083.tar.gz) and its
[checksum](adoption-073-shared-083.tar.gz.sha256) retain these checks and fresh
readback verifies every payload. The earlier 263-second 0.8.2 receipt below
retains its original snapshot scope; unchanged product compiler-floor evidence is
reused. Raw new logs remain under
`target/evidence/shared-083-adoption-073`. No package metadata, real index/refs,
release/publication or sibling files are changed.

## Original Shared Tooling 0.8.2 and Host 0.14.7 qualification

The compatible pending 0.7.3 batch starts from released Metrics 0.7.2
`711fbfa198fb16a3747441c0c1b0512a48047d77`. Package metadata remains 0.7.2.
Previously dirty release-verification/handoff documentation is preserved.
The already selected Host 0.14.7 lock is qualified without changing other rows.

## Shared source and scope

Reviewed clean committed Shared Tooling 0.8.2 is
`aaf75a37717357dd62f4b0b15001eaa3ba1629cf`. An isolated detached clone with the
original source remote supplies canonical distribution bytes. At initial
observation public main still resolves to 0.8.1 `c97f9f9`. The subsequent public
observation confirms exact 0.8.2 `aaf75a3` on main; initial observations retain
their original scope.

Canonical preview/refresh preserves the existing 100 entrypoints/payloads,
updates three task/catalog files and adds the new Cargo-tool task explicitly.
All 101 payloads verify. No file is retired. Tool pins, installers, Make adapters,
library sources, support floors and stored layout remain unchanged.

The [Cargo-tool freshness task](../../tasks/cargo-tool-versions.md) uses the
canonical checker from Shared Tooling with an explicit consumer path. Online
version observations remain separate from offline receipt/byte admission.
Its exact-source fixture passes current/missing/yanked/outdated and incomplete
observations using a substituted registry. Metrics imports no fleet checker,
enables no schedule and installs or changes no executable selection.

## Host source and scope

Both official non-yanked Host 0.14.7 archives embed released source
`52535a6cb88df9a84d1cda0a20d0887c6ba0ea8e` and match registry checksums:

| Crate | SHA-256 | Rust floor |
| --- | --- | --- |
| ic-host-artifacts | `564cd5b984f213fbde2f65b7f18f747f15c3162ef2438a0416293a675d1bea7b` | 1.88 |
| ic-host-fs | `909e2b2cedcda4cb7fc9a6ff208fe50abe996d49fef6f21d57dc7a7de17148b5` | 1.88 |

All 19 artifacts and 18 filesystem Rust source files match the released upstream
tree and the previously selected 0.14.5 archives byte-for-byte. Host 0.14.7 changes
its tooling entrypoint selection; no consumed API or runtime code changes.
The core remains dependency-free; released Memory 0.35.15 and all other lock
rows are preserved. No consumer attribution, endpoint or persistence policy changes.
Frozen IC cost/upgrade evidence retains its original graph and source identities.

## Validation

Exact-source task fixtures, canonical snapshot verification and official archive
checks pass. Inspector native checks, warning-denied Clippy, named argument/report
tests, actual CLI admission/publication and its Rust 1.88 floor pass. Core Rust
1.85 native/Wasm and stable Rust 1.88 native/Wasm gates pass on unchanged canonical
inputs. The explicitly approved complete `make ci` passes in 263 seconds.
Its canonical manifest, lock, snapshot and pin checkpoints stay unchanged.
Pre-adoption product Rust, Cargo inputs, tool pins and all older evidence archives
also retain their original hashes. All warning-denied gates pass.

The [frozen delivery receipt](adoption-073.tar.gz) and
[checksum](adoption-073.tar.gz.sha256) retain the exact snapshot/graph, source
comparisons, focused/full gate logs and CI checkpoints. Fresh archive readback
verifies every payload. Raw previews, refresh results, official archives and logs remain under
`target/evidence/adoption-073`. No staging, commit, release, publication or sibling
edit is performed.
