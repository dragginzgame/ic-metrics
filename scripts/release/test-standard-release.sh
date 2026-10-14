#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
export RELEASE_DELIVERY=direct
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/standard-release-entry.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        if [[ -f "$fixture/output" ]]; then cat "$fixture/output" >&2 || :; fi
        for log in "$fixture"/release-commands.*/*.log; do
            if [[ -f "$log" ]]; then cat "$log" >&2 || :; fi
        done
    fi
    fixture_finish "$status" "$fixture" "failed standard release fixture retained"
}
trap cleanup EXIT
mkdir -p "$fixture/bin" "$fixture/make" "$fixture/scripts/ci"
cp "$root/make/consumer.mk" "$root/make/tools.mk" "$root/make/release.mk" "$root/make/rust-format.mk" "$root/make/execution.mk" "$fixture/make/"
cp "$root/scripts/ci/check-make-execution.sh" "$root/scripts/ci/run-formatting.sh" "$fixture/scripts/ci/"
real_bash="$(command -v bash)"
export STANDARD_RELEASE_REAL_BASH="$real_bash"
export EVENTS="$fixture/events"
cd "$fixture"
real_make="$(command -v make)"
for selection in default direct; do
    if [[ "$selection" == default ]]; then unset RELEASE_DELIVERY; else export RELEASE_DELIVERY=direct; fi
    TMPDIR="$fixture" "$real_bash" "$root/scripts/ci/check-release-commands.sh" "$root" \
        make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk \
        scripts/ci/check-make-execution.sh scripts/ci/run-formatting.sh > "$fixture/output" 2>&1
done

# Admission follows the selected include even when runtime routing is overridden.
# No unselected execution probe may run during harmless help parsing.
mkdir -p "$fixture/external/scripts/ci"
cat > "$fixture/external/scripts/ci/check-make-execution.sh" <<'EXTERNAL'
#!/usr/bin/env bash
echo escaped >> "$EVENTS"
exit 0
EXTERNAL
for selection in environment command; do
    : > "$EVENTS"
    if [[ "$selection" == command ]]; then
        "$real_make" --no-print-directory -f "$root/Makefile" help \
            "SHARED_TOOLING_ROOT=$fixture/external" > "$fixture/output" 2>&1
    else
        SHARED_TOOLING_ROOT="$fixture/external" "$real_make" --no-print-directory \
            -f "$root/Makefile" help > "$fixture/output" 2>&1
    fi
    [[ ! -s "$EVENTS" ]] || exit 1
done

# The smoke checker must bind this consumer's includes to its scratch snapshot,
# even when invoked through a parent Make exporting another tooling root.
cat > "$fixture/external/scripts/ci/run-release.sh" <<'EXTERNAL'
#!/usr/bin/env bash
echo escaped >> "$EVENTS"
exit 99
EXTERNAL
cat > "$fixture/root-parent.mk" <<'MAKE'
export SHARED_TOOLING_ROOT := $(EXTERNAL_ROOT)
check:
	+@bash "$(CHECKER)" "$(CONSUMER)" make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk scripts/ci/check-make-execution.sh scripts/ci/run-formatting.sh
MAKE
: > "$EVENTS"
SHARED_TOOLING_ROOT="$fixture/external" TMPDIR="$fixture" "$real_bash" \
    "$root/scripts/ci/check-release-commands.sh" "$root" \
    make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk \
    scripts/ci/check-make-execution.sh scripts/ci/run-formatting.sh > "$fixture/output" 2>&1
[[ ! -s "$EVENTS" ]] || exit 1
TMPDIR="$fixture" "$real_make" -j2 --no-print-directory -f "$fixture/root-parent.mk" check \
    EXTERNAL_ROOT="$fixture/external" CHECKER="$root/scripts/ci/check-release-commands.sh" \
    CONSUMER="$root" > "$fixture/output" 2>&1
[[ ! -s "$EVENTS" ]] || exit 1

# Unsupported inherited and command-line policies must fail before runner or
# metadata dispatch. The parse-time Make execution probe remains real.
printf '#!%s\n' "$real_bash" > "$fixture/bin/bash"
cat >> "$fixture/bin/bash" <<'BASH'
case "${1:-}" in
    */scripts/ci/check-make-execution.sh) exec "$STANDARD_RELEASE_REAL_BASH" "$@" ;;
    scripts/release/metadata.sh)
        if [[ "${REQUIRE_RUST_CATALOG:-0}" == 1 ]]; then
            [[ "$2" == preflight && "$RUST_TOOL_VERSIONS" == "$EXPECTED_RUST_CATALOG" ]] || exit 1
            printf '%s\n' "$RUST_TOOL_VERSIONS" >> "$EVENTS"
            exit 0
        fi
        if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then
            perl "$JOBSERVER_PROBE" || exit $?
            printf 'metadata %s\n' "$2" >> "$EVENTS"
            exit 0
        fi ;;
