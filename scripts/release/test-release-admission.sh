#!/usr/bin/env bash
set -euo pipefail
export RELEASE_DELIVERY=direct

# Real index/commit and actual Make/logger boundaries; no commits or releases.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/metrics-release-admission.XXXXXX")"
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        [[ ! -f "$fixture/result.log" ]] || cat "$fixture/result.log" >&2
        echo "failed admission fixture retained: $fixture" >&2
    else
        rm -rf "$fixture"
    fi
    exit "$status"
}
trap cleanup EXIT
source_commit="$(git -C "$root" rev-parse HEAD)"
original_cargo_home="${CARGO_HOME-}"
original_cargo_home_set="${CARGO_HOME+x}"
selected_commit="$source_commit"
source_objects="$(git -C "$root" rev-parse --git-path objects)"
case "$source_objects" in /*) ;; *) source_objects="$root/$source_objects" ;; esac
mkdir -p "$fixture/bin" "$fixture/templates"
git -C "$root" archive --format=tar "$selected_commit" Cargo.toml crates |
    tar -xf - -C "$fixture"
selected_version="$(cd "$fixture" && bash "$root/scripts/release/metadata.sh" version)"
selected_date="$(git -C "$root" show "$selected_commit:CHANGELOG.md" | \
    awk -v heading="## [$selected_version] - " 'index($0, heading) == 1 { print $4; count++ } END { if (count != 1) exit 1 }')"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TEMPLATE_DIR="$fixture/templates"
real_bash="$(command -v bash)"
ADMISSION_REAL_GIT="$(command -v git)"
ADMISSION_REAL_CARGO="$(command -v cargo)"
ADMISSION_REAL_MAKE="$(command -v make)"
export ADMISSION_REAL_GIT ADMISSION_REAL_CARGO ADMISSION_REAL_MAKE
export ADMISSION_TOOL_ROOT="$root"
printf '#!%s\n' "$real_bash" > "$fixture/bin/git"
cat >> "$fixture/bin/git" <<'GIT'
set -euo pipefail
case "${ADMISSION_FAIL_GIT:-}:$1" in
    type:cat-file|export:archive|status:status)
        "$ADMISSION_REAL_GIT" "$@"
        exit 43 ;;
    *) exec "$ADMISSION_REAL_GIT" "$@" ;;
esac
GIT
chmod +x "$fixture/bin/git"
printf '#!%s\n' "$real_bash" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
set -euo pipefail
# Permission for preparation must not leak to Cargo or standalone helper reads.
[[ -z "${IC_METRICS_RELEASE_CACHE_PREPARE+x}" ]]
# Manifest parsing is read-only; keep it real while substituting effectful gates.
if [[ "${1:-}" == locate-project ]]; then exec "$ADMISSION_REAL_CARGO" "$@"; fi
printf '%s\n' "$*" >> "$ADMISSION_CARGO_EVENTS"
case "$*" in
    'set-version --help'|'sort --help'|'metadata --locked --offline --format-version 1') ;;
    'fetch --locked'|'fetch --locked --offline')
        if [[ "${ADMISSION_REAL_FETCH:-0}" == 1 ]]; then exec "$ADMISSION_REAL_CARGO" "$@"; fi
        if [[ ! -e "$ADMISSION_CACHE/input" ]]; then
            if [[ "$*" == *' --offline' || "${CARGO_NET_OFFLINE:-false}" == true ||
                  "${ADMISSION_CONFIG_OFFLINE:-false}" == true ]]; then
                echo 'controlled missing cache under explicit offline policy' >&2
                exit 43
            fi
            [[ "${ADMISSION_FETCH_FAILURE:-0}" == 0 ]] || exit "$ADMISSION_FETCH_FAILURE"
            printf 'prepared selected locked input\n' > "$ADMISSION_CACHE/input"
        fi ;;
    *) echo 'unexpected admission fixture Cargo command' >&2; exit 99 ;;
esac
CARGO
chmod +x "$fixture/bin/cargo"
printf '#!%s\n' "$real_bash" > "$fixture/bin/make"
cat >> "$fixture/bin/make" <<'MAKE'
set -euo pipefail
if [[ $# == 4 && "$1" == --no-print-directory && "$2" == -C && "$3" == "$ADMISSION_TOOL_ROOT" ]]; then
    case "$4" in
        install-rust-tools|rust-tools-check)
            printf '%s\n' "$4" >> "$ADMISSION_CARGO_EVENTS"
            [[ "${ADMISSION_TOOL_FAIL:-}" != "$4" ]] || exit 49
            if [[ "$4" == install-rust-tools ]]; then
                if [[ ! -f "$ADMISSION_CACHE/tool" && "${CARGO_NET_OFFLINE:-false}" == true ]]; then exit 57; fi
                [[ "${ADMISSION_TOOL_CHANGE:-no}" != yes ]] || printf '\n# changed selection\n' >> "$ADMISSION_TOOL_ROOT/ci/tool-versions.env"
                printf 'selected executable\n' > "$ADMISSION_CACHE/tool"
            else
                [[ -f "$ADMISSION_CACHE/tool" ]] || exit 53
            fi
            exit 0 ;;
    esac
fi
exec "$ADMISSION_REAL_MAKE" "$@"
MAKE
chmod +x "$fixture/bin/make"
export PATH="$fixture/bin:$PATH" ADMISSION_CARGO_EVENTS="$fixture/cargo-events"
setup() {
    local name="$1"
    worktree="$fixture/$name"
    mkdir -p "$worktree" "$fixture/attempts/$name"
    git -C "$worktree" init --quiet
    mkdir -p "$worktree/.git/objects/info"
    printf '%s\n' "$source_objects" > "$worktree/.git/objects/info/alternates"
    git -C "$worktree" update-ref HEAD "$source_commit"
    cd "$worktree"
    git read-tree HEAD
    git checkout-index --all
    # The index cases use prepared fixture metadata, independent of release tags.
    cat > Cargo.toml <<'TOML'
[workspace]
members = []
[workspace.package]
version = "0.1.1"
edition = "2024"
TOML
    printf 'version = 4\n\n[[package]]\nname = "ic-metrics"\nversion = "0.1.1"\n' > Cargo.lock
    printf '# Changelog\n\n## [0.1.1] - 2026-10-06\n\n- Prepared fixture.\n' > CHANGELOG.md
    git add -- Cargo.toml Cargo.lock CHANGELOG.md
    : > "$ADMISSION_CARGO_EVENTS"
    unset RELEASE_COMMIT ADMISSION_FAIL_GIT IC_METRICS_RELEASE_CACHE_PREPARE
    unset CARGO_NET_OFFLINE ADMISSION_CONFIG_OFFLINE ADMISSION_FETCH_FAILURE ADMISSION_REAL_FETCH
    unset ADMISSION_TOOL_FAIL ADMISSION_TOOL_CHANGE
    export ADMISSION_TOOL_ROOT="$root"
    if [[ -n "$original_cargo_home_set" ]]; then export CARGO_HOME="$original_cargo_home";
    else unset CARGO_HOME; fi
    export ADMISSION_CACHE="$fixture/cache/$name"
    mkdir -p "$ADMISSION_CACHE"
    # Existing admission scenarios have prepared inputs; new cache cases start cold.
    printf 'prepared selected locked input\n' > "$ADMISSION_CACHE/input"
    printf 'selected executable\n' > "$ADMISSION_CACHE/tool"
    export TMPDIR="$fixture/attempts/$name"
    export RELEASE_PREVIOUS=0.1.1 RELEASE_VERSION=0.1.2 RELEASE_DATE=2026-10-06
}
reject() {
    if bash "$root/scripts/release/metadata.sh" "$1" > "$fixture/result.log" 2>&1; then
        echo "admission unexpectedly accepted $worktree: $1" >&2
        exit 1
    fi
}

setup preflight-clean
bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1

# Locked preparation can fill a cold cache without touching release inputs.
# Offline environment/configuration and network errors are authoritative refusals.
for scenario in cold standalone-offline environment-offline config-offline network-failure warm-offline; do
    setup "cache-$scenario"
    mkdir "$fixture/originals-$scenario"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cp "$path" "$fixture/originals-$scenario/$path"; done
    cp .git/index "$fixture/originals-$scenario/index"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    if [[ "$scenario" != warm-offline ]]; then rm "$ADMISSION_CACHE/input"; fi
    expected_status=0
    expected_fetch='fetch --locked'
    case "$scenario" in
        standalone-offline) unset IC_METRICS_RELEASE_CACHE_PREPARE; expected_status=43; expected_fetch='fetch --locked --offline' ;;
        environment-offline) export CARGO_NET_OFFLINE=true; expected_status=43 ;;
        config-offline) export ADMISSION_CONFIG_OFFLINE=true; expected_status=43 ;;
        network-failure) export ADMISSION_FETCH_FAILURE=47; expected_status=47 ;;
        warm-offline) export CARGO_NET_OFFLINE=true ;;
    esac
    status=0
    bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == "$expected_status" ]]
    printf '%s\n' 'set-version --help' "$expected_fetch" > "$fixture/expected-cache-events"
    if [[ "$expected_status" == 0 ]]; then
        printf '%s\n' install-rust-tools rust-tools-check >> "$fixture/expected-cache-events"
    fi
    cmp "$fixture/expected-cache-events" "$ADMISSION_CARGO_EVENTS"
    if [[ "$expected_status" == 0 ]]; then [[ -f "$ADMISSION_CACHE/input" ]];
    else [[ ! -e "$ADMISSION_CACHE/input" ]]; fi
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "$path" "$fixture/originals-$scenario/$path"; done
    cmp .git/index "$fixture/originals-$scenario/index"
    [[ ! -e .git/release-state ]]
done

# Cargo itself admits explicit offline configuration/environment with an empty
# cache. Only tool probes are substituted; fetch executes the committed graph.
for policy in environment config; do
    setup "actual-offline-$policy"
    for path in Cargo.toml Cargo.lock; do git show "$source_commit:$path" > "$path"; done
    # Keep the real committed Cargo graph, but own the cache fixture's notes.
    # A repository draft may select a minor release instead of this test's patch.
    printf '# Changelog\n\n## [%s] - %s\n\n- Offline cache fixture.\n' \
        "$selected_version" "$selected_date" > CHANGELOG.md
    export RELEASE_PREVIOUS="$selected_version"
    export RELEASE_VERSION="${selected_version%.*}.$((${selected_version##*.} + 1))"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1 ADMISSION_REAL_FETCH=1
    export CARGO_HOME="$fixture/actual-cargo-home-$policy"
    mkdir "$CARGO_HOME"
    if [[ "$policy" == environment ]]; then export CARGO_NET_OFFLINE=true;
    else printf '[net]\noffline = true\n' > "$CARGO_HOME/config.toml"; fi
    originals="$fixture/actual-originals-$policy"
    mkdir "$originals"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cp "$path" "$originals/$path"; done
    cp .git/index "$originals/index"
    status=0
    bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == 101 ]]
    printf '%s\n' 'set-version --help' 'fetch --locked' > "$fixture/actual-events"
    cmp "$fixture/actual-events" "$ADMISSION_CARGO_EVENTS"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "$path" "$originals/$path"; done
    cmp .git/index "$originals/index"
    [[ ! -e .git/release-state ]]
done

## The actual runner must stop on fetch refusal before validation or preparation.
# Only Make dispatch is adapted: consumer preflight/version stay real, and a
# successful cold fetch reaches a deliberately failing substitute validation.
export ADMISSION_REAL_MAKE ADMISSION_METADATA="$root/scripts/release/metadata.sh"
cat > "$fixture/bin/release-make" <<'MAKE'
#!/usr/bin/env bash
set -euo pipefail
target=''
for argument in "$@"; do
    case "$argument" in
        RELEASE_*=*) export "$argument" ;;
        release-*) target="$argument" ;;
    esac
done
case "$target" in
    release-version) exec bash "$ADMISSION_METADATA" version ;;
    release-preflight) exec bash "$ADMISSION_METADATA" preflight ;;
    release-verify) printf 'validation\n' >> "$ADMISSION_CARGO_EVENTS"; exit 83 ;;
    '') exec "$ADMISSION_REAL_MAKE" "$@" ;;
    *) echo "unexpected release phase: $target" >&2; exit 99 ;;
esac
MAKE
chmod +x "$fixture/bin/release-make"
git init --bare --quiet "$fixture/destination.git"
for scenario in cold offline network-failure tool-setup-failure tool-check-failure; do
    setup "runner-cache-$scenario"
    git remote add origin "$fixture/destination.git"
    branch="$(git symbolic-ref --quiet --short HEAD)"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    rm "$ADMISSION_CACHE/input"
    case "$scenario" in
        offline) export CARGO_NET_OFFLINE=true ;;
        network-failure) export ADMISSION_FETCH_FAILURE=47 ;;
        tool-setup-failure) export ADMISSION_TOOL_FAIL=install-rust-tools ;;
        tool-check-failure) export ADMISSION_TOOL_FAIL=rust-tools-check ;;
    esac
    cp Cargo.lock "$fixture/runner-lock-before"
    status=0
    RELEASE_MAKE="$fixture/bin/release-make" bash "$root/scripts/ci/run-release.sh" patch origin "$branch" \
        > "$fixture/result.log" 2>&1 || status=$?
    printf '%s\n' 'set-version --help' 'fetch --locked' > "$fixture/runner-cache-events"
    if [[ "$scenario" == cold ]]; then
        [[ "$status" == 83 && -e "$ADMISSION_CACHE/input" ]]
        printf '%s\n' install-rust-tools rust-tools-check validation >> "$fixture/runner-cache-events"
    elif [[ "$scenario" == tool-* ]]; then
        [[ "$status" == 1 && -e "$ADMISSION_CACHE/input" ]]
        printf '%s\n' install-rust-tools >> "$fixture/runner-cache-events"
        if [[ "$scenario" == tool-check-failure ]]; then
            printf '%s\n' rust-tools-check >> "$fixture/runner-cache-events"
        fi
    else [[ "$status" == 1 && ! -e "$ADMISSION_CACHE/input" ]]; fi
    cmp "$fixture/runner-cache-events" "$ADMISSION_CARGO_EVENTS"
    cmp Cargo.lock "$fixture/runner-lock-before"
    for plan in .git/release-state/*.plan; do [[ ! -e "$plan" ]]; done
done

# Actual preflight/runner routing admits selected executables after source/cache
# admission and before the gate. Setup/check effects remain substituted.
for scenario in cold reuse setup-failure check-failure standalone-missing offline-missing pins-changed; do
    setup "tool-$scenario"
    originals="$fixture/tool-originals-$scenario"
    mkdir "$originals"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cp "$path" "$originals/$path"; done
    cp .git/index "$originals/index"
    printf 'old installed executable\n' > "$ADMISSION_CACHE/old-tool"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    expected_status=0
    expected_targets=(install-rust-tools rust-tools-check)
    case "$scenario" in
        cold) rm "$ADMISSION_CACHE/tool" ;;
        setup-failure) export ADMISSION_TOOL_FAIL=install-rust-tools; expected_status=49; expected_targets=(install-rust-tools) ;;
        check-failure) export ADMISSION_TOOL_FAIL=rust-tools-check; expected_status=49 ;;
        standalone-missing)
            unset IC_METRICS_RELEASE_CACHE_PREPARE
            rm "$ADMISSION_CACHE/tool"
            expected_status=53; expected_targets=(rust-tools-check) ;;
        offline-missing)
            export CARGO_NET_OFFLINE=true
            rm "$ADMISSION_CACHE/tool"
            expected_status=57; expected_targets=(install-rust-tools) ;;
        pins-changed)
            # Copy the script owners, so the controlled mutation cannot touch
            # the real repository's reviewed tool pins.
            tool_root="$fixture/changed-tool-root"
            mkdir -p "$tool_root/scripts/release" "$tool_root/scripts/ci" "$tool_root/ci"
            cp "$root/scripts/release/metadata.sh" "$tool_root/scripts/release/"
            for helper in read-cargo-workspace-version.sh check-release-source.sh verify-file-checksum.sh; do
                cp "$root/scripts/ci/$helper" "$tool_root/scripts/ci/"
            done
            cp "$root/ci/tool-versions.env" "$tool_root/ci/"
            export ADMISSION_TOOL_ROOT="$tool_root" ADMISSION_TOOL_CHANGE=yes
            expected_status=1; expected_targets=(install-rust-tools) ;;
    esac
    status=0
    bash "$ADMISSION_TOOL_ROOT/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == "$expected_status" ]]
    expected_fetch='fetch --locked'
    if [[ "$scenario" == standalone-missing ]]; then expected_fetch='fetch --locked --offline'; fi
    printf '%s\n' 'set-version --help' "$expected_fetch" "${expected_targets[@]}" > "$fixture/expected-tool-events"
    cmp "$fixture/expected-tool-events" "$ADMISSION_CARGO_EVENTS"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "$path" "$originals/$path"; done
    cmp .git/index "$originals/index"
    [[ "$(cat "$ADMISSION_CACHE/old-tool")" == 'old installed executable' ]]
    [[ ! -e .git/release-state ]]
done

for scenario in unstaged staged-hidden untracked; do
    setup "preflight-$scenario"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    case "$scenario" in
        unstaged) printf '\nUnrelated edit.\n' >> README.md ;;
        staged-hidden)
            printf '\nHidden staged edit.\n' >> README.md
            git add -- README.md
            git show HEAD:README.md > README.md
            git diff --quiet HEAD -- README.md
            ;;
        untracked) printf 'Unrelated source.\n' > untracked.txt ;;
    esac
    reject preflight
    [[ ! -s "$ADMISSION_CARGO_EVENTS" ]]
done

setup preflight-all-blockers
export IC_METRICS_RELEASE_CACHE_PREPARE=1
printf '\nHidden staged edit.\n' >> README.md
git add -- README.md
git show HEAD:README.md > README.md
printf '\n# Unstaged edit.\n' >> Makefile
untracked=$'source name\nwith newline.rs'
printf 'Untracked input.\n' > "$untracked"
printf '\n# Allowed lock-only work.\n' >> Cargo.lock
cp .git/index "$fixture/index-before"
for path in README.md Makefile "$untracked" Cargo.lock; do
    cp "$path" "$fixture/$(printf '%s' "$path" | shasum -a 256 | cut -d ' ' -f 1)"
done
reject preflight
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]]
grep -F 'staged: README.md' "$fixture/result.log" >/dev/null
grep -F 'unstaged: Makefile' "$fixture/result.log" >/dev/null
printf 'untracked: %q\n' "$untracked" > "$fixture/expected-path"
grep -F -f "$fixture/expected-path" "$fixture/result.log" >/dev/null
grep -F 'has not started validation or version preparation' "$fixture/result.log" >/dev/null
cmp .git/index "$fixture/index-before"
for path in README.md Makefile "$untracked" Cargo.lock; do
    cmp "$path" "$fixture/$(printf '%s' "$path" | shasum -a 256 | cut -d ' ' -f 1)"
done

setup preflight-allowed-lock
printf '\n# Allowed lock-only work.\n' >> Cargo.lock
cp Cargo.lock "$fixture/lock-before"
cp .git/index "$fixture/index-before"
bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1
cmp Cargo.lock "$fixture/lock-before"
cmp .git/index "$fixture/index-before"

setup preflight-failed-status
cp .git/index "$fixture/index-before"
export ADMISSION_FAIL_GIT=status
reject preflight
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]]
grep -F 'cannot inspect' "$fixture/result.log" >/dev/null
cmp .git/index "$fixture/index-before"

setup conflicting-pending-notes
export IC_METRICS_RELEASE_CACHE_PREPARE=1
{ printf '# Changelog\n\n## [0.9.9]\n\n- Conflicting draft.\n\n'; cat CHANGELOG.md; } > notes.fixture
mv notes.fixture CHANGELOG.md
reject preflight
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]]

setup commit-clean
export RELEASE_VERSION=0.1.1
bash "$root/scripts/release/metadata.sh" commit-check > "$fixture/result.log" 2>&1
for path in README.md Cargo.toml Cargo.lock CHANGELOG.md; do
    setup "commit-hidden-${path//\//_}"
    export RELEASE_VERSION=0.1.1
    cp "$path" "$fixture/prepared-file"
    printf '\n# Hidden staged content.\n' >> "$path"
    git add -- "$path"
    cp "$fixture/prepared-file" "$path"
    reject commit-check
done

setup lock-version-mismatch
export RELEASE_VERSION=0.1.1
awk '
    /^\[\[package\]\]$/ { owned=0 }
    /^name = "ic-metrics"$/ { owned=1 }
    owned && /^version = / { $0="version = \"0.9.9\"" }
    { print }
' Cargo.lock > lock.fixture
mv lock.fixture Cargo.lock
reject commit-check
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]]

# Older release checks use the selected commit, despite newer worktree metadata.
setup selected-older-commit
export RELEASE_COMMIT="$selected_commit" RELEASE_VERSION="$selected_version" RELEASE_DATE="$selected_date"
printf 'Newer unrelated worktree metadata.\n' > Cargo.toml
bash "$root/scripts/release/metadata.sh" check > "$fixture/result.log" 2>&1
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]]
for remaining in "$TMPDIR"/*; do [[ ! -e "$remaining" ]]; done
export RELEASE_VERSION=9.8.7
reject check
set -- "$TMPDIR"/metrics-committed-metadata.*
[[ $# == 1 && -d "$1" ]]
grep -F "failed selected-commit metadata retained: $1" "$fixture/result.log" >/dev/null
for path in Cargo.toml Cargo.lock CHANGELOG.md; do
    git show "$selected_commit:$path" > "$fixture/expected-metadata"
    cmp "$fixture/expected-metadata" "$1/$path"
done
export RELEASE_VERSION="$selected_version" RELEASE_DATE=1999-01-01
reject check
export RELEASE_DATE="$selected_date" RELEASE_COMMIT=abcdef0
reject check
export RELEASE_COMMIT=0000000000000000000000000000000000000000
reject check
RELEASE_COMMIT="$(git rev-parse "$source_commit:Cargo.toml")"
export RELEASE_COMMIT
reject check

# Valid-looking output cannot override a failed Git producer. Export failures
# retain the selected input and status; type failures stop before creating it.
for scenario in type export; do
    setup "selected-failed-$scenario"
    export RELEASE_COMMIT="$selected_commit" RELEASE_VERSION="$selected_version" RELEASE_DATE="$selected_date"
    export ADMISSION_FAIL_GIT="$scenario"
    status=0
    bash "$root/scripts/release/metadata.sh" check > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == 43 && ! -s "$ADMISSION_CARGO_EVENTS" ]]
    unset ADMISSION_FAIL_GIT
    if [[ "$scenario" == type ]]; then
        for remaining in "$TMPDIR"/*; do [[ ! -e "$remaining" ]]; done
    else
        set -- "$TMPDIR"/metrics-committed-metadata.*
        [[ $# == 1 && -f "$1/Cargo.toml" ]]
        grep -F "failed selected-commit metadata retained: $1" "$fixture/result.log" >/dev/null
        git show "$selected_commit:Cargo.toml" > "$fixture/expected-metadata"
        cmp "$fixture/expected-metadata" "$1/Cargo.toml"
    fi
done

# Execute this consumer's release-verify adapter, substituting only cheap gates.
# Nested Make must preserve release selections and never route to the parent CI.
for scenario in retention fallback; do
    setup "logger-$scenario"
    mkdir -p scripts/ci make "$worktree/tmp"
    cp "$root/make/tools.mk" "$root/make/release.mk" "$root/make/rust-format.mk" "$root/make/execution.mk" make/
    cp "$root/scripts/ci/run-validation-targets.sh" scripts/ci/
    cp "$root/scripts/ci/check-make-execution.sh" "$root/scripts/ci/run-formatting.sh" scripts/ci/
    cat > Makefile <<'MAKE'
.PHONY: ci msrv
ci:
	@test -z "$${IC_METRICS_RELEASE_CACHE_PREPARE+x}"
	@test "$${CARGO_NET_OFFLINE:-false}" = true
	@test "$(RELEASE_VERSION)" = 9.8.7
	@test "$(RELEASE_COMMIT)" = selected-fixture-commit
	@echo "error: retained-gate-failure"
	@echo "attempt=$$(cat attempt)"
	@exit 7
msrv:
	@echo incorrect-msrv-route >> incorrect-route
	@exit 9
MAKE
    if [[ "$scenario" == fallback ]]; then
        mkdir -p .git/release-state
        printf 'Blocked retention destination.\n' > .git/release-state/validation-failures
    fi
    for attempt in 1 2; do
        printf '%s\n' "$attempt" > attempt
        if IC_METRICS_RELEASE_CACHE_PREPARE=1 TMPDIR="$worktree/tmp" make --no-print-directory -f "$root/Makefile" release-verify \
            RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit \
            > "$fixture/result.log" 2>&1; then
            echo 'release-verify unexpectedly passed failed gate' >&2
            exit 1
        fi
        grep -F retained-gate-failure "$fixture/result.log" >/dev/null
    done
    [[ ! -e incorrect-route ]]
    if [[ "$scenario" == retention ]]; then
        logs=(.git/release-state/validation-failures/*-0-ci.log)
    else
        logs=(tmp/validation.*/0.log)
        grep -F 'Validation logs retained at:' "$fixture/result.log" >/dev/null
    fi
    [[ "${#logs[@]}" == 2 ]]
    for log in "${logs[@]}"; do grep -F retained-gate-failure "$log" >/dev/null; done
