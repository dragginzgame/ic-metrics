# shellcheck shell=bash
# Private scenarios sourced by test-release-admission.sh; caller owns scratch and effects.
# shellcheck disable=SC2154 # root and fixture are supplied by the owning entrypoint.

check_cache_and_tools() {
setup preflight-clean
bash "$root/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1

# Shared owns the simulated cache matrix. Retain this adapter's internal
# preparation selection and standalone refusal, including actual index custody.
for scenario in cold standalone-offline; do
    setup "cache-$scenario"
    capture_metadata "$fixture/originals-$scenario"
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
        printf '%s\n' install-rust-tools rust-tools-check install-release-editor release-editor-check >> "$fixture/expected-cache-events"
    fi
    cmp "$fixture/expected-cache-events" "$ADMISSION_CARGO_EVENTS"
    if [[ "$expected_status" == 0 ]]; then [[ -f "$ADMISSION_CACHE/input" ]] || exit 1;
    else [[ ! -e "$ADMISSION_CACHE/input" ]] || exit 1; fi
    assert_metadata_unchanged "$fixture/originals-$scenario"
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
        install-rust-tools|rust-tools-check|install-release-editor|release-editor-check) exec "${BASH_SOURCE[0]%/*}/make" "$@" ;;
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
        printf '%s\n' install-rust-tools rust-tools-check install-release-editor release-editor-check validation >> "$fixture/runner-cache-events"
    else [[ "$status" == 1 && ! -e "$ADMISSION_CACHE/input" ]] || exit 1; fi
    cmp "$fixture/runner-cache-events" "$ADMISSION_CARGO_EVENTS"
    cmp Cargo.lock "$fixture/runner-lock-before"
    for plan in .git/release-state/*.plan; do [[ ! -e "$plan" ]] || exit 1; done
done

# Shared owns generic tool availability/failure and pin-drift cases. Retain
# Metrics' standalone target selection and its explicit catalog override routing.
# The actual runner's setup/check refusal-before-validation cases stay above.
for scenario in standalone-rust-missing standalone-editor-missing \
    explicit-rust-pins-changed explicit-editor-pins-changed; do
    setup "tool-$scenario"
    originals="$fixture/tool-originals-$scenario"
    capture_metadata "$originals"
    printf 'old installed executable\n' > "$ADMISSION_CACHE/old-tool"
    export IC_METRICS_RELEASE_CACHE_PREPARE=1
    expected_status=0
    expected_targets=(install-rust-tools rust-tools-check install-release-editor release-editor-check)
    case "$scenario" in
        standalone-rust-missing)
            unset IC_METRICS_RELEASE_CACHE_PREPARE
            rm "$ADMISSION_CACHE/rust-tool"
            expected_status=53; expected_targets=(rust-tools-check) ;;
        standalone-editor-missing)
            unset IC_METRICS_RELEASE_CACHE_PREPARE
            rm "$ADMISSION_CACHE/editor-tool"
            expected_status=53; expected_targets=(rust-tools-check release-editor-check) ;;
        explicit-*-pins-changed)
            # Copy the script owners, so the controlled mutation cannot touch
            # the real repository's reviewed tool pins.
            tool_root="$fixture/changed-tool-root-$scenario"
            mkdir -p "$tool_root/scripts/release" "$tool_root/scripts/ci" "$tool_root/ci"
            # Metadata owners resolve physical paths; scratch may traverse a
            # target-directory symlink in a disposable source qualification.
            tool_root="$(cd -P "$tool_root" && printf '%s/.' "$PWD")"
            tool_root="${tool_root%/.}"
            bash "$root/scripts/ci/prepare-script-fixture.sh" "$root" "$tool_root" scripts/release/metadata.sh
            export ADMISSION_TOOL_ROOT="$tool_root"
            case "$scenario" in
                explicit-rust-pins-changed) export ADMISSION_TOOL_CHANGE=rust ;;
                explicit-editor-pins-changed) export ADMISSION_TOOL_CHANGE=editor ;;
            esac
            export RUST_TOOL_VERSIONS="$fixture/selected Rust pins.env"
            cp "$root/ci/tool-versions.env" "$RUST_TOOL_VERSIONS"
            expected_status=1; expected_targets=(install-rust-tools)
            if [[ "$ADMISSION_TOOL_CHANGE" == editor ]]; then
                expected_targets+=(rust-tools-check install-release-editor)
            fi ;;
    esac
    status=0
    bash "$ADMISSION_TOOL_ROOT/scripts/release/metadata.sh" preflight > "$fixture/result.log" 2>&1 || status=$?
    [[ "$status" == "$expected_status" ]] || exit 1
    expected_fetch='fetch --locked'
    if [[ "$scenario" == standalone-* ]]; then expected_fetch='fetch --locked --offline'; fi
    printf '%s\n' "$expected_fetch" "${expected_targets[@]}" > "$fixture/expected-tool-events"
    cmp "$fixture/expected-tool-events" "$ADMISSION_CARGO_EVENTS"
    assert_metadata_unchanged "$originals"
    [[ "$(cat "$ADMISSION_CACHE/old-tool")" == 'old installed executable' ]] || exit 1
    if [[ "$scenario" == explicit-*-pins-changed ]]; then
        cmp "$root/ci/tool-versions.env" "$ADMISSION_TOOL_ROOT/ci/tool-versions.env"
        if [[ "$ADMISSION_TOOL_CHANGE" == rust ]]; then
            cmp "$root/ci/release-tools.env" "$ADMISSION_TOOL_ROOT/ci/release-tools.env"
        fi
    fi
    [[ ! -e .git/release-state ]] || exit 1
done
}
