import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root

    property bool connected: false
    property bool busy: false
    property string progressText: "Подключение…"
    property string displayName: "вконтакте.ком"
    readonly property string statusText: busy ? progressText
                                             : connected ? "подключен как пользователь " + displayName
                                                         : "не подключен · " + displayName
    implicitWidth: 328
    implicitHeight: 320
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: 0
    Accessible.role: Accessible.CheckBox
    Accessible.name: busy ? progressText : connected ? "Отключить VPN" : "Подключить VPN"
    Accessible.description: statusText
    Accessible.checkable: true
    Accessible.checked: connected

    background: Item {}
    contentItem: Item {
        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: 40

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "LARP"
                color: "#F13755"
                font.family: "PT Root UI VF"
                font.pixelSize: 66
                font.weight: Font.Black
                font.letterSpacing: 1
            }

            Rectangle {
                id: track
                anchors.horizontalCenter: parent.horizontalCenter
                width: 110
                height: 60
                radius: height / 2
                color: root.connected ? (root.down ? "#D92C3C" : "#FF3B49")
                                      : (root.hovered ? "#545458" : "#414145")
                border.width: root.activeFocus ? 2 : 0
                border.color: "#FFFFFF"
                opacity: root.busy ? 0.65 : 1
                Behavior on color { ColorAnimation { duration: 160 } }

                Rectangle {
                    width: 54
                    height: 54
                    radius: 27
                    y: 3
                    x: root.connected ? track.width - width - 3 : 3
                    color: "#EEEEF0"
                    Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                }
                SequentialAnimation on opacity {
                    running: root.busy
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.5; to: 1; duration: 650 }
                    NumberAnimation { from: 1; to: 0.5; duration: 650 }
                    onStopped: track.opacity = 1
                }
            }

            Text {
                objectName: "connectionStatus"
                width: parent.width - 24
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.statusText
                textFormat: Text.PlainText
                color: root.connected ? "#EEEEF0" : "#A1A1A6"
                font.family: "PT Root UI VF"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
            }
        }
    }
    Keys.onEnterPressed: clicked()
    Keys.onReturnPressed: clicked()
}
