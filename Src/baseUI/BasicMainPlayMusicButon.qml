import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import MusicPlayer 1.0
Rectangle {
    id:root

    radius: width / 2
    anchors.verticalCenter: parent.verticalCenter
    MouseArea{
        id:playMusicMouseArea
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
        onClicked:{
            //PlayerController.
            if(PlayerController.playing){
                PlayerController.pause()
            }else{
                PlayerController.play()
            }
        }
        onPressed: {
            //image.scale =0.9

        }
        onReleased: {
            //image.scale =1
        }
    }
    Image{
        id:image
        //anchors.fill: parent
        anchors.centerIn: parent
        source:PlayerController.playing?
                   "qrc:/svg/Resources/playMusicFunc/pausel.svg":"qrc:/svg/Resources/playMusicFunc/icon_play.svg"
        sourceSize: "20x20"
        ColorOverlay{
            id:imageColorOver
            source:image
            anchors.fill:source
            //color:imageMouseArea.containsMouse ? "#e6e6e6":"#d5d5d7"
            //opacity: imageMouseArea.containsMouse ? 1 : 0
            //Behavior on opacity {NumberAnimation{duration:200}}
        }
    }
    states: [
        //点击完成
        State {
            name: "ONCLICKED"
            PropertyChanges {
                target: imageColorOver
                color:"#fc3c4f"
            }

        },
        //鼠标进入未点击
        State {
            name: "ONMOUSEOVER"
            when: playMusicMouseArea.containsMouse&&!playMusicMouseArea.pressed
            PropertyChanges {
                target: imageColorOver
                color:"#e6e6e6"
                scale:1.05
            }
            PropertyChanges {
                target: root
                color:"#e33749"
                scale:1.05
            }
        },
        //鼠标进入点击未释放
        State {
            name: "ONPRESSED"
            when: playMusicMouseArea.containsMouse&&playMusicMouseArea.pressed
            PropertyChanges {
                target: imageColorOver
                color:"#9c9ca0"
                scale:0.95
            }
            PropertyChanges {
                target: root
                color:"#9a323e"
                scale:0.95
            }

        },
        //鼠标未进入未点击
        State {
            name: "NORMAL"
            when: !playMusicMouseArea.containsMouse&&!playMusicMouseArea.pressed
            PropertyChanges {
                target: imageColorOver
                color:"#ffffff"
                scale:1.0
            }
            PropertyChanges {
                target: root
                color:"#fc3c4e"
                scale:1.0
            }
        },
        //鼠标点击未释放移出范围
        State {
            name: "ONPRESSEDOVERRANGE"
            when: !playMusicMouseArea.containsMouse&&playMusicMouseArea.pressed
            PropertyChanges {
                target: imageColorOver
                color:"#ababaf"
                scale:0.95
            }
            PropertyChanges {
                target: root
                color:"#a93643"
                scale:0.95
            }
        }

    ]


}
