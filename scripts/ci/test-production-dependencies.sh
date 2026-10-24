#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
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
    for name in ic-build ic-host-fs ic-testkit ic-stable-structures ordinary; do package "$name"; done
}
check_case() {
    local label="$1" expected="$2" status=0
    "$real_cargo" generate-lockfile --offline --manifest-path "$fixture/workspace/Cargo.toml" > "$fixture/lock.log" 2>&1 || {
        status=$?; cat "$fixture/lock.log" >&2; return "$status"
    }
    perl "$checker" --consumer "$fixture/workspace" > "$fixture/$label.log" 2>&1 || status=$?
    if [[ "$expected" == pass ]]; then
        if [[ "$status" != 0 ]]; then cat "$fixture/$label.log" >&2; return 1; fi
    elif [[ "$status" == 0 ]]; then
        echo "production graph unexpectedly admitted $label" >&2; return 1
    fi
}

reset_case
check_case dependency-free pass
printf '\n[dev-dependencies]\nhelper = { package = "ic-testkit", path = "../../../vendor/ic-testkit" }\nbuilder = { package = "ic-build", path = "../../../vendor/ic-build" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case development-package pass

reset_case
printf '\n[dependencies]\nordinary = { path = "../../../vendor/ordinary" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case arithmetic-production-edge fail

for dependency in ic-build ic-host-fs ic-testkit; do
    reset_case
    printf '\n[dependencies]\nordinary = { path = "../../../vendor/ordinary" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
    printf '[dependencies]\nrenamed = { package = "%s", path = "../%s" }\n' "$dependency" "$dependency" >> "$fixture/vendor/ordinary/Cargo.toml"
    check_case "transitive-renamed-$dependency" fail
done

reset_case
printf '\n[target.\x27cfg(target_arch = "wasm32")\x27.dependencies]\nrenamed = { package = "ic-host-fs", path = "../../../vendor/ic-host-fs" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case wasm-only-tooling fail

reset_case
printf '\n[build-dependencies]\nhelper = { package = "ic-testkit", path = "../../../vendor/ic-testkit" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case tooling-build-edge fail

reset_case
printf '\n[dev-dependencies]\nraw = { package = "ic-stable-structures", path = "../../../vendor/ic-stable-structures" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case direct-development-substrate fail

# A successful-looking partial observation is not accepted after child failure.
reset_case
mkdir -p "$fixture/bin"
cat > "$fixture/bin/cargo" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == tree ]]; then
    printf 'ic-metrics v0.1.0|\n'
    exit 7
fi
exec "$REAL_CARGO" "$@"
STUB
chmod +x "$fixture/bin/cargo"
export REAL_CARGO="$real_cargo"
PATH="$fixture/bin:$PATH" check_case partial-failed-observation fail
fixture_complete=true
echo 'Arithmetic-only graph admission, development isolation and failed observations passed'
