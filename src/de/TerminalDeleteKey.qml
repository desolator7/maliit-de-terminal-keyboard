import QtQuick 2.4
import keys 1.0
ActionKey {
    objectName: "terminal-delete"
    property var terminal
    property var nativeInput
    label: "Entf"
    shifted: label
    noMagnifier: true
    overridePressArea: true
    enabled: nativeInput.available
    onReleased: {
        event_handler.onKeyReleased("", "commit")
        nativeInput.deleteForward(terminal.ctrl, terminal.alt, panel.activeKeypadState === "SHIFTED")
        terminal.clearLater()
    }
}
