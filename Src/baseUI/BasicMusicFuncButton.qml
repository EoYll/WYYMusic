import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import MusicPlayer 1.0
Item {
    id:rect
    property alias imgSource: image.source
    width: 30
    height: 30
    Image {
        id: image
        source: ""
        sourceSize: "22x22"
        anchors.centerIn: parent
        ColorOverlay{
            source:image
            anchors.fill: source
            color: "#ababaf"
        }
    }
}
