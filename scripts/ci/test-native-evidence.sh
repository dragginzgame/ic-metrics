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
    (map(.id) | index("prerequisites")) < (map(.id) | index("host_tools")) and
    (map(.id) | index("host_tools")) < (map(.id) | index("toolchain")) and
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
for step in native_inputs native_host host_tools toolchain tool_inputs application_sources native_ci native_artifacts; do
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
        components=(--component clippy --component rustfmt)
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
real_bash="$(command -v bash)"
printf '#!%s\n' "$real_bash" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
set -euo pipefail
if [[ "$1" == scripts/dev/install-host-tools.sh ]]; then
    printf 'host-tools\n' >> "$FIXTURE_COMMANDS"
    printf 'host setup stdout\n'
    printf 'host setup stderr\n' >&2
    if [[ "$FIXTURE_FAILURE" == host-tools ]]; then
        mkdir -p .tools/host-set.fixture
        printf 'retained host candidate\n' > .tools/host-set.fixture/failure:payload
        exit 43
    fi
    exit 0
fi
if [[ "$1" == scripts/ci/collect-native-diagnostics.sh && "${FIXTURE_COLLECTION_STATUS:-0}" != 0 ]]; then
    # The producer owns collector failures; exercise this workflow's handling of
    # its status after real readable diagnostics and candidates are published.
    "$FIXTURE_REAL_BASH" "$@"
    exit "$FIXTURE_COLLECTION_STATUS"
