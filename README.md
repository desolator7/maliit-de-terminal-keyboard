# Deutsches Maliit-Terminallayout für KDE Plasma

Eine persönliche Anpassung von Maliit Keyboard für KDE Plasma unter Wayland.
Das Layout orientiert sich an einer kompakten deutschen ISO-Tastatur und ergänzt
Tasten, die insbesondere im Terminal nützlich sind.

- Deutsche QWERTZ-Belegung mit Zahlenreihe, Umlauten, Akzenttasten und
  häufigen AltGr-Beschriftungen; Umschaltzeichen stehen auf den Symboltasten.
- Einrastende Strg-, Alt- und AltGr-Tasten, Pfeile, Tab, Esc, Entf, Ende,
  Bild auf/ab sowie Sonderzeichen- und Emoji-Umschaltung.
- Die normale Maliit-Einbindung in KDE bleibt erhalten. Die Einstellung zur
  automatischen Großschreibung ist im mitgelieferten Konfigurationsstand aus.

## Voraussetzungen

Linux mit KDE Plasma 6 und Wayland, Maliit Keyboard 2.3.x mit den deutschen
Sprachdaten, Qt 5 mit QML- und Quick-Controls-Modulen, Qt-5-Entwicklungsdateien,
`pkg-config`, `moc`, ein C++-Compiler, Python 3 und `kwriteconfig6`.
Für SVG-Symbole wird das Qt-5-SVG-Paket empfohlen (unter Arch Linux `qt5-svg`).

Die Entf-Taste erzeugt ein virtuelles Linux-Eingabeereignis über `/dev/uinput`;
sie ist nur aktiv, wenn der angemeldete Benutzer darauf zugreifen darf. Das
Projekt ändert hierfür weder Gruppen- noch Geräteberechtigungen. Andere
Tastenkombinationen nutzen die Eingabeschnittstelle von Maliit.

## Installation

```sh
./install.sh
```

Das Skript baut das lokale Qt-5-QML-Plugin aus dem Quellcode, kopiert das
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

### Symbol-Fallback

Falls die Qt-5-SVG-Unterstützung fehlt, enthält `config/icons/breeze/` die auf
dem Ausgangssystem verwendeten PNG-Fallbacks und einen Alias für den
Maliit-Tippfehler `edit-clear-symoblic`. Diese Dateien ergänzen das persönliche
Breeze-Theme und können auch von anderen Anwendungen verwendet werden. Das
Installationsskript installiert sie nicht automatisch; vorhandene eigene
Icon-Dateien sollten nicht überschrieben werden. Eine aktualisierte
Qt-5-SVG-Unterstützung ist vorzuziehen. Für das falsch geschriebene Symbol kann
der mitgelieferte Alias weiterhin erforderlich sein.

## Konfiguration und Struktur

- `src/de/`: QML-Layouts für normale Text-, E-Mail- und URL-Felder sowie
  Tastenkomponenten und hochaufgelöste Umschaltsymbole.
- `src/de/terminalinput/`: Quellcode des lokalen QML-Plugins für Entf.
  Ein systemspezifisches kompiliertes Plugin wird nicht mitgeliefert.
- `config/kwin-wayland.ini`: relevanter KWin-Auszug mit Platzhalter für das
  Home-Verzeichnis; die übrige persönliche KDE-Konfiguration ist nicht enthalten.
- `config/maliit-keyboard-de.desktop.in`: Vorlage des Starters.
- `config/maliit-settings.txt`: dokumentierter GSettings-Stand.
- `config/icons/breeze/`: optionale Icon-Fallbacks.
- `assets/breeze-svg/` und `NOTICE.md`: Quellen und Lizenzhinweise der Symbole.

Das deutsche Maliit-Sprachplugin und die Datenbank sind Bestandteile der
lokalen Maliit-Installation und werden beim Installieren verlinkt.

## Tests

```sh
./tests/run.sh
```

Die Qt-Tests prüfen die Zeichentasten auf vier Belegungsebenen, die sichtbaren
Beschriftungen, Steuer- und Navigationstasten sowie die Umschaltung zu
Sonderzeichen und Emoji. Das virtuelle Eingabegerät für Entf wird im Test
simuliert; die tatsächliche Eingabe in einer Terminalanwendung muss zusätzlich
auf dem Zielsystem geprüft werden. `MALIIT_QML_DIR` kann auf ein abweichendes
Maliit-QML-Verzeichnis gesetzt werden.

## Lizenz

LGPL 3; Hinweise zu den Ursprüngen und zu Breeze-Symbolen stehen in
[NOTICE.md](NOTICE.md).
