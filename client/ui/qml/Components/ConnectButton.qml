import QtQuick
import Larp 1.0

LarpConnectionControl {
    id: root
    property bool isFocusable: true
    connected: ConnectionController.isConnected
    busy: ConnectionController.isConnectionInProgress
    progressText: ConnectionController.connectionStateText
    displayName: LarpProfile.displayName

    Keys.onTabPressed: FocusController.nextKeyTabItem()
    Keys.onBacktabPressed: FocusController.previousKeyTabItem()
    Keys.onUpPressed: FocusController.nextKeyUpItem()
    Keys.onDownPressed: FocusController.nextKeyDownItem()
    Keys.onLeftPressed: FocusController.nextKeyLeftItem()
    Keys.onRightPressed: FocusController.nextKeyRightItem()

    Connections {
        target: ConnectionController
        function onPreparingConfig() {
            PageController.showNotificationMessage(qsTr("Unable to disconnect during configuration preparation"))
        }
    }
    onClicked: ConnectionController.connectButtonClicked()
}
