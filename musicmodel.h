#ifndef MUSICMODEL_H
#define MUSICMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include<QUrl>
class MusicModel : public QAbstractListModel
{
    Q_OBJECT

public:
    struct MusicItem {
        QString title;          // 歌曲标题
        QString artist;         // 艺术家
        QString album;          // 专辑名称
        int duration =0;       // 时长（秒）
        //QUrl coverUrl;          // 封面图片URL
        QUrl filePath;          // 文件路径
        bool isFavorite = false;// 是否收藏
        int trackNumber = 0;    // 曲目编号
        QString fileSize;       //文件大小

        // 构造函数
        MusicItem() = default;
        MusicItem(const QString &title, const QString &artist, const QString &album,
                  const int duration, const QUrl &filePath,const QString &size)
            : title(title), artist(artist), album(album),
            duration(duration),  filePath(filePath),fileSize(size) {}

        // 比较运算符
        bool operator==(const MusicItem &other) const {
            return title == other.title &&
                   artist == other.artist &&
                   album == other.album &&
                   filePath == other.filePath;
        }
    };
    // 角色枚举定义
    enum MusicRoles {
        TitleRole = Qt::UserRole + 1,
        ArtistRole,
        AlbumRole,
        DurationRole,
        CoverUrlRole,
        FilePathRole,
        IsFavoriteRole,
        TrackNumberRole,
        SizeRole
    };
    explicit MusicModel(QObject *parent = nullptr);

    // 必须实现的虚函数
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 数据操作方法
    void addMusicItem(const MusicItem &item);
    void removeMusicItem(int index);
    void updateMusicItem(int index, const MusicItem &item);
    void clear();

    // 数据访问
    QList<MusicItem> musicList() const;
signals:
    void musicListChanged();
private:
    QList<MusicItem> m_musicList;

};

#endif // MUSICMODEL_H
