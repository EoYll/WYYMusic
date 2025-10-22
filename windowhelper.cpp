#include "windowhelper.h"
#include <QGuiApplication>
#include <QScreen>
#include <dwmapi.h>
#include<windowsx.h>
#pragma comment(lib, "dwmapi.lib")

WindowHelper::WindowHelper(QWindow* window)
    : m_window(window)
{

    //QGuiApplication::instance()->installNativeEventFilter(this);
    enableSystemEffects();
    this->setParent(window);
}

void WindowHelper::enableSystemEffects()
{
#ifdef Q_OS_WIN
    if (HWND hwnd = reinterpret_cast<HWND>(m_window->winId())) {
        // 启用Windows 11现代阴影特效
        BOOL enable = TRUE;
        DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &enable, sizeof(enable));

        // 启用系统圆角
        DWM_WINDOW_CORNER_PREFERENCE cornerPreference = DWMWCP_ROUND;
        DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &cornerPreference, sizeof(cornerPreference));

        // 启用窗口阴影
        const MARGINS shadow = {1, 1, 1, 1};
        DwmExtendFrameIntoClientArea(hwnd, &shadow);

        // 启用亚克力背景效果
        DWM_SYSTEMBACKDROP_TYPE backdrop = DWMSBT_MAINWINDOW;
        DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &backdrop, sizeof(backdrop));
    }
#endif
}

// #ifdef Q_OS_WIN
// #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
// bool WindowHelper::nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result)
// #else
// bool WindowHelper::nativeEventFilter(const QByteArray &eventType, void *message, long *result)
// #endif
// {
//     if (eventType != "windows_generic_MSG") return false;

//     MSG* msg = static_cast<MSG*>(message);
//     HWND hwnd = reinterpret_cast<HWND>(m_window->winId());
//     qDebug()<<"hwnd"<<hwnd;
//     if (!msg || msg->hwnd != hwnd) return false;

//     switch (msg->message) {
//     case WM_NCCALCSIZE:
//         // 移除默认边框但保留阴影
//         if (msg->wParam == TRUE) {
//             *result = 0;
//             return true;
//         }
//         break;

//     case WM_NCHITTEST: {
//         // 设置可拖动标题栏区域
//         POINT pt = {GET_X_LPARAM(msg->lParam), GET_Y_LPARAM(msg->lParam)};

//         // 计算窗口区域（屏幕坐标）
//         RECT windowRect;
//         GetWindowRect(hwnd, &windowRect);

//         // 标题栏区域
//         RECT titleBarRect = {
//             windowRect.left,
//             windowRect.top,
//             windowRect.right,
//             windowRect.top + m_titleBarHeight
//         };

//         // 检查是否在标题栏区域（排除按钮区域）
//         if (PtInRect(&titleBarRect, pt)) {
//             *result = HTCAPTION; // 标记为标题栏区域
//             return true;
//         }
//         break;
//     }

//     case WM_DWMCOMPOSITIONCHANGED:
//         // 当DWM合成状态改变时重新启用效果
//         enableSystemEffects();
//         *result = 0;
//         return true;

//     case WM_SETTINGCHANGE:
//         // 系统设置变更时更新窗口
//         if (msg->wParam == SPI_SETWORKAREA) {
//             m_window->requestActivate();
//         }
//         break;
//     }

//     return false;
// }

WindowHelper::~WindowHelper()
{

}
// #endif
