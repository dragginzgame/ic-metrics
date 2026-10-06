#!/usr/bin/env bash
# Exercise the download trust boundary without network or server execution.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "$script_dir/../.." && pwd)"
mkdir -p "$root_dir/target"
fixture="$(mktemp -d "$root_dir/target/reader-provision-fixture.XXXXXX")"
mkdir -p "$fixture/bin" "$fixture/repo/scripts/ci"
cp "$script_dir/install-reader-pocketic.sh" "$script_dir/verify-file-checksum.sh" "$fixture/repo/scripts/ci/"

cat > "$fixture/bin/uname" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
case "$1" in
    -s) printf '%s\n' "$FIXTURE_OS" ;;
    -m) printf '%s\n' "$FIXTURE_ARCH" ;;
    *) exit 2 ;;
esac
SH
cat > "$fixture/bin/curl" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$FIXTURE_CURL_LOG"
while [ "$#" -gt 0 ]; do
    if [ "$1" = --output ]; then
        printf 'untrusted download\n' > "$2"
        break
    fi
    shift
done
SH
cat > "$fixture/bin/gzip" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
touch "$FIXTURE_EXTRACTION_MARKER"
exit 99
SH
chmod 0755 "$fixture/bin/uname" "$fixture/bin/curl" "$fixture/bin/gzip"

for platform in Linux/x86_64 Darwin/x86_64 Darwin/arm64; do
    case "$platform" in
        Linux/x86_64) asset=pocket-ic-x86_64-linux.gz ;;
        Darwin/x86_64) asset=pocket-ic-x86_64-darwin.gz ;;
        Darwin/arm64) asset=pocket-ic-arm64-darwin.gz ;;
    esac
    log="$fixture/${platform//\//-}.curl.log"
    if PATH="$fixture/bin:$PATH" FIXTURE_OS="${platform%/*}" FIXTURE_ARCH="${platform#*/}" \
        FIXTURE_CURL_LOG="$log" FIXTURE_EXTRACTION_MARKER="$fixture/extracted" \
        bash "$fixture/repo/scripts/ci/install-reader-pocketic.sh" \
        > "$log.stdout" 2> "$log.stderr"; then
        echo "Untrusted download was accepted for $platform" >&2
        exit 1
    fi
    [[ "$(cat "$log")" == *"https://github.com/dfinity/pocketic/releases/download/16.0.0/$asset" ]]
    [[ ! -e "$fixture/extracted" && ! -s "$log.stdout" ]]
done

if PATH="$fixture/bin:$PATH" FIXTURE_OS=Linux FIXTURE_ARCH=arm64 \
    FIXTURE_CURL_LOG="$fixture/unsupported.curl.log" FIXTURE_EXTRACTION_MARKER="$fixture/extracted" \
    bash "$fixture/repo/scripts/ci/install-reader-pocketic.sh" \
    > "$fixture/unsupported.stdout" 2> "$fixture/unsupported.stderr"; then
    echo "Unsupported host was accepted" >&2
    exit 1
fi
[[ ! -e "$fixture/unsupported.curl.log" && ! -e "$fixture/extracted" ]]
echo "All three pinned hosts reject untrusted archives before extraction; unsupported hosts never download."
echo "Substitute fixture evidence retained at $fixture"
