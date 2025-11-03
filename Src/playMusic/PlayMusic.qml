import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic 2.15
import "../baseUI"
import MusicPlayer 1.0
import AppState 1.0
Rectangle {
    id: bottomRectange
    property var lyrics
    //左
    MouseArea{
        anchors.fill: parent
        anchors.rightMargin: 5
        onPressed: {
            console.log("PlayMusic onPressed")
        }

        onClicked: {
            console.log("PlayMusic onclicked")

        }
        onReleased: {
            console.log("PlayMusic onReleased")
            AppState.lyricsPageAnimation =true
            AppState.lyricsPageVisible = true
            AppState.lyricsPageAnimation =false
        }

    }

    Item {
        height: parent.height
        anchors.left: parent.left

        Rectangle {
            id: imageRect
            width: 60
            height: 60
            radius: width / 2
            color: "black"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            property int currentIndex: PlayerController.currentIndex

            onCurrentIndexChanged: {
                innerRect.color = generateRandomColor().color
            }

            Rectangle {
                id: innerRect
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: width / 2
                color: "red"
            }
            // Component.onCompleted: {
            //     console.log(PlayerController.setCover())
            // }

            // 生成随机颜色的函数
            function generateRandomColor() {
                // 常见颜色名称
                var colorNames = ["红色", "橙色", "黄色", "绿色", "蓝色", "靛蓝", "紫色", "粉色", "棕色", "灰色"]

                // 生成RGB值
                var r = Math.floor(Math.random() * 256)
                var g = Math.floor(Math.random() * 256)
                var b = Math.floor(Math.random() * 256)

                // 创建颜色对象
                var colorObj = Qt.rgba(r / 255, g / 255, b / 255, 1)

                // 返回颜色对象和名称
                return {
                    "color": colorObj,
                    "name": colorNames[Math.floor(Math.random(
                                                      ) * colorNames.length)]
                }
            }
        }

        Row {
            anchors.top: imageRect.top
            anchors.left: imageRect.right
            anchors.leftMargin: 5
            spacing: 1
            Text {
                text: qsTr(PlayerController.currentSong)
                font.family: "微软雅黑"
                font.pixelSize: 16
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
            }

            Text {
                text: qsTr(" - " + PlayerController.currentArtist)
                font.family: "微软雅黑"
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
                color: "#ababaf"
            }
        }
        Row {
            anchors.bottom: imageRect.bottom
            anchors.left: imageRect.right
            anchors.leftMargin: 5
            spacing: 15
            BasicMusicFuncButton {
                imgSource: "qrc:/svg/Resources/playMusicFunc/shangchuangedan.svg"
                anchors.verticalCenter: parent.verticalCenter
            }
            BasicMusicFuncButton {
                imgSource: "qrc:/svg/Resources/playMusicFunc/xinxi.svg"
                anchors.verticalCenter: parent.verticalCenter
            }
            BasicMusicFuncButton {
                imgSource: "qrc:/svg/Resources/playMusicFunc/fenxiang.svg"
                anchors.verticalCenter: parent.verticalCenter
            }
            BasicMusicFuncButton {
                imgSource: "qrc:/svg/Resources/playMusicFunc/xiazai.svg"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    //中
    Item {
        height: parent.height
        anchors.centerIn: parent
        Row {
            id: playRow
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
            spacing: 15
            //喜欢
            Rectangle {
                width: 30
                height: 30
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                BasicMusicPlayButton {
                    anchors.centerIn: parent
                    icon: "qrc:/svg/Resources/playMusicFunc/aixin.svg"
                    iconSize: "22x22"
                    buttonType: "like"
                }
            }
            //前一首
            Rectangle {
                width: 30
                height: 30
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                BasicMusicPlayButton {
                    anchors.centerIn: parent
                    icon: "qrc:/svg/Resources/playMusicFunc/qianyishou.svg"
                    iconSize: "16x16"
                    buttonType: "before"
                }
            }
            //播放按钮
            BasicMainPlayMusicButon {
                width: 40
                height: 40
                color: "#fc3c52"
            }
            //后一首
            Rectangle {
                width: 30
                height: 30
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                BasicMusicPlayButton {
                    anchors.centerIn: parent
                    icon: "qrc:/svg/Resources/playMusicFunc/houyishou.svg"
                    iconSize: "16x16"
                    buttonType: "next"
                }
            }
            //播放模式
            Rectangle {
                width: 30
                height: 30
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                BasicMusicPlayButton {
                    anchors.centerIn: parent
                    icon: "qrc:/svg/Resources/playMusicFunc/shunxubofang.svg"
                    iconSize: "22x22"
                    musicModel: ["qrc:/svg/Resources/playMusicFunc/shunxubofang.svg", "qrc:/svg/Resources/playMusicFunc/liebiaoxunhuan.svg", "qrc:/svg/Resources/playMusicFunc/danquxunhuan.svg", "qrc:/svg/Resources/playMusicFunc/suijibofang.svg"]

                    buttonType: "mode"
                }
            }
        }
        Row {
            id: timeRow
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            width: implicitWidth
            height: 20
            spacing: 2
            property real currentTime: PlayerController.currentPosition // 当前播放时间（秒）
            property real totalTime: PlayerController.duration // 总时长（秒）
            // 格式化时间（秒）为 mm:ss 格式
            function formatTime(seconds) {
                seconds /= 1000
                var minutes = Math.floor(seconds / 60)
                var secs = Math.floor(seconds % 60)
                return minutes.toString().padStart(2,
                                                   '0') + ":" + secs.toString(
                            ).padStart(2, '0')
            }

            Text {
                id: currentTimeText
                //anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: timeRow.formatTime(timeRow.currentTime)
                color: "#818187"
            }

            // 进度条
            Slider {
                id: progressBar
                //anchors.left: currentTimeText.right
                //anchors.right: totalTimeText.left
                anchors.verticalCenter: parent.verticalCenter
                //anchors.margins: 10
                width: 308
                from: 0
                to: timeRow.totalTime
                value: timeRow.currentTime
                MouseArea {
                    id: sliderMouseArea
                    anchors.fill: parent
                    hoverEnabled: true // 启用悬停检测
                    acceptedButtons: Qt.NoButton // 不处理按钮事件，只用于悬停检测
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    // 鼠标进入时显示手柄
                    onEntered: {
                        progressBar.handle.visible = true
                    }
                    // onPressed: {
                    //     //timeRow.currentTime = progressBar.value
                    // }
                    // onReleased: {

                    //     PlayerController.setCurrentPosition(progressBar.value)
                    //     timeRow.currentTime = Qt.binding(()=>{
                    //         return PlayerController.currentPosition
                    //     })
                    //     console.log("666")
                    // }
                    // 鼠标移出时启动隐藏计时器
                    onExited: {
                        progressBar.handle.visible = false
                    }
                }

                onPressedChanged: {
                    if (pressed) {
                        timeRow.currentTime = value
                    } else {
                        PlayerController.setCurrentPosition(value)
                        timeRow.currentTime = Qt.binding(() => {
                                                             return PlayerController.currentPosition
                                                         })
                    }
                }

                // 自定义样式（可选）
                background: Rectangle {
                    x: progressBar.leftPadding
                    y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                    width: progressBar.availableWidth
                    height: 4
                    radius: 2
                    color: "#4d4d57"

                    Rectangle {
                        width: progressBar.visualPosition * parent.width
                        height: parent.height
                        color: "#c7414e"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: progressBar.leftPadding + progressBar.visualPosition
                       * progressBar.availableWidth - width / 2
                    y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                    implicitWidth: 12
                    implicitHeight: 12
                    radius: 8
                    color: progressBar.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                    visible: false
                }
            }

            // 总时长显示
            Text {
                id: totalTimeText
                //anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: timeRow.formatTime(timeRow.totalTime)
                color: "#818187"
            }
        }
    }
    //右
    Item {
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 36
        Row {
            layoutDirection: Qt.RightToLeft
            anchors.right: parent.right
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter
            BasicMusicFuncButton {
                imgSource: "qrc:/svg/Resources/playMusicFunc/liebiao.svg"
                anchors.verticalCenter: parent.verticalCenter
            }
            BasicMusicFuncButton {
                id:volumeButton
                imgSource: "qrc:/svg/Resources/playMusicFunc/yinliangzhong.svg"
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    id: volumeMouseArea
                    property bool isHovered: false
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    property int volume: volumeSlider.value
                    onClicked: {
                        if(volumeSlider.value!==0){
                            volume = volumeSlider.value
                            volumeSlider.value = 0
                            PlayerController.setVolume(volumeSlider.value)
                        }else{
                            volumeSlider.value = volume
                            PlayerController.setVolume(volumeSlider.value)
                        }
                    }

                    onEntered: {
                        //console.log("进入1")
                        timer1.stop()
                        isHovered =true

                    }
                    onExited: {
                        //console.log("退出1")
                        timer1.start()

                    }
                    Timer {
                        id:timer1
                        interval: 300 // .0.3秒
                        repeat: false
                        onTriggered: volumeMouseArea.isHovered = false
                    }
                }

                Item {
                    id: volumeSliderBackground
                    anchors.bottom: parent.top
                    width: 40
                    height: 140
                    anchors.horizontalCenter: parent.horizontalCenter

                    //opacity: volumeMouseArea.containsMouse||volumeSliderMouseArea.containsMouse?1:0
                    Item {
                        id: volumeSliderInner
                        property bool isHovered: volumeSliderInnerMouseArea.isHovered||volumeSliderMouseArea.isHovered

                        anchors.fill: parent
                        visible: volumeMouseArea.containsMouse || isHovered
                        MouseArea {
                            id: volumeSliderInnerMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            property bool isHovered: false
                            onEntered: {
                                //console.log("进入2")
                                timer2.stop()
                                isHovered = true
                            }
                            onExited: {
                                //console.log("退出2")

                                timer2.start()
                            }
                            Timer {
                                id:timer2
                                interval: 300 // .0.3秒
                                repeat: false
                                onTriggered: volumeSliderInnerMouseArea.isHovered = false
                            }
                        }
                        Rectangle {
                            color: "#34343e"
                            radius: 6
                            width: 25
                            height: 25
                            rotation: 45
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                        }
                        Rectangle {
                            color: "#34343e"
                            width: 38
                            height: 132
                            radius: 6
                            anchors.centerIn: parent
                            Slider {
                                id: volumeSlider
                                orientation: Qt.Vertical
                                anchors.centerIn: parent
                                height: 90
                                width:30
                                from: 0
                                to: 100
                                value: PlayerController.currentVolume*100
                                stepSize: 1
                                //rotation: 180
                                onValueChanged: {
                                    if(value===0){
                                        volumeButton.imgSource = "qrc:/svg/Resources/playMusicFunc/jingyin.svg"
                                    }else if(value <=33){
                                        volumeButton.imgSource = "qrc:/svg/Resources/playMusicFunc/yinliangxiao.svg"
                                    }else if(value<=67){
                                        volumeButton.imgSource = "qrc:/svg/Resources/playMusicFunc/yinliangzhong.svg"
                                    }else if(value<=100){
                                        volumeButton.imgSource = "qrc:/svg/Resources/playMusicFunc/yinliangda.svg"
                                    }
                                }

                                MouseArea {
                                    id: volumeSliderMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    acceptedButtons: Qt.NoButton // 不处理按钮事件，只用于悬停检测
                                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    property bool isHovered: false
                                    onEntered: {
                                       // console.log("进入3")
                                        timer1.stop()
                                        isHovered = true
                                    }
                                    onExited: {
                                       // console.log("退出3")
                                        timer3.start()

                                    }
                                    Timer {
                                        id:timer3
                                        interval: 300 // .0.3秒
                                        repeat: false
                                        onTriggered: volumeSliderMouseArea.isHovered = false

                                    }
                                }
                                background: Rectangle {
                                    x: volumeSlider.leftPadding
                                       + volumeSlider.availableWidth / 2 - width / 2
                                    y: volumeSlider.bottomPadding
                                    width: 6
                                    height: volumeSlider.availableHeight
                                    radius: 3
                                    color: "#fc3d49"
                                    Rectangle {
                                        width: parent.width
                                        height: volumeSlider.visualPosition * parent.height
                                        color: "#494952"
                                        radius: 4
                                    }
                                }
                                handle: Rectangle {
                                    x: volumeSlider.leftPadding
                                       + volumeSlider.availableWidth / 2 - width / 2
                                    y: volumeSlider.bottomPadding + volumeSlider.visualPosition
                                       * volumeSlider.availableHeight - height / 2
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    radius: 8
                                    color: volumeSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                                    border.color: "#bdbebf"
                                }
                                onPressedChanged: {
                                    if (pressed) {
                                        volumeSliderInner.visible = true
                                    } else {
                                        volumeSliderInner.visible = Qt.binding(
                                        () => {
                                            return  volumeMouseArea.containsMouse || volumeSliderInner.isHovered
                                        })
                                    }
                                }
                                onMoved: {
                                    PlayerController.setVolume(volumeSlider.value/100)
                                }
                            }
                            Text {
                                id: volumeSliderNumber
                                text: qsTr(volumeSlider.value+"%")
                                color: "white"
                                font.family: "微软雅黑"
                                font.pixelSize: 10
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 5
                            }
                        }
                    }
                }
            }
        }
    }
}
