# Shared Tooling 0.2.13 adoption for Metrics 0.4.0

The maintainer selected the complete 0.4.0 adoption after the provisional compatible
0.3.8 Host review. Base source is released Metrics 0.3.7
`7c9402eb8e0bc38fffa0db62be77ab314a88a0e2`, with the incoming Host 0.11
manifest/lock changes preserved. Shared source is committed 0.2.13
`5864f468d39f8f9d1bd26fca1afe0e20f25f1b5e`, matching public main at inspection.
Its dirty sibling GitHub-dashboard work is excluded.

The canonical exporter ran from a clean detached clone and retained the exact
93-file selection. Its first attempt refused a remote spelled with `.git`, which
differs from the existing manifest's canonical URL. That refusal is retained;
the retry used the manifest's exact origin and succeeded. No snapshot-owned file
was hand-edited. The local AGENTS overlay is aligned with the adopted revision
and full-delivery validation authority.

The tooling cut removes previously supported LF/CR operational directory names.
Snapshot refresh/verification now refuse supplied and resolved paths before
normalization can select a neighboring checkout. Explicitly rename affected
operational directories before use; existing artifacts/evidence are preserved.
Spaces and ordinary physical aliases remain supported. This requires the next
minor under the pre-1.0 compatibility rule. The sole pending changelog is 0.4.0;
package/workspace versions remain 0.3.7, with no consumer data reset.
Owners: [Shared #95](https://github.com/dragginzgame/shared-tooling/issues/95) and
[Metrics #45](https://github.com/dragginzgame/ic-metrics/issues/45).

The consumer release adapter now prepares its existing pinned Rust executable set
after source/candidate admission and locked cache fetching, through
`make install-rust-tools`, followed by offline `make rust-tools-check`.
Standalone preflight fetches/checks offline without installation. Pin digests are
checked after each external tool phase. The preparation marker is consumed before
children, explicit Cargo offline policy is inherited, and the Make preflight
recipe retains recursive jobserver descriptors. No new installer, pin selection,
tool registry or server dependency was added. Full CI already sequences offline
host/Rust admission before dependent compilation/tests.
Owner: [Shared #96](https://github.com/dragginzgame/shared-tooling/issues/96).
Consumer delivery/native acceptance is tracked in
[#46](https://github.com/dragginzgame/ic-metrics/issues/46).

The actual metadata/admission fixtures cover cold preparation, existing tools,
setup/check failure, offline missing tools, changed pins and original manifest/
lock/index preservation. The actual release runner with substituted phase effects
stops setup/check failures before validation, preparation intent and version/tag
effects; successful setup/check precedes a deliberately failing gate. Existing
source/index/refusal, offline real fetch, selected-commit and failure-log cases
remain covered. Tool installation/availability is substituted in these caller
fixtures; actual installer receipt/reuse/locking behavior belongs to the selected
canonical owner fixtures. No fixture result is native macOS or publication proof.

The separate [Host 0.11 review](host-dependencies-0110.md) binds official non-yanked
registry rows, archive/source identities and actual locked inspector qualification.
Consumed artifact/read source is unchanged; process API removals have no Metrics
caller. Arithmetic and inspector production sources/reports are unchanged.
Consumer measurement contracts require no adapter, storage, identity or endpoint
change: IcyDB, Canic, Timers, Backup, Blob's probe and Toko retain the authorities
recorded in [the extraction contract](../extraction.md#downstream-contract-checks).

Complete Linux delivery validation passes through the actual shared logger:
`ci` (149 seconds), arithmetic Rust 1.85 host/Wasm checks and inspector Rust 1.88
all-target checks. The complete gate includes warning-denied library/inspector
Clippy, unit/doctests, actual CLI, hooks, release/admission/retention, tool and
native-evidence fixtures. Selected ShellCheck also passes for the changed consumer
and canonical script owners.

Separate actual consumer metadata/admission/standard-release checks pass under
GNU Make 3.81/Bash 3.2.57, alongside Bash 5/current Make results. Canonical
snapshot distribution checks pass on both shells. Ten actual consumer-verifier
cases pass: ordinary/space-alias roots are accepted; supplied LF, resolved LF and
CR ancestor paths refuse without changing the neighbor's manifest. Pin, Cargo
and delivery-code input preservation checks pass. Final formatting, snapshot,
pin, links and diff checks pass. Full-gate code inputs retain their checksums;
later documentation-only updates use the narrower link/consistency/diff checks.

[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/38039035514)
passes all three native hosts and lint/security at the selected revision. This
does not qualify the pending consumer's native jobs. #45/#46 retain delivery and
source-bound Linux/Intel/Apple Silicon acceptance. Inputs, refresh/refusal logs,
preservation hashes and check outputs are
under `target/evidence/adoption-040/`; the independent Host inputs remain under
`target/evidence/host-0110/`. Released 0.3.7's native acceptance remains separately
owned by #44. No sibling source edit, resolver, package-version change, commit,
push, release or publication is performed by this adoption.
