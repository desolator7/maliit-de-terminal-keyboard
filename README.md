# Deutsches Maliit-Terminallayout für KDE Plasma

Eine persönliche Anpassung von Maliit Keyboard für KDE Plasma unter Wayland.
Das Layout orientiert sich an einer kompakten deutschen ISO-Tastatur und ergänzt
Tasten, die insbesondere im Terminal nützlich sind.

- Deutsche QWERTZ-Belegung mit Zahlenreihe, Umlauten, Akzenttasten und
  häufigen AltGr-Beschriftungen; Umschaltzeichen stehen auf den Symboltasten.
- Einrastende Strg-, Alt- und AltGr-Tasten, Pfeile, Tab, Esc, Entf, Ende,
  Bild auf/ab sowie Sonderzeichen- und Emoji-Umschaltung.
- Langdruck auf Zahlen und Sonderzeichen öffnet die direkt wählbaren
  Umschalt- und AltGr-Zeichen. Enter und Rückschritt haben große Symbole;
  die Feststelltaste zeigt einen gedrehten Umschaltpfeil.
- Die normale Maliit-Einbindung in KDE bleibt erhalten. Die Einstellung zur
  automatischen Großschreibung ist im mitgelieferten Konfigurationsstand aus.

## Voraussetzungen

Linux mit KDE Plasma 6 und Wayland, Maliit Keyboard 2.3.x mit den deutschen
Sprachdaten, Qt 5 mit QML- und Quick-Controls-Modulen, Qt-5-Entwicklungsdateien,
`pkg-config`, `moc`, ein C++-Compiler, Python 3 und `kwriteconfig6`.
Für SVG-Symbole wird das Qt-5-SVG-Paket empfohlen. Die Prüfung und die optionale Installation sind unten beschrieben.

Die Entf-Taste erzeugt ein virtuelles Linux-Eingabeereignis über `/dev/uinput`;
sie ist nur aktiv, wenn der angemeldete Benutzer darauf zugreifen darf. Das
Projekt ändert hierfür weder Gruppen- noch Geräteberechtigungen. Andere
Tastenkombinationen nutzen die Eingabeschnittstelle von Maliit.

## Installation

```sh
./install.sh
```

Das Skript prüft die Qt-5-SVG-Unterstützung und meldet, wenn sie fehlt. Es
baut das lokale Qt-5-QML-Plugin aus dem Quellcode, kopiert das
Layout in das persönliche Datenverzeichnis, bindet das installierte deutsche
Maliit-Sprachplugin und dessen Datenbank per Symlink ein und trägt einen
benutzerspezifischen Starter als virtuelle Tastatur in KWin ein. Ein bereits
vorhandenes Layoutverzeichnis `de` wird mit Zeitstempel gesichert. Die
Maliit-Einstellung für automatische Großschreibung wird deaktiviert.

Das Skript erwartet die Maliit-Sprachdaten unter
`$(pkg-config --variable=libdir Qt5Core)/maliit/keyboard2/languages/de`.
Bei abweichendem Installationsort kann das Verzeichnis mit
`MALIIT_SYSTEM_DE_DIR` angegeben werden. Die deutsche Sprache muss in Maliit
aktiviert sein, zum Beispiel:

```sh
gsettings set org.maliit.keyboard.maliit enabled-languages "['de']"
gsettings set org.maliit.keyboard.maliit active-language 'de'
gsettings set org.maliit.keyboard.maliit theme 'breeze'
```

Diese Befehle ersetzen die bisher aktivierten Maliit-Sprachen beziehungsweise
das gewählte Theme. Der vollständige dokumentierte Einstellungsstand liegt in
`config/maliit-settings.txt`; er wird nicht ungefragt komplett übernommen.

### SVG-Unterstützung für Qt 5

Maliit verwendet Qt **5**. Ein installiertes Qt-6-SVG-Paket ersetzt die
Qt-5-SVG-Bibliothek und die dazugehörigen Bildformat- und Icon-Plugins nicht.
Die folgenden Prüfungen laden ein SVG als Bild und als Themesymbol:

```sh
./scripts/check-qt5-svg.sh
```

Das Skript benötigt den vorhandenen C++-Compiler und die Qt-5-Gui/Core-
Entwicklungsdateien. Fehlt die Unterstützung, lässt sie sich auf unterstützten
Distributionen ausdrücklich installieren:

```sh
./scripts/install-qt5-svg.sh --dry-run  # Befehl anzeigen
./scripts/install-qt5-svg.sh            # Paketmanager ausführen
```

