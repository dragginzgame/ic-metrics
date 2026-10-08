# Shared Tooling 0.1.25 preparation

The consumer starts from released 0.2.11 source
`69b110b8fbefdac4773eac7631796f9dcb3f41a0`, preserving its existing dirty
publication documentation. Reviewed upstream is committed Shared Tooling
`672ab4b8af50c75ed21a359ca5968682de83be94`; the clean detached checkout at
`/tmp/ic-metrics-shared-025-corrected-reviewed` uses the canonical HTTPS origin.
The canonical exporter refreshes the current 70-file selection and explicitly
adds the archive helper and fixture through `--add-file`, producing 72 verified
files. The common baseline is unchanged from the previous selection. There are
no sibling edits, private snapshot patches or implicit dependency changes.

The runner refreshes only the matching upstream observation after confirmed
direct delivery. It captures the mapping/destination/OIDs, prepares a Git ref
transaction, then checks that the ref is direct while its update lock is held.
Symbolic replacements, dangling replacements and inspection failures abort that
optional projection without replaying delivery. The corrected tracking fixtures
use real isolated Git/bare destinations and inert product gates; other recovery
fixtures use command substitutes. Neither is a live interrupted GitHub release.
Direct-only delivery and consumer metadata/recovery guards remain in place.

The new LOC reporter includes `bin/`, announces unborn repositories with
`head=null`/`unborn=true`, and retains refusal of corrupt Git state. Snapshot
expansion admits explicitly added files and validates exported companion
declarations before replacement. The 35-file upstream diff was reviewed from
the previous `0ba0ad0` selection; only the declared consumer subset is exported.

The consumer's failed-tool candidate collector uses the shared archiver with
explicit checkout-root/path pairs. It retains bytes, modes and final symlinks,
refuses an occupied output, and preserves inputs plus partial output on failure.
The helper deliberately excludes Git metadata. The outer native archive retains
its existing tar policy because failed release fixtures carry useful Git intent
and index state. That policy cannot be replaced with a blanket Git exclusion.
The consumer fixture executes the actual workflow bodies, substitutes Make and
selected failed tar effects, and checks source/setup outcomes, candidate bytes,
literal newline names, modes, links, Git exclusion/retention and archive failures.
Existing source receipts, artifact hashes and upload selection remain owned by
this consumer; the two new shared files enter its native source manifest.

Focused validation results and captured inputs are retained under
`target/evidence/adoption-0212/`. Both Linux Bash 5.2 and genuine Bash 3.2.57
pass `make release-tools-check RELEASE_DELIVERY=pr`, `make ci-evidence-check`
and the selected tooling LOC fixture. The release fixtures explicitly select
direct delivery independently of the invocation's environment; unsupported PR
delivery still fails at the consumer admission boundary. All 19 real-Git
tracking cases pass, including the four corrected race/refusal cases.
The actual consumer workflow fixture passes nine source/setup cases and two
candidate archive failure cases, preserving the preceding failure status.

ShellCheck and actionlint pass. The initial narrow ShellCheck invocation omitted
the declared PR source helper; including that reviewed helper resolves SC1091
without suppressions or source edits, and both logs are retained. Documentation
links, pins, snapshot integrity, manifest/Rust formatting and `git diff --check`
pass. Removing only the pending 0.2.12 changelog entry reproduces released history
byte-for-byte. Cargo manifests/lock, Rust source and tool pins match released HEAD.
The repository description remains accurate. Matching upstream
[CI run 37767868576](https://github.com/dragginzgame/shared-tooling/actions/runs/37767868576)
was queued when preparation began; Linux and lint subsequently passed while
the macOS jobs remained queued at inspection. Exact committed consumer native execution
and downloaded archive acceptance remain in
[#31](https://github.com/dragginzgame/ic-metrics/issues/31) and
[#30](https://github.com/dragginzgame/ic-metrics/issues/30), distinct from prior
[released 0.2.11 qualification](release-0211.md).

Pending 0.2.12 is a compatible tooling change from finalized 0.2.11. Arithmetic,
attribution, units and consumer storage contracts are unchanged. Cargo/package/
lock remain 0.2.11; no dependencies or pins change. No product build, full local
CI, package version change, commit, push, tag, publication or release is part of
this preparation. No named function, method or type was removed.
