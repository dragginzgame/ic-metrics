# Shared Tooling 0.9.2 adoption for pending 0.7.4

Canonical refresh from a clean detached checkout adopts committed/public
`c118062a070a2e238f1eb3989b6fd700f369ce1e`. Nine payloads update and 92 remain
unchanged. All 101 files and 89 explicit roots remain selected; preview reports
no additions or removals. Product Rust, Cargo metadata/lock, tool pins and Git
index retain their original hashes. The base commit remains released 0.7.3
`e714085a972db88c348e4aabe57847f2124d2b97`.

Host/IC installers share upstream lock, verified-cache reuse and cleanup.
Cleanup failure preserves the original setup error and still releases the shared
lock. Evidence checksum manifests reject NUL before hashing; installers reject
supplied/resolved CR/LF paths before configuration or setup. Existing supported
commands and active prepared tool selections remain unchanged.

Exact-source snapshot distribution and installer-path fixtures pass. Selected
scripts with their declared Cargo build companion pass ShellCheck 0.11.0. The
initial incomplete lint selection and its diagnostics remain retained alongside
the complete passing selection; it required no source repair.

Full `make ci` passes in 249 seconds. All package-floor gates pass: arithmetic
Rust 1.85 on native/Wasm, optional store Rust 1.88 on native/Wasm, and private
inspector Rust 1.88 on its native host. Every gate checkpoint matches its baseline
and current canonical inputs. This is local Linux delivery qualification;
command-substitute platform fixtures do not establish new macOS hosted results
or IC measurement evidence.

The [frozen receipt](adoption-074-shared-092.tar.gz) and
[checksum](adoption-074-shared-092.tar.gz.sha256) retain both manifests, preview,
focused/full gate logs, checkpoints, 134 source inputs and verification records.
The earlier [root-selection receipt](snapshot-roots-074.tar.gz) keeps its exact
Shared 0.9.0 scope. The [historical handoff](../status/history-through-073.md)
preserves all earlier handoff text verbatim, with relative links intact; the
[current handoff](../status/current.md) records current authority.

Package metadata remains 0.7.3; the compatible pending notes remain 0.7.4.
No sibling edit, staging, commit, tag, push, release or publication occurs.
