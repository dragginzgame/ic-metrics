#!/usr/bin/env bash
set -euo pipefail
unset GIT_DIR GIT_WORK_TREE
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
fixture="$(fixture_create "${TMPDIR:-/tmp}/metrics-native-source.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Failed native source fixture retained"' EXIT
mkdir -p "$fixture/scripts/ci" "$fixture/crates/example" "$fixture/docs/evidence" "$fixture/.tools" "$fixture/.private-evidence" "$fixture/target"
cp "$root/scripts/ci/native-source-files.sh" "$fixture/scripts/ci/"
git -C "$fixture" init -q
printf '/target/\n/.tools/\n' > "$fixture/.gitignore"
printf 'tracked\n' > "$fixture/Cargo.toml"
git -C "$fixture" add Cargo.toml
names=('space file.rs' $'line\nfile.rs' 'back\slash.rs')
for name in "${names[@]}"; do printf 'pending\n' > "$fixture/crates/example/$name"; done
for directory in docs/evidence .tools .private-evidence target crates/example/target crates/example/.tools crates/example/.private-evidence; do mkdir -p "$fixture/$directory"; printf 'excluded\n' > "$fixture/$directory/payload"; done
bash "$fixture/scripts/ci/native-source-files.sh" > "$fixture/selected.nul"
count=0
while IFS= read -r -d '' file; do
    case "$file" in Cargo.toml|scripts/ci/native-source-files.sh|crates/example/*) ;; *) exit 1 ;; esac
    count=$((count + 1))
    (cd "$fixture" && shasum -a 256 -- "$file") >> "$fixture/hashes"
done < "$fixture/selected.nul"
[[ "$count" == 5 ]]
(cd "$fixture" && shasum -a 256 -c hashes) > "$fixture/check.log"
# Missing tracked source stays selected so the hash boundary cannot silently omit it.
rm "$fixture/Cargo.toml"
bash "$fixture/scripts/ci/native-source-files.sh" > "$fixture/missing.nul"
perl -0ne 'BEGIN { $found=0 } $found=1 if $_ eq "Cargo.toml\0"; END { exit(!$found) }' "$fixture/missing.nul"
fixture_complete=true
echo 'native source selection and filename hashing passed'
