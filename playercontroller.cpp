#include "playercontroller.h"

#include<qtimer.h>
// 对数插值函数
qreal logarithmicInterpolation(qreal start, qreal end, qreal t) {
    if (t <= 0.0) return start;
    if (t >= 1.0) return end;
    if (start <= 0.0 || end <= 0.0) {
        return start * (1 - t) + end * t;
    }

    qreal logStart = std::log(start);
    qreal logEnd = std::log(end);
    qreal interpolatedLog = logStart * (1 - t) + logEnd * t;

    return std::exp(interpolatedLog);
}
PlayerController* PlayerController::instance()
{
    static PlayerController* instance = nullptr;
    if(!instance){
        instance =new PlayerController();
    }
    return instance;
}
PlayerController::PlayerController(QObject *parent)
    : QObject(parent) {
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_player->setAudioOutput(m_audioOutput);
    m_musicModel =new MusicModel(this);
    m_lyricModel = new LyricModel(this);
    m_audioOutput->setVolume(0);
    // 连接信号
    connect(m_player, &QMediaPlayer::positionChanged, this, &PlayerController::positionChanged);
    connect(m_player, &QMediaPlayer::durationChanged, this, &PlayerController::durationChanged);
    connect(m_player, &QMediaPlayer::playbackStateChanged, this, [this]() {
        emit playingChanged();
    });
    connect(m_player,&QMediaPlayer::sourceChanged,this,[this](const QUrl &source){
        //qDebug()<<source.toString().replace(QRegularExpression("\\.(ogg|mp3)$"), ".lrc");
        m_lyricModel->loadLyricFile(source.toString().replace(QRegularExpression("\\.(ogg|mp3|opus|flac|m4a|mp4|ape|wav|aiff|aif)$"), ".lrc"));
    });
    // 媒体状态变化时加载元数据
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if (status == QMediaPlayer::LoadedMedia) {
            loadMetaData();
        }else if(status == QMediaPlayer::EndOfMedia) {
            next(playMode);
        }
    });
    // int fadeDuration = 2000;
    // QTimer *fadeInTimer = new QTimer(this);
    // fadeInTimer->setInterval(50);
    // connect(fadeInTimer,&QTimer::timeout,this,[this,fadeDuration,fadeInTimer](){

    //     qint64 elapsed = QDateTime::currentMSecsSinceEpoch()-m_fadeStartTime;
    //     qreal t = static_cast<qreal>(elapsed) / fadeDuration;
    //     //qDebug()<<elapsed;
    //     if(t>=1.0){
    //         fadeInTimer->stop();
    //         this->m_audioOutput->setVolume(m_currentVolume);
    //         m_state = PlayingState;
    //         return;
    //     }

    //     qreal volume = logarithmicInterpolation(0.001, m_currentVolume, t);
    //     m_audioOutput->setVolume(volume);
    // });


    // connect(m_player,&QMediaPlayer::playingChanged,this,[fadeInTimer,this](bool playing){
    //     if(playing){
    //         this->m_audioOutput->setVolume(0);
    //         fadeInTimer->start();
    //         m_fadeStartTime= QDateTime::currentMSecsSinceEpoch();
    //         //qDebug()<<"调用";
    //     }

    // });

}

void PlayerController::setDirectory(const QString &dirPath,int type) {
    QString path  = dirPath;
    if(dirPath.startsWith("file:///")){
        path = QUrl(dirPath).toLocalFile();
    }
    if (!path.isEmpty()) {
        if(type == 0){
            if(m_currentDirectory == path){
                return;
            }
            m_currentDirectory = path;
            scanMusicFiles(path);
        }else if(type ==1){
            m_currentDirectory = path;
            scanMusicFiles(path);
        }else if(type ==2){
            scanMusicFiles(m_currentDirectory);
        }
    }
}

