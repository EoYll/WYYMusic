import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic 2.15
import AppState 1.0
Item{
    property var rootRef2

    MouseArea{
        anchors.fill: parent
        propagateComposedEvents: true
        anchors.rightMargin: 5
        onPressed: (mouse)=>{
            window.startSystemMove()
        }
        onReleased: {
            if(window.y<=0){
                window.showMaximized()
                AppState.windowIsMaximized = true

            }else{
                AppState.windowIsMaximized = false
            }
        }
    }


    id: statusBar
    //靠左
    Row{
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left
        anchors.leftMargin:40
        spacing: 10
        //回退
        Rectangle{
            id:rollback
            width:28
            height:34
            radius: 6
            color:rollbackMouseArea.containsMouse? "#2b2b31":"transparent"
            border.color: rollbackMouseArea.containsMouse?"#404046":"#2b2b31"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter

            MouseArea{
                id:rollbackMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
                onClicked: {
                    AppState.mainStackView.pop()
                    console.log(AppState.mainStackView)
                }
            }
            Image {
                id: rollbackImg
                anchors.centerIn: parent
                source: "qrc:/svg/Resources/title/huitui.svg"
                sourceSize:"16x16"
            }
        }
        //搜索框34*34
        Rectangle{
            id:search
            width:258
            height:34
            radius: 6
            color:"transparent"
            // color:searchMouseArea.containsMouse? "#2b2b31":"transparent"
            // border.color: searchMouseArea.containsMouse?"#404046":"#2b2b31"
            border.color: "#2b2b31"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter

            //搜索按钮
            Image {
                id: searchImg
                anchors.left: parent.left
                anchors.margins: 16
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/svg/Resources/title/search.svg"
                sourceSize:"25x25"
                MouseArea{
                    id:searchMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
                }
                ColorOverlay{
                    source:searchImg
                    anchors.fill:source
                    color:searchMouseArea.containsMouse ? "white":"#a1a1a3"
                    opacity: searchMouseArea.containsMouse ? 1 : 0
                    Behavior on opacity {NumberAnimation{duration:200}}
                }
            }
            //搜索文本框
            TextField{

                id:textField
                anchors.left: searchImg.right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color:"#717176"
                height: 34
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                background:Rectangle{
                    anchors.fill: parent
                    color:"transparent"
                }

            }

        }
        //听歌识曲
        Rectangle{
            id:listenMusic
            width:34
            height:34
            radius: 6
            color:listenMusicMouseArea.containsMouse? "#2b2b31":"transparent"
            border.color: listenMusicMouseArea.containsMouse?"#404046":"#2b2b31"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter

            MouseArea{
                id:listenMusicMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor

            }
            Image {
                id: listenMusicImg
                anchors.centerIn: parent
                source: "qrc:/svg/Resources/title/maikefeng.svg"
                sourceSize:"16x16"
            }
        }
    }

    //靠右
    Row{

        anchors.verticalCenter: parent.verticalCenter
        anchors.right:parent.right
        anchors.rightMargin:40
        spacing: 16

        //头像
        Rectangle{
            id:userIconRect
            width:30
            height:30
            radius: width/2
            color:"#212127"
              anchors.verticalCenter: parent.verticalCenter
            Image {
                id: userIcon
                anchors.centerIn: parent
                source: "qrc:/svg/Resources/title/touxiang.svg"
                sourceSize:"25x25"
            }
        }
        //未登录
        Item{
            anchors.verticalCenter: parent.verticalCenter
            width:50
            height: 20

            Text{
                id:loadStateText
                text: "未登录"
                color: "#75777f"
                font.pixelSize: 14
                font.family: "微软雅黑 Light"

            }
        }
        //vip

        //向下展开

        Image{
            id:downExpand
            source: "qrc:/svg/Resources/title/zhankai.svg"
            sourceSize: "20x20"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:downExpandMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            }

            ColorOverlay{
                source:downExpand
                anchors.fill:source
                color:downExpandMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: downExpandMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }
        }

        //消息
        Image{
            id:message
            source: "qrc:/svg/Resources/title/youjian.svg"
            sourceSize: "20x20"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:messageMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            }

            ColorOverlay{
                source:message
                anchors.fill:source
                color:messageMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: messageMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }
        }

        //设置
        Image{
            id:setting
            source: "qrc:/svg/Resources/title/settings.svg"
            sourceSize: "20x20"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:settingMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
                onClicked: {
                    if(AppState.mainStackView.currentItem.pageUrl!=="qrc:/Src/rightPage/StackPages/Settings.qml"){
                        AppState.mainStackView.push("qrc:/Src/rightPage/StackPages/Settings.qml")
                    }

                }
            }

            ColorOverlay{
                source:setting
                anchors.fill:source
                color:settingMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: settingMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }
        }
        //皮肤
        Image{
            id:skin
            source: "qrc:/svg/Resources/title/a-021_pifu.svg"
            sourceSize: "20x20"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:skinMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            }

            ColorOverlay{
                source:skin
                anchors.fill:source
                color:skinMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: skinMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }
        }


        //竖线
        Rectangle{
            height:16
            width:1
            anchors.verticalCenter: parent.verticalCenter
            color:"#2b2b31"
        }

        //精简模式
        Image {
            id: streamlineImg
            source: "qrc:/svg/Resources/status/streamline_a.svg"
            sourceSize: "14x14"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:streamlineImgMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            }
            ColorOverlay{
                source:streamlineImg
                anchors.fill:source
                color:streamlineImgMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: streamlineImgMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }

        }
        //最小化
        Image {
            id: minimizeImg
            source: "qrc:/svg/Resources/status/minimize_a.svg"
            sourceSize: "16x16"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:minimizeImgMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    window.showMinimized()
                }
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            }
            ColorOverlay{
                source:minimizeImg
                anchors.fill:source
                color:minimizeImgMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: minimizeImgMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }

        }
        //最大化
        Image {
            id: maximizeImg
            source: AppState.windowIsMaximized?"qrc:/svg/Resources/status/restoredown_a.svg":"qrc:/svg/Resources/status/maximize_a.svg"
            sourceSize: "16x16"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea{
                id:maximizeImgMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor


                onClicked: {
                    if(AppState.windowIsMaximized){
                        //maximizeImg.source="qrc:/svg/Resources/status/maximize_a.svg"
                        window.showNormal()
                        //window.isMaximized = false
                        AppState.windowIsMaximized = false
                    }else{
                        //maximizeImg.source="qrc:/svg/Resources/status/restoredown_a.svg"
                        window.showMaximized()
                        console.log(window.visibility === window.Maximized)
                        //window.isMaximized = true
                        AppState.windowIsMaximized =true
                    }
                }
            }
            ColorOverlay{
                source:maximizeImg
                anchors.fill:source
                color:maximizeImgMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: maximizeImgMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }

        }
        //关闭
        Image {
            id: closeImg
            source: "qrc:/svg/Resources/status/close_a.svg"
            sourceSize: "14x14"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                id:closeImgMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    window.close()
                }
                cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
            }
            ColorOverlay{
                source:closeImg
                anchors.fill:source
                color:closeImgMouseArea.containsMouse ? "white":"#a1a1a3"
                opacity: closeImgMouseArea.containsMouse ? 1 : 0
                Behavior on opacity {NumberAnimation{duration:200}}
            }
        }

    }

}