fi
if [[ "$1" == scripts/ci/report-tool-versions.sh ]]; then
    [[ $# == 2 && "$2" == "$GITHUB_WORKSPACE" ]] || exit 99
    # Shared qualifies catalog selection, admission and executable probes.
    # Metrics owns the workflow's partial-log retention and later-step refusal.
    printf 'reporter partial stdout\n'
    printf 'reporter partial stderr\n' >&2
    [[ "$FIXTURE_FAILURE" != tool-inputs ]] || exit 43
    exit 0
fi
if [[ "$1" == scripts/ci/package-native-recovery-evidence.sh && "$FIXTURE_ARCHIVE_STATUS" != 0 ]]; then
    [[ $# == 3 && "$2" == target/evidence/native-ci && "$3" == target/evidence/native-ci.tar.gz ]] || exit 99
    # Substitute the local packaging boundary, not its internal tar command.
    printf 'outer archive stdout\n'
    printf 'outer archive stderr\n' >&2
    exit "$FIXTURE_ARCHIVE_STATUS"
fi
exec "$FIXTURE_REAL_BASH" "$@"
BASH
chmod +x "$fixture/bin/bash"
FIXTURE_REAL_BASH="$real_bash"
export FIXTURE_REAL_BASH
# Keep this workflow's action-result projection and Git/evidence custody.
for scenario in success skipped-setup host-tools tool-inputs application-sources tools-install tools-check native formatting collection-partial collection-failure native-archive-failure collection-archive-failure; do (
    worktree="$fixture/$scenario"
    mkdir -p "$worktree"
    cp -R "$fixture/source/." "$worktree/"
    cd "$worktree"
    # Exercise filename escaping through the actual workflow hash body below,
    # rather than maintaining a second hashing loop in the selector fixture.
    if [[ "$scenario" == success ]]; then
        mkdir -p crates/filename-fixture
        names=('space file.rs' $'line\nfile.rs' 'back\slash.rs')
        for name in "${names[@]}"; do printf 'pending\n' > "crates/filename-fixture/$name"; done
    fi
    export GIT_DIR="$git_dir" GIT_WORK_TREE="$worktree"
    export GITHUB_WORKSPACE="$worktree" GITHUB_RUN_ID=123 GITHUB_RUN_ATTEMPT=2 GITHUB_EVENT_NAME=fixture
    export GITHUB_PATH="$worktree/github-path" TMPDIR="$worktree/scratch"
    export SHARED_TOOLING_STORE="$worktree/shared-store"
    export RUNNER_TEMP="$worktree/runner temp"
    mkdir -p "$RUNNER_TEMP" "$TMPDIR"
    export FIXTURE_COMMANDS="$worktree/commands.log" FIXTURE_FAILURE=""
    export FIXTURE_FORMATTING=no
    export FIXTURE_COLLECTION_STATUS=0 FIXTURE_ARCHIVE_STATUS=0
    export PATH="$fixture/bin:$root/.tools/rust/common/bin:$root/.tools/host/bin:$PATH"
    export INPUT_OUTCOME=success HOST_OUTCOME=success TOOLCHAIN_OUTCOME=success PREREQUISITES_OUTCOME=success
    export HOST_TOOLS_OUTCOME=skipped
    export APPLICATION_OUTCOME=skipped
    export TOOLS_OUTCOME=skipped TOOL_INPUT_OUTCOME=skipped NATIVE_OUTCOME=skipped
    case "$scenario" in
        host-tools) FIXTURE_FAILURE=host-tools; TOOLCHAIN_OUTCOME=skipped ;;
        tool-inputs) FIXTURE_FAILURE="tool-inputs" ;;
        application-sources) FIXTURE_FAILURE=application-sources ;;
        tools-install|collection-partial|collection-failure|collection-archive-failure) FIXTURE_FAILURE=tools-install ;;
        tools-check) FIXTURE_FAILURE=tools-check ;;
        native) FIXTURE_FAILURE=ci ;;
        formatting) FIXTURE_FAILURE=ci; FIXTURE_FORMATTING=yes ;;
    esac
    case "$scenario" in
        collection-partial) FIXTURE_COLLECTION_STATUS=1 ;;
        collection-failure) FIXTURE_COLLECTION_STATUS=2 ;;
        native-archive-failure) FIXTURE_ARCHIVE_STATUS=23 ;;
        collection-archive-failure) FIXTURE_COLLECTION_STATUS=2; FIXTURE_ARCHIVE_STATUS=23 ;;
    esac
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_inputs.sh" > source.log 2>&1
    shasum -a 256 -c target/evidence/native-ci/source-sha256.txt > source-check.log
    if [[ "$scenario" == success ]]; then
        for name in "${names[@]}"; do
            perl -0e '$name = shift; while (<>) { $found=1 if $_ eq "$name\0" } exit(!$found)' \
                "crates/filename-fixture/$name" target/evidence/native-ci/source-files.nul
        done
    fi
    status=0
    if [[ "$scenario" == skipped-setup ]]; then
        HOST_OUTCOME=failure
        printf 'unrelated log\n' > "$RUNNER_TEMP/tools-install.log"
        printf 'unrelated log\n' > "$RUNNER_TEMP/tools-check.log"
        : > commands.log
    else
        # This fixture models this workflow's step order and outcome projection.
        for step in host_tools:HOST_TOOLS_OUTCOME tools:TOOLS_OUTCOME \
            tool_inputs:TOOL_INPUT_OUTCOME application_sources:APPLICATION_OUTCOME \
            native_ci:NATIVE_OUTCOME; do
            if "$real_bash" --noprofile --norc -e -o pipefail \
                "$fixture/commands/${step%%:*}.sh" > "$PWD/${step%%:*}.log" 2>&1; then
                export "${step#*:}=success"
            else
                status=$?
                export "${step#*:}=failure"
                break
            fi
        done
    fi
    printf '%s\n' "$status" > status.txt
    case "$scenario" in
        success|skipped-setup|native-archive-failure) [[ "$status" == 0 ]] || exit 1 ;;
        *) [[ "$status" == 43 ]] || exit 1 ;;
    esac
    # No later application/native effect can follow a failed action or fetch.
    : > expected-commands
    if [[ "$scenario" != skipped-setup ]]; then
        printf 'host-tools\n' >> expected-commands
    fi
    if [[ "$HOST_TOOLS_OUTCOME" == success ]]; then
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
    if [[ "$scenario" == native-archive-failure || "$scenario" == collection-archive-failure ]]; then
        archive_status=0
        "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1 || archive_status=$?
        expected_archive_status=23
        [[ "$scenario" != collection-archive-failure ]] || expected_archive_status=2
        [[ "$archive_status" == "$expected_archive_status" ]] || exit 1
        bash "$root/scripts/ci/verify-file-checksum.sh" sha256 \
            "$(cat target/evidence/native-diagnostics.tar.gz.sha256)" \
            target/evidence/native-diagnostics.tar.gz > diagnostic-check.log
        [[ ! -e target/evidence/native-ci.tar.gz && ! -e target/evidence/native-ci.tar.gz.sha256 ]] || exit 1
        grep -Fx 'outer archive stdout' archive.log > /dev/null
        grep -Fx 'outer archive stderr' archive.log > /dev/null
        grep -Fx 'Native recovery archive failed (exit 23)' archive.log > /dev/null
        [[ "$(cat target/evidence/native-ci/scratch/release/.git/index)" == 'retained index' ]] || exit 1
        [[ "$(cat target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan)" == 'retained intent' ]] || exit 1
        if [[ "$scenario" == collection-archive-failure ]]; then
            [[ "$(cat .tools/rust/failure:payload)" == 'retained candidate' ]] || exit 1
        fi
        exit 0
    fi
    collection_status=0
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1 || collection_status=$?
    [[ "$collection_status" == "$FIXTURE_COLLECTION_STATUS" ]] || exit 1
    bash "$root/scripts/ci/verify-file-checksum.sh" sha256 \
        "$(cat target/evidence/native-diagnostics.tar.gz.sha256)" \
        target/evidence/native-diagnostics.tar.gz > diagnostic-check.log
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
    expected="$(printf 'native=%s\ninputs=%s\ntools=%s\nhost=%s\ntoolchain=%s\nprerequisites=%s\nhost_tools=%s\ntool_inputs=%s\napplication_sources=%s' \
        "$NATIVE_OUTCOME" "$INPUT_OUTCOME" "$TOOLS_OUTCOME" "$HOST_OUTCOME" "$TOOLCHAIN_OUTCOME" \
        "$PREREQUISITES_OUTCOME" "$HOST_TOOLS_OUTCOME" "$TOOL_INPUT_OUTCOME" "$APPLICATION_OUTCOME")"
    [[ "$(cat unpacked/target/evidence/native-ci/outcome.txt)" == "$expected" ]] || exit 1
    if [[ "$scenario" == success ]]; then
        [[ -s unpacked/target/evidence/native-ci/tool-versions.txt ]] || exit 1
        [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]] || exit 1
    elif [[ "$scenario" == skipped-setup ]]; then
        [[ ! -e diagnostic-readback/tools-setup.log && ! -e diagnostic-readback/tools-check.log ]] || exit 1
        [[ ! -e unpacked/target/evidence/native-ci/tools-setup.log && ! -e unpacked/target/evidence/native-ci/tools-check.log ]] || exit 1
    elif [[ "$scenario" == host-tools ]]; then
        grep -Fx 'host setup stdout' diagnostic-readback/host-tools.log > /dev/null
        grep -Fx 'host setup stderr' diagnostic-readback/host-tools.log > /dev/null
        [[ "$TOOLCHAIN_OUTCOME" == skipped && "$TOOLS_OUTCOME" == skipped &&
           "$APPLICATION_OUTCOME" == skipped && "$NATIVE_OUTCOME" == skipped ]] || exit 1
        mkdir recovered-host-candidates
        tar -xzf unpacked/target/evidence/native-ci/tool-candidates.tar.gz -C recovered-host-candidates
        cmp .tools/host-set.fixture/failure:payload recovered-host-candidates/.tools/host-set.fixture/failure:payload
    else
        case "$scenario" in
            tools-check) failed_log=tools-check.log ;;
            tools-install|collection-*) failed_log=tools-setup.log ;;
            application-sources) failed_log=application-sources.log ;;
            tool-inputs) failed_log="tool-versions.txt" ;;
            native|formatting) failed_log=native-ci.log ;;
        esac
        if [[ "$scenario" == tool-inputs ]]; then
            grep -Fx 'reporter partial stdout' "diagnostic-readback/$failed_log" > /dev/null
            grep -Fx 'reporter partial stderr' "diagnostic-readback/$failed_log" > /dev/null
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
