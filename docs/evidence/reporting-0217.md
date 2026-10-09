# Checked reporting projections

The maintainer-authorized compatible 0.2.17 draft starts from released
`d8276daa3ae8603a5b4e196d0bb5369de54c1216`. Package versions remain 0.2.16;
the pre-existing Host 0.8.5 lock is preserved byte-for-byte with SHA-256
`e8a722e7d091202e9888ed76c66a4cb1dc4c357826009f2290dddcb8b79c6afb`.
The source-bound [sibling audit](../reports/audits/2026/10/09/measurement-needs/01/report.md)
establishes the Backup chunk distribution and Testkit wide-reporting motivations.

The additive queries use existing histogram storage. Cumulative counts validate
only their finite-bound prefix. Quantile ranges use exact rational nearest rank,
reject required count saturation and preserve usable counts after value-total
saturation. The new scaled-ratio function splits quotient/remainder, so a
representable final result survives an overflowing naive product. It accepts
already admitted exact inputs rather than inferring saturation provenance.
No recording function, state layout, existing mean or consumer format changes.

Actual locked offline Linux checks pass with prepared tools:

- `make fmt`, then warning-denied host/all-target and Wasm `make clippy`.
- Named histogram, ratio and existing summary tests on Rust 1.99.
- Actual Rust 1.85 host/Wasm `make msrv`, followed by the named histogram/ratio
  tests and all six compiled documentation examples on that compiler.
- Warning-denied host/Wasm Rustdoc and the same documentation examples on 1.99.
- Documentation links, snapshot integrity, dependency-free core Cargo tree and
  whitespace checks.

Tests cover empty/zero, finite prefix selection, caps and overflowing cumulative
counts, rational ranks, overflow/no bounds, maximum upper bounds, total saturation,
constant evaluation, ratios above floating-point precision and final/intermediate
overflow. Initial Clippy rejected documentation formatting, unnecessary lint
expectations, a let-else style and a late test constant; these were corrected
before further validation. No remaining selected-gate warnings occur.

Logs and source hashes are retained under `target/evidence/reporting-0217/`.
These are arithmetic/compilation results, not new IC instruction/cycle or Wasm-size
measurements. Existing performance evidence remains historical. No sibling source,
dependency selection, public output, full local CI, commit, push, tag or release
is changed by this implementation. Configured native qualification of future
committed source and publication remain distinct from these local checks.
