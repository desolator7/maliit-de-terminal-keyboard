pragma Singleton
import QtQuick 2.4
QtObject {
 property real actionKeyPadding: 2
 property real keyMargins: 2
 property real rowMarginLandscape: 4
 property real rowMarginPortrait: 4
 property real annotationTopMargin: 2
 property real annotationRightMargin: 2
 property real row_margin: 0
 function gu(n) { return 8*n }
}
