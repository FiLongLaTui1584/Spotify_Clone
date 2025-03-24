import 'package:flutter/material.dart';
import 'package:test_do_an/page/song_detail.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:palette_generator/palette_generator.dart'; // Import palette_generator

class CustomMusicBar extends StatefulWidget {
  const CustomMusicBar({super.key});

  @override
  _CustomMusicBarState createState() => _CustomMusicBarState();
}

class _CustomMusicBarState extends State<CustomMusicBar> {
  final AudioPlayerManager _audioManager = AudioPlayerManager();
  Color _backgroundColor = const Color(0xFF1FD662); // Màu mặc định ban đầu
  Color _textColor = Colors.white; // Màu chữ mặc định
  Color _iconColor = Colors.white; // Màu icon mặc định

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi trạng thái từ AudioPlayerManager
    _audioManager.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _updateBackgroundColor(); // Cập nhật màu nền khi bài hát thay đổi
        });
      }
    });
    // Cập nhật màu nền ngay khi khởi tạo
    _updateBackgroundColor();
  }

  Future<void> _updateBackgroundColor() async {
    if (_audioManager.currentSong != null) {
      final String avatarPath =
          _audioManager.currentSong!['avatar'] ?? 'assets/images/random.png';
      try {
        // Trích xuất màu chủ đạo từ ảnh bìa
        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          AssetImage(avatarPath),
          size: const Size(50, 50), // Kích thước ảnh bìa
          maximumColorCount: 20, // Số lượng màu tối đa để phân tích
        );

        // Lấy màu chủ đạo (dominant color)
        Color dominantColor =
            paletteGenerator.dominantColor?.color ?? const Color(0xFF1FD662);

        // Tính độ sáng của màu nền để chọn màu chữ/icon phù hợp
        double luminance = dominantColor.computeLuminance();
        Color newTextColor = luminance < 0.5 ? Colors.white : Colors.black;
        Color newIconColor = luminance < 0.5 ? Colors.white : Colors.black;

        setState(() {
          _backgroundColor = dominantColor;
          _textColor = newTextColor;
          _iconColor = newIconColor;
        });
      } catch (e) {
        print('Lỗi khi trích xuất màu: $e');
        setState(() {
          _backgroundColor = const Color(0xFF1FD662); // Màu mặc định nếu lỗi
          _textColor = Colors.white;
          _iconColor = Colors.white;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                SongDetailPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: _backgroundColor
              .withOpacity(0.9), // Sử dụng màu trích xuất từ ảnh bìa
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: _audioManager.currentSong != null
                  ? Image.asset(
                      _audioManager.currentSong!['avatar'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _audioManager.currentSong?['title'] ?? 'Đang tải...',
                    style: TextStyle(
                      color: _textColor, // Màu chữ động
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    _audioManager.currentSong?['artist'] ?? 'Đang tải...',
                    style: TextStyle(
                      color: _textColor, // Màu chữ phụ
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: _iconColor, // Màu icon động
                size: 35,
              ),
              onPressed: _audioManager.currentIndex > 0
                  ? _audioManager.skipPrevious
                  : null,
            ),
            IconButton(
              icon: Icon(
                _audioManager.isCompleted
                    ? Icons.replay
                    : _audioManager.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                color: _iconColor, // Màu icon động
                size: 35,
              ),
              onPressed: _audioManager.currentSong != null
                  ? (_audioManager.isCompleted
                      ? _audioManager.replaySong
                      : _audioManager.togglePlayPause)
                  : null,
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: _iconColor, // Màu icon động
                size: 35,
              ),
              onPressed: _audioManager.currentIndex <
                      (_audioManager.currentSong != null
                          ? _audioManager.currentIndex + 1
                          : 0)
                  ? _audioManager.skipNext
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
