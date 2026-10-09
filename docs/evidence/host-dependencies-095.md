# IC Host 0.9.5 review

Released Metrics 0.3.4 selects `ic-host-artifacts` and `ic-host-fs` 0.9.5 in
its private inspector graph. This review qualifies that existing selection;
no dependency resolution, version change or upgrade runs. Compatible 0.9
requirements remain unchanged.

Both cached official registry archives match their locked checksums, declare
Rust 1.88.0 and embed upstream source
`0f61811c88a6b6b4b026b04ca16e428409be877f`. All packaged sources and original
member manifests match that commit (20 files for artifacts, 19 for fs).
Upstream library source is unchanged from Host 0.9.4
`4e3daebd5df07c6449279535668436024a45c02b`; the upstream release maintains tooling.

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `dacf349789ee238b60bbca3fd0a164d585338dbfb62e1fa6037317c3bbe47cda` |
| ic-host-fs | `f746f1d73b013826294fc35eab89bc7890d153578092f8d8922322f218288196` |

Focused locked offline Linux checks pass: warning-denied all-target inspector
Clippy, two argument tests, three report tests, actual CLI admission/publication
and Rust 1.88 all-target compilation. Manifest/lock preservation hashes bind
the same selected graph before and after qualification. Logs and package receipts
are under `target/evidence/host-095/`; preservation hashes are under
`target/evidence/adoption-035/`.

Production Rust remains unchanged and the arithmetic graph stays dependency-free.
This does not establish native macOS or IC runtime qualification.
