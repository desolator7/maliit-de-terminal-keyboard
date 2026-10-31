import QtQuick 2.4
import MaliitKeyboard 2.0
import keys 1.0

ActionKey {
    id: root
    objectName: "terminal-caps"
    overridePressArea: true
    noMagnifier: true
    onReleased: panel.activeKeypadState = panel.activeKeypadState === "CAPSLOCK" ? "NORMAL" : "CAPSLOCK"
    Image {
        objectName: "terminal-caps-icon"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -root.rowMargin / 2
        width: Math.min(root.width * 0.68, root.height * 0.68)
        height: width
        rotation: 180
        fillMode: Image.PreserveAspectFit
        source: panel.activeKeypadState === "CAPSLOCK" ? "icons/shift-locked.png" : "icons/shift-disabled.png"
    }
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
