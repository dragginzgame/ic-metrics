# Memory 0.49.1 focused qualification

Scope: the working tree based on Metrics release source
`a9c7789910cf5040788d14b3c2206a559dba4af1`, with the incoming lock update to
Memory 0.49.1, unchanged Storage 0.5.7 and the test-only ratio oracle.
This is focused Linux qualification, not a release or publication receipt.

## Dependency identity

The selected registry Memory 0.49.1 archive checksum is
`a857c52a74ca36b18deeeebe2513fcb38484f013f0804aa6a24371cefd7d0bb5`.
Comparison of the cached official 0.49.0 and 0.49.1 packages finds all 49 `src/`
files and the README included by the library byte-identical. Normal dependencies,
features and the declared Rust floor also match. Manifest differences select
newer upstream development tooling and the package's own version.
This comparison does not assert identical compiled artifacts or IC costs.

The oracle uses `num-bigint` 0.5.1 with default features disabled as an arithmetic
development dependency, plus its three locked support packages. Previously
selected production registry versions and checksums are preserved. Both product APIs,
Metrics V1 encoding and advertised Rust 1.91 floors remain unchanged.

## Focused results

- All six ratio tests pass. The independent arbitrary-precision reference checks
  floor and nearest rounding for 55,297 parameter triples, covering every
  numerator bit boundary, selected denominator/scale boundaries and deterministic
  mixed-bit values. Products may require 192 bits; the reference multiplies
  before division rather than repeating the production quotient decomposition.
- All 22 stable package unit tests and three doctests pass against the new lock.
- Strict arithmetic native all-target Clippy and stable native all-target/Wasm
  library Clippy pass. Rust 1.91 checks the arithmetic package's native test
  targets, including the new oracle dependency.
- Native/Wasm production dependency admission and its exclusion fixtures pass.
  Arithmetic has no normal/build dependencies; the oracle is absent from both
  production graphs.

Logs are retained under `/tmp/metrics-0148-*.log`; the source-file hash roster is
`/tmp/metrics-0148-qualification/memory-library-source.sha256`.
The ratio, strict arithmetic Clippy, Rust-floor and production exclusion checks
are repeated for `num-bigint` 0.5.1 in `/tmp/metrics-bigint05-*.log`.
No full CI, complete package-floor gate, native macOS execution or new IC
measurement is claimed. The [frozen IC comparison](memory-0147.md) retains its
original Memory 0.49.0 identity and measurements; its archive is unchanged.
