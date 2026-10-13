# Checkpoint and histogram cleanup for pending 0.9.2

Starting finalized source is `804ca4727b74d641bbe3be9155e20de914eb3ad9` (0.9.1).
This working-tree batch preserves arithmetic APIs, stable store signatures, V1
bytes, numeric/error admission, package versions and locked registry selections.
The sealed durable bound carries exact equality already implemented by all three
supported snapshots. Generic equality is available without raw codec access.

Identical checkpoint saves load and validate identity/kind/configuration and
numeric state before returning without encoding or map mutation. An absent empty
snapshot still creates its row. Changed snapshots still encode and write; they
also perform the equality check. Hosts retain write cadence and reset ownership.

Histogram constructors and restored-state admission share a borrowed bounds
check. Restoration does not construct an unused empty histogram. The first
invalid bound and restored-state error ordering remain unchanged, including
constant evaluation and empty bounds. Durable histogram continuity checks each
bucket's count and sticky overflow flag together, preserving both obligations.

## Qualification

[The frozen bundle](checkpoint-cleanup-092.tar.gz) and
[checksum](checkpoint-cleanup-092.tar.gz.sha256) retain before/after owner sources,
initial Clippy failure and corrected focused checks, exact command/input identities
and full final gate logs. No private sibling source, search excerpts or issue
bodies are exported. Read-only reviews of the six extraction consumers require
no caller changes; they do not establish consumer runtime/native acceptance.

Named native tests verify no `Memory::write` calls for repeated admitted aggregate,
summary, zero-bound and maximum-bound histogram checkpoints. Changed and initially
absent snapshots write; wrong identity and malformed retained rows fail without
mutation. Separately, valid restored histogram candidates with regressing counts
or a cleared flag in either bucket slot are rejected without writes.
These are deterministic native behavior checks, not IC cycles/instructions or
Wasm-size measurements; no workload-wide savings are claimed.

Full `make ci` passes in 296 seconds, `make msrv` in one second and
`make stable-msrv` in 13 seconds. Both package floors cover native and Wasm.
All 100 guarded source, graph, tool and workflow inputs remain byte-identical
before/after validation in the real checkout. Final receipt/handoff prose receives
separate documentation checks. The real staged tree, refs, manifests and lock
remain unchanged; no commit, package bump, release or publication is performed.
