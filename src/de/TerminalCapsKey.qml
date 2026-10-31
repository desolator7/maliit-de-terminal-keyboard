import QtQuick 2.4
import MaliitKeyboard 2.0
import keys 1.0
ActionKey {
    id: root
    objectName: "terminal-caps"
    label: "Fest"
    shifted: label
    overridePressArea: true
    noMagnifier: true
    onReleased: panel.activeKeypadState = panel.activeKeypadState === "CAPSLOCK" ? "NORMAL" : "CAPSLOCK"
    Rectangle {
        anchors.fill: parent
        anchors.margins: Device.gu(0.25)
        color: "transparent"
        border.width: 2
        border.color: "#3daee9"
        radius: 4
        visible: panel.activeKeypadState === "CAPSLOCK"
    }
}
