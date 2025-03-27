import 'package:just_audio/just_audio.dart';
import 'package:test_do_an/helper/database_helper.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;
  AudioPlayerManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _songs = []; // Danh sách bài hát
  int _currentIndex = 0; // Chỉ số bài hát hiện tại
  bool _isPlaying = false;
  bool _isCompleted = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AudioPlayer get audioPlayer => _audioPlayer;
  Map<String, dynamic>? get currentSong =>
      _songs.isNotEmpty ? _songs[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  bool get isCompleted => _isCompleted;
  int get currentIndex => _currentIndex;

  Future<void> init() async {
    await _loadSongs();
    if (_songs.isNotEmpty) {
      await _loadSongAtIndex(_currentIndex);
    }
    _setupAudioPlayerListeners();
  }

  Future<void> _loadSongs() async {
    try {
      _songs = await _dbHelper.getAllSongs();
    } catch (e) {
      print('Lỗi khi tải danh sách bài hát: $e');
    }
  }

  Future<void> _loadSongAtIndex(int index) async {
    if (index >= 0 && index < _songs.length) {
      try {
        await _audioPlayer.setAsset(_songs[index]['filePath']);
        _currentIndex = index;
        if (_isPlaying) {
          _audioPlayer.play();
        }
      } catch (e) {
        print('Lỗi khi tải bài hát tại index $index: $e');
      }
    }
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _isCompleted = true;
        _isPlaying = false;
      } else {
        _isCompleted = false;
      }
    });
  }

  // Thêm hàm để phát bài hát theo id
  Future<void> playSongById(int songId) async {
    // Tìm bài hát trong danh sách _songs dựa trên id
    int? index = _songs.indexWhere((song) => song['id'] == songId);
    if (index != -1) {
      // Cập nhật _currentIndex và phát bài hát
      _currentIndex = index;
      await _loadSongAtIndex(_currentIndex);
      _audioPlayer.play(); // Phát bài hát ngay lập tức
      _isPlaying = true;
      _isCompleted = false;
    } else {
      print('Không tìm thấy bài hát với id: $songId');
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void replaySong() {
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();
    _isCompleted = false;
  }

  void skipNext() {
    if (_currentIndex < _songs.length - 1) {
      _currentIndex++;
      _loadSongAtIndex(_currentIndex);
    }
  }

  void skipPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _loadSongAtIndex(_currentIndex);
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