esac
printf 'unexpected dispatch\n' >> "$EVENTS"
exit 0
BASH
chmod +x "$fixture/bin/bash"
# Preflight binds the same independently selected Rust catalog as installation;
# a host-only override must not change it. Exercise actual Make child routing.
selected_rust="$fixture/selected Rust pins.env"
cp "$root/ci/tool-versions.env" "$selected_rust"
: > "$EVENTS"
PATH="$fixture/bin:$PATH" RELEASE_DELIVERY=direct REQUIRE_RUST_CATALOG=1 \
    EXPECTED_RUST_CATALOG="$selected_rust" "$real_make" --no-print-directory \
    -f "$root/Makefile" release-preflight "RUST_TOOL_VERSIONS=$selected_rust" \
    "HOST_TOOL_VERSIONS=$fixture/other-host-catalog" > "$fixture/output" 2>&1
printf '%s\n' "$selected_rust" > "$fixture/expected-rust-catalog"
cmp "$fixture/expected-rust-catalog" "$EVENTS"
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
            [[ ! -s "$EVENTS" ]] || exit 1
        done
    done
    : > "$EVENTS"
    if PATH="$fixture/bin:$PATH" RELEASE_DELIVERY="$policy" "$real_bash" "$root/scripts/release/metadata.sh" preflight \
        > "$fixture/output" 2>&1; then exit 1; fi
    [[ ! -s "$EVENTS" ]] || exit 1
done
cp "$fixture/bin/bash" "$fixture/mode-bash"
rm "$fixture/bin/bash"

# Every standard entry selects preparation, retaining explicit caller offline mode.
mkdir -p scripts/ci
cat > scripts/ci/run-release.sh <<'RUNNER'
#!/usr/bin/env bash
set -euo pipefail
[[ "${IC_METRICS_RELEASE_CACHE_PREPARE:-}" == 1 ]] || exit 1
[[ "${CARGO_NET_OFFLINE:-}" == true ]] || exit 1
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
        if [[ "$result" == 0 ]]; then [[ "$status" == 0 ]] || exit 1; else [[ "$status" != 0 ]] || exit 1; fi
        if [[ "$target" == resume ]]; then printf '%s\n' resume 0.1.2 review main > "$fixture/cache-entry-expected";
        else printf '%s\n' "$target" review main > "$fixture/cache-entry-expected"; fi
        cmp "$fixture/cache-entry-expected" "$EVENTS"
    done
done

# Recursive MAKE arguments belong to the real invocation, not the admission probe.
cat > "$fixture/recursive.mk" <<'MAKE'
RELEASE_REMOTE := recursive
recursive-entry:
	+@$(MAKE) release-patch
MAKE
: > "$EVENTS"
CARGO_NET_OFFLINE=true "$real_make" -j2 --no-print-directory \
    -f "$root/Makefile" -f "$fixture/recursive.mk" recursive-entry \
    "MAKE=$real_make --no-print-directory -f $root/Makefile -f $fixture/recursive.mk" \
    RELEASE_BRANCH=main > "$fixture/output" 2>&1
printf '%s\n' patch recursive main > "$fixture/cache-entry-expected"
cmp "$fixture/cache-entry-expected" "$EVENTS"

# The actual consumer includes reject unsafe Make modes before any substituted
# release/formatter operation, including an inherited marker claiming admission.
# Publication remains a separate Cargo operation. Substitute it
# before admission cases so even a broken guard cannot reach a registry.
export JOBSERVER_PROBE="$root/scripts/ci/check-pipe-jobserver.pl"
parallel=(-j4)
if "$real_make" --help | grep -q -- --jobserver-style; then parallel+=(--jobserver-style=pipe); fi
printf '#!%s\n' "$real_bash" > "$fixture/bin/cargo"
cat >> "$fixture/bin/cargo" <<'CARGO'
set -euo pipefail
if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then
    perl "$JOBSERVER_PROBE"
