pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15
QtObject{
    property string fontType: "微软雅黑"// 全局通用字体
    property int playModeIndex: 0 //播放模式
    property StackView mainStackView: null //主栈
}
