import QtQuick 2.4
import QtQuick.Controls 2.12
import MaliitKeyboard 2.0
import keys 1.0

CharKey {
    id: terminalKey
    objectName: "terminal-" + label
    property var terminal
    // Match the commonly printed AltGr legends on the German keyboard.
    readonly property var printedAltGrKeys: ["2", "3", "7", "8", "9", "0", "ß", "q", "e", "+", "<"]
    readonly property string printedShift: shifted !== label &&
                                          !(label.toLowerCase() !== label.toUpperCase() && shifted === label.toUpperCase())
                                          ? shifted : ""
    readonly property string printedAltGr: terminal && printedAltGrKeys.indexOf(label) !== -1
                                            ? terminal.altGrCharacter(label) : ""
    readonly property int legendFontSize: Math.max(8, terminalKey.fontSize * 0.42)
    // Hide the built-in annotation and draw both legends with the same font size.
    annotation: "\u00a0"
    // Caps Lock affects letters, not digits and punctuation.
    state: panel.activeKeypadState === "CAPSLOCK" &&
           !(label.length === 1 && label.toLowerCase() !== label.toUpperCase() && shifted === label.toUpperCase())
           ? "NORMAL" : panel.activeKeypadState
    overridePressArea: terminal.active || label === "´"
    onReleased: {
        if (terminal.active || label === "´")
            terminal.sendCharacter(valueToSubmit, label)
    }
    Label {
        objectName: "terminal-altgr-hint"
        text: terminalKey.printedAltGr
        font.pixelSize: terminalKey.legendFontSize
        font.weight: Font.Light
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Device.annotationTopMargin
        anchors.rightMargin: terminalKey.keyMargin + Device.annotationRightMargin
        visible: !panel.hideKeyLabels && text !== ""
        z: 1
    }
    Label {
        objectName: "terminal-shift-hint"
        text: terminalKey.printedShift
        font.pixelSize: terminalKey.legendFontSize
        font.weight: Font.Light
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: Device.annotationTopMargin
        anchors.leftMargin: terminalKey.keyMargin + Device.gu(0.3)
        visible: !panel.hideKeyLabels && terminalKey.state === "NORMAL" && text !== ""
        z: 1
    }
}
