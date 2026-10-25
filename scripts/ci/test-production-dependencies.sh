#!/usr/bin/env bash
set -euo pipefail
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-production-graph.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Failed production graph fixture retained"' EXIT
export CARGO_NET_OFFLINE=true RUSTUP_AUTO_INSTALL=0
checker="$root/scripts/ci/check-production-dependencies.pl"
real_cargo="$(command -v cargo)"

package() {
    local name="$1"
    mkdir -p "$fixture/vendor/$name/src"
    printf '[package]\nname = "%s"\nversion = "0.1.0"\nedition = "2024"\n[workspace]\n' "$name" > "$fixture/vendor/$name/Cargo.toml"
    : > "$fixture/vendor/$name/src/lib.rs"
}
reset_case() {
    local name
    rm -rf "$fixture/workspace/crates" "$fixture/vendor" "$fixture/workspace/Cargo.lock"
    mkdir -p "$fixture/workspace/crates/ic-metrics/src"
    printf '[package]\nname = "ic-metrics"\nversion = "0.1.0"\nedition = "2024"\n' > "$fixture/workspace/crates/ic-metrics/Cargo.toml"
    : > "$fixture/workspace/crates/ic-metrics/src/lib.rs"
    printf '[workspace]\nmembers = ["crates/ic-metrics"]\nresolver = "3"\n' > "$fixture/workspace/Cargo.toml"
    cp "$root/rust-toolchain.toml" "$fixture/workspace/"
    for name in ic-testkit ic-stable-structures ordinary; do package "$name"; done
}
check_case() {
    local label="$1" expected="$2" status=0
    "$real_cargo" generate-lockfile --offline --manifest-path "$fixture/workspace/Cargo.toml" > "$fixture/lock.log" 2>&1 || {
        status=$?; cat "$fixture/lock.log" >&2; return "$status"
    }
    perl "$checker" --consumer "$fixture/workspace" > "$fixture/$label.log" 2>&1 || status=$?
    if [[ "$expected" == pass ]]; then
        if [[ "$status" != 0 ]]; then cat "$fixture/$label.log" >&2; return 1; fi
    else
        if [[ "$status" == 0 ]] || ! grep -Fq -- "$expected" "$fixture/$label.log"; then
            echo "missing expected rejection for $label: $expected" >&2
            cat "$fixture/$label.log" >&2
            return 1
        fi
    fi
}

reset_case
check_case dependency-free pass
printf '\n[dev-dependencies]\nhelper = { package = "ic-testkit", path = "../../../vendor/ic-testkit" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case development-package pass

# Each declaration axis is independent of the active host and feature graph.
for selection in normal optional target build; do
    reset_case
    table=dependencies
    extra=''
    case "$selection" in
        optional) extra=', optional = true' ;;
        target) table="target.'cfg(target_os = \"none\")'.dependencies" ;;
        build) table=build-dependencies ;;
    esac
    printf '\n[%s]\nrenamed = { package = "ordinary", path = "../../../vendor/ordinary"%s }\n' \
        "$table" "$extra" >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
    check_case "$selection-declaration" 'ic-metrics declares a production dependency: ordinary'
done

reset_case
printf '\n[dev-dependencies]\nraw = { package = "ic-stable-structures", path = "../../../vendor/ic-stable-structures" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case direct-development-substrate 'ic-metrics directly depends on the stable substrate'

# A successful-looking partial observation is not accepted after child failure.
reset_case
mkdir -p "$fixture/bin"
cat > "$fixture/bin/cargo" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == tree ]]; then
    printf 'ic-metrics v0.1.0\n'
    exit 7
fi
exec "$REAL_CARGO" "$@"
STUB
chmod +x "$fixture/bin/cargo"
export REAL_CARGO="$real_cargo"
PATH="$fixture/bin:$PATH" check_case partial-failed-observation 'Cargo graph observation failed; no graph was admitted'
fixture_complete=true
echo 'Arithmetic-only graph admission, development isolation and failed observations passed'
