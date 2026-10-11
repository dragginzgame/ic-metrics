# Shared Tooling 0.6 adoption for Metrics 0.6.5

Current snapshot is committed Shared Tooling 0.6.3
`4fd979d13c32adb3cb2f51f213ebfc4f98339b3d`. Subsequent maintainer graph updates
select [Host 0.13.5](host-dependencies-0135.md), then
[Host 0.14.0](host-dependencies-0140.md); each review retains its own inputs.
The original 0.6.1/Host 0.13.3
qualification below retains its own inputs. Later qualification is recorded in
the supplemental section rather than relabelling that earlier full gate.

The maintainer reports Metrics 0.6.4 published. This batch starts from the clean
local 0.6.4 commit `9d374e098d43e1fa1f23230bc624b7b4db4bfa89`, retaining its
dated release notes, workspace metadata and Host 0.13.3 lock selection.
Shared Tooling source is committed/public 0.6.1
`731909525038c58d6f80b498e80f8630b11c685d`, exported with the canonical
distribution helper from a clean detached clone. All 97 selections remain;
four scripts update and 93 remain unchanged. No fleet-only fixture is added.
The first preview rejects a clone-origin spelling that differs from the
manifest; correcting only that disposable clone's origin permits export.
Snapshot files are not patched independently. Logs are retained under
`target/evidence/adoption-065/`.

## Contract and review

The adopted Cargo setup propagates failures explicitly even when Bash disables
errexit inside conditional command substitution. Source preparation, receipt
admission, references and store/local/common activation stop on failure,
preserving the producer's status. Cleanup releases only acquired locks;
activation requires both physical store and checkout locks. Earlier common
selections, other installers' locks and failed candidates remain retained.
The padded build-count fixture uses numeric comparison.

Contributors rerun explicit `make install-tools`, followed by `make tools-check`.
Shared identities and `.tools/rust/common/bin` remain the canonical installation
and admission contract. Matching compiler, native environment, source archive,
packaged lock, target and profile are required for reuse. The changed build
helper is itself an identity input; earlier generations remain retained.

The four adopted script bytes match the separately reviewed disposable source
copy. Its Bash 5 and genuine Bash 3.2 fixtures and checkout-context ShellCheck
pass. A control using the old 0.6.0 installer and the guarded new fixture fails
with the expected concealed foreign-lock failure. These isolated fixtures mock
Cargo and injection boundaries; they are not real tool installs, native macOS
qualification or IC performance measurements. The initial ShellCheck attempt
used the wrong source-resolution context; its failure and corrected passing
attempt are both retained under `target/evidence/adoption-065-review/`.

Read-only caller review covers IcyDB, Canic, IC Timers, IC Backup, IC Blob Storage
and Toko Miner. Common tools use the shared PATH; selected CLI callers consume
the canonical returned path and failure status. No sibling adapter change,
build or qualification is performed here. Arithmetic, attribution, identity,
persistence and endpoint contracts are unchanged.
The six-consumer catalog records 44 committed/working file identities in
`downstream-inputs.tsv`; selected adapters are retained separately. The initial
search mistakenly targets the different `toko` checkout, which has no matching
scripts directory; the completed catalog and adapter review use `toko-miner`.

The next candidate is compatible 0.6.5: published arithmetic sources, APIs,
behavior, pins and both Rust floors are unchanged. Public arithmetic stays
dependency-free at Rust 1.85; the private inspector retains Rust 1.88 and the
existing Host 0.13.3 graph. No package version, dependency, real index/ref,
release or sibling change is selected by this adoption.

## Local qualification

The verified 97-file snapshot, checkout-context ShellCheck and canonical Cargo
failure fixtures pass against the committed bytes under current Bash and genuine
Bash 3.2.57. Real canonical `make install-tools` and complete offline
`make tools-check` pass. The first setup attempt correctly refuses a concurrent
shared Cargo lock owned by IC Host Tooling. Its failure log/status and earlier
selections remain retained; no foreign lock is removed or bypassed. Normal
setup succeeds after the owner finishes.

A fresh temporary checkout using the same prepared Rust 1.99.0 compiler selects
the same three physical Cargo binaries. An actual `execve` trace records zero
Cargo `info` or `install` dispatches. This is real managed-store reuse evidence,
distinct from the substituted fixture checks.

