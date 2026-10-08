# Bounded host Wasm inspection

## Source and scope

This is new structural inspection of three unchanged Wasms from the
[frozen histogram replay](histogram-replay-029.md). Its archive SHA-256 remains
`bede3e2f63cbcf95b482323dc0135034220de0b7166fc48ad6f8ae8548bd4cfb`.
The replay uses released arithmetic 0.2.8; nothing here rebuilds that experiment
or changes its historical instruction/cycle measurements.

The separately implemented private host binary is based on checkout `4ad5837`
plus the working changes bound by [source hashes](wasm-inspection-0215/source.sha256).
It selects published `ic-host-artifacts` and `ic-host-fs` 0.8.1 in the root
Cargo lock, enabling artifact Wasm inspection only for the private package.
The [guide](../../crates/ic-metrics-wasm-inspect/README.md) defines its explicit
arguments, byte/count units and caller responsibilities. The arithmetic library
still has no dependencies and no platform reader. Source-less lock identities
are workspace-owned; the release adapter uses those canonical identities to
advance both local versions while preserving registry selections.

The pending compatible draft remains 0.2.15; manifests and local lock identities
remain 0.2.14. No source was committed, released or published during preparation.
[#36](https://github.com/dragginzgame/ic-metrics/issues/36) owns committed native
acceptance of this host tool, separately from the current snapshot's #34.

## Inputs and commands

On Linux x86-64, first verify the frozen bundle's existing checksum, then extract
only its three `histogram-replay-029/artifacts/<variant>.wasm` regular members into a new result directory
using `tar -xOf`. Build the actual binary with:

```sh
cargo build -p ic-metrics-wasm-inspect --locked --offline
target/debug/ic-metrics-wasm-inspect count.wasm 1000000 1000 10000 1000 > count.tsv
```

Repeat the last command for `summary.wasm` and `histogram.wasm`. The four bounds
are maximum raw bytes, sections, exports and custom sections, respectively.
The path shown is relative to the new input directory; the executed commands used
`target/evidence/wasm-inspection-0215/<variant>.wasm` from the repository root.
No Wasm transformation, canister execution or native timing benchmark runs.
Bound the actual rows with [report hashes](wasm-inspection-0215/reports.sha256).
Both checksum files use repository-root-relative operands.

## Observed structure

| Frozen variant | Raw Wasm bytes | Encoded code-section bytes | Encoded code-body bytes | Defined functions |
| --- | ---: | ---: | ---: | ---: |
| [Count](wasm-inspection-0215/count.tsv) | 358,328 | 311,893 | 311,891 | 1,850 |
| [Summary](wasm-inspection-0215/summary.tsv) | 358,440 | 312,005 | 312,003 | 1,850 |
| [Histogram](wasm-inspection-0215/histogram.tsv) | 358,611 | 312,175 | 312,173 | 1,851 |

All three report 43,472 encoded data-section bytes, seven imported functions,
one defined global, no imported globals, two data segments, two exports and no
custom sections. Their SHA-256 identities are retained in each complete TSV.
Relative to count, summary adds 112 raw and code-body bytes with the same function
count; histogram adds 283 raw bytes, 282 code-body bytes and one defined function.
These observations describe this frozen synthetic fixture, not application
savings or the footprint of current 0.2.15 source.

Encoded body bytes are not instruction counts. Structural inspection is not
full Wasm validation or IC installation admission. Imported-function counts do
not establish execution, attribution or cycle charges.

## Focused qualification and limitations

Actual Linux checks with prepared caches and `RUSTUP_AUTO_INSTALL=0` pass:

- `make fmt`, followed by the selected warning-denied host Clippy gate.
- `make wasm-inspect-check`: host/all-target checks and the named `args::tests`
  and `report::tests`, covering required/excess/invalid arguments, byte/count
  budgets, malformed input, separate output units and typed output failure.
- `make wasm-inspect-msrv`: actual Rust/Cargo 1.88.0 host compilation.
- `make msrv`: actual Rust/Cargo 1.85.0 arithmetic native/Wasm compilation.
- Bare locked offline `cargo check` selects arithmetic; its `cargo tree` contains
  only `ic-metrics`. Adding host dependencies does not add library dependencies.
- Actual binary invocations refuse malformed input, an eight-byte raw limit,
  a directory and missing arguments, each with status 1 and no stdout.
- Consumer release metadata fixtures exercise both local inherited versions,
  preparation refusal, restoration and rejection of a stale private-package row
  before Cargo dispatch, with real locked offline Cargo metadata;
  Cargo-edit and Git effects remain substituted.

The consumer metadata, release-admission and evidence-collector fixtures also
pass under genuine Bash 3.2.57, including that interpreter on PATH for nested
calls. Bash 5.2 passes separately. The untracked private manifest is checked
explicitly through the canonical pin/inheritance checker module, in addition to
the repository's tracked-file gate; its dependency declarations produce no
findings. These are focused tooling fixtures, not a full local CI gate.

Initial Clippy attempts rejected redundant module visibility and an empty-vector
assertion; both were corrected before later validation. Logs and those failed
attempts remain under `target/evidence/wasm-inspection-0215/`. Additional focused
tooling receipts there cover source/archive collection, shell/workflow lint,
snapshot/pins, formatting and documentation links. Frozen archive and checksum
bytes verify unchanged after the new actual inspection.

CI now selects host checks on Linux and both macOS architectures, logs both
package-floor compiler identities on Linux, and includes the new package in its
native source receipts. The release adapter also requires both minimum-version
gates; its admission fixture retains failed host-floor logs before a clean retry.
That configuration is not a completed committed CI run.
No full local product-test or CI gate was executed. Output failure may leave a
partial stream; only successful exit admits completed evidence. No sibling edits,
measurement-policy change, Rustup target management or archive-reader replacement
is implemented by this tool.
