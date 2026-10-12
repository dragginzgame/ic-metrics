# Shared Tooling 0.9.6 adoption for pending 0.8.1

Canonical refresh from a clean detached checkout adopts reviewed committed/public
`7e9f062f53baad2059a8585e2fffe2b98f03bafd`. Two payloads update:
`docs/releases.md` and `scripts/ci/release-pr.sh`. The other 100 files and all
90 explicit roots remain selected. No payload or root is added or removed.

The upstream PR adapter validates complete JSON identity strings before shell
extraction or saved-state writes. Trailing LF/CRLF in saved PR numbers or Git
identities and observed merged commit identities is rejected with evidence
preserved. Valid same-release reconciliation stays supported. Metrics still
supports direct release delivery only; this snapshot update does not add PR
adapters, merged-checkout qualification or a workflow change here.

The isolated upstream PR fixture passes review, merge/squash/rebase validation,
recovery and conflict cases, including malformed saved/observed identities. It
uses synthetic Git histories and a strict GitHub command substitute, without
real PR, registry or Metrics Git effects. The selected helper passes ShellCheck;
all 102 snapshot payloads verify. These fixtures are distinct from owning native
host acceptance and live PR release execution.

Full `make ci` passes in 263 seconds. Arithmetic Rust 1.85 native/Wasm, stable
Rust 1.88 native/Wasm and private inspector Rust 1.88 floor gates pass. All eight
gate checkpoints match the 136 frozen/current inputs. Relative to the qualified
summary fix, only the snapshot, overlay revision and two imported payloads differ.
This is local Linux delivery qualification; the pending 0.8.0 macOS acceptance
and owning consumer qualification remain separate.

The [frozen receipt](adoption-081-shared-096.tar.gz) and
[checksum](adoption-081-shared-096.tar.gz.sha256) preserve both manifests,
preview/refresh records, focused/full logs, tool identities, frozen validation
inputs, six upstream fixture/companion sources, checkpoints and verification
records. Fresh archive readback verifies all source hashes and completed gate
checkpoints. No check fails in this adoption batch. The Git index stays unchanged.

The [0.9.5 receipt](adoption-081-shared-095.md) and
[summary-restoration receipt](summary-restoration-081.md) retain their original
snapshots, source identities and qualification. Product Rust, Cargo metadata/lock
and tool pins retain their pre-refresh hashes. Base metadata remains 0.8.0 and
pending notes remain compatible 0.8.1. No sibling edit or release effect occurs.
