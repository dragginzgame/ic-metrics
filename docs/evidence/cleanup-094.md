# Durable codec and evidence-fixture cleanup for 0.9.4

The task starts at released 0.9.3
`61f4a235c39386c649b6f878407e9c87ebfe17e6`, preserving incoming uncommitted
Shared Tooling 0.12.2 convergence and Host inspector 0.17.10 selection.
Before-images distinguish this cleanup from those earlier prepared changes.
Package versions, library dependencies, public store APIs and V1 bytes stay fixed.

## Converged flows

The sealed payload-size operation owns static size admission. Both public store
entrypoints invoke it before reading a row; save carries the result into the
encoder. The common private load path retains identity, configuration and
corruption admission. Sealed state writing follows admitted size without another
fallible bound conversion. The record budget remains checked before allocation;
stored records independently retain their format, size, numeric and trailing-byte
checks. Identical checkpoints still validate before skipping encoding/writes.

Fixed-width decoding uses one fixed-size chunk split. Truncated fields return
`MalformedRecord`; failed splits do not advance the input. Variable-length
envelope fields retain their separate bounded slicing.

The native-evidence fixture copies source/helper roots rather than the whole
checkout. It still executes actual workflow bodies, and the source-hash step
refuses omitted tracked workflow inputs. All 18 success/failure scenarios retain
source, log, archive, original-status and Git index/intent assertions. At the
recorded working tree, the former whole-checkout selection contains 415 files /
38,559,277 bytes; the scoped selection contains 106 files / 810,160 bytes.
These are selected-file sizes, not timings or IC cost measurements.

## Qualification and receipt

Formatting, native/all-target and Wasm Clippy with denied warnings, all 14 stable
tests and capability doctests pass. The actual evidence fixture passes on modern
Bash and Bash 3.2; ShellCheck passes. Full `make ci`, `make msrv` and
`make stable-msrv` pass with all 106 guarded source/configuration inputs unchanged.
The product lock, incoming index and Git refs remain unchanged.

A frozen native probe compares public store output before/after for twelve
aggregate, summary and histogram states, including empty/zero, wide totals,
sticky overflow, latest observations and the maximum bound count/unit length.
All V1 record bytes agree. The probe uses the unchanged workspace lock and
`VectorMemory`; it supplies no IC instructions/cycles, upgrade proof or Wasm-size
claim. Existing native tests retain independent restoration/refusal assertions.
Fresh archive extraction reproduces both sets in separate Cargo target directories.
The initial shared-target replay did not recompile the after source; that limited
attempt and the corrected fresh build are retained separately.

The [scoped archive](cleanup-094.tar.gz) and
[checksum](cleanup-094.tar.gz.sha256) retain before/after owner inputs, the frozen
probe, exact records, source hashes and complete validation logs. Private sibling
sources and issue bodies are excluded. Existing evidence keeps its original
identities; this uncommitted local qualification does not establish hosted macOS
acceptance. No staging, commit, release, publication or sibling edit is performed.