fi
printf '%s\n' "$@" >> "$EVENTS"
[[ "${FAIL_PUBLISH:-0}" == 0 ]] || exit 1
CARGO
chmod +x "$fixture/bin/cargo"
printf '#!%s\nexit 0\n' "$real_bash" > "$fixture/bin/rustc"
chmod +x "$fixture/bin/rustc"
cargo_targets=(publish publish-check check check-wasm clippy docs-check test msrv stable-check stable-msrv)
tool_targets=(install-wasm-inspector wasm-inspector-tools-check wasm-inspect-check)
metadata_targets=(release-preflight release-prepare-version release-commit-check release-prepared-check release-committed-check release-tagged-check release-push-check)
cp "$fixture/mode-bash" "$fixture/bin/bash"
for target in release-patch release-minor release-major release-resume fmt fmt-check "${cargo_targets[@]}" "${tool_targets[@]}" "${metadata_targets[@]}"; do
    for mode in -i --ignore-errors -n --dry-run --just-print --recon -t --touch -q --question -kin; do
        for selection in direct inherited cleared replaced both-hidden; do
            : > "$EVENTS"
            status=0
            if [[ "$selection" == inherited ]]; then
                PATH="$fixture/bin:$PATH" _shared_make_execution_checked=yes MAKEFLAGS="$mode" "$real_make" --no-print-directory \
                    -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
            else
                flags=()
                case "$selection" in
                    cleared) flags=(MAKEFLAGS=) ;;
                    replaced) flags=(MAKEFLAGS=--no-print-directory) ;;
                    both-hidden) flags=(MAKEFLAGS= MFLAGS=) ;;
                esac
                PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -f "$root/Makefile" "$mode" "$target" \
                    ${flags[@]+"${flags[@]}"} > "$fixture/output" 2>&1 || status=$?
            fi
            if [[ "$status" != 2 || -s "$EVENTS" ]]; then
                echo "consumer Make admission failed: $target $mode $selection (status $status)" >&2
                exit 1
            fi
        done
    done
done
for assignment in 'MFLAGS :=' 'override MFLAGS :='; do
    printf '%s\n' "$assignment" > "$fixture/hidden-mflags.mk"
    : > "$EVENTS"
    status=0
    PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -i \
        -f "$fixture/hidden-mflags.mk" -f "$root/Makefile" release-patch MAKEFLAGS= \
        > "$fixture/output" 2>&1 || status=$?
    [[ "$status" == 2 && ! -s "$EVENTS" ]] || exit 1
done
rm "$fixture/bin/bash"

# The real consumer Makefile must leave both pipe descriptors open at every
# owned Cargo boundary. Cargo effects are substituted; Make admission is real.
for target in "${cargo_targets[@]}"; do
    : > "$EVENTS"
    PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 "$real_make" "${parallel[@]}" --no-print-directory \
        -f "$root/Makefile" "$target" > "$fixture/output" 2>&1
    [[ -s "$EVENTS" ]] || exit 1
done
# Metadata also dispatches Cargo, so its Bash entry must retain the descriptors.
cp "$fixture/mode-bash" "$fixture/bin/bash"
for target in "${metadata_targets[@]}"; do
    : > "$EVENTS"
    PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 "$real_make" "${parallel[@]}" --no-print-directory \
        -f "$root/Makefile" "$target" > "$fixture/output" 2>&1
    [[ -s "$EVENTS" ]] || exit 1
done
rm "$fixture/bin/bash"
# A failure in a multi-command gate stops before any later Cargo command.
: > "$EVENTS"
status=0
PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 FAIL_PUBLISH=1 "$real_make" "${parallel[@]}" --no-print-directory \
    -f "$root/Makefile" clippy > "$fixture/output" 2>&1 || status=$?
[[ "$status" == 2 ]] || exit 1
printf '%s\n' clippy -p ic-metrics --all-targets --locked -- -D warnings > "$fixture/expected"
cmp "$fixture/expected" "$EVENTS"

# Safe replacement flags still reach the real consumer adapter with its selected
# runner substituted, including parallel mode and a quoted ordinary selection.
for selection in '' --no-print-directory; do
    : > "$EVENTS"
    CARGO_NET_OFFLINE=true "$real_make" -j2 --no-print-directory -f "$root/Makefile" \
        release-patch "MAKEFLAGS=$selection" RELEASE_REMOTE=review RELEASE_BRANCH=main \
        "AUDIT_SELECTION=owner's selection" > "$fixture/output" 2>&1
    printf '%s\n' patch review main > "$fixture/cache-entry-expected"
    cmp "$fixture/cache-entry-expected" "$EVENTS"
done

# A rejected release cannot start a chained publication.
: > "$EVENTS"
if PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -f "$root/Makefile" \
    release-patch RELEASE_DELIVERY=pr > "$fixture/output" 2>&1 && \
    PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory -f "$root/Makefile" publish \
        >> "$fixture/output" 2>&1; then exit 1; fi
[[ ! -s "$EVENTS" ]] || exit 1
for target in publish publish-check; do
    for fail in 0 1; do
        : > "$EVENTS"
        status=0
        PATH="$fixture/bin:$PATH" FAIL_PUBLISH="$fail" "$real_make" --no-print-directory \
            -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
        if [[ "$fail" == 0 ]]; then [[ "$status" == 0 ]] || exit 1; else [[ "$status" != 0 ]] || exit 1; fi
        printf '%s\n' publish -p ic-metrics -p ic-metrics-stable --locked --registry crates-io > "$fixture/expected"
        if [[ "$target" == publish-check ]]; then printf '%s\n' --dry-run >> "$fixture/expected"; fi
        cmp "$fixture/expected" "$EVENTS"
    done
done
echo 'release and publication Make adapters passed (command stubs; no Git or registry effects)'
fixture_complete=true
