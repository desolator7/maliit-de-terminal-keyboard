import QtQuick 2.4
import MaliitKeyboard 2.0
import keys 1.0

ActionKey {
    id: root
    objectName: "terminal-" + label
    property var terminal
    property string modifier
    property bool latched: modifier === "ctrl" ? terminal.ctrl : modifier === "alt" ? terminal.alt : terminal.altgr
    shifted: label
    noMagnifier: true
    overridePressArea: true
    onReleased: {
        if (modifier === "ctrl") terminal.ctrl = !terminal.ctrl
        else if (modifier === "alt") terminal.alt = !terminal.alt
        else terminal.altgr = !terminal.altgr
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: Device.gu(0.25)
        color: "transparent"
        border.width: 2
        border.color: "#3daee9"
        radius: 4
        visible: root.latched
    }
}
