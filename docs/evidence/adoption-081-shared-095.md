# Shared Tooling 0.9.5 adoption for pending 0.8.1

Canonical refresh from a clean detached checkout adopts committed/public
`b1630b89482cc6071fc928a86962d79c9c11fdb7`. The sibling's dirty PR fixture is
excluded. Twelve existing payloads update, 89 remain unchanged, and the selected
real-download retry fixture adds one payload/root: 102 files and 90 explicit
roots. No earlier payload or root is removed. The base commit remains published
0.8.0 `71a29d8a4d7ecf6774d9715895ce9abd13b9e5d7`.

Host/IC installers use the shared bounded curl retry policy. Permanent HTTP
errors and checksum mismatches remain terminal. Snapshot/release identities must
be complete 40- or 64-character lowercase hexadecimal Git hashes. Shared's
artifact discovery helper stays in its owning workflow; Metrics adds no artifact
readback dependency, token requirement or upload replay.

The canonical real-curl fixture now runs in Metrics CI and appears in the native
evidence source inventory. It proves transient recovery, retry exhaustion,
permanent failure and checksum refusal against a loopback HTTP server with the
production HTTPS/TLS arguments asserted. It does not establish availability or
the cause of a particular GitHub asset failure. Exact-source snapshot distribution,
snapshot verification, selected ShellCheck and workflow lint pass. Documentation
links initially ran before the new publication owner existed; creating that
document and rerunning passed. The retained link log is the passing rerun.

Full `make ci` passes in 286 seconds. All package-floor gates pass: arithmetic
Rust 1.85 on native/Wasm, optional store Rust 1.88 on native/Wasm, and private
inspector Rust 1.88 on its native host. All eight gate checkpoints match the
baseline, frozen copies and current 136 source inputs. This is local Linux
delivery qualification; command-substitute fixtures establish neither hosted
macOS acceptance nor IC performance.

The [frozen receipt](adoption-081-shared-095.tar.gz) and
[checksum](adoption-081-shared-095.tar.gz.sha256) retain both snapshot manifests,
preview/refresh records, focused/full logs, toolchain identities, frozen source,
checkpoints and verification records. Fresh archive readback verifies all 136
source hashes and eight gate checkpoints. Cargo metadata/lock, tool pins,
tracked product files and the real Git index retain their original identities.
Earlier receipts keep their original source and graph scope.

Package metadata remains 0.8.0; compatible pending notes are 0.8.1. No sibling
edit, staging, commit, tag, push, release or publication occurs.
