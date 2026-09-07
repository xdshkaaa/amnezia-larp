import QtCore

Settings {
    category: "LarpProfile"
    property string displayName: "вконтакте.ком"

    function saveName(value) {
        displayName = value.trim().slice(0, 64) || "вконтакте.ком"
        sync()
    }
}
