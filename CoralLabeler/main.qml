import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Two Overlaid Images")

    Image {
        id: cover
        source: "test_images/rosvol2-cover.jpg"
        width: 500
        height: 500
        smooth: true
        visible: false
    }

    Image {
        id: overlay
        source: "test_images/rosvol2-overlay.png"
        width: 500
        height: 500
        smooth: true
        visible: false
    }

    Blend {
        anchors.fill: cover
        source: cover
        foregroundSource: overlay
        mode: "average"
    }
}
