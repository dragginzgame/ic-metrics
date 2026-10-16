#!/usr/bin/env bash
set -euo pipefail

# Execute the consumer workflow's source/setup/archive bodies with substituted
# action results and Make effects. This proves local IO/status, not hosted execution.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES GIT_DIR GIT_WORK_TREE
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
yq="$root/.tools/host/bin/yq"
jq="$root/.tools/host/bin/jq"
git_dir="$(git -C "$root" rev-parse --absolute-git-dir)"
mkdir -p "$root/target/evidence/native-ci"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-$root/target/evidence/native-ci}/native-evidence.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    fixture_completion_status "$status" "$fixture_complete" || status=$?
    printf 'Native evidence fixture retained: %s\n' "$fixture"
    exit "$status"
}
trap cleanup EXIT
mkdir -p "$fixture/commands" "$fixture/bin" "$fixture/source"
"$yq" -o=json '.jobs.native.steps' "$root/.github/workflows/ci.yml" > "$fixture/steps.json"
# These are live workflow effect boundaries, not checks of display prose.
# shellcheck disable=SC2016 # jq syntax and GitHub expressions must stay literal.
"$jq" -e '
    (map(.id) | index("checkout")) < (map(.id) | index("native_inputs")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("native_host")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("toolchain")) and
    (map(.id) | index("toolchain")) < (map(.id) | index("tools")) and
    (map(.id) | index("prerequisites")) < (map(.id) | index("tools")) and
    (map(.id) | index("tools")) < (map(.id) | index("tool_inputs")) and
    (map(.id) | index("tool_inputs")) < (map(.id) | index("application_sources")) and
    (map(.id) | index("application_sources")) < (map(.id) | index("native_ci")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("prerequisites")) and
    (map(select(.id == "tools"))[0].uses == "./.github/actions/prepare-common-tools") and
    (map(select(.id == "native_artifacts"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''") and
    (map(select(.uses != null and .with.name == "native-${{ matrix.runner }}-${{ github.run_attempt }}"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''")
' "$fixture/steps.json" > /dev/null
for step in native_inputs native_host toolchain tool_inputs application_sources native_ci native_artifacts; do
    PATH="${jq%/*}:$PATH" bash "$root/scripts/ci/extract-workflow-step.sh" \
        "$fixture/steps.json" "$step" > "$fixture/commands/$step.sh"
done
# Shared owns the action body, Make aggregate, leaf ordering and PATH admission.
# Supply only its public outcomes/logs to the actual Metrics collector below.
cat > "$fixture/commands/tools.sh" <<'TOOLS'
set -euo pipefail
printf 'tools\n' >> "$FIXTURE_COMMANDS"
for phase in install check; do
    printf 'tool action stdout: %s\ntool action stderr: %s\n' "$phase" "$phase" \
        > "$RUNNER_TEMP/tools-$phase.log"
    if [[ "$FIXTURE_FAILURE" == "tools-$phase" ]]; then
        mkdir -p .tools/rust
        printf 'retained candidate\n' > .tools/rust/failure:payload
        exit 43
    fi
done
TOOLS
"$yq" -o=json '.jobs.msrv.steps' "$root/.github/workflows/ci.yml" > "$fixture/msrv-steps.json"
PATH="${jq%/*}:$PATH" bash "$root/scripts/ci/extract-workflow-step.sh" \
    "$fixture/msrv-steps.json" toolchain > "$fixture/commands/minimum_toolchain.sh"
# Execute the real workflow setup bodies and selected helper. Shared owns
# generic argument admission; Metrics owns compiler/component/target selection.
mkdir -p "$fixture/rust-bin"
cat > "$fixture/rust-bin/rustup" <<'RUSTUP'
#!/usr/bin/env bash
printf '%s\0' "$@" > "$METRICS_RUSTUP_ARGS"
exit "$METRICS_RUSTUP_STATUS"
RUSTUP
chmod +x "$fixture/rust-bin/rustup"
for lane in development minimum; do
    if [[ "$lane" == development ]]; then
        version="$("$yq" -p toml -o yaml -r '.toolchain.channel' "$root/rust-toolchain.toml")"
        command_file=toolchain
        components=(--component rustfmt --component clippy)
    else
        version="$("$yq" -p toml -o yaml -r '.workspace.package."rust-version"' "$root/Cargo.toml")"
        command_file=minimum_toolchain
        components=()
    fi
    printf '%s\0' toolchain install "$version" --profile minimal \
        ${components[@]+"${components[@]}"} --target wasm32-unknown-unknown > "$fixture/rust-expected"
    for expected_status in 0 49; do
        status=0
        (cd "$root" && PATH="$fixture/rust-bin:$PATH" METRICS_RUSTUP_ARGS="$fixture/rust-actual" \
            METRICS_RUSTUP_STATUS="$expected_status" "$BASH" --noprofile --norc -e -o pipefail \
            "$fixture/commands/$command_file.sh") > "$fixture/rust-$lane-$expected_status.log" 2>&1 || status=$?
        [[ "$status" == "$expected_status" ]] || exit 1
        cmp "$fixture/rust-expected" "$fixture/rust-actual"
    done
done
# Execute the actual host gate with substituted platform observations. Failed
# comparisons must refuse before writing PATH, including on Bash 3.2.
mkdir -p "$fixture/host-bin"
cat > "$fixture/host-bin/uname" <<'UNAME'
#!/usr/bin/env bash
case "$1" in -s) printf '%s\n' "$FIXTURE_HOST_OS"; exit "${FIXTURE_HOST_STATUS:-0}" ;; -m) printf '%s\n' "$FIXTURE_HOST_ARCH" ;; *) exit 2 ;; esac
UNAME
cat > "$fixture/host-bin/sw_vers" <<'VERSION'
#!/usr/bin/env bash
[[ "$1" == -productVersion ]] || exit 2
printf '%s\n' "$FIXTURE_HOST_VERSION"
VERSION
chmod +x "$fixture/host-bin/uname" "$fixture/host-bin/sw_vers"
# Shared owns generic mismatches; retain this workflow's ordering/PATH boundary.
for scenario in success wrong-os failed-observation; do
    host_os=Darwin host_arch=arm64 host_version=15.0 host_status=0
    case "$scenario" in
        wrong-os) host_os=Linux ;;
        failed-observation) host_status=43 ;;
    esac
    expected_status=1
    [[ "$scenario" != failed-observation ]] || expected_status=43
    : > "$fixture/host-$scenario.path"
    status=0
    (cd "$root" && PATH="$fixture/host-bin:$PATH" EXPECTED_OS=Darwin EXPECTED_ARCHITECTURE=arm64 \
        FIXTURE_HOST_OS="$host_os" FIXTURE_HOST_ARCH="$host_arch" FIXTURE_HOST_VERSION="$host_version" \
        FIXTURE_HOST_STATUS="$host_status" \
        GITHUB_PATH="$fixture/host-$scenario.path" "$BASH" --noprofile --norc -e -o pipefail \
        "$fixture/commands/native_host.sh") > "$fixture/host-$scenario.log" 2>&1 || status=$?
    if [[ "$scenario" == success ]]; then
        [[ "$status" == 0 && "$(cat "$fixture/host-$scenario.path")" == /bin ]] || exit 1
    else
        [[ "$status" == "$expected_status" && ! -s "$fixture/host-$scenario.path" ]] || exit 1
    fi
done
# Copy the workflow's source inputs and Make/helper closure, including pending
# untracked helpers. Historical docs/evidence archives are not fixture inputs.
# The live source-hash step below refuses any omitted workflow input.
# No Git write, release, installer, network or product compilation is dispatched.
bash "$root/scripts/ci/native-source-files.sh" > "$fixture/source-files"
while IFS= read -r -d '' path; do
    if [[ -f "$root/$path" ]]; then
        mkdir -p "$fixture/source/$(dirname "$path")"
        cp -p "$root/$path" "$fixture/source/$path"
    fi
done < "$fixture/source-files"
cat > "$fixture/bin/make" <<'MAKE'
#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" == --no-print-directory ]]; then shift; fi
printf '%s\n' "$*" >> "$FIXTURE_COMMANDS"
printf 'make stdout: %s\n' "$*"
printf 'make stderr: %s\n' "$*" >&2
if [[ "${FIXTURE_FORMATTING:-no}" == yes && "$*" == ci ]]; then
    bash scripts/ci/run-formatting.sh --check bash -c \
        'echo formatter-stdout; echo formatter-stderr >&2; exit 43'
fi
if [[ "$*" == "$FIXTURE_FAILURE" ]]; then exit 43; fi
MAKE
chmod +x "$fixture/bin/make"
real_cargo="$(command -v cargo)"
cat > "$fixture/bin/cargo" <<'CARGO'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$*" == 'fetch --locked' ]]; then
    printf 'application-sources\n' >> "$FIXTURE_COMMANDS"
    printf 'fetch stdout\n'
    printf 'fetch stderr\n' >&2
    [[ "$FIXTURE_FAILURE" != application-sources ]] || exit 43
    exit 0
fi
exec "$FIXTURE_REAL_CARGO" "$@"
CARGO
chmod +x "$fixture/bin/cargo"
export FIXTURE_REAL_CARGO="$real_cargo"
real_tar="$(command -v tar)"
export FIXTURE_REAL_TAR="$real_tar"
real_bash="$(command -v bash)"
printf '#!%s\n' "$real_bash" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
set -euo pipefail
if [[ "$1" == scripts/ci/collect-native-diagnostics.sh && "${FIXTURE_COLLECTION_STATUS:-0}" != 0 ]]; then
    # The producer owns collector failures; exercise this workflow's handling of
    # its status after real readable diagnostics and candidates are published.
    "$FIXTURE_REAL_BASH" "$@"
    exit "$FIXTURE_COLLECTION_STATUS"
fi
if [[ "${!#}" == --check ]]; then
    case "$1" in
        */install-host-tools.sh|*/install-rust-tools.sh|*/install-ic-tools.sh)
            printf '%s\n' "$FIXTURE_REPORT_BIN"
            exit 0 ;;
    esac
