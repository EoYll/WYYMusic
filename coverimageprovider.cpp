// CoverImageProvider.cpp
#include "coverimageprovider.h"

CoverImageProvider::CoverImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image) {}

QImage CoverImageProvider::requestImage(const QString& id, QSize* size, const QSize& requestedSize) {
    Q_UNUSED(id)

    if (size) *size = m_coverImage.size();

    if (requestedSize.width() > 0 && requestedSize.height() > 0) {
        return m_coverImage.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    }

    return m_coverImage;
}

void CoverImageProvider::setCoverImage(const QImage& image) {
    m_coverImage = image;
}
