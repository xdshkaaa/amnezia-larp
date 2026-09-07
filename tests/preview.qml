import QtQuick
import QtQuick.Window
import "../client/ui/qml/Components"

Window {
    id: window
    visible: true
    width: 380
    height: 420
    color: "#1E1E1E"
    FontLoader { source: "../client/fonts/pt-root-ui_vf.ttf" }
    LarpConnectionControl {
        anchors.fill: parent
        connected: true
    }
    Timer {
        interval: 700
        running: true
        onTriggered: window.contentItem.grabToImage(function(result) {
            result.saveToFile(Qt.resolvedUrl("../dist/qa/connection-preview.png").toString().replace("file://", ""))
            Qt.quit()
        })
    }
}
