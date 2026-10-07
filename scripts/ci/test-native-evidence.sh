#!/usr/bin/env bash
set -euo pipefail

# Execute the consumer workflow's source/setup/archive bodies with substitute
# Make effects. This proves local IO and failure status, not hosted execution.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES GIT_DIR GIT_WORK_TREE
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
yq="$root/.tools/host/bin/yq"
jq="$root/.tools/host/bin/jq"
git_dir="$(git -C "$root" rev-parse --absolute-git-dir)"
mkdir -p "$root/target/evidence/native-ci"
fixture="$(mktemp -d "${TMPDIR:-$root/target/evidence/native-ci}/native-evidence.XXXXXX")"
fixture="$(cd "$fixture" && pwd -P)"
trap 'printf "Native evidence fixture retained: %s\n" "$fixture"' EXIT
mkdir -p "$fixture/commands" "$fixture/bin" "$fixture/source"
"$yq" -o=json '.jobs.native.steps' "$root/.github/workflows/ci.yml" > "$fixture/steps.json"
# These are live workflow effect boundaries, not checks of display prose.
# shellcheck disable=SC2016 # jq syntax and GitHub expressions must stay literal.
"$jq" -e '
    (map(.id) | index("checkout")) < (map(.id) | index("native_inputs")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("native_host")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("toolchain")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("rust_tools")) and
    (map(.id) | index("rust_tools")) < (map(.id) | index("host_tools")) and
    (map(.id) | index("native_inputs")) < (map(.id) | index("prerequisites")) and
    (map(select(.id == "native_artifacts"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''") and
    (map(select(.uses != null and .with.name == "native-${{ matrix.runner }}-${{ github.run_attempt }}"))[0].if ==
        "always() && steps.checkout.outcome == '\''success'\''")
' "$fixture/steps.json" > /dev/null
for step in native_inputs rust_tools host_tools tool_inputs ic_tools native_ci native_artifacts; do
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
printf '%s\n' "$*" >> "$FIXTURE_COMMANDS"
printf 'make stdout: %s\n' "$*"
printf 'make stderr: %s\n' "$*" >&2
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
    fi
    exit 43
fi
MAKE
chmod +x "$fixture/bin/make"
real_bash="$(command -v bash)"
for scenario in success rust-install rust-check rust-admission host-install host-check ic-install ic-check native; do (
    worktree="$fixture/$scenario"
    mkdir -p "$worktree"
    cp -R "$fixture/source/." "$worktree/"
    cd "$worktree"
    export GIT_DIR="$git_dir" GIT_WORK_TREE="$worktree"
    export GITHUB_WORKSPACE="$worktree" GITHUB_RUN_ID=123 GITHUB_RUN_ATTEMPT=2 GITHUB_EVENT_NAME=fixture
    export GITHUB_PATH="$worktree/github-path" TMPDIR="$worktree/scratch"
    export FIXTURE_COMMANDS="$worktree/commands.log" FIXTURE_FAILURE="" FIXTURE_ADMISSION=no
    export PATH="$fixture/bin:$root/.tools/rust/bin:$root/.tools/host/bin:$PATH"
    export INPUT_OUTCOME=success HOST_OUTCOME=success TOOLCHAIN_OUTCOME=success PREREQUISITES_OUTCOME=success
    export RUST_OUTCOME=skipped HOST_TOOLS_OUTCOME=skipped TOOL_INPUT_OUTCOME=skipped PROVISION_OUTCOME=skipped NATIVE_OUTCOME=skipped
    case "$scenario" in
        rust-install|rust-admission) FIXTURE_FAILURE=install-rust-tools ;;
        rust-check) FIXTURE_FAILURE=rust-tools-check ;;
        host-install) FIXTURE_FAILURE=install-host-tools ;;
        host-check) FIXTURE_FAILURE=host-tools-check ;;
        ic-install) FIXTURE_FAILURE=install-ic-tools ;;
        ic-check) FIXTURE_FAILURE=ic-tools-check ;;
        native) FIXTURE_FAILURE=ci ;;
    esac
    if [[ "$scenario" == rust-admission ]]; then FIXTURE_ADMISSION=yes; fi
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_inputs.sh" > source.log 2>&1
    shasum -a 256 -c target/evidence/native-ci/source-sha256.txt > source-check.log
    status=0
    for step in rust_tools host_tools tool_inputs ic_tools native_ci; do
        step_status=0
        "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/$step.sh" > "$step.log" 2>&1 || step_status=$?
        outcome=success
        if [[ "$step_status" != 0 ]]; then outcome=failure; status="$step_status"; fi
        case "$step" in
            rust_tools) RUST_OUTCOME="$outcome" ;;
            host_tools) HOST_TOOLS_OUTCOME="$outcome" ;;
            tool_inputs) TOOL_INPUT_OUTCOME="$outcome" ;;
            ic_tools) PROVISION_OUTCOME="$outcome" ;;
            native_ci) NATIVE_OUTCOME="$outcome" ;;
        esac
        if [[ "$step_status" != 0 ]]; then break; fi
    done
    printf '%s\n' "$status" > status.txt
    if [[ "$scenario" == success ]]; then [[ "$status" == 0 ]]; else [[ "$status" == 43 ]]; fi
    "$real_bash" --noprofile --norc -e -o pipefail "$fixture/commands/native_artifacts.sh" > archive.log 2>&1
    shasum -a 256 -c target/evidence/native-ci.tar.gz.sha256 > archive-check.log
    mkdir -p unpacked/target/evidence/native-ci
    tar -xzf target/evidence/native-ci.tar.gz -C unpacked/target/evidence/native-ci
    (cd unpacked && shasum -a 256 -c target/evidence/native-ci/artifact-sha256.txt) > content-check.log
    for file in inputs.txt source-commit.txt source-files.txt source-sha256.txt outcome.txt; do
        cmp "target/evidence/native-ci/$file" "unpacked/target/evidence/native-ci/$file"
    done
    expected="$(printf 'native=%s\ninputs=%s\nprovision=%s\nhost=%s\ntoolchain=%s\nrust=%s\nprerequisites=%s\nhost_tools=%s\ntool_inputs=%s' \
        "$NATIVE_OUTCOME" "$INPUT_OUTCOME" "$PROVISION_OUTCOME" "$HOST_OUTCOME" "$TOOLCHAIN_OUTCOME" \
        "$RUST_OUTCOME" "$PREREQUISITES_OUTCOME" "$HOST_TOOLS_OUTCOME" "$TOOL_INPUT_OUTCOME")"
    [[ "$(cat unpacked/target/evidence/native-ci/outcome.txt)" == "$expected" ]]
    if [[ "$scenario" == success ]]; then
        [[ -s unpacked/target/evidence/native-ci/tool-versions.txt ]]
        [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]]
    else
        case "$scenario" in
            rust-*) failed_log=rust-tools.log ;;
            host-*) failed_log=host-tools.log ;;
            ic-*) failed_log=provision.log ;;
            native) failed_log=native-ci.log ;;
        esac
        grep -Fx "make stdout: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
        grep -Fx "make stderr: $FIXTURE_FAILURE" "unpacked/target/evidence/native-ci/$failed_log" > /dev/null
        [[ "$(tail -1 commands.log)" == "$FIXTURE_FAILURE" ]]
        if [[ "$scenario" == rust-admission || "$scenario" == native ]]; then
            [[ ! -f unpacked/target/evidence/native-ci/tool-candidates.tar.gz ]]
        else
            mkdir recovered-candidates
            tar -xzf unpacked/target/evidence/native-ci/tool-candidates.tar.gz -C recovered-candidates
            for candidate in .tools/host-set.* .tools/ic-set.* .tools/rust; do
                if [[ -d "$candidate" ]]; then
                    cmp "$candidate/failure:payload" "recovered-candidates/$candidate/failure:payload"
                fi
            done
        fi
    fi
) done
echo 'Native evidence source/setup/archive cases passed (Make effects substituted; no hosted CI claim)'
