import QtQuick 2.4
import keys 1.0

SpaceKey {
    objectName: "terminal-space"
    property var terminal
    MouseArea {
        anchors.fill: parent
        visible: terminal.active
        onClicked: {
            if (terminal.pendingDead && !terminal.ctrl && !terminal.alt && !terminal.altgr) { terminal.commitCharacter(" "); terminal.clearLater() }
            else terminal.send("Space")
        }
    }
}
