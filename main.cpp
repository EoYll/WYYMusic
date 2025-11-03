#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include"windowhelper.h"
#include<QQuickWindow>
#include"playercontroller.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/WYYMusic/main.qml"));
    // 调试资源系统
    qmlRegisterSingletonType(QUrl("qrc:/Src/basic/AppState.qml"), "AppState", 1, 0, "AppState");
    // 注册控制器
    PlayerController *playerController = PlayerController::instance();
    playerController->setParent(&app);
    qmlRegisterSingletonInstance<PlayerController>("MusicPlayer", 1, 0, "PlayerController",playerController);
    //engine.addImageProvider("cover", playerController->imageProvider());


    // // 正确安装过滤器
    // WindowHelper* filter = new WindowHelper();
    // app.installNativeEventFilter(filter);
    //qmlRegisterType<WindowHelper>("WindowHelper",1,0,"WindowHelper");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);
    // 获取QML窗口
    QObject* m_rootObject = engine.rootObjects().first();

    QWindow *window = qobject_cast<QWindow *>(m_rootObject);


    // 安装系统效果助手
    WindowHelper* helper = new WindowHelper(window);
    //helper->setParent(window,Qt::FramelessWindowHint|Qt::Window);
    Q_UNUSED(helper); // 避免未使用警告
    return app.exec();
}


