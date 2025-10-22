import QtQuick 2.15
import QtQuick.Controls.Basic 2.15
import Qt5Compat.GraphicalEffects
import "../../baseUI"
import MusicPlayer 1.0
import QtQuick.Dialogs

Item {
    property string pageUrl: "qrc:/Src/rightPage/StackPages/LocalMusicPage.qml"
    Item {
        anchors {
            fill: parent
            leftMargin: 40
            topMargin: 20
            rightMargin: 30
        }
        FolderDialog {
            id: folderDialog
            title: "请选择音乐目录"
            // currentFolder: StandardPaths.standardLocations(
            //                    StandardPaths.MusicLocation)[0]

            onAccepted: {
                PlayerController.setDirectory(selectedFolder,1)
                console.log(selectedFolder)
            }
        }
        Component.onCompleted: {

            PlayerController.setDirectory("file:///C:/Users/Eoyll/Music",0)
        }

        //标题加按钮
        Item {
            id: header
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            implicitHeight: 100
            Label {
                id: localMusicMainTitle
                text: "本地音乐"
                color: "#ffffff"
                font.family: "微软雅黑"
                font.pixelSize: 24
                font.bold: true
            }
            Text {
                id: musicCount
                anchors.left: localMusicMainTitle.right
                anchors.leftMargin: 6
                anchors.bottom: localMusicMainTitle.bottom
                text: qsTr("共 "+musicListView.count+" 首")
                font.pixelSize: 13
                font.family: "微软雅黑"
                color: "#717175"
            }
            Text {
                id: chooseDir
                anchors.bottom: localMusicMainTitle.bottom
                anchors.right: parent.right
                text: qsTr("选择目录>")
                font.pixelSize: 13
                font.family: "微软雅黑"
                color: chooseDirMouseArea.containsMouse ? "#789ef0" : "#5c7aba"
                font.bold: true
                MouseArea {
                    id: chooseDirMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        folderDialog.open()
                    }
                }
            }

            Item {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 50
                Row {
                    spacing: 12
                    //播放全部
                    Rectangle {
                        id: playAll
                        width: 94
                        height: 36
                        radius: 8
                        color: "#fc3c54"
                        Row {
                            width: implicitWidth
                            height: parent.height
                            anchors.centerIn: parent
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"
                                height: 20
                                width: 20
                                Image {
                                    id: playImg
                                    source: "qrc:/svg/Resources/playMusicFunc/icon_play.svg"
                                    anchors.centerIn: parent
                                    ColorOverlay {
                                        source: playImg
                                        color: "#ffffff"
                                        anchors.fill: source
                                    }
                                }
                            }

                            Text {
                                id: palyAllText
                                text: qsTr("播放全部")
                                font.pixelSize: 13
                                font.family: "微软雅黑"
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        MouseArea {
                            onClicked: {
                                console.log(header.width)
                            }
                        }
                    }
                    //匹配
                    Rectangle {
                        id: matchRect
                        width: 36
                        height: 36
                        radius: 8
                        border.width: 1
                        border.color: "#2d2d34"
                        color: matchMouseArea.containsMouse ? "#2b2b31" : "#202027"
                        Image {
                            id: match
                            source: "qrc:/svg/Resources/playMusicFunc/jiaohuan.svg"
                            sourceSize: "24x24"
                            anchors.centerIn: parent
                            ColorOverlay {
                                source: parent
                                anchors.fill: parent
                                color: "white"
                            }
                        }
                        MouseArea {
                            id: matchMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {
                                PlayerController.setDirectory("default",2)
                            }
                        }
                    }
                    Rectangle {
                        id: moreRectRect
                        width: 36
                        height: 36
                        radius: 8
                        border.width: 1
                        border.color: "#2d2d34"
                        color: refreshMouseArea.containsMouse ? "#2b2b31" : "#202027"
                        Image {
                            id: more
                            source: "qrc:/svg/Resources/playMusicFunc/gengduoshu.svg"
                            sourceSize: "24x24"
                            anchors.centerIn: parent
                            ColorOverlay {
                                source: parent
                                anchors.fill: parent
                                color: "white"
                            }
                        }
                        MouseArea {
                            id: refreshMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {

                            }
                        }
                    }
                }
            }
            Item {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 50
                height: 72
                width: 300

                Rectangle {
                    id: textFieldRect
                    height: 36
                    width: textField.activeFocus ? 178 : 72
                    color: "#202027"
                    radius: height / 2
                    border.color: "#2d2d34"
                    border.width: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 214

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                        }
                    }

                    Image {
                        id: searchImg
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.margins: 0
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/svg/Resources/title/search.svg"
                        sourceSize: "20x20"
                        ColorOverlay {
                            source: searchImg
                            anchors.fill: source
                            color: searchMouseArea.containsMouse ? "white" : "#a1a1a3"
                            opacity: searchMouseArea.containsMouse ? 1 : 0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                        }
                    }
                    //搜索文本框
                    TextField {
                        id: textField
                        anchors.left: searchImg.right
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#717176"
                        height: 34
                        font.pixelSize: 13
                        font.family: "微软雅黑"
                        leftPadding: 0
                        //horizontalAlignment: TextInput.AlignLeft
                        background: Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                        }
                        placeholderText: ""
                        Text {
                            id: placeholder
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                rightMargin: 16
                            }
                            text: qsTr("搜索本地音乐")
                            color: "#AAAAAA"
                            font: textField.font
                            visible: textField.text.length === 0
                                     && !textField.inputMethodComposing // && !textField.activeFocus

                            // 关键设置：禁止省略号
                            elide: Text.ElideNone
                            clip: true
                        }
                    }
                    MouseArea {
                        id: searchMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: containsMouse ? Qt.IBeamCursor : Qt.ArrowCursor
                        onClicked: {
                            textField.forceActiveFocus()
                        }
                    }
                }
                Rectangle {
                    anchors.right: parent.right
                    height: 36
                    width: 204
                    radius: height / 2
                    color: "#202027"
                }
            }
        }
        //主视图
        Item {
            id: mainContent
            anchors {
                top: header.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            ListView {
                id: musicListView
                function secondsToMinSec(totalSeconds) {
                    // 确保输入是数字
                    let seconds = Number(totalSeconds);
                    if (isNaN(seconds) || seconds < 0) return "00:00";

                    // 计算分钟和秒数
                    let mins = Math.floor(seconds / 60);
                    let secs = Math.floor(seconds % 60);

                    // 格式化为两位数
                    return mins.toString().padStart(2, '0') + ":" + secs.toString().padStart(2, '0');
                }
                function formatFileSize(bytes, decimals = 2) {
                    if (bytes <= 0) return "0 B";

                    const k = 1024;
                    const sizes = ["B", "KB", "MB", "GB", "TB"];

                    // 计算单位索引
                    const i = Math.floor(Math.log(bytes) / Math.log(k));

                    // 格式化数值
                    return parseFloat((bytes / Math.pow(k, i)).toFixed(decimals)) + " " + sizes[i];
                }
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                clip: true
                property real oldWidth: width
                property bool initalized: false
                currentIndex:-1
                header: Rectangle {
                    id: headerRect

                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: 42
                    color: "transparent"
                    property var buttonList: [numberListHeader, titleButton, albumButton, durationButton, sizeButon]
                    state: "ZERO"
                    Rectangle {
                        id: numberListHeader
                        height: 30
                        width: 50
                        color: "#13131a"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("#")
                            color: "#a0a0a3"
                            font.pixelSize: 13
                            font.family: "微软雅黑"
                        }
                    }

                    BasicTableHeaderButton {
                        id: titleButton
                        index: 1
                        rectTitle: qsTr("标题")
                        minWidth: 180
                        width: 296
                        //minWidth: 180
                        parentRect: parent
                    }
                    BasicTableHeaderButton {
                        id: albumButton
                        index: 2
                        rectTitle: qsTr("专辑")
                        minWidth: 114
                        width: 296
                        //minWidth: 114
                        parentRect: parent
                    }
                    BasicTableHeaderButton {
                        id: durationButton
                        index: 3
                        rectTitle: qsTr("时长")
                        minWidth: 64
                        width: 64
                        //minWidth: 64
                        parentRect: parent
                    }
                    BasicTableHeaderButton {
                        id: sizeButon
                        index: 4
                        rectTitle: qsTr("大小")
                        minWidth: 64
                        width: 64
                        // minWidth: 64
                        parentRect: parent
                    }

                    states: [
                        State {
                            name: "ZERO"
                            PropertyChanges {
                                target: titleButton

                                anchors.left: numberListHeader.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: albumButton
                                anchors.left: titleButton.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: durationButton
                                anchors.left: albumButton.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: sizeButon
                                anchors.left: durationButton.right
                                anchors.right: parent.right
                            }
                        },
                        State {
                            name: "ONE"
                            PropertyChanges {
                                target: titleButton
                                anchors.left: numberListHeader.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: albumButton
                                anchors.left: titleButton.right
                                anchors.right: durationButton.left
                            }
                            PropertyChanges {
                                target: durationButton
                                anchors.left: undefined
                                anchors.right: sizeButon.left
                            }
                            PropertyChanges {
                                target: sizeButon
                                anchors.left: undefined
                                anchors.right: parent.right
                            }
                        },
                        State {
                            name: "TWO"
                            PropertyChanges {
                                target: titleButton
                                anchors.left: numberListHeader.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: albumButton
                                anchors.left: titleButton.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: durationButton
                                anchors.left: albumButton.right
                                anchors.right: sizeButon.left
                            }
                            PropertyChanges {
                                target: sizeButon
                                anchors.left: undefined
                                anchors.right: parent.right
                            }
                        },
                        State {
                            name: "THREE"
                            PropertyChanges {
                                target: titleButton
                                anchors.left: numberListHeader.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: albumButton
                                anchors.left: titleButton.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: durationButton
                                anchors.left: albumButton.right
                                anchors.right: undefined
                            }
                            PropertyChanges {
                                target: sizeButon
                                anchors.left: durationButton.right
                                anchors.right: parent.right
                            }
                        }
                    ]
                }

                model:PlayerController.musicList

                delegate: BasicTableContentButton {

                    width: musicListView.width
                    rectTitle: model.title
                    rectArtist: model.artist
                    rectAlbum: model.album
                    rectDuration: musicListView.secondsToMinSec(model.duration)
                    rectSize: musicListView.formatFileSize(model.size)
                    headerList: musicListView.headerItem.buttonList
                    musicIndex: index
                    musicCurrentIndex:PlayerController.currentIndex
                    // Connections{
                    //     target:parent
                    //     function onIndexSet(rectIndex){
                    //         musicListView.currentIndex = rectIndex
                    //         console.log("查看View选中",musicListView.currentIndex)
                    //     }
                    //}
                    onIndexSet:(rectIndex)=>{
                        musicListView.currentIndex = rectIndex
                        console.log("查看View选中",musicListView.currentIndex)
                    }

                }

                onWidthChanged: {

                    if (musicListView.initalized && oldWidth > 0) {

                        var headerList = musicListView.headerItem.buttonList
                        var deltaWidth = []
                        var eltaWidthPercent = []
                        var countDeltaWidth = 0
                        for (var i = 1; i < headerList.length; i++) {
                            deltaWidth.push(
                                        headerList[i].width - headerList[i].minWidth)
                            countDeltaWidth += headerList[i].width - headerList[i].minWidth
                        }
                        for (var j = 1; j < headerList.length; j++) {
                            eltaWidthPercent.push(
                                        deltaWidth[j - 1] / countDeltaWidth)
                        }
                        var widthChange = musicListView.width - musicListView.oldWidth

                        for (var k = 1; k < headerList.length; k++) {

                            headerList[k].width += widthChange * eltaWidthPercent[k - 1]
                        }
                        oldWidth = width
                    }
                }
                Component.onCompleted: {

                    musicListView.initalized = true
                }
                ScrollBar.vertical: ScrollBar {
                    id: verticalScrollBar
                    policy: ScrollBar.AsNeeded // 按需显示
                    width: 10 // 宽度
                    contentItem: Rectangle {
                        visible: parent.active
                        implicitWidth: 10
                        radius: width / 2
                        color: "#2b2b31"
                    }
                }
            }
        }
    }
}
