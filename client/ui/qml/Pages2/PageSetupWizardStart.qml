import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import PageEnum 1.0
import Style 1.0

import "./"
import "../Controls2"
import "../Config"
import "../Controls2/TextTypes"
import "../Components"

PageType {
    id: root
    enableTimer: (SettingsController.isOnTv()) ? false : true

    ColumnLayout {
        id: content

        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Column {
                anchors.centerIn: parent
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "LARP"
                    color: "#F13755"
                    font.family: "PT Root UI VF"
                    font.pixelSize: 66
                    font.weight: Font.Black
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.application.displayName
                    color: AmneziaStyle.color.paleGray
                    font.family: "PT Root UI VF"
                    font.pixelSize: 18
                }
            }
        }

        BasicButtonType {
            id: startButton
            Layout.fillWidth: true
            Layout.bottomMargin: 48 + PageController.safeAreaBottomMargin
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.alignment: Qt.AlignBottom

            text: qsTr("Let's get started")

            clickedFunc: function() {
                PageController.goToPage(PageEnum.PageSetupWizardConfigSource)
            }
        }
    }

    Timer {
        interval: 250
        running: SettingsController.isOnTv()
        repeat: true
        onTriggered: {
            startButton.forceActiveFocus()
            if (startButton.activeFocus) {
                running = false
            }
        }
    }

    onVisibleChanged: {
        if (visible && SettingsController.isOnTv()) {
            startButton.forceActiveFocus()
        }
    }
}
