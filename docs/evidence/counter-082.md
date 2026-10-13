# Scalar diagnostic counter for pending 0.8.2

The maintainer approved the generic scalar accumulator in
[#68](https://github.com/dragginzgame/ic-metrics/issues/68). The
[six-consumer review](consumer-review-082.md) found event accumulation in Timers
and Toko, and separate byte-total overflow arithmetic in Blob's test probe.
IcyDB/Canic instruction observations and Backup's duration/byte distributions
continue to use aggregates, summaries and histograms.

`MeasurementCounter` retains only a `u128` total and sticky actual-overflow flag.
`ZERO`, exact additions and batch merging preserve zero and exactly reached caps;
`from_parts` rejects a true flag below the cap with the existing typed state
error. `exact_total` and `delta_since` reject actual loss, with decreasing deltas
reported separately. Consumers establish exact input quantities, units, common
counter/window identity and append-only continuity. Narrow report conversion
failure is distinct from source overflow. No sampling, classification, labels,
registration identity, lifecycle, logging or endpoint owner is extracted.

The existing `MeasurementAggregate::record(1)` alternative correctly counts
events, but also retains sample count, total and maximum. The scalar is chosen
for a total that needs no observation statistics and can accept an already exact
wide batch amount. Its addition reuses the existing `add_total` owner; there is
no new overflow algorithm or width-generic framework. This is a semantic scope
choice, without a measured storage/Wasm/instruction/cycle improvement claim.

Seven focused counter tests pass, covering zero, wide quantities/narrowing,
exact caps, sticky loss, duplicate batch attribution, merge loss propagation,
restored-state admission/continuation, delta error precedence and constant
evaluation. Existing aggregate/counter totals agree for admitted `u64` quantity
sequences. Native/Wasm denied-warning Clippy, eight public doctests, documentation
and native/Wasm Rust 1.85 checks pass. The compiled application guide uses the
counter for budget-stop diagnostics; authoritative enforcement stays local.

The optional store still admits exactly aggregate, summary and histogram. All
four stable Rust sources retain their pre-batch hashes, so no stored kind, V1
bytes or collection lifecycle changes. A new durable kind needs a separately
reviewed storage contract. Existing incoming Cargo edits select Host 0.15.1,
Memory 0.35.19 and Syn 3.0.9; this batch preserves those inputs rather than
selecting another graph. Package metadata stays 0.8.1; additive pre-1.0 APIs
select compatible pending 0.8.2 notes. No sibling edit, Git index/ref or release
effect occurs.

Full `make ci` passes in 294 seconds, including all 52 arithmetic tests and
the existing stable/inspector checks. Arithmetic Rust 1.85 native/Wasm, stable
Rust 1.88 native/Wasm and private inspector Rust 1.88 floor gates pass. Eight
checkpoints match the 138 frozen/current validation inputs, including both new
untracked counter files. This qualifies the complete selected local graph;
earlier source/graph and hosted native receipts keep their own identities.

The [frozen receipt](counter-082.public.tar.gz) and [checksum](counter-082.public.tar.gz.sha256)
retain focused/full logs, compiler identities, source/checkpoint hashes, frozen
validation inputs and the public subset of six read-only consumer source reviews.
Original archive readback verifies all validation/consumer bytes and completed
checkpoints. No check fails in this batch. There is no IC performance claim or new owning
consumer adoption/macOS acceptance. No library-owned data reset is required.

The public distribution omits private-consumer material and projects mixed review
records onto the five public consumers. Its `distribution-provenance.json` binds
unchanged retained bytes to the original archive. [The distribution record](archive-distribution-072.md)
identifies the privately retained original/checksum and the remaining published
history scope; this replacement does not establish the omitted consumer
acceptance or qualify a later source or dependency graph.
