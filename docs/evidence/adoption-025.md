# Shared Tooling 0.1.14 adoption for pending 0.2.5

This compatible tooling update is prepared on released consumer source
`21e980b3ed4f1a8d9b6203079ef1e457a3fea588` (0.2.4). The owning issue is
[#14](https://github.com/dragginzgame/ic-metrics/issues/14), adopting the correction
in [Shared Tooling #30](https://github.com/dragginzgame/shared-tooling/issues/30).
Rust source, Cargo versions/lock, graph and tool pins remain unchanged.

## Reviewed source and distribution

The snapshot records `25e7ce83149e081e4dcc52c55c33724e44153f2a` (0.1.14),
matching inspected upstream main. A separate clean detached checkout exported
only committed source through the real distribution helper. The existing
56-file manifest explicitly adds `scripts/ci/check-make-execution.sh`, producing
57 files. No snapshot-owned implementation was patched. AGENTS records the
same source, and every declared file is independently compared with that source.

The release runner, validation logger, pre-commit hook, hook installer and
formatting qualification helper require the new guard. The logger copies it
beside its own immutable temporary script copy. Owned release-admission fixtures
copy both dependencies, and independent fixtures clear their Make controls.
The native workflow's explicit source receipt includes the new helper.

The refreshed governance permits application-owned `apps/` packages alongside
`crates/`, sharing one virtual root and inherited metadata/dependencies. This
library already conforms and needs no moves. Current IC Host Tooling package
owners are corrected in provisioning/provenance docs; historical attribution is
preserved. Uncommitted upstream 0.1.15 sibling LOC work is outside this adoption.

## Focused local qualification

The selected consumer tooling checks ran under real GNU Bash 3.2.57 on Linux
with locked offline Cargo metadata/formatting and prepared tools:

- `make release-tools-check hook-check`: shared release-mode/destination/recovery
  cases, consumer release/publication adapters with command substitutes, metadata
  preparation/rollback, selected-commit admission and actual Make/logger behavior.
- Six bad inherited Make modes at the current consumer logger: ignore-errors,
  dry-run, question, touch, version-only and the long ignore-errors alias. Each
  rejects before the fixture gate writes an event and never announces validation
  success. No real release or full CI is dispatched by these fixtures.
- Twelve consumer retention scenarios preserve expected failed inputs/output;
  successful scratch cleanup retains the existing contract.
- Actual consumer formatting/hook fixtures preserve unrelated/partial/racing
  selections and lockfiles, and qualify installation without activating the real
  checkout's hook or creating commits.
- Matching committed upstream validation-logger and hook fixtures execute locally,
  checking additional GNU Make aliases, GNUMAKEFLAGS, temporary logger dependency
  copying, normal nested release variables, parallel jobserver controls and hook
  rejection without index/working-file changes.
- Selected ShellCheck and workflow lint pass. Snapshot integrity, direct source
  equality, document links, dependency declarations and formatting pass.

The first successful consumer pass preceded the additional logger cases and CI
receipt change; its log remains separate from `consumer-fixtures-final.log`.
The logger/hook-mode fixture logs identify the committed upstream files, whose
adopted guard/logger/hook bytes match the consumer. These source-owner fixtures
complement the actual consumer adapters; they are not a full consumer CI run.
No failed validation attempt occurred. Command output, Bash identity, clean
checkout identity, old manifest and receipts remain under
`target/evidence/adoption-025/`; the consumer retention fixture also keeps its
controlled failed scenarios under `target/evidence/native-ci/`.

## Hosted and release boundaries

[Upstream CI 37586649650](https://github.com/dragginzgame/shared-tooling/actions/runs/37586649650)
passes Linux, native macOS Intel, native macOS Apple Silicon and lint/security
for the exact adopted source. Published consumer 0.2.4 independently passes its
[own CI](https://github.com/dragginzgame/ic-metrics/actions/runs/37587072330).
Neither run qualifies this uncommitted 0.2.5 consumer batch. Keep its committed
native adoption boundary in [#14](https://github.com/dragginzgame/ic-metrics/issues/14).

The pending changelog selects 0.2.5 because the complete batch fixes unsupported
unsafe Make controls while preserving supported release selections and public
arithmetic contracts. Cargo metadata stays 0.2.4. No full local tests/CI, package
version edits, commits, tags, pushes, publication, hook activation or sibling file
mutations ran. This change makes no IC instruction/cycle/Wasm-size claim.
