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
fixture="$(mktemp -d "${TMPDIR:-$root/target/evidence/native-ci}/native-evidence.XXXXXX")"
fixture="$(cd "$fixture" && pwd -P)"
fixture_complete=false
cleanup() {
    local status=$?
    [[ "$fixture_complete" == true || "$status" != 0 ]] || status=1
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
    (map(.id) | index("tool_inputs")) < (map(.id) | index("native_ci")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("prerequisites")) and
    (map(select(.id == "native_artifacts"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''") and
    (map(select(.uses != null and .with.name == "native-${{ matrix.runner }}-${{ github.run_attempt }}"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''")
' "$fixture/steps.json" > /dev/null
for step in native_inputs tools tool_inputs native_ci native_artifacts; do
    # shellcheck disable=SC2016 # $step is bound by jq's --arg.
    "$jq" -er --arg step "$step" '.[] | select(.id == $step) | .run' "$fixture/steps.json" > "$fixture/commands/$step.sh"
done
# Read the real index but use copied current source as the independent worktree.
# No Git write, release, installer, network or product compilation is dispatched.
git -C "$root" ls-files --cached --others --exclude-standard -z > "$fixture/source-files"
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
        mkdir -p "$candidate"
        printf 'retained candidate\n' > "$candidate/failure:payload"
        printf 'literal name\n' > "$candidate/"$'trailing\n'
        chmod 640 "$candidate/failure:payload"
        printf '#!/bin/sh\nexit 0\n' > "$candidate/executable"
        chmod 755 "$candidate/executable"
        ln -s failure:payload "$candidate/link"
        mkdir -p "$candidate/.git"
        printf 'candidate metadata excluded\n' > "$candidate/.git/config"
    fi
    exit 43
fi
MAKE
chmod +x "$fixture/bin/make"
real_bash="$(command -v bash)"
printf '#!%s\n' "$real_bash" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
set -euo pipefail
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
for scenario in success rust-install rust-check rust-admission ic-admission host-install host-check ic-install ic-check native formatting rust-archive-write rust-archive-conflict; do (
    worktree="$fixture/$scenario"
    mkdir -p "$worktree"
    cp -R "$fixture/source/." "$worktree/"
    cd "$worktree"
    export GIT_DIR="$git_dir" GIT_WORK_TREE="$worktree"
    export GITHUB_WORKSPACE="$worktree" GITHUB_RUN_ID=123 GITHUB_RUN_ATTEMPT=2 GITHUB_EVENT_NAME=fixture
    export GITHUB_PATH="$worktree/github-path" TMPDIR="$worktree/scratch"
    export RUNNER_TEMP="$worktree/runner temp"
    mkdir -p "$RUNNER_TEMP" "$TMPDIR"
    export FIXTURE_COMMANDS="$worktree/commands.log" FIXTURE_FAILURE="" FIXTURE_ADMISSION=no
    export FIXTURE_FORMATTING=no
    export PATH="$fixture/bin:$root/.tools/rust/bin:$root/.tools/host/bin:$PATH"
    export INPUT_OUTCOME=success HOST_OUTCOME=success TOOLCHAIN_OUTCOME=success PREREQUISITES_OUTCOME=success
    export TOOLS_OUTCOME=skipped TOOL_INPUT_OUTCOME=skipped NATIVE_OUTCOME=skipped
    case "$scenario" in
        rust-install|rust-archive-write|rust-archive-conflict) FIXTURE_FAILURE=install-rust-tools ;;
        rust-admission) FIXTURE_FAILURE=install-rust-tools-preflight ;;
        ic-admission) FIXTURE_FAILURE=install-ic-tools-preflight ;;
        rust-check) FIXTURE_FAILURE=rust-tools-check ;;
        host-install) FIXTURE_FAILURE=install-host-tools ;;
        host-check) FIXTURE_FAILURE=host-tools-check ;;
        ic-install) FIXTURE_FAILURE=install-ic-tools ;;
        ic-check) FIXTURE_FAILURE=ic-tools-check ;;
        native) FIXTURE_FAILURE=ci ;;
        formatting) FIXTURE_FAILURE=ci; FIXTURE_FORMATTING=yes ;;
    esac
    if [[ "$scenario" == *-admission ]]; then FIXTURE_ADMISSION=yes; fi
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_inputs.sh" > source.log 2>&1
    shasum -a 256 -c target/evidence/native-ci/source-sha256.txt > source-check.log
    status=0
    for step in tools tool_inputs native_ci; do
        step_status=0
        "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/$step.sh" > "$step.log" 2>&1 || step_status=$?
        outcome=success
        if [[ "$step_status" != 0 ]]; then outcome=failure; status="$step_status"; fi
        case "$step" in
            tools) TOOLS_OUTCOME="$outcome" ;;
            tool_inputs) TOOL_INPUT_OUTCOME="$outcome" ;;
            native_ci) NATIVE_OUTCOME="$outcome" ;;
        esac
        if [[ "$step_status" != 0 ]]; then break; fi
    done
    printf '%s\n' "$status" > status.txt
    case "$scenario" in
        success) [[ "$status" == 0 ]] ;;
        native|formatting) [[ "$status" == 43 ]] ;;
        *) [[ "$status" == 2 ]] ;; # GNU Make preserves its failing aggregate status.
    esac
    # No later set/check/native effect can follow the first refused leaf.
    phases=(install-tools install-ic-tools-preflight install-rust-tools-preflight
            install-host-tools install-ic-tools install-rust-tools
            tools-check host-tools-check ic-tools-check rust-tools-check ci)
    : > expected-commands
    for phase in "${phases[@]}"; do
        printf '%s\n' "$phase" >> expected-commands
        if [[ "$phase" == "$FIXTURE_FAILURE" ]]; then break; fi
    done
    cmp expected-commands commands.log
    # The outer archive owns full failed-release evidence, including Git state.
    mkdir -p target/evidence/native-ci/scratch/release/.git/release-state
    printf 'retained index\n' > target/evidence/native-ci/scratch/release/.git/index
    printf 'retained intent\n' > target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan
    if [[ "$scenario" == rust-archive-write || "$scenario" == rust-archive-conflict ]]; then
        if [[ "$scenario" == rust-archive-write ]]; then
            mkdir archive-bin
            printf '#!%s\nprintf "partial candidate archive"\nexit 23\n' "$real_bash" > archive-bin/tar
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
        [[ "$(cat target/evidence/native-ci/tool-candidates.tar.gz)" == "$expected_archive" ]]
        [[ ! -e target/evidence/native-ci.tar.gz && "$(cat status.txt)" == 2 ]]
        [[ "$(cat .tools/rust/failure:payload)" == 'retained candidate' ]]
        [[ "$(cat target/evidence/native-ci/scratch/release/.git/release-state/fixture.plan)" == 'retained intent' ]]
        grep -Fx 'tools=failure' target/evidence/native-ci/outcome.txt > /dev/null
        grep -Fx 'native=skipped' target/evidence/native-ci/outcome.txt > /dev/null
        exit 0
    fi
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1
    shasum -a 256 -c target/evidence/native-ci.tar.gz.sha256 > archive-check.log
    mkdir -p unpacked/target/evidence/native-ci
    tar -xzf target/evidence/native-ci.tar.gz -C unpacked/target/evidence/native-ci
    (cd unpacked && shasum -a 256 -c target/evidence/native-ci/artifact-sha256.txt) > content-check.log
    for file in inputs.txt source-commit.txt source-files.txt source-sha256.txt outcome.txt; do
        cmp "target/evidence/native-ci/$file" "unpacked/target/evidence/native-ci/$file"
    done
    for file in index release-state/fixture.plan; do
        cmp "target/evidence/native-ci/scratch/release/.git/$file" \
            "unpacked/target/evidence/native-ci/scratch/release/.git/$file"
    done
    if [[ "$scenario" == formatting ]]; then
        logs=("$RUNNER_TEMP"/formatting.*)
        [[ ${#logs[@]} == 1 && -f "${logs[0]}" ]]
        mkdir recovered-formatting
        tar -xzf unpacked/target/evidence/native-ci/formatting-logs.tar.gz -C recovered-formatting
        cmp "${logs[0]}" "recovered-formatting/${logs[0]##*/}"
        grep -Fx formatter-stdout "recovered-formatting/${logs[0]##*/}" > /dev/null
        grep -Fx formatter-stderr "recovered-formatting/${logs[0]##*/}" > /dev/null
        grep -Fx 'Checking formatting... FAILED (exit 43)' unpacked/target/evidence/native-ci/native-ci.log > /dev/null
    else
        [[ ! -f unpacked/target/evidence/native-ci/formatting-logs.tar.gz ]]
    fi
    expected="$(printf 'native=%s\ninputs=%s\ntools=%s\nhost=%s\ntoolchain=%s\nprerequisites=%s\ntool_inputs=%s' \
        "$NATIVE_OUTCOME" "$INPUT_OUTCOME" "$TOOLS_OUTCOME" "$HOST_OUTCOME" "$TOOLCHAIN_OUTCOME" \
        "$PREREQUISITES_OUTCOME" "$TOOL_INPUT_OUTCOME")"
    [[ "$(cat unpacked/target/evidence/native-ci/outcome.txt)" == "$expected" ]]
    if [[ "$scenario" == success ]]; then
        [[ -s unpacked/target/evidence/native-ci/tool-versions.txt ]]
        [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]]
    else
        case "$scenario" in
            *-check) failed_log=tools-check.log ;;
            rust-*|host-*|ic-*) failed_log=tools-setup.log ;;
            native|formatting) failed_log=native-ci.log ;;
        esac
        effect='make'
        if [[ "$scenario" == *-admission ]]; then effect=preflight; fi
        grep -Fx "$effect stdout: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
        grep -Fx "$effect stderr: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
        [[ "$(tail -1 commands.log)" == "$FIXTURE_FAILURE" ]]
        if [[ "$scenario" == *-admission || "$scenario" == native || "$scenario" == formatting ]]; then
            [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]]
        else
            mkdir recovered-candidates
            tar -xzf unpacked/target/evidence/native-ci/tool-candidates.tar.gz -C recovered-candidates
            for candidate in .tools/host-set.* .tools/ic-set.* .tools/rust; do
                if [[ -d "$candidate" ]]; then
                    cmp "$candidate/failure:payload" "recovered-candidates/$candidate/failure:payload"
                    cmp "$candidate/"$'trailing\n' "recovered-candidates/$candidate/"$'trailing\n'
                    cmp "$candidate/executable" "recovered-candidates/$candidate/executable"
                    [[ -x "recovered-candidates/$candidate/executable" ]]
                    [[ -L "recovered-candidates/$candidate/link" ]]
                    [[ "$(readlink "recovered-candidates/$candidate/link")" == failure:payload ]]
                    [[ ! -e "recovered-candidates/$candidate/.git" ]]
                    # macOS and Linux expose permissions through different stat syntax.
                    if [[ "$(uname -s)" == Darwin ]]; then
                        [[ "$(stat -f %Lp "recovered-candidates/$candidate/failure:payload")" == 640 ]]
                    else
                        [[ "$(stat -c %a "recovered-candidates/$candidate/failure:payload")" == 640 ]]
                    fi
                fi
            done
        fi
    fi
) done
echo 'Native evidence source/setup/archive cases passed (Make effects substituted; no hosted CI claim)'
fixture_complete=true
