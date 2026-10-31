/*
 * Portions derived from Maliit Keyboard, Copyright 2013 Canonical Ltd.
 * Licensed under the GNU Lesser General Public License, version 3.
 * See LICENSE and NOTICE.md for attribution.
 */
import QtQuick 2.4
import MaliitKeyboard 2.0
import keys 1.0
import "terminalinput" 1.0 as TerminalInput

KeyPad {
    anchors.fill: parent
    TerminalState { id: terminalState }
    TerminalInput.NativeInput { id: nativeInput; objectName: "native-input" }
    content: c1
    symbols: "languages/Keyboard_symbols.qml"
    Column {
        id: c1
        property real maxNrOfKeys: 16
        anchors.fill: parent
        spacing: 0
        Row {
            anchors.left: parent.left
            spacing: 0
            TerminalActionKey { terminal: terminalState; label: "Esc"; keyName: "Esc"; width: panel.keyWidth * 1; padding: 0 }
            TerminalCharKey { terminal: terminalState; label: "1"; shifted: "!"; }
            TerminalCharKey { terminal: terminalState; label: "2"; shifted: "\""; }
            TerminalCharKey { terminal: terminalState; label: "3"; shifted: "§"; }
            TerminalCharKey { terminal: terminalState; label: "4"; shifted: "$"; }
            TerminalCharKey { terminal: terminalState; label: "5"; shifted: "%"; }
            TerminalCharKey { terminal: terminalState; label: "6"; shifted: "&"; }
            TerminalCharKey { terminal: terminalState; label: "7"; shifted: "/"; }
            TerminalCharKey { terminal: terminalState; label: "8"; shifted: "("; }
            TerminalCharKey { terminal: terminalState; label: "9"; shifted: ")"; }
            TerminalCharKey { terminal: terminalState; label: "0"; shifted: "="; }
            TerminalCharKey { terminal: terminalState; label: "ß"; shifted: "?"; }
            TerminalCharKey { terminal: terminalState; label: "´"; shifted: "`"; }
            TerminalBackspaceKey { terminal: terminalState; objectName: "terminal-backspace"; padding: 0; width: panel.keyWidth * 2 }
            TerminalDeleteKey { terminal: terminalState; nativeInput: nativeInput; width: panel.keyWidth; padding: 0 }
        }

        Row {
            anchors.left: parent.left
            spacing: 0
            TerminalActionKey { terminal: terminalState; label: "⇥"; keyName: "Tab"; width: panel.keyWidth * 1.5; padding: 0 }
            TerminalCharKey { terminal: terminalState; label: "q"; shifted: "Q";   }
            TerminalCharKey { terminal: terminalState; label: "w"; shifted: "W";   }
            TerminalCharKey { terminal: terminalState; label: "e"; shifted: "E"; extended: ["è", "é", "ë", "ê", "€"]; extendedShifted: ["È","É", "Ë", "Ê", "€"] }
            TerminalCharKey { terminal: terminalState; label: "r"; shifted: "R";   }
            TerminalCharKey { terminal: terminalState; label: "t"; shifted: "T"; extended: ["þ"]; extendedShifted: ["Þ"] }
            TerminalCharKey { terminal: terminalState; label: "z"; shifted: "Z";   }
            TerminalCharKey { terminal: terminalState; label: "u"; shifted: "U"; extended: ["ü","ù","ú","û"]; extendedShifted: ["Ü","Ù","Ú","Û"] }
            TerminalCharKey { terminal: terminalState; label: "i"; shifted: "I"; extended: ["ì","í","î","ï","ı"]; extendedShifted: ["Ì","Í","Î","Ï","İ"] }
            TerminalCharKey { terminal: terminalState; label: "o"; shifted: "O"; extended: ["ö","ò","ó","ô","õ","ø"]; extendedShifted: ["Ö","Ò","Ó","Ô","Õ","Ø"] }
            TerminalCharKey { terminal: terminalState; label: "p"; shifted: "P";   }
            TerminalCharKey { terminal: terminalState; label: "ü"; shifted: "Ü"; }
            TerminalCharKey { terminal: terminalState; label: "+"; shifted: "*"; }
            Item { width: panel.keyWidth * 0.25; height: panel.keyHeight }
            TerminalReturnKey { objectName: "terminal-return-upper"; terminal: terminalState; width: panel.keyWidth * 1.25; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "Ende"; keyName: "End"; width: panel.keyWidth * 1; padding: 0 }
        }

        Row {
            anchors.left: parent.left
            spacing: 0
            TerminalCapsKey { width: panel.keyWidth * 1.75; padding: 0 }
            TerminalCharKey { terminal: terminalState; label: "a"; shifted: "A"; extended: ["ä","à","á","ã","â","å","æ"]; extendedShifted: ["Ä","À","Â","Á","Ã","Å","Æ"]; }
            TerminalCharKey { terminal: terminalState; label: "s"; shifted: "S"; extended: ["ß","ş","$"]; extendedShifted: ["ẞ","Ş","$"] }
            TerminalCharKey { terminal: terminalState; label: "d"; shifted: "D"; }
            TerminalCharKey { terminal: terminalState; label: "f"; shifted: "F"; }
            TerminalCharKey { terminal: terminalState; label: "g"; shifted: "G"; extended: ["ğ"]; extendedShifted: ["Ğ"]; }
            TerminalCharKey { terminal: terminalState; label: "h"; shifted: "H"; }
            TerminalCharKey { terminal: terminalState; label: "j"; shifted: "J"; }
            TerminalCharKey { terminal: terminalState; label: "k"; shifted: "K"; }
            TerminalCharKey { terminal: terminalState; label: "l"; shifted: "L"; extended: ["ł","£"]; extendedShifted: ["Ł","£"] }
            TerminalCharKey { terminal: terminalState; label: "ö"; shifted: "Ö"; }
            TerminalCharKey { terminal: terminalState; label: "ä"; shifted: "Ä"; }
            TerminalCharKey { terminal: terminalState; label: "#"; shifted: "'"; }
            TerminalReturnKey { objectName: "terminal-return-lower"; terminal: terminalState; width: panel.keyWidth * 1.25; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "Bild ↑"; keyName: "PgUp"; width: panel.keyWidth * 1; padding: 0 }
        }

        Row {
            anchors.left: parent.left
            spacing: 0
            TerminalShiftKey { objectName: "terminal-shift"; width: panel.keyWidth * 1.25; padding: 0 }
            TerminalCharKey { terminal: terminalState; label: "<"; shifted: ">"; }
            TerminalCharKey { terminal: terminalState; label: "y"; shifted: "Y"; extended: ["ÿ","¥"]; extendedShifted: ["Ÿ","¥"] }
            TerminalCharKey { terminal: terminalState; label: "x"; shifted: "X"; }
            TerminalCharKey { terminal: terminalState; label: "c"; shifted: "C"; extended: ["ç","¢"]; extendedShifted: ["Ç","¢"] }
            TerminalCharKey { terminal: terminalState; label: "v"; shifted: "V"; }
            TerminalCharKey { terminal: terminalState; label: "b"; shifted: "B"; }
            TerminalCharKey { terminal: terminalState; label: "n"; shifted: "N"; extended: ["ñ"]; extendedShifted: ["Ñ"] }
            TerminalCharKey { terminal: terminalState; label: "m"; shifted: "M"; }
            TerminalCharKey { terminal: terminalState; label: ","; shifted: ";"; }
            TerminalCharKey { terminal: terminalState; label: "."; shifted: ":"; }
            TerminalCharKey { terminal: terminalState; label: "-"; shifted: "_"; }
            TerminalShiftKey { objectName: "terminal-shift-right"; width: panel.keyWidth * 1.75; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "↑"; keyName: "Up"; width: panel.keyWidth * 1; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "Bild ↓"; keyName: "PgDown"; width: panel.keyWidth * 1; padding: 0 }
        }

        Row {
            anchors.left: parent.left
            spacing: 0
            TerminalModifierKey { terminal: terminalState; label: "Strg"; modifier: "ctrl"; width: panel.keyWidth * 1.25; padding: 0 }
            TerminalModifierKey { terminal: terminalState; label: "Alt"; modifier: "alt"; width: panel.keyWidth * 1.25; padding: 0 }
            SymbolShiftKey { objectName: "terminal-symbols"; width: panel.keyWidth * 1.25; padding: 0 }
            LanguageKey { objectName: "terminal-emoji"; width: panel.keyWidth; padding: 0 }
            TerminalSpaceKey { id: spaceKey; terminal: terminalState; width: panel.keyWidth * 6; padding: 0 }
            TerminalModifierKey { terminal: terminalState; label: "AltGr"; modifier: "altgr"; width: panel.keyWidth * 1.25; padding: 0 }
            TerminalModifierKey { objectName: "terminal-Strg-right"; terminal: terminalState; label: "Strg"; modifier: "ctrl"; width: panel.keyWidth; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "←"; keyName: "Left"; width: panel.keyWidth * 1; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "↓"; keyName: "Down"; width: panel.keyWidth * 1; padding: 0 }
            TerminalActionKey { terminal: terminalState; label: "→"; keyName: "Right"; width: panel.keyWidth * 1; padding: 0 }
        }
    }
}
