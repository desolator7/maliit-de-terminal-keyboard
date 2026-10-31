pragma Singleton
import QtQuick 2.4
QtObject {
 property var actionKeyOverride: null
 property string activeLanguage: "de"
 property var enabledLanguages: ["de"]
 property bool enableMagnifier: false
 function selectNextLanguage() {}
 function hide() {}
}
