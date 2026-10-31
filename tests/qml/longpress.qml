import QtQuick 2.4
import QtQuick.Window 2.4
import keys 1.0
Window {
 id: window
 visible: true
 width: 1300; height: 700
 property var events: []
 function popupPoint(text) {
  for (var i = 0; i < extendedKeysSelector.keys.length; ++i) {
   var key = extendedKeysSelector.keys[i]
   if (key.commitStr === text) {
    var point = key.mapToItem(null, key.width / 2, key.height / 2)
    return { x: point.x, y: point.y }
   }
  }
  return { x: -100, y: -100 }
 }
 Item {
  id: panel
  objectName: "test-panel"
  anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 500
  state: "CHARACTERS"
  QtObject { id: keypad; objectName: "test-keypad"; property string state: ""; property int keyWidth: panel.keyWidth }
  QtObject { id: canvas; property bool extendedKeysShown: false }
  property string emojiState: keypad.state
  property int keyWidth: 0
  property int keyHeight: 0
  property string activeKeypadState: "NORMAL"
  property bool autoCapsTriggered: false
  property bool hideKeyLabels: false
  property Item lastKeyPressed
  QtObject {
   id: event_handler
   function onKeyReleased(label, action) { window.events = window.events.concat([(action || "") + ":" + label]) }
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
  ExtendedKeysSelector {
   id: extendedKeysSelector
   objectName: "test-selector"
   anchors.fill: parent
   z: 10
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
