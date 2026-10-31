#!/usr/bin/env bash
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
data_dir=${XDG_DATA_HOME:-"$HOME/.local/share"}
languages_dir="$data_dir/maliit-keyboard/languages"
target="$languages_dir/de"
qt_lib_dir=$(pkg-config --variable=libdir Qt5Core)
system_de=${MALIIT_SYSTEM_DE_DIR:-"$qt_lib_dir/maliit/keyboard2/languages/de"}
[[ -f "$system_de/libdeplugin.so" && -f "$system_de/database_de.db" ]] || { echo "Maliit-Sprachdateien fehlen in $system_de. MALIIT_SYSTEM_DE_DIR ggf. setzen." >&2; exit 1; }
command -v kwriteconfig6 >/dev/null || { echo 'kwriteconfig6 fehlt.' >&2; exit 1; }
command -v gsettings >/dev/null || { echo 'gsettings fehlt.' >&2; exit 1; }
command -v python3 >/dev/null || { echo 'python3 fehlt.' >&2; exit 1; }
command -v maliit-keyboard >/dev/null || { echo 'maliit-keyboard fehlt.' >&2; exit 1; }
mkdir -p "$languages_dir" "$data_dir/applications"
staging=$(mktemp -d "$languages_dir/.de-install.XXXXXX")
trap '[[ -z ${staging:-} ]] || rm -rf -- "$staging"' EXIT
cp -a "$project_dir/src/de/." "$staging/"
"$project_dir/scripts/build-plugin.sh" "$staging/terminalinput"
ln -s "$system_de/libdeplugin.so" "$staging/libdeplugin.so"
ln -s "$system_de/database_de.db" "$staging/database_de.db"
if [[ -e $target || -L $target ]]; then
    backup="$languages_dir/de.backup.$(date +%Y%m%d-%H%M%S)"
    [[ ! -e $backup && ! -L $backup ]] || { echo "Backup existiert bereits: $backup" >&2; exit 1; }
    mv -- "$target" "$backup"
    echo "Bisheriges Layout gesichert: $backup"
fi
mv -- "$staging" "$target"
staging=''
launcher="$data_dir/applications/maliit-keyboard-de.desktop"
export MALIIT_INSTALL_LANGUAGES="$languages_dir" MALIIT_INSTALL_LAUNCHER="$launcher" MALIIT_INSTALL_BINARY="$(command -v maliit-keyboard)"
python3 - <<'PY'
import os
from pathlib import Path

def quote(value):
    return '"' + value.replace('\\', '\\\\').replace('"', '\\"').replace('`', '\\`').replace('$', '\\$').replace('%', '%%') + '"'
args = ["env", "MALIIT_KEYBOARD_LANGUAGES_PATH=" + os.environ['MALIIT_INSTALL_LANGUAGES'], os.environ['MALIIT_INSTALL_BINARY']]
Path(os.environ['MALIIT_INSTALL_LAUNCHER']).write_text('[Desktop Entry]\nName=Maliit (deutsches Tastaturlayout)\nExec=' + ' '.join(quote(x) for x in args) + '\nType=Application\nX-KDE-Wayland-VirtualKeyboard=true\nIcon=input-keyboard-virtual\nNoDisplay=true\n')
PY
kwriteconfig6 --notify --file kwinrc --group Wayland --key InputMethod "$launcher"
gsettings set org.maliit.keyboard.maliit auto-capitalization false
printf 'Installiert. Maliit wurde als virtuelle Tastatur eingetragen.\n'
