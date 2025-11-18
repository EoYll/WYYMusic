QT += quick
QT += core gui  # 确保包含gui模块
QT += core5compat
QT += multimedia
QT += widgets
CONFIG += c++17
SOURCES += \
        coverimageprovider.cpp \
        lyricmodel.cpp \
        main.cpp \
        musicmodel.cpp \
        playercontroller.cpp \
        windowhelper.cpp

resources.files = main.qml 
resources.prefix = /$${TARGET}
RESOURCES += resources \
    qml.qrc \
    resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = \
    ./ \
    ./Src/basic \

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Src/leftPage/FunctionButton.qml \
    Src/leftPage/LeftPage.qml \
    Src/playMusic/LyricsPage.qml \
    Src/playMusic/PlayMusic.qml \
    Src/rightPage/RightPage.qml \
    Src/MainWindow.qml

HEADERS += \
    coverimageprovider.h \
    lyricmodel.h \
    musicmodel.h \
    playercontroller.h \
    windowhelper.h


win32 {
    # Windows 特定设置
    LIBS += -luser32
    LIBS += -ldwmapi
    DEFINES += _WIN32_WINNT=0x0A00  # 设置最低支持 Windows 10
    QMAKE_CXXFLAGS += -DUNICODE -D_UNICODE
}



win32: LIBS += -LD:/tools/vcpkg/vcpkg-2025.09.17/installed/x64-windows/debug/lib/ -ltag

INCLUDEPATH += D:/tools/vcpkg/vcpkg-2025.09.17/installed/x64-windows/include
DEPENDPATH += D:/tools/vcpkg/vcpkg-2025.09.17/installed/x64-windows/include

win32:!win32-g++: PRE_TARGETDEPS += D:/tools/vcpkg/vcpkg-2025.09.17/installed/x64-windows/debug/lib/tag.lib
else:win32-g++: PRE_TARGETDEPS += D:/tools/vcpkg/vcpkg-2025.09.17/installed/x64-windows/debug/lib/libtag.a
