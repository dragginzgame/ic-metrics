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

## Apple Silicon native receipt supplement

The same run's Apple Silicon job `113759634677` subsequently succeeds, finishing
at `2026-10-09T11:55:27Z`. Artifact `11614202718` verifies GitHub's ZIP digest
`451b70ca8f34623c334e8fe65d7ca4336a4300b00eeddd5433d7a4dbe84fcfb8`
and inner archive digest
`5915a151368e20713a2e30e7c2cdeba700a814a464df5e438013cec8ca0dfb61`.
All 14 top-level payload hashes and 65 selected-source hashes verify against
the released commit. Source/run/attempt 1/push/Darwin/arm64 identities, all nine
successful setup/native outcomes and the released IC pin catalog agree.
Every job step succeeds. The native log confirms the changed release admission,
cache preparation, restoration/recovery and retained-failure fixtures pass,
with the declared substitutions rather than live release effects.

Inputs, verified payloads and comparison results remain under
`target/evidence/release-0219/apple-silicon-download/`. Intel native remains
queued, so #40 stays open for that acceptance. This supplements the original
observation without relabelling historical Linux evidence or reopening completed
#38 qualification. No workflow dispatch, rerun or cancellation occurs.
