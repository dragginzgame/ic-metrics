# Tooling convergence qualification for 0.9.4

Metrics starts at finalized 0.9.3 `61f4a235c39386c649b6f878407e9c87ebfe17e6`.
Shared Tooling starts at 0.12.1 `acf7fc3ca99fb3b5288bbf9316cacd21f3d64e39`.
The maintainer committed the canonical collector and metadata edge cases in
0.12.2 `cff186285829481185e932d3c16514022b897de9`; Metrics exports that exact
clean committed source through the upstream distributor, with 114 payloads.
Selected tool pins, product dependencies, APIs and V1 bytes are unchanged.

## Converged owners

Generic metadata failure, restoration and note-byte cases live in Shared
Tooling's canonical fixture. Metrics' 129-line integration keeps two-package
preparation, stale adapter refusal and entrypoint dispatch. Its controlled Cargo
version edit and Git/Make effects perform no real release; locked offline Cargo
metadata remains real. The intentionally rejected lock's scratch evidence is
nested under the invocation owner before successful cleanup.

The shared collector owns selector invocation, diagnostic status, NUL selection
consumption and candidate archiving for both the shared action and Metrics.
Consumers retain explicit logs, outer Git custody, checksum/upload composition
and retention. A partial admitted collection remains nonzero; archive failure
retains original inputs. Metrics' small diagnostics are still collected first,
and its outer archive preserves fixture Git index and release intent.

Consumer cleanup uses the shared helper after resolving each scratch directory
physically. Local wrappers print relevant diagnostics; common completion/status
and deletion logic converge. Fixtures intentionally retaining success are kept.

## Qualification and limits

Shared focused metadata, host/IC collection/readback fixtures and ShellCheck
pass. Its first full portable suite exposed a wildcard version substitution in
the tooling inventory fixture: the pattern also changed the new commit hash.
The reviewed one-line literal-match correction, full portable rerun and complete
CI/development/distribution ShellCheck pass. That fixture fix remains separately
tracked at [Shared #175](https://github.com/dragginzgame/shared-tooling/issues/175);
the adopted production helpers remain byte-identical to committed 0.12.2.

The new release guide references a publication guide absent from the ordinary
export closure. Metrics explicitly selects that document and its link gate
passes; no optional publication command is activated. The producer correction
belongs to [Shared #176](https://github.com/dragginzgame/shared-tooling/issues/176).
The frozen record excludes unrelated Shared governance and changelog edits.

Metrics full `make ci`, arithmetic `make msrv` and adapter `make stable-msrv`
pass on native/Wasm floors 1.85/1.88, with all 106 source/configuration inputs
unchanged. Local ShellCheck, actionlint, metadata, retention and native archive
fixtures pass. Both canonical and consumer metadata fixtures execute under
Bash 3.2. This is Linux/substitute-effect qualification, not hosted macOS or IC
cost evidence; no Rust source or canister behavior changes.

The [scoped receipt](tooling-convergence-094.tar.gz) and
[checksum](tooling-convergence-094.tar.gz.sha256) retain exact owner sources,
locks, identities and passed/failed logs. They contain no private sibling code
or issue bodies. Existing evidence retains its original source and domain.
No agent staging, commit, version change, tag, push or publication is performed.