void PlayerController::scanMusicFiles(const QString &path) {
    (void)QtConcurrent::run([this, path]() {
        QDir dir(path);
        QStringList files = dir.entryList({"*.mp3", "*.wav", "*.flac", "*.ogg"}, QDir::Files);
        //QFileInfoList files = dir.entryInfoList();
        m_musicModel->clear();
        for (auto &file : files) {
            qDebug()<<file;
            QString pathFile = path + "/" + file;


            #ifdef Q_OS_WIN
                        TagLib::FileRef fileRef(reinterpret_cast<const wchar_t*>(pathFile.utf16()));
            #else
                        TagLib::FileRef fileRef(pathFile.toUtf8().constData());
            #endif
            // 检查文件是否存在
            QFileInfo fileInfo(pathFile);
            if (!fileInfo.exists()) {
                qDebug() << "文件不存在:" << path;
                qDebug()<<"\n";
                continue;
            }

            // 检查文件是否可读
            if (!fileInfo.isReadable()) {
                qDebug() << "文件不可读:" << path;
                qDebug()<<"\n";
                continue;
            }
            if (fileRef.isNull()) {
                qDebug() << "无法打开文件";
                qDebug()<<"\n";
                continue;
            }
            // 动态检测并转换为具体的 OGG 类型
            if (auto* vorbisFile = dynamic_cast<TagLib::Ogg::Vorbis::File*>(fileRef.file())) {
                qDebug() << "检测到 OGG Vorbis 文件";
                if (vorbisFile->tag()) {
                    auto* xiph = vorbisFile->tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();
                    // 处理 Vorbis 标签...
                    const QString title =  QString::fromUtf8(xiph->title().toCString(true));
                    const QString artist = QString::fromUtf8(xiph->artist().toCString(true));
                    const QString album = QString::fromUtf8(xiph->album().toCString(true));
                    const int duration =  audioProperties->lengthInSeconds();
                    const QString size = QString::number(fileInfo.size());
                    // 在获取图片列表前添加检查
                    if (!vorbisFile || !xiph) {
                        qWarning() << "无效的文件指针";
                        return;
                    }
                     // 在主线程更新UI
                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration, pathFile, size]() {
                        MusicModel::MusicItem item{title, artist, album, duration, pathFile, size};
                        m_musicModel->addMusicItem(item);
                    });

                }
            }
            else if (auto* opusFile = dynamic_cast<TagLib::Ogg::Opus::File*>(fileRef.file())) {
                qDebug() << "检测到 OGG Opus 文件";
                if (opusFile->tag()) {
                    auto* xiph = opusFile->tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();

                    QString title = QString::fromUtf8(xiph->title().toCString(true));
                    QString artist = QString::fromUtf8(xiph->artist().toCString(true));
                    QString album = QString::fromUtf8(xiph->album().toCString(true));
                    // 如果标题为空，使用文件名
                    if (title.isEmpty()) {
                        title = fileInfo.completeBaseName();
                    }

                    // 如果艺术家为空，设为未知
                    if (artist.isEmpty()) {
                        artist = "未知艺术家";
                    }

                    // 如果专辑为空，设为未知
                    if (album.isEmpty()) {
                        album = "未知专辑";
                    }
                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());

                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });
                }
            }
            else if (auto* flacFile = dynamic_cast<TagLib::FLAC::File*>(fileRef.file())) {
                qDebug() << "检测到 FLAC 文件";
                if (flacFile->tag()) {
                    auto* tag = flacFile->tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();

                    QString title = QString::fromUtf8(tag->title().toCString(true));
                    QString artist = QString::fromUtf8(tag->artist().toCString(true));
                    QString album = QString::fromUtf8(tag->album().toCString(true));
                    // 如果标题为空，使用文件名
                    if (title.isEmpty()) {
                        title = fileInfo.completeBaseName();
                    }

                    // 如果艺术家为空，设为未知
                    if (artist.isEmpty()) {
                        artist = "未知艺术家";
                    }

                    // 如果专辑为空，设为未知
                    if (album.isEmpty()) {
                        album = "未知专辑";
                    }
                    const QString genre = QString::fromUtf8(tag->genre().toCString(true));
                    const QString comment = QString::fromUtf8(tag->comment().toCString(true));
                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());

                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });
                }
            }
            else if (auto* mp3File = dynamic_cast<TagLib::MPEG::File*>(fileRef.file())) {
                qDebug() << "检测到 MP3 文件";
                if (mp3File->tag()) {
                    auto* tag = mp3File->ID3v1Tag(true);
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();
                    QString title = QString::fromUtf8(tag->title().toCString(true));
                    QString artist = QString::fromUtf8(tag->artist().toCString(true));
                    QString album = QString::fromUtf8(tag->album().toCString(true));
                    // 如果标题为空，使用文件名
                    if (title.isEmpty()) {
                        title = fileInfo.completeBaseName();
                    }

                    // 如果艺术家为空，设为未知
                    if (artist.isEmpty()) {
                        artist = "未知艺术家";
                    }

                    // 如果专辑为空，设为未知
                    if (album.isEmpty()) {
                        album = "未知专辑";
                    }
                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());
                    qDebug()<<title<<artist<<album<<duration<<size;
                    qDebug()<<pathFile;
                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });

                }
            }
            else if (auto* m4aFile = dynamic_cast<TagLib::MP4::File*>(fileRef.file())) {
                qDebug() << "检测到 M4A/MP4 文件";
                if (m4aFile->tag()) {
                    auto* tag = m4aFile->tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();

                    // MP4 标签处理可能略有不同
                    const QString title = QString::fromUtf8(tag->title().toCString(true));
                    const QString artist = QString::fromUtf8(tag->artist().toCString(true));
                    const QString album = QString::fromUtf8(tag->album().toCString(true));
                    const QString genre = QString::fromUtf8(tag->genre().toCString(true));
                    const QString comment = QString::fromUtf8(tag->comment().toCString(true));

                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());

                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });
                }
            }
            else if (auto* apeFile = dynamic_cast<TagLib::APE::File*>(fileRef.file())) {
                qDebug() << "检测到 APE 文件";
                if (apeFile->tag()) {
                    auto* tag = apeFile->tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();

                    const QString title = QString::fromUtf8(tag->title().toCString(true));
                    const QString artist = QString::fromUtf8(tag->artist().toCString(true));
                    const QString album = QString::fromUtf8(tag->album().toCString(true));
                    const QString genre = QString::fromUtf8(tag->genre().toCString(true));
                    const QString comment = QString::fromUtf8(tag->comment().toCString(true));

                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());

                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });
                }
            }
            else if (auto* wavFile = dynamic_cast<TagLib::RIFF::WAV::File*>(fileRef.file())) {
                qDebug() << "检测到 WAV 文件";
                if (wavFile->tag()) {
                    auto* tag = wavFile->tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();

                    const QString title = QString::fromUtf8(tag->title().toCString(true));
                    const QString artist = QString::fromUtf8(tag->artist().toCString(true));
                    const QString album = QString::fromUtf8(tag->album().toCString(true));
                    const QString genre = QString::fromUtf8(tag->genre().toCString(true));
                    const QString comment = QString::fromUtf8(tag->comment().toCString(true));

                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());

                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });
                }
            }
            else {
                qDebug() << "未知或不支持的音乐文件格式:" << pathFile;
                // 可以尝试使用通用文件读取
                if (fileRef.tag()) {
                    auto* tag = fileRef.tag();
                    const TagLib::AudioProperties * audioProperties = fileRef.audioProperties();

                    const QString title = QString::fromUtf8(tag->title().toCString(true));
                    const QString artist = QString::fromUtf8(tag->artist().toCString(true));
                    const QString album = QString::fromUtf8(tag->album().toCString(true));
                    const int duration = audioProperties ? audioProperties->lengthInSeconds() : 0;
                    const QString size = QString::number(fileInfo.size());

                    QMetaObject::invokeMethod(this, [this, title, artist, album, duration,  pathFile, size]() {
                        MusicModel::MusicItem item{
                            title, artist, album,
                            duration,  pathFile, size
                        };
                        m_musicModel->addMusicItem(item);
                    });
                }
            }

        }
        // 扫描完成
        QMetaObject::invokeMethod(this, [this]() {
            emit musicListChanged();
            if (!m_musicModel->musicList().isEmpty()) {
                m_currentIndex = 0;
                emit currentIndexChanged();
                m_player->setSource(m_musicModel->musicList()[m_currentIndex].filePath);
            }
            emit scanFinished();
        });

    });
}

