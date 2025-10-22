#ifndef COVERIMAGEPROVIDER_H
#define COVERIMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>

class CoverImageProvider : public QQuickImageProvider
{
public:
    CoverImageProvider();
    QImage requestImage(const QString& id, QSize* size, const QSize& requestedSize) override;

    void setCoverImage(const QImage& image);

private:
    QImage m_coverImage;
};

#endif // COVERIMAGEPROVIDER_H
