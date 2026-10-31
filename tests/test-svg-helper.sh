#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
printf 'ID=cachyos\nID_LIKE=arch\n' > "$tmp/os-release"
[[ $(OS_RELEASE_FILE="$tmp/os-release" "$root/scripts/install-qt5-svg.sh" --dry-run) == *'pacman -S --needed -- qt5-svg '* ]]
printf 'ID=ubuntu\nID_LIKE=debian\n' > "$tmp/os-release"
[[ $(OS_RELEASE_FILE="$tmp/os-release" "$root/scripts/install-qt5-svg.sh" --dry-run) == *'apt-get install -- libqt5svg5 '* ]]
printf 'ID=fedora\n' > "$tmp/os-release"
[[ $(OS_RELEASE_FILE="$tmp/os-release" "$root/scripts/install-qt5-svg.sh" --dry-run) == *'dnf install qt5-qtsvg '* ]]
printf 'ID=unknown\n' > "$tmp/os-release"
if OS_RELEASE_FILE="$tmp/os-release" "$root/scripts/install-qt5-svg.sh" --dry-run > /dev/null 2>&1; then
    echo 'Unbekannte Distribution wurde fälschlich akzeptiert.' >&2; exit 1
fi
echo 'SVG-Paketmanager: 4 Prüfungen erfolgreich'