void PlayerController::loadMetaData() {
    if (m_currentIndex < 0 || m_currentIndex >= m_musicModel->musicList().size()) return;

    auto metaData = m_player->metaData();

    QString title = metaData.value(QMediaMetaData::Title).toString();
    if (!title.isEmpty()) {
        m_musicModel->musicList()[m_currentIndex].title = title;
    }

    QString artist = metaData.value(QMediaMetaData::Author).toString();
    if (artist.isEmpty()) {
        artist = metaData.value(QMediaMetaData::ContributingArtist).toString();
    }
    if (!artist.isEmpty()) {
        m_musicModel->musicList()[m_currentIndex].artist = artist;
    }

    QString album = metaData.value(QMediaMetaData::AlbumTitle).toString();
    if (!album.isEmpty()) {
        m_musicModel->musicList()[m_currentIndex].album = album;
    }

    emit metaDataLoaded();
    emit currentSongChanged();
}

void PlayerController::play() {

    m_player->play();
    // if(m_state == StoppedState||m_state == PausedState){
    //     if (m_currentIndex >= 0 && m_currentIndex < m_musicModel->musicList().size()) {

    //         m_player->play();
    //         m_state = FadingInState;
    //     }
    // }
}

void PlayerController::pause() {
    m_player->pause();


    // if(m_state!=PlayingState){
    //     return;
    // }
    // QTimer *fadeOutTimer = new QTimer(this);
    // fadeOutTimer->setInterval(50); // 每50毫秒更新一次
    // int fadeDuration = 2000;
    // connect(fadeOutTimer, &QTimer::timeout, this, [this, fadeDuration, fadeOutTimer]() {
    //     qint64 elapsed = QDateTime::currentMSecsSinceEpoch() - m_fadeStartTime;
    //     qreal t = static_cast<qreal>(elapsed) / fadeDuration;
    //     if (t >= 1.0) {
    //         fadeOutTimer->stop();
    //         this->m_audioOutput->setVolume(0.0); // 最终设置为0
    //         m_player->pause();
    //         m_state = PausedState;
    //         // 淡出完成后，可以停止播放等操作
    //         // 例如：this->stop();
    //         return;
    //     }
    //     // 使用对数插值计算当前音量（从startVolume到0.001）
    //     qreal volume = logarithmicInterpolation(m_currentVolume, 0.001, t);
    //     m_audioOutput->setVolume(volume);
    // });
    // m_fadeStartTime= QDateTime::currentMSecsSinceEpoch();
    // fadeOutTimer->start();
    // m_state = FadingOutState;

}

