import QtQuick 2.4
import keys 1.0

BackspaceKey {
    objectName: "terminal-backspace"
    property var terminal
    overridePressArea: terminal.active
    onReleased: {
        if (terminal.pendingDead && !terminal.ctrl && !terminal.alt && !terminal.altgr) {
            Qt.callLater(function() { terminal.pendingDead = "" })
        } else if (terminal.active) terminal.send("Backspace")
    }
}