done

# Rejected Make modes cannot execute a gate or announce successful validation.
# Use the current consumer logger directly; no release or real CI is dispatched.
for mode in i n q t v --ignore-errors; do
    setup "logger-make-mode-$mode"
    cat > Makefile <<'MAKE'
.PHONY: ci
ci:
	@echo reached >> gate-events
	@exit 7
MAKE
    if MAKEFLAGS="$mode" VALIDATION_REPOSITORY_ROOT="$worktree" \
        bash "$root/scripts/ci/run-validation-targets.sh" --fail-fast ci \
        > "$fixture/result.log" 2>&1; then
        echo 'consumer logger accepted an incompatible Make mode' >&2
        exit 1
    fi
    grep -F 'requires recipe execution and failure propagation' "$fixture/result.log" >/dev/null
    [[ ! -e gate-events ]]
    if grep -F 'VALIDATION PASSED' "$fixture/result.log" >/dev/null; then exit 1; fi
done

# The second gate still runs after successful CI; its failures are retained too.
setup logger-second-gate
mkdir -p scripts/ci make
cp "$root/make/tools.mk" "$root/make/release.mk" "$root/make/rust-format.mk" "$root/make/execution.mk" make/
cp "$root/scripts/ci/run-validation-targets.sh" scripts/ci/
cp "$root/scripts/ci/check-make-execution.sh" "$root/scripts/ci/run-formatting.sh" scripts/ci/
cat > Makefile <<'MAKE'
.PHONY: ci msrv
ci:
	@test "$(RELEASE_VERSION)" = 9.8.7
	@echo ci >> gate-events
