import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic 2.15
ComboBox{
    id:comboBox
    height: 30
    width: 134

    //editable: false
    currentIndex: 0
    property alias comboBoxModel: comboBox.model
    model: []
    background: Rectangle{
        anchors.fill: parent
        color: "#1a1a21"
        border.color:"#28282f"
        border.width:1
        radius: height/2

    }
    MouseArea{
        hoverEnabled: true
        anchors.fill:parent
        cursorShape:containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
        onClicked: {
            //console.log(1)

            //console.log(down.rotation)
            comboBox.popup.visible=!comboBox.popup.visible
        }
    }
    indicator: Image {
        id: down
        source: "qrc:/svg/Resources/title/zhankai.svg"
        sourceSize: "20x20"
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin:6
        smooth: true
        antialiasing: true // 抗锯齿
        rotation:0
        Behavior on rotation {
            NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
        }
    }
    contentItem: Text{
        text: comboBox.displayText
        color: "white"
        font.pixelSize: 16
        font.family: "微软雅黑"
        //anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        //anchors.centerIn: Text

    }


    popup: Popup{
        y:parent.height + 4
        width: parent.width
        implicitHeight: 260
        background: Rectangle {
            id:back
            color: "#2d2d38" // 整体背景
            border.color: "#42424c"
            anchors.fill:parent
            radius: 8
            clip: true

        }
        contentItem: ListView {
            id:listView
            anchors.fill: parent
            clip: true
            implicitHeight: contentHeight
            //model: comboBox.popup.visible ? comboBox.delegateModel : null
            model:  comboBox.model
            currentIndex: comboBox.highlightedIndex

            // 自定义垂直滚动条
            ScrollBar.vertical: ScrollBar {
                id: verticalScrollBar2
                policy: ScrollBar.AsNeeded

                // 背景轨道
                background: Rectangle {
                    implicitWidth: 8
                    color: "transparent"
                    //top:parent.top


                    radius: width / 2
                }

                // 滑块
                contentItem: Rectangle {
                    implicitWidth: 8
                    color: verticalScrollBar2.pressed ? "#888888" :
                           verticalScrollBar2.hovered ? "#666666" : "#444444"
                    radius: width / 2

                    // 动态高度
                    implicitHeight: Math.max(
                        20,
                        listView.visibleArea.heightRatio * listView.height
                    )

                    // 动画效果
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }


            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: Rectangle{
                    //color: "#2d2d38" // 整体背景
                    //border.color: "#42424c"
                    width: back.width
                    height:back.height
                    radius: 8
                }
            }
            delegate: ItemDelegate {

                width: comboBox.width-12
                height: 36

                MouseArea{
                    id:itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
                    onClicked: {
                        comboBox.currentIndex = index
                        comboBox.popup.close()
                    }

                }
                contentItem: Text {
                    text: modelData
                    font.family: "微软雅黑"
                    font.pixelSize: 15
                    color: "#c3c3c6"
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: itemMouseArea.containsMouse?"#393943":"transparent"

                }

            }
            // 圆角遮罩
            Rectangle {
                id: mask
                anchors.fill: parent
                radius: 8
                visible: false
            }

        }
        // 应用遮罩效果
        OpacityMask {
            anchors.fill: listView
            source: listView
            maskSource: mask
        }
        onVisibleChanged: {
           down.rotation= visible?180:0
        }
    }
}
