# Incoming IC Host 0.12.4 selection review

The incoming maintainer lock selection is preserved. Only private
`ic-host-artifacts` and `ic-host-fs` versions/checksums change from 0.12.3;
their dependency lists and every other lock row remain identical. Metrics
package/workspace versions remain 0.5.3.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `40fabf2e749364a4f69bd511c37c90079e2da3faacbed81bf3d28a9b6bf25ffd` |
| ic-host-fs | `f78c2c021d8b51dff5dce8d0f89c4ef38f541e402368e23d4e5bc9c9d00c1ee0` |

Embedded Git identities and every packaged Rust/original manifest file match
released Host `5400f159474cebac1ec7ae7c8763abfd258bde03`. Consumed artifact/fs
Rust source is unchanged from 0.12.3. The Host release changes its own optimizer
tooling; consuming these libraries does not adopt those executable pins.
No inspector wrapper, report, arithmetic or consumer contract change is required.
No dependency resolution or archive download is performed.

The complete current-graph qualification is recorded in
[the handoff](../status/current.md). Official index responses and independent
archive/source/lock verification are retained under
`target/evidence/review-054-more/`. Native acceptance remains separate; no IC
instruction, cycle or Wasm-size improvement is claimed.
