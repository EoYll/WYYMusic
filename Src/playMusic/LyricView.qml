import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property alias model: listView.model
    property int currentIndex: -1
    property alias currentItem: listView.currentItem

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        spacing: 10
        preferredHighlightBegin: height / 3
        preferredHighlightEnd: height * 2 / 3
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 200 // 滚动动画持续时间

        delegate: Item {
            width: listView.width
            height: 30
            Text {
                text: model.text
                color: listView.currentIndex === index ? "red" : "white"
                font.pixelSize: listView.currentIndex === index ? 20 : 16
                anchors.centerIn: parent
            }
        }

        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex, ListView.Center)
        }
    }

    // 当currentIndex变化时，滚动到当前项
    onCurrentIndexChanged: {
        listView.currentIndex = currentIndex
    }
}
