import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import AppState 1.0
Rectangle{
    id:root
    property string buttonId: ""
    property bool isSelected: false
    property alias icon: image.source
    property alias title:titleText.text
    width:164
    height:36
    radius: 6
    color:"transparent"
    signal clickedId(string id)
    Image {
        id: image
        source: ""
        sourceSize: "16x16"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left
        anchors.leftMargin: 8
        ColorOverlay{
            id:imageColorOver
            source:image
            anchors.fill: source
            color:"transparent"
            opacity: 1
        }
    }

    Text{
        id:titleText
        text: ""
        color:"#d1d1d3"
        font.pixelSize: 14
        //font.weight: Font.Bold
        font.family: "微软雅黑"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:image.right
        anchors.leftMargin: 8
    }
    MouseArea{
        id:siftMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse?Qt.PointingHandCursor:Qt.ArrowCursor
        onClicked:{
            clickedId(buttonId)
            root.state = "SELECTED"
            switch(buttonId){
            case "sift":
                break;
            case "podcast":
                break;
            case "follow":
                break;
            case "favoriteMusic":
                break;
            case "recently":
                break;
            case "download":
                break;
            case "localMusic":
                if(AppState.mainStackView.currentItem.pageUrl!=="qrc:/Src/rightPage/StackPages/LocalMusicPage.qml"){
                    AppState.mainStackView.push("qrc:/Src/rightPage/StackPages/LocalMusicPage.qml")
                }


                break;
            default:
                break;
            }
        }
        onEntered:{
            if(!root.isSelected){
                root.state ="ONMOUSEOVER"
            }
        }
        onExited: {
            if(!root.isSelected){
                root.state ="UNSELECTED"
            }
        }
    }
    //按钮状态
    states: [
        //选中
        State {
            name: "SELECTED"
            PropertyChanges {
                target: root
                color:"#fc3c4f"
            }
            PropertyChanges {
                target: imageColorOver
                color: "#ffffff"
            }
            PropertyChanges {
                target: titleText
                color:"#ffffff"
            }

        },
        //鼠标悬浮
        State {
            name: "ONMOUSEOVER"
            PropertyChanges {
                target: root
                color:"#27272e"
            }
            PropertyChanges {
                target: imageColorOver
                color:"#a9a9ab"

            }
            PropertyChanges {
                target: titleText
                color:"#d4d4d5"
            }
        },
        //未被选中
        State {
            name: "UNSELECTED"
            when: !root.isSelected && !siftMouseArea.containsMouse
            PropertyChanges {
                target: root
                color:"transparent"
            }
            PropertyChanges {
                target: imageColorOver
                color:"#a3a3a6"

            }
            PropertyChanges {
                target: titleText
                color:"#d1d1d3"
            }
        }
    ]

}
