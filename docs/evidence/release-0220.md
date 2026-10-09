# Published 0.2.20 verification

Release `v0.2.20` selects `97064b0806699b60b475879ea7530135f1b540c8`, matching
the public annotated tag, public main and workspace/package metadata. The
official index reports a non-yanked package with no dependencies/features and
Rust 1.85.0. The downloaded archive matches registry SHA-256
`f78a1d93b280d8580bf3e29a9c15d0537d1a00c93144b0064a7b5ab1bdfe7631`.
Its embedded Git identity, seven Rust sources, application guide, original
manifest, packaged root README and license match the release commit. The
packaged lock contains only Metrics 0.2.20. Arithmetic source is unchanged from
released 0.2.19.

[Exact-source CI 37913368131](https://github.com/dragginzgame/ic-metrics/actions/runs/37913368131)
passes Linux native and the combined arithmetic/host-inspector MSRV job at
inspection. Intel and Apple Silicon native jobs remain queued. The downloaded
Linux archive verifies SHA-256
`d38350f2166286c9f2741c5a866e186ef4dc09a7487634c54e2f39a05c2b80f5`, all 14
top-level payload hashes, selected release-source hashes, exact commit/run/attempt/
event/host identity and all nine successful setup/native outcomes. Its IC catalog
matches the release source. The native log records pinning, release-admission,
formatting and inspector fixtures passing, plus 26 arithmetic tests and six
documentation examples. Substitute release effects remain declared in those
fixtures; no actual interrupted release is claimed.

These Linux receipts do not complete
[#38](https://github.com/dragginzgame/ic-metrics/issues/38) or
[#40](https://github.com/dragginzgame/ic-metrics/issues/40)'s supported-host
acceptance. The released 89-file snapshot selects committed Shared Tooling
`926a20606591214ab29faa236b0b584e4857439e`; its
[preparation record](adoption-0220.md) retains the original local check identities.
The private inspector still selects Host 0.8.9 with its separate
[focused qualification](host-dependencies-089.md). No newer committed Shared
Tooling or Host source is available at inspection. Earlier release and downstream
qualification retain their own source/graph scopes.

Publication inputs and verified Linux receipts remain under
`target/evidence/release-0220/`. Verification runs no build, dependency update,
package version change, commit, push or release. Documentation maintenance adds
no new implementation batch or pending changelog.
