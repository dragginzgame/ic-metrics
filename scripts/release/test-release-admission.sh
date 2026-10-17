#!/usr/bin/env bash
set -euo pipefail
export RELEASE_DELIVERY=direct

# Real index and actual Make/logger boundaries; only isolated fixture Git objects.
# Selected-release checks retain the actual product commit; no product Git writes.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
# Intentional logger failures and summaries belong to this fixture's inputs.
unset VALIDATION_LOG_DIR VALIDATION_FAILURE_LOG_DIR GITHUB_STEP_SUMMARY
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-release-admission.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        [[ ! -f "$fixture/result.log" ]] || cat "$fixture/result.log" >&2
    fi
    fixture_finish "$status" "$fixture" "failed admission fixture retained"
}
trap cleanup EXIT
source_commit="$(git -C "$root" rev-parse HEAD)"
selected_commit="$source_commit"
source_objects="$(git -C "$root" rev-parse --git-path objects)"
case "$source_objects" in /*) ;; *) source_objects="$root/$source_objects" ;; esac
mkdir -p "$fixture/bin" "$fixture/templates"
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
    status:status)
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
[[ -z "${IC_METRICS_RELEASE_CACHE_PREPARE+x}" ]] || exit 1
# Manifest parsing is read-only; keep it real while substituting effectful gates.
if [[ "${1:-}" == locate-project ]]; then exec "$ADMISSION_REAL_CARGO" "$@"; fi
printf '%s\n' "$*" >> "$ADMISSION_CARGO_EVENTS"
case "$*" in
    'sort --workspace --check') exec "$ADMISSION_REAL_CARGO" "$@" ;;
    'metadata --locked --offline --format-version 1')
        if grep -q '^members = \[\]' Cargo.toml; then
            # Synthetic index-admission cases substitute graph facts. Selected
            # committed-source cases below use real locked Cargo metadata.
            printf '{"workspace_members":["fixture"],"packages":[{"id":"fixture","name":"ic-metrics","source":null,"version":"0.1.1"}]}\n'
        else
            exec "$ADMISSION_REAL_CARGO" "$@"
        fi ;;

    'fetch --locked'|'fetch --locked --offline')
        if [[ ! -e "$ADMISSION_CACHE/input" ]]; then
            if [[ "$*" == *' --offline' || "${CARGO_NET_OFFLINE:-false}" == true ]]; then
                echo 'controlled missing cache under explicit offline policy' >&2
                exit 43
            fi
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
            if [[ "$4" == install-rust-tools ]]; then
                [[ "${ADMISSION_TOOL_CHANGE:-no}" != yes ]] || printf '\n# changed selection\n' >> "${RUST_TOOL_VERSIONS:-$ADMISSION_TOOL_ROOT/ci/tool-versions.env}"
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
# Synthetic index/cache/logger cases need tiny metadata/helper inputs, not
# historical evidence or the complete product checkout. Build one fixture-local Git identity;
# real selected-release objects remain available independently through alternates.
baseline="$fixture/baseline"
mkdir "$baseline"
"$ADMISSION_REAL_GIT" -C "$baseline" init --quiet
cat > "$baseline/Cargo.toml" <<'TOML'
[workspace]
members = []
[workspace.package]
version = "0.1.1"
edition = "2024"
TOML
printf 'version = 4\n\n[[package]]\nname = "ic-metrics"\nversion = "0.1.1"\n' > "$baseline/Cargo.lock"
printf '# Changelog\n\n## [0.1.1] - 2026-10-06\n\n- Fixture baseline.\n' > "$baseline/CHANGELOG.md"
printf 'Tracked consumer source sentinel.\n' > "$baseline/README.md"
mkdir -p "$baseline/scripts/ci"
cp "$root/scripts/ci/finalize-release-changelog.awk" "$baseline/scripts/ci/"
"$ADMISSION_REAL_GIT" -C "$baseline" add -- Cargo.toml Cargo.lock CHANGELOG.md README.md scripts/ci/finalize-release-changelog.awk
baseline_tree="$("$ADMISSION_REAL_GIT" -C "$baseline" write-tree)"
baseline_commit="$(printf 'Isolated source-admission fixture\n' | \
    GIT_AUTHOR_NAME=Fixture GIT_AUTHOR_EMAIL=fixture@example.invalid GIT_AUTHOR_DATE=2026-01-01T00:00:00Z \
    GIT_COMMITTER_NAME=Fixture GIT_COMMITTER_EMAIL=fixture@example.invalid GIT_COMMITTER_DATE=2026-01-01T00:00:00Z \
    "$ADMISSION_REAL_GIT" -C "$baseline" commit-tree "$baseline_tree")"
# Share source objects once at the fixture baseline. Git owns each ordinary
# clone's alternates, refs, index and checkout; no linked-worktree Git context.
"$ADMISSION_REAL_GIT" -C "$baseline" update-ref HEAD "$baseline_commit"
printf '%s\n' "$source_objects" > "$baseline/.git/objects/info/alternates"
setup() {
    local name="$1" checkout_commit="${2:-$baseline_commit}"
    worktree="$fixture/$name"
    mkdir -p "$fixture/attempts/$name"
    git clone --quiet --shared --no-checkout --origin fixture-source "$baseline" "$worktree"
    git -C "$worktree" checkout --quiet -B fixture "$checkout_commit"
    cd "$worktree"
    [[ -d .git && "$(git rev-parse HEAD)" == "$checkout_commit" ]] || exit 1
    : > "$ADMISSION_CARGO_EVENTS"
    unset RELEASE_COMMIT ADMISSION_FAIL_GIT IC_METRICS_RELEASE_CACHE_PREPARE
    unset CARGO_NET_OFFLINE ADMISSION_TOOL_CHANGE RUST_TOOL_VERSIONS
    export ADMISSION_TOOL_ROOT="$root"
    export ADMISSION_CACHE="$fixture/cache/$name"
    mkdir -p "$ADMISSION_CACHE"
    # Existing admission scenarios have prepared inputs; new cache cases start cold.
    printf 'prepared selected locked input\n' > "$ADMISSION_CACHE/input"
    printf 'selected executable\n' > "$ADMISSION_CACHE/tool"
    export TMPDIR="$fixture/attempts/$name"
    export RELEASE_PREVIOUS=0.1.1 RELEASE_VERSION=0.1.2 RELEASE_DATE=2026-10-06
}
prepare_validation_adapter() {
    mkdir -p "$worktree/tmp"
    bash "$root/scripts/ci/prepare-make-fixture.sh" "$root" "$worktree"
    mkdir -p "$worktree/ci"
    cp "$root/ci/release-delivery.txt" "$worktree/ci/"
    cp "$root"/scripts/ci/{run-validation-targets,verify-file-checksum}.sh scripts/ci/
}

reject() {
    if bash "$root/scripts/release/metadata.sh" "$1" > "$fixture/result.log" 2>&1; then
        echo "admission unexpectedly accepted $worktree: $1" >&2
        exit 1
    fi
}

setup preflight-clean
bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1

# Shared owns the simulated cache matrix. Retain this adapter's internal
# preparation selection and standalone refusal, including actual index custody.
for scenario in cold standalone-offline; do
    setup "cache-$scenario"
    mkdir "$fixture/originals-$scenario"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cp "$path" "$fixture/originals-$scenario/$path"; done
    cp .git/index "$fixture/originals-$scenario/index"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    rm "$ADMISSION_CACHE/input"
    expected_status=0
    expected_fetch='fetch --locked'
    case "$scenario" in
        standalone-offline) unset IC_METRICS_RELEASE_CACHE_PREPARE; expected_status=43; expected_fetch='fetch --locked --offline' ;;
    esac
    status=0
    bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == "$expected_status" ]] || exit 1
    printf '%s\n' "$expected_fetch" > "$fixture/expected-cache-events"
    if [[ "$expected_status" == 0 ]]; then
        printf '%s\n' install-rust-tools rust-tools-check >> "$fixture/expected-cache-events"
    fi
    cmp "$fixture/expected-cache-events" "$ADMISSION_CARGO_EVENTS"
    if [[ "$expected_status" == 0 ]]; then [[ -f "$ADMISSION_CACHE/input" ]] || exit 1;
    else [[ ! -e "$ADMISSION_CACHE/input" ]] || exit 1; fi
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "$path" "$fixture/originals-$scenario/$path"; done
    cmp .git/index "$fixture/originals-$scenario/index"
    [[ ! -e .git/release-state ]] || exit 1
done

# Shared PR #235 owns real Cargo environment/config offline refusal with a
# frozen minimal graph. This consumer retains authority routing and Git custody.

# Shared qualifies the complete runner/helper failure matrix. Keep the local
# preparation-authority handoff and one refusal before validation/preparation.
# Only Make dispatch is adapted: consumer preflight/version stay real, and a
# successful cold fetch reaches a deliberately failing substitute validation.
export ADMISSION_REAL_MAKE ADMISSION_METADATA="$root/scripts/release/metadata.sh"
cat > "$fixture/bin/release-make" <<'MAKE'
#!/usr/bin/env bash
set -euo pipefail
target=''
for argument in "$@"; do
    case "$argument" in
        install-rust-tools|rust-tools-check) exec "${BASH_SOURCE[0]%/*}/make" "$@" ;;
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
for scenario in cold offline; do
    setup "runner-cache-$scenario"
    git remote add origin "$fixture/destination.git"
    branch="$(git symbolic-ref --quiet --short HEAD)"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    rm "$ADMISSION_CACHE/input"
    case "$scenario" in
        offline) export CARGO_NET_OFFLINE=true ;;
    esac
    cp Cargo.lock "$fixture/runner-lock-before"
    status=0
    RELEASE_MAKE="$fixture/bin/release-make" bash "$root/scripts/ci/run-release.sh" patch origin "$branch" \
        > "$fixture/result.log" 2>&1 || status=$?
    printf '%s\n' 'fetch --locked' > "$fixture/runner-cache-events"
    if [[ "$scenario" == cold ]]; then
        [[ "$status" == 83 && -e "$ADMISSION_CACHE/input" ]] || exit 1
        printf '%s\n' install-rust-tools rust-tools-check validation >> "$fixture/runner-cache-events"
    else [[ "$status" == 1 && ! -e "$ADMISSION_CACHE/input" ]] || exit 1; fi
    cmp "$fixture/runner-cache-events" "$ADMISSION_CARGO_EVENTS"
    cmp Cargo.lock "$fixture/runner-lock-before"
    for plan in .git/release-state/*.plan; do [[ ! -e "$plan" ]] || exit 1; done
done

# Shared owns generic tool availability/failure and pin-drift cases. Retain
# Metrics' standalone target selection and its explicit catalog override routing.
# The actual runner's setup/check refusal-before-validation cases stay above.
for scenario in standalone-missing explicit-pins-changed; do
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
        standalone-missing)
            unset IC_METRICS_RELEASE_CACHE_PREPARE
            rm "$ADMISSION_CACHE/tool"
            expected_status=53; expected_targets=(rust-tools-check) ;;
        explicit-pins-changed)
            # Copy the script owners, so the controlled mutation cannot touch
            # the real repository's reviewed tool pins.
            tool_root="$fixture/changed-tool-root-$scenario"
            mkdir -p "$tool_root/scripts/release" "$tool_root/scripts/ci" "$tool_root/ci"
            # Metadata owners resolve physical paths; scratch may traverse a
            # target-directory symlink in a disposable source qualification.
            tool_root="$(cd -P "$tool_root" && printf '%s/.' "$PWD")"
            tool_root="${tool_root%/.}"
            cp "$root/scripts/release/metadata.sh" "$tool_root/scripts/release/"
            for helper in read-cargo-workspace-version.sh check-release-source.sh check-release-delivery.sh verify-file-checksum.sh cargo-release-preflight.sh check-release-changelog.sh finalize-release-changelog.awk; do
                cp "$root/scripts/ci/$helper" "$tool_root/scripts/ci/"
            done
            cp "$root/ci/tool-versions.env" "$tool_root/ci/"
            cp "$root/ci/release-delivery.txt" "$tool_root/ci/"
            export ADMISSION_TOOL_ROOT="$tool_root" ADMISSION_TOOL_CHANGE=yes
            export RUST_TOOL_VERSIONS="$fixture/selected Rust pins.env"
            cp "$root/ci/tool-versions.env" "$RUST_TOOL_VERSIONS"
            expected_status=1; expected_targets=(install-rust-tools) ;;
    esac
    status=0
    bash "$ADMISSION_TOOL_ROOT/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == "$expected_status" ]] || exit 1
    expected_fetch='fetch --locked'
    if [[ "$scenario" == standalone-missing ]]; then expected_fetch='fetch --locked --offline'; fi
    printf '%s\n' "$expected_fetch" "${expected_targets[@]}" > "$fixture/expected-tool-events"
    cmp "$fixture/expected-tool-events" "$ADMISSION_CARGO_EVENTS"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "$path" "$originals/$path"; done
    cmp .git/index "$originals/index"
    [[ "$(cat "$ADMISSION_CACHE/old-tool")" == 'old installed executable' ]] || exit 1
    if [[ "$scenario" == explicit-pins-changed ]]; then
        cmp "$root/ci/tool-versions.env" "$ADMISSION_TOOL_ROOT/ci/tool-versions.env"
    fi
    [[ ! -e .git/release-state ]] || exit 1
done

# Shared's exportable source fixture owns generic Git/path diagnostics.
# Keep the actual consumer adapter's refusal before cache/tool dispatch.
setup preflight-hidden-staged
export IC_METRICS_RELEASE_CACHE_PREPARE=1
printf '\nHidden staged edit.\n' >> README.md
git add -- README.md
git show HEAD:README.md > README.md
cp .git/index "$fixture/index-before"
cp README.md "$fixture/readme-before"
reject preflight
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]] || exit 1
grep -F 'has not started validation or version preparation' "$fixture/result.log" >/dev/null
cmp .git/index "$fixture/index-before"
cmp README.md "$fixture/readme-before"

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
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]] || exit 1
grep -F 'cannot inspect' "$fixture/result.log" >/dev/null
cmp .git/index "$fixture/index-before"

setup conflicting-pending-notes
export IC_METRICS_RELEASE_CACHE_PREPARE=1
{ printf '# Changelog\n\n## [0.9.9]\n\n- Conflicting draft.\n\n'; cat CHANGELOG.md; } > notes.fixture
mv notes.fixture CHANGELOG.md
reject preflight
[[ ! -s "$ADMISSION_CARGO_EVENTS" ]] || exit 1

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
printf 'sort --workspace --check\n' > "$fixture/expected-order-only"
cmp "$fixture/expected-order-only" "$ADMISSION_CARGO_EVENTS"

# Older release checks use the selected commit, despite newer worktree metadata.
setup selected-older-commit "$selected_commit"
# Read metadata from this exact selected checkout, without a second source export.
selected_version="$(bash "$root/scripts/release/metadata.sh" version)"
selected_date="$(awk -v heading="## [$selected_version] - " \
    'index($0, heading) == 1 { print $4; count++ } END { if (count != 1) exit 1 }' CHANGELOG.md)"
export RELEASE_COMMIT="$selected_commit" RELEASE_VERSION="$selected_version" RELEASE_DATE="$selected_date"
printf 'Newer unrelated worktree metadata.\n' > Cargo.toml
bash "$root/scripts/release/metadata.sh" check > "$fixture/result.log" 2>&1
printf 'sort --workspace --check\nmetadata --locked --offline --format-version 1\n' > "$fixture/expected-selected-events"
cmp "$fixture/expected-selected-events" "$ADMISSION_CARGO_EVENTS"
: > "$ADMISSION_CARGO_EVENTS"
for remaining in "$TMPDIR"/*; do [[ ! -e "$remaining" ]] || exit 1; done
export RELEASE_VERSION=9.8.7
reject check
set -- "$TMPDIR"/cargo-release-check.*
[[ $# == 1 && -d "$1" ]] || exit 1
grep -F "failed Cargo metadata check retained: $1" "$fixture/result.log" >/dev/null
for path in Cargo.toml Cargo.lock CHANGELOG.md; do
    git show "$selected_commit:$path" > "$fixture/expected-metadata"
    cmp "$fixture/expected-metadata" "$1/source/$path"
done
# Shared owns the invalid Git identity, missing-variable and failed-producer
# matrix. The actual two-package selected source and its rejected-version receipt
# remain checked above through this consumer's adapter.

# Execute this consumer's release-verify adapter, substituting only cheap gates.
# Nested Make must preserve release selections and never route to the parent CI.
# Shared qualifies fallback destinations and repeated-failure log preservation.
# Keep the actual adapter's selected destination, environment and gate refusal.
setup logger-retention
prepare_validation_adapter
cat > Makefile <<'MAKE'
.PHONY: ci msrv
ci:
	@test -z "$${IC_METRICS_RELEASE_CACHE_PREPARE+x}"
	@test "$${CARGO_NET_OFFLINE:-false}" = true
	@test "$(RELEASE_VERSION)" = 9.8.7
	@test "$(RELEASE_COMMIT)" = selected-fixture-commit
	@echo "error: retained-gate-failure"
	@exit 7
msrv:
	@echo incorrect-msrv-route >> incorrect-route
	@exit 9
MAKE
if IC_METRICS_RELEASE_CACHE_PREPARE=1 TMPDIR="$worktree/tmp" make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit \
    > "$fixture/result.log" 2>&1; then
    echo 'release-verify unexpectedly passed failed gate' >&2
    exit 1
fi
grep -F retained-gate-failure "$fixture/result.log" >/dev/null
[[ ! -e incorrect-route ]] || exit 1
logs=(.git/release-state/validation-failures/*-0-ci.log)
[[ "${#logs[@]}" == 1 ]] || exit 1
grep -F retained-gate-failure "${logs[0]}" >/dev/null

# The second gate still runs after successful CI; its failures are retained too.
setup logger-second-gate
prepare_validation_adapter
cat > Makefile <<'MAKE'
.PHONY: ci msrv
ci:
	@test "$(RELEASE_VERSION)" = 9.8.7
	@echo ci >> gate-events
msrv:
	@test "$(RELEASE_COMMIT)" = selected-fixture-commit
	@echo msrv >> gate-events
	@if test "$(FAIL_MSRV)" = yes; then echo 'error: retained-msrv-failure'; exit 9; fi

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
[[ "${#second_logs[@]}" == 1 ]] || exit 1
grep -F retained-msrv-failure "${second_logs[0]}" >/dev/null
: > gate-events
make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit FAIL_MSRV=no \
    > "$fixture/result.log" 2>&1
cmp gate-events "$fixture/expected-gates"
grep -F retained-msrv-failure "${second_logs[0]}" >/dev/null
# Shared owns the complete depth matrix. Check Metrics' actual release adapter
# refuses inherited invalid depth before either selected gate can run.
: > gate-events
if VALIDATION_RUNNER_DEPTH=08 VALIDATION_LOG_DIR="$worktree/refused-depth-logs" \
    make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit \
    > "$fixture/result.log" 2>&1; then
    echo 'release-verify accepted invalid inherited depth' >&2
    exit 1
fi
grep -F 'VALIDATION_RUNNER_DEPTH must be' "$fixture/result.log" >/dev/null
[[ ! -s gate-events && ! -e refused-depth-logs ]] || exit 1
# Prepared Cargo inputs must stay fixed between release validation stages.
setup logger-input-drift
prepare_validation_adapter
cat > Makefile <<'MAKE'
.PHONY: ci msrv
ci:
	@echo ci >> gate-events
	@printf '\n# changed during validation\n' >> Cargo.lock
msrv:
	@echo unexpected >> gate-events
	@exit 99
MAKE
if TMPDIR="$worktree/tmp" make --no-print-directory -f "$root/Makefile" release-verify \
    > "$fixture/result.log" 2>&1; then
    echo 'release-verify accepted changed prepared inputs' >&2
    exit 1
fi
printf 'ci\n' > "$fixture/expected-gates"
cmp gate-events "$fixture/expected-gates"
set -- "$worktree"/tmp/validation.*
[[ $# == 1 && -f "$1/inputs.json" && -f "$1/0-after-inputs.json" && -f "$1/0.log" ]] || exit 1
jq -e -s '.[0]["Cargo.toml"] == .[1]["Cargo.toml"] and
    .[0]["Cargo.lock"] != .[1]["Cargo.lock"]' "$1/inputs.json" "$1/0-after-inputs.json" > /dev/null

echo 'release admission, cache preparation, selected-commit metadata and Make/logger retention passed (real Git/locked offline metadata; other Cargo effects and gates substituted)'
fixture_complete=true
