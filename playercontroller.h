#include <QObject>
#include <QStringList>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QFileDialog>
#include <QDir>
#include <QUrl>
#include <QVector>
#include <QMediaMetaData>
#include <QDebug>
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v1tag.h>
#include <taglib/id3v2tag.h>
#include <taglib/attachedpictureframe.h>
#include <taglib/oggfile.h>
#include <taglib/xiphcomment.h>
#include <taglib/vorbisfile.h>
#include <taglib/opusfile.h>
#include "musicmodel.h"
#include<QRandomGenerator>
#include"coverimageprovider.h"
class PlayerController : public QObject {
    Q_OBJECT

    // 暴露给QML的属性
    Q_PROPERTY(QString currentSong READ currentSong NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentArtist READ currentArtist NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentAlbum READ currentAlbum NOTIFY currentSongChanged)
    Q_PROPERTY(int currentPosition READ currentPosition WRITE setCurrentPosition NOTIFY positionChanged)
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(bool playing READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(float currentVolume READ currentVolume WRITE setCurrentVolume NOTIFY currentVolumeChanged)
    // Q_PROPERTY(MusicModel m_musicModel  READ musicList NOTIFY musicListChanged)
    Q_PROPERTY(MusicModel* musicList READ musicList CONSTANT)
    Q_PROPERTY(QString coverSource READ coverSource NOTIFY coverChanged)

public:
    static PlayerController* instance();
    enum PlayerState {
        StoppedState,
        PlayingState,
        PausedState,
        FadingInState,
        FadingOutState
    };
    Q_ENUM(PlayerState)
    QString currentSong() const;
    QString currentArtist() const;
    QString currentAlbum() const;
    int currentPosition() const;
    int duration() const;
    bool isPlaying() const;
    int currentIndex() const;
    MusicModel* musicList() const;
    CoverImageProvider* imageProvider() const;
    QString coverSource() const;
    float currentVolume()const;

    // 供QML调用的方法
    Q_INVOKABLE void setDirectory(const QString &dirPath,int type);
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void playSong(int index);
    Q_INVOKABLE void next(const QString &mode);
    Q_INVOKABLE void previous(const QString &mode);
    Q_INVOKABLE void setCover();

signals:
    void musicListChanged();
    void currentSongChanged();
    void positionChanged();
    void durationChanged();
    void playingChanged();
    void currentIndexChanged();
    void metaDataLoaded();
    void coverChanged();
    void currentVolumeChanged();
public slots:
    void setCurrentPosition(int position);
    void setCurrentVolume(float volume);
private:

    explicit PlayerController(QObject *parent = nullptr);
    ~PlayerController() = default;
    void scanMusicFiles(const QString &path);
    void loadMetaData();

    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;
    CoverImageProvider* m_imageProvider;
    MusicModel *m_musicModel;
    QString m_currentDirectory;
    QString playMode="ORDER";
    QString m_dirPath;
    float m_currentVolume = 0.5;
    int m_coverVersion = 0; // 用于强制刷新
    int m_currentIndex = -1;
    PlayerState m_state = StoppedState;
    qint64 m_fadeStartTime;
};
