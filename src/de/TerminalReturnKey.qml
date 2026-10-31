import QtQuick 2.4
import keys 1.0

ReturnKey {
    id: returnKey
    objectName: "terminal-return"
    property var terminal
    // Keep application-specific action icons and labels; replace only the
    // default icon with scalable high-resolution Breeze artwork.
    iconNormal: overrideIconName
    iconShifted: iconNormal
    iconCapsLock: iconNormal
    overridePressArea: terminal.active
    onReleased: { if (terminal.active) terminal.send("Return") }
    Image {
        objectName: "terminal-return-icon"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -returnKey.rowMargin / 2
        width: Math.min(returnKey.width * 0.68, returnKey.height * 0.68)
        height: width
        fillMode: Image.PreserveAspectFit
        source: "icons/enter.png"
        visible: returnKey.overrideIconName === "" && returnKey.overrideLabel === ""
    }
}