void PlayerController::stop() {
    m_player->stop();
}

void PlayerController::playSong(int index) {
    if (index >= 0 && index < m_musicModel->musicList().size()) {
        if (m_currentIndex != index) {
            m_currentIndex = index;
            emit currentIndexChanged();
            m_player->setSource(m_musicModel->musicList()[index].filePath);
        }
        m_player->play();
    }
}

void PlayerController::next(const QString&mode) {
    if (m_musicModel->musicList().isEmpty()) return;
    int nextIndex =0;
    playMode = mode;
    //qDebug()<<mode;
    if(mode =="ORDER"){
        nextIndex = (m_currentIndex + 1) %m_musicModel->musicList().size();
    }else if(mode =="LIST"){
        nextIndex = (m_currentIndex + 1) %m_musicModel->musicList().size();
    }else if(mode =="CIRCLE"){
        nextIndex = (m_currentIndex ) %m_musicModel->musicList().size();
    }else if(mode =="RANDOM"){
        nextIndex = QRandomGenerator::global()->bounded(0, m_musicModel->musicList().size());
    }
    playSong(nextIndex);
}

void PlayerController::previous(const QString&mode) {
    if (m_musicModel->musicList().isEmpty()) return;
    int prevIndex =0;
    //qDebug()<<mode;
    playMode = mode;
    if(mode =="ORDER"){
        prevIndex = (m_currentIndex - 1 + m_musicModel->musicList().size()) % m_musicModel->musicList().size();
    }else if(mode =="LIST"){
        prevIndex = (m_currentIndex - 1 + m_musicModel->musicList().size()) % m_musicModel->musicList().size();
    }else if(mode =="CIRCLE"){
        prevIndex = (m_currentIndex) % m_musicModel->musicList().size();
    }else if(mode =="RANDOM"){
        prevIndex = QRandomGenerator::global()->bounded(0, m_musicModel->musicList().size());
    }
    playSong(prevIndex);
}

