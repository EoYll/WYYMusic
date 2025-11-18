import QtQuick 2.15
import QtQuick.Controls.Basic 2.15
import Qt5Compat.GraphicalEffects
import "../baseUI"
import MusicPlayer 1.0
import AppState 1.0

Rectangle {
    id: lyricsPage
    color: "#202020"
    Behavior on y {
        enabled: AppState.lyricsPageAnimation
        NumberAnimation {

            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.bottomMargin: 5
        // onClicked: {
        //     parent.y = parent.height
        // }
    }

    Item {
        id: header
        //头部功能栏
        width: parent.width
        height: 80
        anchors.left: parent.left
        anchors.top: parent.top
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            anchors.rightMargin: 5
            onPressed: mouse => {
                           if (window.visibility !== Window.FullScreen) {
                               window.startSystemMove()
                           }
                       }
            onReleased: {
                if (window.visibility === Window.FullScreen) {
                    return
                }
                if (window.y <= 0) {
                    window.showMaximized()
                    AppState.windowIsMaximized = true
                } else {
                    AppState.windowIsMaximized = false
                }
            }
        }
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 40
            spacing: 20
            Rectangle {
                id: downRect
                color: downRectMouseArea.containsMouse ? "#2e2e2e" : "#272727"
                width: 40
                height: 40
                border.width: 1
                border.color: "#313131"
                radius: 8
                Image {
                    source: "qrc:/svg/Resources/status/xiangxia-1.svg"
                    sourceSize: "20x20"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: downRectMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        AppState.lyricsPageAnimation = true
                        AppState.lyricsPageVisible = false
                        AppState.lyricsPageAnimation = false
                    }
                }
                visible: !(window.visibility === Window.FullScreen)
            }
            Rectangle {
                id: fullRect
                color: fullRectMouseArea.containsMouse ? "#2e2e2e" : "#272727"
                width: 40
                height: 40
                border.width: 1
                border.color: "#313131"
                radius: 8
                Image {
                    source: window.visibility === Window.FullScreen ? "qrc:/svg/Resources/status/shouqi.svg" : "qrc:/svg/Resources/status/quanping.svg"
                    sourceSize: "20x20"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: fullRectMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        if (window.visibility === Window.FullScreen) {
                            window.showNormal()
                            AppState.windowIsMaximized = false
                        } else {
                            window.showFullScreen()
                        }
                    }
                }
            }
        }

        Rectangle {
            //播放器模式
            id: playerMode
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 40
            color: playerModeMouseArea.containsMouse ? "#2e2e2e" : "#272727"
            width: 120
            height: 40
            border.width: 1
            border.color: "#313131"
            radius: height / 2
            Row {
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: ""
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("播放器模式")
                    color: "#a6a6a6"
                    font.family: "微软雅黑"
                    font.pixelSize: 16
                }
            }

            MouseArea {
                id: playerModeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {

                }
            }
        }
    }
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: bottomRectange.top
        //封面+歌词
        Item {
            width: parent.width / 2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Rectangle {
                color: "white"
                width: 80
                height: 80
                anchors.centerIn: parent
            }
        }
        Item {

            width: parent.width / 2
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Item {
                id: message
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 20

                height: 70
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: qsTr(PlayerController.currentSong)
                    font.family: "微软雅黑"
                    font.pixelSize: 30
                    font.bold: true
                    color: "white"
                }
                Row{
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin:40
                    spacing: 20
                    Text {
                        text: qsTr("专辑：" + PlayerController.currentAlbum)
                        elide: Text.ElideRight
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        width: 160
                        color: "#8a8a8a"

                    }
                    Text {
                        text: qsTr("歌手：" + PlayerController.currentArtist )
                        elide: Text.ElideRight
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        width: 120
                        color: "#8a8a8a"

                    }
                    Text {
                        text: qsTr("来源：本地音乐")
                        elide: Text.ElideRight
                        font.family: "微软雅黑"
                        font.pixelSize: 15
                        width: 120
                        color: "#8a8a8a"

                    }
                }
            }
            ListView {
                id: lyricsView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: message.bottom
                anchors.bottom: parent.bottom
                anchors.rightMargin: 100
                clip: true
                model: PlayerController.lyricList
                currentIndex:PlayerController.lyricList.currentIndex
                header: Item {
                    width: lyricsView.width
                    height: lyricsView.height / 2 - 22 // 使得第一项可以滚动到中间
                }
                Timer {
                    id: lyricSyncTimer
                    interval: 200 // 调整为 200ms，减少频率
                    repeat: true
                    running: PlayerController.playing // 默认不运行，根据需要启动

                    onTriggered: {
                        // 添加空指针检查
                        if (PlayerController &&
                            PlayerController.lyricList &&
                            PlayerController.currentPosition !== undefined) {

                            PlayerController.lyricList.setPosition(PlayerController.currentPosition)
                        }
                    }
                }

                delegate: Rectangle {
                    // 委托：每个项目都是一个矩形
                    width: lyricsView.width // 宽度与ListView相同
                    height: 44 // 固定高度
                    color: "transparent"

                    property int opacityFunction: 1
                    // 根据选择的函数计算透明度
                    function calculateOpacity(distance, maxDistance) {

                        var normalizedDistance = distance / maxDistance;
                        switch(opacityFunction) {
                            case 0: // 线性
                                return Math.max(0.2, 1 - normalizedDistance);

                            case 1: // 二次方
                                return Math.max(0.2, 1 - normalizedDistance * normalizedDistance);

                            case 2: // 平方根
                                return Math.max(0.2, 1 - Math.sqrt(normalizedDistance));

                            case 3: // S形曲线
                                var t = normalizedDistance * 2 - 1;
                                var sCurve = 0.5 * (1 + Math.sin(Math.PI * (t - 0.5)));
                                return Math.max(0.2, 1 - sCurve);

                            default:
                                return Math.max(0.2, 1 - normalizedDistance);
                        }
                    }
                    // 计算该项中心点距离ListView中心的距离
                    property real distanceToCenter: {
                        var dummy = lyricsView.contentY;//显示更新
                        var itemCenterY = mapToItem(lyricsView, width/2, height/2).y;

                        return Math.abs(itemCenterY - lyricsView.height/2);
                    }

                    // 使用选择的函数计算透明度
                    //property real textOpacity:
                    Text {
                        id:lyricText
                        text: model.text// 显示文本和索引
                        wrapMode: Text.WordWrap  // 按单词换行
                        maximumLineCount: 2  // 最大显示2行
                        elide: Text.ElideRight  // 超出部分显示省略号
                        anchors.verticalCenter: parent.verticalCenter
                        color: index === lyricsView.currentIndex?"#ffffff": "#757575"
                        font.family: "微软雅黑"
                        font.pixelSize:index === lyricsView.currentIndex?22:17
                        opacity: calculateOpacity(distanceToCenter, lyricsView.height/2)
                        width: parent.width
                    }
                }
                footer: Item {
                    width: lyricsView.width
                    height: lyricsView.height / 2 - 22 // 使得最后一项可以滚动到中间
                }

                Component.onCompleted: {
                    // 初始位置：让第一项位于中间
                    lyricsView.contentY = -(lyricsView.height / 2 - 22)


                }
                // 使用Timer减少计算频率
                Timer {
                    id: updateTimer
                    interval: 50 // 50ms更新一次
                    repeat: false
                    onTriggered: lyricsView.updateCurrentItem()
                }
                //监听滚动位置变化，但使用Timer延迟计算
                // onContentYChanged: {
                //     if (!updateTimer.running&&!PlayerController.playing) {
                //         updateTimer.start()
                //     }
                //     //console.log(PlayerController.lyricList.currentIndex)
                //     //PlayerController.lyricList.setPosition(PlayerController.currentPosition)
                // }
                onCurrentIndexChanged: {
                    if (currentIndex >= 0&&currentIndex< lyricsView.count &&PlayerController.playing) {
                        contentY = currentIndex*44-(lyricsView.height / 2 - 22)
                    }
                }
                Behavior on contentY {
                    enabled:PlayerController.playing
                    NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
                }
                // 滚动结束时立即更新
                // onMovementEnded: {
                //     if(!PlayerController.playing){
                //         updateTimer.stop() // 停止计时器
                //         updateCurrentItem() // 立即更新
                //     }
                // }

                // ScrollBar.vertical: ScrollBar {
                //     policy: ScrollBar.AsNeeded
                // }

                // 函数：更新当前选中项
                // function updateCurrentItem() {
                //     var listCenterY = lyricsView.height / 2
                //     var minDistance = Number.MAX_VALUE
                //     var closestIndex = lyricsView.currentIndex
                //     // 默认保持当前选中
                //     // 只检查可见区域附近的项，提高性能
                //     var startIndex = Math.max(0, Math.floor(
                //                                   lyricsView.contentY / 44) - 2)
                //     var endIndex = Math.min(
                //                 lyricsView.count - 1, Math.ceil(
                //                     (lyricsView.contentY + lyricsView.height) / 44) + 2)

                //     for (var i = startIndex; i <= endIndex; i++) {
                //         var item = lyricsView.itemAt(lyricsView.width / 2,
                //                                    i * 44 + 22)
                //         // 获取项中心点
                //         if (item) {
                //             var itemCenterY = item.mapToItem(lyricsView, 0,
                //                                              item.height / 2).y
                //             var distance = Math.abs(itemCenterY - listCenterY)

                //             if (distance < minDistance) {
                //                 minDistance = distance
                //                 closestIndex = i
                //             }
                //         }
                //     }
                //     // 更新选中项
                //     if (closestIndex !== lyricsView.currentIndex) {
                //         lyricsView.currentIndex = closestIndex
                //         lyricsView.currentIndex = Qt.binding(()=>{
                //             return   PlayerController.lyricList.currentIndex;
                //         })
                //     }
                // }
            }
        }
    }

    Rectangle {
        id: bottomRectange
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 80
        color: "#161616"
        MouseArea {
            anchors.fill: parent
            anchors.rightMargin: 5
            // anchors.bottomMargin: 5
            onClicked: {

            }
            onReleased: {
                AppState.lyricsPageAnimation = true
                AppState.lyricsPageVisible = false
                AppState.lyricsPageAnimation = false
            }
        }
        Item {
            id: progressBar
            width: parent.width
            height:2
            anchors.top: parent.top
            property real currentTime: PlayerController.currentPosition // 当前播放时间（秒）
            property real totalTime: PlayerController.duration // 总时长（秒）
            // // 格式化时间（秒）为 mm:ss 格式
            // function formatTime(seconds) {
            //     seconds /= 1000
            //     var minutes = Math.floor(seconds / 60)
            //     var secs = Math.floor(seconds % 60)
            //     return minutes.toString().padStart(2,
            //                                        '0') + ":" + secs.toString(
            //                 ).padStart(2, '0')
            // }
            Slider {
                id: progressSlider
                anchors.verticalCenter: parent.verticalCenter
                //anchors.margins: 10
                width: parent.width
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
                        progressSlider.handle.visible = true
                    }
                    onExited: {
                        progressSlider.handle.visible = false
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
                    x: progressSlider.leftPadding
                    y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                    width: progressSlider.availableWidth
                    height: 4
                    radius: 2
                    color: "transparent"

                    Rectangle {
                        width: progressSlider.visualPosition * parent.width
                        height:sliderMouseArea.containsMouse? parent.height+2:parent.height
                        radius: 2
                        gradient: Gradient {
                                orientation: Gradient.Horizontal  // 水平渐变
                                GradientStop { position: 0.0; color: "#232323" }     // 左端黑色
                                GradientStop { position: 1.0; color: "#616161" }     // 右端白色
                            }
                    }
                }

                handle: Rectangle {
                    x: progressSlider.leftPadding + progressSlider.visualPosition
                       * progressSlider.availableWidth - width / 2
                    y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                    implicitWidth: 12
                    implicitHeight: 12
                    radius: 8
                    color: progressSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                    visible: false
                }
            }
        }
        Item {
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 30

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
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
                Row {
                    id: timeRow
                    anchors.verticalCenter: parent.verticalCenter
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
                        return minutes.toString().padStart(
                                    2, '0') + ":" + secs.toString(
                                    ).padStart(2, '0')
                    }

                    Text {
                        id: currentTimeText
                        //anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: timeRow.formatTime(timeRow.currentTime)
                        color: "#818187"
                    }
                    Text {

                        text: "/"
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#818187"
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
        }

        //中
        Item {
            height: parent.height
            anchors.centerIn: parent
            Row {
                id: playRow

                anchors.centerIn: parent

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
                        icon: musicModel[AppState.playModeIndex]
                        iconSize: "22x22"
                        musicModel: ["qrc:/svg/Resources/playMusicFunc/shunxubofang.svg", "qrc:/svg/Resources/playMusicFunc/liebiaoxunhuan.svg", "qrc:/svg/Resources/playMusicFunc/danquxunhuan.svg", "qrc:/svg/Resources/playMusicFunc/suijibofang.svg"]

                        buttonType: "mode"
                    }
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
                    id: volumeButton
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
                            if (volumeSlider.value !== 0) {
                                AppState.volume = volumeRect.volume
                                volumeRect.volume = 0
                                PlayerController.setCurrentVolume(0)
                            } else {
                                volumeRect.volume = AppState.volume
                                PlayerController.setCurrentVolume(
                                            volumeRect.volume)
                            }
                            volumeRect.volume = Qt.binding(() => {
                                                               return PlayerController.currentVolume
                                                           })
                        }

                        onEntered: {
                            //console.log("进入1")
                            timer1.stop()
                            isHovered = true
                        }
                        onExited: {
                            //console.log("退出1")
                            timer1.start()
                        }
                        Timer {
                            id: timer1
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
                            property bool isHovered: volumeSliderInnerMouseArea.isHovered
                                                     || volumeSliderMouseArea.isHovered

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
                                    id: timer2
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
                                id: volumeRect
                                color: "#34343e"
                                width: 38
                                height: 132
                                radius: 6
                                anchors.centerIn: parent
                                property real volume: PlayerController.currentVolume
                                Slider {
                                    id: volumeSlider
                                    orientation: Qt.Vertical
                                    anchors.centerIn: parent
                                    height: 90
                                    width: 30
                                    from: 0
                                    to: 100
                                    value: Math.round(
                                               PlayerController.currentVolume * 100)
                                    stepSize: 1
                                    //rotation: 180
                                    onValueChanged: {
                                        if (value === 0) {
                                            volumeButton.imgSource
                                                    = "qrc:/svg/Resources/playMusicFunc/jingyin.svg"
                                        } else if (value <= 33) {
                                            volumeButton.imgSource = "qrc:/svg/Resources/playMusicFunc/yinliangxiao.svg"
                                        } else if (value <= 67) {
                                            volumeButton.imgSource = "qrc:/svg/Resources/playMusicFunc/yinliangzhong.svg"
                                        } else if (value <= 100) {
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
                                            console.log(PlayerController.currentVolume)
                                        }
                                        onExited: {
                                            // console.log("退出3")
                                            timer3.start()
                                        }
                                        Timer {
                                            id: timer3
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
                                            volumeRect.volume = value / 100
                                        } else {
                                            volumeSliderInner.visible = Qt.binding(
                                                        () => {
                                                            return volumeMouseArea.containsMouse
                                                            || volumeSliderInner.isHovered
                                                        })
                                            volumeRect.volume = Qt.binding(
                                                        () => {
                                                            return PlayerController.currentVolume
                                                        })
                                        }
                                    }
                                    onMoved: {
                                        PlayerController.setCurrentVolume(
                                                    volumeSlider.value / 100)
                                    }
                                }
                                Text {
                                    id: volumeSliderNumber
                                    text: qsTr(volumeSlider.value + "%")
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
}
