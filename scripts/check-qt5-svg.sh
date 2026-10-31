#!/usr/bin/env bash
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
for program in c++ pkg-config; do
    command -v "$program" >/dev/null || { echo "Fehlt für die Prüfung: $program" >&2; exit 2; }
done
pkg-config --exists Qt5Gui Qt5Core || { echo 'Qt-5-Gui/Core-Entwicklungsdateien fehlen für die Prüfung.' >&2; exit 2; }
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
read -r -a flags <<< "$(pkg-config --cflags Qt5Gui Qt5Core)"
read -r -a libraries <<< "$(pkg-config --libs Qt5Gui Qt5Core)"
c++ -std=c++11 -fPIC "${flags[@]}" "$project_dir/scripts/check-qt5-svg.cpp" -o "$tmp/check-qt5-svg" "${libraries[@]}"
QT_QPA_PLATFORM=offscreen "$tmp/check-qt5-svg"
