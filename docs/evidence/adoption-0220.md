# Single-document pinning exceptions

The compatible pending 0.2.20 batch starts from released Metrics
`429748e4877fa799b164bd2df1d9a76bb0acecb6`. Its unchanged 89-file selection
refreshes through the canonical distribution helper from clean committed Shared
Tooling `926a20606591214ab29faa236b0b584e4857439e`. The sibling's uncommitted VERSION
edit is not copied. This adopts the committed checker fix, not a claim of
published Shared Tooling 0.1.38.

[Shared Tooling #86](https://github.com/dragginzgame/shared-tooling/issues/86)
fixes exception-catalog admission: jq slurps the input and requires exactly one
JSON document before validating its array/schema. This prevents the admitted
document from differing from the entries subsequently used for suppression.
Valid single-array exceptions retain their existing behavior. Metrics currently
selects no exception catalog; its default empty array passes. No dependency
selection, Rust source, public arithmetic contract or release adapter changes.

Focused Linux checks pass under Bash 5 and genuine Bash 3.2.57: canonical pin
fixtures reject malformed/duplicate/valid catalogs combined with a second
document in either order, preserve manifest/lock/index/exception bytes on refusal,
and retain valid exception behavior. Snapshot verification, actual workspace pin
checks and ShellCheck pass. Every selected file matches the committed upstream
distribution source; the initial lock hash is unchanged. Logs and source receipts
remain under `target/evidence/adoption-0220/`.

[Exact upstream CI](https://github.com/dragginzgame/shared-tooling/actions/runs/37912382208)
passes lint/security and Linux portable qualification at inspection; both macOS
jobs are queued. These focused local/substitute fixtures and upstream
observations do not establish complete committed consumer native acceptance.
Package/workspace versions remain 0.2.19. No symbol is removed, no broad local
gate runs, and no tool installation, sibling edit, commit or release occurs.
