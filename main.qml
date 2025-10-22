import QtQuick 2.15
import "qrc:/Src/leftPage/"
import "qrc:/Src/playMusic/"
import "qrc:/Src/rightPage/"
import "qrc:/Src/"

MainWindow {
    id:window
    width:1056
    height: 752
    visible: true
    color:"#00000000"
    title: qsTr("Hello World")
    flags: Qt.FramelessWindowHint|Qt.Window
    //onVisibleChanged: if(visible)console.log(getNativeHandle(this))
    minimumWidth: 1056
    minimumHeight: 752
    Item{
        anchors {
            top:parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom

        }
        LeftPage{
            id:leftRectange
            width:204
            anchors.top:parent.top
            anchors.bottom: bottomRectange.top
            color:"#1a1a21"
        }
        RightPage{
            id:rightRectange
            anchors.top:parent.top
            anchors.bottom: bottomRectange.top
            anchors.left:leftRectange.right
            anchors.right: parent.right
            color:"#13131a"
            rootRef: window
        }
        PlayMusic{
            id:bottomRectange
            height:80
            anchors.left: parent.left
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            color:"#2d2d37"
        }
        LyricsPage{
            anchors.fill:parent

        }
    }






}
