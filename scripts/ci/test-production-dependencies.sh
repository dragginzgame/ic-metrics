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
    for name in ic-metrics ic-metrics-stable; do
        mkdir -p "$fixture/workspace/crates/$name/src"
        printf '[package]\nname = "%s"\nversion = "0.1.0"\nedition = "2024"\n' "$name" > "$fixture/workspace/crates/$name/Cargo.toml"
        : > "$fixture/workspace/crates/$name/src/lib.rs"
    done
    printf '[workspace]\nmembers = ["crates/ic-metrics", "crates/ic-metrics-stable"]\nresolver = "3"\n' > "$fixture/workspace/Cargo.toml"
    cp "$root/rust-toolchain.toml" "$fixture/workspace/"
    for name in ic-memory ic-storage ic-stable-structures ic-build ic-host-fs ic-testkit ordinary; do package "$name"; done
    printf '[features]\ntest-support = []\n' >> "$fixture/vendor/ic-memory/Cargo.toml"
    cat >> "$fixture/workspace/crates/ic-metrics-stable/Cargo.toml" <<'EOF'
[dependencies]
ic-metrics = { path = "../ic-metrics" }
ic-memory = { path = "../../../vendor/ic-memory" }
ic-storage = { path = "../../../vendor/ic-storage" }
[dev-dependencies]
ic-memory = { path = "../../../vendor/ic-memory", features = ["test-support"] }
EOF
    printf '[dependencies]\nic-stable-structures = { path = "../ic-stable-structures" }\n' >> "$fixture/vendor/ic-storage/Cargo.toml"
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

# Production traversal omits development-only feature activation; the governed
# transitive substrate remains allowed. No registry package or build is used.
reset_case
check_case development-feature-and-governed-substrate pass
printf '\n[dev-dependencies]\nhelper = { package = "ic-testkit", path = "../../../vendor/ic-testkit" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
printf 'builder = { package = "ic-build", path = "../../../vendor/ic-build" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case development-package pass

# Two versions can resolve successfully while exposing incompatible governed
# handles. Keep identity counting at Shared's observer; qualify our selections.
for dependency in ic-memory ic-storage ic-stable-structures; do
    reset_case
    cp -R "$fixture/vendor/$dependency" "$fixture/vendor/other-$dependency"
    sed 's/version = "0.1.0"/version = "0.2.0"/' \
        "$fixture/vendor/other-$dependency/Cargo.toml" > "$fixture/second-manifest"
    cp "$fixture/second-manifest" "$fixture/vendor/other-$dependency/Cargo.toml"
    if [[ "$dependency" == ic-memory ]]; then
        printf 'ic-memory = { path = "../other-ic-memory" }\n' >> "$fixture/vendor/ic-storage/Cargo.toml"
    elif [[ "$dependency" == ic-stable-structures ]]; then
        printf '[dependencies]\nic-stable-structures = { path = "../other-ic-stable-structures" }\n' >> "$fixture/vendor/ic-memory/Cargo.toml"
    else
        printf '\n[build-dependencies]\nother-storage = { package = "ic-storage", path = "../../../vendor/other-ic-storage" }\n' >> "$fixture/workspace/crates/ic-metrics-stable/Cargo.toml"
    fi
    check_case "multiple-$dependency-identities" fail
    grep -F "$dependency: expected 1 rendered package identities, observed 2" \
        "$fixture/multiple-$dependency-identities.log" > /dev/null
done

reset_case
printf '\n[dependencies]\nordinary = { path = "../../../vendor/ordinary" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case arithmetic-production-edge fail

for dependency in ic-build ic-host-fs ic-testkit; do
    reset_case
    printf 'renamed = { package = "%s", path = "../%s" }\n' "$dependency" "$dependency" >> "$fixture/vendor/ic-storage/Cargo.toml"
    check_case "transitive-renamed-$dependency" fail
done

reset_case
printf '\n[target.\x27cfg(target_arch = "wasm32")\x27.dependencies]\nrenamed = { package = "ic-host-fs", path = "../ic-host-fs" }\n' >> "$fixture/vendor/ic-storage/Cargo.toml"
check_case wasm-only-tooling fail

reset_case
printf '\n[build-dependencies]\nhelper = { package = "ic-testkit", path = "../../../vendor/ic-testkit" }\n' >> "$fixture/workspace/crates/ic-metrics-stable/Cargo.toml"
check_case tooling-build-edge fail

reset_case
printf 'ic-memory = { path = "../ic-memory", features = ["test-support"] }\n' >> "$fixture/vendor/ic-storage/Cargo.toml"
check_case transitive-memory-feature fail

reset_case
printf 'raw = { package = "ic-stable-structures", path = "../../../vendor/ic-stable-structures" }\n' >> "$fixture/workspace/crates/ic-metrics-stable/Cargo.toml"
check_case direct-development-substrate fail

# A successful-looking partial observation is not accepted after child failure.
reset_case
mkdir -p "$fixture/bin"
cat > "$fixture/bin/cargo" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == tree ]]; then
    printf 'ic-metrics v0.1.0|\n'
    exit 7
fi
exec "$REAL_CARGO" "$@"
EOF
chmod +x "$fixture/bin/cargo"
export REAL_CARGO="$real_cargo"
PATH="$fixture/bin:$PATH" check_case partial-failed-observation fail
fixture_complete=true
echo 'production graph admission, transitive/renamed/build exclusions and failed observations passed'
