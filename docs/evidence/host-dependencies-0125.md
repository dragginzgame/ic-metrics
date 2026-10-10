# Incoming IC Host 0.12.5 selection review

The incoming maintainer lock selection is preserved. Only private
`ic-host-artifacts` and `ic-host-fs` versions/checksums change from 0.12.4;
their dependency lists and every other lock row remain identical. Metrics
package/workspace versions remain 0.5.4.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `a6f16d9f6e5853b22a4eced517099c98841df6ab7a87f6fe0fbecec565072795` |
| ic-host-fs | `7d757bd76355539cc437ca6ca0c14736863c2b6d5185c72cab9ac28ffd100bf4` |

Embedded Git identities and every packaged Rust/original manifest file match
released Host `85f051c60b2a6f37717c4274b1e31caf5b9d3453`.
Artifact Rust is unchanged from 0.12.4. FS changes reject NUL-containing durable
publication paths before directory creation; the inspector uses only bounded
`read_file`, whose module, path helpers and library root remain unchanged.
No durable writer is activated here. Reports, arithmetic and consumer contracts
need no wrapper change. No graph resolution or archive download is performed.

The first complete Shared 0.3.6 gate passes and compiles 0.12.5, but its final
preservation check detects this incoming lock update. It remains separate from
the subsequent stable-input qualification: complete `ci` (238 seconds), `msrv`
and `wasm-inspect-msrv` pass with all 81 frozen inputs unchanged. These gates
include the updated private graph and preserve both package floors; current
delivery status is recorded in [the handoff](../status/current.md).
Official index responses, independent source/archive/lock verification and logs
are retained under `target/evidence/shared-054/`. Hosted native acceptance remains
separate; no IC instruction, cycle or Wasm-size improvement is claimed.
