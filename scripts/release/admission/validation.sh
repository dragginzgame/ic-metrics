# shellcheck shell=bash
# Private scenarios sourced by test-release-admission.sh; caller owns scratch and effects.
# shellcheck disable=SC2154 # root, fixture and worktree come from entrypoint/support.

check_validation_adapter() {
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
}
