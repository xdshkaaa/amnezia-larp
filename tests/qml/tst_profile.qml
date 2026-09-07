import QtQuick
import QtTest

TestCase {
    name: "LarpProfile"
    function test_savesAndReloadsName() {
        const factory = Qt.createComponent("../../client/ui/qml/Modules/Larp/ProfileStore.qml")
        compare(factory.status, Component.Ready, factory.errorString())
        const url = "file:///tmp/larpmnezia-profile-test-" + Date.now() + ".ini"
        let store = factory.createObject(null, {location: url})
        compare(store.displayName, "вконтакте.ком")
        store.saveName("  Тестовый пользователь  ")
        compare(store.displayName, "Тестовый пользователь")
        store.sync()
        store.destroy()
        wait(1)
        store = factory.createObject(null, {location: url})
        compare(store.displayName, "Тестовый пользователь")
        store.saveName("  ")
        compare(store.displayName, "вконтакте.ком")
        store.saveName("x".repeat(100))
        compare(store.displayName.length, 64)
        store.destroy()
    }
}