Full `make ci` passes in 315 seconds, 13:11:54–13:17:09 UTC on 2026-10-11,
including both Clippy gates with warnings denied. All 86 frozen technical
inputs, 2,406 previously selected physical tool-file hashes and the inherited
2,394 earlier local-tool hashes verify immediately afterward. The two tool
catalogs have overlapping domains and are not summed. Arithmetic Rust 1.85
native/Wasm and private-inspector Rust 1.88 checks pass against the unchanged
0.6.4 metadata and Host 0.13.3 graph. Graph and tool pins remain unchanged.
Subsequent documentation changes receive link, snapshot and diff checks; no
technical delivery input changes after the successful full gate.

## Native qualification ownership

The exact-source [Shared CI run](https://github.com/dragginzgame/shared-tooling/actions/runs/38141614488)
is queued at the upstream observation. Public main identifies the adopted
Shared revision; no upstream tag or native success is inferred from it.
[#61](https://github.com/dragginzgame/ic-metrics/issues/61) owns adoption and
delivered-source native acceptance; Linux substitute/older-shell checks do not
establish either native macOS result. Shared
[#120](https://github.com/dragginzgame/shared-tooling/issues/120) owns setup
failure propagation and [#124](https://github.com/dragginzgame/shared-tooling/issues/124)
owns padded build-count correction. The previous released 0.6.3 acceptance in
[#60](https://github.com/dragginzgame/ic-metrics/issues/60) remains separate.
The maintainer subsequently accepts its carried-forward native coverage to
[close older cancelled-run obligations](release-063.md#superseding-older-cancelled-run-acceptance)
in #49/#50/#51, retaining their original cancelled records. That later closeout
does not qualify the newer Shared 0.6 batch here.

## Supplemental Shared Tooling 0.6.2 adoption

Canonical export from a clean detached source preserves the 97-file selection:
four files update and 93 remain unchanged from 0.6.1. The exporter admits the
earlier manifested exports without staging or replacing unrelated working edits.
The incoming maintainer Host 0.13.5 lock and all other graph/pin inputs are frozen
before export and remain unchanged by it. Logs are retained under
`target/evidence/adoption-065/shared-062/`.

Interrupted-release source conflicts now identify the exact saved plan, phase,
previous/candidate versions and saved/current commits. Refusal still preserves
the plan and validation evidence. The new upstream fixture covers patch, minor
and major normal/resume refusals, plus substituted guarded retirement and fresh
validation. Its Git/metadata effects are isolated substitutes, not execution of
a real release or recovery. Shared
[#126](https://github.com/dragginzgame/shared-tooling/issues/126) owns this fix.
The adopted recovery guidance is maintainer-operated and requires positive
consumer-specific proof that preparation never began; Metrics' temporary backup
adapter supplies no durable pre-mutation journal. This adoption neither retires
real plans nor treats missing journals or unchanged metadata as no-effect proof.

The Audit/Machete examples distinguish each executable's parsing and propagate
admission/tool failures, including inherited Cargo context under Shared
[#123](https://github.com/dragginzgame/shared-tooling/issues/123). Metrics has no
selected Audit/Machete caller, so no product extension or CLI wrapper is added.
Shared tool identities and pins remain unchanged from 0.6.1; previously prepared
Cargo generations remain selected. The candidate remains compatible 0.6.5.

The snapshot, documentation checks, selected ShellCheck and current-profile
release-runner fixtures pass. The complete genuine Bash 3.2.57/Make 3.81 profile
also passes in `runner-legacy-profile.log`, with both nested runner and substitute
launchers selecting the older shell. The earlier `runner-bash32.log` uses only
the older fixture launcher, retaining modern nested commands; it is a separate
mixed profile, not the complete older-profile qualification.

Full `make ci` passes in 296 seconds, 13:39:04–13:44:00 UTC on 2026-10-11,
including both Clippy gates and the private inspector's actual CLI test against
Host 0.13.5. All 89 frozen technical inputs, incoming graph/pins and the 2,406
earlier selected physical tool-file hashes verify afterward. Arithmetic Rust
1.85 native/Wasm and private-inspector Rust 1.88 checks pass. The initial 0.6.1
gate above retains its Host 0.13.3 identity; these new results qualify the
preserved Host 0.13.5 selection instead. Final documentation changes receive
link, snapshot, diff and unchanged-input checks.

Read-only release-caller review binds 22 committed/working files across all six
consumers in `downstream-inputs.tsv`. The shared adapter arguments, direct
delivery policy and source-refusal behavior remain compatible; only diagnostics
and owning recovery guidance change. No sibling edit or qualification is
performed. The exact-source [Shared run](https://github.com/dragginzgame/shared-tooling/actions/runs/38143010876)
reports Linux regression and lint/security success, with Apple Silicon running
and Intel queued at the observation. This status is distinct from downloaded
receipt acceptance or delivered Metrics native qualification in
[#61](https://github.com/dragginzgame/ic-metrics/issues/61).

## Supplemental Shared Tooling 0.6.3 adoption

The maintainer reports that normal patch release is blocked by the retained
`.git/release-state/0.6.4.plan`: phase `prepare`, previous 0.6.3, candidate 0.6.4,
source `ddcd7665ac44f3f903b3c4d0faf2eb0963033a29`, empty saved index tree and no
preparation file set. Actual clean HEAD is its descendant
`e5986b6e859578695856bc56a5096ee077dde007`, whose canonical Cargo workspace
version is 0.6.4 with pending 0.6.5 notes. The plan's SHA-256 is
`8205b789a498fcd67da84f2827357778fff81e21f96e693ec97af1263be6a41d`.
Inspection and adoption leave that real intent unchanged; no release, staging,
commit, tag, push, publication or recovery is performed by the agent.

With express authorization for the Shared Tooling repair, its runner now archives
superseded direct preparation after checking clean descendant source, unchanged
destination, absent staging evidence and committed metadata at the saved base or
candidate. Normal targets select the requested increment from current metadata
and repeat preflight/full validation. Preparation remains local metadata only;
consumer journals, backups and receipts are retained and reconciled by their owner.
Explicit resume and later effect phases keep exact-source/payload recovery.

The maintainer commits the reviewed repair as Shared Tooling 0.6.3
`4fd979d13c32adb3cb2f51f213ebfc4f98339b3d` during qualification. A clean detached
clone of that revision supplies the canonical preview and refresh: all 97
selections remain, nine update and 88 are unchanged. The accompanying maintenance
rules require evidence-based delivered-issue reconciliation; they add no automatic
workflow or CI dispatch. The real Metrics index, version, lock and selected pins
remain unchanged. The candidate remains compatible 0.6.5.

Shared qualification covers all increments, unchanged and committed-bumped
metadata, explicit-resume refusal, failed fresh validation, exact retained plans
and logs, dirty/divergent/staging/destination conflicts, and a different requested
increment. Disposable real Git histories additionally reproduce 0.6.4-to-0.6.5
selection, the exact new release commit and bare-destination atomic delivery,
while preserving a separately delivered older tag. These are fixture effects,
not a live Metrics release. ShellCheck and the complete genuine Bash 3.2.57/Make
3.81 simulation profile pass. Logs and canonical export records are retained in
`target/evidence/adoption-065/shared-063/`.

Read-only reviews of IcyDB, Canic, Timers, Backup, Blob Storage and Toko Miner
confirm local-metadata preparation ownership. Their source-bound journals/receipts
and qualification remain consumer-owned; this adoption does not weaken a consumer
preflight or archive its transaction evidence. No sibling edit is performed other
than the expressly authorized Shared Tooling repair.

The Shared Tooling full portable suite and full declared ShellCheck set pass;
its six scoped repair inputs retain their hashes after the maintainer commit.
The public main commit matches the reviewed source. Metrics' complete `make ci`
passes in 267 seconds, 14:10:49–14:15:16 UTC on 2026-10-11, including both Clippy
gates, the actual inspector CLI test and consumer metadata/admission fixtures.
Arithmetic Rust 1.85 native/Wasm and private-inspector Rust 1.88 checks pass.
All 85 frozen technical inputs, the real plan/version/graph/pins and all 2,406
earlier selected physical tool-file hashes verify after delivery validation.
The selected Cargo policy and pins remain unchanged; no real reinstallation is
needed. Fourteen committed/working Make/adapter rows bind the owning preparation
reviews in `downstream-preparation-inputs.tsv`.

Exact-source [Shared CI](https://github.com/dragginzgame/shared-tooling/actions/runs/38145666246)
reports lint/security success, Linux running and both macOS lanes queued at the
observation. Local fixtures do not establish native macOS acceptance; Shared
[#126](https://github.com/dragginzgame/shared-tooling/issues/126) retains that
qualification. Metrics [#61](https://github.com/dragginzgame/ic-metrics/issues/61)
retains this adopted source's delivered native acceptance. The pending Metrics
changes must be committed before the maintainer reruns the normal release target;
that future invocation performs the real plan archival and selects 0.6.5.
