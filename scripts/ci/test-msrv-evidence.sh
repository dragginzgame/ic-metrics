#!/usr/bin/env bash
set -euo pipefail
# Execute the actual MSRV workflow bodies and checker; setup/compiler effects are
# substituted. Shared owns generic validation logging, archiving and checksums.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES GIT_DIR GIT_WORK_TREE
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/msrv-evidence.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "MSRV fixture retained"' EXIT
MSRV_FIXTURE_REAL_GIT="$(command -v git)"
export MSRV_FIXTURE_REAL_BASH="$BASH" MSRV_FIXTURE_REAL_GIT
jq="$root/.tools/host/bin/jq"
"$root/.tools/host/bin/yq" -o=json '.jobs.msrv.steps' "$root/.github/workflows/ci.yml" > "$fixture/steps.json"
# shellcheck disable=SC2016 # GitHub expressions and jq strings remain literal.
"$jq" -e '
    (map(.id) | index("checkout")) < (map(.id) | index("inputs")) and
    (map(.id) | index("inputs")) < (map(.id) | index("host_tools")) and
    (map(.id) | index("host_tools")) < (map(.id) | index("toolchain")) and
    (map(.id) | index("toolchain")) < (map(.id) | index("application_sources")) and
    (map(.id) | index("application_sources")) < (map(.id) | index("check")) and
    (map(.id) | index("check")) < (map(.id) | index("artifacts")) and
    (map(select(.id == "artifacts"))[0].if == "always() && steps.checkout.outcome == '\''success'\''") and
    (map(select(.id == "artifacts"))[0].env == {
        "INPUT_OUTCOME": "${{ steps.inputs.outcome }}",
        "HOST_TOOLS_OUTCOME": "${{ steps.host_tools.outcome }}",
        "TOOLCHAIN_OUTCOME": "${{ steps.toolchain.outcome }}",
        "APPLICATION_SOURCES_OUTCOME": "${{ steps.application_sources.outcome }}",
        "MSRV_OUTCOME": "${{ steps.check.outcome }}"
    }) and
    (map(select(.id == "check"))[0].env == {
        "VALIDATION_LOG_DIR": "${{ github.workspace }}/target/evidence/msrv-ci",
        "VALIDATION_FAILURE_LOG_DIR": "${{ github.workspace }}/target/evidence/msrv-ci/failures",
        "ALLOCATION_FREE_EVIDENCE_ROOT": "${{ github.workspace }}/target/evidence/msrv-ci",
        "TMPDIR": "${{ github.workspace }}/target/evidence/msrv-ci/scratch"
    }) and
    (map(select(.uses != null and .with.name == "msrv-${{ github.run_attempt }}"))[0] |
        .if == "always() && steps.checkout.outcome == '\''success'\''" and
        .with.path == "target/evidence/msrv-ci.tar.gz\ntarget/evidence/msrv-ci.tar.gz.sha256\n" and
        .with["retention-days"] == 30 and .with["if-no-files-found"] == "error")
' "$fixture/steps.json" > /dev/null
for step in inputs host_tools toolchain application_sources check artifacts; do
    PATH="${jq%/*}:$PATH" bash "$root/scripts/ci/extract-workflow-step.sh" "$fixture/steps.json" "$step" > "$fixture/$step.sh"
done
mkdir "$fixture/bin"
printf '#!%s\n' "$BASH" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
case "${1:-}" in
    scripts/dev/install-host-tools.sh)
        echo host-setup-output
        [[ "$MSRV_FIXTURE_SCENARIO" != host-failure ]] || exit 43
        exit 0 ;;
    scripts/dev/prepare-rust-toolchain.sh)
        echo minimum-toolchain-setup-output
        [[ "$MSRV_FIXTURE_SCENARIO" != toolchain-failure ]] || exit 47
        exit 0 ;;
esac
exec "$MSRV_FIXTURE_REAL_BASH" "$@"
BASH
cat > "$fixture/bin/git" <<'GIT'
#!/usr/bin/env bash
if [[ "$MSRV_FIXTURE_SCENARIO" == inputs-failure && "$1" == rev-parse ]]; then exit 41; fi
exec "$MSRV_FIXTURE_REAL_GIT" "$@"
GIT
cat > "$fixture/bin/cargo" <<'CARGO'
#!/usr/bin/env bash
set -euo pipefail
[[ "$1" != +* ]] || shift
case "$1" in
    --version) echo 'cargo fixture-minimum-compiler' ;;
    fetch)
        [[ "$*" == 'fetch --locked' ]]
        echo locked-application-sources-output
        [[ "$MSRV_FIXTURE_SCENARIO" != sources-failure ]] || exit 49 ;;
    rustc)
        [[ "$MSRV_FIXTURE_SCENARIO" != link-failure ]] || exit 39
        mkdir -p target/wasm32-unknown-unknown/debug/examples
        printf 'newly linked fixture artifact\n' > target/wasm32-unknown-unknown/debug/examples/arithmetic-no-allocator.wasm ;;
    check)
        [[ "$MSRV_FIXTURE_SCENARIO" != before-link ]] || exit 37
        if [[ "$MSRV_FIXTURE_SCENARIO" == after-link && "$*" == *--all-targets* ]]; then exit 38; fi ;;
esac
CARGO
printf '#!%s\necho "rustc fixture-minimum-compiler"\n' "$BASH" > "$fixture/bin/rustc"
chmod +x "$fixture/bin/"*

