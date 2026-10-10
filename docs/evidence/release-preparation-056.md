# Incomplete release metadata refusal

The compatible pending 0.5.6 change fixes
[#56](https://github.com/dragginzgame/ic-metrics/issues/56) against released base
`b995f787c8e08a6e2e8c18d99e223835f43f6e4e` (0.5.5). Package versions,
arithmetic APIs and downstream attribution contracts are unchanged. The separate
private [Host 0.12.8 selection](host-dependencies-0128.md) is qualified with the
completed batch rather than relabelling previous graph evidence.

Before correction, the actual metadata adapter invoked without `RELEASE_DATE`
on genuine Bash 3.2.57 prepares Cargo.toml and Cargo.lock, aborts at date expansion,
restores the originals and retains its backup, but exits zero. The existing
metadata fixture, extended in a temporary probe, rejects that false success.
The same probe passes on Bash 5 because its adapter already returns failure.
The failed legacy fixture, original files, partial candidate and probe/logs are
retained under `target/evidence/review-055/`; the failure is not relabelled as
passing evidence. Cargo-edit and Git are substitutes; sorting and locked offline
workspace metadata use real Cargo. No actual release effects are performed.

An actual selected-commit `check` against released 0.5.5 also returns zero on
Bash 3.2 when version or date is missing, discarding the exported source. The
same missing-date check fails and retains its selected input on Bash 5. Logs and
that retained modern export have their own paths under the review evidence.
These probes use real read-only Git observations/archives, without commits,
publication or compiled effects.

The existing production cleanup now converts zero status to failure when
preparation has not completed. Original restoration, backup retention, explicit
signals and ordinary nonzero command statuses retain their existing behavior.
The maintained metadata fixture adds missing-date and missing-version cases,
covering failure after lock preparation and before mutation. Both require failure,
original restoration and retained originals; existing command failures also
require their original status 9. No second release path or new mode is added.
The existing selected-commit cleanup now also requires completion; admission
cases require refusal before Cargo effects and retain the selected commit's
manifest, lock and changelog. Existing Git-producer failures preserve status 43,
and successful checks still clean their scratch export.

Selected ShellCheck and the full metadata fixture pass on Bash 5 and genuine
Bash 3.2.57 with GNU Make 3.81 available. The existing retention gate also passes
on that legacy profile. Full current-source delivery qualification is recorded
separately below; no native macOS or IC measurement acceptance is inferred from
these Linux executions.

## Current upstream adoption

Shared Tooling 0.3.8 `67285b28a98b7c4211ad32de726709d4e87edea4` arrived during
the review and is adopted through its canonical exporter from a clean detached
clone. All 94 selected paths are preserved and independently verified. The source
origin matches the snapshot exactly; the helper refused mismatching clone origin
spellings before copying files. Dirty upstream changelog work is excluded.
The selected changes are archive-qualification guidance and related documentation;
the changed fleet report is outside this consumer's selection. Metrics publishes
one dependency-free crate and needs no coordinated-archive override or new gate.

Initial prepare-only `ci` (225 seconds), `msrv` and `wasm-inspect-msrv` pass with
99 frozen inputs unchanged. Their logs and preservation catalog are explicitly
named `delivery-prepare-only` under the review directory. That proof predates the
selected-commit cleanup, Shared 0.3.8 and Host 0.12.8 changes; it does not qualify
the completed batch.

## Completed delivery qualification

With the complete cleanup corrections, Shared Tooling 0.3.8 and Host 0.12.8
selected, `ci` (183 seconds), `msrv` and `wasm-inspect-msrv` pass offline using
prepared tools/caches. All 99 frozen code, graph, pin and workflow inputs remain
unchanged. Source catalog, final preservation and gate output are named
`delivery-inputs-complete.json`, `delivery-preservation-complete.txt` and
`delivery-complete.log` under the review directory. The earlier prepare-only
qualification remains separate.

Selected ShellCheck, the complete metadata fixture and selected-commit admission
fixture pass on the modern profile and genuine Bash 3.2.57/GNU Make 3.81.
The complete CI includes the current retention gate; the earlier legacy retention
run predates the second cleanup correction. Documentation links and snapshot
verification pass. Hosted native acceptance remains an obligation of the eventual
released source in #56; current Linux checks do not supply a macOS receipt.
