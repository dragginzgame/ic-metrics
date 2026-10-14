# Host inspector repair qualification for 0.9.4

This batch starts from released Metrics 0.9.3
`61f4a235c39386c649b6f878407e9c87ebfe17e6` with the existing uncommitted
Shared Tooling 0.12.2 convergence preserved. Only the selected inspector adapter
changes among its 106 guarded source/configuration inputs.

## Diagnosis and selection

[Released-source run 38530414943](https://github.com/dragginzgame/ic-metrics/actions/runs/38530414943)
passes Linux native CI and both package floors. The checksummed small diagnostic
archives identify the same setup failure on
[Intel](https://github.com/dragginzgame/ic-metrics/actions/runs/38530414943/job/115740687640)
and [Apple Silicon](https://github.com/dragginzgame/ic-metrics/actions/runs/38530414943/job/115740687216):
Host filesystem 0.17.4 passes `u32` permissions to Darwin's `u16` mode constructor.
Neither macOS job reaches application preparation or native CI.

Metrics selects non-yanked published `ic-host-wasm-inspect` 0.17.10 through the
existing managed installer. Its registry archive SHA-256 is
`76abfbacfcdf4f3c17b18f6b9bb4cc9a3644f687d10940dc8b7e8848650979f8`.
The packaged lock selects Host filesystem/artifacts 0.17.10; filesystem archive
SHA-256 is `5c72da59948eba149a222daaaf6d8bf1ae09a2c2da3ed0df86b84f41b296bfb9`.
Both package provenance records identify Host source
`330c015e16318eab169cb70424c43c241e3c0093`. Retained staging uses the existing
checked native-permissions owner, including Apple narrowing after admission.
[Host #84](https://github.com/dragginzgame/ic-host-tooling/issues/84) owns the
producer repair; [Metrics #78](https://github.com/dragginzgame/ic-metrics/issues/78)
owns this consumer selection and native acceptance.

## Qualification and limits

Explicit installation, offline tool admission and actual empty-Wasm report
dispatch pass. Full `make ci`, `make msrv` and `make stable-msrv` pass with all
106 guarded inputs unchanged. The preceding inspector installation, incoming
Git index and refs remain retained/unchanged. Library dependencies, package
versions, APIs, Rust floors and stored V1 bytes do not change.

The [scoped receipt](host-inspector-094.tar.gz) and
[checksum](host-inspector-094.tar.gz.sha256) retain before/after consumer inputs,
official package archives/lock/provenance, tool admission and complete gate logs,
and the original hosted diagnostic archives. Private sibling sources and issue
bodies are excluded. This is local Linux qualification; hosted macOS execution
of the delivered selection remains required. No IC cost, Wasm-size improvement,
agent commit, release, publication or workflow dispatch is claimed.
