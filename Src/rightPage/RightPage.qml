import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls 2.15
import AppState 1.0
// import "../basic"
Rectangle{
    id:rightRectange
    property var rootRef
    TopTitle{
        id: statusBar
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.right:parent.right
        height:70
        rootRef2: rootRef
    }
    StackView{
        id:mainStackView
        anchors.top:statusBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        clip: true
        initialItem: "qrc:/Src/rightPage/StackPages/LocalMusicPage.qml"
        Component.onCompleted: {
            AppState.mainStackView = mainStackView
        }
    }
}
