# shellcheck shell=bash
# Private scenarios sourced by test-release-admission.sh; caller owns scratch and effects.
# shellcheck disable=SC2154 # root, fixture and selected_commit come from entrypoint/support.

check_source_admission() {
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
printf 'sort --workspace --check --grouped\n' > "$fixture/expected-order-only"
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
printf 'sort --workspace --check --grouped\nmetadata --locked --offline --format-version 1\n' > "$fixture/expected-selected-events"
cmp "$fixture/expected-selected-events" "$ADMISSION_CARGO_EVENTS"
: > "$ADMISSION_CARGO_EVENTS"
for remaining in "$TMPDIR"/*; do [[ ! -e "$remaining" ]] || exit 1; done
export RELEASE_VERSION=9.8.7
reject check
# Keep the adapter's rejection/receipt route; Shared's metadata fixture owns
# retained source contents and the complete selected-source failure matrix.
grep -F 'failed Cargo metadata check retained:' "$fixture/result.log" >/dev/null
}
