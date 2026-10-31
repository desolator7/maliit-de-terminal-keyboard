#!/usr/bin/env bash
set -euo pipefail
plugin_dir=${1:?Verzeichnis mit terminalinput.cpp angeben}
for program in c++ pkg-config; do command -v "$program" >/dev/null || { echo "Fehlt: $program" >&2; exit 1; }; done
pkg-config --exists Qt5Qml Qt5Core || { echo 'Qt-5-Entwicklungsdateien (Core und QML) fehlen.' >&2; exit 1; }
moc_command=''
for candidate in moc-qt5 /usr/lib/qt5/bin/moc /usr/lib/qt/bin/moc moc; do
    if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -v 2>&1 | grep -q ' 5\.'; then moc_command=$candidate; break; fi
done
[[ -n $moc_command ]] || { echo 'Qt-5-moc wurde nicht gefunden.' >&2; exit 1; }
read -r -a flags <<< "$(pkg-config --cflags Qt5Qml Qt5Core)"
read -r -a libraries <<< "$(pkg-config --libs Qt5Qml Qt5Core)"
"$moc_command" "${flags[@]}" "$plugin_dir/terminalinput.cpp" -o "$plugin_dir/terminalinput.moc"
c++ -std=c++11 -shared -fPIC "${flags[@]}" "$plugin_dir/terminalinput.cpp" -o "$plugin_dir/libterminalinput.so" "${libraries[@]}"
