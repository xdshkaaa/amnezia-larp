import QtQuick
import QtTest
import "../../client/ui/qml/Components"

TestCase {
    id: testCase
    name: "LarpConnection"
    when: windowShown
    visible: true
    FontLoader { source: "../../client/fonts/pt-root-ui_vf.ttf" }
    width: 400
    height: 400


    SignalSpy { id: clicks; signalName: "clicked" }

    function test_connectionUsesBackendState() {
        const factory = Qt.createComponent("../../client/ui/qml/Components/LarpConnectionControl.qml")
        compare(factory.status, Component.Ready, factory.errorString())
        const control = createTemporaryObject(factory, testCase, {width: 360, height: 320})
        verify(control !== null)
        clicks.target = control
        clicks.clear()
        compare(control.connected, false)
        mouseClick(control, control.width / 2, control.height / 2)
        compare(clicks.count, 1)
        compare(control.connected, false, "Click must not claim a successful VPN connection")
        verify(control.statusText.indexOf("не подключен") === 0)
        control.connected = true
        compare(control.Accessible.checked, true)
        verify(control.statusText.indexOf("подключен как пользователь") === 0)
        control.busy = true
        verify(control.statusText.length > 0)
        control.forceActiveFocus()
        keyClick(Qt.Key_Space)
        compare(clicks.count, 2)
    }
}
