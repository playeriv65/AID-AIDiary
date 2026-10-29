#!/usr/bin/env bash
# Copies the nightly release's manifest and packages from GitHub into the
# folder nginx serves at https://aid.playeriv65.com/updates/, for devices
# that cannot reach GitHub (docs/UPDATES.md). Every file is checked against
# the manifest's SHA-256, and the manifest goes up last, so a device never
# reads one whose files are not there yet. Run hourly by
# aid-update-mirror.timer; does nothing while the release is unchanged.
set -euo pipefail

source_url="${AID_UPDATES_SOURCE:-https://github.com/playeriv65/AID-AIDiary/releases/download/nightly}"
target="${AID_UPDATES_DIR:-/srv/aid-updates/www}"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

curl -fsSL --retry 3 "$source_url/latest.json" -o "$work/latest.json"
build=$(jq -er .build "$work/latest.json")
if [ -f "$target/latest.json" ] &&
  [ "$(jq -r .build "$target/latest.json")" = "$build" ]; then
  exit 0
fi

names=()
while read -r name sum; do
  case "$name" in
    '' | *[!A-Za-z0-9._-]*) echo "Bad file name in the manifest: $name" >&2; exit 1 ;;
  esac
  curl -fsSL --retry 3 "$source_url/$name" -o "$work/$name"
  echo "$sum  $work/$name" | sha256sum -c --quiet -
  names+=("$name")
done < <(jq -er '.files[] | "\(.name) \(.sha256)"' "$work/latest.json")

mkdir -p "$target"
for name in "${names[@]}" latest.json; do
  install -m 644 "$work/$name" "$target/.$name.new"
  mv -f "$target/.$name.new" "$target/$name"
done
# Packages of earlier builds the manifest no longer names.
for file in "$target"/*; do
  name=$(basename "$file")
  if [ "$name" != latest.json ] && [[ ! " ${names[*]} " == *" $name "* ]]; then
    rm -f "$file"
  fi
done
echo "Mirrored build $build"
