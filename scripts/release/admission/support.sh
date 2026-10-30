# shellcheck shell=bash
# Private scenarios sourced by test-release-admission.sh; caller owns scratch and effects.
# shellcheck disable=SC2154 # root and fixture are supplied by the owning entrypoint.

source_commit="$(git -C "$root" rev-parse HEAD)"
# shellcheck disable=SC2034 # Read by the sourced selected-release scenarios.
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
    'sort --workspace --check --grouped') exec "$ADMISSION_REAL_CARGO" "$@" ;;
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
        install-rust-tools|rust-tools-check|install-release-editor|release-editor-check)
            printf '%s\n' "$4" >> "$ADMISSION_CARGO_EVENTS"
            case "$4" in
                *rust-tools*) tool=rust-tool ;;
                *) tool=editor-tool ;;
            esac
            if [[ "$4" == install-rust-tools || "$4" == install-release-editor ]]; then
                if [[ "${ADMISSION_TOOL_CHANGE:-no}:$4" == rust:install-rust-tools ]]; then
                    printf '\n# changed selection\n' >> "${RUST_TOOL_VERSIONS:-$ADMISSION_TOOL_ROOT/ci/tool-versions.env}"
                elif [[ "${ADMISSION_TOOL_CHANGE:-no}:$4" == editor:install-release-editor ]]; then
                    printf '\n# changed editor selection\n' >> "$ADMISSION_TOOL_ROOT/ci/release-tools.env"
                fi
                printf 'selected executable\n' > "$ADMISSION_CACHE/$tool"
            else
                [[ -f "$ADMISSION_CACHE/$tool" ]] || exit 53
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
    cd "$worktree" || return
    [[ -d .git && "$(git rev-parse HEAD)" == "$checkout_commit" ]] || exit 1
    : > "$ADMISSION_CARGO_EVENTS"
    unset RELEASE_COMMIT ADMISSION_FAIL_GIT IC_METRICS_RELEASE_CACHE_PREPARE
    unset CARGO_NET_OFFLINE ADMISSION_TOOL_CHANGE RUST_TOOL_VERSIONS
    export ADMISSION_TOOL_ROOT="$root"
    export ADMISSION_CACHE="$fixture/cache/$name"
    mkdir -p "$ADMISSION_CACHE"
    # Existing admission scenarios have prepared inputs; new cache cases start cold.
    printf 'prepared selected locked input\n' > "$ADMISSION_CACHE/input"
    printf 'selected formatter\n' > "$ADMISSION_CACHE/rust-tool"
    printf 'selected editor\n' > "$ADMISSION_CACHE/editor-tool"
    export TMPDIR="$fixture/attempts/$name"
    export RELEASE_PREVIOUS=0.1.1 RELEASE_VERSION=0.1.2 RELEASE_DATE=2026-10-06
}
prepare_validation_adapter() {
    mkdir -p "$worktree/tmp"
    bash "$root/scripts/ci/prepare-script-fixture.sh" "$root" "$worktree" make/consumer.mk
    mkdir -p "$worktree/ci"
    cp "$root/ci/release-delivery.txt" "$worktree/ci/"
    bash "$root/scripts/ci/prepare-script-fixture.sh" "$root" "$worktree" scripts/ci/run-validation-targets.sh
}

reject() {
    if bash "$root/scripts/release/metadata.sh" "$1" > "$fixture/result.log" 2>&1; then
        echo "admission unexpectedly accepted $worktree: $1" >&2
        exit 1
    fi
}

capture_metadata() {
    local destination="$1" path
    mkdir "$destination"
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cp "$path" "$destination/$path"; done
    cp .git/index "$destination/index"
}

assert_metadata_unchanged() {
    local original="$1" path
    for path in Cargo.toml Cargo.lock CHANGELOG.md; do cmp "$path" "$original/$path"; done
    cmp .git/index "$original/index"
}
