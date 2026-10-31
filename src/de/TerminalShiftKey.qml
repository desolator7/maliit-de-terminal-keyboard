import QtQuick 2.4
import keys 1.0

ShiftKey {
    id: shiftKey
    // Draw high-resolution Breeze artwork directly, since the 22 px theme icon
    // is not upscaled by Qt when a larger icon is requested.
    iconNormal: ""
    iconShifted: ""
    iconCapsLock: ""
    Image {
        objectName: "terminal-shift-icon"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -shiftKey.rowMargin / 2
        width: Math.min(shiftKey.width * 0.68, shiftKey.height * 0.68)
        height: width
        fillMode: Image.PreserveAspectFit
        source: panel.activeKeypadState === "CAPSLOCK" ? "icons/shift-locked.png" :
                panel.activeKeypadState === "SHIFTED" ? "icons/shift-enabled.png" : "icons/shift-disabled.png"
    }
}
