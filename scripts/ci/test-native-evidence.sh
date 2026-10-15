#!/usr/bin/env bash
set -euo pipefail

# Execute the consumer workflow's source/setup/archive bodies with substitute
# Make effects. This proves local IO and failure status, not hosted execution.
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
    (map(select(.id == "native_artifacts"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''") and
    (map(select(.uses != null and .with.name == "native-${{ matrix.runner }}-${{ github.run_attempt }}"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''")
' "$fixture/steps.json" > /dev/null
for step in native_inputs native_host tools tool_inputs application_sources native_ci native_artifacts; do
    PATH="${jq%/*}:$PATH" bash "$root/scripts/ci/extract-workflow-step.sh" \
        "$fixture/steps.json" "$step" > "$fixture/commands/$step.sh"
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
# Run the actual consumer aggregate, substituting only its recursive leaf effects.
if [[ "$*" == install-tools || "$*" == tools-check ]]; then
    exec "$FIXTURE_REAL_MAKE" --no-print-directory -j2 "$@" \
        MAKE="$0" MAKE_COMMAND="$FIXTURE_REAL_MAKE"
fi
if [[ "${FIXTURE_FORMATTING:-no}" == yes && "$*" == ci ]]; then
    bash scripts/ci/run-formatting.sh --check bash -c \
        'echo formatter-stdout; echo formatter-stderr >&2; exit 43'
fi
if [[ "$*" == "$FIXTURE_FAILURE" ]]; then
    case "$*" in
        *rust*) candidate=.tools/rust ;;
        *host*) candidate=.tools/host-set.fixture ;;
        *ic*) candidate=.tools/ic-set.fixture ;;
        *) candidate="" ;;
    esac
    if [[ -n "$candidate" && "$FIXTURE_ADMISSION" != yes ]]; then
        if [[ "${FIXTURE_SHARED_STORE:-no}" == yes ]]; then
            store_kind=host
            [[ "$*" != install-ic-tools ]] || store_kind=ic
            if [[ "$*" == install-rust-tools ]]; then
                store_kind=rust
                mkdir -p "$candidate"
                printf 'local failed compilation\n' > "$candidate/local-failure:payload"
                candidate="$candidate/rust-set.fixture"
            fi
            fixture_store="$SHARED_TOOLING_STORE"
            if [[ "${FIXTURE_STORE_INVALID:-no}" == yes ]]; then
                fixture_store="$SHARED_TOOLING_STORE.physical"
                mkdir "$fixture_store"
                ln -s "$fixture_store" "$SHARED_TOOLING_STORE"
            fi
            store_slot="$fixture_store/$store_kind-$(printf '%064d' 0)"
            mkdir -p "$store_slot/set.fixture" .tools
            ln -s "$store_slot/set.fixture" "$candidate"
            # A bundle without this checkout's reference must not be collected.
            mkdir -p "$store_slot/set.unrelated"
            printf 'unrelated store payload\n' > "$store_slot/set.unrelated/payload"
            chmod 700 "$fixture_store" "$store_slot" "$store_slot/set.fixture"
        else
            mkdir -p "$candidate"
        fi
        printf 'retained candidate\n' > "$candidate/failure:payload"
        # Shared's archive fixture owns filename/mode/link fidelity. This fixture
        # retains a payload marker to prove the consumer selected real evidence.
    fi
    exit 43
fi
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
if [[ "${!#}" == --check ]]; then
    case "$1" in
        */install-host-tools.sh|*/install-rust-tools.sh|*/install-ic-tools.sh)
            printf '%s\n' "$FIXTURE_REPORT_BIN"
            exit 0 ;;
    esac
fi
if [[ "$1" == scripts/dev/wasm-inspector.sh && "${2:-}" == check ]]; then
    printf '%s/inspector\n' "$FIXTURE_REPORT_BIN"
    exit 0
fi
if [[ "${!#}" == --preflight ]]; then
    case "$1" in
        */install-ic-tools.sh|*/install-rust-tools.sh)
            phase="${1##*/}"
            phase="${phase%.sh}-preflight"
            printf '%s\n' "$phase" >> "$FIXTURE_COMMANDS"
            printf 'preflight stdout: %s\n' "$phase"
            printf 'preflight stderr: %s\n' "$phase" >&2
            [[ "$phase" != "$FIXTURE_FAILURE" ]] || exit 43
            exit 0 ;;
    esac
fi
exec "$FIXTURE_REAL_BASH" "$@"
BASH
chmod +x "$fixture/bin/bash"
FIXTURE_REAL_BASH="$real_bash"
export FIXTURE_REAL_BASH
FIXTURE_REAL_MAKE="$(command -v make)"
export FIXTURE_REAL_MAKE
export FIXTURE_REPORT_BIN="$fixture/report-bin"
mkdir -p "$FIXTURE_REPORT_BIN"
for tool in jq yq rg cloc cargo-sort cargo-sort-derives candid-extractor icp didc ic-wasm quill wasm-opt inspector; do
    cat > "$FIXTURE_REPORT_BIN/$tool" <<'TOOL'
