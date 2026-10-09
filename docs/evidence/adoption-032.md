# Shared Tooling 0.2.3 adoption

Pending compatible Metrics 0.3.2 refreshes the unchanged 89-file selection from
reviewed Shared Tooling `ac4549c5ebde497f7db0da5d05d32835112e51de` using its
canonical exporter from a clean detached checkout. Every selected file matches
that source. The selected changes are snapshot-consumption, host-support and
CI-health guidance; production installer/helper bytes remain unchanged from
released Metrics 0.3.1.

The optional all-installer fixture declares all five wrappers as companions
upstream ([Shared #73](https://github.com/dragginzgame/shared-tooling/issues/73)).
Metrics does not select or call that fixture or the exporter regression suite;
its production yq installer retains the common engine and checksum helper.
This adoption neither widens the selection nor claims a new executable guard
in this consumer. Task adoption activates no schedule or workflow changes.

The new CI-health guidance distinguishes queued jobs from completed work and
requires actual gate/input review before deduplicating branch/tag runs. This
consumer already preserves each pushed source and runs its heavy native workflow
for main pushes and PRs, without a second tag-triggered gate. No queue cancellation,
runner setting change or organization-wide capacity diagnosis is performed.

Snapshot/pin verification, actual offline five-tool admission, maintained
documentation links and candidate changelog admission pass. The independent
[Host 0.9.2 review](host-dependencies-092.md) retains its own checked source/lock
identity and unchanged frozen reports. Logs and preserved-input/source hashes
remain under `target/evidence/adoption-032/`. Package versions stay 0.3.1;
no new dependency resolution, Rust source edit, symbol removal, broad local gate,
commit or release runs.

Selected [upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37925303425)
passes lint/security; Linux is running and both macOS lanes are queued at the
recorded observation. These are partial upstream observations, not completed
native qualification of this pending consumer source.
