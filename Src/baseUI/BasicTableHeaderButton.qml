import QtQuick 2.15
import QtQuick.Layouts
Rectangle {
    id: rect

    height: 30
    radius: 6
    color: rectMouseArea.containsMouse ? "#1a1a21" : "#13131a"
    property int startWidth: width
    property int startMouseX: 0
    property int index: 0
    property int minWidth
    property var parentRect

    property int frontWidth: 0
    property alias rectTitle: title.text
    property alias rectHolder: holder.text
    //signal sendRectWidth(int index,int delta)
    property var statesList: ["ZERO","ONE","TWO","THREE"]
    Layout.minimumWidth: minWidth
    Layout.fillWidth: true

    clip:true
    MouseArea {
        id: rectMouseArea
        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        // preventStealing: true
        propagateComposedEvents: true
        property int edges: 0
        property int edgeOffest: 5

        function setEdges(x, y) {
            edges = 0

            if (rect.index < 4 && x > (width - edgeOffest))
                edges |= Qt.RightEdge
        }

        cursorShape: {
            return !containsMouse ? Qt.ArrowCursor : edges
                                    == 4 ? Qt.SizeHorCursor : Qt.PointingHandCursor
        }

        onPositionChanged: {

            setEdges(mouseX, mouseY)
            if (rect.index<4&&pressed&&edges ) {
                // 计算鼠标移动的差值（注意：mouseX是相对于MouseArea的，所以需要加上之前的位置）
                var delta = mouseX - rect.startMouseX
                // 调整按钮宽度，不能小于某个最小值（比如20）
                var nextButton = rect.parentRect.buttonList[rect.index+1]
                rect.width = Math.min(Math.max(rect.minWidth, rect.startWidth + delta),nextButton.x+nextButton.width-rect.x-nextButton.minWidth )

                // if (signalHub) {
                //     console.log(rect.startWidth)
                //     if(rect.width === rect.minWidth)delta =0
                //     signalHub.sendRectDeltaWidth(rect.index, delta,rect.startWidth)
                // }
            }
        }
        onPressed:(mouse)=> {

            if(rect.index<4&&rect.parentRect){
              rect.parentRect.state =rect.statesList[rect.index]

            }
            //setEdges(mouseX, mouseY)
            if (edges && containsMouse) {
                rect.startWidth = rect.width
                rect.startMouseX = mouseX
                // console.log(Qt.TopEdge)1
                // console.log(Qt.LeftEdge)2
                // console.log(Qt.RightEdge)4
                // console.log(Qt.BottomEdge)8
            }
            //mouse.accepted =false
        }
        onReleased: {
            if(parentRect){
                parentRect.state ="ZERO"
            }
        }

        onWidthChanged: {
            if(!pressed){
                rect.width = Math.max(rect.minWidth, rect.width)
                //console.log(rect.index,rect.width)
            }
        }
    }
    // Component.onCompleted: {
    //     if (signalHub) {
    //         signalHub.sendRectDeltaWidth.connect(getOtherWidth)
    //     }
    // }
    // function getOtherWidth(index, delta, startWidth) {
    //     //console.log(index, delta,stratWidth)
    //     if (index + 1 === rect.index) {
    //         if (rect.frontWidth !== startWidth) {
    //             rect.frontWidth = startWidth
    //             rect.startWidth = rect.width
    //         }
    //         //if()
    //         rect.width = Math.max(rect.minWidth, rect.startWidth - delta)
    //         console.log(index, delta,startWidth)
    //     }
    // }

    Text {
        id: title
        text: qsTr("标题")
        color: "#a0a0a3"
        font.pixelSize: 13
        font.family: "微软雅黑"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    Text {
        id: holder
        text: qsTr(" 默认排序")
        color: "#a0a0a3"
        font.pixelSize: 13
        font.family: "微软雅黑"
        anchors.left: title.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        visible: rectMouseArea.containsMouse

    }
}
