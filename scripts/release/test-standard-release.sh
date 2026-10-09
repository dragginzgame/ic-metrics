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
mkdir -p "$fixture/bin" "$fixture/make" "$fixture/scripts/ci"
cp "$root/make/tools.mk" "$root/make/release.mk" "$root/make/rust-format.mk" "$root/make/execution.mk" "$fixture/make/"
cp "$root/scripts/ci/check-make-execution.sh" "$fixture/scripts/ci/"
real_bash="$(command -v bash)"
export STANDARD_RELEASE_REAL_BASH="$real_bash"
export EVENTS="$fixture/events"
cd "$fixture"
real_make="$(command -v make)"
for selection in default direct; do
    if [[ "$selection" == default ]]; then unset RELEASE_DELIVERY; else export RELEASE_DELIVERY=direct; fi
    TMPDIR="$fixture" "$real_bash" "$root/scripts/ci/check-release-commands.sh" "$root" \
        make/tools.mk make/release.mk make/rust-format.mk make/execution.mk \
        scripts/ci/check-make-execution.sh > "$fixture/output" 2>&1
done

# The smoke checker must bind this consumer's includes to its scratch snapshot,
# even when invoked through a parent Make exporting another tooling root.
mkdir -p "$fixture/external/scripts/ci"
cat > "$fixture/external/scripts/ci/run-release.sh" <<'EXTERNAL'
#!/usr/bin/env bash
echo escaped >> "$EVENTS"
exit 99
EXTERNAL
cat > "$fixture/root-parent.mk" <<'MAKE'
export SHARED_TOOLING_ROOT := $(EXTERNAL_ROOT)
check:
	+@bash "$(CHECKER)" "$(CONSUMER)" make/tools.mk make/release.mk make/rust-format.mk make/execution.mk scripts/ci/check-make-execution.sh
MAKE
: > "$EVENTS"
SHARED_TOOLING_ROOT="$fixture/external" TMPDIR="$fixture" "$real_bash" \
    "$root/scripts/ci/check-release-commands.sh" "$root" \
    make/tools.mk make/release.mk make/rust-format.mk make/execution.mk \
    scripts/ci/check-make-execution.sh > "$fixture/output" 2>&1
[[ ! -s "$EVENTS" ]]
TMPDIR="$fixture" "$real_make" -j2 --no-print-directory -f "$fixture/root-parent.mk" check \
    EXTERNAL_ROOT="$fixture/external" CHECKER="$root/scripts/ci/check-release-commands.sh" \
    CONSUMER="$root" > "$fixture/output" 2>&1
[[ ! -s "$EVENTS" ]]

# Unsupported inherited and command-line policies must fail before runner or
# metadata dispatch. The parse-time Make execution probe remains real.
printf '#!%s\n' "$real_bash" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
case "${1:-}" in
    */scripts/ci/check-make-execution.sh) exec "$STANDARD_RELEASE_REAL_BASH" "$@" ;;
esac
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
cp "$fixture/bin/bash" "$fixture/mode-bash"
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

# The actual consumer includes reject unsafe Make modes before any substituted
# release/formatter operation, including an inherited marker claiming admission.
cp "$fixture/mode-bash" "$fixture/bin/bash"
for target in release-patch release-minor release-major release-resume fmt fmt-check; do
    for mode in -i --ignore-errors -n -t -q; do
        for selection in direct inherited; do
            : > "$EVENTS"
            status=0
            if [[ "$selection" == direct ]]; then
                PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -f "$root/Makefile" "$mode" "$target" \
                    > "$fixture/output" 2>&1 || status=$?
            else
                PATH="$fixture/bin:$PATH" _shared_make_execution_checked=yes MAKEFLAGS="$mode" "$real_make" --no-print-directory \
                    -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
            fi
            [[ "$status" == 2 && ! -s "$EVENTS" ]]
        done
    done
done
rm "$fixture/bin/bash"

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
