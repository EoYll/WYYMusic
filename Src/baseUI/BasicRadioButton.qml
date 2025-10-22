import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic 2.15
RadioButton{
    id: control
    text: ""
    property alias radioButtonText: control.text

    MouseArea{
        id:radioButtonMouseArea
        anchors.fill:parent
        hoverEnabled: true
        cursorShape:containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
        //propagateComposedEvents: true
        onClicked: {
            control.checked = true
        }
    }

   // 自定义文本样式
    contentItem: Text {
        text: control.text
        font.family: "微软雅黑"
        font.pixelSize: 13
        color: "#89898d"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }

   // 自定义单选按钮图标
    indicator: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        color: "transparent"
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: width / 2 // 圆形
        border.color:control.checked?"#ff3a3a":radioButtonMouseArea.containsMouse?"white":  "#89898d"

       // 选中时的中心点
        Rectangle {
            visible: control.checked
            color: "#ff3a3a"
            radius: width / 2
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
        }
    }
}
