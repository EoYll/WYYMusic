import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import MusicPlayer 1.0
Rectangle{
    id:rect
    height: 56
    radius:10
    color:outerHovered?"#202027":"#13131a"
    property var headerList
    property string rectTitle
    property string rectArtist
    property string rectAlbum
    property string rectDuration
    property string rectSize
    property int musicIndex
    property int musicCurrentIndex
    property bool outerHovered: rectMouseArea.containsMouse||playIconMouseArea.containsMouse||musicCurrentIndex === musicIndex
    signal indexSet(int rectIndex)
    function padStart(num,length = 2,cha ='0'){
        return num.toString().padStart(length,cha)
    }

    MouseArea{
        id:rectMouseArea
        hoverEnabled: true
        anchors.fill: parent
        //propagateComposedEvents:true
    }
    Item{
        //播放按钮
        width: headerList[0].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[0].x
        Item{
            anchors.centerIn: parent
            height: 20
            width: 20
            Image {
                id: playIcon
                source: rect.musicCurrentIndex ===rect.musicIndex && PlayerController.playing?
                            "qrc:/svg/Resources/playMusicFunc/pausel.svg":"qrc:/svg/Resources/playMusicFunc/icon_play.svg"
                sourceSize: "20x20"
                opacity:outerHovered?1:0
                anchors.centerIn: parent
                visible:!(rect.musicCurrentIndex ===rect.musicIndex && PlayerController.playing &&!playIconMouseArea.containsMouse)||playIconMouseArea.containsMouse
                ColorOverlay{
                    id:imageColorOver
                    source:playIcon
                    anchors.fill:source
                    color:playIconMouseArea.containsMouse?"#d1d1d2":"#a6a6a8"
                    opacity: 1
                    //Behavior on opacity {NumberAnimation{duration:200}}
                }

            }
            MouseArea{
                id:playIconMouseArea
                hoverEnabled: true
                anchors.fill: parent
                //propagateComposedEvents:true
                // onHoveredChanged: (mouse)=>{
                //     mouse.accepted = false
                // }
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
                onClicked: {
                    //PlayerController.
                    if(PlayerController.playing && musicCurrentIndex === musicIndex){
                        PlayerController.pause()
                    }else{
                        PlayerController.playSong(rect.musicIndex)

                        console.log("播放")
                        console.log(rect.musicIndex)
                    }
                }

            }
        }

    }
    Item{
        //动态音波
        width: headerList[0].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[0].x
        visible: rect.musicCurrentIndex ===rect.musicIndex && PlayerController.playing &&!playIconMouseArea.containsMouse
        Row{
            spacing: 4
            anchors.centerIn: parent
            height: 16

            Rectangle{
                id:rect1
                height: 4
                width: 2
                color: "#d23233"
                anchors.bottom: parent.bottom
                SequentialAnimation on height{
                    loops:Animation.Infinite
                    NumberAnimation {
                        from:4
                        to:16
                        easing.type: Easing.Linear
                        duration: 300
                    }

                    PauseAnimation {
                        duration: 200
                    }
                    NumberAnimation {
                        from:16
                        to:4
                        easing.type: Easing.Linear
                        duration: 300
                    }
                    PauseAnimation {
                        duration: 200
                    }
                }


            }
            Rectangle{
                id:rect2
                color: "#d23233"
                height: 4
                width: 2
                anchors.bottom: parent.bottom
                SequentialAnimation on height{
                    loops:Animation.Infinite
                    NumberAnimation {
                        from:4
                        to:16

                        easing.type: Easing.Linear
                        duration: 500
                    }

                    PauseAnimation {
                        duration: 200
                    }
                    NumberAnimation {
                        from:16
                        to:4
                        easing.type: Easing.Linear
                        duration: 500
                    }
                    PauseAnimation {
                        duration: 200
                    }
                }
            }
            Rectangle{
                id:rect3
                color: "#d23233"
                height: 4
                width: 2
                anchors.bottom: parent.bottom
                SequentialAnimation on height{
                    loops:Animation.Infinite
                    NumberAnimation {
                        from:16
                        to:4
                        easing.type: Easing.Linear
                        duration: 400
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    NumberAnimation {
                        from:4
                        to:16

                        easing.type: Easing.Linear
                        duration: 400
                    }
                    PauseAnimation {
                        duration: 200
                    }
                }
            }

        }


    }

    Item{
        //数字
        width: headerList[0].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[0].x
        Text {
            id: number
            text: qsTr(rect.padStart(musicIndex+1))
            anchors.centerIn: parent
            color: "#a0a0a3"
            font.pixelSize: 13
            font.family: "微软雅黑"
            visible:outerHovered?false:true
            font.bold: true
            // anchors.verticalCenter: parent.verticalCenter
        }
    }
    Item{
        //表标题
        width: headerList[1].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[1].x
        // Rectangle{
        //     color: "white"
        //     anchors.fill: parent
        // }

        Item{
            //anchors.verticalCenter: parent.verticalCenter
            //anchors.top: parent.top
            height: parent.height
            anchors{
                left: parent.left
                top:parent.top
                bottom: parent.bottom
                topMargin: 9
                bottomMargin: 9

            }
            width: parent.width

            Text{
                color: rect.musicCurrentIndex ===rect.musicIndex?"#ff3a3a":"white"
                text: rect.rectTitle
                font.pixelSize: 14
                font.family: "微软雅黑"
                anchors.top: parent.top
                //anchors.topMargin: 5
                //anchors.centerIn: parent
                leftPadding: 10
            }
            Text{
                color:rect.musicCurrentIndex ===rect.musicIndex? "#ff3a3a":"#89898d"
                text: rect.rectArtist
                font.pixelSize: 13
                font.family: "微软雅黑"

                anchors.bottom:parent.bottom
                //anchors.centerIn: parent
                leftPadding: 10
            }
            clip:true
        }



        Item{
            // 按钮
        }
    }
    Item{
        //专辑
        width: headerList[2].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[2].x
        clip:true
        Text{
            color: "#cfcfd1"
            text: rect.rectAlbum
            font.pixelSize: 14
            font.family: "微软雅黑"
            anchors.verticalCenter:parent.verticalCenter
            leftPadding: 10
        }

    }
    Item{
        //时长
        width: headerList[3].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[3].x
        clip:true
        Text{
            color: "#8f8f93"
            text: rect.rectDuration
            font.pixelSize: 14
            font.family: "微软雅黑"
            anchors.verticalCenter:parent.verticalCenter
            leftPadding: 10
        }
    }
    Item{
        //大小
        width: headerList[4].width
        height: parent.height
        anchors.top: parent.top
        x:headerList[4].x
        clip:true
        Text{
            color: "#8f8f93"
            text: rect.rectSize
            font.pixelSize: 14
            font.family: "微软雅黑"
            anchors.verticalCenter:parent.verticalCenter
            leftPadding: 10
        }
    }



}