Alternativ führt `./install.sh --with-svg` die Abhängigkeitsinstallation bei
Bedarf vor der Layoutinstallation aus. Das normale `./install.sh` meldet eine
fehlende Unterstützung, installiert aber keine Systempakete. Die Paketbefehle
benötigen bei Ausführung als normaler Benutzer `sudo`:

- Arch Linux und Derivate: `sudo pacman -S --needed qt5-svg`.
- Debian und Ubuntu: `sudo apt-get install libqt5svg5`.
- Fedora: `sudo dnf install qt5-qtsvg`.

Die Pakete enthalten die für Qt 5 nötigen SVG-Plugins; siehe die Paketlisten
von [Arch Linux](https://archlinux.org/packages/extra/x86_64/qt5-svg/files/),
[Debian](https://packages.debian.org/sid/amd64/libqt5svg5/filelist) und
[Fedora](https://packages.fedoraproject.org/pkgs/qt5-qtsvg/qt5-qtsvg/).
Unter anderen Distributionen muss das entsprechende Qt-5-SVG-Paket über deren
Paketverwaltung installiert werden. Qt-5-SVG-Bibliotheken sind bewusst nicht
als systemabhängige Binärdateien im Repository enthalten.

Nach der Installation muss Maliit neu gestartet werden, damit es die Qt-Plugins
lädt. Die Rückschritttaste im deutschen Layout verwendet direkt ein großes
Breeze-Symbol und ist daher unabhängig vom falsch geschriebenen Symbolnamen
im originalen Maliit-Layout.

### Symbol-Fallback

Falls die Qt-5-SVG-Unterstützung fehlt, enthält `config/icons/breeze/` die auf
dem Ausgangssystem verwendeten PNG-Fallbacks und einen Alias für den
Maliit-Tippfehler `edit-clear-symoblic`. Der Alias kann für nicht angepasste
Maliit-Ansichten weiterhin nützlich sein. Diese Dateien ergänzen das
persönliche Breeze-Theme und können auch von anderen Anwendungen verwendet
werden. Das Installationsskript installiert sie nicht automatisch; vorhandene
eigene Icon-Dateien sollten nicht überschrieben werden. Die großen Umschalt-,
Enter- und Rückschrittsymbole bleiben als hochaufgelöste PNGs enthalten.

## Konfiguration und Struktur

- `src/de/`: QML-Layouts für normale Text-, E-Mail- und URL-Felder sowie
  Tastenkomponenten und hochaufgelöste Umschalt-, Enter- und Rückschrittsymbole.
- `src/de/terminalinput/`: Quellcode des lokalen QML-Plugins für Entf.
  Ein systemspezifisches kompiliertes Plugin wird nicht mitgeliefert.
- `config/kwin-wayland.ini`: relevanter KWin-Auszug mit Platzhalter für das
  Home-Verzeichnis; die übrige persönliche KDE-Konfiguration ist nicht enthalten.
- `config/maliit-keyboard-de.desktop.in`: Vorlage des Starters.
- `config/maliit-settings.txt`: dokumentierter GSettings-Stand.
- `config/icons/breeze/`: optionale Icon-Fallbacks.
- `assets/breeze-svg/` und `NOTICE.md`: Quellen und Lizenzhinweise der Symbole.
- `scripts/check-qt5-svg.sh` und `scripts/install-qt5-svg.sh`: SVG-Prüfung
  und optionale Installation der Systemabhängigkeit.

Das deutsche Maliit-Sprachplugin und die Datenbank sind Bestandteile der
lokalen Maliit-Installation und werden beim Installieren verlinkt.

## Tests

```sh
./tests/run.sh
```

Die Tests prüfen die SVG-Paketmanager-Erkennung und melden den Status von Qt-5-SVG.
Die Qt-Tests prüfen die Zeichentasten auf vier Belegungsebenen, die sichtbaren
Beschriftungen, Steuer- und Navigationstasten, Langdruck und Auswahl der
Alternativen sowie die Umschaltung zu Sonderzeichen und Emoji. Das virtuelle Eingabegerät für Entf wird im Test
simuliert; die tatsächliche Eingabe in einer Terminalanwendung muss zusätzlich
auf dem Zielsystem geprüft werden. `MALIIT_QML_DIR` kann auf ein abweichendes
Maliit-QML-Verzeichnis gesetzt werden.

## Lizenz

LGPL 3; Hinweise zu den Ursprüngen und zu Breeze-Symbolen stehen in
[NOTICE.md](NOTICE.md).
