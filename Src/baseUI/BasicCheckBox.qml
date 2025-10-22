import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Basic 2.15
CheckBox{

    property bool isChecked: false
    property alias checkBoxText: checkText.text
    MouseArea{
        id:checkMouseArea
        hoverEnabled: true
        anchors.fill:parent
        cursorShape:containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
        onClicked: {
            parent.isChecked=!parent.isChecked
        }

    }

    indicator:Rectangle{
        width: 16
        height:16
        radius: 3
        color: parent.isChecked?"#ff3a3a":"transparent"
        border.color:parent.isChecked?"#ff3a3a":checkMouseArea.containsMouse?"#e8e8e9":"#717176"
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        // Text{
        //     text: parent.parent.isChecked?"√":""
        //     color: parent.parent.isChecked?"#ffffff":"transparent"
        //     anchors.centerIn: parent
        // }
        Image {
            id:image
            source: "qrc:/svg/Resources/settings/right.svg"
            sourceSize: "10x10"
            anchors.centerIn: parent
            visible: parent.parent.isChecked
            ColorOverlay{
                source:image
                anchors.fill: source
                color:parent.parent.parent.isChecked?"#ffffff":"transparent"
                opacity: 1
            }
        }

    }
    contentItem:Text{
        id:checkText
        text: ""
        //color:"white"
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.RichText
        font.family: "微软雅黑"
        font.pixelSize: 14
        leftPadding: parent.indicator.width //+ parent.spacing // 对齐到复选框右侧

    }
}
