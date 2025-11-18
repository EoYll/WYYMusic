#ifndef LYRICMODEL_H
#define LYRICMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <QPair>
#include <QString>
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>

class LyricModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)

public:
    enum LyricRoles {
        TimeRole = Qt::UserRole + 1,
        TextRole,
        IsCurrentRole
    };


    explicit LyricModel(QObject *parent = nullptr);

    // QAbstractListModel 接口
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 自定义方法
    Q_INVOKABLE bool loadLyricFile(const QString &filePath);
    Q_INVOKABLE void setPosition(qint64 position);

    int currentIndex() const;
    double progress() const;

signals:
    void currentIndexChanged();
    void progressChanged();

private:
    struct LyricLine {
        qint64 time; // 时间戳(毫秒)
        QString text; // 歌词文本
    };

    QVector<LyricLine> m_lyrics;
    int m_currentIndex;
    double m_progress;

    void updateCurrentLyric(qint64 position);

};

#endif // LYRICMODEL_H
