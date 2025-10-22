#pragma once

#include <QWindow>
#include <QAbstractNativeEventFilter>
#include <QRect>
#ifdef Q_OS_WIN
#include <windows.h>
#endif

class WindowHelper : public QObject
{
public:
    explicit WindowHelper(QWindow* window);
    ~WindowHelper();
    // 启用Windows 11原生阴影和特效
    void enableSystemEffects();

    // 事件过滤器实现
// #ifdef Q_OS_WIN
// #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
//     bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result) override;
// #else
//     bool nativeEventFilter(const QByteArray &eventType, void *message, long *result) override;
// #endif
// #endif

private:
    QWindow* m_window;
    //int m_titleBarHeight = 40; // 匹配QML中的标题栏高度
};
