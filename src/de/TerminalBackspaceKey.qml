import QtQuick 2.4
import keys 1.0

BackspaceKey {
    id: backspaceKey
    objectName: "terminal-backspace"
    property var terminal
    // Use the correctly named artwork directly, bypassing Maliit's typo and
    // the fixed-size icon-theme fallback while preserving auto-repeat.
    iconNormal: ""
    iconShifted: ""
    iconCapsLock: ""
    overridePressArea: terminal.active
    onReleased: {
        if (terminal.pendingDead && !terminal.ctrl && !terminal.alt && !terminal.altgr) {
            Qt.callLater(function() { terminal.pendingDead = "" })
        } else if (terminal.active) terminal.send("Backspace")
    }
    Image {
        objectName: "terminal-backspace-icon"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -backspaceKey.rowMargin / 2
        width: Math.min(backspaceKey.width * 0.68, backspaceKey.height * 0.68)
        height: width
        fillMode: Image.PreserveAspectFit
        source: "icons/backspace.png"
    }
}