for scenario in success inputs-failure host-failure toolchain-failure sources-failure before-link link-failure after-link cancelled; do (
    work="$fixture/$scenario"
    mkdir -p "$work/.github/workflows" "$work/target/wasm32-unknown-unknown/debug/examples"
    bash "$root/scripts/ci/prepare-script-fixture.sh" "$root" "$work" \
        scripts/ci/record-native-inputs.sh scripts/ci/collect-msrv-evidence.sh \
        scripts/ci/run-validation-targets.sh scripts/ci/check-allocation-free.sh \
        scripts/ci/check-msrv.sh scripts/ci/read-cargo-workspace-rust-version.sh
    cp "$root/Cargo.toml" "$root/Cargo.lock" "$work/"
    cp "$root/.github/workflows/ci.yml" "$work/.github/workflows/"
    printf '/target/\n' > "$work/.gitignore"
    printf 'msrv:\n\t+bash scripts/ci/check-msrv.sh\n' > "$work/Makefile"
    # A failed check must never collect an artifact left by an earlier build.
    printf 'stale artifact\n' > "$work/target/wasm32-unknown-unknown/debug/examples/arithmetic-no-allocator.wasm"
    git -C "$work" init -q
    git -C "$work" add Cargo.toml Cargo.lock Makefile scripts .github .gitignore
    git -C "$work" -c user.name=Fixture -c user.email=fixture@example.invalid commit -qm seed
    cd "$work"
    export PATH="$fixture/bin:${jq%/*}:$PATH" YQ="$root/.tools/host/bin/yq"
    export MSRV_FIXTURE_SCENARIO="$scenario" GITHUB_RUN_ID=fixture GITHUB_RUN_ATTEMPT=1 GITHUB_EVENT_NAME=pull_request
    export VALIDATION_LOG_DIR="$work/target/evidence/msrv-ci" VALIDATION_FAILURE_LOG_DIR="$work/target/evidence/msrv-ci/failures"
    export ALLOCATION_FREE_EVIDENCE_ROOT="$work/target/evidence/msrv-ci" TMPDIR="$work/target/evidence/msrv-ci/scratch"
    export INPUT_OUTCOME=skipped HOST_TOOLS_OUTCOME=skipped TOOLCHAIN_OUTCOME=skipped APPLICATION_SOURCES_OUTCOME=skipped MSRV_OUTCOME=skipped
    status=0
    for step in inputs host_tools toolchain application_sources check; do
        if [[ "$scenario" == cancelled && "$step" == check ]]; then MSRV_OUTCOME=cancelled; break; fi
        "$MSRV_FIXTURE_REAL_BASH" --noprofile --norc -e -o pipefail "$fixture/$step.sh" > "$work/$step.log" 2>&1 || status=$?
        outcome=success
        [[ "$status" == 0 ]] || outcome=failure
        case "$step" in
            inputs) INPUT_OUTCOME="$outcome" ;;
            host_tools) HOST_TOOLS_OUTCOME="$outcome" ;;
            toolchain) TOOLCHAIN_OUTCOME="$outcome" ;;
            application_sources) APPLICATION_SOURCES_OUTCOME="$outcome" ;;
            check) MSRV_OUTCOME="$outcome" ;;
        esac
        [[ "$status" == 0 ]] || break
    done
    if [[ "$scenario" == success || "$scenario" == cancelled ]]; then [[ "$status" == 0 ]]; else [[ "$status" != 0 ]]; fi
    "$MSRV_FIXTURE_REAL_BASH" -e -o pipefail "$fixture/artifacts.sh" > collection.log 2>&1
    bash scripts/ci/verify-file-checksum.sh sha256 "$(cat target/evidence/msrv-ci.tar.gz.sha256)" \
        target/evidence/msrv-ci.tar.gz > checksum.log
    mkdir replay
    tar -xzf target/evidence/msrv-ci.tar.gz -C replay
    printf 'inputs=%s\nhost_tools=%s\ntoolchain=%s\napplication_sources=%s\nmsrv=%s\n' "$INPUT_OUTCOME" "$HOST_TOOLS_OUTCOME" "$TOOLCHAIN_OUTCOME" "$APPLICATION_SOURCES_OUTCOME" "$MSRV_OUTCOME" > expected-outcome
    cmp expected-outcome replay/outcome.txt
    if [[ "$INPUT_OUTCOME" == success ]]; then
        (cd "$work"; shasum -a 256 -c replay/source-sha256.txt) > source-check.log
        grep -F scripts/ci/check-msrv.sh replay/source-sha256.txt > /dev/null
    fi
    if [[ "$HOST_TOOLS_OUTCOME" != skipped ]]; then grep -Fx host-setup-output replay/host-tools.log > /dev/null; fi
    if [[ "$TOOLCHAIN_OUTCOME" != skipped ]]; then grep -Fx minimum-toolchain-setup-output replay/toolchain.log > /dev/null; fi
    if [[ "$APPLICATION_SOURCES_OUTCOME" != skipped ]]; then grep -Fx locked-application-sources-output replay/application-sources.log > /dev/null; fi
    if [[ "$MSRV_OUTCOME" == success || "$MSRV_OUTCOME" == failure ]]; then
        logs=(replay/validation.*/0.log)
        [[ ${#logs[@]} == 1 && -f "${logs[0]}" ]]
        grep -F fixture-minimum-compiler "${logs[0]}" > /dev/null
    fi
    case "$scenario" in
        success|after-link)
            printf 'newly linked fixture artifact\n' > expected-artifact
            cmp expected-artifact replay/arithmetic-no-allocator.wasm ;;
        *) [[ ! -e replay/arithmetic-no-allocator.wasm ]] ;;
    esac
); done
echo 'MSRV source/setup/check outcomes, retained logs and source-bound link artifacts passed (compiler/setup effects substituted)'
fixture_complete=true
