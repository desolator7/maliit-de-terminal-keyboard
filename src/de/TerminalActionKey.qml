import QtQuick 2.4
import keys 1.0

ActionKey {
    objectName: "terminal-" + label
    property var terminal
    property string keyName
    shifted: label
    noMagnifier: true
    overridePressArea: true
    onReleased: terminal.send(keyName)
}
