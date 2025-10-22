#ifndef DWMCONTROLLER_H
#define DWMCONTROLLER_H
#include <QWindow>
#include <dwmapi.h>  // 直接使用 Windows API

#ifdef Q_OS_WIN
#include <windows.h>
#endif

class DWMController : public QObject {
    Q_OBJECT
public:
    explicit DWMController(QWindow *window) : m_window(window) {
        // 关键：设置无边框窗口
        m_window->setFlags(Qt::FramelessWindowHint | Qt::Window);
    }

    Q_INVOKABLE bool isCompositionEnabled() {
#ifdef Q_OS_WIN
        BOOL enabled;
        return SUCCEEDED(DwmIsCompositionEnabled(&enabled)) && enabled;
#else
        return false;
#endif
    }

    Q_INVOKABLE void extendFrame() {
#ifdef Q_OS_WIN
        if (!isCompositionEnabled()) return;

        HWND hwnd = (HWND)m_window->winId();
        MARGINS margins = { -1, -1, -1, -1 };
        DwmExtendFrameIntoClientArea(hwnd, &margins);
#endif
    }

    Q_INVOKABLE void enableModernBlur(bool darkMode = false) {
#ifdef Q_OS_WIN
        if (!isCompositionEnabled()) return;

        HWND hwnd = (HWND)m_window->winId();

        // 现代模糊效果 (Win10/11)
        const DWORD backdropType = 3; // DWMSBT_TRANSIENTWINDOW/Acrylic
        DwmSetWindowAttribute(hwnd, 38 /*DWMWA_SYSTEMBACKDROP_TYPE*/,
                              &backdropType, sizeof(backdropType));

        // 深色模式支持
        BOOL useDark = darkMode;
        DwmSetWindowAttribute(hwnd, 20 /*DWMWA_USE_IMMERSIVE_DARK_MODE*/,
                              &useDark, sizeof(useDark));
#endif
    }

private:
    QWindow *m_window;
};
#endif // DWMCONTROLLER_H
