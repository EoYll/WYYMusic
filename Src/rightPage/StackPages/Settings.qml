import QtQuick 2.15
import QtQuick.Controls.Basic 2.15
import Qt5Compat.GraphicalEffects
import "../../baseUI"

Item {
    property string pageUrl:"qrc:/Src/rightPage/StackPages/Settings.qml"
    Item {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.topMargin: 20
        Label {
            id: settingMainTitle
            text: "设置"
            color: "#ffffff"
            font.family: "微软雅黑"
            font.pixelSize: 24
            font.bold: true
        }

        Flow {
            id: settingTitleFlow
            anchors.top: settingMainTitle.bottom
            anchors.left: parent.left
            anchors.topMargin: 22
            height: 16
            spacing: 20
            //property color innerColor: indexToColor(selectorRep.selectedIndex)
            // function indexToColor(indexColor){
            //     console.log(indexColor)
            //     console.log(index)
            //     console.log("---")
            //    return index === indexColor?"white":"#a1a1a3"
            // }
            function scrollToBlock(index) {
                var block
                switch (index) {
                case 0:
                    block = accountBlock
                    break
                case 1:
                    block = normalBlock
                    break
                case 2:
                    block = systemBlock
                    break
                case 3:
                    block = playBlock
                    break
                case 4:
                    block = messageAndPrivacy
                    break
                }
                if (block) {
                    var posInContent = block.mapToItem(contentColumn, 0, 0)
                    settingFlick.contentY = posInContent.y
                }
            }
            Repeater {
                id: selectorRep
                anchors.fill: parent
                model: ["账号", "常规", "系统", "播放", "消息与隐私", "快捷键", "音质与下载", "桌面与歌词", "工具", "关于网易云音乐"]
                property int selectedIndex: 0

                delegate: Item {
                    width: selectorLabel.implicitWidth
                    height: selectorLabel.implicitHeight

                    Label {
                        id: selectorLabel
                        text: modelData
                        color: selectorRep.selectedIndex === index ? "white" : (selectorMouseArea.containsMouse ? "#b9b9bb" : "#a1a1a3")
                        font.family: "微软雅黑"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.centerIn: parent
                    }
                    Rectangle {
                        visible: selectorRep.selectedIndex === index
                        anchors.left: selectorLabel.left
                        anchors.top: selectorLabel.bottom
                        anchors.right: selectorLabel.right
                        anchors.leftMargin: selectorLabel.width / selectorLabel.font.pixelSize
                        anchors.rightMargin: selectorLabel.width / selectorLabel.font.pixelSize
                        height: 3
                        radius: 1
                        color: "#ff3a3a"
                    }
                    MouseArea {
                        id: selectorMouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            selectorRep.selectedIndex = index
                            settingTitleFlow.scrollToBlock(index)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: line0
            anchors.top: settingTitleFlow.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.topMargin: 20
            height: 2

            color: "#212127"
        }

        Flickable {
            id: settingFlick
            anchors.top: line0.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            boundsBehavior: Flickable.DragOverBounds

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
            contentHeight: 4000
            clip: true // 重要：裁剪超出区域的内容

            onContentYChanged: {
                updateActiveSection()
                //console.log(contentY)
            }
            function updateActiveSection() {
                var viewTop = settingFlick.contentY
                for (var i = 0; i < sections.length; i++) {
                    var section = sections[i]
                    var sectionTop = section.mapToItem(contentColumn, 0, 0).y
                    var sectionBottom = sectionTop + section.height
                    if (viewTop >= sectionTop && viewTop < sectionBottom) {
                        selectorRep.selectedIndex = i
                        break
                    }
                }
            }
            property var sections: [accountBlock, normalBlock, systemBlock, playBlock, messageAndPrivacy]
            Column {
                id: contentColumn
                anchors.fill: parent
                spacing: 4
                //账号
                Item {
                    id: accountBlock
                    height: 126
                    width: 200
                    Label {
                        id: label1
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        text: "账号"
                        color: "white"
                        font.family: "微软雅黑"
                        font.pixelSize: 16
                        font.bold: true
                        width: 132
                    }
                    Item {
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        anchors.left: label1.right
                        Label {
                            text: "登录网易云音乐，手机电脑多端同步，320k高音质无限下载"
                            color: "white"

                            font.family: "微软雅黑"
                            font.pixelSize: 14
                        }
                        Rectangle {
                            anchors.top: parent.top
                            anchors.topMargin: 44
                            width: 82
                            height: 28
                            radius: width / 2
                            color: "#fc3b5b"
                            Text {
                                anchors.centerIn: parent
                                id: login
                                text: qsTr("立即登录")
                                font.family: "微软雅黑"
                                font.pixelSize: 14
                                color: "#ffffff"
                            }
                        }
                    }
                }
                Rectangle {
                    id: line1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 30

                    height: 2

                    color: "#212127"
                }
                //常规
                Item {
                    id: normalBlock
                    height: 392
                    width: 200
                    Label {
                        id: label2
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        text: "常规"
                        color: "white"
                        font.family: "微软雅黑"
                        font.pixelSize: 16
                        font.bold: true
                        width: 132
                    }
                    Item {
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        anchors.left: label2.right
                        Label {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            textFormat: Text.RichText
                            text: "字体选择"
                            font.family: "微软雅黑"
                            font.pixelSize: 15
                            font.bold: true
                            color: "white"
                        }
                        Label {
                            anchors.left: parent.children[0].right
                            anchors.top: parent.top
                            anchors.topMargin: 1
                            textFormat: Text.RichText
                            text: "(如果字体显示不清晰，请在控制面板-字体设置中启动系统 Clear Type 设置)"
                            font.family: "微软雅黑"
                            font.pixelSize: 14
                            font.bold: false
                            color: "#89898d"
                        }
                        BasicComboBox {
                            id: comboBox
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 26
                            comboBoxModel: ["默认", "仿宋", "华文仿宋", "华文中宋", "华文仿宋", "华文宋体", "华文新魏", "华文楷体", "华文细黑", "华文行楷", "华文隶书", "宋体", "幼圆", "微软雅黑", "微软雅黑 Light", "新宋体", "方正姚体"]
                        }

                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 65
                            checkBoxText: "<font color='white'>开机自动运行</font>"
                        }
                        ButtonGroup {
                            id: radioGroup
                            buttons: row.children
                        }

                        Row {
                            anchors.left: parent.children[3].right
                            anchors.leftMargin: 50
                            anchors.top: parent.top
                            anchors.topMargin: 65
                            id: row
                            spacing: 50
                            BasicRadioButton {
                                text: "最小化展示"
                                checked: true
                            }

                            BasicRadioButton {
                                text: "前台展示"
                            }
                        }

                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 65 + 50
                            checkBoxText: "<font color='white'>将网易云音乐设为默认浏览器</font>"
                        }
                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 65 + 50 * 2
                            checkBoxText: "<font color='white'>开启GPU加速</font><font color='#89898d'>(若软件黑屏，请关闭GPU加速尝试解决)</font>"
                        }
                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 65 + 50 * 3
                            checkBoxText: "<font color='white'>禁用动画效果</font><font color='#89898d'>(减少部分资源占用)</font>"
                        }
                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 65 + 50 * 4
                            checkBoxText: "<font color='white'>禁用系统缩放比例</font><font color='#89898d'>(减少部分资源占用)</font>"
                        }
                    }
                }

                Rectangle {
                    id: line2
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 30

                    height: 2

                    color: "#212127"
                }
                //系统
                Item {
                    id: systemBlock
                    height: 220
                    width: 200
                    Label {
                        id: label3
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        text: "系统"
                        color: "white"
                        font.family: "微软雅黑"
                        font.pixelSize: 16
                        font.bold: true
                        width: 132
                    }
                    Item {
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        anchors.left: label3.right
                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: -3
                            checkBoxText: "<font color='white'>开启定时关闭软件</font>"
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 40
                            spacing: 10

                            Text {
                                id: timeText
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("剩余关闭时间")
                                color: "white"
                                font.family: "微软雅黑"
                                font.pixelSize: 16
                            }
                            BasicComboBox {
                                id: hoursComboBox

                                anchors.verticalCenter: parent.verticalCenter
                                comboBoxModel: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
                            }
                            Text {
                                id: hourText
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("小时")
                                color: "white"
                                font.family: "微软雅黑"
                                font.pixelSize: 16
                            }
                            BasicComboBox {
                                id: minutesComboBox
                                anchors.verticalCenter: parent.verticalCenter
                                comboBoxModel: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
                            }
                            Text {
                                id: minuteText
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("分钟")
                                color: "white"
                                font.family: "微软雅黑"
                                font.pixelSize: 16
                            }
                        }
                        BasicCheckBox {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 80
                            checkBoxText: "<font color='white'>关闭软件同时关机</font>"
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 126
                            text: "关闭主面板"
                            color: "white"
                            font.family: "微软雅黑"
                            font.pixelSize: 15
                            font.bold: true
                        }
                        ButtonGroup {
                            id: radioGroup2
                            buttons: row2.children
                        }
                        Row {
                            anchors.left: parent.children[3].right
                            anchors.leftMargin: 50
                            anchors.top: parent.top
                            anchors.topMargin: 122
                            id: row2
                            spacing: 50

                            BasicRadioButton {
                                text: "最小化到系统托盘"
                                checked: true
                            }

                            BasicRadioButton {
                                text: "退出云音乐"
                            }
                        }
                    }
                }
                Rectangle {
                    id: line3
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    height: 2
                    color: "#212127"
                }
                //播放
                Item {
                    id: playBlock
                    height: 685
                    width: 200
                    Label {
                        id: label4
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        text: "播放"
                        color: "white"
                        font.family: "微软雅黑"
                        font.pixelSize: 16
                        font.bold: true
                        width: 132
                    }
                    Item {
                        anchors.top: parent.top
                        anchors.topMargin: 24
                        anchors.left: label4.right
                        Column {
                            id: playColumn
                            anchors.top: parent.top
                            anchors.left: parent.left
                            spacing: 20
                            //height: 500
                            width: 500
                            BasicCheckBox {
                                checkBoxText: "<font color='white'>程序启动时自动播放</font>"
                            }
                            BasicCheckBox {
                                checkBoxText: "<font color='white'>首次进入播客页时自动播放</font><font color='#6a6a6e'>(不播歌时)</font>"
                            }
                            BasicCheckBox {
                                checkBoxText: "<font color='white'>程序启动时记住上一次播放进度</font>"
                            }
                            BasicCheckBox {
                                checkBoxText: "<font color='white'>开启音乐淡入淡出</font>"
                            }

                            BasicCheckBox {
                                checkBoxText: "<font color='white'>平衡不同音频内容之间的音量大小</font>"
                            }
                            Column {
                                id: outputDevice
                                width: parent.width
                                spacing: 10
                                Text {
                                    id: outputDeviceText
                                    text: qsTr("输出设备")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                BasicComboBox {
                                    comboBoxModel: ["DirectSound:主声音驱动程序"]
                                    width: 360
                                }
                            }
                            Row {
                                height: 30
                                spacing: 20
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("系统音量")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("15%")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                    width: 40
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("(低于30%可能影响收听体验)")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 12
                                    //font.bold: true
                                }
                            }
                            Row {
                                height: 30
                                spacing: 30
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("系统空间特效")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("已开启(可能影响声音效果)")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    //font.bold: true
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("了解系统空间音效>")
                                    color: "#5e7cbd"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    // font.bold: true
                                }
                            }
                            Row {
                                spacing: 36

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("系统音频增强")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                ButtonGroup {

                                    id: radioGroup3
                                    buttons: row3.children
                                }
                                Row {
                                    spacing: 20
                                    id: row3
                                    anchors.verticalCenter: parent.verticalCenter
                                    BasicRadioButton {
                                        text: "开启(可能影响声音效果)"
                                        checked: true
                                    }

                                    BasicRadioButton {
                                        text: "关闭"
                                    }
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("了解系统音频增强>")
                                    color: "#5e7cbd"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    //font.bold: true
                                }
                            }
                            Column {
                                spacing: 5
                                Text {
                                    //anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("播放列表")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                ButtonGroup {

                                    id: radioGroup4
                                    buttons: col1.children
                                }
                                Column {
                                    //spacing: 20
                                    id: col1
                                    //anchors.verticalCenter: parent.verticalCenter
                                    BasicRadioButton {
                                        text: "<font color='white'>双击播放单曲时，用当前所在歌曲列表替换播放列表</font>"
                                        checked: true
                                    }

                                    BasicRadioButton {
                                        text: "<font color='white'>双击播放单曲时，仅把当前单曲添加到播放列表</font>"
                                    }
                                }
                            }
                            Column {
                                Text {
                                    //anchors.verticalCenter: parent.verticalCenter
                                    text: qsTr("最近播放记录")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                BasicCheckBox {
                                    checkBoxText: "<font color='white'>开启后，同步当前账号在各设备的最近播放记录</font>"
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    id: line4
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    height: 2
                    color: "#212127"
                }
                //消息与隐私
                Item {
                    id: messageAndPrivacy
                    height: 200
                    width: 300
                    Label {
                        id: label5
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        text: "消息与隐私"
                        color: "white"
                        font.family: "微软雅黑"
                        font.pixelSize: 16
                        font.bold: true
                        width: 132
                    }
                    Item {
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        anchors.left: label5.right
                        Column {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            Row {
                                Text {
                                    id: privateMessage
                                    text: qsTr("私信")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                ButtonGroup {
                                    id: radioGroup5
                                    buttons: row4.children
                                }

                                Row {
                                    id: row4
                                    BasicRadioButton {
                                        text: "<font color='white'>所有人</font>"
                                        checked: true
                                    }

                                    BasicRadioButton {
                                        text: "<font color='white'>我关注的人</font>"
                                    }
                                }
                            }
                            Row {
                                Text {
                                    id: name
                                    text: qsTr("我的听歌排行")
                                    color: "white"
                                    font.family: "微软雅黑"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                ButtonGroup {
                                    id: radioGroup6
                                    buttons: row5.children
                                }

                                Row {
                                    id: row5
                                    BasicRadioButton {
                                        text: "<font color='white'>所有人可见</font>"
                                        checked: true
                                    }

                                    BasicRadioButton {
                                        text: "<font color='white'>我关注的人可见</font>"
                                    }
                                    BasicRadioButton {
                                        text: "<font color='white'>仅自己可见</font>"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
