import QtQuick 2.4
import keys 1.0

ReturnKey {
    objectName: "terminal-return"
    property var terminal
    overridePressArea: terminal.active
    onReleased: { if (terminal.active) terminal.send("Return") }
}
