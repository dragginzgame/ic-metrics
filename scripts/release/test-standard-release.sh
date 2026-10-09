#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
export RELEASE_DELIVERY=direct
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/standard-release-entry.XXXXXX")"
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        if [[ -f "$fixture/output" ]]; then cat "$fixture/output" >&2 || :; fi
        for log in "$fixture"/release-commands.*/*.log; do
            if [[ -f "$log" ]]; then cat "$log" >&2 || :; fi
        done
        echo "failed standard release fixture retained: $fixture" >&2
    else
        rm -rf "$fixture"
    fi
    exit "$status"
}
trap cleanup EXIT
mkdir -p "$fixture/bin" "$fixture/make"
cp "$root/make/tools.mk" "$root/make/release.mk" "$root/make/rust-format.mk" "$fixture/make/"
real_bash="$(command -v bash)"
export EVENTS="$fixture/events"
cd "$fixture"
real_make="$(command -v make)"
for selection in default direct; do
    if [[ "$selection" == default ]]; then unset RELEASE_DELIVERY; else export RELEASE_DELIVERY=direct; fi
    TMPDIR="$fixture" "$real_bash" "$root/scripts/ci/check-release-commands.sh" "$root" \
        make/tools.mk make/release.mk make/rust-format.mk > "$fixture/output" 2>&1
done

# Unsupported inherited and command-line policies must fail before any tool
# runs, including metadata-only entrypoints.
printf '#!%s\n' "$real_bash" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
printf 'unexpected dispatch\n' >> "$EVENTS"
exit 0
BASH
chmod +x "$fixture/bin/bash"
for policy in pr invalid ''; do
    for selection in environment command; do
        for target in release-patch release-minor release-major release-resume release-preflight release-prepare-version; do
            : > "$EVENTS"
            status=0
            if [[ "$selection" == command ]]; then
                PATH="$fixture/bin:$PATH" RELEASE_DELIVERY=direct "$real_make" --no-print-directory \
                    -f "$root/Makefile" "$target" "RELEASE_DELIVERY=$policy" > "$fixture/output" 2>&1 || status=$?
            else
                PATH="$fixture/bin:$PATH" RELEASE_DELIVERY="$policy" "$real_make" --no-print-directory \
                    -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
            fi
            if [[ "$status" == 0 ]]; then
                echo 'unsupported delivery was accepted' >&2
                exit 1
            fi
            [[ ! -s "$EVENTS" ]]
        done
    done
    : > "$EVENTS"
    if PATH="$fixture/bin:$PATH" RELEASE_DELIVERY="$policy" "$real_bash" "$root/scripts/release/metadata.sh" preflight \
        > "$fixture/output" 2>&1; then exit 1; fi
    [[ ! -s "$EVENTS" ]]
done
rm "$fixture/bin/bash"

# Every standard entry selects preparation, retaining explicit caller offline mode.
mkdir -p scripts/ci
cat > scripts/ci/run-release.sh <<'RUNNER'
#!/usr/bin/env bash
set -euo pipefail
[[ "${IC_METRICS_RELEASE_CACHE_PREPARE:-}" == 1 ]]
[[ "${CARGO_NET_OFFLINE:-}" == true ]]
printf '%s\n' "$@" > "$EVENTS"
exit "${CACHE_ENTRY_RESULT:-0}"
RUNNER
for target in patch minor major resume; do
    for result in 0 17; do
        : > "$EVENTS"
        status=0
        CACHE_ENTRY_RESULT="$result" CARGO_NET_OFFLINE=true "$real_make" --no-print-directory \
            -f "$root/Makefile" "release-$target" VERSION=0.1.2 RELEASE_REMOTE=review \
            RELEASE_BRANCH=main > "$fixture/output" 2>&1 || status=$?
        if [[ "$result" == 0 ]]; then [[ "$status" == 0 ]]; else [[ "$status" != 0 ]]; fi
        if [[ "$target" == resume ]]; then printf '%s\n' resume 0.1.2 review main > "$fixture/cache-entry-expected";
        else printf '%s\n' "$target" review main > "$fixture/cache-entry-expected"; fi
        cmp "$fixture/cache-entry-expected" "$EVENTS"
    done
done

# Publication remains a separate single-package Cargo operation, never a release.
printf '#!%s\n' "$real_bash" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
set -euo pipefail
printf '%s\n' "$@" >> "$EVENTS"
[[ "${FAIL_PUBLISH:-0}" == 0 ]]
CARGO
chmod +x "$fixture/bin/cargo"
# A rejected release cannot start a chained publication.
: > "$EVENTS"
if PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -f "$root/Makefile" \
    release-patch RELEASE_DELIVERY=pr > "$fixture/output" 2>&1 && \
    PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -f "$root/Makefile" publish \
        >> "$fixture/output" 2>&1; then exit 1; fi
[[ ! -s "$EVENTS" ]]
for target in publish publish-check; do
    for fail in 0 1; do
        : > "$EVENTS"
        status=0
        PATH="$fixture/bin:$PATH" FAIL_PUBLISH="$fail" "$real_make" --no-print-directory \
            -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
        if [[ "$fail" == 0 ]]; then [[ "$status" == 0 ]]; else [[ "$status" != 0 ]]; fi
        printf '%s\n' publish -p ic-metrics --locked --registry crates-io > "$fixture/expected"
        if [[ "$target" == publish-check ]]; then printf '%s\n' --dry-run >> "$fixture/expected"; fi
        cmp "$fixture/expected" "$EVENTS"
    done
done
echo 'release and publication Make adapters passed (command stubs; no Git or registry effects)'
