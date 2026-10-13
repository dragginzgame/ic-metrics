# Admitted mean errors and raw Wasm shape for pending 0.9.0

This authorized [#69](https://github.com/dragginzgame/ic-metrics/issues/69) cut
starts from clean released `0baae3a49b0bb2c42b32dfe8005b33d07e7e11d7`.
The reviewed Shared Tooling 0.9.10 module-surface/cleanup methods and Metrics
overlay govern arithmetic, public errors, restoration, callers and size evidence.
Package versions, dependency selections, pins and real Git index/ref stay fixed.
The public variant removal selects minor 0.9.0 notes, without release effects.

An admitted exact count bounds total by `samples * maximum <= u64::MAX²`.
Recording/merging preserve this, and restoration requires total overflow to carry
sample overflow. Count admission therefore excludes total overflow in means and
intervals. For nonempty scaled means, the result is bounded by `maximum * scale`;
quotient/remainder decomposition avoids overflowing the intermediate total product.
The remainder and scale each fit `u64`, and their product fits `u128`.

The cut removes unreachable mean total/projection and interval total cases and
their branches. Mean errors now belong with their projection owner. Scalar
counter actual-total-overflow and generic ratio denominator/result-overflow errors
remain live. Tracked flags, restored-state admission, empty/zero distinctions,
count-first rejection, exact caps and stable V1 bytes remain unchanged. No data
reset, fallback, alias, production panic or unchecked arbitrary-input admission
is introduced. Callers update matches or construction of the removed variants.

The existing scaled-observation check now uses an independent standard midpoint
oracle. Restored count/total endpoints cover sparse, full and just-below-full
totals across small/maximum counts, maxima and scales. Const, invalid restoration,
both-snapshot interval rejection and scale-zero overflow checks pass.

Matched standalone probes compile with Rust 1.99.0, `wasm32-unknown-unknown`,
opt-level z, fat LTO, one codegen unit, abort panic and stripped symbols:

| Probe | Released bytes | Candidate bytes | Change |
| --- | ---: | ---: | ---: |
| Integer mean | 1,955 | 1,945 | −10 |
| Scaled mean | 2,162 | 2,081 | −81 |
| Interval mean | 1,968 | 1,958 | −10 |
| Generic ratio | 1,915 | 1,915 | byte-identical |
| Recording | 351 | 351 | byte-identical |
| Histogram restoration control | 629 | 629 | byte-identical |

These separate wrapper modules are scoped raw byte evidence; their changes must
not be added into an application saving or treated as IC instructions/cycles.
A narrowing experiment saved only two further bytes and was rejected; its
sources/results remain retained. The final code keeps wide arithmetic operands.

Six frozen read-only consumer sources have no matches/construction of removed
errors. The copied IcyDB numeric DTO fields, getters and conversion pass a native
projection test and warning-denied Rust 1.85 Wasm compilation; transport derives
and whole-consumer/platform acceptance are excluded. Toko still uses the prior
raw recording helper; its existing adoption issue receives that scoped finding.
Owning 0.9 adoption feedback preserves earlier completed acceptance and requires
publication before registry selection. No sibling source edit/build is performed.

Focused Clippy, arithmetic/restoration/ratio tests, doctests and test-floor checks
pass. Full CI passes in 299 seconds; core, stable and inspector floor gates pass
in 1, 13 and 3 seconds. Eight checkpoints agree on all 140 frozen/current inputs.
Initial lint failures and the fixture-only unused-field observation are retained
alongside their corrected passing outcomes. Library/native checks establish no
later macOS or actual application acceptance.

The [frozen receipt](error-cut-090.tar.gz) and
[checksum](error-cut-090.tar.gz.sha256) retain exact before/after inputs, probes,
compiler identities, results, rejected experiment, consumer source observations,
issue feedback and complete validation logs. Archive readback verifies payloads,
source checkpoints and all final Wasm hashes. Historical evidence is untouched.
