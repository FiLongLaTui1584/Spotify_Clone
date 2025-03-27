import 'package:flutter/material.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'package:test_do_an/page/artist_info.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import 'package:palette_generator/palette_generator.dart';

class SongDetailPage extends StatefulWidget {
  @override
  _SongDetailPageState createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  final AudioPlayerManager _audioManager = AudioPlayerManager();
  double _currentTime = 0;
  double _totalDuration = 0;
  Color _lyricBoxColor = Colors.red;
  Color _textColor = Colors.white;
  List<MapEntry<String, String>> _lyricsList = [];
  int _currentLyricIndex = -1;
  final ScrollController _scrollController = ScrollController();
  List<double> _lineHeights = [];
  List<GlobalKey> _lineKeys = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
    _updateLyricBoxColor();
    _parseLyricsToList();
    _checkIfFavorite();
  }

  void _setupAudioListeners() {
    // Lấy tổng thời gian bài hát
    _totalDuration = _audioManager.audioPlayer.duration?.inSeconds.toDouble() ?? 196;
    // Lắng nghe vị trí phát nhạc
    _audioManager.audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _currentTime = position.inSeconds.toDouble();
          _updateCurrentLyricIndex();
        });
      }
    });
    // Lắng nghe thay đổi trạng thái (play/pause, skip bài)
    _audioManager.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _totalDuration = _audioManager.audioPlayer.duration?.inSeconds.toDouble() ?? 196;
          _updateLyricBoxColor();
          _parseLyricsToList();
          _checkIfFavorite();
        });
      }
    });
  }

  Future<void> _updateLyricBoxColor() async {
    if (_audioManager.currentSong != null) {
      final String avatarPath = _audioManager.currentSong!['avatar'] ?? 'assets/images/random.png';
      try {
        final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
          AssetImage(avatarPath),
          size: const Size(418, 418),
          maximumColorCount: 20,
        );

        Color dominantColor = paletteGenerator.dominantColor?.color ?? Colors.red;
        double luminance = dominantColor.computeLuminance();
        Color newTextColor = luminance < 0.5 ? Colors.white : Colors.black;

        setState(() {
          _lyricBoxColor = dominantColor;
          _textColor = newTextColor;
        });
      } catch (e) {
        print('Lỗi khi trích xuất màu: $e');
        setState(() {
          _lyricBoxColor = Colors.red;
          _textColor = Colors.white;
        });
      }
    }
  }

  // Parse lời bài hát từ JSON thành danh sách
  void _parseLyricsToList() {
    _lyricsList.clear();
    _lineKeys.clear();
    _lineHeights.clear();
    if (_audioManager.currentSong != null && _audioManager.currentSong!['lyrics'] != null) {
      print('Lyrics từ database: ${_audioManager.currentSong!['lyrics']}');
      try {
        Map<String, String> lyrics = Map<String, String>.from(jsonDecode(_audioManager.currentSong!['lyrics']));
        _lyricsList = lyrics.entries.toList();
        // Sắp xếp theo thời gian
        _lyricsList.sort((a, b) {
          int timeA = _parseTimeToSeconds(a.key);
          int timeB = _parseTimeToSeconds(b.key);
          return timeA.compareTo(timeB);
        });
        // Tạo GlobalKey cho từng dòng
        _lineKeys = List.generate(_lyricsList.length, (index) => GlobalKey());
        _lineHeights = List.filled(_lyricsList.length, 0.0, growable: true);
      } catch (e) {
        print('Lỗi khi parse lyrics: $e');
        _lyricsList.clear();
        _lyricsList.add(MapEntry("0:00", "Không có lời bài hát"));
        _lineKeys.clear();
        _lineKeys.add(GlobalKey());
        _lineHeights.clear();
        _lineHeights.add(0.0);
      }
    } else {
      print('Lyrics không tồn tại hoặc null');
      _lyricsList.clear();
      _lyricsList.add(MapEntry("0:00", "Không có lời bài hát"));
      _lineKeys.clear();
      _lineKeys.add(GlobalKey());
      _lineHeights.clear();
      _lineHeights.add(0.0);
    }
    setState(() {});
  }

  // Chuyển thời gian từ "mm:ss" thành giây
  int _parseTimeToSeconds(String time) {
    List<String> parts = time.split(':');
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
    return minutes * 60 + seconds;
  }

  // Cập nhật chỉ số câu hát đang phát
  void _updateCurrentLyricIndex() {
    int currentSeconds = _currentTime.toInt();
    int newIndex = -1;

    for (int i = 0; i < _lyricsList.length; i++) {
      int lyricTime = _parseTimeToSeconds(_lyricsList[i].key);
      if (currentSeconds >= lyricTime) {
        newIndex = i;
      } else {
        break;
      }
    }

    if (newIndex != _currentLyricIndex) {
      print('Cập nhật _currentLyricIndex: $newIndex');
      setState(() {
        _currentLyricIndex = newIndex;
      });
      if (_currentLyricIndex >= 0) {
        _scrollToCurrentLyric();
      }
    }
  }

  // Cuộn đến câu hát đang phát và căn giữa
  void _scrollToCurrentLyric() {
    if (_scrollController.hasClients && _currentLyricIndex >= 0) {
      // Kiểm tra xem chiều cao của dòng hiện tại đã được cập nhật chưa
      if (_currentLyricIndex >= _lineHeights.length || _lineHeights[_currentLyricIndex] <= 0.0) {
        // Nếu chưa cập nhật, đợi và thử lại sau
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCurrentLyric();
        });
        return;
      }

      // Tính vị trí cuộn
      double position = 0.0;
      for (int i = 0; i < _currentLyricIndex; i++) {
        position += _lineHeights[i] > 0.0 ? _lineHeights[i] : 50.0;
      }

      double viewportHeight = 200;
      double currentLineHeight = _lineHeights[_currentLyricIndex];

      // Căn giữa câu hát trong khung nhìn
      double adjustedPosition = position - (viewportHeight / 2) + (currentLineHeight / 2);

      // Đảm bảo không cuộn âm hoặc vượt quá giới hạn
      adjustedPosition = adjustedPosition.clamp(0.0, _scrollController.position.maxScrollExtent);

      _scrollController.animateTo(
        adjustedPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Hàm chuyển đổi giây thành phút:giây (mm:ss)
  String _formatDuration(double seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = (seconds % 60).toInt();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _rewind10Seconds() {
    double newTime = (_currentTime - 10).clamp(0, _totalDuration);
    _audioManager.audioPlayer.seek(Duration(seconds: newTime.toInt()));
    setState(() {
      _currentTime = newTime;
    });
  }

  void _skip10Seconds() {
    double newTime = (_currentTime + 10).clamp(0, _totalDuration);
    _audioManager.audioPlayer.seek(Duration(seconds: newTime.toInt()));
    setState(() {
      _currentTime = newTime;
    });
  }

  Future<void> _checkIfFavorite() async {
    int? userId = UserSession.currentUser?['id'];
    if (userId == null || _audioManager.currentSong == null) return;

    bool isFavorite = await DatabaseHelper.instance.isSongInFavoriteAlbum(
      userId,
      _audioManager.currentSong!['id'],
    );
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _toggleFavorite() async {
    int? userId = UserSession.currentUser?['id'];
    if (userId == null || _audioManager.currentSong == null) return;

    if (_isFavorite) {
      await DatabaseHelper.instance.removeSongFromFavoriteAlbum(
        userId,
        _audioManager.currentSong!['id'],
      );
      setState(() {
        _isFavorite = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa khỏi danh sách yêu thích')),
      );
    } else {
      await DatabaseHelper.instance.addSongToFavoriteAlbum(
        userId,
        _audioManager.currentSong!['id'],
      );
      setState(() {
        _isFavorite = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm vào danh sách yêu thích')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.expand_more, color: Colors.white, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _audioManager.currentSong?['title'] ?? 'NOLOVENOLIFE',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _audioManager.currentSong?['avatar'] ?? 'assets/images/random.png',
                  width: 418,
                  height: 418,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _audioManager.currentSong?['title'] ?? 'NOLOVENOLIFE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _audioManager.currentSong?['artist'] ?? 'HIEUTHUHAI',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 8),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _currentTime,
                      min: 0,
                      max: _totalDuration,
                      onChanged: (value) {
                        setState(() {
                          _currentTime = value;
                          _audioManager.audioPlayer.seek(Duration(seconds: value.toInt()));
                        });
                      },
                      activeColor: Color.fromARGB(166, 222, 219, 219),
                      inactiveColor: Color.fromARGB(255, 58, 56, 56),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_currentTime),
                          style: TextStyle(
                            color: Color.fromARGB(166, 222, 219, 219),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatDuration(_totalDuration),
                          style: TextStyle(
                            color: Color.fromARGB(166, 222, 219, 219),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.replay_10, color: Colors.white, size: 40),
                    onPressed: _rewind10Seconds,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: Colors.white, size: 50),
                    onPressed: _audioManager.currentIndex > 0 ? _audioManager.skipPrevious : null,
                  ),
                  IconButton(
                    icon: Icon(
                      _audioManager.isCompleted
                          ? Icons.replay
                          : _audioManager.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 80,
                    ),
                    onPressed: _audioManager.currentSong != null
                        ? (_audioManager.isCompleted
                            ? _audioManager.replaySong
                            : _audioManager.togglePlayPause)
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 50),
                    onPressed: _audioManager.currentIndex <
                            (_audioManager.currentSong != null ? _audioManager.currentIndex + 1 : 0)
                        ? _audioManager.skipNext
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10, color: Colors.white, size: 40),
                    onPressed: _skip10Seconds,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              width: MediaQuery.of(context).size.width - 30,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _lyricBoxColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bản xem trước lời bài hát",
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: 200,
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: _lyricsList.length,
                      itemBuilder: (context, index) {
                        // Đo chiều cao của dòng lyric
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final RenderBox? renderBox =
                              _lineKeys[index].currentContext?.findRenderObject() as RenderBox?;
                          if (renderBox != null && _lineHeights[index] != renderBox.size.height) {
                            setState(() {
                              _lineHeights[index] = renderBox.size.height;
                              // Gọi _scrollToCurrentLyric() ngay khi đo được chiều cao của dòng hiện tại
                              if (_currentLyricIndex >= 0 && _lineHeights[_currentLyricIndex] > 0.0) {
                                _scrollToCurrentLyric();
                              }
                            });
                          }
                        });

                        return Container(
                          key: _lineKeys[index],
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            _lyricsList[index].value,
                            style: TextStyle(
                              color: index == _currentLyricIndex
                                  ? _textColor
                                  : _textColor.withOpacity(0.5),
                              fontSize: 21,
                              fontWeight: index == _currentLyricIndex ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Người tham gia thực hiện",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildContributor(
                    _audioManager.currentSong?['artist'] ?? 'HIEUTHUHAI',
                    "Nghệ sĩ chính",
                    true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContributor(String name, String role, bool isFollowing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              Map<String, dynamic>? artist = await DatabaseHelper.instance.getArtistByName(name);
              if (artist != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistInfoPage(
                      artistId: artist['id'],
                      artistName: artist['name'],
                      artistAvatar: artist['avatar'] ?? 'assets/images/random.png',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Không tìm thấy thông tin nghệ sĩ')),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isFollowing)
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Đang theo dõi",
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}