fi
exec "$FIXTURE_REAL_BASH" "$@"
BASH
chmod +x "$fixture/bin/bash"
FIXTURE_REAL_BASH="$real_bash"
export FIXTURE_REAL_BASH
export FIXTURE_REPORT_BIN="$fixture/report-bin"
mkdir -p "$FIXTURE_REPORT_BIN"
for tool in jq yq rg cloc cargo-sort cargo-sort-derives candid-extractor icp didc ic-wasm quill wasm-opt; do
    cat > "$FIXTURE_REPORT_BIN/$tool" <<'TOOL'
#!/usr/bin/env bash
printf 'observed %s\n' "${0##*/}"
printf 'tool observation stderr\n' >&2
[[ "${FIXTURE_FAILURE:-}" != tool-inputs ]] || exit 43
TOOL
    chmod +x "$FIXTURE_REPORT_BIN/$tool"
done
# Keep this workflow's action-result projection and Git/evidence custody.
for scenario in success skipped-setup tool-inputs application-sources tools-install tools-check native formatting collection-partial collection-failure native-archive-write; do (
    worktree="$fixture/$scenario"
    mkdir -p "$worktree"
    cp -R "$fixture/source/." "$worktree/"
    cd "$worktree"
    export GIT_DIR="$git_dir" GIT_WORK_TREE="$worktree"
    export GITHUB_WORKSPACE="$worktree" GITHUB_RUN_ID=123 GITHUB_RUN_ATTEMPT=2 GITHUB_EVENT_NAME=fixture
    export GITHUB_PATH="$worktree/github-path" TMPDIR="$worktree/scratch"
    export SHARED_TOOLING_STORE="$worktree/shared-store"
    export RUNNER_TEMP="$worktree/runner temp"
    mkdir -p "$RUNNER_TEMP" "$TMPDIR"
    export FIXTURE_COMMANDS="$worktree/commands.log" FIXTURE_FAILURE=""
    export FIXTURE_FORMATTING=no
    export FIXTURE_COLLECTION_STATUS=0
    export PATH="$fixture/bin:$root/.tools/rust/common/bin:$root/.tools/host/bin:$PATH"
    export INPUT_OUTCOME=success HOST_OUTCOME=success TOOLCHAIN_OUTCOME=success PREREQUISITES_OUTCOME=success
    export APPLICATION_OUTCOME=skipped
    export TOOLS_OUTCOME=skipped TOOL_INPUT_OUTCOME=skipped NATIVE_OUTCOME=skipped
    case "$scenario" in
        tool-inputs) FIXTURE_FAILURE="tool-inputs" ;;
        application-sources) FIXTURE_FAILURE=application-sources ;;
        tools-install|collection-partial|collection-failure) FIXTURE_FAILURE=tools-install ;;
        tools-check) FIXTURE_FAILURE=tools-check ;;
        native) FIXTURE_FAILURE=ci ;;
        formatting) FIXTURE_FAILURE=ci; FIXTURE_FORMATTING=yes ;;
    esac
    case "$scenario" in
        collection-partial) FIXTURE_COLLECTION_STATUS=1 ;;
        collection-failure) FIXTURE_COLLECTION_STATUS=2 ;;
    esac
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_inputs.sh" > source.log 2>&1
    shasum -a 256 -c target/evidence/native-ci/source-sha256.txt > source-check.log
    status=0
    if [[ "$scenario" == skipped-setup ]]; then
        HOST_OUTCOME=failure
        printf 'unrelated log\n' > "$RUNNER_TEMP/tools-install.log"
        printf 'unrelated log\n' > "$RUNNER_TEMP/tools-check.log"
        : > commands.log
    else
        for step in tools tool_inputs application_sources native_ci; do
            step_status=0
            "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/$step.sh" > "$step.log" 2>&1 || step_status=$?
            outcome=success
            if [[ "$step_status" != 0 ]]; then outcome=failure; status="$step_status"; fi
            case "$step" in
                tools) TOOLS_OUTCOME="$outcome" ;;
                tool_inputs) TOOL_INPUT_OUTCOME="$outcome" ;;
                application_sources) APPLICATION_OUTCOME="$outcome" ;;
                native_ci) NATIVE_OUTCOME="$outcome" ;;
            esac
            if [[ "$step_status" != 0 ]]; then break; fi
        done
    fi
    printf '%s\n' "$status" > status.txt
    case "$scenario" in
        success|skipped-setup|native-archive-write) [[ "$status" == 0 ]] || exit 1 ;;
        *) [[ "$status" == 43 ]] || exit 1 ;;
    esac
    # No later application/native effect can follow a failed action or fetch.
    : > expected-commands
    if [[ "$scenario" != skipped-setup ]]; then
        printf 'tools\n' >> expected-commands
        if [[ "$TOOLS_OUTCOME" == success && "$TOOL_INPUT_OUTCOME" == success ]]; then
            printf 'application-sources\n' >> expected-commands
            if [[ "$APPLICATION_OUTCOME" == success ]]; then printf 'ci\n' >> expected-commands; fi
        fi
    fi
    cmp expected-commands commands.log
    # The outer archive owns full failed-release evidence, including Git state.
    mkdir -p target/evidence/native-ci/scratch/release/.git/release-state
    printf 'retained index\n' > target/evidence/native-ci/scratch/release/.git/index
    printf 'retained intent\n' > target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan
    # Diagnostics remain readable even when complete evidence collection fails.
    if [[ "$scenario" == collection-failure ]]; then
        archive_status=0
        "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1 || archive_status=$?
        [[ "$archive_status" == 2 && ! -e target/evidence/native-ci.tar.gz ]] || exit 1
        shasum -a 256 -c target/evidence/native-diagnostics.tar.gz.sha256 > diagnostic-check.log
        [[ "$(cat target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan)" == 'retained intent' ]] || exit 1
        [[ "$(cat .tools/rust/failure:payload)" == 'retained candidate' ]] || exit 1
        grep -Fx 'tools=failure' target/evidence/native-ci/outcome.txt > /dev/null
        exit 0
    fi
    if [[ "$scenario" == native-archive-write ]]; then
        mkdir archive-bin
        # shellcheck disable=SC2016 # The stub substitutes only outer tar writing.
        printf '#!%s\ncase "$*" in *"-C target/evidence/native-ci .") printf "partial native archive"; exit 23 ;; esac\nexec "$FIXTURE_REAL_TAR" "$@"\n' "$real_bash" > archive-bin/tar
        chmod +x archive-bin/tar
        export PATH="$worktree/archive-bin:$PATH"
        archive_status=0
        "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1 || archive_status=$?
        [[ "$archive_status" == 23 ]] || exit 1
        shasum -a 256 -c target/evidence/native-diagnostics.tar.gz.sha256 > diagnostic-check.log
        [[ "$(cat target/evidence/native-ci.tar.gz)" == 'partial native archive' &&
           ! -e target/evidence/native-ci.tar.gz.sha256 ]] || exit 1
        [[ "$(cat target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan)" == 'retained intent' ]] || exit 1
        exit 0
    fi
    collection_status=0
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1 || collection_status=$?
    [[ "$collection_status" == "$FIXTURE_COLLECTION_STATUS" ]] || exit 1
    shasum -a 256 -c target/evidence/native-diagnostics.tar.gz.sha256 > diagnostic-check.log
    mkdir diagnostic-readback
    tar -xzf target/evidence/native-diagnostics.tar.gz -C diagnostic-readback
    for file in diagnostic-readback/*; do
        [[ -f "$file" && ! -L "$file" ]] || exit 1
        cmp "$file" "target/evidence/native-ci/${file##*/}"
        case "${file##*/}" in *.tar.gz|scratch|tool-candidates*) exit 1 ;; esac
    done
    cmp target/evidence/native-ci/outcome.txt diagnostic-readback/outcome.txt
    shasum -a 256 -c target/evidence/native-ci.tar.gz.sha256 > archive-check.log
    mkdir -p unpacked/target/evidence/native-ci
    tar -xzf target/evidence/native-ci.tar.gz -C unpacked/target/evidence/native-ci
    (cd unpacked && shasum -a 256 -c target/evidence/native-ci/artifact-sha256.txt) > content-check.log
    for file in inputs.txt source-commit.txt source-files.nul source-sha256.txt outcome.txt; do
        cmp "target/evidence/native-ci/$file" "unpacked/target/evidence/native-ci/$file"
    done
    for file in index release-state/fixture.plan; do
        cmp "target/evidence/native-ci/scratch/release/.git/$file" \
            "unpacked/target/evidence/native-ci/scratch/release/.git/$file"
    done
    if [[ "$scenario" == formatting ]]; then
        logs=("$RUNNER_TEMP"/formatting.*)
        [[ ${#logs[@]} == 1 && -f "${logs[0]}" ]] || exit 1
        mkdir recovered-formatting
        tar -xzf unpacked/target/evidence/native-ci/formatting-logs.tar.gz -C recovered-formatting
        cmp "${logs[0]}" "recovered-formatting/${logs[0]##*/}"
        grep -Fx formatter-stdout "recovered-formatting/${logs[0]##*/}" > /dev/null
        grep -Fx formatter-stderr "recovered-formatting/${logs[0]##*/}" > /dev/null
        grep -Fx 'Checking formatting... FAILED (exit 43)' unpacked/target/evidence/native-ci/native-ci.log > /dev/null
    else
        [[ ! -f unpacked/target/evidence/native-ci/formatting-logs.tar.gz ]] || exit 1
    fi
    expected="$(printf 'native=%s\ninputs=%s\ntools=%s\nhost=%s\ntoolchain=%s\nprerequisites=%s\ntool_inputs=%s\napplication_sources=%s' \
        "$NATIVE_OUTCOME" "$INPUT_OUTCOME" "$TOOLS_OUTCOME" "$HOST_OUTCOME" "$TOOLCHAIN_OUTCOME" \
        "$PREREQUISITES_OUTCOME" "$TOOL_INPUT_OUTCOME" "$APPLICATION_OUTCOME")"
    [[ "$(cat unpacked/target/evidence/native-ci/outcome.txt)" == "$expected" ]] || exit 1
    if [[ "$scenario" == success ]]; then
        [[ -s unpacked/target/evidence/native-ci/tool-versions.txt ]] || exit 1
        [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]] || exit 1
    elif [[ "$scenario" == skipped-setup ]]; then
        [[ ! -e diagnostic-readback/tools-setup.log && ! -e diagnostic-readback/tools-check.log ]] || exit 1
        [[ ! -e unpacked/target/evidence/native-ci/tools-setup.log && ! -e unpacked/target/evidence/native-ci/tools-check.log ]] || exit 1
    else
        case "$scenario" in
            tools-check) failed_log=tools-check.log ;;
            tools-install|collection-*) failed_log=tools-setup.log ;;
            application-sources) failed_log=application-sources.log ;;
            tool-inputs) failed_log="tool-versions.txt" ;;
            native|formatting) failed_log=native-ci.log ;;
        esac
        if [[ "$scenario" == tool-inputs ]]; then
            grep -Fx 'observed cloc' "diagnostic-readback/$failed_log" > /dev/null
            grep -Fx 'tool observation stderr' "diagnostic-readback/$failed_log" > /dev/null
            [[ "$APPLICATION_OUTCOME" == skipped && "$NATIVE_OUTCOME" == skipped ]] || exit 1
            [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]] || exit 1
            exit 0
        fi
        if [[ "$scenario" == application-sources ]]; then
            grep -Fx 'fetch stdout' "diagnostic-readback/$failed_log" > /dev/null
            grep -Fx 'fetch stderr' "diagnostic-readback/$failed_log" > /dev/null
            [[ "$NATIVE_OUTCOME" == skipped ]] || exit 1
            exit 0
        fi
        case "$scenario" in
            tools-*|collection-*)
                phase=install
                [[ "$scenario" != tools-check ]] || phase=check
                grep -Fx "tool action stdout: $phase" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
                grep -Fx "tool action stderr: $phase" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null ;;
            *)
                grep -Fx "make stdout: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
                grep -Fx "make stderr: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null ;;
        esac
        if [[ "$scenario" == native || "$scenario" == formatting ]]; then
            [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]] || exit 1
        else
            mkdir recovered-candidates
            tar -xzf unpacked/target/evidence/native-ci/tool-candidates.tar.gz -C recovered-candidates
            cmp .tools/rust/failure:payload recovered-candidates/.tools/rust/failure:payload
        fi
    fi
) done
echo 'Native evidence source/setup/archive cases passed (action results and Make effects substituted; no hosted CI claim)'
fixture_complete=true
