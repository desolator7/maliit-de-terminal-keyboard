import QtQuick 2.4
import QtQuick.Window 2.4
Window {
 id: window
 visible: true
 width: 1300; height: 500
 property var events: []
 Item {
  id: panel
  objectName: "test-panel"
  anchors.fill: parent
  state: "CHARACTERS"
  QtObject { id: keypad; objectName: "test-keypad"; property string state: "" }
  property string emojiState: keypad.state
  property int keyWidth: 0
  property int keyHeight: 0
  property string activeKeypadState: "NORMAL"
  property bool autoCapsTriggered: false
  property bool hideKeyLabels: false
  property Item lastKeyPressed
  QtObject {
   id: event_handler
   function onKeyReleased(label, action) { window.events = window.events.concat([action + ":" + label]) }
   function onKeyPressed(label, action) {}
  }
  QtObject {
   id: fullScreenItem
   property bool landscape: true
   property bool cursorSwipe: false
   property int prevSwipePositionX: 0
   property int prevSwipePositionY: 0
   property int height: 500
   property var timerSwipe: QtObject { function stop() {} function restart() {} }
   function processSwipe(x,y) {}
  }
  QtObject { id: magnifier; property var currentlyAssignedKey; property bool shown }
  Item {
   id: extendedKeysSelector
   enabled: false
   property var extendedKeysModel; property var currentlyAssignedKey; property var keys: []
   property bool multirow: false; property int rowX: 0; property int rowY: 0
   function closePopover() {}
  }
  QtObject { id: swipeArea; property var drag: QtObject { property bool active: false } }
  QtObject { id: keyboardSurface; property int y }
  Loader {
   id: loader
   anchors.fill: parent
   source: "../../src/de/Keyboard_de.qml"
   onStatusChanged: if (status === Loader.Error) { console.log("LOAD_FAILED"); Qt.exit(1) }
  }
  
 }
}
