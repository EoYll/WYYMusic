import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import "./"
import AppState 1.0
Rectangle{
    id:leftRectange
    Row{
        id:mainTitle
        height:70
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        spacing: 15
        Rectangle{
            color:"white"
            width: 30
            height: 30
            radius: width/2
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id:mainIcon
                source: "qrc:/svg/Resources/title/WYYMusic.svg"
                sourceSize: "30x30"
                anchors.centerIn: parent
                RotationAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 2000
                    loops: Animation.Infinite
                }
            }
        }


        Text{
            text:"网易云音乐"
            color:"white"
            anchors.verticalCenter: parent.verticalCenter
            font.family: "华文行楷"
            font.pixelSize: 20
        }
    }
    Item{
        //第一部分
        anchors.top:mainTitle.bottom
        anchors.left: parent.left
        anchors.right:parent.right
        Component.onCompleted: {
            sift.clickedId.connect(buttonStateGroup.changeId)
            podcast.clickedId.connect(buttonStateGroup.changeId)
            follow.clickedId.connect(buttonStateGroup.changeId)
            favoriteMusic.clickedId.connect(buttonStateGroup.changeId)
            recently.clickedId.connect(buttonStateGroup.changeId)
            download.clickedId.connect(buttonStateGroup.changeId)
            localMusic.clickedId.connect(buttonStateGroup.changeId)

            localMusic.state ="SELECTED"
        }
        StateGroup{
            id:buttonStateGroup
            property string selectedId:"localMusic"
            function changeId(Id){
                selectedId =Id
            }

            states:[
                State {
                    name: "sift"
                    when: buttonStateGroup.selectedId === "sift"
                    PropertyChanges {target: sift;isSelected:true}
                    PropertyChanges {target: podcast;isSelected:false}
                    PropertyChanges {target: follow;isSelected:false}

                    PropertyChanges {target: favoriteMusic;isSelected:false}
                    PropertyChanges {target: recently;isSelected:false}
                    PropertyChanges {target: download;isSelected:false}
                    PropertyChanges {target: localMusic;isSelected:false}


                },
                State {
                    name: "podcast"
                    when: buttonStateGroup.selectedId === "podcast"
                    PropertyChanges {target: sift;isSelected:false}
                    PropertyChanges {target: podcast;isSelected:true}
                    PropertyChanges {target: follow;isSelected:false}

                    PropertyChanges {target: favoriteMusic;isSelected:false}
                    PropertyChanges {target: recently;isSelected:false}
                    PropertyChanges {target: download;isSelected:false}
                    PropertyChanges {target: localMusic;isSelected:false}
                },
                State {
                    name: "follow"
                    when: buttonStateGroup.selectedId === "follow"
                    PropertyChanges {target: sift;isSelected:false}
                    PropertyChanges {target: podcast;isSelected:false}
                    PropertyChanges {target: follow;isSelected:true}

                    PropertyChanges {target: favoriteMusic;isSelected:false}
                    PropertyChanges {target: recently;isSelected:false}
                    PropertyChanges {target: download;isSelected:false}
                    PropertyChanges {target: localMusic;isSelected:false}
                },
                State {
                    name: "favoriteMusic"
                    when: buttonStateGroup.selectedId === "favoriteMusic"
                    PropertyChanges {target: sift;isSelected:false}
                    PropertyChanges {target: podcast;isSelected:false}
                    PropertyChanges {target: follow;isSelected:false}

                    PropertyChanges {target: favoriteMusic;isSelected:true}
                    PropertyChanges {target: recently;isSelected:false}
                    PropertyChanges {target: download;isSelected:false}
                    PropertyChanges {target: localMusic;isSelected:false}
                },
                State {
                    name: "recently"
                    when: buttonStateGroup.selectedId === "recently"
                    PropertyChanges {target: sift;isSelected:false}
                    PropertyChanges {target: podcast;isSelected:false}
                    PropertyChanges {target: follow;isSelected:false}

                    PropertyChanges {target: favoriteMusic;isSelected:false}
                    PropertyChanges {target: recently;isSelected:true}
                    PropertyChanges {target: download;isSelected:false}
                    PropertyChanges {target: localMusic;isSelected:false}
                },
                State {
                    name: "download"
                    when: buttonStateGroup.selectedId === "download"
                    PropertyChanges {target: sift;isSelected:false}
                    PropertyChanges {target: podcast;isSelected:false}
                    PropertyChanges {target: follow;isSelected:false}

                    PropertyChanges {target: favoriteMusic;isSelected:false}
                    PropertyChanges {target: recently;isSelected:false}
                    PropertyChanges {target: download;isSelected:true}
                    PropertyChanges {target: localMusic;isSelected:false}
                },
                State {
                    name: "localMusic"
                    when: buttonStateGroup.selectedId === "localMusic"
                    PropertyChanges {target: sift;isSelected:false}
                    PropertyChanges {target: podcast;isSelected:false}
                    PropertyChanges {target: follow;isSelected:false}

                    PropertyChanges {target: favoriteMusic;isSelected:false}
                    PropertyChanges {target: recently;isSelected:false}
                    PropertyChanges {target: download;isSelected:false}
                    PropertyChanges {target: localMusic;isSelected:true}
                }
            ]
        }
        Column{
            id:filter
            anchors.top: parent.top
            anchors.topMargin: 18
            anchors.horizontalCenter:  parent.horizontalCenter
            spacing:4
            //精选
            FunctionButton{
                id:sift
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/music.svg"
                title:"精选"
                buttonId: "sift"
            }
            //播客
            FunctionButton{
                id:podcast
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/radio.svg"
                title:"播客"
                buttonId: "podcast"
            }
            //关注
            FunctionButton{
                id:follow
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/follow.svg"
                title:"关注"
                buttonId: "follow"
            }

        }
        //分割线
        Item{
            id:line1
            anchors.top:filter.bottom
            anchors.horizontalCenter:  parent.horizontalCenter
            width: 164
            height:36
            Rectangle{
                anchors.horizontalCenter:  parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "#27272e"
                width: 146
                height:1
            }
        }
        //第二部分
        Column{
            id:musicMenu
            anchors.top: line1.bottom
            //anchors.topMargin: 18
            anchors.horizontalCenter:  parent.horizontalCenter
            spacing:4
            //我喜欢的音乐
            FunctionButton{
                id:favoriteMusic
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/like.svg"
                title:"我喜欢的音乐"
                buttonId: "favoriteMusic"
            }
            //最近播放
            FunctionButton{
                id:recently
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/recently.svg"
                title:"最近播放"
                buttonId: "recently"
            }
            //下载管理
            FunctionButton{
                id:download
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/download.svg"
                title:"下载管理"
                buttonId: "download"
            }
            //本地音乐
            FunctionButton{
                id:localMusic
                anchors.horizontalCenter:  parent.horizontalCenter
                icon:"qrc:/svg/Resources/function/music.svg"
                title:"本地音乐"
                buttonId: "localMusic"
            }
        }
        //分割线
        Item{
            id:line2
            anchors.top:musicMenu.bottom
            anchors.horizontalCenter:  parent.horizontalCenter
            width: 164
            height:36
            Rectangle{
                anchors.horizontalCenter:  parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "#27272e"
                width: 146
                height:1
            }
        }
        //第三部分 创建的歌单
        //TODO

    }


}
