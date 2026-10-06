#!/usr/bin/env bash
# Explicit CI provisioning only; ordinary tests never invoke this downloader.
set -euo pipefail

if [ "$#" -ne 0 ]; then
    echo "usage: install-reader-pocketic.sh" >&2
    exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(cd "$script_dir/../.." && pwd)"
host_os="$(uname -s)"
host_arch="$(uname -m)"
case "$host_os/$host_arch" in
    Linux/x86_64)
        asset=pocket-ic-x86_64-linux.gz
        digest=268ba79ec7fe9a563a575adf4983c69627093cce2711d142e476cdc7ad04249e
        ;;
    Darwin/x86_64)
        asset=pocket-ic-x86_64-darwin.gz
        digest=9710b9c4ac4eaa7eb10bddaa2aba80560a59362610f1bcd8c6e23be82a39c327
        ;;
    Darwin/arm64)
        asset=pocket-ic-arm64-darwin.gz
        digest=41cf77e24effc381e21f5e07e908ed078783646e6de05ed52fd6973221f07e64
        ;;
    *)
        echo "No pinned PocketIC artifact for $host_os/$host_arch" >&2
        exit 2
        ;;
esac

# Retain downloads and failed candidates in this repository's target directory.
# A fresh directory avoids replacing a previous run's binary or evidence.
mkdir -p "$root_dir/target/tools"
install_dir="$(mktemp -d "$root_dir/target/tools/reader-pocketic.XXXXXX")"
archive="$install_dir/$asset"
candidate="$install_dir/pocket-ic"
echo "PocketIC 16.0.0 asset: $asset ($digest); artifacts: $install_dir" >&2
curl --proto '=https' --proto-redir '=https' --tlsv1.2 --fail --location \
    --silent --show-error --connect-timeout 30 --max-time 180 \
    --output "$archive" "https://github.com/dfinity/pocketic/releases/download/16.0.0/$asset"
bash "$script_dir/verify-file-checksum.sh" sha256 "$digest" "$archive"
gzip -dc "$archive" > "$candidate"
chmod 0755 "$candidate"
version="$("$candidate" --version)"
if [ "$version" != 'pocket-ic-server 16.0.0' ]; then
    echo "PocketIC version mismatch; retained candidate: $candidate" >&2
    exit 1
fi
echo "Verified $version" >&2
printf '%s\n' "$candidate"
