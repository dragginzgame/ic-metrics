# Incoming IC Host 0.14.1 selection review

The incoming maintainer lock selects private `ic-host-artifacts` and `ic-host-fs`
0.14.1 instead of 0.14.0. Their dependency lists and every other lock field remain
unchanged. The existing manifest requirement remains 0.14. This review preserves
the incoming selection without dependency resolution or Metrics version changes.

Official non-yanked sparse-index rows declare Rust 1.88.0 and match the selected
lock and already cached registry archives:

| Package | Archive SHA-256 |
| --- | --- |
| ic-host-artifacts | `fe9f4f3b54951520a67e8f99f120baf4cc9d6c37e3a848e20ce9f4d029ba3307` |
| ic-host-fs | `59ab765de7d6d9f4d5eaecac6e4c74e1350af4dda7d7cd3d0c7d6a4d89f08672` |

Embedded Git identities, all packaged Rust sources, original manifests, READMEs
and licenses match published Host 0.14.1
`f766121c7282a78753ca32bdb4d069ba8424b517`, also identified by public main.
The initial source comparison assumed crate-local READMEs; the corrected mapping
uses the inherited workspace README and license, with all selected bytes matching.

Host 0.14.1 adopts Shared Tooling 0.6.3 and preserves its own validation receipts,
notes and logs before same-candidate revalidation. This is Host-owned release
adapter work, not a new filesystem or artifact API. Both consumed source trees
and original child manifests remain unchanged from 0.14.0. Metrics already owns
its Shared 0.6.3 adoption and local-metadata adapter. No new process dependency,
inspector wrapper or arithmetic implementation is needed.

Inspector all-target checks, warnings-denied Clippy, argument/report tests and
the actual CLI admission/publication test pass. Arithmetic Rust 1.85 native/Wasm
and private-inspector Rust 1.88 checks pass against the incoming graph. Public
arithmetic remains dependency-free, allocation-free and `no_std`. There is no
instruction, cycle or raw Wasm-size improvement claim.

This is a focused dependency review. The preceding full gate remains bound to
Host 0.14.0, and the delivered Metrics 0.6.5 hosted run uses its committed 0.14.0
lock. Neither is relabelled as full validation of this incoming selection.
Source/archive responses, selected index rows, manifest/lock/pin hashes and
focused logs remain under `target/evidence/host-0141/`.
