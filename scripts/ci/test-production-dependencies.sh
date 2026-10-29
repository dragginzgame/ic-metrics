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
    mkdir -p "$fixture/workspace/crates/ic-metrics/src" "$fixture/workspace/crates/ic-logging/src"
    printf '[package]\nname = "ic-metrics"\nversion = "0.1.0"\nedition = "2024"\n' > "$fixture/workspace/crates/ic-metrics/Cargo.toml"
    : > "$fixture/workspace/crates/ic-metrics/src/lib.rs"
    printf '[package]\nname = "ic-logging"\nversion = "0.1.0"\nedition = "2024"\n\n[dependencies]\n' > "$fixture/workspace/crates/ic-logging/Cargo.toml"
    : > "$fixture/workspace/crates/ic-logging/src/lib.rs"
    printf '[workspace]\nmembers = ["crates/ic-logging", "crates/ic-metrics"]\nresolver = "3"\n' > "$fixture/workspace/Cargo.toml"
    cp "$root/rust-toolchain.toml" "$fixture/workspace/"
    for name in ic-testkit ic-stable-structures ordinary serde ic-wire; do package "$name"; done
    cat >> "$fixture/workspace/crates/ic-metrics/Cargo.toml" <<'TRANSPORT'
[dependencies]
serde = { path = "../../../vendor/serde", default-features = false }
ic-wire = { path = "../../../vendor/ic-wire", default-features = false }
TRANSPORT
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
check_case standard-arithmetic pass
printf '\n[dev-dependencies]\nhelper = { package = "ic-testkit", path = "../../../vendor/ic-testkit" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case development-package pass

reset_case
check_case standard-transport pass
cp "$fixture/workspace/crates/ic-metrics/Cargo.toml" "$fixture/standard-manifest"
sed 's/default-features = false/optional = true, default-features = false/g' "$fixture/standard-manifest" > "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case optional-transport 'transport dependency must be required without defaults'
sed 's/default-features = false/default-features = true/g' "$fixture/standard-manifest" > "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case transport-default-features 'transport dependency must be required without defaults'
sed '/^ic-wire = /d' "$fixture/standard-manifest" > "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case missing-transport 'missing standard transport dependency'

add_declaration() {
    local owner="$1" selection="$2" table=dependencies extra=''
    case "$selection" in
        optional) extra=', optional = true' ;;
        target) table="target.'cfg(target_os = \"none\")'.dependencies" ;;
        build) table=build-dependencies ;;
    esac
    if [[ "$table" != dependencies ]]; then
        printf '\n[%s]\n' "$table" >> "$fixture/workspace/crates/$owner/Cargo.toml"
    fi
    printf '\nrenamed = { package = "ordinary", path = "../../../vendor/ordinary"%s }\n' \
        "$extra" >> "$fixture/workspace/crates/$owner/Cargo.toml"
}

# Construct the same declaration axes while keeping each owner's policy explicit.
for owner in ic-metrics ic-logging; do
    for selection in normal optional target build; do
        reset_case
        add_declaration "$owner" "$selection"
        check_case "$owner-$selection" "$owner declares a production dependency: ordinary"
    done
done

reset_case
printf '\nic-metrics = { path = "../ic-metrics" }\n' >> "$fixture/workspace/crates/ic-logging/Cargo.toml"
check_case logging-metrics-coupling 'ic-logging declares a production dependency: ic-metrics'

reset_case
printf '[workspace]\nmembers = ["crates/ic-metrics"]\nresolver = "3"\n' > "$fixture/workspace/Cargo.toml"
check_case missing-logging 'missing registered workspace package: ic-logging'

reset_case
printf '\n[dev-dependencies]\nraw = { package = "ic-stable-structures", path = "../../../vendor/ic-stable-structures" }\n' >> "$fixture/workspace/crates/ic-metrics/Cargo.toml"
check_case direct-development-substrate 'ic-metrics directly depends on the stable substrate'

# Metadata is the trust boundary: no partial output from a failed Cargo child
# or a successful malformed/incomplete observation may admit dependencies.
reset_case
mkdir -p "$fixture/bin"
cat > "$fixture/bin/cargo" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == metadata ]]; then
    case "$METRICS_METADATA_CASE" in
        failed)
            printf '%s\n' '{"version":1,"workspace_members":["fixture"],"packages":[{"id":"fixture","name":"ic-metrics","dependencies":[]}]}'
            exit 7 ;;
        malformed) printf 'not JSON\n' ;;
        incomplete) printf '{}\n' ;;
        missing-dependencies)
            printf '%s\n' '{"version":1,"workspace_members":["fixture"],"packages":[{"id":"fixture","name":"ic-metrics"}]}' ;;
        *) exit 99 ;;
    esac
    exit 0
fi
exec "$REAL_CARGO" "$@"
STUB
chmod +x "$fixture/bin/cargo"
export REAL_CARGO="$real_cargo"
for observation in failed malformed incomplete missing-dependencies; do
    expected='invalid Cargo workspace metadata'
    case "$observation" in
        failed) expected='failed observation: cargo metadata' ;;
        missing-dependencies) expected='missing declared dependencies' ;;
    esac
    PATH="$fixture/bin:$PATH" METRICS_METADATA_CASE="$observation" \
        check_case "metadata-$observation" "$expected"
done
fixture_complete=true
echo 'Metrics/Logging admission, dependency isolation and metadata refusals passed'
