# Released 0.3.7 native acceptance

Released source `7c9402eb8e0bc38fffa0db62be77ab314a88a0e2` adopts Shared
Tooling 0.2.11, including the formatting reporter/collector and hidden-Make-mode
repair. [Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38037875150)
now passes Linux, Intel macOS, Apple Silicon macOS and both package-floor checks
on attempt 1. This completes the changed-source acceptance in
[#44](https://github.com/dragginzgame/ic-metrics/issues/44).

All three independently downloaded native receipts verify:

| Host | Artifact | ZIP SHA-256 | Inner archive SHA-256 |
| --- | --- | --- | --- |
| Linux | `11664791085` | `87e161f140647ac1bd2455e279c44fe193e7f14cf79cd7559599f8671cb6258d` | `a01bf2fc80b35311897a3de296c43ced728a03b3bfb3a0ddcedad2267627d2db` |
| Intel macOS | `11666038230` | `ce59c9406be7f14620c7535cb831837b7dec08ff21cefb37b15dc35aa7658258` | `78504bf7decb5e47f50dbd364ca43a9925968f5875a559903d11e173a86ce1ac` |
| Apple Silicon macOS | `11665846677` | `11217354d6a83d7a61cf6924c0ecb93c12bd03a6b116f632a762b57a3c4f088d` | `8e427008784978df2f879941317d6ddf54cde23d833490c42bb369f4cc386a84` |

Each receipt verifies GitHub's ZIP digest, the inner archive checksum, 15 payload
hashes, 70 released-source hashes and source-file ordering, exact run/attempt/
push/host identities, the released IC pin catalog and all nine successful setup/
native outcomes. Downloaded logs confirm actual inspector CLI, formatting/hooks,
release/admission and reporter/collector fixture execution. Each nested formatting
archive retains two nonempty diagnostic logs. Release effects remain substituted
where the fixture documents them; native tests establish no live publication or
IC measurement/performance gain.

The earlier observation with Intel still running remains historical. This
completed matrix does not qualify 0.4.0's later snapshot-path/preflight changes
or its Host 0.11 graph. Run/job inputs, archives, verified payloads and
`verification.json` are retained under `target/evidence/release-037/`. Initial
inspection-script parsing/pathspec refusals are separate from the successful
receipt verification; they did not indicate a product or archive failure.
No workflow rerun, compilation, release or publication occurs in this review.
