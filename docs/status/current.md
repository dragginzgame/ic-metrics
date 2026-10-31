# Current handoff — 2026-10-30

Source base is release 0.21.0, `ffdf7c9`. The incoming checkout had only the
maintainer-requested changelog clarification for the accidental repeat release.
That note remains intact. Workspace metadata is 0.21.0 and Wire/Wire Derive stay
at 0.10.0. Neither own versions nor dependencies changed in this batch.

## Accepted work and current state

The maintainer accepted the first three improvement candidates: reconcile release
documentation, execute generated Metrics TypeScript codecs and vary the logging
model's operation schedules. All three are implemented locally and uncommitted.
Pending notes select compatible patch 0.21.1 for testing/documentation changes;
no public API, arithmetic, retained-data layout or production runtime changed.
The optional truncation cleanup was outside the selected first-three batch.

README, package guide, compiled application prose and the
[0.20–0.21 migration guide](../migration-020.md) now describe the released contract
instead of calling 0.20 pending. The guide explains that 0.21 repeats 0.20, and
shows Metrics 0.21 with Wire 0.10. Registry availability is not inferred from Git
release records. Native report graphs still need one Metrics/Wire identity.

## Rust/TypeScript report conformance

`make typescript-check` runs one explicitly selected Node-dependent Rust test.
The test generates codecs and writes the TypeScript runtime exported by the
locked Wire crate. Node's transform-types flag executes these files directly;
there is no copied codec, sibling source input, npm package or npm install step.
The exact prepared Node version is owned by `ci/node-version.txt` (24.21.0).

Five independent Rust/JavaScript report values cover empty/zero, wide totals,
exact caps and actual overflow, composing aggregates, counters, summaries and a
37-bound histogram. Rust bytes decode to the expected JS values, JS encoding
matches Rust bytes, and Rust decodes the JS output back to the expected report.
Truncated payloads and wrong fixed-array lengths receive typed Wire rejections.
This establishes structural codec parity, not browser-side arithmetic admission;
canonical Rust restoration remains the numeric validation boundary.

The test is ignored by ordinary Rust suites and MSRV checks, which need no Node.
A separate Linux CI job prepares pinned Node and Rust, fetches locked sources,
runs the focused Make target and retains its generated inputs/outputs. Node setup
is explicit; validation refuses a missing/mismatched runtime without installing it.
See [host commands and scope](../hosts.md#prerequisites-and-focused-checks).

## Logging model

The original fixed mixed-operation schedule remains. The same independent event
journal also checks eight fixed-seed schedules, each 256 operations, across the
existing count/text/UTF-8 bounds and normal/nearly exhausted sequence identities.
Schedules vary append/refusal, pruning, restoration and cursor interactions.
Wrapping u64 generation is deterministic and adds no dependency or clock input.
A failed run prints its seed so the same operation order can be replayed.

## Validation and remaining boundaries

Evidence is `target/audits/repo-improvements-021-20261030/`; generated codec inputs,
Node stdout/stderr and encoded output remain in `target/typescript-conformance/`.
Formatting, strict focused library/test Clippy for both packages, both named
logging model tests and the executed five-report conformance test pass on Linux.
Workflow actionlint, documentation links and diff checks pass. The first Clippy
attempt required borrowing the schedule iterator; the initial JS rejection test
expected the wrong error category for array length, then passed with Wire's
actual typed `limit` contract. Failure diagnostics were retained separately.

No full CI/MSRV suite, hosted workflow, macOS execution, browser, installed IC
runtime, release or publication ran. The TypeScript check executes code but does
not perform static TypeScript type checking. Previous Wire-adoption receipts
remain at `target/audits/wire-0100-20261030/`, with their original graph/scope;
`ffdf7c9:docs/status/current.md` preserves that handoff. Shared Tooling stays at
reviewed 0.27.11, revision `62edfbd43087a718bf0283e9040676a49211976d`.

The index and sibling checkouts remain untouched. Existing owning adoption work
is referenced in [the 0.18 migration guide](../migration-018.md); previously
recorded Persistence #141, Canic #715, Jobs #79, Tooling #268, Profiler #13 and
Miner #67 need their current issue state read before resuming. No issue state was
changed or requalified by this batch.