msrv:
	@test "$(RELEASE_COMMIT)" = selected-fixture-commit
	@echo msrv >> gate-events
	@if test "$(FAIL_MSRV)" = yes; then echo 'error: retained-msrv-failure'; exit 9; fi
.PHONY: wasm-inspect-msrv
wasm-inspect-msrv:
	@test "$(RELEASE_COMMIT)" = selected-fixture-commit
	@echo wasm-inspect-msrv >> gate-events
	@if test "$(FAIL_HOST_MSRV)" = yes; then echo 'error: retained-host-msrv-failure'; exit 9; fi
MAKE
if make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit FAIL_MSRV=yes \
    > "$fixture/result.log" 2>&1; then
    echo 'release-verify unexpectedly passed failed second gate' >&2
    exit 1
fi
printf 'ci\nmsrv\n' > "$fixture/expected-gates"
cmp gate-events "$fixture/expected-gates"
second_logs=(.git/release-state/validation-failures/*-1-msrv.log)
[[ "${#second_logs[@]}" == 1 ]]
grep -F retained-msrv-failure "${second_logs[0]}" >/dev/null
: > gate-events
if make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit FAIL_MSRV=no FAIL_HOST_MSRV=yes \
    > "$fixture/result.log" 2>&1; then
    echo 'release-verify unexpectedly passed failed host minimum gate' >&2
    exit 1
fi
printf 'ci\nmsrv\nwasm-inspect-msrv\n' > "$fixture/expected-gates"
cmp gate-events "$fixture/expected-gates"
host_logs=(.git/release-state/validation-failures/*-2-wasm-inspect-msrv.log)
[[ "${#host_logs[@]}" == 1 ]]
grep -F retained-host-msrv-failure "${host_logs[0]}" >/dev/null
: > gate-events
make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit FAIL_MSRV=no \
    > "$fixture/result.log" 2>&1
cmp gate-events "$fixture/expected-gates"
grep -F retained-msrv-failure "${second_logs[0]}" >/dev/null
grep -F retained-host-msrv-failure "${host_logs[0]}" >/dev/null
echo 'release admission, cache preparation, selected-commit metadata and Make/logger retention passed (real Git/offline fetch; remaining Cargo effects and gates substituted)'