void PlayerController::setCurrentVolume(float volume) {
    m_audioOutput->setVolume(volume);
    m_currentVolume = volume;
    emit currentVolumeChanged();
    //qDebug()<<"当前音量"<<this->m_currentVolume;
}
void PlayerController::setCover(){
    qDebug()<<"11";
    QVariant coverData = m_player->metaData().value(QMediaMetaData::CoverArtImage);
    qDebug()<<"11";
    if (!coverData.isValid()) {
        qDebug()<<"11";
        QImage image = coverData.value<QImage>();
        qDebug()<<image;
        m_imageProvider->setCoverImage(image);
        m_coverVersion++; // 增加版本号强制刷新
        emit coverChanged();
    }
    // qDebug()<<"11";
    // QVariant coverVariant = m_player->metaData().value(m_player->metaData().ThumbnailImage);
    // qDebug()<<"11";
    // /*这一步的类型转换跨度很大，displayer->metaData()返回QMediaMetaData类型，因此本身就可以作为QMediaMetaData对象，再使用QMediaMetaData::value()，其返回的是QVariant类，可以理解成存储不同数据的万能类，它可以转换成其他非常多的类型。value()需要传入对应key值才会返回你需要的元数据，key值等于QMediaMetaData中不同数据类型的关键字，现在我要提取出封面信息，关键字就是QMediaMetaData::ThumbnailImage(等同于displayer->metaData().ThumbnailImage)*/
    // if(coverVariant.canConvert<QImage>()){ //如果coverVariant可以转换成QImage类对象
    //     qDebug()<<"22";
    //     QImage coverImage = coverVariant.value<QImage>(); //将QVariant转换为QImage，此处也可以使用coverVariant.qvariant_cast<QImage>()函数
    //     qDebug()<<"33";
    //     m_imageProvider->setCoverImage(coverImage);
    //     m_coverVersion++; // 增加版本号强制刷新
    //     emit coverChanged();
    // }
}
CoverImageProvider* PlayerController::imageProvider() const {
    return m_imageProvider;
}


QString PlayerController::coverSource() const {
    return QString("image://cover/%1").arg(m_coverVersion);
}

// 属性实现
QString PlayerController::currentSong() const {
    if (m_currentIndex >= 0 && m_currentIndex < m_musicModel->musicList().size()) {
        return m_musicModel->musicList()[m_currentIndex].title;
    }
    return "";
}

QString PlayerController::currentArtist() const {
    if (m_currentIndex >= 0 && m_currentIndex < m_musicModel->musicList().size()) {
        return m_musicModel->musicList()[m_currentIndex].artist;
    }
    return "";
}

QString PlayerController::currentAlbum() const {
    if (m_currentIndex >= 0 && m_currentIndex < m_musicModel->musicList().size()) {
        return m_musicModel->musicList()[m_currentIndex].album;
    }
    return "";
}
float PlayerController:: currentVolume()const{
    return this->m_currentVolume;
}

int PlayerController::currentPosition() const {
    return m_player->position();
}

int PlayerController::duration() const {
    return m_player->duration();
}

bool PlayerController::isPlaying() const {
    return m_player->playbackState() == QMediaPlayer::PlayingState;
}

int PlayerController::currentIndex() const {
    return m_currentIndex;
}
MusicModel* PlayerController::musicList()const{
    return m_musicModel;
}
LyricModel*PlayerController:: lyricList() const{
    return m_lyricModel;
}

void PlayerController::setCurrentPosition(int position) {
    m_player->setPosition(position);
}
