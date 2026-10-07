#!/usr/bin/env bash
set -euo pipefail

# Real index/commit and actual Make/logger boundaries; no commits or releases.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
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
selected_commit="$source_commit"
source_objects="$(git -C "$root" rev-parse --git-path objects)"
case "$source_objects" in /*) ;; *) source_objects="$root/$source_objects" ;; esac
mkdir -p "$fixture/bin" "$fixture/templates"
git -C "$root" show "$selected_commit:Cargo.toml" > "$fixture/Cargo.toml"
selected_version="$(cd "$fixture" && bash "$root/scripts/release/metadata.sh" version)"
selected_date="$(git -C "$root" show "$selected_commit:CHANGELOG.md" | \
    awk -v heading="## [$selected_version] - " 'index($0, heading) == 1 { print $4; count++ } END { if (count != 1) exit 1 }')"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null GIT_TEMPLATE_DIR="$fixture/templates"
real_bash="$(command -v bash)"
ADMISSION_REAL_GIT="$(command -v git)"
ADMISSION_REAL_CARGO="$(command -v cargo)"
export ADMISSION_REAL_GIT ADMISSION_REAL_CARGO
printf '#!%s\n' "$real_bash" > "$fixture/bin/git"
cat >> "$fixture/bin/git" <<'GIT'
set -euo pipefail
case "${ADMISSION_FAIL_GIT:-}:$1" in
    type:cat-file|export:show)
        "$ADMISSION_REAL_GIT" "$@"
        exit 43 ;;
    *) exec "$ADMISSION_REAL_GIT" "$@" ;;
esac
GIT
chmod +x "$fixture/bin/git"
printf '#!%s\n' "$real_bash" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
set -euo pipefail
# Manifest parsing is read-only; keep it real while substituting effectful gates.
if [[ "${1:-}" == locate-project ]]; then exec "$ADMISSION_REAL_CARGO" "$@"; fi
printf '%s\n' "$*" >> "$ADMISSION_CARGO_EVENTS"
case "$*" in
    'set-version --help'|'sort --help'|'fetch --locked --offline'|'metadata --locked --offline --format-version 1') ;;
    *) echo 'unexpected admission fixture Cargo command' >&2; exit 99 ;;
esac
CARGO
chmod +x "$fixture/bin/cargo"
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
    unset RELEASE_COMMIT ADMISSION_FAIL_GIT
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
grep -F 'fetch --locked --offline' "$ADMISSION_CARGO_EVENTS" >/dev/null

for scenario in unstaged staged-hidden untracked; do
    setup "preflight-$scenario"
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

setup conflicting-pending-notes
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
    cp "$root/make/tools.mk" make/
    cp "$root/scripts/ci/run-validation-targets.sh" scripts/ci/
    cp "$root/scripts/ci/check-make-execution.sh" scripts/ci/
    cat > Makefile <<'MAKE'
.PHONY: ci msrv
ci:
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
        if TMPDIR="$worktree/tmp" make --no-print-directory -f "$root/Makefile" release-verify \
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
cp "$root/make/tools.mk" make/
cp "$root/scripts/ci/run-validation-targets.sh" scripts/ci/
cp "$root/scripts/ci/check-make-execution.sh" scripts/ci/
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
[[ "${#second_logs[@]}" == 1 ]]
grep -F retained-msrv-failure "${second_logs[0]}" >/dev/null
: > gate-events
make --no-print-directory -f "$root/Makefile" release-verify \
    RELEASE_VERSION=9.8.7 RELEASE_COMMIT=selected-fixture-commit FAIL_MSRV=no \
    > "$fixture/result.log" 2>&1
cmp gate-events "$fixture/expected-gates"
grep -F retained-msrv-failure "${second_logs[0]}" >/dev/null
echo 'release admission, selected-commit metadata and actual Make/logger retention passed (real Git; Cargo and gates substituted)'
