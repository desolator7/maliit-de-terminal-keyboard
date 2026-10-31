#!/usr/bin/env bash
set -euo pipefail
if [[ ${1:-} == --help ]]; then
    echo 'Verwendung: ./scripts/install-qt5-svg.sh [--dry-run]'
    echo 'Installiert die Qt-5-SVG-Laufzeit über den Paketmanager des Systems.'
    exit 0
fi
if [[ $# -gt 1 || (${1:-} != '' && ${1:-} != --dry-run) ]]; then
    echo 'Verwendung: ./scripts/install-qt5-svg.sh [--dry-run]' >&2; exit 2
fi
os_release=${OS_RELEASE_FILE:-/etc/os-release}
[[ -r $os_release ]] || { echo "Betriebssystemdatei fehlt: $os_release" >&2; exit 2; }
# shellcheck disable=SC1090
. "$os_release"
os=" ${ID:-} ${ID_LIKE:-} "
if [[ $os == *' arch '* || $os == *' cachyos '* || $os == *' manjaro '* ]]; then
    manager=pacman; command_args=(-S --needed -- qt5-svg)
elif [[ $os == *' debian '* || $os == *' ubuntu '* ]]; then
    manager=apt-get; command_args=(install -- libqt5svg5)
elif [[ $os == *' fedora '* || $os == *' rhel '* ]]; then
    manager=dnf; command_args=(install qt5-qtsvg)
else
    echo "Nicht unterstützte Distribution (${ID:-unbekannt}); Qt-5-SVG bitte über deren Paketmanager installieren." >&2; exit 2
fi
if [[ ${1:-} != --dry-run ]]; then
    command -v "$manager" >/dev/null || { echo "Paketmanager fehlt: $manager" >&2; exit 2; }
fi
prefix=()
if [[ $EUID -ne 0 ]]; then
    if [[ ${1:-} != --dry-run ]]; then command -v sudo >/dev/null || { echo 'sudo fehlt.' >&2; exit 2; }; fi
    prefix=(sudo)
fi
if [[ ${1:-} == --dry-run ]]; then
    printf '%q ' "${prefix[@]}" "$manager" "${command_args[@]}"; printf '\n'; exit 0
fi
"${prefix[@]}" "$manager" "${command_args[@]}"
