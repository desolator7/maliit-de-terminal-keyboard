#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
"$root/tests/test-svg-helper.sh"
if "$root/scripts/check-qt5-svg.sh"; then
    echo 'SVG-Prüfung: verfügbar'
else
    check_status=$?
    if [[ $check_status -ne 1 ]]; then echo 'SVG-Prüfung konnte nicht ausgeführt werden.' >&2; exit "$check_status"; fi
    echo 'SVG-Prüfung: Qt-5-SVG fehlt (Layouttests laufen mit PNG-Symbolen weiter).'
fi
qt_lib_dir=$(pkg-config --variable=libdir Qt5Core)
qml_dir=${MALIIT_QML_DIR:-"$qt_lib_dir/maliit/keyboard2/qml"}
[[ -f "$qml_dir/keys/qmldir" ]] || { echo "Maliit-QML-Dateien fehlen: $qml_dir" >&2; exit 1; }
cp -a "$root/src/de" "$tmp/de"
"$root/scripts/build-plugin.sh" "$tmp/de/terminalinput"
cp -a "$root/tests/qml" "$tmp/qml"
python3 - "$tmp/qml/test.qml" "$tmp/qml/longpress.qml" "$tmp/de/Keyboard_de.qml" <<'PY'
import pathlib, sys
for name in sys.argv[1:3]:
    p=pathlib.Path(name); s=p.read_text().replace('../../src/de/Keyboard_de.qml', pathlib.Path(sys.argv[3]).as_uri()); p.write_text(s)
PY
read -r -a flags <<< "$(pkg-config --cflags Qt5Gui Qt5Qml Qt5Core Qt5Quick Qt5Test)"
read -r -a libraries <<< "$(pkg-config --libs Qt5Gui Qt5Qml Qt5Core Qt5Quick Qt5Test)"
c++ -fPIC "${flags[@]}" "$root/tests/equal-legends.cpp" -o "$tmp/keys-test" "${libraries[@]}"
c++ -fPIC "${flags[@]}" "$root/tests/special-tab-shift.cpp" -o "$tmp/special-test" "${libraries[@]}"
c++ -fPIC "${flags[@]}" "$root/tests/longpress.cpp" -o "$tmp/longpress-test" "${libraries[@]}"
cc -shared -fPIC "$root/tests/mock-uinput.c" -o "$tmp/mock-uinput.so" -ldl
export QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software QML2_IMPORT_PATH="$tmp/qml:$qml_dir"
"$tmp/keys-test" "$tmp/qml/test.qml" "$root/tests/xkb-expectations.json"
MALIIT_TEST_UINPUT="$tmp/uinput-events.bin" LD_PRELOAD="$tmp/mock-uinput.so" "$tmp/special-test" "$tmp/qml/test.qml"
MALIIT_TEST_UINPUT="$tmp/uinput-events-longpress.bin" LD_PRELOAD="$tmp/mock-uinput.so" "$tmp/longpress-test" "$tmp/qml/longpress.qml" "$root/tests/xkb-expectations.json"
