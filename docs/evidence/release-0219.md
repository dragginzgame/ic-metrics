# Published 0.2.19 verification

Release `v0.2.19` selects `429748e4877fa799b164bd2df1d9a76bb0acecb6`, matching
public main and workspace/package metadata. The official index reports a
non-yanked package with no dependencies/features and Rust 1.85.0. The downloaded
archive verifies its registry SHA-256:
`0948b36a40fa649dcf9f4b1edbf204a0ccab4c3f17b6a85cbdd0186df1e3b71d`.
Its embedded Git identity, seven Rust sources, application guide, original
manifest, packaged root README and license match the release commit. The
packaged lock contains only Metrics 0.2.19. Arithmetic source is unchanged from
released 0.2.18.

At inspection, [exact-source CI 37912160949](https://github.com/dragginzgame/ic-metrics/actions/runs/37912160949)
passes the combined arithmetic/host-inspector MSRV job and Linux native. Intel
and Apple Silicon native jobs are queued. The downloaded Linux archive verifies
SHA-256 `c8505a2e85af2acd6901af3903a1e99a498a9d81bc1fae70e75eba6deca17ca4`,
all 14 top-level payload hashes, the selected release-source hashes, exact
commit/run/attempt/event/host identity and all nine successful setup/native
outcomes. Its IC catalog matches the release source. These Linux receipts do not complete
[#40](https://github.com/dragginzgame/ic-metrics/issues/40)'s release-adapter native
acceptance or [#38](https://github.com/dragginzgame/ic-metrics/issues/38)'s remaining
consumer qualification. Earlier release receipts retain their own identities.

The released snapshot selects Shared Tooling
`dc4fdf0f78928d75b69bbf43b37c690c53a04d1e`; the released private inspector selects
Host 0.8.9. Their [tooling preparation](adoption-0219.md) and
[Host qualification](host-dependencies-089.md) retain separate local Linux scope.
Later snapshot adoption cannot relabel those checks or the released CI source.

Publication inputs and verified Linux receipts remain under
`target/evidence/release-0219/`. Verification
runs no build, dependency update, package version change, commit, push or release.