#!/usr/bin/env bash
printf 'observed %s\n' "${0##*/}"
printf 'tool observation stderr\n' >&2
[[ "${FIXTURE_FAILURE:-}" != tool-inputs ]] || exit 43
TOOL
    chmod +x "$FIXTURE_REPORT_BIN/$tool"
done
for scenario in success tool-inputs application-sources rust-install rust-check rust-store rust-store-invalid rust-admission ic-admission host-install host-check host-store ic-install ic-check ic-store native formatting rust-archive-write rust-archive-conflict; do (
    worktree="$fixture/$scenario"
    mkdir -p "$worktree"
    cp -R "$fixture/source/." "$worktree/"
    cd "$worktree"
    export GIT_DIR="$git_dir" GIT_WORK_TREE="$worktree"
    export GITHUB_WORKSPACE="$worktree" GITHUB_RUN_ID=123 GITHUB_RUN_ATTEMPT=2 GITHUB_EVENT_NAME=fixture
    export GITHUB_PATH="$worktree/github-path" TMPDIR="$worktree/scratch"
    export SHARED_TOOLING_STORE="$worktree/shared-store" FIXTURE_SHARED_STORE=no
    export FIXTURE_STORE_INVALID=no
    export RUNNER_TEMP="$worktree/runner temp"
    mkdir -p "$RUNNER_TEMP" "$TMPDIR"
    export FIXTURE_COMMANDS="$worktree/commands.log" FIXTURE_FAILURE="" FIXTURE_ADMISSION=no
    export FIXTURE_FORMATTING=no
    export PATH="$fixture/bin:$root/.tools/rust/common/bin:$root/.tools/host/bin:$PATH"
    export INPUT_OUTCOME=success HOST_OUTCOME=success TOOLCHAIN_OUTCOME=success PREREQUISITES_OUTCOME=success
    export APPLICATION_OUTCOME=skipped
    export TOOLS_OUTCOME=skipped TOOL_INPUT_OUTCOME=skipped NATIVE_OUTCOME=skipped
    case "$scenario" in
        tool-inputs) FIXTURE_FAILURE="tool-inputs" ;;
        application-sources) FIXTURE_FAILURE=application-sources ;;
        rust-install|rust-store|rust-store-invalid|rust-archive-write|rust-archive-conflict) FIXTURE_FAILURE=install-rust-tools ;;
        rust-admission) FIXTURE_FAILURE=install-rust-tools-preflight ;;
        ic-admission) FIXTURE_FAILURE=install-ic-tools-preflight ;;
        rust-check) FIXTURE_FAILURE=rust-tools-check ;;
        host-install|host-store) FIXTURE_FAILURE=install-host-tools ;;
        host-check) FIXTURE_FAILURE=host-tools-check ;;
        ic-install|ic-store) FIXTURE_FAILURE=install-ic-tools ;;
        ic-check) FIXTURE_FAILURE=ic-tools-check ;;
        native) FIXTURE_FAILURE=ci ;;
        formatting) FIXTURE_FAILURE=ci; FIXTURE_FORMATTING=yes ;;
    esac
    if [[ "$scenario" == *-store || "$scenario" == rust-store-invalid ]]; then FIXTURE_SHARED_STORE=yes; fi
    if [[ "$scenario" == rust-store-invalid ]]; then FIXTURE_STORE_INVALID=yes; fi
    if [[ "$scenario" == *-admission ]]; then FIXTURE_ADMISSION=yes; fi
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_inputs.sh" > source.log 2>&1
    shasum -a 256 -c target/evidence/native-ci/source-sha256.txt > source-check.log
    status=0
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
    printf '%s\n' "$status" > status.txt
    case "$scenario" in
        success) [[ "$status" == 0 ]] || exit 1 ;;
        native|formatting|application-sources|tool-inputs) [[ "$status" == 43 ]] || exit 1 ;;
        *) [[ "$status" == 2 ]] || exit 1 ;; # GNU Make preserves its failing aggregate status.
    esac
    # No later set/check/native effect can follow the first refused leaf.
    phases=(install-tools install-ic-tools-preflight install-rust-tools-preflight
            install-host-tools install-ic-tools install-rust-tools install-wasm-inspector
            tools-check host-tools-check ic-tools-check rust-tools-check wasm-inspector-tools-check application-sources ci)
    : > expected-commands
    for phase in "${phases[@]}"; do
        printf '%s\n' "$phase" >> expected-commands
        if [[ "$phase" == "$FIXTURE_FAILURE" || ( "$scenario" == tool-inputs && "$phase" == wasm-inspector-tools-check ) ]]; then break; fi
    done
    cmp expected-commands commands.log
    # The outer archive owns full failed-release evidence, including Git state.
    mkdir -p target/evidence/native-ci/scratch/release/.git/release-state
    printf 'retained index\n' > target/evidence/native-ci/scratch/release/.git/index
    printf 'retained intent\n' > target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan
    # Diagnostics remain readable even when complete evidence collection fails.
    if [[ "$scenario" == rust-archive-write || "$scenario" == rust-archive-conflict ]]; then
        if [[ "$scenario" == rust-archive-write ]]; then
            mkdir archive-bin
            # shellcheck disable=SC2016 # Arguments expand in the generated stub.
            printf '#!%s\ncase "$*" in *./.tools/*|*./.tools/rust*) printf "partial candidate archive"; exit 23 ;; esac\nexec "$FIXTURE_REAL_TAR" "$@"\n' "$real_bash" > archive-bin/tar
            chmod +x archive-bin/tar
            export PATH="$worktree/archive-bin:$PATH"
            expected_archive='partial candidate archive'
        else
            expected_archive='occupied candidate archive'
            printf '%s' "$expected_archive" > target/evidence/native-ci/tool-candidates.tar.gz
        fi
        if "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1; then
            echo 'candidate archive failure was accepted' >&2
            exit 1
        fi
        shasum -a 256 -c target/evidence/native-diagnostics.tar.gz.sha256 > diagnostic-check.log
        [[ "$(cat target/evidence/native-ci/tool-candidates.tar.gz)" == "$expected_archive" ]] || exit 1
        [[ ! -e target/evidence/native-ci.tar.gz && "$(cat status.txt)" == 2 ]] || exit 1
        [[ "$(cat .tools/rust/failure:payload)" == 'retained candidate' ]] || exit 1
        [[ "$(cat target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan)" == 'retained intent' ]] || exit 1
        grep -Fx 'tools=failure' target/evidence/native-ci/outcome.txt > /dev/null
        grep -Fx 'native=skipped' target/evidence/native-ci/outcome.txt > /dev/null
        exit 0
    fi
    collection_status=0
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1 || collection_status=$?
    if [[ "$FIXTURE_STORE_INVALID" == yes ]]; then
        [[ "$collection_status" == 1 ]] || exit 1
        grep -F 'Tool evidence collection incomplete' archive.log > /dev/null
    else
        [[ "$collection_status" == 0 ]] || exit 1
    fi
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
    else
        case "$scenario" in
            *-check) failed_log=tools-check.log ;;
            rust-*|host-*|ic-*) failed_log=tools-setup.log ;;
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
        effect='make'
        if [[ "$scenario" == *-admission ]]; then effect=preflight; fi
        grep -Fx "$effect stdout: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
        grep -Fx "$effect stderr: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
        [[ "$(tail -1 commands.log)" == "$FIXTURE_FAILURE" ]] || exit 1
        if [[ "$scenario" == *-admission || "$scenario" == native || "$scenario" == formatting ]]; then
            [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]] || exit 1
        else
            mkdir recovered-candidates
            tar -xzf unpacked/target/evidence/native-ci/tool-candidates.tar.gz -C recovered-candidates
            for candidate in .tools/host-set.* .tools/ic-set.* .tools/rust .tools/rust/rust-set.*; do
                if [[ -d "$candidate" ]]; then
                    recovered="recovered-candidates/$candidate"
                    if [[ "$candidate" == .tools/rust && "$FIXTURE_SHARED_STORE" == yes ]]; then
                        cmp "$candidate/local-failure:payload" "$recovered/local-failure:payload"
                        continue
                    fi
                    if [[ -L "$candidate" ]]; then
                        [[ -L "$recovered" && "$(readlink "$recovered")" == "$(readlink "$candidate")" ]] || exit 1
                        if [[ "$FIXTURE_STORE_INVALID" == yes ]]; then
                            [[ ! -e "recovered-candidates/rust-$(printf '%064d' 0)" ]] || exit 1
                            continue
                        fi
                        physical="$(cd "$candidate" && pwd -P)"
                        recovered="recovered-candidates/${physical#"$SHARED_TOOLING_STORE/"}"
                        [[ -d "$recovered" && ! -L "$recovered" ]] || exit 1
                        [[ ! -e "${recovered%/*}/set.unrelated" ]] || exit 1
                    fi
                    cmp "$candidate/failure:payload" "$recovered/failure:payload"
                fi
            done
        fi
    fi
) done
echo 'Native evidence source/setup/archive cases passed (Make effects substituted; no hosted CI claim)'
fixture_complete=true
