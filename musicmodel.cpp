// musicmodel.cpp
#include "musicmodel.h"

MusicModel::MusicModel(QObject *parent)
    : QAbstractListModel(parent) {}

int MusicModel::rowCount(const QModelIndex &parent) const {
    return parent.isValid() ? 0 : m_musicList.size();
}

QVariant MusicModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_musicList.size())
        return QVariant();

    const MusicItem &item = m_musicList[index.row()];

    switch (role) {
    case TitleRole: return item.title;
    case ArtistRole: return item.artist;
    case AlbumRole: return item.album;
    case DurationRole: return item.duration;
    //case CoverUrlRole: return item.coverUrl;
    case FilePathRole: return item.filePath;
    case IsFavoriteRole: return item.isFavorite;
    case TrackNumberRole: return item.trackNumber;
    case SizeRole:return item.fileSize;
    default: return QVariant();
    }
}

QHash<int, QByteArray> MusicModel::roleNames() const {
    static QHash<int, QByteArray> roles;
    if (roles.isEmpty()) {
        roles[TitleRole] = "title";
        roles[ArtistRole] = "artist";
        roles[AlbumRole] = "album";
        roles[DurationRole] = "duration";
        //roles[CoverUrlRole] = "coverUrl";
        roles[FilePathRole] = "filePath";
        roles[IsFavoriteRole] = "isFavorite";
        roles[TrackNumberRole] = "trackNumber";
        roles[SizeRole]= "size";
    }
    return roles;
}

void MusicModel::addMusicItem(const MusicItem &item) {
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_musicList.append(item);
    endInsertRows();
}

void MusicModel::removeMusicItem(int index) {
    if (index < 0 || index >= m_musicList.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_musicList.removeAt(index);
    endRemoveRows();
}

void MusicModel::updateMusicItem(int index, const MusicItem &item) {
    if (index < 0 || index >= m_musicList.size())
        return;

    m_musicList[index] = item;
    QModelIndex modelIndex = createIndex(index, 0);
    emit dataChanged(modelIndex, modelIndex);
}

void MusicModel::clear() {
    beginResetModel();
    m_musicList.clear();
    endResetModel();
}

QList<MusicModel::MusicItem> MusicModel::musicList() const {
    return m_musicList;
}
