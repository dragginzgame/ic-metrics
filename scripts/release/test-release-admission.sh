#!/usr/bin/env bash
set -euo pipefail
# Actual consumer policy, editor, runner, Git, group metadata and publication plan.
# Only setup, broad gates, archive compilation and registry upload are substituted.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH VALIDATION_LOG_DIR
unset VALIDATION_FAILURE_LOG_DIR GITHUB_STEP_SUMMARY RELEASE_MAKE
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
export PATH="$root/.tools/host/bin:$root/.tools/rust/common/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-$root/target}/observability-release-groups.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    fixture_completion_status "$status" "$fixture_complete" || status=$?
    if [[ "$status" != 0 ]]; then fixture_replay_logs "$fixture"/*.log; fi
    printf 'Group release fixture retained: %s\n' "$fixture" >&2
    exit "$status"
}
trap cleanup EXIT
FIXTURE_RELEASE_EDITOR="$(make --no-print-directory -s -C "$root" release-editor-check)"
export FIXTURE_RELEASE_EDITOR
FIXTURE_REAL_CARGO="$(command -v cargo)"
export FIXTURE_REAL_CARGO
mkdir "$fixture/repo" "$fixture/bin"
(cd "$root" && git ls-files --cached --others --exclude-standard -z | while IFS= read -r -d '' path; do
    [[ ! -f "$path" ]] || printf '%s\0' "$path"
done | tar --null -T - -cf -) | tar -xf - -C "$fixture/repo"
mkdir -p "$fixture/repo/.tools/host/bin"
cp "$root/.tools/host/bin/jq" "$root/.tools/host/bin/yq" "$fixture/repo/.tools/host/bin/"
printf '#!%s\n' "$BASH" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
if [[ "${1:-}" == publish ]]; then printf '%s\n' "$@" >> "$FIXTURE_PUBLICATION_EVENTS"; exit 0; fi
exec "$FIXTURE_REAL_CARGO" "$@"
CARGO
chmod +x "$fixture/bin/cargo"
printf '#!%s\nexit 52\n' "$BASH" > "$fixture/broken-editor"
chmod +x "$fixture/broken-editor"
export FIXTURE_BROKEN_EDITOR="$fixture/broken-editor"
export FIXTURE_PUBLICATION_EVENTS="$fixture/publication-events"
export PATH="$fixture/bin:$PATH" RELEASE_DELIVERY=direct RELEASE_REMOTE=origin RELEASE_BRANCH=main
cd "$fixture/repo"
cat >> Makefile <<'MAKE'

include fixture-gates.mk
MAKE
cat > fixture-gates.mk <<'MAKE'
.PHONY: install-rust-tools rust-tools-check install-release-editor release-editor-check ci msrv package-check clippy
install-rust-tools rust-tools-check install-release-editor:
	@test ! -e .git/fail-tools
release-editor-check:
	@if test -e .git/broken-editor; then printf '%s\n' "$$FIXTURE_BROKEN_EDITOR"; else printf '%s\n' "$$FIXTURE_RELEASE_EDITOR"; fi
ci:
	@test ! -e .git/fail-validation
	@test -z "$${IC_METRICS_RELEASE_CACHE_PREPARE+x}" && test "$${CARGO_NET_OFFLINE:-false}" = true
	@printf 'ci\n' >> .git/gates
	@if test -e .git/drift-input; then printf '\n# fixture drift\n' >> Cargo.lock; fi
msrv:
	@test ! -e .git/fail-msrv
	@printf 'msrv\n' >> .git/gates
package-check:
	@printf 'package-check\n' >> .git/gates
clippy:
	@printf 'publication-lint\n' >> .git/gates
release-commit-check:
	@bash fixture-index-check.sh
	@bash scripts/release/metadata.sh commit-check
	@git diff --cached --name-only | LC_ALL=C sort > .git/staged-files
release-push-check:
	@bash scripts/release/metadata.sh check
	@test ! -e .git/hold-push
MAKE
cat > fixture-index-check.sh <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
# Hidden staged edits must refuse even when the worktree has the prepared bytes.
for path in README.md Cargo.lock; do
    cp "$path" .git/prepared-content
    printf '\n# unexpected staged content\n' >> "$path"
    git add -- "$path"
    cp .git/prepared-content "$path"
    if bash scripts/release/metadata.sh commit-check > ".git/hidden-${path//\//_}.log" 2>&1; then exit 1; fi
    git add -- "$path"
done
BASH
# Each group has a synthetic pending entry only inside the disposable checkout.
# Metrics takes a patch; Logging a minor, proving different numeric identities.
for group in metrics logging; do
    export RELEASE_GROUP="$group"
    plan="$(bash scripts/release/metadata.sh plan)"
    previous="$(printf '%s' "$plan" | jq -er .previous)"
    ledger="$(printf '%s' "$plan" | jq -er .changelog)"
    kind='patch'
    [[ "$group" != logging ]] || kind=minor
    candidate="$(perl scripts/ci/validate-release-inputs.pl next-version "$previous" "$kind")"
    printf '# Changelog\n\n## [%s]\n\n- Fixture release.\n\n## [%s] - 2000-01-01\n\n- Fixture baseline.\n' "$candidate" "$previous" > "$ledger"
done
git init -q -b main
git config user.name Fixture
git config user.email fixture@example.invalid
git config core.hooksPath /dev/null
git add -- .
git commit -qm 'Disposable group baseline'
git init -q --bare "$fixture/remote.git"
git remote add origin "$fixture/remote.git"
git push -q -u origin main
freeze_consumer() {
    local group="$1" supplier="$2" version="$3"
    consumer="$fixture/$group-consumer"
    mkdir -p "$consumer/supplier" "$consumer/client/src"
    cp Cargo.toml Cargo.lock rust-toolchain.toml "$consumer/"
    cp -R "crates/ic-$supplier/src" "crates/ic-$supplier/Cargo.toml" \
        "crates/ic-$supplier/README.md" "crates/ic-$supplier/LICENSE" "$consumer/supplier/"
    perl -pi -e 's/^members = .*/members = ["supplier", "client"]/; s/^default-members = .*/default-members = ["client"]/' "$consumer/Cargo.toml"
    SUPPLIER="$supplier" SUPPLIER_VERSION="$version" perl -0pi -e \
        's/\[workspace.dependencies\]/[workspace.dependencies]\nic-$ENV{SUPPLIER} = { path = "supplier", version = "=$ENV{SUPPLIER_VERSION}", default-features = false }/' "$consumer/Cargo.toml"
    printf '[package]\nname = "retained-consumer"\nversion = "0.0.0"\nedition.workspace = true\n[dependencies]\nic-%s.workspace = true\n' "$supplier" > "$consumer/client/Cargo.toml"
    if [[ "$supplier" == metrics ]]; then
        cat > "$consumer/client/src/lib.rs" <<'RUST'
