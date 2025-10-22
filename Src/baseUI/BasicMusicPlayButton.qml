import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import MusicPlayer 1.0
import AppState
Item {
    id:rect
    property alias icon: image.source
    property alias iconSize: image.sourceSize
    property var musicModel
    property var musicMode:["ORDER","LIST","CIRCLE","RANDOM"]
    property string buttonType
    property bool isLiked: false
    Image {
        id: image
        source: ""
        sourceSize: "20x20"
        anchors.centerIn: parent
        ColorOverlay{
            id:imageColorOver
            source:image
            anchors.fill:source
            //color:imageMouseArea.containsMouse ? "#e6e6e6":"#d5d5d7"
            //opacity: imageMouseArea.containsMouse ? 1 : 0
            //Behavior on opacity {NumberAnimation{duration:200}}
        }
        MouseArea{
            id:imageMouseArea
            hoverEnabled: true
            anchors.fill: parent

            cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            onClicked:{
                switch(buttonType){
                    case "like":
                        console.log(image.source)
                        rect.isLiked =!rect.isLiked
                        if(rect.isLiked){
                            image.source = "qrc:/svg/Resources/playMusicFunc/aixin_selected.svg"
                        }else{
                            image.source = "qrc:/svg/Resources/playMusicFunc/aixin.svg"
                        }

                        console.log(image.source)
                        break;
                    case "before":
                        PlayerController.previous(rect.musicMode[AppState.playModeIndex%rect.musicMode.length])
                        break;
                    case "next":
                        PlayerController.next(rect.musicMode[AppState.playModeIndex%rect.musicMode.length])
                        // console.log(root.musicMode)
                        console.log(AppState.playModeIndex)
                        break;
                    case "mode":
                        if(rect.musicModel.length>0){
                            //console.log(musicModel.indexOf((root.index+1)%musicModel.length).toString())
                            AppState.playModeIndex = (AppState.playModeIndex+1)%rect.musicModel.length
                            image.source = rect.musicModel[AppState.playModeIndex]
                            console.log(AppState.playModeIndex)
                        }
                        break;
                    default:
                        break;

                }
            }
            onPressed: {
                image.scale =0.9

            }
            onReleased: {
                image.scale =1
            }
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
            when: imageMouseArea.containsMouse&&!imageMouseArea.pressed&&!rect.isLiked
            PropertyChanges {
                target: imageColorOver
                color:"#e6e6e6"
            }
        },
        //鼠标进入点击未释放
        State {
            name: "ONPRESSED"
            when: imageMouseArea.containsMouse&&imageMouseArea.pressed&&!rect.isLiked
            PropertyChanges {
                target: imageColorOver
                color:"#9c9ca0"
            }

        },
        //鼠标未进入未点击
        State {
            name: "NORMAL"
            when: !imageMouseArea.containsMouse&&!imageMouseArea.pressed&&!rect.isLiked
            PropertyChanges {
                target: imageColorOver
                color:"#d5d5d7"
            }
        },
        //鼠标点击未释放移出范围
        State {
            name: "ONPRESSEDOVERRANGE"
            when: !imageMouseArea.containsMouse&&imageMouseArea.pressed&&!rect.isLiked
            PropertyChanges {
                target: imageColorOver
                color:"#919197"
            }
        }

    ]

}
