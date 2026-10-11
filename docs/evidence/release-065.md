# Published 0.6.5 verification

Local HEAD, public main and peeled annotated tag `v0.6.5` agree on
`c4685c9f79d97a55f5dcd5d4ea4b796812fb2ad0`. Workspace/package versions and the
official archive's embedded Git identity agree. The non-yanked registry row
declares Rust 1.85.0, no dependencies and no features. Downloaded archive SHA-256
verifies as `6678e3dd82a101de7c9693dd51dcfb997fb4b4c052e003eaf6b30b74a12441b7`.
All packaged arithmetic sources, the original manifest, root README and license
match released source. Arithmetic is byte-identical to released 0.6.2.

The release delivers [Shared Tooling 0.6.3 adoption](adoption-065.md#supplemental-shared-tooling-063-adoption)
and the separately reviewed [Host 0.14.0 selection](host-dependencies-0140.md).
Its committed lock selects Host 0.14.0. The incoming uncommitted Host 0.14.1
lock selection is [reviewed separately](host-dependencies-0141.md); it is not
covered by this released-source verification or hosted run.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38150183645)
reports the job checking both Rust floors passing, Linux in progress and both
macOS lanes queued at inspection. No native receipt is available to verify at
this observation. [#61](https://github.com/dragginzgame/ic-metrics/issues/61)
retains native acceptance for the delivered Shared 0.6 batch. Earlier local gates
retain their original metadata/graph identities and do not establish delivered
native acceptance. Canic's remaining actual runtime/native obligations stay in
[#10](https://github.com/dragginzgame/ic-metrics/issues/10).

The exact-source [Host 0.14.1 run](https://github.com/dragginzgame/ic-host-tooling/actions/runs/38149531883)
reports Linux and MSRV success, Intel running and Apple Silicon queued. The older
Host 0.14.0 run is cancelled. These upstream statuses do not establish downloaded
Host receipts or Metrics native acceptance, and do not claim the older run passed.

Official registry response and downloaded release bytes remain under
`target/evidence/review-065/`. Earlier ignored local evidence is absent following
the maintainer's cleanup; fresh registry verification does not restore it. This
review performs no dependency resolution, installation, workflow dispatch,
release recovery, staging, commit or sibling mutation.
