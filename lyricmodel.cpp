#include "LyricModel.h"

LyricModel::LyricModel(QObject *parent)
    : QAbstractListModel(parent), m_currentIndex(-1), m_progress(0.0)
{
}

int LyricModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_lyrics.size();
}

QVariant LyricModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_lyrics.size())
        return QVariant();

    const LyricLine &line = m_lyrics.at(index.row());

    switch (role) {
    case TimeRole:
        return line.time;
    case TextRole:
        return line.text;
    case IsCurrentRole:
        return index.row() == m_currentIndex;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LyricModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TimeRole] = "time";
    roles[TextRole] = "text";
    roles[IsCurrentRole] = "isCurrent";
    return roles;
}
QString decodeFileData(const QByteArray& data) {
    qDebug()<<QStringDecoder(QStringDecoder::System).decode(data);
    return QStringDecoder(QStringDecoder::System).decode(data);
        // LyricModel::LrcDecoder::DecodeResult result = LyricModel::LrcDecoder::decodeLrcText(data);
        // return result.content;


    // QString usedEncoding;
    // if (data.isEmpty()) {
    //     usedEncoding = "UTF-8";
    //     return QString();
    // }

    // // 检查BOM
    // if (data.startsWith("\xEF\xBB\xBF")) {
    //     usedEncoding = "UTF-8";
    //     return QStringDecoder("UTF-8").decode(data);
    // }
    // if (data.startsWith("\xFF\xFE")) {
    //     usedEncoding = "UTF-16LE";
    //     return QStringDecoder("UTF-16LE").decode(data);
    // }
    // if (data.startsWith("\xFE\xFF")) {
    //     usedEncoding = "UTF-16BE";
    //     return QStringDecoder("UTF-16BE").decode(data);
    // }

    // // 尝试常见编码
    // for (const char* encoding : { "GBK", "Windows-1252","UTF-8"}) {
    //     QStringDecoder decoder(encoding);
    //     QString content = decoder.decode(data);
    //     if (!decoder.hasError() && content.contains('[') && content.contains(']')) {
    //         usedEncoding = encoding;
    //         return content;
    //     }
    // }

    // // 回退
    // usedEncoding = "UTF-8";
    // return QStringDecoder("UTF-8").decode(data);
}
bool LyricModel::loadLyricFile(const QString &filePath)
{
    beginResetModel();

    m_lyrics.clear();
    m_currentIndex = -1;
    m_progress = 0.0;

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        endResetModel();
        return false;
    }
    // 读取文件数据
    QByteArray fileData = file.readAll();
    file.close();

    // 使用QStringDecoder解码
    QString fileContent = decodeFileData(fileData);
    QStringList lines = fileContent.split('\n');

    QRegularExpression timeRegex("\\[(\\d+):(\\d+)[\\.\\:](\\d+)\\]");

    for (const QString& line : lines) {
        QString trimmedLine = line.trimmed();

        // 匹配时间标签和歌词
        QRegularExpressionMatchIterator matches = timeRegex.globalMatch(trimmedLine);

        if (matches.hasNext()) {
            // 获取最后一个匹配的时间标签
            QRegularExpressionMatch lastMatch;
            while (matches.hasNext()) {
                lastMatch = matches.next();
            }

            // 提取分钟、秒和可选的百分秒
            int minutes = lastMatch.captured(1).toInt();
            int seconds = lastMatch.captured(2).toInt();
            int hundredths = lastMatch.captured(3).isEmpty() ? 0 : lastMatch.captured(3).toInt();

            // 计算总毫秒数
            qint64 time = (minutes * 60 + seconds) * 1000 + hundredths * 10;

            // 提取歌词文本
            QString lyricText = trimmedLine.mid(lastMatch.capturedEnd()).trimmed();
            //qDebug()<<lyricText;
            if (!lyricText.isEmpty()) {
                m_lyrics.append({time, lyricText});
            }
        }
    }

    // 按时间排序
    std::sort(m_lyrics.begin(), m_lyrics.end(),
              [](const LyricLine &a, const LyricLine &b) {
                  return a.time < b.time;
              });

    file.close();
    endResetModel();
    emit currentIndexChanged();
    return true;
}

void LyricModel::setPosition(qint64 position)
{
    updateCurrentLyric(position);

}

void LyricModel::updateCurrentLyric(qint64 position)
{
    if (m_lyrics.isEmpty()) {
        if (m_currentIndex != -1) {
            m_currentIndex = -1;
            emit currentIndexChanged();
        }
        return;
    }

    // 查找当前歌词
    int newIndex = -1;
    for (int i = 0; i < m_lyrics.size(); ++i) {
        if (m_lyrics[i].time <= position) {
            newIndex = i;
        } else {
            break;
        }
    }

    // 如果索引发生变化，更新显示
    if (newIndex != m_currentIndex) {
        int oldIndex = m_currentIndex;
        m_currentIndex = newIndex;

        // 通知视图数据变化（为了高亮更新）
        if (oldIndex >= 0 && oldIndex < m_lyrics.size()) {
            QModelIndex oldModelIndex = createIndex(oldIndex, 0);
            emit dataChanged(oldModelIndex, oldModelIndex, {IsCurrentRole});
        }
        if (m_currentIndex >= 0 && m_currentIndex < m_lyrics.size()) {
            QModelIndex newModelIndex = createIndex(m_currentIndex, 0);
            emit dataChanged(newModelIndex, newModelIndex, {IsCurrentRole});
        }

        emit currentIndexChanged();
    }

    // 计算进度（用于动画效果）
    if (m_currentIndex >= 0 && m_currentIndex + 1 < m_lyrics.size()) {
        qint64 currentTime = m_lyrics[m_currentIndex].time;
        qint64 nextTime = m_lyrics[m_currentIndex + 1].time;

        if (nextTime > currentTime) {
            double newProgress = static_cast<double>(position - currentTime) /
                                 (nextTime - currentTime);
            if (qAbs(newProgress - m_progress) > 0.01) {
                m_progress = qBound(0.0, newProgress, 1.0);
                emit progressChanged();
            }
        }
    } else {
        if (m_progress != 0.0) {
            m_progress = 0.0;
            emit progressChanged();
        }
    }
}

int LyricModel::currentIndex() const
{
    return m_currentIndex;
}

double LyricModel::progress() const
{
    return m_progress;
}
