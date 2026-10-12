# Published 0.7.1 verification

Local release HEAD and public main agree on
`569a388bb0066bb51ede6095d88b40a65f36e82a`. Both downloaded official archives
verify against non-yanked registry rows and embed that exact source commit:

| Package | SHA-256 | Rust floor |
| --- | --- | --- |
| ic-metrics 0.7.1 | `55e42fc5e0ac985e4efcdce9b2a3f2ff11eee5ec2517ba3de9428751595b6d14` | 1.85 |
| ic-metrics-stable 0.7.1 | `352f91b9004b3925a34442b45758d86057df20b11a45d6b183cfdc733126aaf9` | 1.88 |

Every packaged Rust file matches its owning released directory: 12 core and four
stable-store sources. Arithmetic remains dependency-free and `no_std`; durable
storage stays separately opted in. The release delivers the reviewed Shared
Tooling 0.6.5 snapshot/common entrypoint and Cargo-input checkpoint admission.
Its committed private lock selects Host 0.14.3 and IC Memory 0.35.13.

[Exact-source CI](https://github.com/dragginzgame/ic-metrics/actions/runs/38222899510)
is queued at observation. Publication does not supply delivered-source native
acceptance; [#61](https://github.com/dragginzgame/ic-metrics/issues/61) retains that
obligation. A subsequent API observation confirms Linux native and all package
floors pass, with both macOS lanes still queued; receipt verification remains
separate. The [prepared 0.7.2 IC experiment](stable-cost-072.md) uses byte-exact
released product source with its own locked Testkit/Host/Memory graph and measured
domain; it does not relabel old publication/native records.

Raw sparse rows, archives and verification records remain under
`target/evidence/release-071`. The incoming Host 0.14.4/Memory 0.35.14 lock belongs
to separate current qualification. No package version, Git ref or index is changed
by this review, and no release or publication command is executed.
