# Shared Tooling 0.6 adoption for Metrics 0.6.5

Current snapshot is committed/public Shared Tooling 0.6.2
`7f1ca16b0dfa98021d2671017ecb7de767409b0e`. A subsequent maintainer lock update
selects Host 0.13.5; it is preserved and reviewed in
[the Host record](host-dependencies-0135.md). The original 0.6.1/Host 0.13.3
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