#[test]
fn retained_arithmetic_contract() {
    use ic_metrics::{checked_scaled_ratio, MeasurementRatioError};
    assert_eq!(checked_scaled_ratio(u128::MAX, 1, 1), Ok(u128::MAX));
    assert_eq!(checked_scaled_ratio(1, 0, 0), Err(MeasurementRatioError::ZeroDenominator));
    assert_eq!(checked_scaled_ratio(u128::MAX, 1, 2), Err(MeasurementRatioError::Overflow));
}
RUST
    else
        cat > "$consumer/client/src/lib.rs" <<'RUST'
#[test]
fn retained_log_contract() {
    use core::num::NonZeroUsize;
    use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
    let one = NonZeroUsize::new(1).unwrap();
    let mut log = Log::new(Limits { max_entries: one, max_message_bytes: 32, max_label_bytes: 16, max_text_bytes: 64 });
    let receipt = log.append(EntryInput { created_at_secs: 1, source: "fixture", topic: None, level: Level::Info, message: "retained" }).unwrap();
    assert_eq!(receipt.sequence, 0);
    assert_eq!(log.page(Filter::default(), PageRequest { before: None, max_results: one, max_scanned: one }).entries.len(), 1);
    assert_eq!(log.prune_expired(3, 1, 1).removed, 1);
}
RUST
    fi
    cargo metadata --manifest-path "$consumer/Cargo.toml" --offline --format-version 1 > "$fixture/$group-consumer-before.json"
    cp "$consumer/Cargo.lock" "$fixture/$group-consumer.lock"
}
for group in metrics logging; do
    export RELEASE_GROUP="$group"
    other=logging
    kind='patch'
    [[ "$group" != logging ]] || { other=metrics; kind=minor; }
    previous="$(make --no-print-directory -s release-version)"
    candidate="$(perl scripts/ci/validate-release-inputs.pl next-version "$previous" "$kind")"
    other_version="$(RELEASE_GROUP="$other" make --no-print-directory -s release-version)"
    other_ledger="$(RELEASE_GROUP="$other" bash scripts/release/metadata.sh plan | jq -er .changelog)"
    cp "$other_ledger" "$fixture/$group-other-ledger"
    cp "crates/ic-$other/Cargo.toml" "$fixture/$group-other-manifest"
    freeze_consumer "$group" "$other" "$other_version"
    cargo metadata --locked --offline --format-version 1 > "$fixture/$group-before.json"
    source="$(git rev-parse HEAD)"
    # Invalid source and tool setup refuse before validation or version mutation.
    printf '\nfixture edit\n' >> README.md
    if make "release-$kind" > "$fixture/$group-dirty.log" 2>&1; then exit 1; fi
    git restore README.md
    printf '\nfixture staged edit\n' >> README.md
    git add -- README.md
    git restore --worktree README.md
    git show HEAD:README.md > README.md
    cp .git/index "$fixture/$group-hidden-index"
    if make "release-$kind" > "$fixture/$group-hidden-source.log" 2>&1; then exit 1; fi
    cmp .git/index "$fixture/$group-hidden-index"
    git restore --staged README.md
    touch .git/fail-tools
    if make "release-$kind" > "$fixture/$group-tools.log" 2>&1; then exit 1; fi
    rm .git/fail-tools
    [[ "$(make -s release-version)" == "$previous" && "$(git rev-parse HEAD)" == "$source" ]]
    # Failing validation retains its actual logger evidence without preparation.
    touch .git/fail-validation
    if make "release-$kind" > "$fixture/$group-validation.log" 2>&1; then exit 1; fi
    rm .git/fail-validation
    [[ ! -e ".git/release-state/$group-$candidate/validated" ]]
    [[ "$(make -s release-version)" == "$previous" && "$(git rev-parse HEAD)" == "$source" ]]
    touch .git/fail-msrv
    if make "release-$kind" > "$fixture/$group-msrv-refusal.log" 2>&1; then exit 1; fi
    rm .git/fail-msrv
    [[ ! -e ".git/release-state/$group-$candidate/validated" ]]
    # A gate that changes an admitted Cargo input cannot reach the second gate.
    : > .git/gates
    touch .git/drift-input
    if make "release-$kind" > "$fixture/$group-input-drift.log" 2>&1; then exit 1; fi
    rm .git/drift-input
    printf 'ci\n' > "$fixture/$group-drift-expected"
    cmp .git/gates "$fixture/$group-drift-expected"
    [[ ! -e ".git/release-state/$group-$candidate/validated" ]]
    git restore Cargo.lock
    # The actual shared transaction restores every selected file on renderer refusal.
    bash scripts/release/metadata.sh files > "$fixture/$group-plan-files"
    while IFS= read -r -d '' path; do shasum -a 256 "$path"; done < "$fixture/$group-plan-files" > "$fixture/$group-originals"
    touch .git/broken-editor
    if make "release-$kind" > "$fixture/$group-rollback.log" 2>&1; then exit 1; fi
    rm .git/broken-editor
    shasum -a 256 -c "$fixture/$group-originals" > "$fixture/$group-rollback-hashes"
    [[ -z "$(git status --porcelain)" ]]
    # Stop after the real commit/tag, then refuse tampered and wrong-group receipts.
    touch .git/hold-push
    if make "release-$kind" > "$fixture/$group-release.log" 2>&1; then exit 1; fi
    [[ "$(make -s release-version)" == "$candidate" ]]
    receipt=".git/release-state/$group-$candidate/validated"
    cp "$receipt" "$fixture/$group-receipt"
    printf 'tampered\n' > "$receipt"
    if make release-resume "VERSION=$candidate" > "$fixture/$group-tamper.log" 2>&1; then exit 1; fi
    cp "$fixture/$group-receipt" "$receipt"
    if RELEASE_GROUP="$other" make release-resume "VERSION=$candidate" > "$fixture/$group-wrong-group.log" 2>&1; then exit 1; fi
    rm .git/hold-push
    make release-resume "VERSION=$candidate" > "$fixture/$group-resume.log" 2>&1
    commit="$(git rev-parse HEAD)"
    [[ "$(git log -1 --format=%s)" == "Release $group $candidate" ]]
    [[ "$(git --git-dir="$fixture/remote.git" rev-parse "refs/tags/$group-v$candidate^{}")" == "$commit" ]]
    [[ "$(git --git-dir="$fixture/remote.git" rev-parse refs/heads/main)" == "$commit" ]]
    [[ -z "$(git status --porcelain)" ]]
    cmp "$other_ledger" "$fixture/$group-other-ledger"
    cmp "crates/ic-$other/Cargo.toml" "$fixture/$group-other-manifest"
    diff -qr "crates/ic-$other/src" "$consumer/supplier/src" > "$fixture/$group-consumer-source-check"
    cmp "$consumer/Cargo.lock" "$fixture/$group-consumer.lock"
    CARGO_TARGET_DIR="$root/target/release-group-consumers" cargo test --manifest-path "$consumer/Cargo.toml" \
        -p retained-consumer --lib --locked --offline > "$fixture/$group-consumer-test.log" 2>&1
    [[ "$(RELEASE_GROUP="$other" make -s release-version)" == "$other_version" ]]
    cargo metadata --locked --offline --format-version 1 > "$fixture/$group-after.json"
    jq -n -e --arg name "ic-$other" --slurpfile before "$fixture/$group-before.json" --slurpfile after "$fixture/$group-after.json" '
        def identity($m): $m.packages[] | select(.name==$name) | {id,version,dependencies};
        identity($before[0]) == identity($after[0])' >/dev/null
    # The admitted plan includes unchanged Cargo.toml for literal-version groups;
    # the committed diff contains exactly the files whose bytes actually changed.
    if [[ "$group" == metrics ]]; then
        printf '%s\n' CHANGELOG.md Cargo.lock Cargo.toml > "$fixture/expected-changed"
    else
        printf '%s\n' Cargo.lock crates/ic-logging/CHANGELOG.md crates/ic-logging/Cargo.toml > "$fixture/expected-changed"
    fi
    git diff-tree --no-commit-id --name-only -r HEAD | LC_ALL=C sort > "$fixture/changed"
    LC_ALL=C sort "$fixture/expected-changed" > "$fixture/expected-sorted"
    cmp "$fixture/expected-sorted" "$fixture/changed"
    cmp "$fixture/expected-sorted" .git/staged-files
    cp .git/staged-files "$fixture/$group-staged-files"
    # Late admission reads the exact released commit, even if allowed metadata
    # in the current worktree is newer or temporarily invalid.
    printf 'newer worktree metadata\n' > Cargo.toml
    RELEASE_COMMIT="$commit" RELEASE_SOURCE="$source" RELEASE_PREVIOUS="$previous" \
        RELEASE_VERSION="$candidate" RELEASE_DATE="$(sed -n '4p' "$receipt")" \
        bash scripts/release/metadata.sh check > "$fixture/$group-selected-source.log" 2>&1
    git restore Cargo.toml
    make release-resume "VERSION=$candidate" > "$fixture/$group-repeat-resume.log" 2>&1
    [[ "$(git rev-parse HEAD)" == "$commit" ]]
    # Real publication admission/runner; only the final Cargo upload is a sentinel.
    : > "$FIXTURE_PUBLICATION_EVENTS"
    make publish-check > "$fixture/$group-publication.log" 2>&1
    printf '%s\n' publish --locked --registry crates-io --package "ic-$group@$candidate" --dry-run > "$fixture/publication-expected"
    cmp "$fixture/publication-expected" "$FIXTURE_PUBLICATION_EVENTS"
    : > "$FIXTURE_PUBLICATION_EVENTS"
    if make publish-check "PACKAGE=ic-$other" > "$fixture/$group-cross-publication.log" 2>&1; then exit 1; fi
    [[ ! -s "$FIXTURE_PUBLICATION_EVENTS" ]]
    echo "$group: independent metadata, rollback, exact commit/tag, receipts/resume and publication passed"
done
fixture_complete=true
