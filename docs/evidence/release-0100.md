# Released 0.10.0 acceptance

Public main and peeled `v0.10.0` identify
`63a6bd7ee79cc892f9894ab307c990520842ffc7`.
[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38633947812),
attempt 1, completes successfully on that source. The source selects Shared
Tooling `345865182de74a4cadfb9028b7c2055796d9552e` (display version 0.12.5),
published inspector 0.17.10 and Memory 0.38.0.

## Native and compiler acceptance

| Host | Successful job | Diagnostic artifact ID | Diagnostic tar SHA-256 |
| --- | --- | --- | --- |
| Linux x86_64 | `116092251911` | `11928185638` | `ff13a8eccc9eeedf1fc3cedb278cd2926f4314f4610637725e2dab9525148963` |
| Intel macOS | `116092251941` | `11930440359` | `37e56cc82152b8cec25612175c8f5a7fbdb4146d68f8f5a1eec2a06d5aa44644` |
| Apple Silicon macOS | `116092251349` | `11928980679` | `c9eb87bbca9bd74bf33330915baa09ce9470059cf51d8fa43b4d4fc1b7a4499f` |

Each downloaded diagnostic tar matches its enclosed checksum. Its source,
run/attempt, push event and native architecture match the job metadata. All
eight recorded outcomes are successful, and each of the 117 source hashes
matches its released Git object. The NUL-delimited source roster matches the
checksum roster exactly. Setup logs identify inspector 0.17.10; offline tool
admission and actual bounded inspector dispatch pass on all three hosts.

Each native receipt records successful explicit locked application preparation,
shared snapshot/catalog checks, canonical Cargo metadata preparation/restoration,
Metrics' delegated two-package metadata cases and selected-source offline
release admission. The library suites pass 50 arithmetic units, 16 stable units
and eight doctests per package. Successful floor job `116092251725` runs the
declared arithmetic Rust 1.85 and stable Rust 1.88 native/Wasm checks under the
released workflow. Job-log API output was empty during inspection; compiler-floor
acceptance is established by the recorded job/step conclusions and committed
workflow, rather than a newly downloaded compiler transcript.

This completes current consumer acceptance for
[#70 — Adopt snapshot-owned common tool catalogs](https://github.com/dragginzgame/ic-metrics/issues/70),
[#73 — Qualify coordinated Cargo metadata adoption](https://github.com/dragginzgame/ic-metrics/issues/73),
[#76 — Prepare the locked graph before offline release fixtures](https://github.com/dragginzgame/ic-metrics/issues/76)
and [#78 — Adopt the Host inspector macOS permission repair](https://github.com/dragginzgame/ic-metrics/issues/78).
The earlier [cold-cache reproduction](checkpoint-093.md) retains its independent
inputs; this hosted review does not claim an initially empty Cargo cache.
Older failed and cancelled workflows keep their original conclusions.

## Publication and retained scope

Both official registry rows are non-yanked. Downloaded archives match their
registry checksums; packaged Rust/application source, READMEs and original
manifests match the released Git objects, and both VCS records identify the
same clean source:

| Package | Official archive SHA-256 |
| --- | --- |
| `ic-metrics` 0.10.0 | `bad10fc3636b40ed249ecc24057ab2fb1967b9dca5e67ffa9e7563fab2a06bb8` |
| `ic-metrics-stable` 0.10.0 | `cd0810bbe36fb7adb0c7fe1f106604c2947f787b5c609066be2c8289b466ddac` |

The arithmetic registry row has no dependencies or features. The optional stable
package requires Metrics `^0.10` and Memory `^0.38` without enabling extra features.
[The compact receipt](native-closeout-0100.tar.gz) and
[checksum](native-closeout-0100.tar.gz.sha256) retain the original small diagnostic
tars/checksums, public run/job/artifact API identities, selected registry rows,
package VCS records, archive checksums and verification results. API ZIP digests
are retained as metadata; original ZIP bytes and full native scratch archives
were not downloaded or verified. This receipt contains no sibling source.

The [counter IC experiment](durable-counter-097.md) remains bound to its earlier
source and graph. This release acceptance supplies no new IC cost measurement,
first durable consumer qualification, Canic runtime acceptance or private-source
export permission. Those obligations stay with their owning GitHub issues.
